package;

import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.display.Tileset;

/**
 * ...
 * @author 
 */
class Palette extends Sprite
{
	public var bitmapData:BitmapData;
	public var tilemap:Tilemap;

	public function new(setBitmapData:BitmapData) 
	{
		super();
		bitmapData = setBitmapData;
		tilemap = new Tilemap(bitmapData.width, bitmapData.height, new Tileset(bitmapData));
		
		addChild(tilemap);
	}
	
}