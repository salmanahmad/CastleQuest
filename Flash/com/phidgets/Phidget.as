package com.phidgets
{
	import flash.events.Event;
	import com.phidgets.events.PhidgetEvent;
	import com.phidgets.events.PhidgetErrorEvent;
	import flash.events.EventDispatcher;
	
	/*
		Class: Phidget
		Base Phidget class from which all specific device classes inherit.
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by all Phidgets.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetEvent.CONNECT				- server connect
		PhidgetEvent.DISCONNECT				- server disconnect
		PhidgetEvent.ATTACH					- phidget attach
		PhidgetEvent.DETACH					- phidget detach
		PhidgetErrorEvent.ERROR				- asynchronous error
	*/
	public class Phidget extends EventDispatcher
	{
		private var _attached:Boolean = false;
		
		private var _serialNumber:int = com.phidgets.Constants.PUNK_INT;
		private var _deviceVersion:int = 0;
		private var _deviceType:String = null;
		private var _deviceName:String = null;
		private var _deviceLabel:String = null;
		
		//private var _deviceTypeNumber:int = 0;
		private var _specificDevice:int = com.phidgets.Constants.PFALSE;
		
		protected var _phidgetSocket:PhidgetSocket = null;
		private var randInt:int = 0; //used for the open/close command
		protected var keyCount:int = 0; //used for keeping track of attach / detach events
		protected var keyCountNeeded:int = 0;
		protected var keyCountNeededGood:Boolean = false;
		
		private var calledClose:Boolean = false;
		
		internal function initForManager(serial:int, version:int, type:String, name:String, label:String,
			attached:Boolean, socket:PhidgetSocket):void
		{
			_attached = attached;
			_serialNumber = serial;
			_deviceVersion = version;
			_deviceType = type;
			_deviceName = name;
			_deviceLabel = label;
			_phidgetSocket = socket;
		}
		
		public function Phidget(type:String)
		{
			_deviceType = type;
			initVars();
		}
		
		/*
			Function: open
			Opens a Phidget.
			
			Parameters:
				address - address of the webservice. This can be 'localhost' when running from a single computer.
				port - port of the webservice. This is 5001 by default.
				password - password of the webservice. This is optional and doesn't need to be specified for unsecured webservices.
				serialNumber - serial number of the phidget to open. This is optional and if not specified, the first available phidget will be opened.
		*/
		public function open(address:String, port:Number, password:String = null, serialNumber:int = 0x7FFFFFFF):void {
			_serialNumber = serialNumber;
			_phidgetSocket = new PhidgetSocket();
			if(serialNumber == com.phidgets.Constants.PUNK_INT)
				_specificDevice = com.phidgets.Constants.PFALSE;
			else
				_specificDevice = com.phidgets.Constants.PTRUE;
			_phidgetSocket.connect(address, port, password, onConnected, onDisconnected, onError);
		}
		
		/*
			Function: close
			Closes a Phidget.
			This closes the connection to a Phidget, and to the server.
		*/
		public function close():void {
			calledClose = true;
			var key:String = "/PCK/Client/0.0.0.0/"+randInt+"/"+_deviceType;
			if(_specificDevice == com.phidgets.Constants.PTRUE)
				key = key+"/"+_serialNumber.toString();
			_phidgetSocket.setKey(key, "Close", false);
			_phidgetSocket.close();
		}
		
		private function onConnected():void {
			
			//now send the open key
			var rand:Number = Math.random();
			randInt = int(rand * 99999);
			var key:String = "/PCK/Client/0.0.0.0/"+randInt+"/"+_deviceType;
			if(_specificDevice == com.phidgets.Constants.PTRUE)
				key = key+"/"+_serialNumber.toString();
			_phidgetSocket.setKey(key, "Open", false);

			//listen
			var pattern:String = "/PSK/"+_deviceType;
			if(_specificDevice == com.phidgets.Constants.PTRUE)
				pattern = pattern+"/"+_serialNumber.toString();
			_phidgetSocket.setListener(pattern, onPhidgetData);
			
			dispatchEvent(new PhidgetEvent(PhidgetEvent.CONNECT,this));
		}
		
		private function onDisconnected():void {
			if(!calledClose)
				dispatchEvent(new PhidgetEvent(PhidgetEvent.DISCONNECT,this));
			if(_attached)
				detachDevice();
			calledClose = false;
		}
		
		private function onError(error:PhidgetError):void {
			dispatchEvent(new PhidgetErrorEvent(PhidgetErrorEvent.ERROR,this,error));
		}
		
		protected function isKnown(array:Array, index:int, unkval:Number = -1):Boolean{
			if(array[index] == null || array[index] == undefined)
				return false;
			if(Number(array[index]).toPrecision(15) == unkval.toPrecision(15) && unkval != -1)
				return false;
			return true;
		}
		
		protected function indexArray(array:Array, index:int, limit:int, unkval:Number = -1):Object{ 
			if(index >= limit || index < 0)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
			if(!isKnown(array, index, unkval))
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return array[index];
		}
		
		protected function intToBool(val:int):Boolean{ 
			if(val == com.phidgets.Constants.PUNK_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			if(val == com.phidgets.Constants.PFALSE) return false;
			if(val == com.phidgets.Constants.PTRUE) return true;
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNEXPECTED);
		}
		
		protected function boolToInt(val:Boolean):int{ 
			if(val == false) return com.phidgets.Constants.PFALSE;
			else return com.phidgets.Constants.PTRUE;
		}
		
		protected function makeKey(setThing:String):String{ 
			return "/PCK/"+_deviceType+"/"+_serialNumber+"/"+setThing;
		}
		protected function makeIndexedKey(setThing:String, index:int, limit:int):String{ 
			if(index >= limit || index < 0)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
			return "/PCK/"+_deviceType+"/"+_serialNumber+"/"+setThing+"/"+index;
		}
		
		//override in the subclasses
		protected function initVars():void{}
		protected function eventsAfterOpen():void{}
		protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{}
		
		private function onPhidgetData(key:String, val:String, reason:int):void
		{
			//trace("Key: "+key+" Val: "+val+" Reason: "+reason);
				
			if(reason != com.phidgets.Constants.ENTRY_REMOVING || val == "Detached")
			{
				var dataArray:Array = key.split("/");
				
				var serialNumber:int = int(dataArray[3]);
				var setThing:String = dataArray[4];
				var index:int = 0;
				if(dataArray.length>5)
					index = int(dataArray[5]);
					
				if(_specificDevice == com.phidgets.Constants.PFALSE && val != "Detached")
				{
					_specificDevice = 2;
					_serialNumber = serialNumber;
				}
				
				//trace("Serial: "+serialNumber+" SetThing: "+setThing+" Index: "+index+" Value: "+val);
				
				if(serialNumber == _serialNumber)
				{
					switch(setThing)
					{
						case "Label":
							_deviceLabel = val;
							keyCount++;
							break;
						case "Version":
							_deviceVersion = int(val);
							keyCount++;
							break;
						case "Name":
							_deviceName = val;
							keyCount++;
							break;
						case "ID":
							keyCount++;
							break;
						case "InitKeys":
							keyCountNeeded = int(val);
							keyCountNeededGood = true;
							keyCount++;
							break;
						case "Status":
							if(val == "Attached")
							{
								keyCount++;
							}
							else if(val == "Detached")
							{
								keyCount = 0;
								keyCountNeededGood = false;
								detachDevice();
							}
							else
								throw new PhidgetError(com.phidgets.Constants.EPHIDGET_NETWORK);
							break;
						default:
							onSpecificPhidgetData(setThing, index, val);
							break;
					}
					if(keyCount >= keyCountNeeded && _attached == false && keyCountNeededGood == true)
					{
						_attached = true;
						dispatchEvent(new PhidgetEvent(PhidgetEvent.ATTACH,this));
						//dispatch initial events
						eventsAfterOpen();
					}
				}
			}
			
		}
		
		private function detachDevice():void {
			_attached = false;
			if(!calledClose)
				dispatchEvent(new PhidgetEvent(PhidgetEvent.DETACH,this));
			if(_specificDevice == 2)
			{
				_specificDevice = com.phidgets.Constants.PFALSE;
				_serialNumber = com.phidgets.Constants.PUNK_INT;
			}
			_deviceLabel = null;
			_deviceVersion = com.phidgets.Constants.PUNK_INT;
			_deviceName = null;
			initVars();
		}
		
		//Getters
		/*
			Property: Type
			Gets the type (class) of a Phidget.
		*/
		public function get Type():String{
			if(_deviceType == null)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return _deviceType;
		}
		/*
			Property: Name
			Gets the specific name of a Phidget.
		*/
		public function get Name():String{
			if(_deviceName == null)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return _deviceName;
		}
		/*
			Property: Label
			Gets the Label of a Phidget.
		*/
		public function get Label():String{
			if(_deviceLabel == null)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return _deviceLabel;
		}
		/*
			Property: Version
			Gets the firwmare version of a Phidget.
		*/
		public function get Version():int{
			if(_deviceVersion == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return _deviceVersion;
		}
		/*
			Property: serialNumber
			Gets the unique serial number of a Phidget.
		*/
		public function get serialNumber():int{
			if(_serialNumber == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return _serialNumber;
		}
		/*
			Property: isAttached
			Gets the attached state of a Phidget.
		*/
		public function get isAttached ():Boolean{
			return _attached;
		}
		
		//From the socket
		/*
			Propery: isConnected
			Gets the connected to server state.
			Note that being connected to the server does not mean that the Phidget is attached.
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

		//Setters
		/*
			Property: Label
			Sets the Label.
			Note that this is only supported on some systems.
		*/
		public function set Label(str:String):void{
			var key:String = "/PCK/"+_deviceType+"/"+_serialNumber+"/Label";
			_phidgetSocket.setKey(key, str, false);
		}
		
		override public function toString():String{
			return _deviceName+", Version: "+_deviceVersion+", Serial Number: "+_serialNumber
				+(_deviceLabel==null || _deviceLabel=="" ? "" : ", Label: "+_deviceLabel);
		}
	}
}