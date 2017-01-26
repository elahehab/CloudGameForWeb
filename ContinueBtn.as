package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class ContinueBtn extends MovieClip {
		
		
		public function ContinueBtn() {
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
			addEventListener(MouseEvent.CLICK, MouseClick);
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
		
		function MouseClick(e:MouseEvent):void {
			dispatchEvent(new ContinueClickedEvent());
		}
	}
	
}
