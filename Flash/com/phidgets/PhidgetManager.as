package com.phidgets
{
	import flash.events.Event;
	import com.phidgets.events.PhidgetManagerEvent;
	import com.phidgets.events.PhidgetErrorEvent;
	import flash.events.EventDispatcher;
	
	/*
		Class: PhidgetManager
		A class for accessing the Phidget Manager on a webservice.
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetManager.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetManagerEvent.CONNECT			- server connect
		PhidgetManagerEvent.DISCONNECT		- server disconnect
		PhidgetManagerEvent.ATTACH			- phidget attach
		PhidgetManagerEvent.DETACH			- phidget detach
		PhidgetErrorEvent.ERROR				- asynchronous error
	*/
	public class PhidgetManager extends EventDispatcher
	{
		protected var _phidgetSocket:PhidgetSocket = null;
		
		private var calledClose:Boolean = false;
		
		/*
			Function: open
			Opens a connection to a phidget manager.
			
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
			Closes the connection to a phidget manager.
		*/
		public function close():void {
			calledClose = true;
			_phidgetSocket.close();
		}
		
		private function onConnected():void {
			//listen
			var pattern:String = "^/PSK/List/";
			_phidgetSocket.setListener(pattern, onPhidgetManagerData);
			
			dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.CONNECT, this));
		}
		
		private function onDisconnected():void {
			if(!calledClose)
				dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.DISCONNECT, this));
			calledClose = false;
		}
		
		private function onError(error:PhidgetError):void {
			dispatchEvent(new PhidgetErrorEvent(PhidgetErrorEvent.ERROR,this,error));
		}
		
		private function onPhidgetManagerData(key:String, val:String, reason:int):void
		{
			//trace("Key: "+key+" Val: "+val+" Reason: "+reason);
				
			if(reason != com.phidgets.Constants.ENTRY_REMOVING)
			{
				var dataArray:Array = key.split("/");
				var dataArray2:Array = val.split(" ");
				
				var deviceType:String = dataArray[3];
				var serialNumber:int = int(dataArray[4]);
				
				var deviceVersion:int = int(dataArray2[1].substring(8));
				var deviceIDSpec:String = dataArray2[2].substring(3);
				var deviceLabel:String = dataArray2[3].substring(6);
				//take care of spaces in label
				for(var i:int=4;i<dataArray2.length;i++)
					deviceLabel = deviceLabel+" "+dataArray2[i];
				
				//trace(deviceType+"<>"+serialNumber+"<>"+deviceIDSpec+"<>"+deviceVersion+"<>"+deviceLabel);
				
				var phidget:Phidget = new Phidget(deviceType);
					
				if(dataArray2[0] == "Attached")
				{
					phidget.initForManager(serialNumber, deviceVersion, deviceType, 
						Constants.Phid_DeviceSpecificName[deviceIDSpec], deviceLabel,
						true, _phidgetSocket);
					dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.ATTACH,this,phidget));
				}
				if(dataArray2[0] == "Detached") 
				{
					phidget.initForManager(serialNumber, deviceVersion, deviceType, 
						Constants.Phid_DeviceSpecificName[deviceIDSpec], deviceLabel,
						false, _phidgetSocket);
					dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.DETACH,this,phidget));
				}
			}
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