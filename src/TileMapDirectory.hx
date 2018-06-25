package;
import lime.ui.FileDialog;
import lime.utils.Resource;

/**
 * ...
 * @author 
 */
class TileMapDirectory 
{
	//public static var directory:Array<String> = [];
	
	public static function open()
	{
		var fileDialog = new FileDialog();
		fileDialog.onOpen.add(function(e:Resource)
		{
			trace("open");
			//to do: extract data and save tilemap locally.
		});
		fileDialog.onCancel.add(function()
		{
			
		});
		
		fileDialog.open("png", null, "Open TileMap");
	}
	
}