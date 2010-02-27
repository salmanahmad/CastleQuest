package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetAccelerometer
		A class for controlling a PhidgetAccelerometer.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetAccelerometer. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.ACCELERATION_CHANGE	- acceleration change
	*/
	public class PhidgetAccelerometer extends Phidget
	{
		private var numAxes:int;
		private var accelerationMin:Number;
		private var accelerationMax:Number;
		
		private var axes:Array;
		private var axisTriggers:Array;
		
		public function PhidgetAccelerometer(){
			super("PhidgetAccelerometer");
		}
		
		override protected function initVars():void{
			numAxes = com.phidgets.Constants.PUNK_INT;
			accelerationMin = com.phidgets.Constants.PUNK_NUM;
			accelerationMax = com.phidgets.Constants.PUNK_NUM;
			axes = new Array(3);
			axisTriggers = new Array(3);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfAxes":
					numAxes = int(value);
					keyCount++;
					break;
				case "Acceleration":
					if(axes[index] == undefined)
						keyCount++;
					axes[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.ACCELERATION_CHANGE,this,Number(axes[index]),index));
					break;
				case "AccelerationMin":
					accelerationMin = Number(value);
					keyCount++;
					break;
				case "AccelerationMax":
					accelerationMax = Number(value);
					keyCount++;
					break;
				case "Trigger":
					if(axisTriggers[index] == undefined)
						keyCount++;
					axisTriggers[index] = value;
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			for(var i:int = 0; i<numAxes; i++)
			{
				if(isKnown(axes, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.ACCELERATION_CHANGE,this,Number(axes[i]),i));
			}
		}
		
		//Getters
		/*
			Property: AxisCount
			Gets the number of axes on this accelerometer.
		*/
		public function get AxisCount():int{
			if(numAxes == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numAxes;
		}
		/*
			Function: getAcceleration
			Gets the acceleration of a axis.
			
			Parameters:
				index - acceleration axis
		*/
		public function getAcceleration(index:int):Number{
			return Number(indexArray(axes, index, numAxes, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getAccelerationMin
			Gets the minimum acceleration that an axis will return.
			
			Parameters:
				index - acceleration axis
		*/
		public function getAccelerationMin(index:int):Number{
			if(accelerationMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMin;
		}
		/*
			Function: getAccelerationMax
			Gets the maximum acceleration that an axis will return.
			
			Parameters:
				index - acceleration index
		*/
		public function getAccelerationMax(index:int):Number{
			if(accelerationMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMax;
		}
		/*
			Function: getAccelerationChangeTrigger
			Gets the change trigger for an axis.
			
			Parameters:
				index - acceleration axis
		*/
		public function getAccelerationChangeTrigger(index:int):Number{
			return Number(indexArray(axisTriggers, index, numAxes, com.phidgets.Constants.PUNK_NUM));
		}
		
		//Setters
		/*
			Function: setAccelerationChangeTrigger
			Sets the change trigger for an axis.
			
			Parameters:
				index - acceleration axis
				val - change trigger
		*/
		public function setAccelerationChangeTrigger(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Trigger", index, numAxes), val.toString(), true);
		}
	}
}