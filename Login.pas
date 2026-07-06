unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DM, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Imaging.jpeg,class_all,fleet, Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage;

type
  TFLogin = class(TForm)
    IMGBGLogin: TImage;
    lblwelcome: TLabel;
    lbledtname: TLabeledEdit;
    lbledtpassword: TLabeledEdit;
    cbteam: TComboBox;
    cbstaff: TComboBox;
    spbtnlogin: TSpeedButton;
    imgpanel: TImage;
    sbtnproblem: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure spbtnloginClick(Sender: TObject);
    procedure sbtnproblemClick(Sender: TObject);
    procedure imgpanelClick(Sender: TObject);
  private
    { Private declarations }
    tfile : textfile;
    flag : Boolean;
    path, sname,spass,steam,sjob : string;
    rname,rpass,rteam,rjob : array[1..500] of String;
  public
    { Public declarations }
    procedure fteamid;
    procedure tjob;
    procedure LoadUniqueJobRoles;
    procedure teamname;
  end;

var
  FLogin: TFLogin;
   objclass : Tclass;
   teamid :integer;
implementation

{$R *.dfm}

uses homepage,  Staff, Management;

 //This one adds all the jobs into the staff combo box


procedure TFLogin.LoadUniqueJobRoles;
var
  tfile: TextFile;
  ipos: Integer;
  sline, sjob: string;
begin
  AssignFile(tfile, 'Logins.txt');
  Reset(tfile);

  try
    while not Eof(tfile) do
    begin
      ReadLn(tfile, sline);

      ipos := LastDelimiter(';', sline);
      if ipos > 0 then
      begin
        sjob := Trim(Copy(sline, ipos + 1, Length(sline) - ipos));
      end
      else
        Continue;

      if cbstaff.Items.IndexOf(sjob) = -1 then
      begin
        cbstaff.Items.Add(sjob);
      end;
    end;
  finally
    CloseFile(tfile);
  end;
end;

 //This one manages the form and how it should look like;

procedure TFLogin.FormActivate(Sender: TObject);
begin
  // Load the GIF background
  IMGBGLogin.Picture.LoadFromFile('BGLogin.gif');
  if IMGBGLogin.Picture.Graphic is TGIFImage then
  begin
    TGIFImage(IMGBGLogin.Picture.Graphic).Animate := True;
  end;

  lblWelcome.Caption := 'Welcome';
  lblWelcome.Font.Color := clblack;
  lblWelcome.Font.Size := 30;

  imgpanel.picture.loadfromfile('Transparent.png');


  // Set edit controls
  lbledtname.EditLabel.Caption := '';
  lbledtname.Text := 'Name';

  lbledtpassword.EditLabel.Caption := '';
  lbledtpassword.Text := 'Password';
  cbteam.Text := 'Team';
  cbstaff.Text := 'Job';

  // Set button font color
  spbtnlogin.Font.Color := clWhite;

  // Assign file for logins
  AssignFile(tfile, 'Logins.txt');

  // Set the path for the data module
  dm.FDM.setpath;

  LoadUniqueJobRoles;
end;


//This gets the teamID and sends it to the class unit to store

procedure TFLogin.fteamid;
begin
 dm.FDM.tblteams.first;

  While not dm.FDM.tblteams.eof do
    begin

       if dm.FDM.tblteams['Tname'] = steam then
           begin
                 teamID := dm.FDM.tblteams['TeamID'];
           end;
       dm.FDM.tblteams.next;
    end;

  dm.FDM.tblteams.Active := False;



end;

//This gets and stores the team name

procedure TFLogin.teamname;
begin
objclass.geteamname(cbteam.text);
end;

// This procedure opens the correct forms for each worker as some are only allowed to open certain forms

procedure TFLogin.tjob;

begin
 if sjob = 'Team Principle' then
 begin
   fhomepage.show;
   flogin.hide;
 end
 else
 if sjob = 'Logistics' then
 begin
   ffleet.show;
   flogin.hide;
 end
  else
 if sjob = 'Warehouse' then
 begin
   fFleet.show;
   flogin.hide;
 end
 else

 if sjob = 'Data Analyst' then
 begin
   fstaff.show;
   flogin.hide;
 end
 else
 begin
   fhomepage.pnlfleet.visible := False;
   fhomepage.pnlstaff.visible := False;
   fhomepage.pnlmanage.visible := False;


   fhomepage.show;
   flogin.hide;
 end;

end;

 // This button uses the textfile to check wether or not the person is login into the correct account


procedure TFLogin.spbtnloginClick(Sender: TObject);
var
  sline, pass, team, job: string;
  ipos, icount, k: integer;
begin
  icount := 0;
  Reset(tfile);
  flag := false;

  while not EOF(tfile) do
  begin
    if icount >= 500 then
    begin
      ShowMessage('Maximum number of accounts reached. Cannot read more.');
      Break; // Exit the loop if the limit is reached
    end;

    Inc(icount);
    ReadLn(tfile, sline);

    ipos := Pos(';', sline);
    rname[icount] := Copy(sline, 1, ipos - 1);
    Delete(sline, 1, ipos);

    ipos := Pos(';', sline);
    rpass[icount] := Copy(sline, 1, ipos - 1);
    Delete(sline, 1, ipos);

    ipos := Pos(';', sline);
    rteam[icount] := Copy(sline, 1, ipos - 1);
    Delete(sline, 1, ipos);

    rjob[icount] := sline;
  end;

  Sname := lbledtname.Text;
  Spass := lbledtpassword.Text;
  Steam := cbteam.Text;
  Sjob := cbstaff.Text;

  k := 1;
  while (flag = false) and (k <= icount) do
  begin
    if sname = rname[k] then
    begin
      flag := true;
      pass := rpass[k];
      team := rteam[k];
      job := rjob[k];
    end;

    Inc(k);
  end;

  if flag then
  begin
    if (spass = pass) and (steam = team) and (sjob = job) then
    begin
      fteamid;
      objclass := Tclass.Create(teamid);
      teamname;
      tjob;
    end;
  end
  else
  begin
    ShowMessage('Login failed. Please check your credentials.');
  end;
end;


//This button will allow users to log any problems they have with their account

procedure TFLogin.sbtnproblemClick(Sender: TObject);
var
  ProblemDescription: string;
  UserName: string;
  Password: string;
  LogFile: TextFile;
begin
  UserName := lbledtname.Text;
  Password := lbledtpassword.Text;

  ProblemDescription := InputBox('Report a Problem', 'Please describe your problem:', '');

  if ProblemDescription <> '' then
  begin

    AssignFile(LogFile, 'Fault Logs.txt');
    try
      if FileExists('Fault Logs.txt') then
        Append(LogFile)
      else
        Rewrite(LogFile);

      WriteLn(LogFile, ':User  ' + UserName + '; Password: ' + Password + '; Problem: ' + ProblemDescription);
    finally
      CloseFile(LogFile);
    end;

    ShowMessage('Your problem has been logged successfully.');
  end
  else
  begin
    ShowMessage('No problem description provided.');
  end;
end;

end.
