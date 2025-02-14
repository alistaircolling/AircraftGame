package services
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import model.UserDataModel;
	import model.vo.ErrorVO;
	import model.vo.MainVO;
	import model.vo.ReceivedDataVO;
	
	import signals.ErrorReceived;
	import signals.WaitSetByXML;
	
	import utils.DataUtils;

	public class InitialXMLService implements IXMLService
	{
		[Inject]
		public var userModel:UserDataModel;
		[Inject]
		public var errorReceived:ErrorReceived;
		[Inject]
		public var waitSet:WaitSetByXML;
		
		private var _data:String;
		private var _dataFile:File;
		private var _gameID:Number;
		private var _gameXML:XML;
		private var _gameFile:File;
		
		public function loadXML(__s:String=null):void
		{
			
			//load inti params			
			_data = xmlFile("Selex"+File.separator+"initParams.xml");
			handleServiceResult(_data);
		}
		
		private function xmlFile( path:String ):String{
			
			var directory:File = File.documentsDirectory;
			_dataFile = directory.resolvePath(path);
			var stream:FileStream = new FileStream();
			stream.open(_dataFile, FileMode.READ);
			var retS:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return retS;
			
		}
		
		
		
		private function handleServiceResult(s:String):void{
			trace("initialise xml received");
			 
			
			var mainXml:XML = new XML(s);
			var dataVO:MainVO = new MainVO();
			dataVO.debug = (mainXml.debug.valueOf()=="true")?true:false;
			dataVO.games = new Vector.<ReceivedDataVO>();
			//set lookup tables
			var gamesXML:XMLList = mainXml.game as XMLList;
			var xml:XML;
			for each (var xml:XML in gamesXML) 
			{
				trace("loading game data:"+xml.@name);
				//var xml:XMLList = gamesXML[i];
				var vo:ReceivedDataVO = new ReceivedDataVO();
				vo.name = xml.@name;
				vo.debug = dataVO.debug;
				//reliability
				var reliabList:XMLList = xml.reliability;
				vo.reliability = DataUtils.returnVectorFromList( reliabList[0], Number(xml.currentReliability) );
				//nff
				var nffList:XMLList = xml.nff;
				vo.nff = DataUtils.returnVectorFromList( nffList[0], Number(xml.currentNFF) );
				//turnaround
				var turnList:XMLList = xml.turnaround;
				vo.turnaround = DataUtils.returnVectorFromList( turnList[0], Number(xml.currentTurnaround) );
				//platform mgt
				if(xml.platformMgt){
					trace("it has!");
					var platform:XMLList = xml.platformMgt;
					vo.platformMgt = DataUtils.returnVectorFromList( platform[0], Number(xml.currentPlatformMgt) );
					vo.currentPlatformMgt = DataUtils.getObjectForValue( vo.platformMgt, Number(xml.currentPlatformMgt));
				}
				//mis
				if(xml.mis){
					trace("it has mis!");
					var mis:XMLList = xml.mis;
					vo.mis = DataUtils.returnVectorFromList( mis[0], Number(xml.currentMIS) );
					vo.currentMIS = DataUtils.getObjectForValue( vo.mis, Number(xml.currentMIS));
				}
				
				
				
				//
				vo.sparesCostInc = Number(xml..sparesCost_ea);
				
				//set current
				vo.currentSpares = Number(xml.currentSpares);//used to store the current value
				
				vo.currentReliability = DataUtils.getObjectForValue( vo.reliability, Number(xml.currentReliability));
				vo.currentNFF = DataUtils.getObjectForValue( vo.nff, Number(xml.currentNFF));
				vo.currentTuranaround = DataUtils.getObjectForValue( vo.turnaround, Number(xml.currentTurnaround));
				
				vo.lastPercent = 65;
				vo.initialData = true;
				//minimum values will be set on view components that the user is unable to go below and so are not referenced in the model
				
				userModel.iteration = 0;//incremented when the user presses go
				userModel.budget = Number(xml.currentBudget); //moved from last so spares stepper updates correctly
				
				dataVO.games.push(vo);
				
				
			}
			
			userModel.allVO = dataVO;
			//TODO remove for multi game version
			userModel.vo = userModel.allVO.games[0];
			userModel.currentGameVO = userModel.vo;
			
			//wait received
			var waitMilliseconds:int = Number(mainXml.waitTime)*1000;
			waitSet.dispatch(waitMilliseconds);
			
		}
		
		private function handleServiceFault(event:Object):void{
			trace("xml error in loading, dispatching error signal");
			var vo:ErrorVO = new ErrorVO();
			vo.title = "XML Load Error";
			vo.msg = "There has been an error loading the leader board, please click OK to attempt load again";
			vo.fn = "reloadLeaderBoard";
			errorReceived.dispatch(vo);
		}
	}
}