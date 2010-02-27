package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetWeightSensor
		A class for controlling a PhidgetWeightSensor.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetWeightSensor. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.WEIGHT_CHANGE	- weight change
	*/
	public class PhidgetWeightSensor extends Phidget
	{
		private var weight:Number;
		private var weightTrigger:Number;
		
		public function PhidgetWeightSensor(){
			super("PhidgetWeightSensor");
		}
		
		override protected function initVars():void{
			weight = com.phidgets.Constants.PUNI_NUM;
			weightTrigger = com.phidgets.Constants.PUNI_NUM;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "Weight":
					if(weight == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					weight = Number(value);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.WEIGHT_CHANGE,this,weight));
					break;
				case "Trigger":
					if(weightTrigger == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					weightTrigger = Number(value);
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			if(weight != com.phidgets.Constants.PUNK_NUM)
				dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.WEIGHT_CHANGE,this,weight));
		}
		
		//Getters
		/*
			Property: Weight
			Gets the currently sensed weight.
		*/
		public function get Weight():Number{
			if(weight == com.phidgets.Constants.PUNK_NUM || weight == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return weight;
		}
		/*
			Property: WeightChangeTrigger
			Gets the weight change trigger.
		*/
		public function get WeightChangeTrigger():Number{
			if(weightTrigger == com.phidgets.Constants.PUNK_NUM || weightTrigger == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return weightTrigger;
		}
		
		//Setters
		/*
			Property: WeightChangeTrigger
			Sets the weight change trigger.
			
			Parameters:
				val - change trigger
		*/
		public function set WeightChangeTrigger(val:Number):void{ 
			_phidgetSocket.setKey(makeKey("Trigger"), val.toString(), true);
		}
	}
}