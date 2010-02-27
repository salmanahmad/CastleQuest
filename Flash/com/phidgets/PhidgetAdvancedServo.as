package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetAdvancedServo
		A class for controlling a PhidgetAdvancedServo.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetAdvancedServo.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.VELOCITY_CHANGE	- velocity change
		PhidgetDataEvent.POSITION_CHANGE	- position change
		PhidgetDataEvent.CURRENT_CHANGE		- current change
	*/
	public class PhidgetAdvancedServo extends Phidget
	{
		private var numMotors:int;
		private var accelerationMin:Number;
		private var accelerationMax:Number;
		private var velocityMin:Number;
		private var velocityMaxLimit:Number;
		private var positionMinLimit:Number;
		private var positionMaxLimit:Number;
		
		private var velocities:Array;
		private var velocityMax:Array;
		private var maxVelocities:Array;
		private var accelerations:Array;
		private var currents:Array;
		private var motorEngagedState:Array;
		private var speedRampingState:Array;
		private var positions:Array;
		private var positionMin:Array;
		private var positionMax:Array;
		private var stopped:Array;
		private var servoParameters:Array
		
		/*
			Constants: Servo Types
			These are the some predefined servo motors. Setting one of these will set degree-PCM ratio, min and max angle, and max velocity.
			Custom servo parameters can be set with the setServoParameters function.
			
			PHIDGET_SERVO_DEFAULT - Default - This is what the servo API been historically used, originally based on the Futaba FP-S148
			PHIDGET_SERVO_RAW_us_MODE - Raw us mode - all position, velocity, acceleration functions are specified in microseconds rather then degrees
			PHIDGET_SERVO_HITEC_HS322HD - HiTec HS-322HD Standard Servo
			PHIDGET_SERVO_HITEC_HS5245MG - HiTec HS-5245MG Digital Mini Servo
			PHIDGET_SERVO_HITEC_805BB - HiTec HS-805BB Mega Quarter Scale Servo
			PHIDGET_SERVO_HITEC_HS422 - HiTec HS-422 Standard Servo
			PHIDGET_SERVO_TOWERPRO_MG90 - Tower Pro MG90 Micro Servo
			PHIDGET_SERVO_HITEC_HSR1425CR - HiTec HSR-1425CR Continuous Rotation Servo
			PHIDGET_SERVO_HITEC_HS785HB - HiTec HS-785HB Sail Winch Servo
			PHIDGET_SERVO_HITEC_HS485HB - HiTec HS-485HB Deluxe Servo
			PHIDGET_SERVO_HITEC_HS645MG - HiTec HS-645MG Ultra Torque Servo
			PHIDGET_SERVO_HITEC_815BB - HiTec HS-815BB Mega Sail Servo
			PHIDGET_SERVO_USER_DEFINED - User defined servo parameters
			
		*/
		public static const PHIDGET_SERVO_DEFAULT:int = 1;
		public static const PHIDGET_SERVO_RAW_us_MODE:int = 2;
		public static const PHIDGET_SERVO_HITEC_HS322HD:int = 3;
		public static const PHIDGET_SERVO_HITEC_HS5245MG:int = 4;
		public static const PHIDGET_SERVO_HITEC_805BB:int = 5;
		public static const PHIDGET_SERVO_HITEC_HS422:int = 6;
		public static const PHIDGET_SERVO_TOWERPRO_MG90:int = 7;
		public static const PHIDGETCOM_SERVO_HITEC_HSR1425CR:int = 8;
		public static const PHIDGETCOM_SERVO_HITEC_HS785HB:int = 9;
		public static const PHIDGETCOM_SERVO_HITEC_HS485HB:int = 10;
		public static const PHIDGETCOM_SERVO_HITEC_HS645MG:int = 11;
		public static const PHIDGETCOM_SERVO_HITEC_815BB:int = 12;
		public static const PHIDGET_SERVO_USER_DEFINED:int = 13;
		
		
		public function PhidgetAdvancedServo(){
			super("PhidgetAdvancedServo");
		}
		
		override protected function initVars():void{
			numMotors = com.phidgets.Constants.PUNK_INT;
			positionMinLimit = com.phidgets.Constants.PUNK_NUM;
			positionMaxLimit = com.phidgets.Constants.PUNK_NUM;
			accelerationMin = com.phidgets.Constants.PUNK_NUM;
			accelerationMax = com.phidgets.Constants.PUNK_NUM;
			velocityMin = com.phidgets.Constants.PUNK_NUM;
			velocityMaxLimit = com.phidgets.Constants.PUNK_NUM;
			velocities = new Array(8);
			accelerations = new Array(8);
			currents = new Array(8);
			velocityMax = new Array(8);
			maxVelocities = new Array(8);
			motorEngagedState = new Array(8);
			speedRampingState = new Array(8);
			positions = new Array(8);
			positionMin = new Array(8);
			positionMax = new Array(8);
			stopped = new Array(8);
			servoParameters = new Array(8);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfMotors":
					numMotors = int(value);
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
					if(positionMin[index] == undefined) 
						keyCount++;
					positionMin[index] = Number(value);
					break;
				case "PositionMax":
					if(positionMax[index] == undefined) 
						keyCount++;
					positionMax[index] = Number(value);
					break;
				case "PositionMinLimit":
					positionMinLimit = Number(value);
					keyCount++;
					break;
				case "PositionMaxLimit":
					positionMaxLimit = Number(value);
					keyCount++;
					break;
				case "VelocityMin":
					velocityMin = Number(value);
					keyCount++;
					break;
				case "VelocityMaxLimit":
					velocityMaxLimit = Number(value);
					keyCount++;
					break;
				case "VelocityMax":
					if(velocityMax[index] == undefined) 
						keyCount++;
					velocityMax[index] = value;
					break;
				case "Position":
					if(positions[index] == undefined) 
						keyCount++;
					positions[index] = value;
					if(isAttached)
					{
						var posn:Number = PhidgetServoParameters(servoParameters[index]).usToDegrees(Number(positions[index]));
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,posn,index));
					}
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
				case "Engaged":
					if(motorEngagedState[index] == undefined) 
						keyCount++;
					motorEngagedState[index] = value;
					break;
				case "Stopped":
					if(stopped[index] == undefined) 
						keyCount++;
					stopped[index] = value;
					break;
				case "SpeedRampingOn":
					if(speedRampingState[index] == undefined) 
						keyCount++;
					speedRampingState[index] = value;
					break;
				case "VelocityLimit":
					maxVelocities[index] = value;
					break;
				case "Velocity":
					if(velocities[index] == undefined) 
						keyCount++;
					velocities[index] = value;
					if(isAttached)
					{
						var vel:Number = PhidgetServoParameters(servoParameters[index]).usToDegrees(Number(velocities[index]));
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,vel,index));
					}
					break;
				case "ServoParameters":
					if(servoParameters[index] == undefined) 
						keyCount++;
					var paramData:Array = value.split(",");
					servoParameters[index] = new PhidgetServoParameters(paramData[0], paramData[1], paramData[2], paramData[3], paramData[4]);
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			for(var i:int = 0; i<numMotors; i++)
			{
				if(isKnown(positions, i, com.phidgets.Constants.PUNK_NUM))
				{
					var posn:Number = PhidgetServoParameters(servoParameters[i]).usToDegrees(Number(positions[i]));
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,posn,i));
				}
				if(isKnown(velocities, i, com.phidgets.Constants.PUNK_NUM))
				{
					var vel:Number = PhidgetServoParameters(servoParameters[i]).usToDegrees(Number(velocities[i]));
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,vel,i));
				}
				if(isKnown(currents, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE,this,Number(currents[i]),i));
			}
		}
		
		//Getters
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
			var val:Number = PhidgetServoParameters(servoParameters[index]).usToDegreesVel(accelerationMin);
			return val;
		}
		/*
			Function: getAccelerationMax
			Gets the maximum settable acceleration for a motor.
			
			Parameters:
				index - motor index
		*/
		public function getAccelerationMax(index:int):Number{
			if(accelerationMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			var val:Number = PhidgetServoParameters(servoParameters[index]).usToDegreesVel(accelerationMax);
			return val;
		}
		/*
			Function: getPositionMin
			Gets the minimum position that a motor can go to.
			
			Parameters:
				index - motor index 
		*/
		public function getPositionMin(index:int):Number{
			if(positionMin[index] == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			var val:Number = PhidgetServoParameters(servoParameters[index]).usToDegrees(positionMin[index]);
			return val;
		}
		/*
			Function: getPositionMax
			Gets the maximum position that a motor can go to.
			
			Paramters:
				index - motor index
		*/
		public function getPositionMax(index:int):Number{
			if(positionMax[index] == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			var val:Number = PhidgetServoParameters(servoParameters[index]).usToDegrees(positionMax[index]);
			return val;
		}
		/*
			Function: getVelocityMin
			Gets the minimum velocity that a motor can be set to.
			
			parameters:
				index - motor index
		*/
		public function getVelocityMin(index:int):Number{
			if(velocityMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			var val:Number = PhidgetServoParameters(servoParameters[index]).usToDegreesVel(velocityMin);
			return val;
		}
		/*
			Function: getVelocityMax
			Gets the maximum velocity that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
		public function getVelocityMax(index:int):Number{
			if(velocityMax[index] == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			var val:Number = PhidgetServoParameters(servoParameters[index]).usToDegreesVel(velocityMax[index]);
			return val;
		}
		/*
			Function: getAcceleration
			Gets the last acceleration that a motor was set to.
			
			Parameters:
				index - motor index
		*/
		public function getAcceleration(index:int):Number{
			return PhidgetServoParameters(servoParameters[index]).usToDegreesVel(Number(indexArray(accelerations, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
		}
		/*
			Function: getVelocity
			Gets the current velocity of a motor
			
			Parameters:
				index - motor index
		*/
		public function getVelocity(index:int):Number{
			return PhidgetServoParameters(servoParameters[index]).usToDegreesVel(Number(indexArray(velocities, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
		}
		/*
			Function: getVelocityLimit
			Gets the last velocity limit that a motor was set to.
			
			Parameters:
				index - motor index
		*/
		public function getVelocityLimit(index:int):Number{
			return PhidgetServoParameters(servoParameters[index]).usToDegreesVel(Number(indexArray(maxVelocities, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
		}
		/*
			Function: getCurrent
			Gets the current current that a motor is drawing.
			
			Parameters:
				index - motor index
		*/
		public function getCurrent(index:int):Number{
			return Number(indexArray(currents, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getPosition
			Gets the current position of a motor.
			
			Parameters:
				index - motor index
		*/
		public function getPosition(index:int):Number{
			if(motorEngagedState[index] != true)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return PhidgetServoParameters(servoParameters[index]).usToDegrees(Number(indexArray(positions, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
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
			Gets the stopped state of a motor. This is whether or not the motor is moving/processing commands.
			
			Parameters:
				index - motor index
		*/
		public function getStopped(index:int):Boolean{
			return intToBool(int(indexArray(stopped, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getSpeedRampingOn
			Gets the speed ramping state of the motor. This is whether the motor used acceleration and velocity or not.
			
			Parameters:
				index - motor index
		*/
		public function getSpeedRampingOn(index:int):Boolean{
			return intToBool(int(indexArray(motorEngagedState, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getSpeedRampingOn
			Gets the speed ramping state of the motor. This is whether the motor used acceleration and velocity or not.
			
			Parameters:
				index - motor index
		*/
		public function getServoType(index:int):int{
			return PhidgetServoParameters(servoParameters[index]).servoType;
		}
		
		//Setters
		/*
			Function: setAcceleration
			Sets the acceleration of a motor.
			
			Parameters:
				index - motor index
				val - acceleration
		*/
		public function setAcceleration(index:int, val:Number):void{ 
			val = PhidgetServoParameters(servoParameters[index]).degreesToUsVel(val);
			_phidgetSocket.setKey(makeIndexedKey("Acceleration", index, numMotors), val.toString(), true);
		}
		/*
			Function: setVelocityLimit
			Sets the velocity limit of a motor.
			
			Parameters:
				index - motor index
				val - velocity limit
		*/
		public function setVelocityLimit(index:int, val:Number):void{ 
			val = PhidgetServoParameters(servoParameters[index]).degreesToUsVel(val);
			_phidgetSocket.setKey(makeIndexedKey("VelocityLimit", index, numMotors), val.toString(), true);
		}
		/*
			Function: setPosition
			Sets the position of a motor.
			
			Parameters:
				index - motor index
				val - motor position
		*/
		public function setPosition(index:int, val:Number):void{ 
			val = PhidgetServoParameters(servoParameters[index]).degreesToUs(val);
			_phidgetSocket.setKey(makeIndexedKey("Position", index, numMotors), val.toString(), true);
		}
		/*
			Function: setPositionMax
			Sets the maximum position that a motor can be set to.
			
			Parameters:
				index - motor index
				val - motor position
		*/
		public function setPositionMax(index:int, val:Number):void{ 
			val = PhidgetServoParameters(servoParameters[index]).degreesToUs(val);
			positionMax[index] = val;
			_phidgetSocket.setKey(makeIndexedKey("PositionMax", index, numMotors), val.toString(), true);
		}
		/*
			Function: setPositionMin
			Sets the minimum position that a motor can be set to.
			
			Parameters:
				index - motor index
				val - motor position
		*/
		public function setPositionMin(index:int, val:Number):void{ 
			val = PhidgetServoParameters(servoParameters[index]).degreesToUs(val);
			positionMin[index] = val;
			_phidgetSocket.setKey(makeIndexedKey("PositionMin", index, numMotors), val.toString(), true);
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
		/*
			Function: setSpeedRampingOn
			Sets the speed ramping state of a motor. This is whether the motor uses acceleration and velocity or not.
			
			Parameters:
				index - motor index
				val - speed ramping state
		*/
		public function setSpeedRampingOn(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("SpeedRampingOn", index, numMotors), boolToInt(val).toString(), true);
		}
		/*
			Function: setServoType
			Sets the servo type
			
			Parameters:
				index - motor index
				val - servoType
		*/
		public function setServoType(index:int, val:int):void
		{
			setupServoParams(index, PhidgetServoParameters.getServoParams(val));
		}
		/*
			Function: setServoParameters
			Sets the servo parameters
			
			Parameters:
				index - motor index
				minUs - minimum PCM in microseconds
				maxUs - maximum PCM in microseconds
				degrees - total range of motion in degrees
				velocityMax - maximum velocity of servo in degrees/second
		*/
		public function setServoParameters(index:int, minUs:Number, maxUs:Number, degrees:Number, velocityMax:Number):void
		{
			setupServoParams(index, new PhidgetServoParameters(PHIDGET_SERVO_USER_DEFINED, minUs, maxUs, (maxUs - minUs)/degrees, ((maxUs - minUs)/degrees)*velocityMax));
		}
		
		private function setupServoParams(index:int, params:PhidgetServoParameters):void
		{
			if(params.servoType == PHIDGET_SERVO_RAW_us_MODE)
				positionMinLimit = 0;
			else
				positionMinLimit = 1/12.0;
				
			velocityMax[index] = params.maxUsPerS;
		
			_phidgetSocket.setKey(makeIndexedKey("ServoParameters", index, numMotors), params.toString(), true);
			servoParameters[index] = params;
			
			if(maxVelocities[index] > velocityMax[index])
				setVelocityLimit(index, params.usToDegreesVel(velocityMax[index]));
				
			if(params.maxUs > positionMaxLimit)
				setPositionMax(index, params.usToDegrees(positionMaxLimit));
			else
				setPositionMax(index, params.usToDegrees(params.maxUs));
			
			setPositionMin(index, params.usToDegrees(params.minUs));
		}
	}
}
