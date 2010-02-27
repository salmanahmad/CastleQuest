package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetInterfaceKit
		A class for controlling a PhidgetInterfaceKit.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetInterfaceKit. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE	- digital input change
		PhidgetDataEvent.OUTPUT_CHANGE	- output change
		PhidgetDataEvent.SENSOR_CHANGE	- sensor change
	*/
	public class PhidgetInterfaceKit extends Phidget
	{
		private var numSensors:int;
		private var numInputs:int;
		private var numOutputs:int;
		
		private var inputs:Array;
		private var outputs:Array;
		private var sensors:Array;
		private var sensorsRaw:Array;
		
		private var sensorTriggers:Array;
		
		private var ratiometric:int;
		
		public function PhidgetInterfaceKit(){
			super("PhidgetInterfaceKit");
		}
		
		override protected function initVars():void{
			numSensors = com.phidgets.Constants.PUNK_INT;
			numInputs = com.phidgets.Constants.PUNK_INT;
			numOutputs = com.phidgets.Constants.PUNK_INT;
			inputs = new Array(32);
			outputs = new Array(32);
			sensors = new Array(8);
			sensorsRaw = new Array(8);
			sensorTriggers = new Array(8);
			ratiometric = com.phidgets.Constants.PUNK_BOOL;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfSensors":
					numSensors = int(value);
					keyCount++;
					break;
				case "NumberOfInputs":
					numInputs = int(value);
					keyCount++;
					break;
				case "NumberOfOutputs":
					numOutputs = int(value);
					keyCount++;
					break;
				case "Input":
					if(inputs[index] == undefined) keyCount++;
					inputs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[index]),index));
					break;
				case "Output":
					if(outputs[index] == undefined) keyCount++;
					outputs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE,this,intToBool(outputs[index]),index));
					break;
				case "Sensor":
					if(sensors[index] == undefined) keyCount++;
					sensors[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SENSOR_CHANGE,this,int(sensors[index]),index));
					break;
				case "RawSensor":
					if(sensorsRaw[index] == undefined) keyCount++;
					sensorsRaw[index] = value;
					break;
				case "Trigger":
					if(sensorTriggers[index] == undefined) keyCount++;
					sensorTriggers[index] = value;
					break;
				case "Ratiometric":
					if(ratiometric == com.phidgets.Constants.PUNK_BOOL) keyCount++;
					ratiometric = int(value);
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			var i:int = 0
			for(i = 0; i<numSensors; i++)
			{
				if(isKnown(sensors, i, com.phidgets.Constants.PUNK_INT))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SENSOR_CHANGE,this,int(sensors[i]),i));
			}
			for(i = 0; i<numInputs; i++)
			{
				if(isKnown(inputs, i, com.phidgets.Constants.PUNK_BOOL))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[i]),i));
			}
			for(i = 0; i<numOutputs; i++)
			{
				if(isKnown(outputs, i, com.phidgets.Constants.PUNK_BOOL))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE,this,intToBool(outputs[i]),i));
			}
		}
		
		//Getters
		/*
			Property: InputCount
			Gets the number of digital inputs supported by this board.
		*/
		public function get InputCount():int{
			if(numInputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numInputs;
		}
		/*
			Property: OutputCount
			Gets the number of digital outputs supported by this board.
		*/
		public function get OutputCount():int{
			if(numOutputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numOutputs;
		}
		/*
			Property: SensorCount
			Gets the number of sensors (analog inputs) supported by this board
		*/
		public function get SensorCount():int{
			if(numSensors == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numSensors;
		}
		/*
			Property: Ratiometric
			Gets the ratiometric state for the board.
			Note that not all Interface Kits support Ratiometric.
		*/
		public function get Ratiometric():Boolean{
			if(ratiometric == com.phidgets.Constants.PUNK_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(ratiometric);
		}
		/*
			Property: Ratiometric
			Sets the ratiometric state for a board.
			Note that not all Interface Kits support ratiometric.
			
			Parameters:
				val - ratiometric state
		*/
		public function set Ratiometric(val:Boolean):void{ 
			_phidgetSocket.setKey(makeKey("Ratiometric"), boolToInt(val).toString(), true);
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
			Function: getOutputState
			Gets the state of a digital output.
			
			Parameters:
				index - digital output index
		*/
		public function getOutputState(index:int):Boolean{
			return intToBool(int(indexArray(outputs, index, numOutputs, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getSensorValue
			Gets the value of a sensor (0-1000).
			
			Parameters:
				index - sensor index
		*/
		public function getSensorValue(index:int):int{
			return int(indexArray(sensors, index, numSensors, com.phidgets.Constants.PUNK_INT));
		}
		/*
			Function: getSensorRawValue
			Gets the raw 12-bit value of a sensor (0-4095).
			
			Parameters:
				index - sensor index
		*/
		public function getSensorRawValue(index:int):int{
			return int(indexArray(sensorsRaw, index, numSensors, com.phidgets.Constants.PUNK_INT));
		}
		/*
			Function: getSensorChangeTrigger
			Gets the change trigger for a sensor.
			
			Parameters:
				index - sensor index
		*/
		public function getSensorChangeTrigger(index:int):int{
			return int(indexArray(sensorTriggers, index, numSensors, com.phidgets.Constants.PUNK_INT));
		}
		
		//Setters
		/*
			Function: setOutputState
			Sets the state of a digital output.
			
			parameters:
				index - digital output index
				val - output state
		*/
		public function setOutputState(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Output", index, numOutputs), boolToInt(val).toString(), true);
		}
		/*
			Function: setSensorChangeTrigger
			Sets the change trigger for a sensor.
			
			Parameters:
				index - sensor index
				val - change trigger
		*/
		public function setSensorChangeTrigger(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Trigger", index, numSensors), val.toString(), true);
		}
	}
}