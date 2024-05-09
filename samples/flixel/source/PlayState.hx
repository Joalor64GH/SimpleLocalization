package;

import flixel.input.keyboard.FlxKey;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;

import Localization;

class PlayState extends FlxState
{
    var daText:FlxText;

    override public function create()
    {
        Localization.init({
            languages: ['en-us', 'es-es', 'fr-fr', 'pt-br', 'yr-hr'],
            directory: "languages", // this variable is optional
            default_language: "en-us" // this variable is optional
        });

        daText = new FlxText(0, 0, FlxG.width, '', 12);
        daText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        daText.screenCenter(XY);
        add(daText);

        var daText2:FlxText = new FlxText(5, FlxG.height - 24, 0, 'Use 1-5 to switch languages.', 12);
        daText2.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        daText2.scrollFactor.set();
        add(daText2);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        final keyPressed:FlxKey = FlxG.keys.firstJustPressed();
        if (keyPressed != FlxKey.NONE) {
            switch (keyPressed) {
                case ONE: Localization.switchLanguage("en-us");
                case TWO: Localization.switchLanguage("es-es");
                case THREE: Localization.switchLanguage("fr-fr");
                case FOUR: Localization.switchLanguage("pt-br");
                case FIVE: Localization.switchLanguage("yr-hr");
            }
        }
        
        daText.text = Localization.get('greeting');
    }
}