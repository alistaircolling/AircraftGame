package view.mediators
{
	import model.vo.CopyVO;
	import model.vo.LeaderBoardVO;
	
	import org.robotlegs.mvcs.Mediator;
	
	import signals.CopySet;
	import signals.LeaderBoardSet;
	
	import view.components.LeaderBoard;
	
	public class LeaderBoardMediator extends Mediator
	{
		[Inject]
		public var view:LeaderBoard;
		[Inject]
		public var lbSet:LeaderBoardSet;
		[Inject]
		public var copySet:CopySet;
		
	
		override public function onRegister():void{
			
			lbSet.add(dataSet);
			copySet.add(onCopySet);
			
		}
		
		private function onCopySet(vo:CopyVO):void
		{
			view.
			
		}
		
		override public function onRemove():void{
			
			lbSet.remove(dataSet);
			copySet.remove(onCopySet);
			
		}
		
		private function dataSet( vo:LeaderBoardVO ):void{
			
			view.dp  = vo.winners;
			
		}
	}
}