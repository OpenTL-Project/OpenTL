package;

import core.App;
import core.Button;
import motion.Actuate;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author 
 */
class Tab extends Button
{
	@:isVar public var expand(get, set):Bool = true;
	function get_expand():Bool
	{
		return expand;
	}
	function set_expand(set:Bool):Bool
	{
		expand = set;
		updateExpand();
		return expand;
	}
	public var shape:Shape;
	//buttons
	public var dropdown:Shape;
	public var add:Shape;
	public var trash:Shape;
	
	

	public function new(title:String,expanded:Bool=true,scrollable:Bool=true,toggleView:Bool=false) 
	{
		super();
		//main shape
		shape = new Shape();
		shape.graphics.lineStyle(2, 0x36373E);
		shape.graphics.beginFill(0x5B5D6B);
		shape.graphics.drawRoundRect(0, 0, 256, 640, 4 * 2, 4 * 2);
		//embed line into shape
		shape.graphics.endFill();
		shape.graphics.lineStyle(2, 0x36373E); shape.graphics.moveTo(16, 31); shape.graphics.lineTo(16 + 224, 31);
		shape.graphics.lineStyle(2, 0x757788); shape.graphics.moveTo(16, 31 + 2); shape.graphics.lineTo(16 + 224, 31 + 2);
		
		addChild(shape);
		addChild(App.createText(title, 32, 8 + 0, 14, 0xDFE0EA, TextFormatAlign.LEFT, 126 + 76 - 20));
		dropdown = new Shape();
		dropdown.x = 12; dropdown.y = 12 + 4;
		//turn upside down
		if (!expanded) dropdown.rotation = 180;
		addChild(dropdown);
		
		//set
		expand = expanded;
		
		//enable function
		Click = function(_){};
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
	
	public function updateExpand()
	{
		//TODO: expand and unexpand tab
		if (expand)
		{
		dropdown0();
		}else{
		dropdown1();
		}
	}
	
	override public function mouseClick(e:MouseEvent) 
	{
		super.mouseClick(e);
		if (App.pointRect(e.localX, e.localY, new Rectangle(dropdown.x,dropdown.y,dropdown.width,dropdown.height)))
		{
			updateExpand();
			expand = !expand;
			trace("pressed");
		}
		//trace("mouseX " + e.localX + " mouseY " + e.localY);
		
	}
	
}