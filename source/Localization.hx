package;

#if sys
import sys.io.File;
#end

#if openfl
import openfl.system.Capabilities;
#end
import openfl.Assets;

import haxe.Json;
import haxe.io.Path;

using StringTools;

typedef ApplicationConfig = {
    var languages:Array<String>;
    @:optional var directory:String;
    @:optional var default_language:String;
}

/**
 * A simple localization system.
 * Please credit me if you use it!
 * @author Joalor64GH
 */

class Localization 
{
    /**
     * Contains data for different languages.
     * The outer map's key represents the language code, and the inner dynamic object contains the key-value pairs for localized strings.
     */
    private static var data:Map<String, Dynamic>;

    /**
     * is the Selected Language
     */
    private static var currentLanguage:String;

    /**
     * Is the application's default language
     */
    public static var DEFAULT_LANGUAGE:String = "en-us";

    /**
     * Is the application's default language directory
     */
    private static final DEFAULT_DIR:String = "languages";

    /**
     * is where the files are located
     */
    public static var directory:String = DEFAULT_DIR;

    /**
     * is the System Language.
     * it doesn't return the language variation!
     */
    public static var systemLanguage(get, never):String;

    public static function get_systemLanguage() 
    {
        #if openfl
        return Capabilities.language; 
        #else
        return throw "This Variable is for OpenFl only!";
        #end
    }

    /**
     * is to start the Class but for something more customizable you can use loadLanguages
     * @param config is where you will have the variables to configure the Class
     */
    public static function init(config:ApplicationConfig) 
    {
        directory = config.directory ?? "languages";
        DEFAULT_LANGUAGE = config.default_language ?? "en-us";

        loadLanguages(config.languages);
        switchLanguage(DEFAULT_LANGUAGE);
    }

    /**
     * Simply loads languages based on an array of codes.
     * @param languages An array containing the language codes (Example: ["en-us", "es-es", "fr-fr"]).
     * @return Whether or not all languages were successfully loaded.
     */

    public static function loadLanguages(languages:Array<String>):Bool
    {
        var allLoaded:Bool = true;

        data = new Map<String, Dynamic>();

        for (language in languages) {
            var languageData:Dynamic = loadLanguageData(language);
            data.set(language, languageData);
        }

        return allLoaded;
    }

    /**
     * Loads the data for the specified language, but falls back to English if it's not found.
     * @param language The language code (Example: "en-us" for English).
     * @return The map containing the parsed data.
     */

    private static function loadLanguageData(language:String):Dynamic
    {
        var jsonContent:String;

        try {
            // Use the requested language if the file is found
            #if sys
            jsonContent = File.getContent(path(language));
            #else
            jsonContent = Assets.getText(path(language));
            #end
        } catch (e) { // If an error occurs, it will set the default language!
            trace('file not found: $e');
            #if sys
            jsonContent = File.getContent(path(DEFAULT_LANGUAGE));
            #else
            jsonContent = Assets.getText(path(DEFAULT_LANGUAGE));
            #end
        }

        return Json.parse(jsonContent);
    }

    /**
     * Used to switch languages to a specified code.
     * @param newLanguage The new language to switch to.
     */

    public static function switchLanguage(newLanguage:String)
    {
        // Check if requested language is the same as the current language 
        if (newLanguage == currentLanguage)
            return; // Language is already selected, so no change is needed

        // Attempt to load data for requested language
        var languageData:Dynamic = loadLanguageData(newLanguage);

        currentLanguage = newLanguage; // Updates current language
        data.set(newLanguage, languageData); // Sets data for new language
        trace('Language changed to $currentLanguage');
    }

    /**
     * Retrieves a localized string for a given key and language.
     * @param key The key for the localized string.
     * @param language The language to retrieve the string from.
     * @return The localized string.
     */

    public static function get(key:String, ?language:String):String
    {
        var targetLanguage:String = language ?? currentLanguage;
        var languageData = data.get(targetLanguage);
        
        if (data == null) {
            trace("You haven't initialized the class!");
            return null;
        }

        if (data.exists(targetLanguage))
            if (Reflect.hasField(languageData, key))
                return Reflect.field(languageData, key);

        return null;
    }

    /**
     * it returns a language directory
     * @param language Target Language
     */
    private static function path(language:String) {
        var localDir = Path.join([directory, language + ".json"]);
        var path:String = Paths.file(localDir); // change this if you need to
        return path; 
    }
}