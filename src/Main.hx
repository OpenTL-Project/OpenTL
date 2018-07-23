package;

import core.App;
import openfl.display.Sprite;
import openfl.Lib;
import core.Font;
import crashdumper.CrashDumper;

/**
 * ...
 * @author 
 */
class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
		new App(1440,1024, new Font("prox", "assets/data/Depot New W00 Thin.ttf", "assets/data/Varela-Regular.ttf", "assets/data/GothamMedium.ttf", "assets/data/OpenSans-Italic.ttf", "assets/data/Comfortaa-Light.ttf"));
		App.state = new EditorState();
		var fps = new openfl.display.FPS();
		Lib.current.addChild(fps);
	}

}
