package;

import core.App;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

/**
 * ...
 * @author 
 */
class EditorTilemap extends Tilemap 
{

	public function new() 
	{
		//intial size
		super(512,512,null,true);
		
		var bd:BitmapData = new BitmapData(50, 50, false, 0x000000);
		//to do: write code to load tileset from a folder, currently hard coded renaine demo tileset (Thank you Squidly!)
		bd = Assets.getBitmapData("assets/img/renaine_tiles.png");
		
		
		//to do set tile size from user input or hscript.
		var tileSize:Int = 16;
		var amountX:Int = Math.floor(bd.width / tileSize);
		var amountY:Int = Math.floor(bd.height / tileSize);
		
		//fill rectangle array into tileset
		var rectArray:Array<Rectangle> = [];
		for (i in 0...amountX) for (j in 0...amountY) rectArray.push(new Rectangle(i * tileSize, j * tileSize, tileSize, tileSize));
		tileset = new Tileset(bd, rectArray);
		
		//grid line style
		EditorState.grid.graphics.lineStyle(1, 0xFFFFFF);
		//create tiles and grid
		for (i in 0...Static.cX) for (j in 0...Static.cY)
		{
			var tile = new EditorTile(0, i, j,tileset);
			addTile(tile);
			createGrid(i, j);
		}
	}
	
	public function createGrid(i:Int,j:Int)
	{
		//TODO: turn into Dashed line total 7 dashes per tile
		//create grid (bottom left -> bottom right -> top right)
		EditorState.grid.graphics.moveTo((i + 0) * EditorTile.size, (j + 1) * EditorTile.size);
		EditorState.grid.graphics.lineTo((i + 1) * EditorTile.size, (j + 1) * EditorTile.size);
		EditorState.grid.graphics.lineTo((i + 1) * EditorTile.size, (j + 0) * EditorTile.size);
	}
	
}