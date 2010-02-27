package com.phidgets.events
{
	import com.phidgets.Phidget;
	import com.phidgets.PhidgetManager;
	import flash.events.Event;
	
	/*
		Class: PhidgetManagerEvent
		A class for Phidget Manager events.
	*/
	public class PhidgetManagerEvent extends Event
	{
		/*
			Constants: Phidget Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			CONNECT			-	A connection to the server was established.
			DISCONNECT		-	A connection to the server was lost.
			ATTACH		-	A Phidget was plugged into the server.
			DETACH		-	A Phidget was unplugged from the server.
		*/
		public static const CONNECT	:String = "connect";
		public static const DISCONNECT:String 	= "disconnect";
		public static const ATTACH:String 	= "attach";
		public static const DETACH:String 	= "detach";
		
		private var _phidgetManager:PhidgetManager;
		private var _phidget:Phidget;
		
		public function PhidgetManagerEvent (type:String,manager:PhidgetManager,phidget:Phidget=null) {
			super(type);
			this._phidgetManager = manager;
			this._phidget = phidget;
		}
		
		override public function toString():String{
			if(_phidget == null)
				return "[ Phidget Manager Event: "+type+" ]";
			else
				return "[ Phidget Manager Event: "+type+": "+_phidget+" ]";
		}
		/*
			Property: Manager
			Gets the PhidgetManager object from which this event originated
		*/
		public function get Manager():PhidgetManager{ 
			return _phidgetManager;
		}
		/*
			Property: Device
			For ATTACH and DETACH events, gets the Phidget object representing the attached or detached device.
		*/
		public function get Device():Phidget{ 
			return _phidget;
		}
	}
}