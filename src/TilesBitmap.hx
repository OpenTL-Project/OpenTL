package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.display.Shape;

/**
 * ...
 * @author 
 */
class TilesBitmap extends Bitmap 
{
	var editor:EditorTilemap;
	public var selectorID:Int = 0;
	public var tileSize:Float = 16;
	public var amountX:Int = 10;
	public var amountY:Int = 10;
	public var layer:Layer;

	public function new() 
	{
		super(null, null, true);
		editor = EditorState.tilemap;
		layer = editor.layer;
		bitmapData = layer.bitmapData;
		width = 290;
		height = 290;
		x = 13;
		y = 135;
		
		EditorState.tilesSelector = new Shape();
		change();
	}
	
	public function change()
	{
		selectorID = 0;
		EditorState.tilesSelector.x = x; EditorState.tilesSelector.y = y;
		EditorState.tilesSelector.graphics.clear();
		EditorState.tilesSelector.graphics.lineStyle(2, 0xFFFFFF, 0.8);
		EditorState.tilesSelector.graphics.drawRect(0, 0, tileSize, tileSize);
	}
	
	public function pressed()
	{
		
	}
	
}