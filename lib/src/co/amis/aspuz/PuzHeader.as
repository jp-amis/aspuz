package co.amis.aspuz
{
	public class PuzHeader
	{
		private var _checksum:int;
		private var _fileMagic:String;
		private var _cibChecksum:String;
		
		private var _width:int;
		private var _height:int;
		
		public function PuzHeader(){}

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

		public function get cibChecksum():String
		{
			return _cibChecksum;
		}

		public function set cibChecksum(value:String):void
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