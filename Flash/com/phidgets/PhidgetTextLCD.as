package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetTextLCD
		A class for controlling a PhidgetTextLCD.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetTextLCD extends Phidget
	{
		private var numRows:int;
		private var numColumns:int;
		private var backlight:int;
		private var cursorOn:int;
		private var cursorBlink:int;
		private var contrast:int;
		
		public function PhidgetTextLCD(){
			super("PhidgetTextLCD");
		}
		
		override protected function initVars():void{
			numRows = com.phidgets.Constants.PUNK_INT;
			numColumns = com.phidgets.Constants.PUNK_INT;
			backlight = com.phidgets.Constants.PUNK_BOOL;
			cursorOn = com.phidgets.Constants.PUNK_BOOL;
			cursorBlink = com.phidgets.Constants.PUNK_BOOL;
			contrast = com.phidgets.Constants.PUNK_INT;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfRows":
					numRows = int(value);
					keyCount++;
					break;
				case "NumberOfColumns":
					numColumns = int(value);
					keyCount++;
					break;
				case "Backlight":
					backlight = int(value);
					break;
				case "CursorOn":
					cursorOn = int(value);
					break;
				case "CursorBlink":
					cursorBlink = int(value);
					break;
				case "Contrast":
					contrast = int(value);
					break;
			}
		}
		
		//Getters
		/*
			Property: RowCount
			Gets the number of rows available on the LCD.
		*/
		public function get RowCount():int{
			if(numRows == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numRows;
		}
		/*
			Property: ColumnCount
			Gets the number of columns available per row on the LCD.
		*/
		public function get ColumnCount():int{
			if(numColumns == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numColumns;
		}
		/*
			Property: Backlight
			Gets tha state of the backlight.
		*/
		public function get Backlight():Boolean{
			if(backlight == com.phidgets.Constants.PUNK_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(backlight);
		}
		/*
			Property: Cursor
			Gets the visible state of the cursor.
		*/
		public function get Cursor():Boolean{
			if(cursorOn == com.phidgets.Constants.PUNK_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(cursorOn);
		}
		/*
			Property: CursorBlink
			Gets the blinking state of the cursor.
		*/
		public function get CursorBlink():Boolean{
			if(cursorBlink == com.phidgets.Constants.PUNK_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(cursorBlink);
		}
		/*
			Property: Contrast
			Gets the last set contrast value.
		*/
		public function get Contrast():int{
			if(contrast == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return contrast;
		}
		
		//Setters
		/*
			Property: Backlight
			Sets the backlight state.
			
			Parameters:
				val - backlight state
		*/
		public function set Backlight(val:Boolean):void{ 
			_phidgetSocket.setKey(makeKey("Backlight"), boolToInt(val).toString(), true);
		}
		/*
			Property: Cursor
			Sets the cursor (visible) state.
			
			Parameters:
				val - cursor state
		*/
		public function set Cursor(val:Boolean):void{ 
			_phidgetSocket.setKey(makeKey("CursorOn"), boolToInt(val).toString(), true);
		}
		/*
			Property: CursorBlink
			Sets the cursor blink state.
			
			Parameters:
				val - cursor blink state
		*/
		public function set CursorBlink(val:Boolean):void{ 
			_phidgetSocket.setKey(makeKey("CursorBlink"), boolToInt(val).toString(), true);
		}
		/*
			Property: Contrast
			Sets the contrast (0-255).
			
			Parameters:
				val - contrast
		*/
		public function set Contrast(val:int):void{ 
			_phidgetSocket.setKey(makeKey("Contrast"), val.toString(), true);
		}
		/*
			Function: setDisplayString
			Sets the display string for a row.
			
			Parameters:
				index - row
				val - display string
		*/
		public function setDisplayString(index:int, val:String):void{ 
			_phidgetSocket.setKey(makeIndexedKey("DisplayString", index, numRows), val, true);
		}
		/*
			Function: setDisplayCharacter
			Sets the character at a row and column. Send a one character string.
			
			Parameters:
				row - row
				column - column
				val - character
		*/
		public function setDisplayCharacter(row:int, column:int, val:String):void{ 
			var index:int = (row + 1) * (column + 1);
			_phidgetSocket.setKey(makeIndexedKey("DisplayCharacter", index, numRows*numColumns), val, true);
		}
		/*
			Function: setCustomCharacter
			Creates a custom character. See the product manual for more information.
			
			Parameters:
				index - character index (8-15)
				val1 - character data 1
				val2 - character data 2
		*/
		public function setCustomCharacter(index:int, val1:int, val2:int):void {
			var key:String = makeIndexedKey("CustomCharacter", index, 16);
			if(index < 8) throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
			var val:String = val1+","+val2;
			_phidgetSocket.setKey(key, val, true);
		}
	}
}