﻿package code{	 	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.KeyboardEvent;	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.ui.Keyboard;	import flash.filters.*;		import flash.media.Sound;    import flash.media.SoundChannel;    import flash.net.URLRequest;		public class GameController extends MovieClip	{				var pause:Boolean = true;		var gameStarted:Boolean = false;				var rfidController:RFIDController = null;		var graphicsController:GraphicsController = null;						var player0:Player;		// Player Left		var player1:Player;		// Player Right				var winningPlayer = 0;		var winningAnimation = null;		var destroyedCastle = null;				var actionMusic:Sound = null;		var victoryMusic:Sound = null;		var cardMusic:Sound = null;		var bustMusic:Sound = null;				var actionUrl:String = "action.mp3";		var victoryUrl:String = "victory.mp3";				var cardUrl:String = "card.mp3";		var bustUrl:String = "bust.mp3";		        var actionSong:SoundChannel = null;        var victorySong:SoundChannel = null;						public function GameController()		{			actionMusic = new Sound();			victoryMusic = new Sound();			cardMusic = new Sound();			bustMusic = new Sound();						var actionRequest:URLRequest = new URLRequest(actionUrl);			var victoryRequest:URLRequest = new URLRequest(victoryUrl);						var cardRequest:URLRequest = new URLRequest(cardUrl);			var bustRequest:URLRequest = new URLRequest(bustUrl);			            actionMusic.load(actionRequest);            victoryMusic.load(victoryRequest);				cardMusic.load(cardRequest);			bustMusic.load(bustRequest);			graphicsController = new GraphicsController(this);			rfidController = new RFIDController(this);			// ScoreBoard defined as symbols in flash...			player0 = new Player("Player1", scoreboard0);			player1 = new Player("Player2", scoreboard1);			// Update screen every frame			addEventListener(Event.ENTER_FRAME,enterFrameHandler);			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);			//stage.allowFullscreen=true;						resetGame();		}								function keyHandler(event:KeyboardEvent) :void {			trace('keyboard down! "' + event.charCode + '"');						stage.displayState == "normal" ? "fullScreen" : "normal";						if(String.fromCharCode(event.charCode) == ' ') {				if(this.pause) {					resumeGame();				} else {					pauseGame();				}				if(!gameStarted) {					resetGame();					startGame();				}								} else if(event.charCode == 0) {				// Shift -- Restart Game...				if(gameStarted && pause) {					resetGame();				}			} else {				stage.displayState = "fullScreen";			}		}										public function newCard(reader:int, card:int):void		{						if(pause) return						var player:Player = null;			var opponent:Player = null;						if(reader == 0)			{				player = player0;				opponent = player1;			}			else			if(reader == 1)			{				player = player1;				opponent = player0;			}			else			{				trace("Error - unknown reader used...");				return;			}						var player_index = reader;			var opponent_index = 1-reader;			var busted:Boolean = false;						player.cards_used++;			player.incrementCurrent(card);			if(player.isHit()) {				//player.updateDistance();				//graphicsController.renderHealth((Utils.END - player.distance) / Utils.END, opponent_index);								opponent.decrementHealth();				graphicsController.renderHealth(opponent.health / Utils.START, opponent_index);								var canon = null;				canon = player_index == 0 ? canon0 : canon1;				canon.gotoAndPlay("fire");												player.randomizeTarget();				player.resetCards();				trace(player.name +  " hit!");				graphicsController.renderAttack(1,player_index);				graphicsController.renderHit(player_index);			} else if (player.isBust()) {								busted = true;								player.decrementHealth();				graphicsController.renderHealth(player.health / Utils.START, player_index);								player.randomizeTarget();				player.resetCards();								graphicsController.renderBust(player_index);								trace(player.name +  " bust!");						}			if(busted) {				bustMusic.play();			} else {				cardMusic.play();			}			//if(player.isWin()) {			if(opponent.isDead()) {				trace(player.name +  " wins...");												winningPlayer = player_index;								// Castle destruction handled in the frame handler...				winningAnimation = graphicsController.attackQueue[graphicsController.attackQueue.length - 1];			}						if(player.isDead()) {				trace(opponent.name +  " wins...");								winningPlayer = opponent_index;								// Hanled here...				graphicsController.renderDestroyCastle(player_index);				destroyedCastle = player_index == 0 ? castle0 : castle1;							}		}				private function pauseGame():void {			stop();									var i = 0;			for(i = 0; i < graphicsController.attackQueue.length; i++) {				graphicsController.attackQueue[i].stop();			}						for(i = 0; i < graphicsController.notificationQueue.length; i++) {				graphicsController.notificationQueue[i].stop();			}							pause = true;			pauseScreen.showPause();						// push the pause screen to the front so that it covers all of the added animations...			this.setChildIndex(pauseScreen, this.numChildren - 1);		}				private function resumeGame():void {			play();			var i = 0;			for(i = 0; i < graphicsController.attackQueue.length; i++) {				graphicsController.attackQueue[i].play();			}						for(i = 0; i < graphicsController.notificationQueue.length; i++) {				graphicsController.notificationQueue[i].play();			}						pause = false;			pauseScreen.hide();		}				private function resetGame():void {						pause = true;			gameStarted = false;			pauseScreen.showStart();						trace("remove me - 1");			pauseScreen.hide();					}						private function startGame():void {			if(victorySong) { victorySong.stop(); victorySong = null; }			if(!actionSong) {				actionSong = actionMusic.play(0, 10000000000);			}						player0.reset();			player1.reset();			graphicsController.reset();			pause = false;			gameStarted = true;			pauseScreen.hide();						var current:Number = Utils.random();			var target:Number = current + Utils.random();			player0.setCurrent(current);			player0.setTarget(target);						player1.setCurrent(current);			player1.setTarget(target);		}		private function enterFrameHandler(event:Event):void		{						if(winningAnimation && winningAnimation.currentFrame == winningAnimation.totalFrames) {				//graphicsController.renderHealth(0, 1-winningPlayer);				graphicsController.renderDestroyCastle(1-winningPlayer)								winningAnimation = null;				if(winningPlayer == 0) {					destroyedCastle = castle1;				} else if(winningPlayer == 1) {					destroyedCastle = castle0;				}			}						if(destroyedCastle && destroyedCastle.currentFrame == destroyedCastle.totalFrames) {				//pauseGame();				resetGame();								if(actionSong) { actionSong.stop(); actionSong = null;}				if(!victorySong) {					victorySong = victoryMusic.play();				}								destroyedCastle = null;							}		}						}}