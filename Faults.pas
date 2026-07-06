unit Faults;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.GIFImg;

type
  TfFaults = class(TForm)
    IMGBGFaults: TImage;
    redfaults: TRichEdit;
    btnsearch: TButton;
    btnupdate: TButton;
    edtname: TEdit;
    edtjob: TEdit;
    edtteam: TEdit;
    edtpassword: TEdit;
    procedure btnsearchClick(Sender: TObject);
    procedure btnupdateClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure LoadFaultLogs;
    procedure SearchTeamMembers;
    procedure CheckPersonInTeam;
    procedure EditUser(const UserName: string);
  public
    { Public declarations }
  end;

var
  fFaults: TfFaults;

implementation

{$R *.dfm}

procedure TfFaults.LoadFaultLogs;
var
  LogFile: TextFile;
  Line: string;
begin
  redfaults.Clear; // Clear existing content
  AssignFile(LogFile, 'Fault Logs.txt');
  try
    Reset(LogFile);
    while not Eof(LogFile) do
    begin
      ReadLn(LogFile, Line);
      redfaults.Lines.Add(Line); // Add each line to the RichEdit
    end;
  finally
    CloseFile(LogFile);
  end;
end;

procedure TfFaults.SearchTeamMembers;
var
  LogFile: TextFile;
  Line, TeamName: string;
  UserName, Password, Job, Team: string;
  ipos: Integer;
begin
  TeamName := edtteam.Text; // Get the team name from the edit box
  redfaults.Clear; // Clear existing content

  AssignFile(LogFile, 'Logins.txt');
  try
    Reset(LogFile);
    while not Eof(LogFile) do
    begin
      ReadLn(LogFile, Line);
      // Parse the line to extract user details
      ipos := Pos(';', Line);
      UserName := Copy(Line, 1, ipos - 1);
      Delete(Line, 1, ipos);

      ipos := Pos(';', Line);
      Password := Copy(Line, 1, ipos - 1);
      Delete(Line, 1, ipos);

      ipos := Pos(';', Line);
      Team := Copy(Line, 1, ipos - 1);
      Job := Line; // The remaining part is the job

      // Check if the user is in the specified team
      if Team = TeamName then
      begin
        redfaults.Lines.Add(':User   ' + UserName + '; Password: ' + Password + '; Team: ' + Team + '; Job: ' + Job);
      end;
    end;
  finally
    CloseFile(LogFile);
  end;
end;

procedure TfFaults.CheckPersonInTeam;
var
  LogFile: TextFile;
  Line, UserNameToCheck: string;
  UserName, Password, Job, Team: string;
  FoundInTeam: Boolean;
  ipos : integer;
begin
  UserNameToCheck := edtname.Text; // Get the username to check
  FoundInTeam := False;

  // First, check if the user is in the specified team
  AssignFile(LogFile, 'Logins.txt');
  try
    Reset(LogFile);
    while not Eof(LogFile) do
    begin
      ReadLn(LogFile, Line);
      // Parse the line to extract user details
      ipos := Pos(';', Line);
      UserName := Copy(Line, 1, ipos - 1);
      Delete(Line, 1, ipos);

      ipos := Pos(';', Line);
      Password := Copy(Line, 1, ipos - 1);
      Delete(Line, 1, ipos);

      ipos := Pos(';', Line);
      Team := Copy(Line, 1, ipos - 1);
      Job := Line; // The remaining part is the job

      if (UserName = UserNameToCheck) and (Team = edtteam.Text) then
      begin
        FoundInTeam := True;
        Break; // Exit the loop if found
      end;
    end;
  finally
    CloseFile(LogFile);
  end;

  if not FoundInTeam then
  begin
    // Search the entire logins file for the user
    AssignFile(LogFile, 'Logins.txt');
    try
      Reset(LogFile);
      while not Eof(LogFile) do
      begin
        ReadLn(LogFile, Line);
        // Parse the line to extract user details
        ipos := Pos(';', Line);
        UserName := Copy(Line, 1, ipos - 1);
        Delete(Line, 1, ipos);

        ipos := Pos(';', Line);
        Password := Copy(Line, 1, ipos - 1);
        Delete(Line, 1, ipos);

        ipos := Pos(';', Line);
        Team := Copy(Line, 1, ipos - 1);
        Job := Line; // The remaining part is the job

        if UserName = UserNameToCheck then
        begin
          // User found in a different team
          ShowMessage('User  ' + UserNameToCheck + ' found in team: ' + Team + '.');
          EditUser(UserNameToCheck); // Call to edit user details
          Exit; // Exit after finding the user
        end;
      end;
    finally
      CloseFile(LogFile);
    end;

    // If user is not found anywhere
    ShowMessage('User  ' + UserNameToCheck + ' not found in any team.');
    // Optionally, prompt to add them to the logins field
  end;
end;

procedure TfFaults.EditUser(const UserName: string);
begin
  // Implement logic to edit user details
  // You can show a dialog or another form to allow editing
  ShowMessage('Editing details for user: ' + UserName);
  // Here you can implement the logic to update the user details in the file
end;

procedure TfFaults.FormActivate(Sender: TObject);
begin
 // Load the GIF background
  IMGBGFaults.Picture.LoadFromFile('BGLogin.gif');
  if IMGBGFaults.Picture.Graphic is TGIFImage then
  begin
    TGIFImage(IMGBGFaults.Picture.Graphic).Animate := True;
  end;


end;

procedure TfFaults.btnsearchClick(Sender: TObject);
begin
  LoadFaultLogs; // Load fault logs into the RichEdit
  SearchTeamMembers; // Search for team members
end;

procedure TfFaults.btnupdateClick(Sender: TObject);
begin
  CheckPersonInTeam; // Check if the specific person is in the team
end;

end.
