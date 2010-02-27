package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetTextLED
		A class for controlling a PhidgetTextLED.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetTextLED extends Phidget
	{
		private var numRows:int = com.phidgets.Constants.PUNK_INT;
		private var numColumns:int = com.phidgets.Constants.PUNK_INT;
		private var brightness:int = com.phidgets.Constants.PUNK_INT;
		
		public function PhidgetTextLED(){
			super("PhidgetTextLED");
		}
		
		override protected function initVars():void{
			numRows = com.phidgets.Constants.PUNK_INT;
			numColumns = com.phidgets.Constants.PUNK_INT;
			brightness = com.phidgets.Constants.PUNK_INT;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfRows":
					numRows = int(value);
					keyCount++;
					break;
				case "NumberOfColumns":
					numColumns = int(value);
					keyCount++;
					break;
				case "Brightness":
					brightness = int(value);
					break;
			}
		}
		
		//Getters
		/*
			Property: RowCount
			Gets the number of rows supported by the TextLED.
		*/
		public function get RowCount():int{
			if(numRows == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numRows;
		}
		/*
			Property: ColumnCount
			Gets the number of columns per row supported by this TexlLED
		*/
		public function get ColumnCount():int{
			if(numColumns == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numColumns;
		}
		/*
			Property: Brightness
			Gets the brightness of the display.
		*/
		public function get Brightness():int{
			if(brightness == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return brightness;
		}
		
		//Setters
		/*
			Property: Brightness
			Sets the brightness of the display (0-100).
			
			Parameters:
				val - brightness
		*/
		public function set Brightness(val:int):void{ 
			_phidgetSocket.setKey(makeKey("brightness"), val.toString(), true);
		}
		/*
			Function: setDisplayString
			Sets the display string for a row.
			
			Parameters:
				index - row
				val - display string
		*/
		public function setDisplayString(index:int, val:String):void{ 
			_phidgetSocket.setKey(makeIndexedKey("DisplayString", index, numRows), val, true);
		}
	}
}