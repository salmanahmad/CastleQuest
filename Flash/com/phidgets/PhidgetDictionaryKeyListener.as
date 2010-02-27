package com.phidgets
{
	import com.phidgets.PhidgetDictionary;
	import com.phidgets.events.PhidgetDictionaryEvent;
	import flash.events.EventDispatcher;
	
	/*
		Class: PhidgetDictionaryKeyListener
		A class for listening to key/value changes on a <PhidgetDictionary>
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by all PhidgetDictionaryKeyListener.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDictionaryEvent.KEY_CHANGE		- key/value added or changed
		PhidgetDictionaryEvent.KEY_REMOVAL		- key removed
	*/
	public class PhidgetDictionaryKeyListener extends EventDispatcher
	{
		private var _pattern:String;
		private var _dict:PhidgetDictionary;
		private var _lid:int = com.phidgets.Constants.PUNK_INT;
		
		/*
			Constructor: PhidgetDictionaryKeyListener
			Creates a KeyListener for a specified dictionary and key pattern.
			
			Parameters:
				dict - <PhidgetDictionary> on which to listen for keys
				pattern - extended regular expression key pattern to listen for
		*/
		public function PhidgetDictionaryKeyListener(dict:PhidgetDictionary, pattern:String) {
			_dict = dict;
			_pattern = pattern;
		}
		
		private function onDictData(key:String, val:String, reason:int):void
		{
			if(reason == Constants.ENTRY_REMOVING)
				dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.KEY_REMOVAL, this._dict, key, val));
			else
				dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.KEY_CHANGE, this._dict, key, val));
		}
		/*
			Function: start
			Start listening for keys. Make sure that the dictionary has connected before you call this. This can be called in the Dictionary CONNECT event.
		*/
		public function start():void {
			_lid = _dict._phidgetSocket.setListener(_pattern, onDictData);
		}
		/*
			Function: stop
			Stop listening for keys.
		*/
		public function stop():void {
			if(_lid != com.phidgets.Constants.PUNK_INT){
				_dict._phidgetSocket.removeListener(_lid);
				_lid = com.phidgets.Constants.PUNK_INT;
			}
		}
	}
}