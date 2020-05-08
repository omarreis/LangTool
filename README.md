# LangTool
This app offers some features not found in the original TLang IDE editor.

LangTool is a Firemonkey app (multiplatform). Tested on Windows 10.
Compiled with Delphi 10.3.3

## LangTool  features :
* Load/Save *.LNG files 
* Edit all languages in the same grid (uses a TStringGrid, edit strings in place)
* Copy original list of texts to clipboard (to use with Google translate) 
* Paste list of strings from clipboard (to imput Google translate results). 
  Before pasting a list of strings from clipboard **place the cursor in the desired cell**
  
Note that automatic translation services sometimes translate words out of context.
Have a translator - or at least a native speaker - review your app translations.

Interaction between LangTool and TLang is done by means of LNG files
* On the IDE, double click TLang component to open property editor
* Import texts from form (labels buttons etc)
* Save file *.lng*. No languages yet.
* Open it with LangTool
* Add languages using 2 letter codes like 'ES', 'FR', 'IT' .. 
* Complete translation texts, editing grid cells. Leave untranslated texts empty. 
* Save *.lng file
* On the IDE, TLang property editor, load translation file.

TLang is clearly a work in progress. The original editor has no way 
to delete a single language. To work around that:
* change form to text 
* delete TLang.Resources property 
* Change back to form, double click TLang and import the file edited with LangTool (*.lng)
* Close TLang editor and reopen it to update the languages combo (it is not updated after load)

You may also need to localize Delphi default dialog texts ( Yes, No etc). This is not done by TLang.
To do that copy FMX.Dialogs.pas to project directory and change it 
as described in this stackoverflow answer (the one by omarreis):

https://stackoverflow.com/questions/39750219/how-to-change-at-runtime-the-value-of-smsgdlgyes-smsgdlgno-etc/61643607#61643607

![LangTool screen screenshot](LangToolShot.png)
