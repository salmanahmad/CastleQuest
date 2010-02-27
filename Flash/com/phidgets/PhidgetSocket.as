package com.phidgets
{
	import flash.net.XMLSocket;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.system.Security;
	
	// WARNING: This class is for internal use only.
	public class PhidgetSocket
	{
		/*
		*	Phidget WebService Protocol version history
		*	1.0 - Initial version
		*
		*	1.0.1
		*		-first version to be enforced
		*		-we changed around the device id numbers, so old webservice won't be able to talk to new
		*
		*	1.0.2
		*		-Authorization is asynchronous, so we had to add Tags and now it's not compatible with old webservice
		*		-Doesn't match the old version checking! So could be ugly for users, get an unexpected error rather then a version error
		*		-Sends out all initial data, so it's just like opening locally
		*		-supports interfacekit Raw sensor value
		*		-supports labels on remoteIP managers
		*
		*	1.0.3
		*		-supports servoType and setServoParameters for PhidgetServo and PhidgetAdvancedServo
		*
		*	1.0.4
		*		-added some servo types
		*		-fixed RFID initialization - wasn't getting tag events if tag is on reader before open
		*		-fixed RFID sometimes not attaching in Flash
		*
		*/
		private const protocol_ver:String = "1.0.4";
		
		private var _socket:XMLSocket;
		private var _host:String = null;
		private var _port:Number = com.phidgets.Constants.PUNK_INT;
		private var _serverID:String = null;
		private var _password:String = null;
		
		private var _connected:Boolean = false;
		private var _authenticated:Boolean = false;
		
		private var lidCounter:int = 0;
		private var lidList:Array;
		
		private var _connectedCallback:Function;
		private var _disconnectedCallback:Function;
		private var _errorCallback:Function;
		
		public function PhidgetSocket()
		{
			_socket = new XMLSocket();

			_socket.addEventListener(Event.CONNECT, 		onSocketConnect);
			_socket.addEventListener(DataEvent.DATA,		onSocketData);
			_socket.addEventListener(Event.CLOSE,			onSocketClose);
			_socket.addEventListener(IOErrorEvent.IO_ERROR ,onSocketError);
			
			lidList = new Array();
		}
		
		public function connect(address:String, port:Number, password:String, 
			connectedCallback:Function, disconnectedCallback:Function, errorCallback:Function):void
		{
			_host = address;
			_port = port
			_connectedCallback = connectedCallback;
			_disconnectedCallback = disconnectedCallback;
			_errorCallback = errorCallback;
			
			if(password != null)
				_password = password;
			flash.system.Security.loadPolicyFile("xmlsocket://"+address+":"+port);
			_socket.connect(_host, _port);
		}
		
		public function close():void {
			socketSend("quit");
		}
		
		private function goodChar(charCode:Number):Boolean {
			var chars:String = "09azAZ ./";
			if(charCode <= chars.charCodeAt(1) && charCode >= chars.charCodeAt(0))
				return true;
			if(charCode <= chars.charCodeAt(3) && charCode >= chars.charCodeAt(2))
				return true;
			if(charCode <= chars.charCodeAt(5) && charCode >= chars.charCodeAt(4))
				return true;
			if(charCode == chars.charCodeAt(6) || charCode == chars.charCodeAt(7) || charCode == chars.charCodeAt(8))
				return true;
			return false;
		}
		
		private function hexChar(num:Number):String {
			var chars:String = "0123456789abcdef";
			if(num > 0xF) return "f";
			return chars.charAt(num);
		}
		
		private function hexval(char:String):Number {
			var chars:String = "09af";
			var charCode:Number = char.toLowerCase().charCodeAt(0);
			if(charCode <= chars.charCodeAt(1) && charCode >= chars.charCodeAt(0))
				return charCode - chars.charCodeAt(0);
			if(charCode <= chars.charCodeAt(3) && charCode >= chars.charCodeAt(2))
				return charCode - chars.charCodeAt(2) + 10;
			return 0;
		}
		
		private function escape(val:String):String {
			var newVal:String = "";
			if(val.length == 0)
				newVal = "\\x01";
			else
			{
				for(var i:int = 0; i<val.length; i++) {
					var charCode:Number = val.charCodeAt(i)
					if(!goodChar(charCode))
						newVal = newVal.concat("\\x" + hexChar(charCode / 16) + hexChar(charCode % 16));
					else
						newVal = newVal.concat(String.fromCharCode(charCode));
				}
			}
			return newVal;
		}
		
		private function unescape(val:String):String {
			var newVal:String = "";
			for(var i:int = 0; i<val.length; i++) {
				if(val.charAt(i) == "//") {
					newVal = newVal.concat(String.fromCharCode(hexval(val.charAt(i+2)) * 16 + hexval(val.charAt(i+3))));
					i+=3;
				}
				else
					newVal = newVal.concat(val.charAt(i));
			}
			if(newVal == String.fromCharCode(0x01))
				return "";
			return newVal;
		}
		
		private function socketSend(data:String):void{
			var request:String = data;// + "\n";
			//trace("Request: <"+request+">");
			_socket.send(request)
		}
		
		public function setKey(key:String, val:String, persistent:Boolean):void{
			var request:String = "set "+key+"=\""+escape(val)+"\"";
			if(!persistent)
				request = request+" for session";
			socketSend(request);
		}
		
		public function removeKey(pattern:String):void {
			var request:String = "remove "+pattern;
			socketSend(request);	
		}
		
		public function setListener(pattern:String, callback:Function):int
		{
			var request:String = "listen "+pattern+" lid"+lidCounter;
			lidList[lidCounter] = callback;
			lidCounter++;
			socketSend(request);
			return lidCounter-1;
		}
		
		public function removeListener(lid:int):void {
			var request:String = "ignore lid"+lid;
			socketSend(request);
		}
		
		private function onAuthenticated():void {
			//trace("Authenticated");
			_authenticated = true;
			
			//start reports
			socketSend("report 8 report")
			
			_connectedCallback();
		}
		
		private function onSocketConnect(evt:Event):void{			
			if(!_socket.connected)
			{
				_errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_NETWORK_NOTCONNECTED));
				return;
			}
			
			_connected = true;
			
			socketSend("need nulls");
			socketSend("995 authenticate, version="+protocol_ver);
			
			//wait for autentication to finish, then add open key
			var key:String = new String("/PSK/Client/");
		}
		
		private function onSocketError(evt:IOErrorEvent):void{
			var error:PhidgetError = new PhidgetError(Constants.EPHIDGET_NETWORK);
			error.setMessage(evt.text);
			_errorCallback(error);
		}
		
		private function onSocketClose(evt:Event):void{
			_connected = false;
			_disconnectedCallback();
		}
		
		private function onSocketData(evt:DataEvent):void{
			var realData:String = evt.data;
			if(evt.data.indexOf('\n')!=-1)
				realData = evt.data.substring(0, evt.data.indexOf('\n'));
			
			var tag:String = null;
			var multiPart:Boolean = false;
			
			//check for and parse out a tag
			if(realData.charCodeAt(0) > "9".charCodeAt(0) || realData.charCodeAt(0) < "0".charCodeAt(0))
			{
				var spaceIndex:int = realData.indexOf(" ");
				tag = realData.substring(0,spaceIndex);
				realData = realData.substring(spaceIndex+1, realData.length);
			}
			
			var responseType:String	= realData.charAt(0);
			var responseCode:String = realData.substring(0,3);
			if(realData.charAt(3) == "-")
				multiPart = true;
				
			realData = realData.substring(4, realData.length);
			
			var request:String = "";
			
			//trace("Response: <"+realData+">");
			
			var error:com.phidgets.PhidgetError = new PhidgetError(Constants.EPHIDGET_NETWORK);
			error.setMessage(responseCode+" "+realData);
					
			switch(responseType)
			{
				case Constants.SUCCESS_200_RESP:
					if(multiPart)
					{
						if(realData.substring(0,3) == "lid")
						{
							var lisid:int = int(realData.charAt(3));
							var callback:Function = lidList[lisid];
							var keyStart:int = realData.indexOf("key ") + 4;
							var keyEnd:int = realData.indexOf(" latest");
							var key:String = realData.substring(keyStart, keyEnd);
							var valStart:int = realData.indexOf("\"", keyEnd) + 1;
							var valEnd:int = realData.indexOf("\"", valStart);
							var val:String = realData.substring(valStart, valEnd);
							var reasonStart:int = realData.indexOf("(",valEnd) + 1;
							var reasonEnd:int = realData.indexOf(")",valEnd);
							var reason:String = realData.substring(reasonStart, reasonEnd);
							var reasonInt:int;
							switch(reason)
							{
								case "current":
									reasonInt = com.phidgets.Constants.CURRENT_VALUE;
									break;
								case "removing":
									reasonInt = com.phidgets.Constants.ENTRY_REMOVING;
									break;
								case "added":
									reasonInt = com.phidgets.Constants.ENTRY_ADDED;
									break;
								case "changed":
									reasonInt = com.phidgets.Constants.VALUE_CHANGED;
									break;
							}
							
							//unescape val
							
							callback(key, unescape(val), reasonInt);
						}
					}
					break;
				case Constants.FAILURE_300_RESP:
					_errorCallback(error);
					break;
				case Constants.FAILURE_400_RESP:
					_errorCallback(error);
					break;
				case Constants.FAILURE_500_RESP:
					_errorCallback(error);
					break;
				case Constants.AUTHENTICATE_900_RESP:
					switch(responseCode)
					{
						case "999": //Authentication required
							var ticket		:String = realData+_password;
							_password = null;
							var hash		:String = MD5.hex_md5(ticket);
							request = "997 " + hash;
							socketSend(request);
							break;
						case "998": //Authentication failed
							_errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_BADPASSWORD));
							break;
						case "996": //Authenitcated, or no authentication
							//check version
							if(realData.indexOf("version=",0)<=0)
							{
								_errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_BADVERSION));
								break;
							}
							onAuthenticated();
							break;
						case "994": //Authentication failed
							_errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_BADVERSION));
							break;
					}
					break;
			}
		}
		
		public function get Address():String{
			return _host;
		}
		public function get Port():int{
			return _port;
		}
		public function get ServerID():String{
			return _serverID;
		}
		public function get isConnected ():Boolean{
			return _connected;
		}
	}
}