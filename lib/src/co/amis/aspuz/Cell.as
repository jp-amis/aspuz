package co.amis.aspuz {
	
	public class Cell {
		
		public static const TYPE_LETTER:String = "letter"; 
		public static const TYPE_BLACK:String = "black";
		
		private var _x:int;
		private var _y:int;		
		private var _type:String;
		private var _letter:String;
		private var _state:String;
		
		public function Cell(x:int, y:int, type:String, letter:String=null, state:String=null) {
			this._x = x;
			this._y = y;
			this._type = type;
			this._letter = letter;
			this._state = state;
		}
		
		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			_state = value;
		}

		public function get letter():String
		{
			return _letter;
		}

		public function set letter(value:String):void
		{
			_letter = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

	}
	
}