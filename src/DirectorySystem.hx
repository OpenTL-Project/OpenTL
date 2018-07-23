package;
import lime.ui.FileDialog;
import lime.utils.Resource;
import openfl.display.BitmapData;
import lime.system.System;

/**
 * ...
 * @author 
 */
class DirectorySystem
{
	//public static var directory:Array<String> = [];
	public static var finish:BitmapData->Void;
	
	public static function open()
	{
		trace("try");
		var fileDialog = new FileDialog();
		var dir:Array<String> = [];
		fileDialog.onCancel.add(function()
		{
		trace("fail");
		});
		fileDialog.onSelect.add(function(e:String)
		{
		BitmapData.loadFromFile(e).onComplete(function(bmd:BitmapData)
		{
		if(finish != null)finish(bmd);
		});
		});
		fileDialog.browse(lime.ui.FileDialogType.OPEN,null,null,"Open TileSheet");
	}
	
}