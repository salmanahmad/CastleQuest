package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetStepper
		A class for controlling a PhidgetStepper.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetStepper.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE		- digital input change
		PhidgetDataEvent.VELOCITY_CHANGE	- velocity change
		PhidgetDataEvent.POSITION_CHANGE	- position change
		PhidgetDataEvent.CURRENT_CHANGE		- current change
	*/
	public class PhidgetStepper extends Phidget
	{
		private var numMotors:int;
		private var numInputs:int;
		private var positionMin:Number;
		private var positionMax:Number;
		private var accelerationMin:Number;
		private var accelerationMax:Number;
		private var velocityMin:Number;
		private var velocityMax:Number;
		private var currentMin:Number;
		private var currentMax:Number;
		
		private var velocities:Array;
		private var velocityLimits:Array;
		private var accelerations:Array;
		private var currents:Array;
		private var currentLimits:Array;
		private var currentPositions:Array;
		private var targetPositions:Array;
		private var inputs:Array;
		private var motorEngagedState:Array;
		private var motorStoppedState:Array;
		
		public function PhidgetStepper(){
			super("PhidgetStepper");
		}
		
		override protected function initVars():void{
			numMotors = com.phidgets.Constants.PUNK_INT;
			numInputs = com.phidgets.Constants.PUNK_INT;
			positionMin = com.phidgets.Constants.PUNK_NUM;
			positionMax = com.phidgets.Constants.PUNK_NUM;
			accelerationMin = com.phidgets.Constants.PUNK_NUM;
			accelerationMax = com.phidgets.Constants.PUNK_NUM;
			velocityMin = com.phidgets.Constants.PUNK_NUM;
			velocityMax = com.phidgets.Constants.PUNK_NUM;
			currentMin = com.phidgets.Constants.PUNK_NUM;
			currentMax = com.phidgets.Constants.PUNK_NUM;
			velocities = new Array(8);
			velocityLimits = new Array(8);
			accelerations = new Array(8);
			currents = new Array(8);
			currentLimits = new Array(8);
			currentPositions = new Array(8);
			targetPositions = new Array(8);
			inputs = new Array(8);
			motorEngagedState = new Array(8);
			motorStoppedState = new Array(8);
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
				case "PositionMin":
					positionMin = Number(value);
					keyCount++;
					break;
				case "PositionMax":
					positionMax = Number(value);
					keyCount++;
					break;
				case "VelocityMin":
					velocityMin = Number(value);
					keyCount++;
					break;
				case "VelocityMax":
					velocityMax = Number(value);
					keyCount++;
					break;
				case "CurrentMin":
					currentMin = Number(value);
					keyCount++;
					break;
				case "CurrentMax":
					currentMax = Number(value);
					keyCount++;
					break;
				case "Input":
					if(inputs[index] == undefined)
						keyCount++;
					inputs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[index]),index));
					break;
				case "CurrentPosition":
					if(currentPositions[index] == undefined)
						keyCount++;
					currentPositions[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,Number(currentPositions[index]),index));
					break;
				case "TargetPosition":
					if(targetPositions[index] == undefined)
						keyCount++;
					targetPositions[index] = value;
					break;
				case "Acceleration":
					accelerations[index] = value;
					break;
				case "CurrentLimit":
					currentLimits[index] = value;
					break;
				case "Current":
					if(currents[index] == undefined)
						keyCount++;
					currents[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE,this,Number(currents[index]),index));
					break;
				case "VelocityLimit":
					velocityLimits[index] = value;
					break;
				case "Velocity":
					if(velocities[index] == undefined)
						keyCount++;
					velocities[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,Number(velocities[index]),index));
					break;
				case "Engaged":
					if(motorEngagedState[index] == undefined)
						keyCount++;
					motorEngagedState[index] = value;
					break;
				case "Stopped":
					if(motorStoppedState[index] == undefined)
						keyCount++;
					motorStoppedState[index] = value;
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
				if(isKnown(currentPositions, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,Number(currentPositions[i]),i));
				if(isKnown(velocities, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,Number(velocities[i]),i));
				if(isKnown(currents, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE,this,Number(currents[i]),i));
			}
		}
		
		//Getters
		/*
			Property: InputCount
			Gets the number of digital inputs available on this controller.
			
			Returns:
				The number of digital inputs.
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
			Gets the minimum settable acceleration for a motor.
			
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
			Gets the maximum settable acceleration for a motor
			
			Parameters:
				index - motor index
		*/
		public function getAccelerationMax(index:int):Number{
			if(accelerationMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMax;
		}
		/*
			Function: getPositionMin
			Gets the minimum position that a motor can travel to.
			
			Parameters:
				index - motor index
		*/
		public function getPositionMin(index:int):Number{
			if(positionMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return positionMin;
		}
		/*
			Function: getPositionMax
			Gets the maximum position that a motor can travel to.
			
			Parameters:
				index - motor index
		*/
		public function getPositionMax(index:int):Number{
			if(positionMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return positionMax;
		}
		/*
			Function: getVelocityMin
			Gets the minimum velocity that a motor can be set to.
			Note that the minimum velocity that a motor can return is -(velocityMax)
			
			Parameters:
				index - motor index
		*/
		public function getVelocityMin(index:int):Number{
			if(velocityMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return velocityMin;
		}
		/*
			Function: getVelocityMax
			Gets the maximum velocity that a motor can be set to or return.
			
			Parameters:
				index - motor index
		*/
		public function getVelocityMax(index:int):Number{
			if(velocityMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return velocityMax;
		}
		/*
			Function: getCurrentMin
			Gets the minimum settable current limit for a motor.
			Note that current limit is not supported on all stepper controllers.
			
			Parameters:
				index - motor index
		*/
		public function getCurrentMin(index:int):Number{
			if(velocityMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return currentMin;
		}
		/*
			Function: getCurrentMax
			Gets the maximum settable current limit for a motor.
			Note that current limit is not supported on all stepper controllers.
			
			Parameters:
				index - motor index
		*/
		public function getCurrentMax(index:int):Number{
			if(velocityMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return currentMax;
		}
		/*
			Function: getInputState
			Gets the state of a digital input.
			Note that not all stepper controllers have digital inputs.
			
			Parameters:
				index - input index
		*/
		public function getInputState(index:int):Boolean{
			return intToBool(int(indexArray(inputs, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getAcceleration
			Gets the last set acceleration for a motor.
			
			Parameters:
				index - motor index
		*/
		public function getAcceleration(index:int):Number{
			return Number(indexArray(accelerations, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getVelocity
			Gets the current velocity for a motor.
			
			Parameters:
				index - motor index
		*/
		public function getVelocity(index:int):Number{
			return Number(indexArray(velocities, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getVelocityLimit
			Gets the last set velocity limit for a motor.
			
			Parameters:
				index - motor index
		*/
		public function getVelocityLimit(index:int):Number{
			return Number(indexArray(velocityLimits, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getCurrentLimit
			Gets the last set current limit for a motor.
			Note that current limit is not supported by all stepper controllers.
			
			Parameters:
				index - motor index
		*/
		public function getCurrentLimit(index:int):Number{
			return Number(indexArray(currentLimits, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getCurrent
			Gets the current current draw for a motor.
			Note that current sense is not supported by all stepper controllers.
			
			Parameters:
				index - motor index
		*/
		public function getCurrent(index:int):Number{
			return Number(indexArray(currents, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getCurrentPosition
			Gets the current position of a motor.
			
			Parameters:
				index - motor index
		*/
		public function getCurrentPosition(index:int):Number{
			return Number(indexArray(currentPositions, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getTargetPosition
			Gets the last set target position.
			
			Parameters:
				index - motor index
		*/
		public function getTargetPosition(index:int):Number{
			return Number(indexArray(targetPositions, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getEngaged
			Gets the engaged state of a motor. This is whether or not the motor is powered.
			
			Parameters:
				index - motor index
		*/
		public function getEngaged(index:int):Boolean{
			return intToBool(int(indexArray(motorEngagedState, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getStopped
			Gets the stopped state of a motor. If this is true, it indicates that the motor is not moving, and there are no outstanding commands.
			
			Parameters:
				index - motor index
		*/
		public function getStopped(index:int):Boolean{
			return intToBool(int(indexArray(motorStoppedState, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
		}
		
		//Setters
		/*
			Function: setAcceleration
			Sets the acceleration for a motor. The motor will accelerate and decelerate at this rate.
			
			Parameters:
				index - motor index
				val - acceleration
		*/
		public function setAcceleration(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Acceleration", index, numMotors), val.toString(), true);
		}
		/*
			Function: setVelocityLimit
			Sets the upper velocity limit for a motor.
			
			Parameters:
				index - motor index
				val - velocity
		*/
		public function setVelocityLimit(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("VelocityLimit", index, numMotors), val.toString(), true);
		}
		/*
			Function: setCurrentPosition
			Sets the current position of a motor. This will not move the motor and should not be called if a motor is moving.
			
			Parameters:
				index - motor index
				val - current motor position
		*/
		public function setCurrentPosition(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("CurrentPosition", index, numMotors), val.toString(), true);
		}
		/*
			Function: setTargetPosition
			Sets a new target position for a motor. The motor will immediately start moving towards this position.
			
			Parameters:
				index - motor index
				val - target motor position
		*/
		public function setTargetPosition(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("TargetPosition", index, numMotors), val.toString(), true);
		}
		/*
			Function: setCurrentLimit
			Sets the upper current limit for a motor.
			Note that not all stepper controllers support current limit.
			
			Parameters:
				index - motor index
				val - current limit
		*/
		public function setCurrentLimit(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("CurrentLimit", index, numMotors), val.toString(), true);
		}
		/*
			Function: setEngaged
			Sets the engaged state of a motor. This determines whether a motor is powered or not.
			
			Parameters:
				index - motor index
				val - engaged state
		*/
		public function setEngaged(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Engaged", index, numMotors), boolToInt(val).toString(), true);
		}
	}
}