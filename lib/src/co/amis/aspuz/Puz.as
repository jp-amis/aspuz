package co.amis.aspuz {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class Puz {
		
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
		
		public function get cells():Vector.<Cell>
		{
			return _cells;
		}

		public function set cells(value:Vector.<Cell>):void
		{
			_cells = value;
		}

		public function get header():PuzHeader
		{
			return _header;
		}

		public function set header(value:PuzHeader):void
		{
			_header = value;
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
		
//			loop all the strings
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
			var blackCell:Boolean;
			var currentCellNumber:int = 1;
			var currentClue:int = 0;
			var isNumberAssigned:Boolean;
			var needsDownNumber:Boolean;
			var needsAcrossNumber:Boolean;
			for( y ; y < this._header.height; y++ ) {
				for( x ; x < this._header.width; x++ ) {
					blackCell = this.isBlackCell(x, y);
					this._cells.push(new Cell(x, y, this.isBlackCell(x, y) ? Cell.TYPE_BLACK : Cell.TYPE_LETTER, this.getLetter(x, y), this.getLetterState(x, y)));
					
//					if it's a black cell there is no need to keep checking
					if(blackCell) 
						continue;
					
					isNumberAssigned = false;
					
					needsAcrossNumber = cellNeedsAcrossNumber(x, y);
					needsDownNumber = cellNeedsDownNumber(x, y);
					
					if(needsAcrossNumber) {
						isNumberAssigned = true;	
						
						this._clues.push(new Clue(currentCellNumber, x, y, Clue.HORIZONTAL, clues[currentClue], this.getNumberOfLetters(x, y, Clue.HORIZONTAL)));
						
						currentClue++;
					}
					
					if(needsDownNumber) {
						isNumberAssigned = true;
						
						this._clues.push(new Clue(currentCellNumber, x, y, Clue.VERTICAL, clues[currentClue], this.getNumberOfLetters(x, y, Clue.VERTICAL)));
						
						currentClue++;
					}
					
					if(isNumberAssigned) currentCellNumber++;
				}
				x = 0;
			}
		}
		
		private function cellNeedsAcrossNumber(x:int, y:int):Boolean {
			if( x == 0 || this.isBlackCell(x-1, y) )
				if( x + 1 < this._header.width && !this.isBlackCell(x+1, y) )
					return true;
			return false;
		}
		
		private function cellNeedsDownNumber(x:int, y:int):Boolean {
			if( y == 0 || this.isBlackCell(x, y-1) )
				if( y + 1 < this._header.height && !this.isBlackCell(x, y+1) )
					return true;
			return false;
		}		
			
		private function isBlackCell(x:int, y:int):Boolean {
			var pos:int = (this._header.width * y) + x;
			return pos >= 0 ? this._solution.charAt(pos) == "." : false;
		}
		
		private function getLetter(x:int, y:int):String {
			var pos:int = (this._header.width * y) + x;
			return pos >= 0 ? this._solution.charAt(pos) : null;
		}
		
		private function getLetterState(x:int, y:int):String {
			var pos:int = (this._header.width * y) + x;
			return pos >= 0 ? this._state.charAt(pos) : null;
		}
		
		private function getNumberOfLetters(x:int, y:int, direction:String):int {
			var size:int = 0;
			
			if(direction == Clue.HORIZONTAL) {
				while (x < this._header.width && !this.isBlackCell(x, y)) {
					size++; 
					x++;
				}
			} else if(direction == Clue.VERTICAL) {
				while (y < this._header.height && !this.isBlackCell(x, y)) {
					size++; 
					y++;
				}
			}
			
			return size;
		}
	}
	
}