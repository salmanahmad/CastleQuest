package com.phidgets.events
{
	import com.phidgets.Phidget;
	import com.phidgets.PhidgetError;
	import flash.events.Event;
	
	/*
		Class: PhidgetErrorEvent
		A class for error events.
	*/
	public class PhidgetErrorEvent extends Event
	{
		/*
			Constants: Error Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			ERROR			-	An asynchronous error occured.
		*/
		public static const ERROR	:String = "error";
		
		private var _error:PhidgetError;
		private var _sender:Object;
		
		public function PhidgetErrorEvent (type:String,sender:Object,error:PhidgetError) {
			super(type);
			_error = error;
			_sender = sender;
		}
		
		override public function toString():String{
				return "[ Phidget Error Event: "+_error.message+ " ]";
		}
		
		/*
			Property: Error
			Gets the <PhidgetError> containing the error information for this event.
		*/
		public function get Error():PhidgetError{ 
			return _error;
		}
		
		/*
			Property: Sender
			The object from which this event originated.
		*/
		public function get Sender():Object {
			return _sender;
		}
	}
}