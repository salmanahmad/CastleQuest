package code {
	
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.ui.Keyboard;
	
	
	
	public class PauseScreen extends MovieClip {
		
		public function showPause():void {

			this.visible = true;
			this.pauseText.visible = true;
			this.continueText.visible = true;
			this.restartText.visible = true;

		}
		
		public function showStart():void {
			this.visible = true;
			
			
			this.pauseText.visible = false;			
			this.restartText.visible = false;
			
			this.continueText.visible = true;
			
		}
		
		public function hide():void {
			this.visible = false;
		}

	}
}