package model
{
	import model.vo.GraphResultsVO;
	import model.vo.MainVO;
	import model.vo.ReceivedDataVO;
	
	import org.robotlegs.mvcs.Actor;
	
	import services.LeaderBoardService;
	
	import signals.BalanceSet;
	import signals.ChangeState;
	import signals.GameIDSet;
	import signals.GameTypeSet;
	import signals.GraphDataSet;
	import signals.IterationChange;
	import signals.StageSet;
	import signals.UserDataSet;
	import signals.UserDataSetLive;
	
	public class UserDataModel extends Actor
	{
		[Inject]
		public var userDataSet:UserDataSet;
		[Inject]
		public var stageSet:StageSet;
		[Inject]
		public var changeState:ChangeState;
		[Inject]
		public var balanceSet:BalanceSet;
		[Inject]
		public var iterationChange:IterationChange;
		[Inject]
		public var graphDataSet:GraphDataSet;
		[Inject]
		public var gameIDSet:GameIDSet;
		[Inject]
		public var testSignal:UserDataSetLive;
		[Inject]
		public var gameTypeSet:GameTypeSet;
		[Inject]
		public var leaderboardService:LeaderBoardService;
		
		private var _gameID:Number;
		
		private var _graphVO:GraphResultsVO;
		
		private var _budget:Number;
		private var _iteration:int;
		
		private var _gameType:String = "plane";
		
		//used for the current game
		private var _vo:ReceivedDataVO;
		//private var _vo:GameVO;
		private var _stage:int; /* -1 intro, 
									0 entering first round, 1 showing first round, 
									2 entering 2nd round, 3, showing 2nd round,
									4, entering 3rd round, 5, showing 3rd round,
									6 Final score screen
									7 Exit Slide Screen */
		public var allVO:MainVO;
		private var _currentGameVO:ReceivedDataVO;

		public function get currentGameVO():ReceivedDataVO
		{
			return _currentGameVO;
		}

		public function set currentGameVO(value:ReceivedDataVO):void
		{
			_currentGameVO = value;
			//TODO create gameSet Signal if necessary 
		}

		public function get stage():int
		{
			return _stage;
		}

		public function updateBalance( n:Number ):void{
			
			var newBudget:Number = budget +n;
			budget = Math.round(newBudget*100)/100;

		}
		
		
		public function set stage(value:int):void
		{
			_stage = value;
			stageSet.dispatch(_stage); 
		}

		public function get vo():ReceivedDataVO
		{
			return _vo;
		}

		public function set vo(value:ReceivedDataVO):void
		{
			trace("user has selected game type vo set on model:"+value.name);
			_vo = value;
			//TODO check this!! not sure what it means or how it works with multiple games
			/*if (vo.initialData){
				
				changeState.dispatch(ChangeState.ENTER_SCREEN); //
				
			}*/
			//dispatch after so the mediator is instantiated
		
			userDataSet.dispatch(_vo);
			testSignal.dispatch(_vo);
			gameType = _vo.name;
				
		}

		public function get budget():Number
		{
			return _budget;
		}

		public function set budget(value:Number):void
		{
			_budget = value;
			balanceSet.dispatch(_budget);
		}

		public function get iteration():int
		{
			return _iteration;
		}

		public function set iteration(value:int):void
		{
			_iteration = value;
			trace("----- ITERATION SET TO:"+value);
			iterationChange.dispatch(_iteration);
		}

		public function get graphVO():GraphResultsVO
		{
			return _graphVO;
		}

		public function set graphVO(value:GraphResultsVO):void
		{
			
			_graphVO = value;
		
			changeState.dispatch(ChangeState.RESULTS_SCREEN);
			
			graphDataSet.dispatch(_graphVO);
			
			
		}

		public function get gameID():Number
		{
			return _gameID;
		}

		public function set gameID(value:Number):void
		{
			_gameID = value;
			gameIDSet.dispatch(_gameID);
			
		}

		public function get gameType():String
		{
			return _gameType;
		}

		public function set gameType(value:String):void
		{
			_gameType = value;
			gameTypeSet.dispatch(_gameType);
			//whenever the game type is set we will see the intro screen and load the leaderboard for that game
			leaderboardService.requestData(value);
			
		}


	}
}