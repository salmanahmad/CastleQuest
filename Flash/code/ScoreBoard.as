package code {
	
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.ui.Keyboard;
	
	
	
	public class ScoreBoard extends MovieClip {
		
		public function setName(value:String):void {
			nameText.text = value;
		} 
		
		public function setTarget(value:String):void {
			targetText.text = value;
		}
		
		public function setCurrent(value:String):void {
			currentText.text = value;
		}


	}
}