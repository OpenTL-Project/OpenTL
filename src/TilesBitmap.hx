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
	public var selectorX:Int = 0;
	public var selectorY:Int = 0;
	public var amountX:Int = 10;
	public var amountY:Int = 10;
	public var layer:Layer;

	public function new() 
	{
		super(null, null, true);
		editor = EditorState.tilemap;
		layer = editor.layer;
		if(layer != null)bitmapData = layer.bitmapData;
		width = 290;
		height = 290;
		x = 13;
		y = 135;
		
		EditorState.tilesSelector = new Shape();
		change();
	}
	
	public function change(clear:Bool=true,xpos:Float=0,ypos:Float=0)
	{
		var tileSize:Float = 16;
		if(editor.layer != null)tileSize = editor.layer.tileSize;
		if(clear)
		{
		selectorID = 0;
		EditorState.tilesSelector.x = x; EditorState.tilesSelector.y = y;
		EditorState.tilesSelector.graphics.clear();
		}
		EditorState.tilesSelector.graphics.lineStyle(2, 0xFFFFFF, 0.8);
		EditorState.tilesSelector.graphics.drawRect(xpos, ypos, tileSize, tileSize);
	}
	
}