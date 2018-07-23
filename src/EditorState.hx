package;

import core.App;
import core.Button;
import core.State;
import core.Text;
import haxe.Json;
import haxe.Timer;
import openfl.Assets;
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
import openfl.text.TextField;
import core.InputText;

/**
 * ...
 * @author 
 */
class EditorState extends State 
{
	public static var stageContainer:DisplayObjectContainer;
	var stagePressed:Int = 0;
	var tilesPressed:Int = 0;
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
	var tilesBitmap:TilesBitmap;
	public static var tilesSelector:Shape;
	//inputs
	public var tileSizeInput:InputText;
	public var tileSize:Float = 0;
	public var tileSizeEditor:InputText;
	//map posistion tile
	public var mapTile:Map<Int,EditorTile> = new Map<Int,EditorTile>();
	
	//controls
	var cameraUp:Bool = false;
	var cameraDown:Bool = false;
	var cameraLeft:Bool = false;
	var cameraRight:Bool = false;
	
	var selectUp:Bool = false;
	var selectDown:Bool = false;
	var selectLeft:Bool = false;
	var selectRight:Bool = false;

	//mac specfic
	var commandKey:Bool = false;
	
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
		tiles = new Tab("TILES", true, false, false, 320);
		tiles.add.Click = addTileSheet;
		tiles.containerPressed = tileSelect;
		tiles.y = 80;
		tiles.x = 1120;
		tilesBitmap = new TilesBitmap();
		addChild(tiles);
		//input system
		var tileSizeInput = new InputText(8,300,"tileSize",20,300,0xFFFFFF,0xFFFFFF);
		tileSizeInput.textfield.restrict = "0-9";
		tileSizeInput.textInput = function()
		{
			tileSize = Std.parseFloat(cast(tileSizeInput.text,String));
			setTileSizeInput();
		}
		tileSizeInput.text = "32";
		tiles.container.addChild(tileSizeInput);
		tiles.container.addChild(tilesBitmap);
		tiles.container.addChild(tilesSelector);
		#if debug
		var fps = new FPS(10, 10, 0xFFFFFF);
		fps.scaleX = 2; fps.scaleY = 2;
		addChild(fps);
		#end
	}

	public function setTileSizeInput()
	{
		var size = tileSize;
		trace("tile size " + size);
		if(size > 0 && tilemap.layer != null)
		{
			trace("set tile size");
			tilemap.layer.tileSize = size;
			tilemap.layer.aX = Math.floor(tilesBitmap.width/size);
			tilemap.layer.aY = Math.floor(tilesBitmap.height/size);
		}
	}
	
	public function tileSelect()
	{
		//select
		tilesBitmap.selectorID = getSelectorID();
		trace("tile " + tilesBitmap.selectorID);
		selectMove(false);
		tilesPressed = 1;
	}
	public function addTileSheet(_)
	{
		DirectorySystem.finish = function(bmd)
		{
			tilesBitmap.bitmapData = bmd;
			tilemap.layer = new Layer();
			//sets ax ay and tilesize
			setTileSizeInput();
			//editor tile size
			tilemap.layer.editorTileSize = 32;
			tilesBitmap.amountX = tilemap.layer.aX;
			tilesBitmap.amountY = tilemap.layer.aY;
			tilesBitmap.change();
		};
		DirectorySystem.open();
	}
	//global 
	override public function mouseUp() 
	{
		super.mouseUp();
		stageUp();
		if (App.pointRect(mouseX, mouseY, layers.Rect())) layers.pressed();
		//if (App.pointRect(mouseY, mouseY, levels.Rect())) levels.pressed();
	}
	//stage 
	public function stageDown()
	{
		if(HandleButton.main == null)
		{
		if(commandKey)
		{
		stagePressed = 2;
		}else{
		stagePressed = 1;
		}
		}
	}
	public function tileDown(mX:Float,mY:Float)
	{
		if (mX < stageContainer.x + tilemap.x) return;
		if (mX > stageContainer.x + tilemap.grid.width - 8) return;
		if (mY < stageContainer.y + tilemap.y) return;
		if (mY > stageContainer.y + tilemap.grid.height - 8) return;
		var int = Math.floor((mX - stageContainer.x) / tilemap.layer.editorTileSize) + Math.floor((mY - stageContainer.y) / tilemap.layer.editorTileSize) * tilemap.cX;
		trace("int " + int + " select " + tilesBitmap.selectorID + " num " + tilemap.numTiles);
		var tile = mapTile.get(int);
		if (tile == null)
		{
			tile = new EditorTile(tilesBitmap.selectorID,int);
			tilemap.addTile(tile);
			mapTile.set(tile.int, tile);
			trace("x " + tile.x + " y " + tile.y + " num " + tilemap.numTiles);
		}
		switch(stagePressed)
		{
			case 0:
			//nothing
			case 1:
			//left mouse
			tilemap.removeTile(tile);
			tile.id = tilesBitmap.selectorID;
			tilemap.addTile(tile);
			case 2:
			//right mouse
			mapTile.remove(tile.int);
			tilemap.removeTile(tile);
			trace("remove");
		}
	}
	public function stageRightDown()
	{
		stagePressed = 2;
	}
	public function stageUp()
	{
		stagePressed = 0;
		tilesPressed = 0;
		if(tilemap.layer != null)HandleButton.resize();
	}

	public function overState():Bool
	{
		if(App.pointRect(mouseX,mouseY,new Rectangle(stageContainer.x + tilemap.x,stageContainer.y + tilemap.y,tilemap.width,tilemap.height)))return true;
		return false;
	}
	
	override public function mouseDown() 
	{
		super.mouseDown();
		if(overState())stageDown();
		if (App.pointRect(mouseX, mouseY, tiles.Rect())) tiles.pressed();
	}
	override public function mouseRightDown(e:MouseEvent) 
	{
		super.mouseRightDown(e);
		if(overState()) stageRightDown();
	}
	override public function mouseRightUp(e:MouseEvent) 
	{
		super.mouseRightUp(e);
		if(stagePressed == 2)stageUp();
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

	public function getSelectorID():Int
	{
		if(tilemap.layer == null)return 0;
		trace("selector layer " + tilemap.layer.tileSize);
		tilesBitmap.selectorX = Math.floor(tilesBitmap.mouseX/tilemap.layer.tileSize);
		tilesBitmap.selectorY = Math.floor(tilesBitmap.mouseY/tilemap.layer.tileSize);
		return tilesBitmap.selectorX + tilesBitmap.selectorY * tilesBitmap.amountX;
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

			//mac specfic
			case Keyboard.COMMAND: commandKey = bool;
			
		}
	}
	
	public function selectMove(keyMove:Bool=true)
	{
		if(tilemap.layer == null)return;
		trace("work");
		var tx:Float = 0;
		var ty:Float = 0;
		
		if(keyMove)
		{
		if (selectUp && tilesBitmap.selectorID > tilesBitmap.amountX) tilesBitmap.selectorID += -tilesBitmap.amountX;
		if (selectDown && tilesBitmap.selectorID < tilesBitmap.amountX * tilesBitmap.amountY - tilesBitmap.amountX) tilesBitmap.selectorID += tilesBitmap.amountX;
		if (selectLeft && tilesBitmap.selectorID > 0)
		{
			if (tilesBitmap.selectorID - Math.floor(tilesBitmap.selectorID / tilesBitmap.amountX) * tilesBitmap.amountX > 0) tilesBitmap.selectorID += -1;
		}
		if (selectRight && tilesBitmap.selectorID + 1 < tilesBitmap.amountX * tilesBitmap.amountY)
		{
			if (tilesBitmap.selectorID - Math.floor(tilesBitmap.selectorID / tilesBitmap.amountX) * tilesBitmap.amountX < tilesBitmap.amountX - 1) tilesBitmap.selectorID += 1;
		}
		}
		
		tilesSelector.x = tilesBitmap.x + (tilesBitmap.selectorID - Math.floor(tilesBitmap.selectorID / tilesBitmap.amountX) * tilesBitmap.amountX) * tilemap.layer.tileSize;
		tilesSelector.y = tilesBitmap.y + Math.floor(tilesBitmap.selectorID / tilesBitmap.amountX) * tilemap.layer.tileSize;
		//trace("selector " + tilesBitmap.selectorID);
	}
	
	override public function update() 
	{
		super.update();
		//drag
		if (stagePressed > 0 && tilemap.layer != null)
		{
		//this code helps with fast drawing of tiles onto the tilemap
		var mX:Float = mouseX;
		var mY:Float = mouseY;
		if(Math.abs(mouseX - oX) > tilemap.layer.editorTileSize)mX = oX + (mouseX - oX)/2;
		if(Math.abs(mouseY - oY) > tilemap.layer.editorTileSize)mY = oY + (mouseY - oY)/2;
		if(mX != mouseX || mY != mouseY)tileDown(mX,mY);
		tileDown(mouseX,mouseY);
		}
		if(tilesPressed > 0)
		{
			//resize tile selector
			
		}
		//update tile resizing of stage
		if (HandleButton.main !=  null && tilemap.layer != null) HandleButton.update();
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
	
	override public function resize() 
	{
		super.resize();
		setHeader(topBar);
		setHeader(topText, false); topText.x += 16;
		setHeader(layers, false); layers.x += 2;
	}
	
	
}