package  {
	
	public class DataPoint {

		public var record_time:Number;
		public var mouse_x:Number;
		public var mouse_y:Number;
		public var rainyAbrDim:Array = new Array();
		public var normalAbrDim:Array = new Array();
		public var eye_x:Number;
		public var eye_y:Number;

		public function DataPoint(obj:Object = null) {
			if(obj == null)
				return;
				
			if(obj.hasOwnProperty("record_time")) {
				this.record_time = obj.record_time;
			}
			if(obj.hasOwnProperty("mouse_x")) {
				this.mouse_x = obj.mouse_x;
			}
			
			if(obj.hasOwnProperty("mouse_y")) {
				this.mouse_y = obj.mouse_y;
			}
			
			if(obj.hasOwnProperty("eye_x")) {
				this.eye_x = obj.eye_x;
			}
			
			if(obj.hasOwnProperty("eye_y")) {
				this.eye_y = obj.eye_y;
			}
			
			if(obj.hasOwnProperty("rainyAbrDim")) {
				for(var i = 0; i < obj.rainyAbrDim.length; i++) {
					this.rainyAbrDim.push({id: obj.rainyAbrDim[i].id, abr_x: obj.rainyAbrDim[i].abr_x, abr_y:obj.rainyAbrDim[i].abr_y});
				}
			}
			
			if(obj.hasOwnProperty("normalAbrDim")) {
				for(i = 0; i < obj.normalAbrDim.length; i++) {
					this.normalAbrDim.push({id: obj.normalAbrDim[i].id, abr_x: obj.normalAbrDim[i].abr_x, abr_y:obj.normalAbrDim[i].abr_y});
				}
			}
		}

	}
	
}
