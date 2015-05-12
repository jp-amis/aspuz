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
		
	}
	
}