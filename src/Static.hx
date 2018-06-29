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
	public static var editorTileSize:Float = 64;
	public static var tilesTileSize:Float = 32;
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
	
	/*
	private static function get_():Int
	{
		
	}
	private static function set_(set:Int):Int
	{
		
	}
	*/
}