package;
import openfl.display.Tileset;

/**
 * ...
 * @author 
 */
class Static 
{
	//holds all properties and variables that are acsessed across classes
	@:isVar public static var tileSize(get, set):Int = 16;
	//dynamically adjusted to scale to tilemap
	public static var editorTileSize:Float;
	@:isVar public static var tilemapWidth(get,set):Int = 500;
	@:isVar public static var tilemapHeight(get, set):Int = 500;
	//tilemap x and y count of tiles
	@:isVar public static var cX(get,set):Int = 8;
	@:isVar public static var cY(get,set):Int = 8;
	
	public static var tilesetArray:Array<Tileset> = new Array<Tileset>();
	
	//getters and setters
	private static function get_tileSize():Int
	{
		return tileSize;
	}
	private static function set_tileSize(set:Int):Int
	{
		return tileSize = set;
	}
	
	private static function get_tilemapWidth():Int
	{
		return tilemapWidth;
	}
	private static function set_tilemapWidth(set:Int):Int
	{
		//setEditorTileSize();
		return tilemapWidth = set;
	}
	
	private static function get_tilemapHeight():Int
	{
		return tilemapHeight;
	}
	private static function set_tilemapHeight(set:Int)
	{
		//setEditorTileSize();
		return tilemapHeight = set;
	}
	
	private static function get_cX():Int
	{
		return cX;
	}
	private static function set_cX(set:Int):Int
	{
		return cX = set;
	}
	
	private static function get_cY():Int
	{
		return cY;
	}
	private static function set_cY(set:Int):Int
	{
		return cY = set;
	}
	
	
	public static function setEditorTileSize(inital:Bool=false)
	{
		//when properties change tilemap updates
		editorTileSize = Math.min(tilemapWidth, tilemapHeight) / Math.min(cX, cY);
		if(inital == false)EditorState.tilemap.generate();
	}
	
	/*
	private static function get_():Int
	{
		
	}
	private static function set_(set:Int):Int
	{
		
	}
	*/
}