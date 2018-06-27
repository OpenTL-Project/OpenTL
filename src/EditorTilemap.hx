package;

import core.App;
import haxe.Timer;
import openfl.Assets;
import openfl.display.BitmapData;
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

	public function new() 
	{
		//intial size
		super(512,512,null,true);
		
		var bd:BitmapData = new BitmapData(50, 50, false, 0x000000);
		//to do: write code to load tileset from a folder, currently hard coded renaine demo tileset (Thank you Squidly!)
		bd = Assets.getBitmapData("assets/img/renaine_tiles.png");
		
		var tileSize:Int = 16;
		var amountX:Int = Math.floor(bd.width / tileSize);
		var amountY:Int = Math.floor(bd.height / tileSize);
		
		//fill rectangle array into tileset
		var rectArray:Array<Rectangle> = [];
		for (i in 0...amountX) for (j in 0...amountY) rectArray.push(new Rectangle(i * tileSize, j * tileSize, tileSize, tileSize));
		tileset = new Tileset(bd, rectArray);
		grid = new Shape();
		grid.cacheAsBitmap = true;
		EditorState.stageContainer.addChild(grid);
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
		grid.graphics.clear();
		grid.width = 0;
		grid.height = 0;
		//remove previous tiles
		if(numTiles > 0)removeTiles(0, numTiles);
		//grid line style
		grid.graphics.lineStyle(2, 0xFFFFFF);
		//left and top line
		grid.graphics.moveTo(0, 0); grid.graphics.lineTo(0, height - 12);
		grid.graphics.moveTo(0, 0); grid.graphics.lineTo(width - 12, 0);
		//create tiles and grid
		for (i in 0...Static.cX) for (j in 0...Static.cY)
		{
			var tile = new EditorTile(1, i, j,tileset);
			addTile(tile);
			createGrid(i, j);
		}
		
	}
	
	public function createGrid(i:Int,j:Int)
	{
		//TODO: turn into Dashed line total 7 dashes per tile
		//create grid (bottom left -> bottom right -> top right)
		grid.graphics.moveTo((i + 0) * Static.editorTileSize, (j + 1) * Static.editorTileSize);
		grid.graphics.lineTo((i + 1) * Static.editorTileSize, (j + 1) * Static.editorTileSize);
		grid.graphics.lineTo((i + 1) * Static.editorTileSize, (j + 0) * Static.editorTileSize);
	}
	
}