class GraphicsController {

	/* Public Methods */
	
	// power is a percentage between 0 and 1. 
	// attacker is really an enum - it is left as an int for now...
	public void renderAttack(float power, int attacker) {
		
	}
	
	// this will show the animation of the collapse when it hits 0%	
	// player is really an enum, it is left as an int for now...
	public void renderHealth(float health, int player) {

	}
	
	// parameter left as an int for now. Really it is an enum {win, lose, tie}
	public void renderVictory(int type) {
		
	}
	
	public void alertMessage(String message, int time) {
		
	}
	
	// type is left as an int - it is really a enum {bust, correct, plain, skip}
	public void renderProblem(int type, int current, int target) {
		
	}

}
