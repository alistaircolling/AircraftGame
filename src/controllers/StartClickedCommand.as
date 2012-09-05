package controllers
{
	import model.ExampleModel;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.SignalCommand;
	
	import services.BlackBoxService;
	import services.InitialXMLService;
	import services.LeaderBoardService;
	
	import signals.ChangeState;
	
	public class StartClickedCommand extends SignalCommand
	{
	
		[Inject]
		public var leaderBoardService:LeaderBoardService;
		[Inject]
		public var changeState:ChangeState;
		[Inject]
		public var initXMLService:InitialXMLService;
		
		
		
		override public function execute():void{
			
			trace("start clicked command, loading intial XML.....");
			//TODO must reauest the leaderboard for the corect game- probably ill go in the service
			
			leaderBoardService.requestData();
			//relocated to LoadIniitalXMLCOmmand
			//initXMLService.loadXML("data/initParams.xml");
			
		
		}
		
		
	}
}