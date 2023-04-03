unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation,System.Messaging,FMX.Platform;

type
  TfrmMain = class(TForm)
    pnlHeader: TPanel;
    Rectangle1: TRectangle;
    lblMain: TLabel;
    pnlImages: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure DoOrientationChanged(const Sender: TObject; const M: TMessage);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
    FId: Integer;
  public
    { Public declarations }

  end;

var
  frmMain: TfrmMain;


implementation

{$R *.fmx}

//Si hubo un cambio de orientacion
procedure TfrmMain.DoOrientationChanged(const Sender: TObject; const M: TMessage);
var w,h: single;
var s: IFMXScreenService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, s) then begin
  //Calcular la altura o ancho para el panel 1 ya que
  //el panel 2 tiene alineación Client, es decir toma el resto
    h:=pnlImages.Height / 2;
    w:=pnlImages.Width / 2;

    case s.GetScreenOrientation of
      TScreenOrientation.Portrait:
      begin
      //Si la oritentacion es portrait poner panel 1 arriba
        Panel1.Height:=h;
        Panel1.Align:=TAlignLayout.Top;
      end;
      TScreenOrientation.Landscape:
      //Si la orientacion es landscape(horizontal) poner panel 1 a la izquierda
      begin
        Panel1.Width:=w;
        Panel1.Align:=TAlignLayout.Left;
      end;
      //Si la oritancion es inverted landscape poner panel 1
      // a la derecha
      TScreenOrientation.InvertedLandscape:
      begin
        Panel1.Width:=w;
        Panel1.Align:=TAlignLayout.Right;
      end;
      //Orientacion no soportada
      TScreenOrientation.InvertedPortrait:
      begin
        Panel1.Width:=w;
        Panel1.Align:=TAlignLayout.Bottom;
      end;
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Subscribe to TOrientationChangedMessage
FId := TMessageManager.DefaultManager.SubscribeToMessage(TOrientationChangedMessage, DoOrientationChanged);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Unsubscribe the TOrientationChangedMessage
TMessageManager.DefaultManager.Unsubscribe(TOrientationChangedMessage, FId);
end;

end

