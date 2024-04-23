# Simple Localization™
My own localization system made from scratch! <br>
Basically, it uses keys from `.json` files to translate text, and that's all there is to it!

## Basic Usage
Initialization:
```hx
Localization.init({
    languages: ['en-us', 'es-es', 'fr-fr', 'pt-br', 'yr-hr'],
    directory: "languages", // this variable is optional
    default_language: "en-us" // this variable is optional
});
```

Switching to another language:
```hx
Localization.switchLanguage("en-us");
```

Retrieving a key:
```hx
Localization.get("greeting", "en-us"); // If the second parameter is empty, defaults to current language
```

Basic `.json` setup:
```json
{
    "greeting": "Hello world!",
    "farewell": "Goodbye!"
}
```

## Documentation
For futher documentation, check out [`Localization.hx`](/source/Localization.hx).

## Other Stuff
You can check out this system in action in the [`samples/flixel`](/samples/flixel/) folder. <br>
If you need localization tags, go [here](https://tinyurl.com/zm5f35ua).
