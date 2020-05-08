unit fTLangTool;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Objects, FMX.StdCtrls, System.Rtti, FMX.Grid.Style, FMX.Grid, Fmx.Platform,
  FMX.ScrollBox, FMX.Layouts, FMX.Controls.Presentation;

type
  TFormTLangTool = class(TForm)
    ActionList1: TActionList;
    PreviousTabAction1: TPreviousTabAction;
    TitleAction: TControlAction;
    NextTabAction1: TNextTabAction;
    TopToolBar: TToolBar;
    btnBack: TSpeedButton;
    ToolBarLabel: TLabel;
    btnNext: TSpeedButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    BottomToolBar: TToolBar;
    layoutTopLangPg1: TLayout;
    TransGrid: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    btnLoadLngFile: TButton;
    Lang1: TLang;
    btnPasteLanguage: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    btnSaveFileAs: TButton;
    btnClearAll: TButton;
    StringColumn8: TStringColumn;
    StringColumn9: TStringColumn;
    StringColumn10: TStringColumn;
    StringColumn11: TStringColumn;
    StringColumn12: TStringColumn;
    StringColumn13: TStringColumn;
    StringColumn14: TStringColumn;
    StringColumn15: TStringColumn;
    btnAddLanguage: TButton;
    btnCopyTextsToClipboard: TButton;
    rectAboutLangTool: TRectangle;
    labVersion: TLabel;
    Label1: TLabel;
    linkGit: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TitleActionUpdate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure btnLoadLngFileClick(Sender: TObject);
    procedure btnSaveFileAsClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnAddLanguageClick(Sender: TObject);
    procedure btnCopyTextsToClipboardClick(Sender: TObject);
    procedure btnPasteLanguageClick(Sender: TObject);
  private
    procedure populateGridWithLanguages;
    procedure copyGridToLang1;
    procedure ClearLang1;
    procedure ClearGrid;
    procedure DoClearAll;
    procedure DoAddLanguage(const aLang: String);
  public
  end;

var
  FormTLangTool: TFormTLangTool;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.iPhone4in.fmx IOS}

function TryGetClipboardService(out _clp: IFMXClipboardService): boolean;
begin
  Result := TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService);
  if Result then
    _clp := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
end;

procedure StringToClipboard(const _s: string);
var
  clp: IFMXClipboardService;
begin
  if TryGetClipboardService(clp) then
    clp.SetClipboard(_s);
end;

procedure StringFromClipboard(out _s: string);
var
  clp: IFMXClipboardService;
  Value: TValue;
  s: string;
begin
  if TryGetClipboardService(clp) then begin
    Value := clp.GetClipboard;
    if not Value.TryAsType(_s) then
      _s := '';
  end;
end;

procedure TFormTLangTool.TitleActionUpdate(Sender: TObject);
begin
  if Sender is TCustomAction then
  begin
    if TabControl1.ActiveTab <> nil then
      TCustomAction(Sender).Text := TabControl1.ActiveTab.Text
    else
      TCustomAction(Sender).Text := '';
  end;
end;

procedure TFormTLangTool.populateGridWithLanguages;
var
  len: Cardinal;
  i,j: Integer;
  r,c:integer;
  S,aTrans,sLang,aOrig:String;

begin
  // Sep := #9;    //csv w/ tab
  ClearGrid;

  len := Lang1.Resources.Count;  // number of languages
  S := 'en';                     // Original language = 'en'
  c:=0; r:=0;                    // col row
  TransGrid.Columns[0].Header := S;  // 1st col= Original texts
  for j := 0 to Lang1.Original.Count-1 do
    TransGrid.Cells[0,j] := Lang1.Original.Strings[j];

  for i:=0 to len-1 do //for each lang, build column
    begin
      c     := i+1;
      sLang := Lang1.Resources[i];     // sLang tipo 'pt'
      // TransGrid.Cells[c,0] := sLang;      // header da lingua
      TransGrid.Columns[c].Header := sLang;       //
                                                    //
      LoadLangFromStrings( Lang1.LangStr[sLang]);    // load language strings if available

      for j:=0 to Lang1.Original.Count-1 do
        begin
          aOrig  := Lang1.Original.Strings[j];
          aTrans := Translate(aOrig);
          if (aTrans=aOrig) then aTrans:='';

          TransGrid.Cells[c,j] := aTrans;
        end;
    end;
end;

procedure TFormTLangTool.btnAddLanguageClick(Sender: TObject);
begin
   InputBox('New Lang','Enter language code (2 chars):','',
     procedure(const AResult: TModalResult; const AValue: string)
     begin
       if (AResult=mrOK) then
         DoAddLanguage(AValue);
     end
    );
end;

procedure TFormTLangTool.DoAddLanguage(const aLang:String);
var c:integer; aCol:TColumn;
begin
  for c:=1 to TransGrid.ColumnCount-1 do
    begin
      aCol := TransGrid.Columns[c];
      if aCol.Header='' then
        begin
          aCol.Header := aLang;
          exit;
        end;
    end;
