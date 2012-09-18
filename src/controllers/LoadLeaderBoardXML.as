package controllers
{
	
	
	
	import org.robotlegs.mvcs.SignalCommand;
	
	import services.CompiledXMLService;
	import services.InitialXMLService;
	import services.LeaderBoardService;
	
	public class LoadLeaderBoardXML extends SignalCommand
	{
		[Inject]
		public var leaderBoard:LeaderBoardService;
		[Inject]
		public var initXMLService:InitialXMLService;
		
		
		override public function execute():void{
		//TODO remove for the multi version game
			initXMLService.loadXML("data/initParams.xml");
			leaderBoard.requestData();
			
		}
	}
}