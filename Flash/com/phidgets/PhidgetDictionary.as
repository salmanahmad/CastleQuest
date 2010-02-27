package com.phidgets
{
	import flash.events.Event;
	import com.phidgets.events.PhidgetDictionaryEvent;
	import com.phidgets.events.PhidgetErrorEvent;
	import flash.events.EventDispatcher;
	
	/*
		Class: PhidgetDictionary
		A class for accessing the Phidget Dictionary.
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by all PhidgetDictionary.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDictionaryEvent.CONNECT		- server connect
		PhidgetDictionaryEvent.DISCONNECT	- server disconnect
		PhidgetErrorEvent.ERROR				- asynchronous error
	*/
	public class PhidgetDictionary extends EventDispatcher
	{
		internal var _phidgetSocket:PhidgetSocket = null;
		
		private var calledClose:Boolean = false;
		/*
			Function: open
			Opens a connection to a dictionary.
			
			Parameters:
				address - address of the webservice. This can be 'localhost' when running from a single computer.
				port - port of the webservice. This is 5001 by default.
				password - password of the webservice. This is optional and doesn't need to be specified for unsecured webservices.
		*/
		public function open(address:String, port:Number, password:String = null):void {
			_phidgetSocket = new PhidgetSocket();
			_phidgetSocket.connect(address, port, password, onConnected, onDisconnected, onError);
		}
		
		/*
			Function: close
			closes the connection to a dictionary.
		*/
		public function close():void {
			calledClose = true;
			_phidgetSocket.close();
		}
		
		private function onConnected():void {
			dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.CONNECT, this));
		}
		
		private function onDisconnected():void {
			if(!calledClose)
				dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.DISCONNECT, this));
			calledClose = false;
		}
		
		private function onError(error:PhidgetError):void {
			dispatchEvent(new PhidgetErrorEvent(PhidgetErrorEvent.ERROR,this,error));
		}
		
		/*
			Function: addKey
			Adds or changes a key/value pair to the dictionary.
			
			Parameters:
				key - key value
				value - value value
				persistent - optional, default is true, determines whether a key remains after closing the connection to the dictionay
		*/
		public function addKey(key:String, value:String, persistent:Boolean=true):void {
			_phidgetSocket.setKey(key, value, persistent);
		}
		/*
			Function: removeKey
			Removes a (set) of key(s) that match the pattern. The pattern is a regular, or extended regular expression.
			
			Parameters:
				pattern - pattern of keys to remove
		*/
		public function removeKey(pattern:String):void {
			_phidgetSocket.removeKey(pattern);
		}
		
		//From the socket		
		/*
			Propery: isConnected
			Gets the connected to server state.
		*/
		public function get isConnected ():Boolean{
			return _phidgetSocket.isConnected;
		}
		/*
			Property: Address
			Gets the server address.
		*/
		public function get Address():String{
			if(_phidgetSocket.Address == null)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return _phidgetSocket.Address;
		}
		/*
			Property: Port
			Gets the server port.
		*/
		public function get Port():int{
			if(_phidgetSocket.Port == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return _phidgetSocket.Port;
		}
	}
}