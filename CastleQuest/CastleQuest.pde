// Main project file. This file should simply instantiate GameController and transfer control to it...


/* Bootstrap */
GraphicsController graphicsController;
GameController gameController;

void setup()
{
	graphicsController = new GraphicsController();
	gameController = new GameController(graphicsController);
}

void draw()
{
	graphicsController.draw();

	//just testing
}

/* Global Convenience Methods... */





