package
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	import co.amis.aspuz.Aspuz;
	
	public class notsotest extends Sprite
	{
		public function notsotest() {
			init();
		}
		
		private function init():void {
			// Loop the files and get the ones with .puz extension to test
			var appDirectory:File = File.applicationDirectory;
			var files:Array = appDirectory.getDirectoryListing();
			
			var passed:Boolean = true;
			
			for (var i:uint = 0; i < files.length; i++)
			{				
				if(files[i].extension == "puz") {
					trace("TESTING "+files[i].name+" :: :: :: :: ::");
					Aspuz.parse(files[i] as File);
					trace("PASSED "+passed);
					trace("");
				}								
			}
		}
	}
}