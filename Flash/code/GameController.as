﻿package code{	 	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.KeyboardEvent;	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.ui.Keyboard;	import flash.filters.*;		public class GameController extends MovieClip	{				var pause:Boolean = true;		var gameStarted:Boolean = false;				var rfidController:RFIDController = null;		var graphicsController:GraphicsController = null;						var player0:Player;		// Player Left		var player1:Player;		// Player Right				var winningPlayer = 0;		var winningAnimation = null;		var destroyedCastle = null;				public function GameController()		{			graphicsController = new GraphicsController(this);			rfidController = new RFIDController(this);			// ScoreBoard defined as symbols in flash...			player0 = new Player("Player1", scoreboard0);			player1 = new Player("Player2", scoreboard1);			// Update screen every frame			addEventListener(Event.ENTER_FRAME,enterFrameHandler);			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);						resetGame();		}								function keyHandler(event:KeyboardEvent) :void {			trace('keyboard down! "' + event.charCode + '"');						if(String.fromCharCode(event.charCode) == ' ') {				if(this.pause) {					resumeGame();				} else {					pauseGame();				}				if(!gameStarted) {					resetGame();					startGame();				}								} else if(event.charCode == 0) {				// Shift -- Restart Game...				if(gameStarted && pause) {					resetGame();				}			}		}										public function newCard(reader:int, card:int):void		{						if(pause) return						var player:Player = null;			var opponent:Player = null;						if(reader == 0)			{				player = player0;				opponent = player1;			}			else			if(reader == 1)			{				player = player1;				opponent = player0;			}			else			{				trace("Error - unknown reader used...");				return;			}						var player_index = reader;			var opponent_index = 1-reader;			player.cards_used++;			player.incrementCurrent(card);			if(player.isHit()) {				//player.updateDistance();				//graphicsController.renderHealth((Utils.END - player.distance) / Utils.END, opponent_index);								opponent.decrementHealth();				graphicsController.renderHealth(opponent.health / Utils.START, opponent_index);												player.randomizeTarget();				player.resetCards();				trace(player.name +  " hit!");				graphicsController.renderAttack(1,player_index);				graphicsController.renderHit(player_index);			} else if (player.isBust()) {				player.decrementHealth();				graphicsController.renderHealth(player.health / Utils.START, player_index);								player.randomizeTarget();				player.resetCards();								graphicsController.renderBust(player_index);								trace(player.name +  " bust!");						}			//if(player.isWin()) {			if(opponent.isDead()) {				trace(player.name +  " wins...");												winningPlayer = player_index;								// Castle destruction handled in the frame handler...				winningAnimation = graphicsController.attackQueue[graphicsController.attackQueue.length - 1];			}						if(player.isDead()) {				trace(opponent.name +  " wins...");								winningPlayer = opponent_index;								// Hanled here...				graphicsController.renderDestroyCastle(player_index);				destroyedCastle = player_index == 0 ? castle0 : castle1;							}		}				private function pauseGame():void {			stop();									var i = 0;			for(i = 0; i < graphicsController.attackQueue.length; i++) {				graphicsController.attackQueue[i].stop();			}						for(i = 0; i < graphicsController.notificationQueue.length; i++) {				graphicsController.notificationQueue[i].stop();			}							pause = true;			pauseScreen.showPause();						// push the pause screen to the front so that it covers all of the added animations...			this.setChildIndex(pauseScreen, this.numChildren - 1);		}				private function resumeGame():void {			play();			var i = 0;			for(i = 0; i < graphicsController.attackQueue.length; i++) {				graphicsController.attackQueue[i].play();			}						for(i = 0; i < graphicsController.notificationQueue.length; i++) {				graphicsController.notificationQueue[i].play();			}						pause = false;			pauseScreen.hide();		}				private function resetGame():void {						pause = true;			gameStarted = false;			pauseScreen.showStart();					}						private function startGame():void {			player0.reset();			player1.reset();			graphicsController.reset();			pause = false;			gameStarted = true;			pauseScreen.hide();						var current:Number = Utils.random()			var target:int = 0;			for(var i:int = 0; i < Math.ceil(Utils.HAND_SIZE / 2); i++)			{				target += Utils.random();			}			player0.setCurrent(current);			player0.setTarget(target);						player1.setCurrent(current);			player1.setTarget(target);		}		private function enterFrameHandler(event:Event):void		{						if(winningAnimation && winningAnimation.currentFrame == winningAnimation.totalFrames) {				//graphicsController.renderHealth(0, 1-winningPlayer);				graphicsController.renderDestroyCastle(1-winningPlayer)								winningAnimation = null;				if(winningPlayer == 0) {					destroyedCastle = castle1;				} else if(winningPlayer == 1) {					destroyedCastle = castle0;				}			}						if(destroyedCastle && destroyedCastle.currentFrame == destroyedCastle.totalFrames) {				//pauseGame();				resetGame();				destroyedCastle = null;							}		}						}}