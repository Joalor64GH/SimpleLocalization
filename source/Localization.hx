package;

import sys.io.File;
import sys.FileSystem;

import flixel.FlxG;
import haxe.Json;

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
    private static var currentLanguage:String; // Stores the currently selected language
    private static var DEFAULT_LANGUAGE:String = "en-us"; // The default language (English)

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
            if (languageData != null) {
                trace("successfully loaded language: " + language + "!");
                data.set(language, languageData);
            } else {
                trace("oh no! failed to load language: " + language + "!");
                allLoaded = false;
            }
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
        var path:String = Paths.file("languages/" + language + ".json"); // You can edit this if you need to

        // Attempt to load the requested file
        if (FileSystem.exists(path)) {
            // Use the requested language if the file is found
            jsonContent = File.getContent(path);
            currentLanguage = language; // Updates current language to the requested one
        } else {
            // If the requested file is not found, uses the default language as a fallback
            trace("oops! file not found for: " + language + "!");
            jsonContent = File.getContent(Paths.file("languages/" + DEFAULT_LANGUAGE + ".json"));
            currentLanguage = DEFAULT_LANGUAGE;
        }

        return Json.parse(jsonContent);
    }

    /**
     * Used to switch languages to a specified code.
     * @param newLanguage The new language to switch to.
     * @return Whether or not the switch was successful.
     */

    public static function switchLanguage(newLanguage:String):Bool
    {
        // Check if requested language is the same as the current language 
        if (newLanguage == currentLanguage) {
            trace("hey! you're already using the language: " + newLanguage);
            return true; // Language is already selected, so no change is needed
        }

        // Attempt to load data for requested language
        var languageData:Dynamic = loadLanguageData(newLanguage);

        // Check if the data was successfully loaded
        if (languageData != null) {
            trace("yay! successfully loaded data for: " + newLanguage);
            currentLanguage = newLanguage; // Updates current language
            data.set(newLanguage, languageData); // Sets data for new language
            return true; // The switch was successful
        } else {
            trace("whoops! failed to load data for: " + newLanguage);
            return false; // The switch failed
        }

        return false;
    }

    /**
     * Retrieves a localized string for a given key and language.
     * @param key The key for the localized string.
     * @param language The language to retrieve the string from.
     * @return The localized string.
     */

    public static function get(key:String, language:String = "en-us"):String
    {
        var targetLanguage:String = language.toLowerCase();
        var languageData = data.get(targetLanguage);
        
        if (data != null) {
            if (data.exists(targetLanguage)) {
                if (languageData != null && Reflect.hasField(languageData, key)) {
                    return Reflect.field(languageData, key);
                }
            }
        }

        return Reflect.field(languageData, key); // Returns the string
    }
}
