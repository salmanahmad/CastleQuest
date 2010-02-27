package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetServo
		A class for controlling a PhidgetServo.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetServo. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.POSITION_CHANGE	- position change
	*/
	public class PhidgetServo extends Phidget
	{
		private var numServos:int;
		private var positionMinLimit:Number;
		private var positionMaxLimit:Number;
		
		private var positions:Array;
		private var positionMin:Array;
		private var positionMax:Array;
		private var motorEngagedState:Array;
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
		
		public function PhidgetServo(){
			super("PhidgetServo");
		}
		
		override protected function initVars():void{
			positionMinLimit = com.phidgets.Constants.PUNK_NUM;
			positionMaxLimit = com.phidgets.Constants.PUNK_NUM;
			numServos = com.phidgets.Constants.PUNK_INT;
			positions = new Array(4);
			positionMin = new Array(4);
			positionMax = new Array(4);
			motorEngagedState = new Array(4);
			servoParameters = new Array(8);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfMotors":
					numServos = int(value);
					keyCount++;
					break;
				case "PositionMinLimit":
					positionMinLimit = Number(value);
					keyCount++;
					break;
				case "PositionMaxLimit":
					positionMaxLimit = Number(value);
					keyCount++;
					break;
				case "Engaged":
					if(motorEngagedState[index] == undefined)
						keyCount++;
					motorEngagedState[index] = value;
					break;
				case "Position":
					if(positions[index] == undefined)
						keyCount++;
					positions[index] = Number(value);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,PhidgetServoParameters(servoParameters[index]).usToDegrees(Number(positions[index])),index));
					break;
				case "ServoParameters":
					if(servoParameters[index] == undefined) 
						keyCount++;
					var paramData:Array = value.split(",");
					servoParameters[index] = new PhidgetServoParameters(paramData[0], paramData[1], paramData[2], paramData[3], 0);
					if(paramData[1] > positionMaxLimit)
						positionMax[index] = positionMaxLimit;
					else
						positionMax[index] = paramData[1];
					positionMin[index] = paramData[0];
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			for(var i:int = 0; i<numServos; i++)
			{
				if(isKnown(positions, i, com.phidgets.Constants.PUNK_NUM))
				{
					var posn:Number = PhidgetServoParameters(servoParameters[i]).usToDegrees(Number(positions[i]));
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,posn,i));
				}
			}
		}
		
		//Getters
		/*
			Property: MotorCount
			Gets the number of motors supported by this controller.
		*/
		public function get MotorCount():int{
			if(numServos == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numServos;
		}
		/*
			Function: getPosition
			Gets the current position of a motor.
			
			Parameters:
				index - motor index
		*/
		public function getPosition(index:int):Number{
			return PhidgetServoParameters(servoParameters[index]).usToDegrees(Number(indexArray(positions, index, numServos, com.phidgets.Constants.PUNK_NUM)));
		}
		/*
			Function: getEngaged
			Gets the engaged (powered) state of a motor.
			
			Parameters:
				index - motor index
		*/
		public function getEngaged(index:int):Boolean{
			return intToBool(int(indexArray(motorEngagedState, index, numServos, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getPositionMin
			Gets the minimum position supported by a motor
			
			Parameters:
				index - motor index
		*/
		public function getPositionMin(index:int):Number{
			if(positionMin[index] == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return PhidgetServoParameters(servoParameters[index]).usToDegrees(positionMin[index]);
		}
		/*
			Function: getPositionMax
			Gets the maximum position supported by a motor.
			
			Parameters:
				index - motor index
		*/
		public function getPositionMax(index:int):Number{
			if(positionMax[index] == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return PhidgetServoParameters(servoParameters[index]).usToDegrees(positionMax[index]);
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
			Function: setPosition
			Sets the position of a motor. If the motor is not engaged, this will engage it.
			
			Parameters:
				index - motor index
				val - position
		*/
		public function setPosition(index:int, val:Number):void{ 
			val = PhidgetServoParameters(servoParameters[index]).degreesToUs(val);
			_phidgetSocket.setKey(makeIndexedKey("Position", index, numServos), val.toString(), true);
		}
		/*
			Function: setEngaged
			Sets the engaged (powered) state of a motor.
			
			Parameters:
				index - motor index
				val - engaged state
		*/
		public function setEngaged(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Engaged", index, numServos), boolToInt(val).toString(), true);
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
		*/
		public function setServoParameters(index:int, minUs:Number, maxUs:Number, degrees:Number):void
		{
			setupServoParams(index, new PhidgetServoParameters(PHIDGET_SERVO_USER_DEFINED, minUs, maxUs, (maxUs - minUs)/degrees, 0));
		}
		
		private function setupServoParams(index:int, params:PhidgetServoParameters):void
		{
			if(params.servoType == PHIDGET_SERVO_RAW_us_MODE)
				positionMinLimit = 0;
			else
				positionMinLimit = 1/12.0;
				
			if(params.maxUs > positionMaxLimit)
				positionMax[index] = positionMaxLimit;
			else
				positionMax[index] = params.maxUs;
			positionMin[index] = params.minUs;
				
			_phidgetSocket.setKey(makeIndexedKey("ServoParameters", index, numServos), params.toString(), true);
			servoParameters[index] = params;
		}
	}
}