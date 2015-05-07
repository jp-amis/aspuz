package co.amis.aspuz {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	internal class Puz {
		
		private var _file:File;
		private var _header:PuzHeader = new PuzHeader();
		private var _numberOfCells:int = 0;
		
		private var _solutionStart:uint = 0x34;
		private var _stateStart:uint;
		private var _stringStart:uint;
		
		private var _solution:String;
		private var _state:String;
		
		private var _title:String;
		private var _author:String;
		private var _copyright:String;
		
		private var _clues:Vector.<Clue> = new Vector.<Clue>();
		private var _cells:Vector.<Cell> = new Vector.<Cell>();
		
		public function Puz(file:File) {
			_file = file;
		}
		
		public function parse():void {
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(_file, FileMode.READ);
			
			var byteArray:ByteArray = new ByteArray();
			fileStream.readBytes(byteArray);
			
			this._header.checksum = Aspuz.readByteArray(byteArray, 0x00, 'short');
			this._header.fileMagic = Aspuz.readByteArray(byteArray, 0x02, 'utfBytes', 0xC);
			
			this._header.cibChecksum = Aspuz.readByteArray(byteArray, 0x0E, 'short');						
			this._header.maskedLowChecksums = Aspuz.readByteArray(byteArray, 0x10, 'int16');
			this._header.maskedHighChecksums = Aspuz.readByteArray(byteArray, 0x14, 'int16');
			
			this._header.versionString = Aspuz.readByteArray(byteArray, 0x18, 'utfBytes', 0x4);
			this._header.reserved1C = Aspuz.readByteArray(byteArray, 0x1C, 'utfBytes', 0x2);
			this._header.scrambledChecksum = Aspuz.readByteArray(byteArray, 0x1E, 'short') != 0;
			this._header.reserved20 = Aspuz.readByteArray(byteArray, 0x20, 'utfBytes', 0x20);
			this._header.width = Aspuz.readByteArray(byteArray, 0x2C, 'byte');
			this._header.height = Aspuz.readByteArray(byteArray, 0x2D, 'byte');
			this._header.numberOfClues = Aspuz.readByteArray(byteArray, 0x2E, 'unsignedByte');
			this._header.unknownBitmask = Aspuz.readByteArray(byteArray, 0x30, 'unsignedByte');
			this._header.scrambledTag = Aspuz.readByteArray(byteArray, 0x32, 'unsignedByte');
			
			this._numberOfCells = this._header.width * this._header.height;			
			this._stateStart = this._solutionStart + this._numberOfCells;
			
			this._solution = Aspuz.readByteArray(byteArray, this._solutionStart, "multiByte", this._numberOfCells);
			this._state = Aspuz.readByteArray(byteArray, this._stateStart, "multiByte", this._numberOfCells);
			
			this._stringStart = this._stateStart + this._numberOfCells;
			
			var byte:uint;
			var byteLength:uint = byteArray.length;
			var j:int=0, i:int;
			var stringsCount:int = 0;
			var lastBytes:Array = new Array();			
			
			var clues:Vector.<String> = new Vector.<String>();
		
			//loop all the strings
			for ( i = this._stringStart; i < byteLength ; i++) {
				byte = uint(byteArray[i]);
//				check if null byte
				if(byte == 0) {
					// go back and get all bytes until last null byte
					lastBytes.length = 0;
					j = i-1;
					while(uint(byteArray[j]) != 0 && j >= this._stringStart) {
						lastBytes.push(String.fromCharCode(uint(byteArray[j])));
						j--;
					}
					lastBytes.reverse();
					
					if(stringsCount == 0) this._title = lastBytes.join("");
					else if(stringsCount == 1) this._author = lastBytes.join("");
					else if(stringsCount == 2) this._copyright = lastBytes.join("");
					else {
//						clues						
						clues.push(lastBytes.join(""));
						if(clues.length == this._header.numberOfClues) break;												
					}
					
					stringsCount++;
				}
			}
			
//			loop every cell and process it
//			loop every X cell then Y++
			var y:int = 0;
			var x:int = 0;
			
			for( y ; y < this._header.height; y++ ) {
				for( x ; x < this._header.width; x++ ) {
					this._cells.push(new Cell(x, y, this.isBlackCell(x, y) ? Cell.TYPE_BLACK : Cell.TYPE_LETTER, this.getLetter(x, y)));				
				}
				x = 0;
			}
			trace(this._cells);
		}
		
		private function isBlackCell(x:int, y:int):Boolean {
			var pos:int = (this._header.width * y) + x;
			return pos >= 0 ? this._solution.charAt(pos) == "." : false;
		}
		
		private function getLetter(x:int, y:int):String {
			var pos:int = (this._header.width * y) + x;
			return pos >= 0 ? this._solution.charAt(pos) : null;
		}
	}
	
}