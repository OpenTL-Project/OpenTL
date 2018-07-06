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
	public var tileSize:Float = 0;
	public var selector:Shape;
	public var selectorID:Int = 0;
	public var amountX:Int = 0;
	public var amountY:Int = 0;

	public function new() 
	{
		//intial size
		super(1, 1, null, true);
		tileSize = Static.editorTileSize;	
		//selector
		selector = new Shape();
		selector.cacheAsBitmap = true;
		//bacgkround
		//opaqueBackground = 0x0;
		
		var bd = new BitmapData(50, 50, false, 0x000000);
		//to do: write code to load tileset from a folder, currently hard coded renaine demo tileset (Thank you Squidly!)
		bd = Assets.getBitmapData("assets/img/renaine_tiles.png");
		
		amountX = Math.floor(bd.width / Static.tileSize);
		amountY = Math.floor(bd.height / Static.tileSize);
		
		//fill rectangle array into tileset
		var rectArray:Array<Rectangle> = [];
		for (j in 0...amountY) for (i in 0...amountX) rectArray.push(new Rectangle(i * Static.tileSize, j * Static.tileSize, Static.tileSize, Static.tileSize));
		tileset = new Tileset(bd, rectArray);
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
		//set size
		amountX = Static.cX;
		amountY = Static.cY;
		
		width = tileSize * amountX;
		height = tileSize * amountY;
		
		grid.graphics.clear();
		grid.width = 0;
		grid.height = 0;
		grid.x = x;
		grid.y = y;
		//remove previous tiles
		if (numTiles > 0) removeTiles(0, numTiles);
		//grid line style
		grid.graphics.lineStyle(2, 0xFFFFFF);
		//left and top line
		grid.graphics.moveTo(0, 0); grid.graphics.lineTo(0, height);
		grid.graphics.moveTo(0, 0); grid.graphics.lineTo(width, 0);
		//create tiles and grid
		//x
		var i:Int = 0;
		//y
		var j:Int = 0;
		while (j < amountY)
		{
			createGridRect(i * tileSize,j * tileSize);
			i ++;
			if (i >= amountX)
			{
				i = 0;
				j += 1;
			}
		}
		trace("num " + numTiles);
	}
	
	public function createGridRect(x:Float,y:Float)
	{
		//TODO: turn into Dashed line total 7 dashes per tile
		//create grid (bottom left -> bottom right -> top right)
		grid.graphics.moveTo(x, tileSize + y);
		grid.graphics.lineTo(x + tileSize, y + tileSize);
		grid.graphics.lineTo(x + tileSize, y);
	}
	
}