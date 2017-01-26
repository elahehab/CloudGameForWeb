package  {
	
	public class Strategies {

		public static var list:Array = new Array();
		public static var instance:Strategies = null;

		public function Strategies() {
			
		}
		
		public static function getStrategies():Array {
			if(list.length == 0) {
				list.push("به مرکز صفحه يا مرکز ابرها نگاه کردم");
				list.push("يکي از ابرها را جدا کردم و بقيه را به صورت گروهي دنبال کردم در حالي که نيم نگاهي به ابر جدا شده داشتم");
				list.push("ابرهاي باران‌زا را با چشم دنبال کردم");
				list.push("هنگام کند شدن حرکت ابرها با دقت بيشتري به آنها نگاه کردم");
				
				for(var i = 0; i < list.length; i++) {
					String(list[i]).replace("ی", "ي");
				}
			}
			return list;
		}
		
		public static function getIdx(txt:String):int {
			for(var i = 0; i < list.length; i++) {
				if(list[i] == txt) {
					return i;
				}
			}
			return -1;
		}
	}
}
