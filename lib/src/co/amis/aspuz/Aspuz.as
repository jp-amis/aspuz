package co.amis.aspuz {
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class Aspuz {
		
		public function Aspuz() {}
		
		public static function readByteArray(byteArray:ByteArray, offset:uint, length:uint, type:String="string"):* {
			byteArray.position = 0;
			var b:ByteArray = new ByteArray();
			byteArray.readBytes(b, offset, length); 
			if(type == "short"){
				return b.readUnsignedShort();
			}else if(type == "int8"){
				return b.readUnsignedInt();
			}else if(type == "string") {
				byteArray.position = offset;				
				return byteArray.readUTFBytes(length);
			}
			return null;
		}
		
		public static function parse(_file:File):Puz {
			var puz:Puz = new Puz();
			
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(_file, FileMode.READ);
			
			var byteArray:ByteArray = new ByteArray();
			fileStream.readBytes(byteArray);
			
			var contentString:String = byteArray.toString();					
			
//			var b:ByteArray = new ByteArray();
//			byteArray.readBytes(b, 0x00, 0x2);
			//Checksum
			byteArray.position = 0x00; 
			trace(byteArray.readShort());
			//filemagic
			byteArray.position = 0x02;
			trace(byteArray.readUTFBytes(0xC));
			//CIB Checksum
			byteArray.position = 0x0E;
			trace(byteArray.readShort());
			//Masked Low Checksums
			byteArray.position = 0x10;
			trace(byteArray.readUnsignedInt().toString(16));
			//Masked High Checksums
			byteArray.position = 0x14;
			trace(byteArray.readUnsignedInt().toString(16));
			//Version String(?)
			byteArray.position = 0x18;
			trace(byteArray.readUTFBytes(0x4));
			//Reserved1C
			byteArray.position = 0x1C;
			trace(byteArray.readUTFBytes(0x2));
			//Scrambled Checksum
			byteArray.position = 0x1E;
			trace(byteArray.readShort() != 0);
			//Reserved20
			byteArray.position = 0x20;
			trace(byteArray.readUTFBytes(0xC));
			//Width
			byteArray.position = 0x2C;
			trace(byteArray.readByte());
			//Height
			byteArray.position = 0x2D;
			trace(byteArray.readByte());			
			//number of clues
			byteArray.position = 0x2E;
			trace(byteArray.readUnsignedByte());
			//Unknown Bitmask
			byteArray.position = 0x30;
			trace(byteArray.readUnsignedByte());								
			//Scrambled Tag
			byteArray.position = 0x32;
			trace(byteArray.readUnsignedByte());
			
//			var cells:int = width * height;
//			var solutionStart:int = 0x34;
//			var stateStart:int = solutionStart + cells;
			
//			puz.header.checksum = Aspuz.readByteArray(byteArray, 0x00, 0x2, 'short');
//			trace(puz.header.checksum);
//			puz.header.fileMagic = Aspuz.readByteArray(byteArray, 0x02, 0xC, 'string');
//			trace(puz.header.fileMagic);
//			puz.header.cibChecksum = Aspuz.readByteArray(byteArray, 0x0E, 0x2, 'string');
//			trace(puz.header.cibChecksum);
//			
//			byteArray.position = 45;
//			trace(byteArray.readUTFBytes(1));
//			puz.header.width = Aspuz.readByteArray(byteArray, 0x2C, 0x1, 'int8');
//			puz.header.height = Aspuz.readByteArray(byteArray, 0x2D, 0x1, 'int8');
//			trace(puz.header.width, puz.header.height);			
//			trace(contentString);
//			contentString.
			
			return puz;
		}
		
		public static function encodeUTF8 (text:String):String {
			    var a:uint, n:uint, A:uint;
			    var utf:String;
			    utf = "";
			    A = text.length;
			 
			    for (a = 0; a < A; a++) {
				        n = text.charCodeAt (a);
				        if (n < 128) {
					            utf += String.fromCharCode (n);
				        } else if ((n > 127) && (n < 2048)) {
					            utf += String.fromCharCode ((n >> 6) | 192);
					            utf += String.fromCharCode ((n & 63) | 128);
				        } else {
					            utf += String.fromCharCode ((n >> 12) | 224);
					            utf += String.fromCharCode (((n >> 6) & 63) | 128);
					            utf += String.fromCharCode ((n & 63) | 128);
				        }
			    }
			    return utf;
		}
	}
	
	
}