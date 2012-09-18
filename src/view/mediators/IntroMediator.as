package view.mediators
{
	import flash.events.MouseEvent;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import model.vo.CopyVO;
	import model.vo.LeaderBoardVO;
	
	import org.robotlegs.mvcs.Mediator;
	
	import signals.ChangeState;
	import signals.CopySet;
	import signals.GameTypeSelected;
	import signals.LeaderBoardSet;
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
		public var waitSet:WaitSetByXML;
		[Inject]
		public var changeState:ChangeState;
		[Inject]
		public var copySet:CopySet;
		
		override public function onRegister():void{
			trace("Intro Mediator registered");
			update.dispatch("Intro mediator registered");
			//register listeners 
			addListeners();
			//
			loadXML.dispatch();
			
		}
		
		override public function onRemove():void{
			
			introView.planeButton.removeEventListener(MouseEvent.CLICK, planeClicked);
			introView.heliButton.removeEventListener(MouseEvent.CLICK, heliClicked);
			introView.continueButton.removeEventListener(MouseEvent.CLICK, videoContinueClicked);
			//add listener for signal
			textSetOnModel.add(onModelChanged);
			leaderBoardSet.add(updateLeaderBoard);
			waitSet.remove(onWaitSet);
			copySet.remove(onCopySet);
			
		}
		
		private function addListeners():void{
			trace("add intro mediator listeners");
			waitSet.add(onWaitSet);
			introView.continueButton.addEventListener(MouseEvent.CLICK, videoContinueClicked);
		//	introView.planeButton.addEventListener(MouseEvent.CLICK, planeClicked);
		//	introView.heliButton.addEventListener(MouseEvent.CLICK, heliClicked);
			introView.startButton.addEventListener(MouseEvent.CLICK, startLand);
			
			//add listener for signal
			textSetOnModel.add(onModelChanged);
			leaderBoardSet.add(updateLeaderBoard);
			copySet.add(onCopySet);
			
		}
		
		private function onCopySet(vo:CopyVO):void
		{
			introView.introText.textFlow = TextConverter.importToFlow(vo.introText, TextConverter.TEXT_FIELD_HTML_FORMAT)
			
		}
		//milliseconds wait set
		private function onWaitSet(n:int):void{
			introView.interactionWait = n;
			
		}
		private function videoContinueClicked( m:MouseEvent ):void{
			
			introView.showVideo(false);		
			//introView.startTimer(true);
		}
		private function updateLeaderBoard( vo:LeaderBoardVO ):void{
			introView.leaderboardIntro.dp = vo.winners;
		}
		
		//be sure to pass the corect data type of the signal
		public function onModelChanged(__s:String):void{
			
			
		}
		private function startLand( m:MouseEvent ):void{
				introView.startTimer(false);
				gameTypeSelected.dispatch("land");
				//startClicked.dispatch();
				changeState.dispatch(ChangeState.ENTER_SCREEN); //this has been removed from initxmlservice spo we can set the text first
		}
		
		private function planeClicked( m:MouseEvent ):void{
				introView.startTimer(false);
				gameTypeSelected.dispatch("plane");
				startClicked.dispatch();
		}
		private function heliClicked( m:MouseEvent ):void{
				introView.startTimer(false);
				gameTypeSelected.dispatch("heli");
				startClicked.dispatch();
		}
		
	
	}
}