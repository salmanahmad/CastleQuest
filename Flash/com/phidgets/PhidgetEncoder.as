package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	

	/*
		Class: PhidgetEncoder
		A class for controlling a PhidgetEncoder.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetEncoder. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE		- digital input change
		PhidgetDataEvent.POSITION_CHANGE	- position change
			-Note that this is a relative position change, not an absolute position.
	*/
	public class PhidgetEncoder extends Phidget
	{
		private var numEncoders:int;
		private var numInputs:int;
		private var inputs:Array;
		private var encoders:Array;
		private var timeChanges:Array;
		
		public function PhidgetEncoder(){
			super("PhidgetEncoder");
		}
		
		override protected function initVars():void{
			numEncoders = com.phidgets.Constants.PUNK_INT;
			numInputs = com.phidgets.Constants.PUNK_INT;
			inputs = new Array(4);
			timeChanges = new Array(4);
			encoders = [0,0,0,0];
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfEncoders":
					numEncoders = int(value);
					keyCount++;
					break;
				case "NumberOfInputs":
					numInputs = int(value);
					keyCount++;
					break;
				case "Input":
					inputs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[index]),index));
					break;
				case "Position":
					var posnArray:Array = value.split("/");
					encoders[index] = posnArray[2];
					
					timeChanges[index] = posnArray[0];
					if(timeChanges[index] >= 30000)
						timeChanges[index] = com.phidgets.Constants.PUNK_INT;
					
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,int(posnArray[1]),index));
						
					break;
				case "ResetPosition":
					encoders[index] = value;
					break;
			}
		}
		
		//Getters
		/*
			Property: InputCount
			Gets the number of digital inputs supported by this encoder.
			Note that not all encoders support digital inputs.
		*/
		public function get InputCount():int{
			if(numInputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numInputs;
		}
		/*
			Property: EncoderCount
			Gets the number of encoder inputs supported by this encoder.
		*/
		public function get EncoderCount():int{
			if(numEncoders == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numEncoders;
		}
		/*
			Function: getPosition
			Gets the absolute position of the encoder.
			
			Parameters:
				inputs - encoder index
		*/
		public function getPosition(index:int):int{
			return int(indexArray(encoders, index, numEncoders, com.phidgets.Constants.PUNK_INT));
		}
		/*
			Function: getTimeChange
			Gets the ammount of time that passed between the last two position change events, in milliseconds.
			This can be called from the position change handler.
			
			Parameters:
				inputs - encoder index
		*/
		public function getTimeChange(index:int):int{
			return int(indexArray(timeChanges, index, numEncoders, com.phidgets.Constants.PUNK_INT));
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
		
		//Setters
		/*
			Function: setPosition
			Sets/Resets the position of the encoder.
			
			Parameters:
				index - encoder index
				val - position
		*/
		public function setPosition(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("ResetPosition", index, numEncoders), val.toString(), true);
		}
	}
}