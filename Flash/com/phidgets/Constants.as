package com.phidgets
{
	/*
		Class: Constants
	*/
	public class Constants
	{
		
		/*
			Constants: Error Codes
			Error codes that can show up in <PhidgetError> exceptions.
			
			EPHIDGET_UNEXPECTED	- unknown error occured
			EPHIDGET_NETWORK	- network error
			EPHIDGET_UNKNOWNVAL	- state not yet recieved from device
			EPHIDGET_BADPASSWORD	- wrong password specified
			EPHIDGET_UNSUPPORTED	- function not supported for this device, or not yet implemented
			EPHIDGET_OUTOFBOUNDS	- tried to index past the end of an array
			EPHIDGET_NETWORK_NOTCONNECTED	- not connected error
			EPHIDGET_BADVERSION	- webservice and client version mismatch
			
		*/
		public static const EPHIDGET_UNEXPECTED:Number = 				3
		public static const EPHIDGET_NETWORK:Number = 					8
		public static const EPHIDGET_UNKNOWNVAL:Number = 				9
		public static const EPHIDGET_BADPASSWORD:Number = 				10
		public static const EPHIDGET_UNSUPPORTED:Number = 				11
		public static const EPHIDGET_OUTOFBOUNDS:Number = 				14
		public static const EPHIDGET_NETWORK_NOTCONNECTED:Number = 		16
		public static const EPHIDGET_BADVERSION:Number = 				19
		
		public static const PFALSE:int = 								0x00
		public static const PTRUE:int = 								0x01
		
		public static const PUNK_BOOL:int = 							0x02
		public static const PUNK_INT:int = 								0x7FFFFFFF
		public static const PUNK_NUM:Number = 							1e+300
		
		public static const PUNI_BOOL:int = 							0x03
		public static const PUNI_INT:int = 								0x7FFFFFFE
		public static const PUNI_NUM:Number = 							1e+250
		
		public static const Phid_ErrorDescriptions:Array = [,,,
		"Unexpected Error.  Contact Phidgets Inc. for support.",,,,,
		"Network Error.",
		"Value is Unknown (State not yet received from device).",
		"Authorization Failed.",
		"Not Supported",,,
		"Index out of Bounds",,
		"A connection to the server does not exist.",,,
		"Webservice and Client protocol versions don't match. Update both to newest release."];
		
		/* This needs to match the CPhidget_DeviceID enum in phidget21 C library */
		public static const Phid_DeviceSpecificName:Object = {
		/* These are all current devices */
		113:	"Phidget Accelerometer 2-axis",
		126:	"Phidget Accelerometer 3-axis",
		58:		"Phidget Advanced Servo Controller 8-motor",
		123:	"Phidget Bipolar Stepper Controller 1-motor",
		75:		"Phidget Encoder 1-encoder 1-input",
		128:	"Phidget High Speed Encoder 1-encoder",
		64:		"Phidget InterfaceKit 0/0/4",
		129:	"Phidget InterfaceKit 0/0/8",
		68:		"Phidget InterfaceKit 0/16/16",
		69:		"Phidget InterfaceKit 8/8/8",
		125:	"Phidget InterfaceKit 8/8/8",
		74:		"Phidget LED 64",
		118:	"Phidget Touch Slider",
		89:		"Phidget High Current Motor Controller 2-motor",
		88:		"Phidget Low Voltage Motor Controller 2-motor 4-input",
		116:	"Phidget PH Sensor",
		49:		"Phidget RFID 2-output",
		119:	"Phidget Touch Rotation",
		57:		"Phidget Servo Controller 1-motor",
		112:	"Phidget Temperature Sensor",
		381:	"Phidget TextLCD",
		122:	"Phidget Unipolar Stepper Controller 4-motor",
		
		/* These are all past devices (no longer sold) */
		83:		"Phidget InterfaceKit 0/8/8",
		4:		"Phidget InterfaceKit 4/8/8",
		48:		"Phidget RFID",
		2:		"Phidget Servo Controller 1-motor",
		56:		"Phidget Servo Controller 4-motor",
		3:		"Phidget Servo Controller 4-motor",
		82:		"Phidget TextLCD",
		339:	"Phidget TextLCD",
		72:		"Phidget TextLED 4x8",
		73:		"Phidget TextLED 1x8",
		114:	"Phidget Weight Sensor",
		
		/* Nothing device */
		1:		"Uninitialized Phidget Handle",
		
		/* never released to general public */
		81:		"Phidget InterfaceKit 0/5/7",
		337:	"Phidget TextLCD Custom",
		
		/* These are unreleased or prototype devices */
		383:	"Phidget Accelerometer 3-axis",
		130:	"Phidget Advanced Servo Controller 1-motor",
		121:	"Phidget GPS",
		117:	"Phidget Gyroscope",
		127:	"Phidget Gyroscope 3-axis",
		
		/* This is for internal prototyping */
		153:	"Phidget Generic Device" };
		
		//Socket Server Constants
		//Commands
		public static const NULL_CMD:String = "need nulls";
		public static const LISTEN_CMD:String = "listen";
		public static const IGNORE_CMD:String = "ignore";
		public static const REPORT_CMD:String = "report";
		public static const WAIT_CMD:String = "wait";
		public static const FLUSH_CMD:String = "flush";
		public static const WALK_CMD:String = "walk";
		public static const QUIT_CMD:String = "quit";
		public static const GET_CMD:String = "get";
		public static const SET_CMD:String = "set";
		//responses
		public static const SUCCESS_200_RESP:String = "2";
		public static const FAILURE_300_RESP:String = "3";
		public static const FAILURE_400_RESP:String = "4";
		public static const FAILURE_500_RESP:String = "5";
		public static const AUTHENTICATE_900_RESP:String = "9";
		
		public static const OK_PENDING_RESP:String = "200-";
		public static const OK_RESP:String  = "200 ";
		
		//Listen key change reasons
		public static const VALUE_CHANGED:int = 1;
		public static const ENTRY_ADDED:int = 2;
		public static const ENTRY_REMOVING:int = 3;
		public static const CURRENT_VALUE:int = 4;
	}
}