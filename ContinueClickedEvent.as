package  {
	import flash.events.Event;
	
	public class ContinueClickedEvent extends Event {

		public static const CONTINUE_CLICKED:String = "ContinueClickedEvent";

		public function ContinueClickedEvent(type:String=CONTINUE_CLICKED, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new ContinueClickedEvent(type,bubbles, cancelable);
		}

	}
	
}
