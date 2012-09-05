package controllers
{
	import model.ExampleModel;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.SignalCommand;
	
	import services.BlackBoxService;
	import services.InitialXMLService;
	import services.LeaderBoardService;
	
	import signals.ChangeState;
	
	public class LoadInitialXMLCommand extends SignalCommand
	{
		
		[Inject]
		public var initXMLService:InitialXMLService;
		
		
		override public function execute():void{
			trace("EXECUTE!!!!");
			trace("load initialXMLCOmmand execute");
			initXMLService.loadXML("data/initParams.xml");
		
		}
		
		
	}
}