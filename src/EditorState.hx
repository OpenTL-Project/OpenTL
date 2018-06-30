package;

import core.App;
import core.Button;
import core.State;
import core.Text;
import haxe.Json;
import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.display.FPS;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.SharedObject;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 
 */
class EditorState extends State 
{
	public static var stageContainer:DisplayObjectContainer;
	var stagePressed:Int = 0;
	public static var tilemap:EditorTilemap;
	
	//buttons
	var fileButton:Button;
	var projectButton:Button;
	var exportButton:Button;
	
	//ui
	var topBar:Shape;
	var topText:Text;
	//tabs
	var layers:Tab;
	var levels:Tab;
	var tiles:Tab;
	var tilesTilemap:EditorTilemap;
	
	//controls
	var cameraUp:Bool = false;
	var cameraDown:Bool = false;
	var cameraLeft:Bool = false;
	var cameraRight:Bool = false;
	
	var selectUp:Bool = false;
	var selectDown:Bool = false;
	var selectLeft:Bool = false;
	var selectRight:Bool = false;
	
	var cameraSpeed:Int = 5;
	var leftPressed:Bool = false;
	var rightPressed:Bool = false;
	var mouseMiddleDown:Bool = false;
	//old mouseX and mouseY
	public static var oX:Float = 0;
	public static var oY:Float = 0;
	
	public var save:SharedObject;
	public var saveTimer:Timer;
	

	public function new()
	{
		background = new Bitmap(new BitmapData(1, 1, false, 0x757788));
		super();
		save = SharedObject.getLocal("save");
		saveTimer = new Timer(1000 * 3);
		saveTimer.run = function()
		{
			//save.data.tilemap = saveTilemap();
			trace("auto save");
		}
		
		stageContainer = new DisplayObjectContainer();
		
		addChild(stageContainer);
		tilemap = new EditorTilemap();
		stageContainer.addChild(tilemap);
		stageContainer.addChild(tilemap.grid);
		//center intally
		centerStage();
		//ui
		topBar = App.createRect(0, 0, App.setWidth, 32, 0x5B5D6B);
		addChild(topBar);
		topText = App.createText("FILE        PROJECT        EXPORT", 0, 8 - 4, 14, 0xDFE0EA);
		addChild(topText);
		//TODO: file project and export invisButtons using App.createInvisButton()
		layers = new Tab("LAYERS");
		layers.y = 32 + 3;
		addChild(layers);
		tiles = new Tab("TILES", true, false, false, false, 320);
		tiles.y = 80;
		tiles.x = 1120;
		
		tilesTilemap = new EditorTilemap(false);
		tiles.container.y = 135;
		tiles.container.x = 13;
		tiles.container.addChild(tilesTilemap);
		tiles.container.addChild(tilesTilemap.grid);
		tiles.container.addChild(tilesTilemap.selector);
		tiles.addChild(tiles.container.mask = App.createRect(0, 0, 290, 290, 0));
		tiles.container.mask.x = tiles.container.x;
		tiles.container.mask.y = tiles.container.y;
		tiles.containerPressed = function()
		{
			//TODO: get tile id from mouse press
			
		}
		addChild(tiles);
		#if debug
		var fps = new FPS(10, 10, 0xFFFFFF);
		fps.scaleX = 2; fps.scaleY = 2;
		addChild(fps);
		#end
		//load
		//loadTilemap(save.data.tilemap);
	}
	
