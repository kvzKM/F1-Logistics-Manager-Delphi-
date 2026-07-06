unit Fleet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
 tffleet = class(TForm)
    SBtnexit: TSpeedButton;
    imgBGFleet: TImage;
    redVehicles: TRichEdit;
    btnMain: TButton;
    btnVehicles: TButton;
    redmain: TRichEdit;
    imgpanel: TImage;
    lblwelcome: TLabel;
    Label1: TLabel;
    procedure sbtnexitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnVehiclesClick(Sender: TObject);
    procedure btnMainClick(Sender: TObject);
  private
    { Private declarations }


  public
    { Public declarations }
   ITeamID : integer;
  end;

var
  FFleet: TFfleet;


implementation


{$R *.dfm}

uses homepage, dm,Class_all,login;

//This shows all the maintenance  logs for the team

procedure Tffleet.btnMainClick(Sender: TObject);
begin
    redmain.lines.add('VehichleID'+#9+'Details');
    redmain.lines.add('--------------------------------');

    Dm.FDM.tblvehicles.Open;
    Dm.FDM.tblvehicles.First;

    Dm.FDM.tblmaintenance.Active := True;
    Dm.FDM.tblmaintenance.Open;
    Dm.FDM.tblmaintenance.First;

    redmain.Clear;


    Dm.FDM.sqlall.SQL.Clear;
    Dm.FDM.sqlall.SQL.Add('SELECT  V.VehicleID, V.TeamID, M.tDetails ' +
                       'FROM tblMaintenance M, tblVehicles V WHERE (M.VehicleID = V.VehicleID) AND ' +
                       ' (V.TeamID = '+inttostr(objclass.getteamID)+')');


    Dm.FDM.sqlall.Open;

    if Dm.FDM.sqlall.RecordCount > 0 then
    begin
      Dm.FDM.sqlall.First;
      while not Dm.FDM.sqlall.Eof do
      begin
        redmain.Lines.Add(Dm.FDM.sqlall.FieldByName('VehicleID').asstring+#9+Dm.FDM.sqlall.FieldByName('tDetails').AsString);
        Dm.FDM.sqlall.Next;
      end;


    end;

end;
//This shows all the current vehicles logs for the team
procedure Tffleet.btnVehiclesClick(Sender: TObject);
begin
  Dm.FDM.tblvehicles.active := true;
 Dm.FDM.tblvehicles.Open;

 redVehicles.clear;

 Dm.FDM.tblvehicles.first;

 redVehicles.lines.Add('Reg Number'+#9+'Capacity'+#9+'Vehicle'+'VehicleID');
 redVehicles.lines.Add('=============================');

 while not Dm.FDM.tblvehicles.eof do
   begin

     if Dm.FDM.tblvehicles['TeamID'] = objclass.getteamID then
        begin

          redVehicles.lines.add(Dm.FDM.tblvehicles['RegistrationNumber']+
                  #9+Dm.FDM.tblvehicles['Capacity']+#9+Dm.FDM.tblvehicles['VehicleType']+#9+Dm.FDM.tblvehicles['VehicleID']);
        end;

     Dm.FDM.tblvehicles.next;
   end;
end;
 //This loads the background
procedure Tffleet.FormActivate(Sender: TObject);
begin
 Redvehicles.clear;
 redmain.clear;


 IMGBGfleet.picture.loadfromfile('BG'+objclass.assignname+'.jpg');
end;

procedure Tffleet.sbtnexitClick(Sender: TObject);
begin
 fhomepage.show;
 ffleet.close;
end;

end.
