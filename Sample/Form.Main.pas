unit Form.Main;

interface

{$SCOPEDENUMS ON}

uses
  System.Types, System.Classes, FGX.Forms, FGX.Forms.Types, FGX.Controls, FGX.Controls.Types, FGX.Layout, 
  FGX.Layout.Types, FGX.Button.Types, FGX.Button, FGX.GraphicControl, FGX.Shape, FGX.Rectangle,
  Android.Api.ActivityAndView, FGX.CardPanel;

type
  TFormMain = class(TfgForm)
    fgButton1: TfgButton;
    fgCardPanel1: TfgCardPanel;
    procedure fgButton1Tap(Sender: TObject);
  private
    { Private declarations }
    procedure OnFinishAnimation;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.xfm}

uses
  System.SysUtils,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log,
  FGX.Animation,
  FGX.Controls.Android,
  FGX.Platform.Android,
  FGX.Helpers.Android,
  FGX.TranslateAnimation;

procedure TFormMain.fgButton1Tap(Sender: TObject);
begin
  TfgTranslateAnimation.Animate(fgCardPanel1, 0, 0, 0, 600, 2000, OnFinishAnimation);
end;

procedure TFormMain.OnFinishAnimation;
begin
  TfgDialogs.ShowMessage('Animation finished');
end;

end.
