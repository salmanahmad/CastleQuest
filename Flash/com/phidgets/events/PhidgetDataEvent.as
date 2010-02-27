package com.phidgets.events
{
	import com.phidgets.Phidget;
	import com.phidgets.PhidgetError;
	import com.phidgets.Constants;
	import flash.events.Event;
	import flash.accessibility.Accessibility;
	
	/*
		Class: PhidgetDataEvent
		A class for data events from Phidget boards.
	*/
	public class PhidgetDataEvent extends PhidgetEvent
	{
		/*
			Constants: Data Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			ACCELERATION_CHANGE	-	An acceleration changed. Used by <PhidgetAccelerometer>.
			CURRENT_CHANGE		-	A current changed. Used by <PhidgetAdvancedServo>, <PhidgetMotorControl> and <PhidgetStepper>.
			INPUT_CHANGE		-	A digital input changed. Used by <PhidgetEncoder>, <PhidgetInterfaceKit>, <PhidgetMotorControl> and <PhidgetStepper>.
			OUTPUT_CHANGE		-	A digital output changed. Used by <PhidgetInterfaceKit> and <PhidgetRFID>.
			PH_CHANGE			-	A PH changed. Used by <PhidgetPHSensor>.
			POSITION_CHANGE		-	A position changed.	Used by <PhidgetAdvancedServo>, <PhidgetEncoder>, <PhidgetServo> and <PhidgetStepper>.
			SENSOR_CHANGE		-	An analog input changed. Used by <PhidgetInterfaceKit>.
			TAG					-	An RFID tag was detected. Used by <PhidgetRFID>.
			TAG_LOST			-	An RFID tag was removed. Used by <PhidgetRFID>.
			TEMPERATURE_CHANGE	-	A temperature changed. Used by <PhidgetTemperatureSensor>.
			VELOCITY_CHANGE		-	A velocity changed. Used by <PhidgetAdvancedServo>, <PhidgetMotorControl> and <PhidgetStepper>.
			WEIGHT_CHANGE		-	A weight changed. Used by <PhidgetWeightSensor>.
		*/
		
	//Multiple
		public static const INPUT_CHANGE	:String = "inputChange";
		public static const OUTPUT_CHANGE	:String = "outputChange";
		public static const POSITION_CHANGE	:String = "positionChange";
		public static const CURRENT_CHANGE 	:String = "currentChange";
		public static const VELOCITY_CHANGE	:String = "velocityChange";
	//Accelerometer
		public static const ACCELERATION_CHANGE	:String = "accelearaionChange";
	//AdvancedServo
		//public static const POSITION_CHANGE	:String = "positionChange";
		//public static const CURRENT_CHANGE 	:String = "currentChange";
		//public static const VELOCITY_CHANGE	:String = "velocityChange";
	//Encoder
		//public static const POSITION_CHANGE	:String = "positionChange";
		//public static const INPUT_CHANGE	:String = "inputChange";
	//InterfaceKit
		public static const SENSOR_CHANGE	:String = "sensorChange";
		//public static const INPUT_CHANGE	:String = "inputChange";
		//public static const OUTPUT_CHANGE	:String = "outputChange";
	//LED
	//MotorControl
		//public static const CURRENT_CHANGE 	:String = "currentChange";
		//public static const VELOCITY_CHANGE	:String = "velocityChange";
		//public static const INPUT_CHANGE	:String = "inputChange";
	//PHSensor
		public static const PH_CHANGE		:String = "phChange";
	//RFID
		public static const TAG				:String	= "tag";
		public static const TAG_LOST		:String	= "tagLost";
		//public static const OUTPUT_CHANGE	:String = "outputChange";
	//Servo
		//public static const POSITION_CHANGE	:String = "positionChange";
	//Stepper
		//public static const INPUT_CHANGE	:String = "inputChange";
		//public static const POSITION_CHANGE	:String = "positionChange";
		//public static const CURRENT_CHANGE 	:String = "currentChange";
		//public static const VELOCITY_CHANGE	:String = "velocityChange";
	//TemperatureSensor
		public static const TEMPERATURE_CHANGE	:String = "temperatureChange";
	//TextLCD
	//TextLED
	//WeightSensor
		public static const WEIGHT_CHANGE	:String = "weightChange";
		
		private var _data:Object;
		private var _index:int = -1;
		
		public function PhidgetDataEvent (type:String,phidget:Phidget,data:Object,index:int=-1) {
			super(type, phidget);
			_data = data;
			_index = index;
		}
		
		override public function toString():String{
			if(_index == -1)
				return "[ Phidget Data Event: "+type+" to "+_data+" ]";
			else
				return "[ Phidget Data Event: "+type+" "+_index+" to "+_data+" ]";
		}
		
		/*
			Property: Index
			Gets the index for this event, for indexed events.
		*/
		public function get Index():int{ 
			if(_index == -1)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
			return _index;
		}
		/*
			Property: Data
			Gets the data for this event. This could be a Number, and Boolean or a String, depending on the event type.
		*/
		public function get Data():Object{ 
			return _data;
		}
	}
}