package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.events.IOErrorEvent;
	
	public class level extends MovieClip {
		
		var vecAbrNormal:Array = new Array();
		var vecAbrRainy:Array = new Array();
		var count:int = 0;
		var ansTime:int = 0;
		var numTrue:int = 0;
		var numClicked:int = 0;
		var timer:Timer = new Timer(1000);
		var levInfo:levelInfo = new levelInfo();
		var numCoin:int = 0;
		var m_score:int = 0;
		var m_answerTime:int = 0;
		var mouseMovement:Array = new Array();
		var rainyCloudsMovement:Array = new Array();
		var allDataArr:Array = new Array();
		private var eyeTracker:EyeTracker = new EyeTracker();
		private var intervalId:int;
		
		private var m_speed:Number = 0;
		private var m_shetabKondShavande:Number = 0;
		private var numNormalAbr:int = 0;
		private var numRainyAbr:int = 0;
		private var startTime:int = 0;
		private var m_startTime:int = 0;
		private var m_distructorType:int;
		var m_ctrl:ctrl = null;
		public var distributionType:int = 0;/* 1-fullScreen 2-UpLEft 3-UpRight 4-DownLeft 5-DownRight 
											 6-UP 7-Down 8-Right 9-Left*/
		
		public function level(_numNormalAbr:int,_numRainyAbr:int,_m_speed:Number,_ctrl:ctrl,
							  _m_shetabKondShavande:Number,_m_maxGradian:Number,_m_changeGRadianTime,
							  _m_distructorType:int,_distributionType:int/* 1-fullScreen 2-UpLEft 3-UpRight 4-DownLeft 5-DownRight*/) {
			
			distributionType = _distributionType;
			m_ctrl = _ctrl;
			_ctrl.maxGradian = _m_maxGradian;
			_ctrl.countChangeGradian = _m_changeGRadianTime;
			m_distructorType = _m_distructorType;
			
			m_startTime = m_ctrl.m_count;
			startTime = m_ctrl.m_count;
			numNormalAbr = _numNormalAbr;
			numRainyAbr = _numRainyAbr;	
			m_shetabKondShavande = _m_shetabKondShavande;
			
			m_speed = _m_speed;
			
		}
		
		public function startLevel():void {
			
			if(m_distructorType == 1) //rad mishavad
			{
				var r:Number = Math.random();
				var yy:Number = Math.random()*400 + 200;
				if(r < 0.5)
				{
					var m1:MozahemAirPlane = new MozahemAirPlane();
					m1.x = -100;
					m1.y = yy;
					m_ctrl.addChildAt(m1,3);					
				}
				else
				{
					
					var m3:MozahemBirds = new MozahemBirds();
					m3.x = 800;
					m3.y = yy;
					m_ctrl.addChildAt(m3,3);
				
				}
			}
			else if(m_distructorType == 2) //rad mishavad
			{
				r = Math.random();
				var xx:Number = Math.random()*400 +100;
				yy = Math.random()*300 +100;
				if(r < 0.5)
				{
					var m4:MozahemHelicopter = new MozahemHelicopter();
					m4.x = xx;
					m4.y = yy;
					addChild(m4);					
				}
				else
				{
					var m2:MozahemBalloon = new MozahemBalloon();
					m2.x = xx;
					m2.y = yy;
					addChild(m2);				
				}
			}
			
			m_ctrl.sb.scoreBar.setNumCoin(numRainyAbr);
			startt();
			
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, harkat);
			
			intervalId = setInterval(saveMouseAndRainDim, 100);
			
			//eyeTracker.startTrack();
			//addChild(eyeTracker);
			//eyeTracker.addEventListener(EyeTrackerDataSentEvent.EYE_TRACKER_DATA, onEyeTrackerDataRecieved)
		}
		
		public function harkat(e:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, harkat);
			
			m_ctrl.soundChannelTempo120 = m_ctrl.musicAbr1.play();
			
			addEventListener(Event.ENTER_FRAME,loop);
			
			for(var i:int=0;i<vecAbrNormal.length;i++)
			{
				AbrNormal(vecAbrNormal[i]).harkat=1;
			}
			for(i=0;i<vecAbrRainy.length;i++)
			{
				AbrRainy(vecAbrRainy[i]).harkat=1;
			}
		}
		
		public function loop(e:Event):void
		{
			count++;
			if(count == m_shetabKondShavande && ansTime==0)
			{
				count = 0;
				var dotaChasbidanBeHam:Boolean = false;
				if(vecAbrRainy[0] !=  null)
				{
					if(AbrRainy(vecAbrRainy[0]).currentFrame == 6)// frame 5 yani akharin fram e barani ast, bayad check shavad ke hampooshani darand ke agar darand abr ha naistand
					{
						for(var i:int = 0;i<vecAbrNormal.length;i++)// abr haye normal ba ham
						{
							for(var j:int = 0;j<vecAbrNormal.length;j++)
							{
								if(i!=j)
								{
									var deltaX:Number = vecAbrNormal[i].x - vecAbrNormal[j].x;
									var deltaY:Number = vecAbrNormal[i].y - vecAbrNormal[j].y;
									var dis:Number  =  deltaX*deltaX + deltaY*deltaY;
									dis = Math.sqrt(dis);
									if(dis < 20)
									{
										dotaChasbidanBeHam = true;
										break;
									}
								}
							}
						}
						for(i = 0;i<vecAbrRainy.length;i++)// abr haye rainy ba ham
						{
							for(j = 0;j<vecAbrRainy.length;j++)
							{
								if(i!=j)
								{
									deltaX = vecAbrRainy[i].x - vecAbrRainy[j].x;
									deltaY = vecAbrRainy[i].y - vecAbrRainy[j].y;
									dis = deltaX*deltaX + deltaY*deltaY;
									dis = Math.sqrt(dis);
									if(dis < 20)
									{
										dotaChasbidanBeHam = true;
										break;
									}
								}
							}
						}
						for(i = 0;i<vecAbrRainy.length;i++)// abr haye rainy ba hnormal
						{
							for(j = 0;j<vecAbrNormal.length;j++)
							{
								deltaX  = vecAbrRainy[i].x - vecAbrNormal[j].x;
								deltaY  = vecAbrRainy[i].y - vecAbrNormal[j].y;
								dis = deltaX*deltaX + deltaY*deltaY;
								dis = Math.sqrt(dis);
								if(dis < 20)
								{
									dotaChasbidanBeHam = true;
									break;
								}
							}
						}
						if(dotaChasbidanBeHam == true)
							count = m_shetabKondShavande - 1; // ke loop bad ham dobare biad check she nare ta time bad
					}
				}

				if(dotaChasbidanBeHam == false)
				{
					for(i  = 0;i<vecAbrNormal.length;i++)
					{
						AbrNormal(vecAbrNormal[i]).m_speed-=(m_speed/6);
					}
					for(i = 0;i<vecAbrRainy.length;i++)
					{
						AbrRainy(vecAbrRainy[i]).m_speed-=(m_speed/6);
						var destFrame:int = AbrRainy(vecAbrRainy[i]).currentFrame + 1;
						if(destFrame == AbrRainy(vecAbrRainy[i]).totalFrames)
							destFrame = AbrRainy(vecAbrRainy[i]).totalFrames - 1;
						AbrRainy(vecAbrRainy[i]).gotoAndStop(destFrame);
					}
					if(vecAbrRainy[0]!= null)
					{
						if(AbrRainy(vecAbrRainy[0]).m_speed < 0.001)//momkene ashari beshe va in ashari ha round nashe rooye sefr
						{
							for(i  = 0;i<vecAbrNormal.length;i++)
							{
								AbrNormal(vecAbrNormal[i]).m_speed = 0;
							}
							for(i = 0;i<vecAbrRainy.length;i++)
							{
								AbrRainy(vecAbrRainy[i]).m_speed = 0;
							}
							ansTime = 1;
							
							SoundMixer.stopAll();
							m_ctrl.soundChannelTempo120.stop();
							m_ctrl.musicAbr2.play();
							m_answerTime = m_ctrl.m_count;
							
							clearInterval(intervalId);
							eyeTracker.disableRecord();
						}
					}
				}
			}
		}
		
		public function sendJSON(levInfo:levelInfo):void
		{
			var dataStr:String = JSON.stringify(levInfo);
			var vars: URLVariables = new URLVariables();
			vars.email = this.m_ctrl.getUserEmailAddr();
			vars.data = dataStr;
			
			var req: URLRequest = new URLRequest();
			req.method      = URLRequestMethod.POST;
			req.data        = vars;
			req.url         = "http://127.0.0.1:5000/addGameData";

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onDataSent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(req);
		}
		
		private function onDataSent(e:Event):void {
			trace("data sent successfuly... " + e.target.data)
		}
		
		private function ioErrorHandler(e:Event):void {
			trace("error sending data")
		}
		
		public function errorLoader(e:Event):void
		{
			trace("error catched");
		}

		public function clicked(ans:int, abrID:int):void
		{
			numClicked++;
			levInfo.ansTimeSeq.push(m_ctrl.m_count - startTime);
			if(ans==1)
			{
				m_ctrl.numAllTrue++;
				levInfo.trueFalseSeq +="T";
				levInfo.correctRainy.push(abrID);
				numTrue++;
				m_ctrl.sb.scoreBar._incScore(50);
				numCoin++;
			}
			else
			{
				m_ctrl.numAllFault++;
				levInfo.trueFalseSeq +="F";
				levInfo.wrongNormal.push(abrID);
				m_ctrl.sb.scoreBar._dropCoin();
			}			
			if(numClicked == numRainyAbr)
			{
				
				levInfo.lev = m_ctrl.difficality; //bayad ghabl az finishLevel bashad
				if(numRainyAbr==numTrue)
				{
					if(m_ctrl.difficality < 20)
					{
						m_ctrl.finishLevel(100);
						m_score+=100;
					}
					else if(m_ctrl.difficality < 40)
					{
						m_ctrl.finishLevel(200);
						m_score+=200;
					}
					else if(m_ctrl.difficality < 60)
					{
						m_ctrl.finishLevel(300);
						m_score+=300;
					}
					else if(m_ctrl.difficality < 80)
					{
						m_ctrl.finishLevel(400);
						m_score+=400;
					}
					else
					{
						m_ctrl.finishLevel(500);
						m_score+=500;
					}
				}
				else
				{
					m_ctrl.finishLevel(0);
				}
				
				levInfo.trueAnsNum = numTrue;
				levInfo.falseAnsNum = numRainyAbr - numTrue;
				levInfo.m_score=m_score + 50*levInfo.trueAnsNum;
				levInfo.numCoin=numCoin;
				levInfo.isDone=false;
				levInfo.numNormalAbr = this.numNormalAbr;
				levInfo.numRainyAbr = this.numRainyAbr;
				levInfo.m_changeGRadianTime = m_ctrl.countChangeGradian;
				levInfo.m_distructorType = this.m_distructorType;
				levInfo.m_maxGradian = m_ctrl.maxGradian;
				levInfo.m_shetabKondShavande = this.m_shetabKondShavande;
				levInfo.m_speed = this.m_speed;
				levInfo.distributionType = this.distributionType;
				
				levInfo.allData = this.allDataArr;

				sendJSON(levInfo);
				
			}
		}
		
		public function startt():void
		{
			
			timer.stop()
			var randomLocation:Array=new Array();
			for(var i:int=0;i<numRainyAbr;i++)
			{
				var rr:int=Math.floor(Math.random()*(numRainyAbr+numNormalAbr));
				var hast:int=0;
				for(i =0;i<randomLocation.length;i++)
				{
					if(randomLocation[i]==rr)
						hast=1;
				}
				if(hast==0)
					randomLocation.push(rr);
				else
					i--;
			}
			
			var offsetX:int=0;
			var offsetY:int=0;
			var numberInRaw:int=0;
			
			if(distributionType == 1) {
				
				numberInRaw=6;
				offsetX=160;
				offsetY=160;
				
			} else if(distributionType == 2) {
				
				numberInRaw = 4;
				offsetX = 50;
				offsetY = 50;
				
			} else if(distributionType == 3) {
				
				numberInRaw = 4;
				offsetX = 350;
				offsetY = 50;
				
			} else if(distributionType == 4) {
				
				numberInRaw = 4;
				offsetX = 50;
				offsetY = 320;
			
			} else if(distributionType == 5) {
				
				numberInRaw = 4;
				offsetX = 350;
				offsetY = 320;
				
			} else if(distributionType == 6) {
				
				numberInRaw = 4;
				offsetX = 200;
				offsetY = 50;
				
			} else if(distributionType == 7) {
				
				numberInRaw = 4;
				offsetX = 200;
				offsetY = 280;
				
			} else if(distributionType == 8) {
				
				numberInRaw = 4;
				offsetX = 50;
				offsetY = 135;
				
			} else if(distributionType == 9) {
				
				numberInRaw = 4;
				offsetX = 400;
				offsetY = 135;
			}
			
			for(i = 0; i < numNormalAbr+numRainyAbr; i++)
			{
				hast = 0;
				for(var t:int = 0; t < randomLocation.length; t++)
				{
					if(randomLocation[t]==i)
						hast = 1;
				}
				if(hast==0)
				{
					var a1:AbrNormal = new AbrNormal(this, vecAbrNormal.length);
					a1.x = offsetX+Math.round((i%numberInRaw))*70;
					a1.y = offsetY+Math.round((i/numberInRaw))*70;
					a1.m_speed = m_speed;
					addChild(a1);
					vecAbrNormal.push(a1);
				}
				else
				{
					var a:AbrRainy = new AbrRainy(this, vecAbrRainy.length);
					a.x = offsetX+Math.round((i%numberInRaw))*70;
					a.y = offsetY+Math.round((i/numberInRaw))*70;;
					a.m_speed = m_speed;
					addChild(a);
					vecAbrRainy.push(a);
				}
			}
		}
		function timeOut():void
		{

		}
		
		function saveMouseAndRainDim():void {
			var dataPoint:DataPoint = new DataPoint();
			dataPoint.mouse_x = stage.mouseX; dataPoint.mouse_y = stage.mouseY;
			for(var i:int = 0; i < vecAbrNormal.length; i++) {
				var abrNorm:AbrNormal = vecAbrNormal[i];
				dataPoint.normalAbrDim.push({id: abrNorm.ID, abr_x: abrNorm.x, abr_y:abrNorm.y});
			}
			
			for(var j:int = 0; j < vecAbrRainy.length; j++) {
				var abrRainy:AbrRainy = vecAbrRainy[j];
				dataPoint.rainyAbrDim.push({id: abrRainy.ID, abr_x: abrRainy.x, abr_y:abrRainy.y});
			}
			allDataArr.push(dataPoint);
		}
		
		function onEyeTrackerDataRecieved(e:EyeTrackerDataSentEvent):void {
			var dataPoint:DataPoint = new DataPoint();
			dataPoint.record_time = e.recordTime;
			dataPoint.eye_x = e.eye_x; dataPoint.eye_y = e.eye_y;
			dataPoint.mouse_x = stage.mouseX; dataPoint.mouse_y = stage.mouseY;
			for(var i:int = 0; i < vecAbrNormal.length; i++) {
				var abrNorm:AbrNormal = vecAbrNormal[i];
				dataPoint.normalAbrDim.push({id: abrNorm.ID, abr_x: abrNorm.x, abr_y:abrNorm.y});
			}
			
			for(var j:int = 0; j < vecAbrRainy.length; j++) {
				var abrRainy:AbrRainy = vecAbrRainy[j];
				dataPoint.rainyAbrDim.push({id: abrRainy.ID, abr_x: abrRainy.x, abr_y:abrRainy.y});
			}
			allDataArr.push(dataPoint);
		}
	}
}