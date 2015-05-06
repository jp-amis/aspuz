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
			var output:String = "";
			var output2:String = "";
			var byte:uint;
			var j:uint=0;
			var clues:Array = new Array();
			var stringsCount:int = 0;
			for (var i:uint = this._stringStart; i < byteArray.length; i+=1) {
				byte = uint(byteArray[i]);
				//check if null string 
				if(byte == 0) {
					//go back and get all
					var arr:Array = new Array();
					j = i-1;
					while(uint(byteArray[j]) != 0 && j >= this._stringStart) {
						arr.push(String.fromCharCode(uint(byteArray[j])));
						j--;
					}
					arr.reverse();
					
					//clues
					if(stringsCount > 2){
						clues.push(arr.join(""));
						if(clues.length == this._header.numberOfClues) break;
					}
					
					
					stringsCount++;
				}
			}						
		}
	}
	
}