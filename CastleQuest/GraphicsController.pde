class GraphicsController
{

	/* Private ivars */
	private String IMDIR = "resources/images/"; //directory containing images

	//background image
	private String backgroundImageName = "testBackgroundImage.png";
	private PImage backgroundImage;

	//Player Castle Images
	//formatted: playerCastleImageName + num + playerCaslteImageExtension
	private String playerCastleImageName = "testPlayerCastle";
	private String playerCaslteImageExtension = ".png";
	private int numPlayerCastleImages = 3;
	private int currPlayerCastleImageNum = 0;
	private PImage[] playerCastleImages;

	private String opponentCastleImageName = "testPlayerCastle";
	private String opponentCaslteImageExtension = ".png";
	private int numOpponentCastleImages = 3;
	private int currOpponentCastleImageNum = 0;
	private PImage[] opponentCastleImages;


	private float playerHealth = 1;
	private float opponentHealth = 1;


	/* Public Methods */

	//Constructor
	public GraphicsController ()
	{
		playerCastleImages = new PImage[numPlayerCastleImages];
		opponentCastleImages = new PImage[numOpponentCastleImages];
	}

	public void setup()
	{
		size(800,600);
		frameRate(10);
		smooth();
		noStroke();
		noCursor();
		fill(250);

		//load images
		backgroundImage = loadImage(IMDIR + backgroundImageName);

		for(int i = 0; i<numPlayerCastleImages; ++i)
		{
			playerCastleImages[i] = loadImage(IMDIR + playerCastleImageName + i + playerCaslteImageExtension);
		}

		for(int i = 0; i<numOpponentCastleImages; ++i)
		{
			opponentCastleImages[i] = loadImage(IMDIR + opponentCastleImageName + i + opponentCaslteImageExtension);
		}

	}

	//to draw a frame
	public void draw()
	{
		//just to test drawing a box
		rect(40, 20, 40, 20);

		//draw background image
		image(backgroundImage,0,0);

		//draw Player Castle;
		image(playerCastleImages[currPlayerCastleImageNum],0,400);
		//draw health bar?

		//draw Opponent Castle;
		image(opponentCastleImages[currOpponentCastleImageNum],600,400);
		//draw health bar?


	}

	// power is a percentage between 0 and 1.
	// attacker is really an enum - it is left as an int for now...
	public void renderAttack(float power, int attacker)
	{

	}

	// this will show the animation of the collapse when it hits 0%
	// player is really an enum, it is left as an int for now...
	// assume 0 = player
	//        1 = opponent
	//        health ranges from 0 to 1
	public void renderHealth(float health, int player)
	{
		switch(player)
		{
		case 0: // player
			currPlayerCastleImageNum = constrain(floor( (-health + 1) * float(numPlayerCastleImages)), 0, numPlayerCastleImages - 1);
			playerHealth = health;
			break;

		case 1: // opponent
			currOpponentCastleImageNum = constrain(floor( (-health + 1) * float(numOpponentCastleImages)), 0, numOpponentCastleImages - 1);
			opponentHealth = health;
			break;

		default:
			break;
		}
	}

	// parameter left as an int for now. Really it is an enum {win, lose, tie}
	public void renderVictory(int type)
	{

	}

	public void alertMessage(String message, int time)
	{

	}

	// type is left as an int - it is really a enum {bust, correct, plain, skip}
	// assume:
	// 0 = plain
	// 1 = bust
	// 2 = correct
	// 3 = skip
	public void renderProblem(int type, int current, int target)
	{

	}

}


