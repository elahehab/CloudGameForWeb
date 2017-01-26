package 
{

	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.net.FileReference;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.ProgressEvent;
	import flash.media.SoundChannel;
	import flash.display.StageDisplayState;

	public class ctrl extends MovieClip
	{
		var score:int = 0;
		var difficality:int = 0;
		var currentLevel:level = null;
		var timer:Timer = new Timer(500);
		var sb:*;
		var numSeqFault:int = 0;
		var bg:backG;
		var countChangeGradian:Number = 10;
		var maxGradian:Number = 120;

		var firstNumRainyCloud:int = 16;
		var firstNumNormalCloud:int = 1;
		var firstSpeed:int = 6;
		var firstDecrisingAcc:int = 40;

		var soundFalseAns:SoundFalseAns=new SoundFalseAns();
		var soundTrueAns:SoundTrueAns=new SoundTrueAns();
		var soundStartGame:SoundStartGame=new SoundStartGame();
		var soundMouseOver:SoundMouseOver=new SoundMouseOver();

		var musicAbr1:MusicAbr1=new MusicAbr1();
		var musicAbr2:MusicAbr2=new MusicAbr2();


		var soundChannelTempo120:SoundChannel = new SoundChannel();
		var soundChannelTempo140:SoundChannel = new SoundChannel();
		var soundChannelTempo160:SoundChannel = new SoundChannel();

		var lastLevel:int = 0;
		var sessionNumber:int = 0;
		var user_id:int = 0;
		var task_id:int = 0;
		var host:String;

		var numTry:int = 0;
		var numAllTrue:int = 0;
		var numAllFault:int = 0;

		var myLoader:Loader = new Loader();
		var m_count:int = 0;

		var outputText:String = new String();
		var time:int = 0;
		var distribution:int = 1;/* 1-fullScreen 2-UpLEft 3-UpRight 4-DownLeft 5-DownRight
									6-UP 7-Down 8-Right 9-Left*/
		var userEmailAddr:String;
		var m_ins:ins;

		const MAX_NUM_TRY:int = 20;
		
		var type:int = 1; //type = 1 => level 1 to 10
						  //type = 2 => level 11 to 20
						  //type = 3 => level 21 to 30
						  
		var endLevel:int = 10;
		
		var sinTable:Array = [37];
		var cosTable:Array = [37];
		
		var timeIsOut:Boolean = false;
		var levels:Array = null;
		var continuePage:ContinueNextLevelPage;
		
		var showMode:Boolean = false;

		public function ctrl()
		{
			//addChild(new ContinueNextLevelPage());
			
			//this.scaleX = 1.5;
			
			if(showMode) {
				startClicked();
				return;
			}

			m_ins = new ins(startClicked);
			m_ins.x = 400;
			m_ins.y = 270;
			addChild(m_ins);
			
			for(var i:int=0;i<37;i++)
			{
				sinTable[i]=Math.sin(i * 10 * Math.PI / 180);
			}
			for(i=0;i<37;i++)
			{
				cosTable[i]=Math.cos(i * 10 * Math.PI / 180);
			}
			
		}
		
		public function sinApprox(degree:Number):Number
		{
			while(degree > 360)degree-=360;
			while(degree < 0)degree+=360;
			
			var index : int = (int(degree))/10;
			return sinTable[index];
		}
		public function cosApprox(degree:Number):Number
		{
			while(degree > 360)degree-=360;
			while(degree < 0)degree+=360;
			var index : int = (int(degree))/10;
			return cosTable[index];
		}
		
		public function loop(e:Event):void
		{
			m_count++;
		}

		public function startClicked():void
		{
			if(!this.showMode)
				userEmailAddr = m_ins.getEmail();
				
			soundStartGame.play();
			var inputString:String = "0";
			addEventListener(Event.ENTER_FRAME,loop);

			var aa:int = 01;
			if (aa==0)
			{
				inputString = root.loaderInfo.parameters["maxGradian"];
				maxGradian = Number(inputString);

				inputString = root.loaderInfo.parameters["changeGradianTime"];
				countChangeGradian = Number(inputString);

				inputString = root.loaderInfo.parameters["numRainyCloud"];
				firstNumRainyCloud = Number(inputString);

				inputString = root.loaderInfo.parameters["numNormalCloud"];
				firstNumNormalCloud = Number(inputString);

				inputString = root.loaderInfo.parameters["primarySpeed"];
				firstSpeed = Number(inputString);

				inputString = root.loaderInfo.parameters["acceleration"];
				firstDecrisingAcc = Number(inputString);
			}
			else
			{
				maxGradian = 20;
				countChangeGradian = 40;
				firstNumRainyCloud = 1;
				firstNumNormalCloud = 5;
				firstSpeed = 6;
				firstDecrisingAcc = 40;
			}

			bg = new backG();
			addChild(bg);
			var gtitle:GameTitle = new GameTitle();
			gtitle.x = -330;
			gtitle.y = -295;
			bg.addChild(gtitle);

			var url:URLRequest = new URLRequest("Bar.swf");
			myLoader.load(url);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,externalSWFLoaded);
			myLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);

		}
		
		function onProgressHandler(event:ProgressEvent):void
		{
			var dataAmountLoaded:Number = event.bytesLoaded / event.bytesTotal * 100;

			//trace("dataAmountLoaded: "+dataAmountLoaded);
		}


		public function externalSWFLoaded(e:Event):void
		{
			var assetClass:Class = myLoader.contentLoaderInfo.applicationDomain.getDefinition("SideBar") as Class;
			sb= new assetClass();

			addChild(sb);
			sb.x = 400;
			sb.y = 300;
			sb.difficulty.visible = false;
			sb.scoreBar._setScore(0);
			sb.scoreBar._setMainLevel(1,100);
			
			sb.time._resetTime();
			sb.time._setTotalTime(600); //10 minutes
			sb.time._startTime(true);
			addEventListener("timeOut",timeOut);
			
			if(showMode) {
				addChild(new PlayerViewer());
			} else {
				createNewLevel();
			}
		}
		
		public function createNewLevel():void
		{
			if(currentLevel != null && this.contains(currentLevel)) {
				removeChild(currentLevel);
			}
				
			bg.gotoAndStop(1);
			timer.stop();
			
			if(levels == null) {
				levels = new Array();
				levels.push([7, 1, 10,this, 20, 20, 10, 0 ,2]); //0
				levels.push([7, 1, 10,this, 20, 20, 10, 0 ,5]); //1
				levels.push([7, 1, 10,this, 20, 20, 10, 0 ,4]); //2
				levels.push([8, 1, 14,this, 20, 20, 10, 0, 3]); //3
				
				levels.push([8, 2, 10,this, 30, 10, 10, 0, 5]); //4
				levels.push([8, 2, 15,this, 12, 10, 10, 0, 4]); //5
				levels.push([8, 2, 15,this, 12, 10, 10, 0, 1]); //6
				levels.push([8, 2, 15,this, 12, 10, 10, 0, 7]); //7
				levels.push([8, 2, 15,this, 12, 10, 10, 0, 8]); //8
				
				levels.push([9, 3, 10,this, 30, 10, 10, 0, 6]); //9
				levels.push([8, 3, 15,this, 12, 10, 10, 0, 7]); //10
				levels.push([10,3, 12,this, 20, 10, 10, 0, 8]); //11
				levels.push([10,3, 12,this, 20, 10, 10, 0, 9]); //12
				levels.push([10,3, 12,this, 20, 10, 10, 0, 1]); //13
				levels.push([10,3, 12,this, 20, 10, 10, 0, 7]); //14
				
				levels.push([9, 4, 14,this, 20, 10, 10, 0, 4]); //15
				levels.push([9, 4, 14,this, 20, 10, 10, 0, 8]); //16
				levels.push([12,4, 10,this, 30, 10, 10, 0, distribution]); //17
				levels.push([12,4, 15,this, 20, 10, 10, 0, distribution]); //18
				levels.push([14,4, 14,this, 20, 10, 10, 0, distribution]); //19
				levels.push([14,4, 14,this, 30, 10, 10, 0, distribution]); //20
				
				levels.push([12,5, 10,this, 30, 10, 10, 0, distribution]); //21
				levels.push([12,5, 12,this, 30, 10, 10, 0, distribution]); //22
				levels.push([12,5, 14,this, 25, 10, 10, 0, distribution]); //23
				levels.push([12,5, 15,this, 25, 10, 10, 0, distribution]); //24
				levels.push([14,5, 15,this, 25, 10, 10, 0, distribution]); //25
				levels.push([14,5, 16,this, 30, 10, 10, 0, distribution]); //26
				levels.push([14,5, 16,this, 25, 10, 10, 0, distribution]); //27
				
				levels.push([12,6, 10,this, 30, 10, 10, 0, distribution]); //28
				levels.push([12,6, 12,this, 25, 10, 10, 0, distribution]); //29
				levels.push([12,6, 14,this, 25, 10, 10, 0, distribution]); //30
				levels.push([12,6, 15,this, 30, 10, 10, 0, distribution]); //31
				levels.push([12,6, 15,this, 15, 10, 10, 0, distribution]); //32
				levels.push([14,6, 16,this, 30, 10, 10, 0, distribution]); //33
				levels.push([14,6, 16,this, 25, 10, 10, 0, distribution]); //34
				
				levels.push([10,7, 10,this, 30, 10, 10, 0, distribution]); //35
				levels.push([12,7, 12,this, 25, 10, 10, 0, distribution]); //36
				levels.push([12,7, 14,this, 25, 10, 10, 0, distribution]); //37
				levels.push([12,7, 15,this, 25, 10, 10, 0, distribution]); //38
				levels.push([12,7, 15,this, 30, 10, 10, 0, distribution]); //39
				levels.push([12,7, 16,this, 30, 10, 10, 0, distribution]); //40
				levels.push([12,7, 16,this, 30, 10, 10, 0, distribution]); //41
			}
			currentLevel = new level(levels[difficality][0], levels[difficality][1], levels[difficality][2], 
									 levels[difficality][3], levels[difficality][4], levels[difficality][5], 
									 levels[difficality][6], levels[difficality][7], levels[difficality][8]);
			addChild(currentLevel);
			currentLevel.startLevel();
			sb.scoreBar._setMainLevel(difficality+1,levels.length);
		}

		public function finishLevel(resultt:int):void
		{
			numTry++;
			sb.scoreBar._incScore(resultt);

			score +=  resultt;
			var prevDiff:int = difficality;

			if (resultt > 0)
			{
				numAllTrue++;
				numSeqFault = 0;
				difficality += 1;
				if (difficality > levels.length - 1)
				{
					difficality = levels.length - 1;
				}
			}
			else
			{
				numAllFault++;
				numSeqFault++;
				if (numSeqFault==2)
				{
					numSeqFault = 0;
					//difficality = 0; //if the user chose the wronge answer for the second time restart the game
					if (difficality < 0)
					{
						difficality = 0;
					}
				}
			}
			trace("difficulty is " + difficality);
			if (timeIsOut)//(difficality == endLevel || numTry == MAX_NUM_TRY)
			{
				sb.scoreBar._finishCounting();
				var assetClass:Class = myLoader.contentLoaderInfo.applicationDomain.getDefinition("finishPage") as Class;
				var finishP:* = new assetClass(sb.scoreBar._getScore(),numAllTrue / (numAllTrue + numAllFault) * 100,host);

				addChild(finishP);
			}
			else if((difficality == 1 || difficality == 9 || difficality == 15 || difficality == 21 ||
					difficality == 28 || difficality == 35 || difficality == 41) && prevDiff == difficality - 1)
			{
				var partNum:int;
				if(difficality <= 4) partNum = 1;
				else if(difficality <= 9) partNum = 2;
				else if(difficality <= 15) partNum = 3;
				else if(difficality <= 21) partNum = 4;
				else if(difficality <= 28) partNum = 5;
				else if(difficality <= 35) partNum = 6;
				else if(difficality <= 41) partNum = 7;
				
				continuePage = new ContinueNextLevelPage(partNum, this.userEmailAddr);
				addChild(continuePage);
				addEventListener(ContinueClickedEvent.CONTINUE_CLICKED, onContinueClicked);
				sb.time._stopTime();
			} else {
				createNewLevel();
			}
		}
		
		private function onContinueClicked(e:ContinueClickedEvent):void {
			timer.start();
			removeChild(continuePage);
			sb.time._resumeTime();
			createNewLevel();
		}

		public function getUserEmailAddr():String
		{
			return this.userEmailAddr;
		}
		
		private function timeOut(e:Event):void {
			trace("time finished")
			timeIsOut = true;
		}
	}
}