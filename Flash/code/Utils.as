﻿package code {	public class Utils {				public static const START:int = 7;		public static const END:int = 0;				public static const HAND_SIZE:int = 6;		public static const CARD_LIMIT:int = 5;				public static function random():int		{			return Math.ceil(Math.random()*CARD_LIMIT);		}	 				}}