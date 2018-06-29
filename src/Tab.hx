package;

import core.App;
import core.Button;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author 
 */
class Tab extends DisplayObjectContainer
{
	@:isVar public var expandBool(get, set):Bool = true;
	function get_expandBool():Bool
	{
		return expandBool;
	}
	function set_expandBool(set:Bool):Bool
	{
		expandBool = set;
		if (expandBool)
		{
		expand();
		}else{
		collaspe();	
		}
		return expandBool;
	}
	public var shape:Shape;
	public var container:DisplayObjectContainer;
	//buttons
	public var dropdown:Shape;
	public var add:Shape;
	public var trash:Shape;
	
	public var shapeWidth:Int = 0;
	
	

	public function new(title:String,expanded:Bool=true,scrollable:Bool=true,toggleView:Bool=false,addButtonBool:Bool=true,setShapeWidth:Int=256) 
	{
		super();
		shapeWidth = setShapeWidth;
		//main shape
		shape = new Shape();
		addChild(shape);
		addChild(App.createText(title, 32, 4, 14, 0xDFE0EA, TextFormatAlign.LEFT, 126 + 76 - 20));
		dropdown = new Shape();
		dropdown.x = 12; dropdown.y = 12;
		addChild(dropdown);
		
		if (addButtonBool)
		{
		add = App.createSprite(232 - 4, 8 - 6, "assets/icons/add.svg");
		addChild(add);
		}
		
		//set
		expandBool = expanded;
		
		//create container to add tilemap/scroll view in 
		addChild(container = new DisplayObjectContainer());
	}
	
	//dropdown functions
	public function dropdown0()
	{
		dropdown.graphics.clear();
		dropdown.graphics.beginFill(0xDFE0EA);
		dropdown.graphics.moveTo(0, 0);
		dropdown.graphics.lineTo(8 / 2, 8);
		dropdown.graphics.lineTo(8, 0);
		dropdownRect();
	}
	public function dropdown1()
	{
		dropdown.graphics.clear();
		dropdown.graphics.beginFill(0xDFE0EA);
		dropdown.graphics.moveTo(0, 8);
		dropdown.graphics.lineTo(8/2,0);
		dropdown.graphics.lineTo(8, 8);
		dropdownRect();
	}
	public function dropdownRect()
	{
		dropdown.graphics.endFill();
		dropdown.graphics.beginFill(0, 0);
		dropdown.graphics.drawRect( -12, -12, 12 + 8 + 8 + 8, 12 + 8 + 8);
	}
	
	public function expand()
	{
		dropdown0();
		shape.graphics.clear();
		shape.graphics.lineStyle(2, 0x36373E);
		shape.graphics.beginFill(0x5B5D6B);
		shape.graphics.drawRoundRect(0, 0, shapeWidth, 640, 4 * 2, 4 * 2);
		shapeUnderLine();
	}
	public function collaspe()
	{
		dropdown1();
		shape.graphics.clear();
		shape.graphics.lineStyle(2, 0x36373E);
		shape.graphics.beginFill(0x5B5D6B);
		shape.graphics.drawRoundRect(0, 0, shapeWidth, 31, 4 * 2, 4 * 2);
		//shapeUnderLine();
	}
	public function shapeUnderLine()
	{
		//embed line into shape
		shape.graphics.endFill();
		shape.graphics.lineStyle(2, 0x36373E); shape.graphics.moveTo(16, 31); shape.graphics.lineTo(16 + shapeWidth - 32, 31);
		shape.graphics.lineStyle(2, 0x757788); shape.graphics.moveTo(16, 31 + 2); shape.graphics.lineTo(16 + shapeWidth - 32, 31 + 2);
	}
	
    public function Rect():Rectangle 
	{
		return new Rectangle(x, y, width, height);
	}
	
	//called from mouseup in editor state
	public function pressed() 
	{
		if (App.pointRect(mouseX, mouseY, new Rectangle(dropdown.x, dropdown.y, dropdown.width, dropdown.height))) expandBool = !expandBool;
	}
	
}