package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetPHSensor
		A class for controlling a PhidgetPHSensor.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetPHSensor. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.PH_CHANGE	- PH change
	*/
	public class PhidgetPHSensor extends Phidget
	{
		private var phMin:Number;
		private var phMax:Number;
		private var potentialMin:Number;
		private var potentialMax:Number;
		
		private var ph:Number;
		private var potential:Number;
		private var phTrigger:Number;
		
		public function PhidgetPHSensor(){
			super("PhidgetPHSensor");
		}
		
		override protected function initVars():void{
			phMin = com.phidgets.Constants.PUNI_NUM;
			phMax = com.phidgets.Constants.PUNI_NUM;
			potentialMin = com.phidgets.Constants.PUNK_NUM;
			potentialMax = com.phidgets.Constants.PUNK_NUM;
		
			ph = com.phidgets.Constants.PUNI_NUM;
			potential = com.phidgets.Constants.PUNI_NUM;
			phTrigger = com.phidgets.Constants.PUNI_NUM;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "PHMin":
					if(phMin == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					phMin = Number(value);
					break;
				case "PHMax":
					if(phMax == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					phMax = Number(value);
					break;
				case "PotentialMin":
					potentialMin = Number(value);
					keyCount++;
					break;
				case "PotentialMax":
					potentialMax = Number(value);
					keyCount++;
					break;
				case "PH":
					if(ph == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					ph = Number(value);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.PH_CHANGE,this,ph));
					break;
				case "Trigger":
					if(phTrigger == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					phTrigger = Number(value);
					break;
				case "Potential":
					if(potential == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					potential = Number(value);
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			if(ph != com.phidgets.Constants.PUNK_NUM)
				dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.PH_CHANGE,this,ph));
		}
		
		//Getters
		/*
			Property: PH
			Gets the current PH sensed by the PH sensor.
		*/
		public function get PH():Number{
			if(ph == com.phidgets.Constants.PUNK_NUM || ph == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return ph;
		}
		/*
			Property: PHMin
			Gets the minumum PH that the sensor might return.
		*/
		public function get PHMin():Number{
			if(phMin == com.phidgets.Constants.PUNK_NUM || phMin == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return phMin;
		}
		/*
			Property: PHMax
			Gets the maximum PH that the sensor might return
		*/
		public function get PHMax():Number{
			if(phMax == com.phidgets.Constants.PUNK_NUM || phMax == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return phMax;
		}
		/*
			Property: Potential
			Gets the potential (mV) being measured by the board.
		*/
		public function get Potential():Number{
			if(potential == com.phidgets.Constants.PUNK_NUM || potential == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return potential;
		}
		/*
			Property: PotentialMin
			Gets the minimum potential that might be returned.
		*/
		public function get PotentialMin():Number{
			if(potentialMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return potentialMin;
		}
		/*
			Property: PotentialMax
			Gets the maximum potential that might be returned.
		*/
		public function get PotentialMax():Number{
			if(potentialMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return potentialMax;
		}
		/*
			Property: PHChangeTrigger
			Gets the change trigger for PH.
		*/
		public function get PHChangeTrigger():Number{
			if(phTrigger == com.phidgets.Constants.PUNK_NUM || phTrigger == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return phTrigger;
		}
		
		//Setters
		/*
			Property: PHChangeTrigger
			Sets the change trigger for PH.
			
			Parameters:
				val - change trigger
		*/
		public function set PHChangeTrigger(val:Number):void{ 
			_phidgetSocket.setKey(makeKey("Trigger"), val.toString(), true);
		}
		/*
			Property: Temperature
			Sets the temperature used for internal PH calculations.
			
			Parameters:
				val - temperature
		*/
		public function set Temperature(val:Number):void{ 
			_phidgetSocket.setKey(makeKey("Temperature"), val.toString(), true);
		}
	}
}