	public function saveTilemap():String
	{
		var array1D:Array<Int> = [];
		for (i in 0...tilemap.numTiles)
		{
			var tile = tilemap.getTileAt(i);
			if (tile.alpha > 0 && tile.id > 0)
			{
			array1D.push(tile.id);
			}else{
			array1D.push(-1);
			}
		}
		/*var array2D:Array<Array<Int>> = [];
		for (j in 0...tilemap.amountY)
		{
			for (i in 0...tilemap.amountX)
			{
				var tile = tilemap.getTileAt(j * tilemap.amountX + i);
				if (tile.alpha > 0 && tile.id > 0)
				{
				array2D[j][i] = tile.id;
				}else{
				array2D[j][i] = -1;
				}
			}
		}*/
		return Json.stringify({data:array1D,cX:Static.cX,cY:Static.cY,tileSize:tilemap.tileSize});
	}
	public function loadTilemap(string:String)
	{
		if (string == "") return;
		
		var data = Json.parse(string);
		var array:Array<Int> = data.data;
		if(data.cX > 0)Static.cX = data.cX;
		if (data.cY > 0) Static.cY = data.cY;
		if (data.tileSize > 0) tilemap.tileSize = data.tileSize;
		tilemap.generate();
		for (i in 0...array.length)
		{
			var tile = tilemap.getTileAt(i);
			if (tile != null)
			{
			if (array[i] == -1)
			{
			tile.alpha = 0;	
			}else{
			tile.alpha = 1;
			tile.id = array[i];
			}
			}
		}
	}
	
	//global 
	override public function mouseUp() 
	{
		super.mouseUp();
		stageUp();
		if (App.pointRect(mouseX, mouseY, layers.Rect())) layers.pressed();
		//if (App.pointRect(mouseY, mouseY, levels.Rect())) levels.pressed();
		if (App.pointRect(mouseX, mouseY, tiles.Rect())) tiles.pressed();
	}
	public function getTileId(mX:Float, mY:Float,tilemap:EditorTilemap):Tile
	{
		if (mX < 0 || mX > tilemap.width - 20) return null;
		return tilemap.getTileAt(Math.floor(mX / tilemap.tileSize) + Math.floor(mY / tilemap.tileSize) * Static.cX);
	}
	//stage 
	public function stageDown()
	{
		if(HandleButton.main == null)stagePressed = 1;
	}
	public function tileDown()
	{
		var tile = getTileId(stageContainer.mouseX, stageContainer.mouseY,tilemap);
		if (tile == null) return;
		
		switch(stagePressed)
		{
			case 0:
			//nothing
			case 1:
			//left mouse
			tile.id = tilesTilemap.selectorID;
			tile.alpha = 1;
			case 2:
			//right mouse
			tile.id = 0;
			tile.alpha = 0;
		}
	}
	public function stageRightDown()
	{
		stagePressed = 2;
	}
	public function stageUp()
	{
		stagePressed = 0;
		HandleButton.resize();
	}
	
	override public function mouseDown() 
	{
		super.mouseDown();
		if(App.pointRect(mouseX,mouseY,new Rectangle(stageContainer.x,stageContainer.y,stageContainer.width,stageContainer.height)))stageDown();
	}
	override public function mouseRightDown(e:MouseEvent) 
	{
		super.mouseRightDown(e);
		if (App.pointRect(mouseX, mouseY, new Rectangle(stageContainer.x, stageContainer.y, stageContainer.width, stageContainer.height))) stageRightDown();
	}
	override public function mouseRightUp(e:MouseEvent) 
	{
		super.mouseRightUp(e);
		stageUp();
	}
	override public function keyUp(e:KeyboardEvent) 
	{
		super.keyUp(e);
		setKeyboard(e.keyCode, false);
	}
	override public function keyDown(e:KeyboardEvent) 
	{
		super.keyDown(e);
		setKeyboard(e.keyCode, true);
		selectMove();
		switch(e.keyCode)
		{
			case Keyboard.V:
			var bool = !tilemap.grid.visible;
			tilemap.grid.visible = bool;
			for (handler in tilemap.handleArray) handler.visible = bool;
		}
	}
	
	public function setKeyboard(keyCode:Int, bool:Bool)
	{
		switch(keyCode)
		{
			case Keyboard.UP: cameraUp = bool;
			case Keyboard.DOWN: cameraDown = bool;
			case Keyboard.LEFT: cameraLeft = bool;
			case Keyboard.RIGHT: cameraRight = bool;
			
			case Keyboard.W: selectUp = bool;
			case Keyboard.S: selectDown = bool;
			case Keyboard.A: selectLeft = bool;
			case Keyboard.D: selectRight = bool;
			
		}
	}
	
