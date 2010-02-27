package com.phidgets.events
{
	import com.phidgets.Phidget;
	import flash.events.Event;
	
	/*
		Class: PhidgetEvent
		A class for Phidget events. These events are supported by all Phidgets.
	*/
	public class PhidgetEvent extends Event
	{		
		/*
			Constants: Phidget Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			CONNECT			-	A connection to the server was established.
			DISCONNECT		-	A connection to the server was lost.
			ATTACH		-	A connection to the phidget was established.
			DETACH		-	A connection to the phidget was lost.
		*/
		public static const CONNECT	:String = "connect";
		public static const DISCONNECT:String 	= "disconnect";
		public static const ATTACH:String 	= "attach";
		public static const DETACH:String 	= "detach";
		
		private var _phidget:Phidget;
		
		public function PhidgetEvent (type:String,phidget:Phidget) {
			super(type);
			this._phidget = phidget;
		}
		
		override public function toString():String{
			return "[ Phidget Event: "+type+" ]";
		}
		/*
			Property: Device
			Gets the Phidget object from which this event originated
		*/
		public function get Device():Phidget{ 
			return _phidget;
		}
	}
}