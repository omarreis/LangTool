# LangTool
This app offers some features not found in the original TLang IDE editor.

LangTool is a Firemonkey app (multiplatform). Tested on Windows 10.
Compiled with Delphi 10.3.3

## LangTool  features :
* Edit all languages in the same grid (uses a TStringGrid)
* Copy original texts to clipboard (to use with Google translate) 
* Paste list of strings from clipboard (to imput Google translate results) 
* Load/Save *.LNG files

TLang is clearly a work in progress. The original editor has no way 
to delete a single language. To work around that:
1- change form to text 
2- delete TLang.Resources property 
3- Change back to form, double click TLang and import the file edited with LangTool (*.lng)
Close TLang editor and reopen it to update the languages combo (it is not updated after load)

Also you may need to localize Dialog texts ( Yes, No etc) 
To do that copy FMX.Dialogs.pas to project directory and change it 
as described in this stackoverflow answer ( the one by omarreis):

https://stackoverflow.com/questions/39750219/how-to-change-at-runtime-the-value-of-smsgdlgyes-smsgdlgno-etc/61643607#61643607


![LangTool screen shot](LangToolShot.png)
