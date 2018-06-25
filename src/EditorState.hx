package;

import core.App;
import core.Button;
import core.State;
import core.Text;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.display.FPS;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 
 */
class EditorState extends State 
{
	var stageContainer:DisplayObjectContainer;
	var tilemap:EditorTilemap;
	var mapData:Map<{x:Int,y:Int},EditorTile> = new Map<{x:Int,y:Int},EditorTile>();
	var palette:Sprite;
	
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
	
	public static var grid:Shape;
	//controls
	var cameraUp:Bool = false;
	var cameraDown:Bool = false;
	var cameraLeft:Bool = false;
	var cameraRight:Bool = false;
	var cameraSpeed:Int = 5;
	var leftPressed:Bool = false;
	var rightPressed:Bool = false;
	var mouseMiddleDown:Bool = false;
	//old mouseX and mouseY
	var oX:Float;
	var oY:Float;
	

	public function new()
	{
		background = new Bitmap(new BitmapData(1, 1, false, 0x757788));
		super();
		//update static initally
		Static.update(true);
		
		stageContainer = new DisplayObjectContainer();
		addChild(stageContainer);
		grid = new Shape();
		grid.cacheAsBitmap = true;
		tilemap = new EditorTilemap();
		stageContainer.addChild(tilemap);
		stageContainer.addChild(grid);
		
		palette = new Palette(tilemap.tileset.bitmapData);
		addChild(palette);
		
		addChild(new FPS(10, 10, 0xFFFFFF));
		
		//center intally
		centerStage();
		
		//ui
		topBar = App.createRect(0, 0, App.setWidth, 32, 0x5B5D6B);
		addChild(topBar);
		topText = App.createText("FILE        PROJECT        EXPORT", 0, 8 - 4, 14, 0xDFE0EA);
		addChild(topText);
		//TODO: file project and export invisButtons using App.createInvisButton()
		
		var layers = new Tab("LAYERS");
		layers.y = 100;
		addChild(layers);
		
	}
	
	//global 
	override public function mouseUp() 
	{
		super.mouseUp();
	}
	override public function mouseDown() 
	{
		super.mouseDown();
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
	}
	
	public function setKeyboard(keyCode:Int, bool:Bool)
	{
		switch(keyCode)
		{
			case Keyboard.UP | Keyboard.W: cameraUp = bool;
			case Keyboard.DOWN | Keyboard.S: cameraDown = bool;
			case Keyboard.LEFT | Keyboard.A: cameraLeft = bool;
			case Keyboard.RIGHT | Keyboard.D: cameraRight = bool;
		}
	}
	
	override public function update() 
	{
		super.update();
		//trace("keyUP " + cameraUp);
		cameraMove();
		//drag stage
		if (mouseMiddleDown)
		{
			moveStage(mouseX - oX, mouseY - oY);
		}
		//set old
		oX = mouseX; oY = mouseY;
	}
	
	public function centerStage()
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
		tilemap.x += x;
		tilemap.y += y;
		grid.x += x;
		grid.y += y;
	}
	public function setStage(x:Float, y:Float)
	{
		tilemap.x = x;
		tilemap.y = y;
		grid.x = x;
		grid.y = y;
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
		trace("scale " + stageContainer.scaleX);
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
	}
	
	
}