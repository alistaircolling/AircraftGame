package view.mediators
{
	import flash.events.MouseEvent;
	
	import model.vo.LeaderBoardVO;
	
	import org.robotlegs.mvcs.Mediator;
	
	import signals.GameTypeSelected;
	import signals.GameTypeSet;
	import signals.LeaderBoardSet;
	import signals.LoadInitialXML;
	import signals.LoadXML;
	import signals.StartClicked;
	import signals.StatusUpdate;
	import signals.TextSetOnModel;
	import signals.WaitSetByXML;
	
	import view.components.IntroView;
	
	public class IntroMediator extends Mediator
	{
		[Inject]
		public var introView:IntroView;
		[Inject]
		public var startClicked:StartClicked;
		[Inject]
		public var textSetOnModel:TextSetOnModel;
		[Inject]
		public var leaderBoardSet:LeaderBoardSet;
		[Inject]
		public var loadXML:LoadXML;
		[Inject]
		public var update:StatusUpdate;
		[Inject]
		public var gameTypeSelected:GameTypeSelected;
		[Inject]
		public var gameTypeSet:GameTypeSet;
		[Inject]
		public var waitSet:WaitSetByXML;
		[Inject]
		public var loadInitialXML:LoadInitialXML;
		
		private var _gameType:String;
		
		override public function onRegister():void{
			trace("Intro Mediator registered");
			update.dispatch("Intro mediator registered");
			//register listeners 
			addListeners();
			//should not load leaderboard first
			//loadXML.dispatch();
			loadInitialXML.dispatch();
			
			
		}
		
		override public function onRemove():void{
			
			introView.planeButton.removeEventListener(MouseEvent.CLICK, planeClicked);
			introView.heliButton.removeEventListener(MouseEvent.CLICK, heliClicked);
			introView.continueButton.removeEventListener(MouseEvent.CLICK, videoContinueClicked);
			introView.startGameButton.removeEventListener(MouseEvent.CLICK, onStartClicked);
			//add listener for signal
			//FIXME ? not sure of these may need to be removed though it may be on purpose
			textSetOnModel.add(onModelChanged);
			leaderBoardSet.add(updateLeaderBoard);
			//
			waitSet.remove(onWaitSet);
			gameTypeSet.remove(onGameTypeSet);
			
		}
		
		private function addListeners():void{
			trace("add intro mediator listeners");
			waitSet.add(onWaitSet);
			introView.continueButton.addEventListener(MouseEvent.CLICK, videoContinueClicked);
			introView.planeButton.addEventListener(MouseEvent.CLICK, planeClicked);
			introView.heliButton.addEventListener(MouseEvent.CLICK, heliClicked);
			introView.startGameButton.addEventListener(MouseEvent.CLICK, onStartClicked);
			
			//add listener for signal
			textSetOnModel.add(onModelChanged);
			leaderBoardSet.add(updateLeaderBoard);
			gameTypeSet.add(onGameTypeSet);
		}
		
		private function onGameTypeSet(s:String):void
		{
			_gameType = s;
			
		}
		
		protected function onStartClicked(event:MouseEvent):void
		{
			startClicked.dispatch();			
		}
		//milliseconds wait set
		private function onWaitSet(n:int):void{
			introView.interactionWait = n;
			
		}
		private function videoContinueClicked( m:MouseEvent ):void{
			
			introView.showVideo(false);		
			if (_gameType=="plane"||_gameType=="heli"){
				introView.startTimer(true);
			}
		}
		private function updateLeaderBoard( vo:LeaderBoardVO ):void{
			introView.leaderboardIntro.dp = vo.winners;
		}
		
		//be sure to pass the corect data type of the signal
		public function onModelChanged(__s:String):void{
			
			
		}
		
		private function planeClicked( m:MouseEvent ):void{
			if (_gameType=="plane"||_gameType=="heli"){
				introView.startTimer(false);
			}
				//FIXME ? i dont think this is used anywhere 
			//	gameTypeSelected.dispatch("plane");
				startClicked.dispatch();
		}
		private function heliClicked( m:MouseEvent ):void{
			if (_gameType=="plane"||_gameType=="heli"){
				introView.startTimer(false);
			}
		//		gameTypeSelected.dispatch("heli");
				startClicked.dispatch();
		}
		
	
	}
}