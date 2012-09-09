package controllers
{
	import model.UserDataModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	import services.LeaderBoardService;
	
	public class GameTypeSelectedCommand extends SignalCommand
	{
		[Inject]
		public var type:String;
		[Inject]
		public var userDataModel:UserDataModel;
		[Inject]
		public var leaderBoardService:LeaderBoardService;
		
		override public function execute():void{
			
			userDataModel.gameType = type;
			//load the correct leaderbord
			leaderBoardService.requestData(type);
			
		}
	}
}