program Formula1;

uses
  Vcl.Forms,
  Login in 'Login.pas' {FLogin},
  DM in 'DM.pas' {FDM: TDataModule},
  Homepage in 'Homepage.pas' {FHomepage},
  Management in 'Management.pas' {FManagement},
  Staff in 'Staff.pas' {FStaff},
  Class_All in 'Class_All.pas' {$R *.res},
  Fleet in 'Fleet.pas' {ffleet};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFLogin, FLogin);
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TFHomepage, FHomepage);
  Application.CreateForm(TFManagement, FManagement);
  Application.CreateForm(TFStaff, FStaff);
  Application.CreateForm(Tffleet, ffleet);
  Application.CreateForm(Tffleet, ffleet);
  Application.Run;
end.
