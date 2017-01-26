package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class MozahemBirds extends MovieClip {
		
		
		public function MozahemBirds() {
			// constructor code
			addEventListener(Event.ENTER_FRAME,loop);
		}
		public function loop(e:Event):void
		{
			x-=5;
			y-=1;
		}
	}
	
}
