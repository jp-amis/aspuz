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
		
	}
	
}