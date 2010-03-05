﻿package code {	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.KeyboardEvent;	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.ui.Keyboard;	class GraphicsController extends MovieClip {				public var gameController:GameController;		public var attackQueue:Array;		public var notificationQueue:Array;				function GraphicsController(gameController:GameController) {			this.gameController = gameController;			attackQueue = [];			notificationQueue = [];						// Update screen every frame			addEventListener(Event.ENTER_FRAME,enterFrameHandler);								}		private function enterFrameHandler(event:Event):void		{			cleanQueue(attackQueue);			cleanQueue(notificationQueue);		}		private function cleanQueue(queue:Array) {						var i:int;						for(i = 0; i < queue.length; i++) {				var animation = queue[i];				if(animation && animation.currentFrame == animation.totalFrames) {					removeFromQueue(queue, animation);					i--;				}			}		}		private function pushToQueue(queue:Array, animation:MovieClip, x:Number, y:Number) {			animation.x = x;			animation.y = y;			queue.push(animation);			this.gameController.addChild(animation);					}		private function removeFromQueue(queue:Array, index:int) {			if(queue[index] != null) {				gameController.removeChild(queue[index]);				queue.splice(index, 1);			}		}						private function emptyQueue(queue:Array) {						var count = queue.length;			for(var i = 0; i < count; i++) {				removeFromQueue(queue, 0);			}					}				public function reset() {									emptyQueue(attackQueue);			emptyQueue(notificationQueue);									gameController.progressBar0.updatePercent(1);			gameController.progressBar1.updatePercent(1);						gameController.castle0.gotoAndStop("stop");			gameController.castle1.gotoAndStop("stop");		}		// power between 0 and 1		public function renderAttack(power:Number, player:int):void {			var animation  = null;			if(player == 0) {				animation = new CannonLaunch1();				pushToQueue(attackQueue, animation, 50, 300);				/*				animation.x = 50;				animation.y = 300;				attackQueue.push(animation);				this.gameController.addChild(animation);				*/							} else if(player == 1) {				animation = new CannonLaunch2();				pushToQueue(attackQueue, animation, 50, 300);				/*				animation.x = 50;				animation.y = 300;				attackQueue.push(animation);				this.gameController.addChild(animation);				*/							}		}		var player0Location = {x:160, y:380};		var player1Location = {x:640, y:380};		public function renderBust(player:int):void {			var location = player == 0 ? player0Location : player1Location;			var animation = new BustAnimation();			pushToQueue(notificationQueue, animation, location.x, location.y);		}		public function renderHit(player:int):void {			var location = player == 0 ? player0Location : player1Location;			var animation = new HitAnimation();			pushToQueue(notificationQueue, animation, location.x, location.y);		}		// health between 0 and 1		public function renderHealth(health:Number, player:int):void {						// Castyle Defined as a Symbol in flash...			var castle = null;			if(player == 0) {				castle = this.gameController.castle0;				gameController.progressBar0.updatePercent(health);							} else if(player == 1) {				castle = this.gameController.castle1;				gameController.progressBar1.updatePercent(health);			} 									if(health == 0 && castle) {				castle.gotoAndPlay("destroy");			}					}										public function renderVictory(type:int):void {						var message:String = "";			if(type == 0) {				message = "Player 1 Wins!";			} else if(type == 1) {				message = "Player 2 Wins!";							}						this.alertMessage(message);					}				public function alertMessage(message:String):void {			gameController.alertText.text = message;		}						public function renderProblem(type:int, current:int, target:int, player:int):void {			// Done - Implemented via the ScoreBoard and Player classes		}	}	}