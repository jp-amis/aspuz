package co.amis.aspuz {
	
	public class Clue {
		
		public static const HORIZONTAL:String = "horizontal"; 
		public static const VERTICAL:String = "vertical";
		
		private var _number:int;
		private var _x:int;
		private var _y:int;
		private var _direction:String;
		private var _value:String;
		private var _size:int;
		
		public function Clue(number:int, x:int, y:int, direction:String, value:String, size:int) {
			this._number = number;
			this._x = x;
			this._y = y;
			this._direction = direction;
			this._value = value;					
			this._size = size;
		}
		
		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}

		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get number():int
		{
			return _number;
		}

		public function set number(value:int):void
		{
			_number = value;
		}

	}
	
}