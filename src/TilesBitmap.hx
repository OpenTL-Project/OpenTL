package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

/**
 * ...
 * @author 
 */
class TilesBitmap extends Bitmap 
{
	var editor:EditorTilemap;
	public var selectorID:Int = 0;
	public var tileSize:Int = 0;
	public var amountX:Int = 0;
	public var amountY:Int = 0;

	public function new() 
	{
		super(null, null, true);
		editor = EditorState.tilemap;
		
	}
	
	public function pressed()
	{
		
	}
	
}