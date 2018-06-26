package;

import core.Button;

/**
 * ...
 * @author 
 */
class HandleButton extends Button 
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
		super(xpos, ypos);
		//auto add to stageContainer
		if (dir >= 0) EditorState.stageContainer.addChild(this);
		//generate graphic
		graphics.beginFill(0xDFE0EA);
		switch(dir)
		{
			case -1:
			graphic0(setWidth, lineThickness);
			case 0:
			//up
			graphic1(setWidth, lineThickness);
			x = EditorState.tilemap.width;
			y = -9 -height;
			case 1:
			//down
			graphic1(setWidth, lineThickness);
			
			case 2:
			//left 
			graphic1(setWidth, lineThickness);
			
			case 3:
			//right
			graphic1(setWidth, lineThickness);
			
		}
		trace("x " + x + " y " + y);
	}
	
	public function graphic0(setWidth:Int,lineThickness:Int)
	{
		graphics.drawRect(0, 0, setWidth, lineThickness);
		graphics.drawRect(0, lineThickness * 2, setWidth, lineThickness);
	}
	public function graphic1(setWidth:Int,lineThickness:Int)
	{
		graphics.drawRect(0, 0, lineThickness, setWidth);
		graphics.drawRect(lineThickness * 2, 0, lineThickness, setWidth);
	}
	
}