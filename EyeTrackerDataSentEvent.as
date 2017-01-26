package  {
	import flash.events.Event;
	
	public class EyeTrackerDataSentEvent extends Event {

		public static const EYE_TRACKER_DATA:String = "EyeTrackerData";
		public var recordTime:Number;
		public var eye_x:Number;
		public var eye_y:Number;

		public function EyeTrackerDataSentEvent(_time:Number, _eye_x:Number, _eye_y:Number, type:String=EYE_TRACKER_DATA, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.recordTime = _time;
			this.eye_x = _eye_x;
			this.eye_y = _eye_y;
		}
		
		public override function clone():Event
		{
			return new EyeTrackerDataSentEvent(this.recordTime, this.eye_x, this.eye_y, type,bubbles, cancelable);
		}

	}
	
}
