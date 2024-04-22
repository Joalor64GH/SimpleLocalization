package;

class Main extends openfl.display.Sprite
{
	public function new()
	{
		super();
		addChild(new flixel.FlxGame(1280, 720, PlayState, #if (flixel < "5.0.0") -1, #end 60, 60, false, false));
	}
}