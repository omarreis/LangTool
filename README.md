# LangTool
This app offers some features not found in the original TLang editor.

LangTool special features :
* Edit all languages in the same grid (uses a TStringGrid)
* Copy original texts to clipboard (to use with Google translate) 
* Paste list of strings from clipboard (to imput Google translate results) 
* Load/Save *.LNG files

TLang is clearly a work in progress. The original editor has no way 
to delete a single language. To work around that, change form to text 
and delete TLang.Resources property Change back to form, 
double click TLang and import the *.lng file
Close TLang and reopen to update the languages combo

Also you need to hack FMX.Dialogs.pas to be able to 
localize dialog texts ( Yes, No etc)

Check this stackoverflow answer:
https://stackoverflow.com/questions/39750219/how-to-change-at-runtime-the-value-of-smsgdlgyes-smsgdlgno-etc/61643607#61643607

