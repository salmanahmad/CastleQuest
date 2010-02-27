class GraphicsController {
  
    /* Private ivars */
    private String IMDIR = "resources/images/"; //directory containing images
    
    //background image
    //private String backgroundImageName = "testBackgroundImage.png";
    private String backgroundImageName = "testBackgroundImage.jpg";    
    private PImage backgroundImage;
    
    //Player Castle Images
    //Multi-images names are formatted: name + num + extension, eg: castle2.png
    private String playerCastleImageName = "testPlayerCastle";
    private String playerCaslteImageExtension = ".png";
    private int numPlayerCastleImages = 3;
    private int currPlayerCastleImageNum = 0;
    private PImage[] playerCastleImages;
    private int playerCastleLocation_x = 0;
    private int playerCastleLocation_y = 400;
    private String playerCastleCollapsedImageName = "testPlayerCastleCollapsed.png";
    private PImage playerCastleCollapsedImage;
    
    private String opponentCastleImageName = "testPlayerCastle";
    private String opponentCaslteImageExtension = ".png";
    private int numOpponentCastleImages = 3;
    private int currOpponentCastleImageNum = 0;
    private PImage[] opponentCastleImages;
    private int opponentCastleLocation_x = 600;
    private int opponentCastleLocation_y = 400;
    private String opponentCastleCollapsedImageName = "testPlayerCastleCollapsed.png";
    private PImage opponentCastleCollapsedImage;
  
    private float playerHealth = 1;
    private float opponentHealth = 1;
    
    
    //cannon ball
    private String cannonBallImageName = "testCannonBall.png";
    private PImage cannonBallImage;
    private float player_cannon_x = 125; // in pixels
    private float player_cannon_y = 500;
    private float player_target_x_min = 650;
    private float player_target_x_max = 750;
    private float player_target_y_min = 500;
    private float player_target_y_max = 550;
    private float opponent_cannon_x = 675;
    private float opponent_cannon_y = 500;
    private float opponent_target_x_min = 50;
    private float opponent_target_x_max = 150;
    private float opponent_target_y_min = 500;
    private float opponent_target_y_max = 550;
    private float timeToHit_min = 1000; // in milliseconds
    private float timeToHit_max = 1500;
    
    private float cannon_gravity = 0.0003;
    
    private class Attack {
      public float time_send;
      public float time_hit;
      
      //parameters for parabola, as functions of t
      public float ax, bx; // x = ax * t + bx
      public float ay, by, cy; // y = ax * t^2 + bx * t + c
    }
    
    private ArrayList attacks;
  
  
    
    //for all the different animation sprites
    private class Animation {
      public float time_start;
      public float time_end;
      public PImage[] images;
      public int x,y;
      
      public Animation(float start, float len, PImage[] imgs, int x, int y){
        time_start = start;
        time_end = start + len;
        images = imgs;
        this.x = x;
        this.y = y;
      }
    }
    
    private ArrayList animations;
  
    private String cannonHitAnimationName = "testCannonHit";
    private String cannonHitAnimationExtension = ".png";
    private int numCannonHitAnimationImages = 2;
    private PImage[] cannonHitAnimationImages;
    private int cannonHitAnimationLength = 250; //milliseconds
  
    private String playerCastleExplodingAnimationName = "testPlayerCastleExploding";
    private String playerCastleExplodingAnimationExtension = ".png";
    private int numPlayerCastleExplodingAnimationImages = 2;
    private PImage[] playerCastleExplodingAnimationImages;
    private int playerCastleExplodingAnimationLength = 2000; //milliseconds
  
    private String opponentCastleExplodingAnimationName = "testPlayerCastleExploding";
    private String opponentCastleExplodingAnimationExtension = ".png";
    private int numOpponentCastleExplodingAnimationImages = 2;
    private PImage[] opponentCastleExplodingAnimationImages;
    private int opponentCastleExplodingAnimationLength =500; //milliseconds
  
  
    //Problem related variables
    private int currentNumber;
    private int targetNumber;
    
    //private class Alert 
  
  
    /* Public Methods */
    
    //Constructor
    public GraphicsController () {
      playerCastleImages = new PImage[numPlayerCastleImages];
      opponentCastleImages = new PImage[numOpponentCastleImages];
      cannonHitAnimationImages = new PImage[numCannonHitAnimationImages];
      playerCastleExplodingAnimationImages = new PImage[numPlayerCastleExplodingAnimationImages];
      opponentCastleExplodingAnimationImages = new PImage[numOpponentCastleExplodingAnimationImages];
      attacks = new ArrayList(32);
      animations = new ArrayList(32);
    }
    
    public void setup() {
        size(800,600);
        frameRate(120);
        smooth();
        noStroke();
        noCursor();
        fill(250);
        
        PFont font;
        font = loadFont("Georgia-64.vlw"); 
        textFont(font);
        
        //load images
        backgroundImage = loadImage(IMDIR + backgroundImageName);

        for(int i = 0; i<numPlayerCastleImages; ++i){
          playerCastleImages[i] = loadImage(IMDIR + playerCastleImageName + i + playerCaslteImageExtension);
        }
        playerCastleCollapsedImage = loadImage(IMDIR + playerCastleCollapsedImageName);
        
        for(int i = 0; i<numOpponentCastleImages; ++i){
          opponentCastleImages[i] = loadImage(IMDIR + opponentCastleImageName + i + opponentCaslteImageExtension);
        }
        opponentCastleCollapsedImage = loadImage(IMDIR + opponentCastleCollapsedImageName);
        
        cannonBallImage = loadImage(IMDIR + cannonBallImageName);
        
        for(int i = 0; i<numCannonHitAnimationImages; ++i){
          cannonHitAnimationImages[i] = loadImage(IMDIR + cannonHitAnimationName + i + cannonHitAnimationExtension);
        }
        
        for(int i = 0; i<numPlayerCastleExplodingAnimationImages; ++i){
          playerCastleExplodingAnimationImages[i] = loadImage(IMDIR + playerCastleExplodingAnimationName + i + playerCastleExplodingAnimationExtension);
        }
        
        for(int i = 0; i<numOpponentCastleExplodingAnimationImages; ++i){
          opponentCastleExplodingAnimationImages[i] = loadImage(IMDIR + opponentCastleExplodingAnimationName + i + opponentCastleExplodingAnimationExtension);
        }
    }
    
    //to draw a frame
    public void draw(){
        //just to test drawing a box
        //rect(40, 20, 40, 20);
        
        float time = millis();
        
        
        //draw background image
        image(backgroundImage,0,0);
        
        //draw Player Castle;
        if(currPlayerCastleImageNum < numPlayerCastleImages){
          image(playerCastleImages[currPlayerCastleImageNum],playerCastleLocation_x,playerCastleLocation_y);
        } else {
          image(playerCastleCollapsedImage,playerCastleLocation_x,playerCastleLocation_y);
        }
        //draw health bar?
        
        //draw Opponent Castle;
        if(currOpponentCastleImageNum < numOpponentCastleImages){
          image(opponentCastleImages[currOpponentCastleImageNum],opponentCastleLocation_x,opponentCastleLocation_y);
        } else {
          image(opponentCastleCollapsedImage,opponentCastleLocation_x,opponentCastleLocation_y);
        }
        //draw health bar?
        
        //draw attacks
        int s = attacks.size();
        for(int i = s-1; i >= 0; --i){
          Attack a = (Attack) attacks.get(i);
          float x,y;
          
          
          if(time >= a.time_hit){
            attacks.remove(i);
            float t = a.time_hit - a.time_send;
            x = a.ax*t+a.bx;
            y = a.ay*t*t+a.by*t+a.cy;
            animations.add(new Animation(time, cannonHitAnimationLength, cannonHitAnimationImages, (int)x-20, (int)y-20));
          } else {
            float t = time - a.time_send;
            x = a.ax*t+a.bx;
            y = a.ay*t*t+a.by*t+a.cy;
            image(cannonBallImage, x - 10, y - 10);
          }
        }
        
        //draw cannon if 
        if(currPlayerCastleImageNum < numPlayerCastleImages){
          // draw cannnon
        } else {
          // do NOT draw cannon
        }
        
        if(currPlayerCastleImageNum < numPlayerCastleImages){
          // draw cannnon
        } else {
          // do NOT draw cannon
        }
        
        s = animations.size();
        for(int i = s-1; i>=0; --i){
          Animation a = (Animation) animations.get(i);
          
          if(time >= a.time_end){
            animations.remove(i);
          } else {
            int imgNum = constrain(floor( (time - a.time_start) / (a.time_end - a.time_start) * a.images.length ),0,a.images.length-1);
            image(a.images[imgNum], a.x, a.y);
          }
        }
        
        //draw target and current numbers
        text("Target: " + targetNumber, 224, 120);
        text("Current: " + currentNumber, 188, 204);
        
    }
    
	// power is a percentage between 0 and 1. 
	// attacker is really an enum - it is left as an int for now...
        // assume 0 = player
        // assume 1 = opponent
	public void renderAttack(float power, int attacker) {
            if ( power <= 0 ) return;
            
            float time = millis();
            float t_targ, x_0=0, y_0=0, x_targ=0, y_targ=0;
            
            t_targ = (-power+1) * (timeToHit_max - timeToHit_min) + timeToHit_min;
	    
            switch(attacker){
              case 0:
                  x_0 = player_cannon_x;
                  y_0 = player_cannon_y;
                  x_targ = floor(random(player_target_x_min, player_target_x_max+1));
                  y_targ = floor(random(player_target_y_min, player_target_y_max+1));
                break;
              
              case 1:
                  x_0 = opponent_cannon_x;
                  y_0 = opponent_cannon_y;
                  x_targ = floor(random(opponent_target_x_min, opponent_target_x_max+1));
                  y_targ = floor(random(opponent_target_y_min, opponent_target_y_max+1));
                break;
              
              default:
                break;
            }
            
            Attack temp = new Attack();
            temp.time_send = time;
            temp.time_hit = time + t_targ;
            temp.ax = (x_targ - x_0)/t_targ;
            temp.bx = x_0;
            temp.ay = cannon_gravity;
            temp.by = (y_targ - y_0 - cannon_gravity * t_targ * t_targ)/t_targ;
            temp.cy = y_0;
            
            attacks.add(temp);
	}
	
	// this will show the animation of the collapse when it hits 0%	
	// player is really an enum, it is left as an int for now...
        // assume 0 = player
        //        1 = opponent
        //        health ranges from 0 to 1
	public void renderHealth(float health, int player) {
            float time = millis();
  
            switch(player){
              case 0: // player
                  currPlayerCastleImageNum = constrain(floor( (-health + 1) * float(numPlayerCastleImages)), 0, numPlayerCastleImages);
                  playerHealth = health;
                  if(health <= 0){
                    animations.add(new Animation(time, playerCastleExplodingAnimationLength, playerCastleExplodingAnimationImages, playerCastleLocation_x, playerCastleLocation_y));
                  }
                  
                break;
              
              case 1: // opponent
                  currOpponentCastleImageNum = constrain(floor( (-health + 1) * float(numOpponentCastleImages)), 0, numOpponentCastleImages);
                  opponentHealth = health;
                  if(health <= 0){
                    animations.add(new Animation(time, opponentCastleExplodingAnimationLength, opponentCastleExplodingAnimationImages, opponentCastleLocation_x, opponentCastleLocation_y));
                  }
                break;
              
              default:
                break;
            }
	}
	
	// parameter left as an int for now. Really it is an enum {win, lose, tie}
	public void renderVictory(int type) {
		
	}
	
	public void alertMessage(String message, int time) {
		
	}
	
	// type is left as an int - it is really a enum {bust, correct, plain, skip}
        // assume:
        // 0 = plain
        // 1 = bust
        // 2 = correct
        // 3 = skip
	public void renderProblem(int type, int current, int target) {
            currentNumber = current;
            targetNumber = target;
	}

}
