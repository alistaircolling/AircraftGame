package controllers
{
	
	
	
	import model.UserDataModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	import services.CompiledXMLService;
	import services.LeaderBoardService;
	
	public class LoadLeaderBoardXML extends SignalCommand
	{
		[Inject]
		public var leaderBoard:LeaderBoardService;
		[Inject]
		public var userModel:UserDataModel;	
		
		override public function execute():void{
			var gType:String = userModel.gameType;
			leaderBoard.requestData(gType);
			
		}
	}
}