end;


procedure TFormTLangTool.btnClearAllClick(Sender: TObject);
begin
  MessageDlg( 'Clear all?',
             System.UITypes.TMsgDlgType.mtConfirmation,
             [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
                procedure(const AResult: TModalResult)   //non modal msg box for Android
                begin
                  case AResult of
                    mrYes: DoClearAll; // pressed yes, delete it
                    mrNo: ;
                  end;
                end
            );
end;

procedure TFormTLangTool.btnCopyTextsToClipboardClick(Sender: TObject);
var S,aText:String; r:integer;
const crlf=#13#10;
begin
  S:='';
  for r :=0 to TransGrid.RowCount-1 do
  begin
    aText := TransGrid.Cells[0,r];  // col 0 has the originals
    if (aText<>'') then
      S := S+aText+crlf;
  end;
  StringToClipboard(S);
end;

procedure TFormTLangTool.DoClearAll;
var c:integer; aCol:TColumn;
begin
  for c:=1 to TransGrid.ColumnCount-1 do //clear grid headers
    begin
      aCol := TransGrid.Columns[c];
      aCol.Header := '';
    end;

  ClearGrid;  // clear grid cells
  ClearLang1; //
end;

procedure TFormTLangTool.btnLoadLngFileClick(Sender: TObject);
var fn:String;
begin
  if OpenDialog1.Execute then
    begin
      fn := OpenDialog1.FileName;
      Lang1.LoadFromFile(fn);

      populateGridWithLanguages;     //  Lang1 --> Grid
    end;
end;

procedure TFormTLangTool.btnPasteLanguageClick(Sender: TObject);
var S,aText:String; r,c,arow:integer; SL:TStringList;
  i: Integer;
const crlf=#13#10;
begin
  StringFromClipboard(S);
  SL :=  TStringList.Create;
  SL.Text := S;
  c       := TransGrid.ColumnIndex;
  arow    := TransGrid.Selected;
  if (SL.Count>0) then
    begin
      for i := 0 to SL.Count-1 do
         begin
           S := SL.Strings[i];
           TransGrid.Cells[c,arow+i] := S;
         end;
    end;
  SL.Free;
end;

procedure TFormTLangTool.ClearLang1;
begin
  Lang1.Lang := 'en';  //original
  Lang1.Original.Clear;
  // TODO: dispose Resources?
  Lang1.Resources.Clear;
end;

procedure TFormTLangTool.ClearGrid;
var c, r: Integer;
begin
  for c := 0 to Pred(TransGrid.ColumnCount) do
    for r := 0 to Pred(TransGrid.RowCount) do
      TransGrid.Cells[c, r] := '';
end;


procedure TFormTLangTool.copyGridToLang1;  //tricky
var c,r:integer;  aCol:TColumn; aText,aTrans,aLang,S:String; aStrings:TStrings;
begin
  ClearLang1;

  c:=0;  //Originals

  aCol := TransGrid.Columns[0];
  for r :=0 to TransGrid.RowCount-1 do
  begin
    aText := TransGrid.Cells[c,r];
    if (aText<>'') then
      Lang1.Original.Add(aText);     // populate Originals
  end;

  for c:=1 to TransGrid.ColumnCount-1 do
    begin
      aCol := TransGrid.Columns[c];
      aLang := aCol.Header;
      if (aLang<>'') then
        begin
          Lang1.AddLang(aLang);  // this create a stringlist for each lang
          aStrings := Lang1.LangStr[aLang];

          for r:=0 to TransGrid.RowCount-1 do  //for each text..
          begin
            aText  := TransGrid.Cells[0,r];
            if Trim(aText)='' then continue;     //ignore empty original texts

            aTrans := TransGrid.Cells[c,r];  //get translation
            if (aTrans<>'') then            //has tranlation for this text?
              begin
                S := aText+'='+aTrans;      // add name=value line
                aStrings.Add(S);
              end;
          end;
        end;
    end;
end;

procedure TFormTLangTool.btnSaveFileAsClick(Sender: TObject);
var fn:String;
begin
  //
  if (OpenDialog1.Filename<>'') then
     SaveDialog1.Filename := OpenDialog1.Filename;
  if SaveDialog1.Execute then
    begin
      fn := SaveDialog1.Filename;

      copyGridToLang1;

      Lang1.SaveToFile(fn);
    end;
end;

procedure TFormTLangTool.FormCreate(Sender: TObject);
var aLang:String;
begin
  { This defines the default active tab at runtime }
  TabControl1.First(TTabTransition.None);

  aLang := 'pt';  //teste
  if (CompareText( aLang,'en')<>0) then   // en is default
    begin
      LoadLangFromStrings( Lang1.LangStr[aLang] );    // load language from resources, if available
      // LocalizeDialogButtons;
    end;
end;

procedure TFormTLangTool.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) and (TabControl1.TabIndex <> 0) then
  begin
    TabControl1.First;
    Key := 0;
  end;
end;

end.
