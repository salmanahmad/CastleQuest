package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;

	/*
		Class: PhidgetLED
		A class for controlling a PhidgetLED.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetLED extends Phidget
	{
		private var numLEDs:int;
		private var leds:Array;
		
		public function PhidgetLED(){
			super("PhidgetLED");
		}
		
		override protected function initVars():void{
			numLEDs = com.phidgets.Constants.PUNK_INT;
			leds = new Array(64);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfLEDs":
					numLEDs = int(value);
					keyCount++;
					break;
				case "Brightness":
					if(leds[index] == undefined) keyCount++;
					leds[index] = value;
					break;
			}
		}
		
		//Getters
		/*
			Property: LEDCount
			Gets the number of LEDs supported by this PhidgetLED
		*/
		public function get LEDCount():int{
			if(numLEDs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numLEDs;
		}
		/*
			Function: getDiscreteLED
			Gets the brightness of an LED.
			
			Parameters:
				index - LED index
		*/
		public function getDiscreteLED(index:int):int{
			return int(indexArray(leds, index, numLEDs, com.phidgets.Constants.PUNK_INT));
		}
		
		//Setters
		/*
			Function: setDiscreteLED
			Sets the brightness of an LED (0-100).
			
			Parameters:
				index - LED index
				val - brightness
		*/
		public function setDiscreteLED(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Brightness", index, numLEDs), val.toString(), true);
		}
	}
}