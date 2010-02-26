import com.phidgets.*;
import com.phidgets.event.*;
import java.util.HashMap;

PFont font;
String tag = "";


/* For future special encodings, 
if(myTag.equals(new Integer(-1)))
	System.out.println("special here");*/
public class RfidReaders
{
	RFIDPhidget rfid = null;
	RFIDPhidget rfid2 = null;
	HashMap myHM = null;
	RFIDPhidget myRFID = null;
	//	GameController myGC = null;
	boolean allowReads = true;
	Integer myTag;

	void setupReader() {
		// Fill out this with mappings
		myHM = new HashMap();
		myHM.put("041514ab3b", new Integer(1));
		myHM.put("041514a794", new Integer(1));
		myHM.put("041514acc4", new Integer(1));
		myHM.put("041514a10f", new Integer(2));
		myHM.put("0415149a97", new Integer(2));
		myHM.put("041514a3d2", new Integer(2));
		myHM.put("041514a220", new Integer(3));
		myHM.put("0415148c9c", new Integer(3));
		try {
			rfid = new RFIDPhidget();
			rfid2 = new RFIDPhidget();

			rfid.addAttachListener(new AttachListener() {
				public void attached(AttachEvent ae)
				{
					try
					{
						((RFIDPhidget)ae.getSource()).setAntennaOn(true);
						((RFIDPhidget)ae.getSource()).setLEDOn(true);
					}
					catch (PhidgetException ex) {
					}
					println("attachment of " + ae);
				}
			}
			);

			rfid.addDetachListener(new DetachListener() {
				public void detached(DetachEvent ae) {
					System.out.println("detachment of " + ae);
				}
			}
			);

			rfid.addErrorListener(new ErrorListener() {
				public void error(ErrorEvent ee) {
					System.out.println("error event for " + ee);
				}
			}
			);

			rfid.addTagGainListener(new TagGainListener()
			{
				public void tagGained(TagGainEvent oe)
				{
					System.out.println(oe);
					tag = oe.getValue();
					if(allowReads)
					{
						myTag = (Integer) myHM.get(tag);
						if(myTag == null)
							System.out.println("WTF this is unrecognized.");
						else
							System.out.println("Yay! Send this to the game controller, value: "+myTag);
					}
				}
			}
			);

			rfid.addTagLossListener(new TagLossListener()
			{
				public void tagLost(TagLossEvent oe)
				{
					System.out.println(oe);
					tag = "";
				}
			}
			);

			rfid.addOutputChangeListener(new OutputChangeListener()
			{
				public void outputChanged(OutputChangeEvent oe)
				{
					System.out.println(oe);
				}
			}
			);
			
			rfid2.addAttachListener(new AttachListener() {
				public void attached(AttachEvent ae)
				{
					try
					{
						((RFIDPhidget)ae.getSource()).setAntennaOn(true);
						((RFIDPhidget)ae.getSource()).setLEDOn(true);
					}
					catch (PhidgetException ex) {
					}
					println("attachment of " + ae);
				}
			}
			);

			rfid2.addDetachListener(new DetachListener() {
				public void detached(DetachEvent ae) {
					System.out.println("detachment of " + ae);
				}
			}
			);

			rfid2.addErrorListener(new ErrorListener() {
				public void error(ErrorEvent ee) {
					System.out.println("error event for " + ee);
				}
			}
			);

			rfid2.addTagGainListener(new TagGainListener()
			{
				public void tagGained(TagGainEvent oe)
				{
					System.out.println(oe);
					tag = oe.getValue();
					if(allowReads)
					{
						myTag = (Integer) myHM.get(tag);
						if(myTag == null)
							System.out.println("WTF this is unrecognized.");
						else
							System.out.println("Yay! Send this to the game controller, value: "+myTag);
					}
				}
			}
			);

			rfid2.addTagLossListener(new TagLossListener()
			{
				public void tagLost(TagLossEvent oe)
				{
					System.out.println(oe);
					tag = "";
				}
			}
			);

			rfid2.addOutputChangeListener(new OutputChangeListener()
			{
				public void outputChanged(OutputChangeEvent oe)
				{
					System.out.println(oe);
				}
			}
			);

			rfid.open(4787);
			println("waiting for RFID attachment…");
			rfid.waitForAttachment(1000);

			System.out.println("Serial: " + rfid.getSerialNumber());
			System.out.println("Outputs: " + rfid.getOutputCount());

			rfid2.open(5598);
			println("waiting for RFID attachment2…");
			rfid2.waitForAttachment(1000);
			System.out.println("Serial2: " + rfid2.getSerialNumber());
			System.out.println("Outputs2: " + rfid2.getOutputCount());

			System.out.println("Outputting events.");

		}
		catch (PhidgetException ex)
		{
			System.out.println(ex);
		}
	}

	void closeReader(){
		try {
			System.out.print("closing…");
			rfid.close();
			rfid = null;
			rfid2.close();
			rfid2 = null;
			System.out.println(" ok");
			if (false) {
				System.out.println("wait for finalization…");
				System.gc();
			}
		}
		catch (PhidgetException ex)
		{
			System.out.println(ex);
		}
	}

	public void enable()
	{
		System.out.println("Reading has been enabled");
		allowReads = true;
	}

	public void disable()
	{
		System.out.println("Reading has been disabled");
		allowReads = false;
	}

	public boolean isEnabled()
	{
		return allowReads;
	}
	public boolean isDisabled()
	{
		return ! allowReads;
	}
}
void setup()
{
	size(400,100);

	//Don’t forget to create the font in the tools menu above
	font = loadFont("Monaco-24.vlw");
	textFont(font);
	fill(0);
	// setup Reader
	RfidReaders r = new RfidReaders();
	r.setupReader();

	// close Reader: Should add a button or some other trigger to call this method
	//closeReader();
}

void draw()
{
	background(200);
	text("Current Tag:"+tag, 50, 50);
}
