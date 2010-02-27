 	int start = 0;
        int end = 10;

	int hand_size = 6;
	int card_limit = 5; 

	int randomNumber()
	{
            return ceil(random(1.0)*card_limit);
	}


class GameController
{

	GraphicsController graphicsController;
	NetworkController networkController;
	RFIDController rfidController;

	Player player1;
	Player player2;

	GameController(GraphicsController gc)
	{

		graphicsController = gc;
		graphicsController.setup();

		rfidController = new RFIDController(this);
		rfidController.setup();

		networkController = new NetworkController();
		
		player1 = new Player("Player1", gc);
		player2 = new Player("Player2", gc);

	}
	public void newCard(int reader, int card)
	{
		Player p = null;
		if(reader == 1)
		{
                        println("\n\n---Player1----\n\n");          
			p = player1;
		}
		else
		if(reader == 2)
		{
                        println("\n\n---Player2----\n\n");  
			p = player2;
		}
		else
		{
			println("Error - unknown reader used...");
			return;
		}


                graphicsController.renderAttack(1,reader - 1);

		p.cards_used++;
		p.incrementCurrent(card);

		if(p.isHit()) {
			
			p.updateDistance();
			p.setTarget();
			p.resetCards();

			println(p.name +  " hit!");
		} else if (p.isBust()) {
			
			p.setTarget();
			p.resetCards();			
			
			println(p.name +  " bust!");			
		}
		
		if(p.isWin()) {
			println(p.name +  " wins...");
		}


	}





	private void reset_game()
	{
		player1.reset();
		player2.reset();
	}


}


class Player
{

        public GraphicsController graphicsController;
	public String name;

	public int distance = 0;

	public int current = -1;
	public int target = -1;

	public int cards_used = 0;
	public int start_time = 0;
	public int time_weight = 100000000;

	Player(String name, GraphicsController gc) {
		this.name = name;
                this.graphicsController = gc;
	}

	public void resetCards() {
		this.cards_used = 0;
	}

	public void reset()
	{
		this.distance = start;
		this.cards_used = 0;
	}

	public void updateDistance()
	{
		//time = (new Date()) - start_time;
		//increment = cards_used + (1/time) * time_weight;

		int increment = cards_used;
		distance += increment;

	}

	public void incrementCurrent(int increment) {
		this.current += increment;
	}


	public void setTarget()
	{
		int increment = 0;
		for(int i = 0; i < ceil(hand_size / 2); i++)
		{
			increment += randomNumber();
		}

		this.target = this.current + increment;

	}

	public boolean isHit() {
		return this.current == this.target;
	}
	
	public boolean isBust() {
		return this.current > this.target;
	}
	
	public boolean isWin() {
		return this.distance >= end;
	}


}

