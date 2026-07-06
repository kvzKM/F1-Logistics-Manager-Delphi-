unit Staff;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Data.DB,
  Vcl.Grids, Vcl.DBGrids, dm, Vcl.StdCtrls, Vcl.ComCtrls,login,
  Vcl.Imaging.pngimage;

type
  TFStaff = class(TForm)
    SBtnexit: TSpeedButton;
    imgBGStaff: TImage;
    SpbtnTeam: TSpeedButton;
    redstaff: TRichEdit;
    edtName: TEdit;
    edtcontact: TEdit;
    cmbrole: TComboBox;
    spbtnadd: TSpeedButton;
    spbtnedit: TSpeedButton;
    spbtndelete: TSpeedButton;
    ComboBox1: TComboBox;
    imgpanel: TImage;
    procedure sbtnexitClick(Sender: TObject);
    procedure SpbtnTeamClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure spbtnsortClick(Sender: TObject);
    procedure spbtnaddClick(Sender: TObject);
    procedure spbtneditClick(Sender: TObject);
    procedure spbtndeleteClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FStaff: TFStaff;

implementation

{$R *.dfm}

uses homepage;

procedure TFStaff.ComboBox1Change(Sender: TObject);
var
 ssort : string;
begin

 ssort := Inputbox('Sort?','By:','');

 dm.fdm.tblstaff.sort := ssort+' ASC';

 SpbtnTeamClick(self);
end;

procedure TFStaff.FormActivate(Sender: TObject);
begin
 spbtnteamclick(self);
 spbtnteam.visible := false;

 IMGBGstaff.picture.loadfromfile('BG'+objclass.assignname+'.jpg');
end;

procedure TFStaff.sbtnexitClick(Sender: TObject);
begin
 fhomepage.show;
 fstaff.close;
end;

procedure TFStaff.spbtnaddClick(Sender: TObject);
var
iteam : integer;
sname, srole, scontact  : string;
begin

  Iteam := objclass.getteamID;
  sname := edtname.text;
  srole := cmbrole.text;
  scontact := edtcontact.text;

  dm.fdm.tblStaff.insert;
  dm.fdm.tblStaff['Name'] := sname;
  dm.fdm.tblStaff['TeamID'] := iteam;
  dm.fdm.tblStaff['Role'] := Srole;
  dm.fdm.tblStaff['Contact'] := scontact;
  Dm.fdm.tblstaff['StaffID'] := random(1000);

  dm.fdm.tblStaff.post;

 SpbtnTeamClick(self);
end;

procedure TFStaff.spbtndeleteClick(Sender: TObject);
var
sedit : string;
begin
 sedit := inputbox('Who do you want to delete?','Name:','');

   with dm.fdm do
 begin
   if tblstaff.locate('Name', sedit, []) = true then
    begin
     tblstaff.delete;
    end;
 end;
 SpbtnTeamClick(self);
end;

procedure TFStaff.spbtneditClick(Sender: TObject);
var
sedit : string;
begin
 sedit := inputbox('Who do you want to edit?','Name:','');

 with dm.fdm do
 begin
   if tblstaff.locate('Name', sedit, []) = true then
    begin
      tblstaff.edit;
      tblstaff['Name'] := inputbox('So you want to change?', 'Name:', tblstaff['Name']);
      tblstaff['Role'] := inputbox('So you want to change?', 'Name:', tblstaff['Role']);
      tblstaff['Contact'] := inputbox('So you want to change?', 'Name:', tblstaff['Contact']);
      tblstaff.post;
    end
     else
    begin
     showmessage('No record found');
    end;
 end;

 SpbtnTeamClick(self);
end;

procedure TFStaff.spbtnsortClick(Sender: TObject);
var
 ssort : string;
begin

 ssort := Inputbox('Sort?','By:','');

 dm.fdm.tblstaff.sort := ssort+' ASC';

 SpbtnTeamClick(self);
end;

procedure TFStaff.SpbtnTeamClick(Sender: TObject);
begin
 redstaff.clear;

 dm.fdm.tblstaff.first;

 redstaff.lines.add('Name:'+#9+#9+#9+'Role:'+#9+#9+#9+'Contact:');
 redstaff.lines.add('====================================================');

 while not dm.fdm.tblstaff.eof do
   begin
    if (dm.fdm.tblstaff['TeamID'] = objclass.getteamid) then
       begin
         redstaff.lines.add(dm.fdm.tblstaff['Name']+#9+#9+dm.fdm.tblstaff['Role']+#9+#9+dm.fdm.tblstaff['Contact']);
       end;
    dm.fdm.tblstaff.next;
   end;

end;
end.
