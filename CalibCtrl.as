package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.net.Socket;
	
	
	public class CalibCtrl extends MovieClip {
		
		private var gameTimer:Timer = new Timer(1000, 2000);
		private var startCalibTime:Number;
		private var socket:Socket;
		
		public function CalibCtrl() {
			
			var calibBt:CalibBt = new CalibBt();
			calibBt.x = 400;
			calibBt.y = 300;
			addChild(calibBt);
			calibBt.addEventListener(MouseEvent.CLICK, onCalibClicked);
		}
		
		private function onCalibClicked(e:MouseEvent):void {
			gameTimer.start();
			startCalibTime = getTimer();
			startCalibrate();
		}
		
		private function startCalibrate():void
		{
			socket = new Socket();
			//Security.allowDomain("*");
			//Security.allowInsecureDomain("*");
			socket.addEventListener(Event.CONNECT, onSocketConnect);
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onResponse);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecError);
			
			socket.connect("localhost", 4242);
		}
		
		private function onSocketConnect(e:Event):void
		{
			trace("socket is connected...");
			socket.writeUTFBytes("<SET ID=\"CALIBRATE_SHOW\" STATE=\"1\" />\r\n");
			socket.writeUTFBytes("<SET ID=\"CALIBRATE_START\" STATE=\"1\" />\r\n");
			MovieClip(this.root).nextScene();
		}
		
		private function onError(e:IOErrorEvent):void {
			trace("IO Error: "+e);
		}
		
		private function onSecError(e:SecurityErrorEvent):void {
			trace("Security Error: "+e);
		}
		
		private function onClose(e:Event):void {
			// Security error is thrown if this line is excluded
			socket.close();
		}
		
		private function onResponse(e:ProgressEvent):void {
			while (socket.bytesAvailable > 0) {
				var res:String = socket.readUTFBytes(socket.bytesAvailable);
				trace("res: " + res);
			}
		}
	}
	
}
