package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AbrRainy extends MovieClip {
		var direc:Number=0;
		var w:Number=3;
		var changeDirect:int=0;
		public var m_speed:int = 0;
		var lev:level=null;
		var harkat:int=0;
		var baseWidth:Number=52.1;//vase abre bedoon baresh, andazash enghadre
		var baseHeight:Number=34.5;
		
		var baseWidth2:Number=52.1;//vase abre raniny, andazash enghadre
		var baseHeight2:Number=51.2;
		
		public var ID:int;
		
		public function AbrRainy(_lev:level, _id:int) {
			lev=_lev;
			this.ID = _id;
			stop();
			scaleX = 0.5;
			scaleY = 0.5;
			if(lev != null) {
				direc=Math.random()*(359)+1;
				gotoAndStop(2);
				addEventListener(Event.ENTER_FRAME,loop);
				addEventListener(MouseEvent.CLICK,clickMouse);
				addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
				addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
			}
		}
		function clickMouse(e:MouseEvent):void
		{
			if(m_speed==0)
			{
				lev.clicked(1, this.ID);
				removeEventListener(MouseEvent.CLICK,clickMouse);
				gotoAndStop(1);
			}
		}
		function MouseOut(e:MouseEvent):void
		{
			if(m_speed==0 && currentFrame!=1)
			{
				scaleX = 0.5;
				scaleY = 0.5;
			}
		}
		function MouseOver(e:MouseEvent):void
		{
			if(m_speed==0 && currentFrame!=1)
			{
				ctrl(parent.parent).soundMouseOver.play();
				scaleX = 0.55;
				scaleY = 0.55;
			}
		}
		function degrees(radians:Number):Number
		{
			return radians * 180/Math.PI;
		}
		function radians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		public function movement():void
		{
			
			changeDirect++;
			
			if(changeDirect > lev.m_ctrl.countChangeGradian)
			{
				changeDirect=0;
				w=Math.random()*lev.m_ctrl.maxGradian - lev.m_ctrl.maxGradian/2 ;
			}
			
			//Movement
			direc=direc+w;
			x+=m_speed*lev.m_ctrl.sinApprox(direc)*0.5;
			y+=m_speed*lev.m_ctrl.cosApprox(direc)*0.5;
			
			//collision with sides
			var rightSide:int = 0;
			var leftSide:int = 0;
			var upSide:int = 0;
			var downSide:int = 0;
			
			/* 1-fullScreen 2-UpLEft 3-UpRight 4-DownLeft 5-DownRight*/
			
			if(lev.distributionType == 1){
				rightSide= 640;
				leftSide= 40;
				upSide= 80;
				downSide= 570;
			}else if(lev.distributionType == 2){
				rightSide= 400;
				leftSide= 40;
				upSide= 80;
				downSide= 380;
			}else if(lev.distributionType == 3){
				rightSide= 640;
				leftSide= 300;
				upSide= 80;
				downSide= 380;
			}else if(lev.distributionType == 4){
				rightSide= 400;
				leftSide= 40;
				upSide= 280;
				downSide= 570;
			}else if(lev.distributionType == 5){
				rightSide= 640;
				leftSide= 300;
				upSide= 280;
				downSide= 570;
			} else if(lev.distributionType == 6) {
				rightSide= 520;
				leftSide= 200;
				upSide= 80;
				downSide= 300;
			} else if(lev.distributionType == 7) {
				rightSide= 520;
				leftSide= 200;
				upSide= 280;
				downSide= 570;
			} else if(lev.distributionType == 8) {
				rightSide= 400;
				leftSide= 40;
				upSide= 180;
				downSide= 475;
			} else if(lev.distributionType == 9) {
				rightSide= 640;
				leftSide= 300;
				upSide= 180;
				downSide= 475;
			}
			
			if( x < leftSide)//collide with left
			{
				direc=Math.random()*(1+150-30)+30;
			}
			if( x > rightSide)//collide with right
			{
				direc=Math.random()*(1+330-210)+210;
				
			}
			if( y < upSide)////collide with up
			{
				direc=Math.random()*(1+420-300)+300;
			}
			if( y > downSide)//collide with doww
			{
				direc=Math.random()*(1+240-120)+120;
			}			
		}
		public function loop(e:Event):void
		{
			if(harkat==1)
				movement();

		}
	}
	
}
