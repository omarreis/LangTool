![LangTool logo](LangToolLogo.png)

# LangTool
LangTool is a language editor for Delphi Firemonkey, to help with app localization.
It manages LNG ( language files ) to be used with component TLang.
This app offers some features not found in the original TLang IDE Language Designer.

LangTool can installed on the Delphi IDE as a design time package
or run as a desktop app. The package contains no new components, only an 
alternative TLang Component Editor.

Tested on Windows 10 (Delphi 10.3.3)

## What's inside LNG files ?
* List of *Original* texts (TStrings) 
* List of translation *Resources*.   Each resource (language) has: 
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
  Place cursor on the top of the column to paste a whole new language ( list of strings )
* Drag columns ( change language order, not that this matters.. )   
  
Note that automatic translation services a lot of times translate words out of context.
Have a translator - or at least a native speaker - review your app translations.

## LangTool installation
LangTool installs on the IDE as a design time package.
Compile *dclLangTool.dpk* and install it.

![TLang menu](TLangMenu.png) 

Right-click a TLang component on a Form. Now you have 2 options:
* Show LangTool Editor..              <--- LangTool 
* Show IDE Lang Designer..            <--- Original component editor

Original editor can be used to import texts from form, export templates  and LNG files.
The original IDE editor, however, cannot delete languages, or edit all
languages in the same grid, or copy-paste languages to-from translation services.
For that you now have LangTool   :)

TODO: Localize LangTool !!!!   :)

But wait...There is more!

You may want to localize Delphi default dialog texts ( Yes, No etc). This is not done by TLang.
To do that copy FMX.Dialogs.pas to project directory and change it 
as described in this stackoverflow answer (the one by omarreis)

https://github.com/omarreis/LangTool/blob/master/fixDialogs.md

https://stackoverflow.com/questions/39750219/how-to-change-at-runtime-the-value-of-smsgdlgyes-smsgdlgno-etc/61643607#61643607

![LangTool screen screenshot] (LangToolShot.png) 


