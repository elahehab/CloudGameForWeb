package  {
	
	public class levelInfo {

		public var m_score:int;
		public var lev:int;
		public var numNormalAbr:int;
		public var numRainyAbr:int;
		public var m_speed:Number;
		public var m_shetabKondShavande:Number;
		public var m_maxGradian:Number;
		public var m_changeGRadianTime:Number;
		public var m_distructorType:int;
		public var distributionType:int;
		
		public var allData:Array;
		public var correctRainy:Array = new Array();
		public var wrongNormal:Array = new Array();
		
		public var numCoin:int;
		public var isDone:Boolean;
		public var trueAnsNum:int;
		public var falseAnsNum:int;
		public var trueFalseSeq:String="";
		public var ansTimeSeq:Array=new Array();
		
		public function levelInfo() {
		}
	}
}