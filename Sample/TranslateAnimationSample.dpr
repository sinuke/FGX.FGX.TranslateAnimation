program TranslateAnimationSample;

uses
  FGX.Application,
  FGX.Forms,
  Form.Main in 'Form.Main.pas' {FormMain: TfgForm},
  FGX.TranslateAnimation in '..\Class\FGX.TranslateAnimation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
