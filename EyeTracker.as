package  {
	import flash.net.Socket;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.system.Security;
	import flash.display.MovieClip;
	
	public class EyeTracker extends MovieClip {

		private var points:Array = new Array();
		private var socket:Socket;
		private var timer:Timer = new Timer(1000, 2000);
		private var startOfTrack:Number;
		private var recordEnabled:Boolean = true;
		
		public function EyeTracker() {
			
		}
		
		public function startTrack():void {
			timer.start();
			startOfTrack = getTimer();
			if(socket != null && socket.connected == true)
			{
				socket.close();
			}
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onSocketConnectGetData);
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onResponse);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecError);
			
			socket.connect("localhost", 4242);
		}
		
		private function onSocketConnectGetData(e:Event):void
		{
			socket.writeUTFBytes("<SET ID=\"ENABLE_SEND_DATA\" STATE=\"1\" />");
			socket.writeUTFBytes("\r\n");
			socket.writeUTFBytes("<SET ID=\"ENABLE_SEND_POG_BEST\" STATE=\"1\" />");
			socket.writeUTFBytes("\r\n");
			trace("request is sent...");
		}
		
		private function onError(e:IOErrorEvent):void {
			trace("Eye Tracker IO Error: "+e);
		}
		
		private function onSecError(e:SecurityErrorEvent):void {
			trace("Security Error: "+e);
		}
		
		private function onClose(e:Event):void {
			socket.close();
		}
		
		private function onResponse(e:ProgressEvent):void {
			while (socket.bytesAvailable > 0) {
				var res:String = socket.readUTFBytes(socket.bytesAvailable);
				if(res.indexOf("REC") > 0) {
					var time = (getTimer() - startOfTrack);
					if(this.recordEnabled) {
						var val:String = res + "\"" + time + "\"";
						points.push(val);
						var pointSpecs:Array = parsPoint(val);
						dispatchEvent(new EyeTrackerDataSentEvent(pointSpecs[2], pointSpecs[0], pointSpecs[1]));
					}
				}
			}
		}
		
		private function parsData():Array 
		{
			var pointsRes:Array = new Array();
			for(var i = 0; i < points.length; i++) {
				pointsRes.push(parsPoint(points[i]));;
			}
			return pointsRes;
		}
		
		private function parsPoint(pointStr:String):Array {
			var res:Array = pointStr.split("\"");

			var eye_x:Number = Number(res[1]);
			var eye_y:Number = Number(res[3]);
			var time:Number = Number(res[7]);
			
			return [eye_x, eye_y, time];
		}
		
		public function disableRecord():void {
			this.recordEnabled = false;
		}
		
		public function enableRecord():void {
			this.recordEnabled = true;
		}
		
		public function getResultPoints():Array {
			return parsData();
		}

	}
	
}
