package  {
	
	import flash.display.MovieClip;
	import fl.controls.CheckBox;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.Font;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	
	
	public class ContinueNextLevelPage extends MovieClip {
		
		[Embed(source="/BHoma.ttf", fontName = "bhoma", mimeType = "application/x-font", advancedAntiAliasing="true", embedAsCFF="true")]
		private var BHoma:Class;
		private var selectedStrategies:Array = new Array();
		private var partNum:int;
		private var userEmail:String;
		
		public function ContinueNextLevelPage(_partNum:int, _userEmail:String) {
			
			var stList:Array = Strategies.getStrategies();
			var tf:TextFormat = createTextFormat();
			this.partNum = _partNum;
			this.userEmail = _userEmail;
			
			for(var i = 0; i < stList.length; i++) {
				var cb:CheckBox = new CheckBox();
				cb.label = stList[i];
				cb.y = 50*(i+1) + 140;
				cb.x = -220;
				cb.setSize(1000, 30);
				cb.setStyle("textFormat", tf);
				cb.addEventListener(MouseEvent.CLICK, onOptionClicked);
				//cb.textField.multiline = true;
				//cb.textField.wordWrap = true;
				//cb.textField.width = 700;
				//cb.setStyle("embedFonts", true);
				//cb.setStyle("defaultTextFormat", tf);
				cb.labelPlacement = "left";
				addChild(cb);
			}
			
			var continueBtn:ContinueBtn = new ContinueBtn();
			continueBtn.y = (600 - continueBtn.height)/2 + 150;
			continueBtn.x = (700 - continueBtn.width)/2 + 20;
			continueBtn.addEventListener(MouseEvent.CLICK, onContinueClicked);
			addChild(continueBtn);
		}
		
		private function createTextFormat():TextFormat {
			var tf:TextFormat = new TextFormat();
			tf.size = 20;
			tf.font = "B Homa";
			tf.align = TextFormatAlign.RIGHT;
			
			//Font.registerFont(BHoma);
			return tf;
		}
		
		private function onOptionClicked(e:Event):void {
			var cb:CheckBox = CheckBox(e.target);
			var idx:int = Strategies.getIdx(cb.label);
			if(cb.selected) {
				if(selectedStrategies.indexOf(idx) < 0) {
					selectedStrategies.push(idx);
				}
			} else {
				if(selectedStrategies.indexOf(idx) >= 0) {
					selectedStrategies.splice(selectedStrategies.indexOf(idx), 1);
				}
			}
		}
		
		private function onContinueClicked(e:Event):void {
			var vars: URLVariables = new URLVariables();
			vars.strategies   = this.selectedStrategies.toString();
			vars.playerEmail = this.userEmail;
			vars.partId = this.partNum;
			
			var req: URLRequest = new URLRequest();
			req.method      = URLRequestMethod.POST;
			req.data        = vars;
			req.url         = "http://127.0.0.1:5000/addStrategies";

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onDataSent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(req);
		}
		
		private function onDataSent(e:Event):void {
			trace("data sent successfully response: " + e.target.data);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			trace("IO Error!! " + e.text);
		}
	}
	
}
