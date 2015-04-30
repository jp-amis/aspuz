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
		
		private var _rawSolution:String;
		
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
			this._stateStart = _solutionStart + _numberOfCells;
			
			// TODO Change variable name to just solution
			this._rawSolution = Aspuz.readByteArray(byteArray, this._solutionStart, "multiByte", this._numberOfCells);
			
			var line:String = "";
			for(var i:int = 0; i < this._rawSolution.length; i++) {				
				if(this._rawSolution.charAt(i) == ".") {
					line += "-";
				} else {
					line += this._rawSolution.charAt(i);
				}
				if(line.length == this._header.width) {					
					trace(line);
					line = "";
				}
			}
		}
	}
	
}