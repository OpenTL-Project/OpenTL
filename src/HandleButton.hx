package;

import core.Button;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * ...
 * @author 
 */
class HandleButton extends Shape
{
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
		cacheAsBitmap = true;
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
		switch(dir)
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
	
	public function pressed() 
	{
		
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