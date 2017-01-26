package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class startBt extends MovieClip {
		
		public function startBt() {
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
		}
		
		function MouseOut(e:MouseEvent):void
		{

			height = height/1.1;// - 10;
			width= width/1.1;// - 10;

		}
		function MouseOver(e:MouseEvent):void
		{

			height=height * 1.1;
			width=width * 1.1;
			
		}
	}
	
}
