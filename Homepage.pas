unit Homepage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dm, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.StdCtrls,  Management,Staff,fleet, Vcl.Imaging.pngimage;

type
  TFHomepage = class(TForm)
    imgBGHP: TImage;
    SBtnexit: TSpeedButton;
    pnlfleet: TPanel;
    pnlstaff: TPanel;
    pnlmanage: TPanel;
    mraces: TMemo;
    lblfleet: TLabel;
    lblmanagement: TLabel;
    lblStaff: TLabel;
    imgpanel: TImage;
    procedure SBtnexitClick(Sender: TObject);
    procedure pnlfleetClick(Sender: TObject);
    procedure pnlmanageClick(Sender: TObject);
    procedure pnlstaffClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FHomepage: TFHomepage;

implementation

{$R *.dfm}

uses Login;

procedure TFHomepage.FormActivate(Sender: TObject);
begin
 lblfleet.caption := 'Fleet';
 lblfleet.font.size := 26;

 lblStaff.caption := 'Staff';
 lblStaff.font.size := 26;

 lblmanagement.caption := 'Management';
 lblmanagement.font.size := 26;

 IMGBGHP.picture.loadfromfile('BG'+objclass.assignname+'.jpg');


end;

procedure TFHomepage.pnlfleetClick(Sender: TObject);
begin
 ffleet.show;
 fhomepage.hide;
end;

procedure TFHomepage.pnlmanageClick(Sender: TObject);
begin
 fmanagement.show;
 fhomepage.hide;
end;

procedure TFHomepage.pnlstaffClick(Sender: TObject);
begin
 fstaff.show;
 fhomepage.hide;
end;

procedure TFHomepage.SBtnexitClick(Sender: TObject);
begin
 fhomepage.close;
 flogin.show;
end;

end.
