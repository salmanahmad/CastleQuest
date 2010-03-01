package code
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.ui.Keyboard;
	
	
	public class ProgressBar extends MovieClip
	{

		function ProgressBar()
		{
			updatePercent(1.0);
		}
		
		
		public function updatePercent(val:Number):void {
			var width:Number = val * progressBacking.width;
			progressIndicator.width = width
		}
		

	}
}
