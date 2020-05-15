# LangTool
LangTool is a language editor for Delphi Firemonkey. It helps with app localization.
The program manages LNG ( language files ) to be used with component TLang.
This app offers some features not found in the original TLang IDE editor.

LangTool is a Firemonkey app (multiplatform). Tested on Windows 10.
Compiled with Delphi 10.3.3

## What's inside LNG files ?
* List of *Original* texts (TStrings) 
* List of translation *Resources*
  Each resource (language) has: 
    * lang code: two letter ISO language code ( use capital letters )
    * Strings: list of text=translation lines for the language

Languages can be loaded from a file or from form resources.
The last loaded language goes into global var Lang:TStringList

Translate() function does translations at run time.
    
## LangTool  features :
* Load/Save *.LNG files 
* Add/delete languages
* Edit all languages in the same grid (uses a TStringGrid, edit strings in place)
* Copy original list of texts to clipboard (ex: to use with Google Translate) 
* Paste list of strings from clipboard (input translation results). 
  Before pasting a list of strings from clipboard remember to **place the cursor in the desired cell** 
  Place cursor in the top of the column to paste a whole new language ( list of strings )
* Drag columns ( change language order, not that this matters.. )   
  
Note that automatic translation services a lot of times translate words out of context.
Have a translator - or at least a native speaker - review your app translations.

Interaction between LangTool and the Delphi IDE is done by means of LNG files.

* On the IDE, double-click TLang component in your form to open the property editor
* Import texts from form (labels buttons etc)
* Save file YourAppName.lng. No languages yet.
* Open the file with LangTool
* Add languages using 2 letter codes like 'ES', 'FR', 'IT' .. 
* Complete translation texts, editing grid cells ( in place editing). 
Leave untranslated texts empty. 
* Save .lng file
* On the IDE, TLang property editor, load translation file.

TLang seems to be a work  in progress (as of D 10.3.3)  
The original editor has no way to delete a language or reset the component. 
If you open a lng file on top of existing translations, they get duplicated.

To work around that, what I did was:

* In your app , right-click the form change form-to-text 
* Locate TLang component (ex. Lang1) delete ResourcesBin property 
* change back to form mode, double click the empty TLang and import the file edited with LangTool (*.lng)
* close TLang editor and reopen it to update the languages combo (it is not updated after file load)

TODO: Localize LangTool !!!!   :)

You may also need to localize Delphi default dialog texts ( Yes, No etc). This is not done by TLang.
To do that copy FMX.Dialogs.pas to project directory and change it 
as described in this stackoverflow answer (the one by omarreis)

https://github.com/omarreis/LangTool/blob/master/fixDialogs.md

https://stackoverflow.com/questions/39750219/how-to-change-at-runtime-the-value-of-smsgdlgyes-smsgdlgno-etc/61643607#61643607

![LangTool screen screenshot](LangToolShot.png)

