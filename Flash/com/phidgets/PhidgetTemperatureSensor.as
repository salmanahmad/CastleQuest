package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetTemperatureSensor
		A class for controlling a PhidgetTemperatureSensor.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetTemperatureSensor. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.TEMPERATURE_CHANGE	- temperature change
	*/
	public class PhidgetTemperatureSensor extends Phidget
	{
		private var numSensors:int;
		private var potentialMin:Number;
		private var potentialMax:Number;
		private var ambientTemperatureMin:Number;
		private var ambientTemperatureMax:Number;
		private var temperatureMins:Array;
		private var temperatureMaxs:Array;
		
		private var ambientTemperature:Number;
		private var thermocoupleTypes:Array;
		private var temperatures:Array;
		private var potentials:Array;
		private var temperatureTriggers:Array;
		
		/*
			Constants: Thermocouple Types
			These are the type of thermocouples supported by the PhidgetTemperatureSensor. These constants are used with <getThermocoupleType> and <setThermocoupleType>.
			
			PHIDGET_TEMPERATURE_SENSOR_K_TYPE - K-Type thermocouple.
			PHIDGET_TEMPERATURE_SENSOR_J_TYPE - J-Type thermocouple.
			PHIDGET_TEMPERATURE_SENSOR_E_TYPE - E-Type thermocouple.
			PHIDGET_TEMPERATURE_SENSOR_T_TYPE - T-Type thermocouple.
		*/
		public static const PHIDGET_TEMPERATURE_SENSOR_K_TYPE:int = 1;
		public static const PHIDGET_TEMPERATURE_SENSOR_J_TYPE:int = 2;
		public static const PHIDGET_TEMPERATURE_SENSOR_E_TYPE:int = 3;
		public static const PHIDGET_TEMPERATURE_SENSOR_T_TYPE:int = 4;
		
		public function PhidgetTemperatureSensor(){
			super("PhidgetTemperatureSensor");
		}
		
		override protected function initVars():void{
			numSensors = com.phidgets.Constants.PUNK_INT;
			potentialMin = com.phidgets.Constants.PUNK_NUM;
			potentialMax = com.phidgets.Constants.PUNK_NUM;
			ambientTemperatureMin = com.phidgets.Constants.PUNK_NUM;
			ambientTemperatureMax = com.phidgets.Constants.PUNK_NUM;
			temperatureMins = new Array(8);
			temperatureMaxs = new Array(8);
		
			ambientTemperature = com.phidgets.Constants.PUNI_NUM;
			temperatures = new Array(8);
			potentials = new Array(8);
			temperatureTriggers = new Array(8);
			thermocoupleTypes = new Array(8);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfSensors":
					numSensors = int(value);
					keyCount++;
					break;
				case "ThermocoupleType":
					if(thermocoupleTypes[index] == undefined)
						keyCount++;
					thermocoupleTypes[index] = value;
					break;
				case "AmbientTemperature":
					if(ambientTemperature == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					ambientTemperature = Number(value);
					break;
				case "AmbientTemperatureMin":
					ambientTemperatureMin = Number(value);
					keyCount++;
					break;
				case "AmbientTemperatureMax":
					ambientTemperatureMax = Number(value);
					keyCount++;
					break;
				case "Temperature":
					if(temperatures[index] == undefined)
						keyCount++;
					temperatures[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.TEMPERATURE_CHANGE,this,Number(temperatures[index]),index));
					break;
				case "TemperatureMin":
					if(temperatureMins[index] == undefined)
						keyCount++;
					temperatureMins[index] = value;
					break;
				case "TemperatureMax":
					if(temperatureMaxs[index] == undefined)
						keyCount++;
					temperatureMaxs[index] = value;
					break;
				case "Potential":
					if(potentials[index] == undefined)
						keyCount++;
					potentials[index] = value;
					break;
				case "PotentialMin":
					potentialMin = Number(value);
					keyCount++;
					break;
				case "PotentialMax":
					potentialMax = Number(value);
					keyCount++;
					break;
				case "Trigger":
					if(temperatureTriggers[index] == undefined)
						keyCount++;
					temperatureTriggers[index] = value;
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			for(var i:int = 0; i<numSensors; i++)
			{
				if(isKnown(temperatures, i, com.phidgets.Constants.PUNK_NUM))
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.TEMPERATURE_CHANGE,this,Number(temperatures[i]),i));
			}
		}
		
		//Getters
		/*
			Property: TemperatureInputCount
			Gets the number of thermocouple inputs supported by this sensor.
		*/
		public function get TemperatureInputCount():int{
			if(numSensors == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numSensors;
		}
		/*
			Property: AmbientTemperature
			Gets the ambient (board) temperature.
		*/
		public function get AmbientTemperature():Number{
			if(ambientTemperature == com.phidgets.Constants.PUNK_NUM || ambientTemperature == com.phidgets.Constants.PUNI_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return ambientTemperature;
		}
		/*
			Property: AmbientTemperatureMin
			Gets the minimum temperature that the ambient sensor can measure.
		*/
		public function get AmbientTemperatureMin():Number{
			if(ambientTemperatureMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return ambientTemperatureMin;
		}
		/*
			Property: AmbientTemperatureMax
			Gets the maximum temperature that the ambient sensor can measure.
		*/
		public function get AmbientTemperatureMax():Number{
			if(ambientTemperatureMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return ambientTemperatureMax;
		}
		/*
			Function: getThermocoupleType
			Gets the type of thermocouple expected at a thermocouple input.
			
			Parameters:
				index - thermocouple input.
		*/
		public function getThermocoupleType(index:int):int{
			return int(indexArray(thermocoupleTypes, index, numSensors, -1));
		}
		/*
			Function: getTemperature
			Gets the temperature at a thermocouple input.
			
			Parameters:
				index - thermocouple input.
		*/
		public function getTemperature(index:int):Number{
			return Number(indexArray(temperatures, index, numSensors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getTemperatureMin
			Gets the minimum temperature that a thermocouple input can measure.
			
			Parameters:
				index - thermocouple input
		*/
		public function getTemperatureMin(index:int):Number{
			return Number(indexArray(temperatureMins, index, numSensors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getTemperatureMax
			Gets the maximum temperature that a thermocouple input can measure.
		
			Parameters:
				index - thermocouple input
		*/
		public function getTemperatureMax(index:int):Number{
			return Number(indexArray(temperatureMaxs, index, numSensors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getPotential
			Gets the potential (mV) that a thermocouple input is measuring.
			
			Parameters:
				index - thermocouple input
		*/
		public function getPotential(index:int):Number{
			return Number(indexArray(potentials, index, numSensors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getPotentialMin
			Gets the minimum potential that a thermocouple input can measure.
			
			Parameters:
				index - thermocouple input
		*/
		public function getPotentialMin(index:int):Number{
			if(potentialMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return potentialMin;
		}
		/*
			Function: getPotentialMax
			Gets the maximum potential that a thermocouple input can measure.
			
			Parameters:
				index - thermocouple input
		*/
		public function getPotentialMax(index:int):Number{
			if(potentialMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return potentialMax;
		}
		/*
			Function: getTemperatureChangeTrigger
			Gets the change trigger for a thermocouple input.
			
			Parameters:
				index - thermocouple index
		*/
		public function getTemperatureChangeTrigger(index:int):Number{
			return Number(indexArray(temperatureTriggers, index, numSensors, com.phidgets.Constants.PUNK_NUM));
		}
		
		//Setters
		/*
			Function: setTemperatureChangeTrigger
			Sets the change trigger for a thermocouple input.
			
			Parameters:
				index - thermocouple input
				val - change trigger
		*/
		public function setTemperatureChangeTrigger(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Trigger", index, numSensors), val.toString(), true);
		}
		/*
			Function: setThermocoupleType
			Sets the type of thermocouple attached to a thermocouple input. Default is K-Type.
			
			Parameters:
				index - thermocouple index
				val - thermocouple type
		*/
		public function setThermocoupleType(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("ThermocoupleType", index, numSensors), val.toString(), true);
		}
	}
}