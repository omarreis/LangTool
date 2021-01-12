unit LangToolEditor; // LangTool alternative TLang component editor

interface

uses
  System.SysUtils,System.UITypes,System.Classes,
  FMX.Dialogs,
  FMX.Types,     // TLang
  DesignEditors,
  DesignIntf;

type
  TLangToolComponentEditor = class(TComponentEditor)
  private
    fOldEditor: TComponentEditor;
    procedure ShowLangToolForm;
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
    destructor  Destroy;                                              override;
    function  GetVerbCount: Integer;            override;
    function  GetVerb(Index: Integer): string;  override;
    procedure ExecuteVerb(Index: Integer);      override;
  end;

procedure Register;

implementation  //---------------------------------

uses
  fTLangTool; //  TFormTLangTool  - LangTool editor form

// see https://stackoverflow.com/questions/33547929/create-a-descendant-of-a-existing-componenteditor-tfdquery
VAR
  PrevEditorClass:TComponentEditorClass=NIL;   //save class of original IDE TLang Editor

constructor TLangToolComponentEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);

  IF Assigned( PrevEditorClass ) THEN //must be
    fOldEditor := TComponentEditor(PrevEditorClass.Create(AComponent, ADesigner))
    else fOldEditor := nil;
end;

destructor TLangToolComponentEditor.Destroy;
begin
  if Assigned(fOldEditor) then
    begin
      fOldEditor.Free;
      fOldEditor := nil;
    end;

  inherited;   // test: jan21: invalid access when Delphi is closed
end;

function TLangToolComponentEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

function TLangToolComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Show &LangTool Editor..';
    1: IF Assigned(fOldEditor) THEN Result := 'Show IDE Lang Designer..'
         else Result := 'Old editor not found';
  else
    Result := 'LangTool supports 2 verbs.';
  end;
end;

procedure TLangToolComponentEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: ShowLangToolForm;
    1: IF Assigned(FOldEditor) THEN FOldEditor.Edit
       else MessageDlg('Old editor not found', TMsgDlgType.mtInformation,
         [TMsgDlgBtn.mbOk], 0);
  else
    raise ENotImplemented.Create('LangTool supports 2 verbs.');
  end;
end;

procedure AssignTLang(aLangSrc,aLangDest:TLang);  // TLang --> TLang    same as aLangDest.Assign(aLangSrc)
var i:integer; aLang:String; aStrs1,aStrs2:TStrings;
begin
  aLangDest.Lang := aLangSrc.Lang;  //original
  aLangDest.Original.Assign(aLangSrc.Original); //ok
  // TODO: dispose Resources?
  aLangDest.Resources.Clear;
  for i:= 0 to aLangSrc.Resources.Count-1 do
    begin
      aLang  := aLangSrc.Resources.Strings[i];
      aStrs1 := TStrings(aLangSrc.Resources.Objects[i]);
      aLangDest.AddLang(aLang);
      aStrs2 := aLangDest.LangStr[aLang];  //get access to strings
      aStrs2.Assign(aStrs1);              //copy strings
    end;
end;

procedure TLangToolComponentEditor.ShowLangToolForm;
var  DesignerForm: TFormTLangTool; aLangSrc,aLangDest:TLang;
begin
  DesignerForm := TFormTLangTool.Create(nil);
  try
    // Set curent value to designer form
    aLangSrc  := (Component as TLang);
    aLangDest := DesignerForm.Lang1;
    AssignTLang(aLangSrc, aLangDest);         // Componemnt --> LangTool.Lang1
    DesignerForm.populateGridWithLanguages;  // Lang1 --> grid
    // Show ModalForm, and then take result
    if DesignerForm.ShowModal = mrOK then     // modal
      begin
        DesignerForm.copyGridToLang1;
        aLangSrc := DesignerForm.Lang1;
        aLangDest:= (Component as TLang);
        AssignTLang(aLangSrc,aLangDest);         // as in aLangDest.Assign( aLangSrc );
        Designer.Modified;
      end;
  finally
    DesignerForm.Free;
  end;
end;

procedure Register;
VAR
  aLang: TLang;
  Editor: IComponentEditor;
BEGIN
  aLang := TLang.Create(NIL);
  TRY
    Editor := GetComponentEditor( aLang, NIL);  // get original Delphi TLang editor
    IF Assigned(Editor) THEN BEGIN
      PrevEditorClass := TComponentEditorClass((Editor AS TObject).ClassType);
    END;
  FINALLY
    Editor := NIL;
    aLang.Free;
  END;
  RegisterComponentEditor(TLang, TLangToolComponentEditor);
END;

end.

