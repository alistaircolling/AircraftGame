package controllers
{
	import model.UserDataModel;
	import model.vo.GraphResultsVO;
	import model.vo.ReceivedDataVO;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	import services.InitialXMLService;
	
	import utils.DataUtils;
	
	public class BlackBoxDataReceivedCommand extends SignalCommand
	{
		[Inject]
		public var xml:XML;//received form black box
		[Inject]
		public var userModel:UserDataModel;
		[Inject]
		public var intialXMLService:InitialXMLService;
		
		
		override public function execute():void{
			
		
			
			//SET THE GRAPH VO FIRST TO AVOID ITERATION SHOWING IN INPUT PANEL
			
			//create the graphresult vo
			var graphVO:GraphResultsVO = new GraphResultsVO();
			//create the vectors
			var pcFlown:Vector.<Number>;
			var pcVals:String = xml..percentSuccess.valueOf();
			var pc:Array = pcVals.split(",");
			pcFlown = DataUtils.convertArrayToVector(pc);
			var month:Vector.<Number>;
			var monthVals:String = xml..monthTotal.valueOf();
			var monthA:Array = monthVals.split(",");
			month = DataUtils.convertArrayToVector(monthA);
			var inAir:Vector.<Number>;
			var inAirVals:String = xml..inUse.valueOf();
			var inA:Array = inAirVals.split(",");
			
			inAir = DataUtils.convertArrayToVector(inA);
			var onGround:Vector.<Number>;
			var onGVals:String = xml..unavailable.valueOf();
			var onG:Array = onGVals.split(",");
			onGround = DataUtils.convertArrayToVector(onG);
			
			graphVO.inAir = inAir;
			graphVO.monthTotal = month;
			graphVO.onGround = onGround;
			graphVO.percentFlown = pcFlown;
			
			
		
			//set graph vo
			userModel.graphVO = graphVO;
		
			//TODO update to match the new xml structure
			trace("black box data received command");
			var vo:ReceivedDataVO = new ReceivedDataVO();
			trace("rel:"+userModel.currentGameVO.reliability+":"+ Number(xml..currentReliability));
			vo.currentReliability = DataUtils.getObjectForValue(userModel.currentGameVO.reliability, Number(xml..currentReliability));
			vo.currentNFF = DataUtils.getObjectForValue(userModel.currentGameVO.nff, xml..currentNFF);
			vo.currentTuranaround = DataUtils.getObjectForValue(userModel.currentGameVO.turnaround, xml..currentTurnaround);
			//new
			vo.currentPlatformMgt = DataUtils.getObjectForValue(userModel.currentGameVO.platformMgt, xml..currentPlatformMgt);
			vo.currentMIS = DataUtils.getObjectForValue(userModel.currentGameVO.mis, xml..currentMIS);
			
			vo.currentSpares = Number(xml..currentSpares);
			vo.sparesCostInc = userModel.currentGameVO.sparesCostInc;//already set and so retrieved
			vo.iteration = Number(xml..iteration);
			
			vo.lastPercent = graphVO.percentFlown[graphVO.percentFlown.length-1];
			if (vo.iteration == 3){
				
				vo.avAvailability = xml..averageAchieved;
				//TODO need to check if the final score value should be money in bank for all games
				vo.finalScore = Number(xml..moneyInBank);
				vo.costPerFHr = Number(xml..costperFH);
			}
			
			//update vectors to start at minimum values
			vo.reliability = DataUtils.getVectorFromStartingVO(userModel.currentGameVO.reliability, vo.currentReliability);
			vo.nff = DataUtils.getVectorFromStartingVO(userModel.currentGameVO.nff, vo.currentNFF);
			vo.turnaround = DataUtils.getVectorFromStartingVO(userModel.currentGameVO.turnaround, vo.currentTuranaround);
			//new
			vo.platformMgt = DataUtils.getVectorFromStartingVO(userModel.currentGameVO.platformMgt, vo.currentPlatformMgt);
			vo.mis = DataUtils.getVectorFromStartingVO(userModel.currentGameVO.mis, vo.currentMIS);
			
			vo.initialData = false;
			//set on the model
			
			userModel.currentGameVO = vo;
			
			//set the iteration on the model
			userModel.iteration = Number(xml..iteration);
			var theBudget:Number = Number(xml..currentBudget);
			
			userModel.budget = theBudget;
			
			
		}
		
	}
}