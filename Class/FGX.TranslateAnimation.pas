unit FGX.TranslateAnimation;

interface

uses System.SysUtils,
     FGX.Controls,
     FGX.Types,
     Android.Api.ActivityAndView,
     Java.Bridge;

type
  TTranslateAnimationListener = class(TJavaLocal, JAnimation_AnimationListener)
  protected
    FFinishCallback: TfgCallback;
  public
    constructor Create(const AFinishCallback: TfgCallback);
    destructor Destroy; override;

    {JAnimation_AnimationListener}
    procedure onAnimationEnd(const AArg0: JAnimation);
    procedure onAnimationRepeat(const AArg0: JAnimation);
    procedure onAnimationStart(const AArg0: JAnimation);
  end;

  TfgTranslateAnimation = class
  public
    class procedure Animate(const AControl: TfgControl; const AFromXDelta, AFromYDelta, AToXDelta, AToYDelta: Single;
                            const ADuration: Integer; const AFinishCallback: TfgCallback = nil);
  end;

implementation

uses FGX.Animation,
     FGX.Helpers.Android,
     FGX.Controls.Android,
     FGX.Types.AutoreleasePool,
     Android.Api.Resources;

{ TMyAnimatorListener }

constructor TTranslateAnimationListener.Create(const AFinishCallback: TfgCallback);
begin
  inherited Create;

  FFinishCallback := AFinishCallback;
end;

destructor TTranslateAnimationListener.Destroy;
begin
  FFinishCallback := nil;
  inherited;
end;

procedure TTranslateAnimationListener.onAnimationEnd(const AArg0: JAnimation);
begin
  if Assigned(FFinishCallback) then
    FFinishCallback;
end;

procedure TTranslateAnimationListener.onAnimationRepeat(const AArg0: JAnimation);
begin
end;

procedure TTranslateAnimationListener.onAnimationStart(const AArg0: JAnimation);
begin
end;

{ TfgTranslateAnimator }

class procedure TfgTranslateAnimation.Animate(const AControl: TfgControl; const AFromXDelta, AFromYDelta, AToXDelta,
  AToYDelta: Single; const ADuration: Integer; const AFinishCallback: TfgCallback);
var
  View: JView;
  Listener: TTranslateAnimationListener;
  Animation: JTranslateAnimation;
  Interpolator: JAccelerateDecelerateInterpolator;
  Scale: Single;
begin
  Scale := TfgAndroidHelper.ScreenScale;
  View := AControl.Handle.View;
  Animation := TJTranslateAnimation.Create(AFromXDelta * Scale, AToXDelta * Scale, AFromYDelta * Scale, AToYDelta * Scale);
  if ADuration = PlatformDuration then
    Animation.setDuration(TJResources.getSystem.getInteger(TJR_integer.config_shortAnimTime))
  else
    Animation.setDuration(ADuration);
  Animation.setFillAfter(True);

  Interpolator := TJAccelerateDecelerateInterpolator.Create;

  Listener := TTranslateAnimationListener.Create(
    procedure
    begin
      if Assigned(AFinishCallback) then
        AFinishCallback();

      TfgAutoreleasePool.Release(Listener);
      TfgAutoreleasePool.Release(Interpolator);
      TfgAutoreleasePool.Release(Animation);
    end);

  TfgAutoreleasePool.Store(Listener);
  TfgAutoreleasePool.Store(Interpolator);
  TfgAutoreleasePool.Store(Animation);

  Animation.setInterpolator(TJInterpolator.Wrap(Interpolator));
  Animation.setAnimationListener(TJAnimation_AnimationListener.Wrap(Listener));

  View.startAnimation(Animation);
end;

end.
