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
	public var mainBool:Bool = false;
	public var tileSize:Float = 0;
	public var selector:Shape;
	public var selectorID:Int = 0;
	public var amountX:Int = 0;
	public var amountY:Int = 0;

	public function new(setMainBool:Bool=true) 
	{
		//intial size
		super(1, 1, null, true);
		mainBool = setMainBool;
		if (mainBool)
		{
		tileSize = Static.editorTileSize;	
		}else{
		tileSize = Static.tilesTileSize;
		//selector
		selector = new Shape();
		selector.cacheAsBitmap = true;
		}
		//bacgkround
		//opaqueBackground = 0x0;
		
		var bd:BitmapData = new BitmapData(50, 50, false, 0x000000);
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
		if (mainBool)
		{
		var tim = new Timer(16 * 10);
		tim.run = function()
		{
		for (i in 0...4) handleArray.push(new HandleButton(0, 0, i));
		tim.stop();
		tim = null;
		}
		}
	}
	
	public function generate()
	{
		//set size
		if (mainBool)
		{
			amountX = Static.cX;
			amountY = Static.cY;
		}else{
			//selector
			selector.graphics.clear();
			selector.graphics.lineStyle(4, 0xFFFFFF);
			selector.graphics.drawRect(0, 0, tileSize, tileSize);
		}
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
		var multiTiles:Bool = !mainBool;
		while (j < amountY)
		{
			//id system for tiles tilemap
			var id = 0;
			if (multiTiles)
			{
				id = i + j * amountX;
				if (id >= tileset.numRects)
				{
					multiTiles = false;
					id = 0;
				}
			}
			
			var tile = new EditorTile(id, i, j, tileset, tileSize);
			if (!multiTiles) tile.alpha = 0;
			addTile(tile);
			createGrid(tile);
			
			i ++;
			if (i >= amountX)
			{
				i = 0;
				j += 1;
			}
		}
		trace("num " + numTiles);
	}
	
	public function createGrid(tile:EditorTile)
	{
		//TODO: turn into Dashed line total 7 dashes per tile
		//create grid (bottom left -> bottom right -> top right)
		grid.graphics.moveTo(tile.x, tile.tileSize + tile.y);
		grid.graphics.lineTo(tile.x + tile.tileSize, tile.y + tile.tileSize);
		grid.graphics.lineTo(tile.x + tile.tileSize, tile.y);
	}
	
}