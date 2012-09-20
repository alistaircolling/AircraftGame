package view.mediators
{
	import flash.events.MouseEvent;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import model.UserDataModel;
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
		[Inject]
		public var userModel:UserDataModel;
		
		override public function onRegister():void{
			trace("Intro Mediator registered");
			trace("+++++++++++++INTRO PANEL ADDED+++++++++++++");
			update.dispatch("Intro mediator registered");
			//register listeners 
			addListeners();
			//check if xml is already loaded
			if(!userModel.vo || userModel.vo.iteration==3){
				trace("loading xml as this is the first time!");
				loadXML.dispatch();
			}else{
				trace("not loading XML from input mediator as it is already loaded");
			}
			
		}
		
		override public function onRemove():void{
			trace("///////INTRO PANEL REMOVED////////");
		//	introView.planeButton.removeEventListener(MouseEvent.CLICK, planeClicked);
		//	introView.heliButton.removeEventListener(MouseEvent.CLICK, heliClicked);
			introView.continueButton.removeEventListener(MouseEvent.CLICK, videoContinueClicked);
			introView.startButton.removeEventListener(MouseEvent.CLICK, startLand);
			//add listener for signal
			textSetOnModel.add(onModelChanged);
			leaderBoardSet.add(updateLeaderBoard);
			waitSet.remove(onWaitSet);
			copySet.remove(onCopySet);
			
		}
		
		private function addListeners():void{
			trace("add intro mediator listeners");
			introView.continueButton.addEventListener(MouseEvent.CLICK, videoContinueClicked);
		//	introView.planeButton.addEventListener(MouseEvent.CLICK, planeClicked);
		//	introView.heliButton.addEventListener(MouseEvent.CLICK, heliClicked);
			introView.startButton.addEventListener(MouseEvent.CLICK, startLand);
			
			waitSet.add(onWaitSet);
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
				//load xml again to reset?
				
				//startClicked.dispatch();
				changeState.dispatch(ChangeState.ENTER_SCREEN); //this has been removed from initxmlservice spo we can set the text first
				userModel.vo = userModel.vo;
				//userModel.budget = userModel.budget;
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