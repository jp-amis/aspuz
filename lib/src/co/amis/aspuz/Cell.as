package co.amis.aspuz {
	
	public class Cell {
		
		public static const TYPE_LETTER:String = "letter"; 
		public static const TYPE_BLACK:String = "black";
		
		private var _x:int;
		private var _y:int;
		private var _letter:String;
		private var _type:String;		
		
		public function Cell(x:int, y:int, type:String, letter:String=null) {
			this._type = type;
		}
		
	}
	
}