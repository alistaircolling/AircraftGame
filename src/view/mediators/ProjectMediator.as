package view.mediators
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.vo.LeaderBoardVO;
	import model.vo.MainVO;
	import model.vo.ReceivedDataVO;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import signals.ChangeState;
	import signals.ErrorReceived;
	import signals.GameIDSet;
	import signals.GameTypeSet;
	import signals.InitSocket;
	import signals.LeaderBoardSet;
	import signals.MusicVolumeSet;
	import signals.RequestGameID;
	import signals.RestartGame;
	import signals.StartClicked;
	import signals.StatusUpdate;
	import signals.TextSetOnModel;
	import signals.UserDataSet;
	
	import utils.CustomEvent;
	
	import view.components.InputPanel;
	import view.components.IntroView;
	
	public class ProjectMediator extends Mediator
	{
		[Inject]
		public var viewComp:AircraftGame;
		[Inject]
		public var buttonClicked:StartClicked;
		[Inject]
		public var textSetOnModel:TextSetOnModel;
		[Inject]
		public var errorReceived:ErrorReceived;
		[Inject]
		public var changeState:ChangeState;
		[Inject]
		public var statusUpdate:StatusUpdate;
		[Inject]
		public var gameIDSet:GameIDSet;
		[Inject]
		public var requestID:RequestGameID;
		[Inject]
		public var initSocket:InitSocket;
		[Inject]
		public var lBSet:LeaderBoardSet;
		[Inject]
		public var restartGame:RestartGame;
		[Inject]
		public var userDataSet:UserDataSet;
		[Inject]
		public var gameTypeSet:GameTypeSet;
		[Inject]
		public var musicVolSet:MusicVolumeSet;
		
		override public function onRegister():void{
			trace("Project Mediator registered");
			//register listeners 
			addListeners();
		}
		
		
		
		private function addListeners():void {
			trace("add listeners project mediator");
			userDataSet.add(showDebug);
			changeState.add(updateState);
			statusUpdate.add(showStatus);
			gameIDSet.add(setGameID);
			lBSet.add(leaderBoardSet);
			gameTypeSet.add(gameTypeSetListener);
			errorReceived.add(showErrorReceived);
			return;
			requestID.dispatch();
			initSocket.dispatch();
			viewComp.addEventListener("restart", restartGameListener);
			viewComp.addEventListener("toggleMute", toggleMuteListener);
			viewComp.addEventListener(IntroView.SHOW_PREVIEW_VIDEO, onShowPreviewVideo);
			viewComp.closePreviewVid.addEventListener(MouseEvent.CLICK, onClosePreviewVid);
		}
		
		private function onClosePreviewVid(m:MouseEvent):void{
			trace("close preview vid");
			viewComp.previewVideo.stop();
			viewComp.previewVid.visible = false;
			
			if (viewComp.gType =="plane"||viewComp.gType =="heli") viewComp.introView.startTimer(true);
			
		}
		
		private function onShowPreviewVideo(e:Event):void{
			trace("show preview vid");
			viewComp.previewVideo.play();
			viewComp.previewVid.visible = true;
			//set to top index
			var par:*  = viewComp.previewVid.parent;
			
			viewComp.setElementIndex(viewComp.previewVid, viewComp.numElements-3);
			
		}
		
		private function toggleMuteListener(e:Event):void{
			
			musicVolSet.dispatch(-1);
			
		}
		
		private function gameTypeSetListener( s:String ):void{
			viewComp.gType = s;
			switch(s){
				case "plane":
					viewComp.heliBackground.visible = false;
					viewComp.planeBackground.visible = true;
					viewComp.introView.introPanelHeli.visible = false;
					viewComp.introView.introPanelPlane.visible = true;
					break
				case "heli":
					viewComp.heliBackground.visible = true;
					viewComp.planeBackground.visible = false;
					viewComp.introView.introPanelHeli.visible = true;
					viewComp.introView.introPanelPlane.visible = false;
					break
				case "land":
					//TODO add the correct elements
					
					viewComp.heliBackground.visible = true;
					viewComp.planeBackground.visible = false;
					viewComp.introView.introPanelHeli.visible = true;
					viewComp.introView.introPanelPlane.visible = false;
					break
			}
		}
		
		//TODO update the signal tohave the MainVO
		private function showDebug( vo:ReceivedDataVO ):void{
			//TODO temporarily hiding this so the music doesnt play
			viewComp.statusLabel.visible = vo.debug;
			userDataSet.removeAll();//remove after the first time the game is launched
			
		}
		
		private function restartGameListener( e:CustomEvent ):void{
			
			restartGame.dispatch();
			
		}
		
		private function showErrorReceived( s:String ):void{
			
			viewComp.showTheError(s);
		}
		
		private function leaderBoardSet( vo:LeaderBoardVO ):void{
			
			var top3:Array = vo.winners.source.slice(0,3);
			var ac:ArrayCollection = new ArrayCollection(top3);
			viewComp.leaderBoard.dp = ac;
			
		}
		
		private function setGameID( n:Number ):void{
			viewComp.gameID.text = "GAME ID:  "+n.toString();
		}
		
		private function showStatus( s:String ):void{
			
			viewComp.statusLabel.text += "\n--------------\n"+s;
		}
		
		private function updateState( s:String ):void{
			showStatus("update state in project mediator");
			viewComp.updateState(s);
		}
		
		
		//be sure to pass the corect data type of 
		public function onModelChanged(__s:String):void{
			
			
		}
		
		private function buttonClickedListener(__m:MouseEvent):void { 
			
			//send signal
			buttonClicked.dispatch();
			
		}
		
	}
}