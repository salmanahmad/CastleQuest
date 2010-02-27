// ActionScript file
package com.phidgets
{
	/*
		Class: PhidgetError
		Phidget exceptions.
		
		Most functions can throw an exception under the right (or wrong) circumstances. See the Product and Programming manuals for more details.
		
		The error codes that can show up are documented in <Constants>.
	*/
	public class PhidgetError extends Error {
		/*
			Constructor: PhidgetError
			Creates a new PhidgetError object
			
			Parameters:
				errorID - error code
		*/
    	public function PhidgetError(errorID:int) {
        	super(com.phidgets.Constants.Phid_ErrorDescriptions[errorID], errorID);
    	}
    	
    	/*
    		Function: setMessage
    		Sets the error message for an exception.
    		
    		Parameters:
    			message - error messag
    	*/
    	public function setMessage(message:String):void {
	    	this.message = message;
    	}
    	
	}
}