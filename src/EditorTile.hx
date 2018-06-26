package;

import openfl.display.Tile;
import openfl.display.Tileset;

/**
 * ...
 * @author 
 */
class EditorTile extends openfl.display.Tile 
{
	public var ix:Int = 0;
	public var iy:Int = 0;

	public function new(id:Int=0, x:Int=0, y:Int=0,setTileset:Tileset) 
	{
		ix = x;
		iy = y;
		super(id, 0, 0, 1, 1);
		//set tileset and rect
		tileset = setTileset;
		rect = tileset.getRect(id);
		//set properties to tile
		data = null;
		toGrid();
		toScale();
	}
	
	public function toGrid()
	{
		x = iy * (Static.editorTileSize + 0);
		y = ix * (Static.editorTileSize + 0);
	}
	
	public function toScale()
	{
		scaleX = 1 / rect.width * Static.editorTileSize;
		scaleY = 1 / rect.height * Static.editorTileSize;
	}
	
	
	
}