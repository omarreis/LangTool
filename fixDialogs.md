from https://stackoverflow.com/questions/39750219/how-to-change-at-runtime-the-value-of-smsgdlgyes-smsgdlgno-etc/61643607#61643607

# How to localize Firemonkey Dialogs

Firemonkey dialog messages like button texts 'Yes', 'No' are defined as const in FMX.Dialogs.pas.
Changing it for localization is not allowed using default compiler settings 
Compiler gives 'left side cannot be assigned'
So I copyed FMX.Dialogs.pas to my project directory and changed the **const** to a **var**

FMX.Dialogs.pas

        ..
      var  // <-- added this to change ButtonCaptions and MsgTitles to var, to allow localization
        MsgTitles: array[TMsgDlgType] of string = (SMsgDlgWarning, SMsgDlgError, SMsgDlgInformation, SMsgDlgConfirm, '');
        ButtonCaptions: array[TMsgDlgBtn] of string = (SMsgDlgYes, SMsgDlgNo, SMsgDlgOK, SMsgDlgCancel, SMsgDlgAbort,    
        ...

then I added: 

    Procedure LocalizeDialogButtons; // localize texts inside FMX.Dialogs
    begin
      ButtonCaptions[TMsgDlgBtn.mbyes]      := Translate(SMsgDlgYes);        //  'Yes'
      ButtonCaptions[TMsgDlgBtn.mbno]       := Translate(SMsgDlgNo);         //  'No'
      ButtonCaptions[TMsgDlgBtn.mbOK]       := Translate(SMsgDlgOK);         //  'OK'
      ButtonCaptions[TMsgDlgBtn.mbCancel]   := Translate(SMsgDlgCancel);     //  'Cancel'
      ButtonCaptions[TMsgDlgBtn.mbAbort]    := Translate(SMsgDlgAbort);      //  'Abort'
      ButtonCaptions[TMsgDlgBtn.mbRetry]    := Translate(SMsgDlgRetry);      //  'Retry'
      ButtonCaptions[TMsgDlgBtn.mbIgnore]   := Translate(SMsgDlgIgnore);     //  'Ignore'
      ButtonCaptions[TMsgDlgBtn.mbNoToAll]  := Translate(SMsgDlgNoToAll);    //  'No to All'
      ButtonCaptions[TMsgDlgBtn.mbYesToAll] := Translate(SMsgDlgYesToAll);   //  'Yes to &All'
      ButtonCaptions[TMsgDlgBtn.mbHelp]     := Translate(SMsgDlgHelp);       //  'Help'
      ButtonCaptions[TMsgDlgBtn.mbClose]    := Translate(SMsgDlgClose);      //  'All'
      MsgTitles[TMsgDlgType.mtWarning]      := Translate(SMsgDlgWarning);    //  'Warning'
      MsgTitles[TMsgDlgType.mtError]        := Translate(SMsgDlgError);      //  'Error'
      MsgTitles[TMsgDlgType.mtInformation]  := Translate(SMsgDlgInformation);//  'Information'
      MsgTitles[TMsgDlgType.mtConfirmation] := Translate(SMsgDlgConfirm);    //  'Confirm'
    
    end;

Which is called on FormCreate, after loading the localization strings with TLang.

* Add the dialog texts to TLang (one by one).
* Complete the translations for the new texts, for all languages. 
  So all text translations are in one place.

Note that you *have to* compare your changed FMX.Dialogs.pas with the official version (and apply changes) every time you do a Delphi update, to be in sync 

https://github.com/omarreis/LangTool/blob/master/readme.md
