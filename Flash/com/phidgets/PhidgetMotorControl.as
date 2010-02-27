package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetMotorControl
		A class for controlling a PhidgetMotorControl.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetMotorControl.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE		- digital input change
		PhidgetDataEvent.VELOCITY_CHANGE	- velocity change
		PhidgetDataEvent.CURRENT_CHANGE		- current change
	*/
	public class PhidgetMotorControl extends Phidget
	{
		private var numMotors:int;
		private var numInputs:int;
		private var accelerationMin:Number;
		private var accelerationMax:Number;
		
		private var velocities:Array;;
		private var accelerations:Array;
		private var currents:Array;
		private var inputs:Array;
		
		public function PhidgetMotorControl(){
			super("PhidgetMotorControl");
		}
		
		override protected function initVars():void{
			numMotors = com.phidgets.Constants.PUNK_INT;
			numInputs = com.phidgets.Constants.PUNK_INT;
			accelerationMin = com.phidgets.Constants.PUNK_NUM;
			accelerationMax = com.phidgets.Constants.PUNK_NUM;
			inputs = new Array(4);
			velocities = new Array(2);
			accelerations = new Array(2);
			currents = new Array(2);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfMotors":
					numMotors = int(value);
					keyCount++;
					break;
				case "NumberOfInputs":
					numInputs = int(value);
					keyCount++;
					break;
				case "AccelerationMin":
					accelerationMin = Number(value);
					keyCount++;
					break;
				case "AccelerationMax":
					accelerationMax = Number(value);
					keyCount++;
					break;
				case "Input":
					if(inputs[index] == undefined)
						keyCount++;
					inputs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[index]),index));
					break;
				case "Velocity":
					if(velocities[index] == undefined)
						keyCount++;
					velocities[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,Number(velocities[index]),index));
					break;
				case "Acceleration":
					accelerations[index] = value;
					break;
				case "Current":
					if(currents[index] == undefined)
						keyCount++;
					currents[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE,this,Number(currents[index]),index));
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			var i:int = 0
			for(i = 0; i<numInputs; i++)
			{
				if(isKnown(inputs, i, com.phidgets.Constants.PUNK_BOOL))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[i]),i));
			}
			for(i = 0; i<numMotors; i++)
			{
				if(isKnown(velocities, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,Number(velocities[i]),i));
				if(isKnown(currents, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE,this,Number(currents[i]),i));
			}
		}
		
		//Getters
		/*
			Property: InputCount
			Gets the number of digital inputs supported by this controller.
		*/
		public function get InputCount():int{
			if(numInputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numInputs;
		}
		/*
			Property: MotorCount
			Gets the number of motors supported by this controller.
		*/
		public function get MotorCount():int{
			if(numMotors == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numMotors;
		}
		/*
			Function: getAccelerationMin
			Gets the minimum acceleration that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
		public function getAccelerationMin(index:int):Number{
			if(accelerationMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMin;
		}
		/*
			Function: getAccelerationMax
			Gets the maximum acceleration that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
		public function getAccelerationMax(index:int):Number{
			if(accelerationMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMax;
		}
		/*
			Function: getInputState
			Gets the state of a digital input.
			
			Parameters:
				index - digital input index
		*/
		public function getInputState(index:int):Boolean{
			return intToBool(int(indexArray(inputs, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getAcceleration
			Gets the last acceleration that a motor was set at.
			
			Parameters:
				index - motor index
		*/
		public function getAcceleration(index:int):Number{
			return Number(indexArray(accelerations, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getVelocity
			Gets the current velocity of a motor.
			
			Parameters:
				index - motor index
		*/
		public function getVelocity(index:int):Number{
			return Number(indexArray(velocities, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getCurrent
			Gets the current current draw of a motor.
			Note that not all motor controllers support current sense.
			
			Parameters:
				index - motor index
		*/
		public function getCurrent(index:int):Number{
			return Number(indexArray(currents, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		
		//Setters
		/*
			Function: setAcceleration
			Sets the acceleration for a motor.
			
			Parameters:
				index - motor index
				val - acceleraion
		*/
		public function setAcceleration(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Acceleration", index, numMotors), val.toString(), true);
		}
		/*
			Function: setVelocity
			Sets the velocity for a motor.
			
			Parameters:
				index - motor index
				val - velocity
		*/
		public function setVelocity(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Velocity", index, numMotors), val.toString(), true);
		}
	}
}