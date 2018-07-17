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
	public var int:Int = 0;
	public var tileSize:Float = 0;

	public function new(id:Int=0, setInt:Int) 
	{
		tileSize = EditorState.tilemap.layer.editorTileSize;
		int = setInt;
		super(id, 0, 0, 1, 1);
		//set tileset and rect
		tileset = EditorState.tilemap.tileset;
		rect = tileset.getRect(id);
		//set properties to tile
		data = null;
		//set pos
		var row:Int = Math.floor(int / EditorState.tilemap.cX);
		ix = int - row * EditorState.tilemap.cX;
		iy = row;
		toGrid();
		toScale();
	}
	
	public function toGrid()
	{
		x = ix * (tileSize + 0);
		y = iy * (tileSize + 0);
	}
	
	public function toScale()
	{
		scaleX = 1 / rect.width * tileSize;
		scaleY = 1 / rect.height * tileSize;
	}
	
	
	
}