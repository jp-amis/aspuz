package co.amis.aspuz
{
	public class PuzHeader
	{
		private var _checksum:int;
		private var _fileMagic:String;
		
		private var _cibChecksum:int;
		private var _maskedLowChecksums:String;
		private var _maskedHighChecksums:String;
		
		private var _versionString:String;
		private var _reserved1C:String;
		private var _scrambledChecksum:Boolean;
		private var _reserved20:String;		
		private var _width:int;
		private var _height:int;
		private var _numberOfClues:uint;
		private var _unknownBitmask:uint;
		private var _scrambledTag:uint;
		
		public function PuzHeader(){}

		public function get scrambledTag():uint
		{
			return _scrambledTag;
		}

		public function set scrambledTag(value:uint):void
		{
			_scrambledTag = value;
		}

		public function get unknownBitmask():uint
		{
			return _unknownBitmask;
		}

		public function set unknownBitmask(value:uint):void
		{
			_unknownBitmask = value;
		}

		public function get numberOfClues():uint
		{
			return _numberOfClues;
		}

		public function set numberOfClues(value:uint):void
		{
			_numberOfClues = value;
		}

		public function get reserved20():String
		{
			return _reserved20;
		}

		public function set reserved20(value:String):void
		{
			_reserved20 = value;
		}

		public function get scrambledChecksum():Boolean
		{
			return _scrambledChecksum;
		}

		public function set scrambledChecksum(value:Boolean):void
		{
			_scrambledChecksum = value;
		}

		public function get reserved1C():String
		{
			return _reserved1C;
		}

		public function set reserved1C(value:String):void
		{
			_reserved1C = value;
		}

		public function get versionString():String
		{
			return _versionString;
		}

		public function set versionString(value:String):void
		{
			_versionString = value;
		}

		public function get maskedHighChecksums():String
		{
			return _maskedHighChecksums;
		}

		public function set maskedHighChecksums(value:String):void
		{
			_maskedHighChecksums = value;
		}

		public function get maskedLowChecksums():String
		{
			return _maskedLowChecksums;
		}

		public function set maskedLowChecksums(value:String):void
		{
			_maskedLowChecksums = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get cibChecksum():int
		{
			return _cibChecksum;
		}

		public function set cibChecksum(value:int):void
		{
			_cibChecksum = value;
		}

		public function get fileMagic():String
		{
			return _fileMagic;
		}

		public function set fileMagic(value:String):void
		{
			_fileMagic = value;
		}

		public function get checksum():int
		{
			return _checksum;
		}

		public function set checksum(value:int):void
		{
			_checksum = value;
		}

	}
}