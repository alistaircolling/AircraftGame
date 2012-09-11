package signals
{
	import model.vo.CopyVO;
	
	import org.osflash.signals.Signal;
	
	public class CopySet extends Signal
	{
		public function CopySet()
		{
			super(CopyVO);
		}
	}
}