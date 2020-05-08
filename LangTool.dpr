program LangTool;

uses
  System.StartUpCopy,
  FMX.Forms,
  fTLangTool in 'fTLangTool.pas' {FormTLangTool};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTLangTool, FormTLangTool);
  Application.Run;
end.
