package;

import core.App;
import haxe.Timer;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import openfl.display.Shape;

/**
 * ...
 * @author 
 */
class EditorTilemap extends Tilemap 
{
	public var grid:Shape;
	public var handleArray:Array<HandleButton> = [];
	public var selector:Shape;
	public var selectorID:Int = 0;
	public var layer:Layer;
	//size of tilemap
	public var cX:Int = 10;
	public var cY:Int = 10;

	public function new() 
	{
		//intial size
		super(1, 1, null, true);
		//set inital layer
		layer = Static.layers[0];
		//selector
		selector = new Shape();
		selector.cacheAsBitmap = true;
		//bacgkround
		//opaqueBackground = 0x0;
		//fill rectangle array into tileset
		var rectArray:Array<Rectangle> = [];
		for (j in 0...cY) for (i in 0...cX) rectArray.push(new Rectangle(i * layer.tileSize, j * layer.tileSize, layer.tileSize, layer.tileSize));
		tileset = new Tileset(layer.bitmapData, rectArray);
		grid = new Shape();
		grid.cacheAsBitmap = true;
		generate();
		//add handles after 10 frames
		var tim = new Timer(16 * 10);
		tim.run = function()
		{
		for (i in 0...4) handleArray.push(new HandleButton(0, 0, i));
		tim.stop();
		tim = null;
		}
	}
	
	public function generate()
	{
		
		width = layer.tileSize * cX;
		height = layer.tileSize * cY;
		
		grid.graphics.clear();
		grid.width = 0;
		grid.height = 0;
		grid.x = x;
		grid.y = y;
		//remove previous tiles
		if (numTiles > 0) removeTiles(0, numTiles);
		//grid line style
		grid.graphics.lineStyle(2, 0xFFFFFF);
		//grid
		//x
		var i:Int = 0;
		//y
		var j:Int = 0;
		while (j < cY)
		{
			createGridRect(i,j);
			i ++;
			if (i >= cX)
			{
				i = 0;
				j += 1;
			}
		}
		trace("num " + numTiles);
		
		//left and top line
		grid.graphics.moveTo(0, 0); grid.graphics.lineTo(0, grid.height);
		grid.graphics.moveTo(0, 0); grid.graphics.lineTo(grid.width, 0);
	}
	
	public function createGridRect(x:Float,y:Float)
	{
		x *= layer.editorTileSize;
		y *= layer.editorTileSize;
		//TODO: turn into Dashed line total 7 dashes per tile
		//create grid (bottom left -> bottom right -> top right)
		grid.graphics.moveTo(x, layer.editorTileSize + y);
		grid.graphics.lineTo(x + layer.editorTileSize, y + layer.editorTileSize);
		grid.graphics.lineTo(x + layer.editorTileSize, y);
	}
	
}