	public function selectMove()
	{
		var tx:Float = 0;
		var ty:Float = 0;
		
		if (selectUp && tilesTilemap.selectorID > tilesTilemap.amountX) tilesTilemap.selectorID += -tilesTilemap.amountX;
		if (selectDown && tilesTilemap.selectorID < tilesTilemap.amountX * tilesTilemap.amountY - tilesTilemap.amountX) tilesTilemap.selectorID += tilesTilemap.amountX;
		if (selectLeft && tilesTilemap.selectorID > 0)
		{
			if (tilesTilemap.selectorID - Math.floor(tilesTilemap.selectorID / tilesTilemap.amountX) * tilesTilemap.amountX > 0) tilesTilemap.selectorID += -1;
		}
		if (selectRight && tilesTilemap.selectorID + 1 < tilesTilemap.amountX * tilesTilemap.amountY)
		{
			if (tilesTilemap.selectorID - Math.floor(tilesTilemap.selectorID / tilesTilemap.amountX) * tilesTilemap.amountX < tilesTilemap.amountX - 1) tilesTilemap.selectorID += 1;
		}
		
		tilesTilemap.selector.x = (tilesTilemap.selectorID - Math.floor(tilesTilemap.selectorID / tilesTilemap.amountX) * tilesTilemap.amountX) * tilesTilemap.tileSize;
		tilesTilemap.selector.y = Math.floor(tilesTilemap.selectorID / tilesTilemap.amountX) * tilesTilemap.tileSize;
	}
	
	override public function update() 
	{
		super.update();
		//drag
		if (stagePressed > 0) tileDown();
		//update tile resizing of stage
		if (HandleButton.main !=  null) HandleButton.update();
		//trace("keyUP " + cameraUp);
		cameraMove();
		//drag stage
		if (mouseMiddleDown)moveStage(mouseX - oX, mouseY - oY);
		//set old
		oX = mouseX; oY = mouseY;
	}
	
	public static function centerStage()
	{
		stageContainer.x = (App.setWidth - stageContainer.width) / 2;
		stageContainer.y = (App.setHeight - stageContainer.height) / 2;
	}
	
	public function cameraMove()
	{
		if (cameraUp) stageContainer.y += cameraSpeed;
		if (cameraDown) stageContainer.y += -cameraSpeed;
		if (cameraLeft) stageContainer.x += cameraSpeed;
		if (cameraRight) stageContainer.x += -cameraSpeed;
	}
	
	public function moveStage(x:Float, y:Float)
	{
		stageContainer.x += x;
		stageContainer.y += y;
	}
	public function setStage(x:Float, y:Float)
	{
		stageContainer.x = x;
		stageContainer.y = y;
	}
	
	override public function mouseWheel(e:openfl.events.MouseEvent) 
	{
		super.mouseWheel(e);
		var scale = e.delta * 0.05;
		if (stageContainer.scaleX + scale > 0 && stageContainer.scaleX + scale < 2.5)
		{
		stageContainer.scaleX += scale;
		stageContainer.scaleY += scale;
		}
	}
	override public function mouseWheelDown(e:MouseEvent) 
	{
		super.mouseWheelDown(e);
		mouseMiddleDown = true;
	}
	override public function mouseWheelUp(e:MouseEvent) 
	{
		super.mouseWheelUp(e);
		mouseMiddleDown = false;
	}
	
	override public function resize(prx:Int, pry:Int, ssx:Float, ssy:Float) 
	{
		super.resize(prx, pry, ssx, ssy);
		App.setHeader(topBar);
		App.setHeader(topText, false); topText.x += 16;
		App.setHeader(layers, false); layers.x += 2;
	}
	
	
}