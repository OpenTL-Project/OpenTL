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
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 
 */
class EditorState extends State 
{
	public static var stageContainer:Button;
	public static var tilemap:EditorTilemap;
	var palette:Sprite;
	
	//buttons
	var fileButton:Button;
	var projectButton:Button;
	var exportButton:Button;
	var handleArray:Array<HandleButton> = [];
	
	//ui
	var topBar:Shape;
	var topText:Text;
	//tabs
	var layers:Tab;
	var levels:Tab;
	var tiles:Tab;
	
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
		
		stageContainer = new Button();
		stageContainer.Down = stageDown;
		stageContainer.Up = stageUp;
		stageContainer.Click = stageClick;
		addChild(stageContainer);
		tilemap = new EditorTilemap();
		stageContainer.addChild(tilemap);
		stageContainer.addChild(tilemap.grid);
		//add handles
		for (i in 0...4) handleArray.push(new HandleButton(0, 0, i));
		
		//palette
		palette = new Palette(tilemap.tileset.bitmapData);
		addChild(palette);
		//center intally
		centerStage();
		//ui
		topBar = App.createRect(0, 0, App.setWidth, 32, 0x5B5D6B);
		addChild(topBar);
		topText = App.createText("FILE        PROJECT        EXPORT", 0, 8 - 4, 14, 0xDFE0EA);
		addChild(topText);
		//TODO: file project and export invisButtons using App.createInvisButton()
		layers = new Tab("LAYERS");
		layers.y = 100;
		addChild(layers);
		#if debug
		var fps = new FPS(10, 10, 0xFFFFFF);
		fps.scaleX = 2; fps.scaleY = 2;
		addChild(fps);
		#end
		
	}
	
	//global 
	override public function mouseUp() 
	{
		super.mouseUp();
		if (App.pointRect(mouseX, mouseY, layers.Rect())) layers.pressed();
		//if (App.pointRect(mouseY, mouseY, levels.Rect())) levels.pressed();
		//if (App.pointRect(mouseX, mouseY, tiles.Rect())) tiles.pressed();
	}
	//stage 
	public function stageDown(e:MouseEvent)
	{
		if (e.localX < tilemap.x || e.localX > tilemap.x + tilemap.width || e.localY < tilemap.y || e.localY > tilemap.y + tilemap.height)
		{
		//handler pressed
		for (i in 0...4) if (App.pointRect(e.localX, e.localY, handleArray[i].Rect()))
		{
			trace("pressed");
		}
		}else{
		//tile id
		var id:Int = Math.floor(e.localX / Static.editorTileSize) + Math.floor(e.localY / Static.editorTileSize) * Static.cX;
		tilemap.getTileAt(id).alpha = 0.2;
		trace("id " + id);
		}
	}
	public function stageUp(e:MouseEvent)
	{
		
	}
	public function stageClick(e:MouseEvent)
	{
		
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