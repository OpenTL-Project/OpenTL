package;

import core.App;
import core.Button;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * ...
 * @author 
 */
class HandleButton extends Button
{
	
	//global
	public static var main:HandleButton;
	public var direction:Int = 0;
	/**
	 * 
	 * @param	xpos
	 * @param	ypos
	 * @param	size
	 * @param	dir -1 = defualt, 0 = up, 1 = down, 2 = left, 3 = right
	 */
	public function new(?xpos:Float=0, ?ypos:Float=0, dir:Int=-1, lineThickness:Int=2, setWidth:Int=16) 
	{
		super();
		direction = dir;
		cacheAsBitmap = true;
		//function
		Down = function(_)
		{
			main = this;
		}
		//auto add to stageContainer
		if (dir >= 0) 
		{
			EditorState.stageContainer.addChild(this);
		}else{
			x = xpos;
			y = ypos;
		}
		//generate graphic
		graphics.lineStyle(lineThickness,0xDFE0EA);
		switch(direction)
		{
			case -1:
			graphic0(setWidth, lineThickness);
			case 0:
			//up
			graphic0(setWidth, lineThickness);
			x = (EditorState.tilemap.width - width)/2;
			y = -9 - height;
			case 1:
			//down
			graphic0(setWidth, lineThickness);
			x = (EditorState.tilemap.width - width) / 2;
			y = EditorState.tilemap.height + 9;
			case 2:
			//left 
			graphic1(setWidth, lineThickness);
			x = -9 - height;
			y = (EditorState.tilemap.height - height)/2;
			case 3:
			//right
			graphic1(setWidth, lineThickness);
			x = EditorState.tilemap.width + 9;
			y = (EditorState.tilemap.height - height)/2;
		}
		
		//background invis rect
		graphics.endFill();
		graphics.beginFill(0, 0);
		graphics.drawRect(0, 0, width, height);
	}
	
	public static function update()
	{
		trace("update");
		var difY:Float = App.state.mouseY - EditorState.oY;
		var difX:Float = App.state.mouseX - EditorState.oX;
		
		switch(main.direction)
		{
			case 0:
			//up
			if (EditorState.tilemap.grid.height - difY < 0) return;
			EditorState.tilemap.grid.y += difY;
			EditorState.tilemap.grid.height += -difY;
			main.y += difY;
			case 1:
			//down
			EditorState.tilemap.grid.height += difY;
			main.y += difY;
			case 2:
			//left
			if (EditorState.tilemap.grid.width - difX < 0) return;
			EditorState.tilemap.grid.x += difX;
			EditorState.tilemap.grid.width += -difX;
			main.x += difX;
			case 3:
			//right	
			EditorState.tilemap.grid.width += difX;
			main.x += difX;
		}
	}
	
	public function Rect():Rectangle
	{
		return new Rectangle(x, y, width, height);
	}
	
	public function graphic0(setWidth:Int,lineThickness:Int)
	{
		graphics.moveTo(0, 0); graphics.lineTo(setWidth, 0);
		graphics.moveTo(0, lineThickness * 2); graphics.lineTo(setWidth, lineThickness * 2);
	}
	public function graphic1(setWidth:Int,lineThickness:Int)
	{
		graphics.moveTo(0, 0); graphics.lineTo(0, setWidth);
		graphics.moveTo(lineThickness * 2, 0); graphics.lineTo(lineThickness * 2, setWidth);
	}
	
}