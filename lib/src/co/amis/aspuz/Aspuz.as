package co.amis.aspuz {
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class Aspuz {
		
		public function Aspuz() {}
		
		public static function readByteArray(byteArray:ByteArray, position:uint, type:String="string", length:uint=0x0, charset:String="iso-8859-1"):* {
			byteArray.position = position;
			 
			if(type == "short"){
				return byteArray.readShort();
			} else if(type == "utfBytes") {
				return byteArray.readUTFBytes(length);
			} else if(type == "int16") {
				return byteArray.readUnsignedInt().toString(16);
			} else if(type == "byte") {
				return byteArray.readByte();
			} else if(type == "unsignedByte") {
				return byteArray.readUnsignedByte();
			} else if(type == "multiByte") {
				return byteArray.readMultiByte(length, charset);
			}
			return null;
		}
		
		public static function parse(_file:File):Puz {
			var puz:Puz = new Puz(_file);
			puz.parse();			
			return puz;
		}				
	}
	
	
}