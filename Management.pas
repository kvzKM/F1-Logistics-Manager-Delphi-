unit Management;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TFManagement = class(TForm)
    imgBGManage: TImage;
    redmanage: TRichEdit;
    btnreport: TButton;
    SpeedButton1: TSpeedButton;
    btnstaff: TButton;
    btnInv: TButton;
    btnmain: TButton;
    imgpanel: TImage;
    procedure FormActivate(Sender: TObject);
    procedure btnreportClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnstaffClick(Sender: TObject);
    procedure btnInvClick(Sender: TObject);
    procedure btnmainClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FManagement: TFManagement;

implementation

{$R *.dfm}

uses homepage, dm, class_all, login;

procedure TFManagement.btnmainClick(Sender: TObject);
var
  FirstRecord: Boolean;
  GroupTotal: Double;
begin
  redmanage.Lines.Clear;

  // Query for maintenance-related expenses
  Dm.FDM.sqlall.SQL.Clear;
  Dm.FDM.sqlall.SQL.Add('SELECT M.MaintenanceID, M.VehicleID, M.tDetails, M.MaintenanceDate, E.Payment, E.Description ' +
                        'FROM tblExpenses E ' +
                        'INNER JOIN tblMaintenance M ON E.IDNR = M.MaintenanceID ' +
                        'WHERE (E.Description LIKE ''%Maintenance%'' OR E.Description LIKE ''%Repair%'' OR E.Description LIKE ''%Service%'') ' +
                        'ORDER BY M.MaintenanceDate DESC, M.VehicleID');

  Dm.FDM.sqlall.Open;

  if Dm.FDM.sqlall.RecordCount > 0 then
  begin
    redmanage.Lines.Add('MAINTENANCE EXPENSES');
    redmanage.Lines.Add('====================');
    redmanage.Lines.Add('');

    Dm.FDM.sqlall.First;
    FirstRecord := True;
    GroupTotal := 0;

    while not Dm.FDM.sqlall.Eof do
    begin
      // Add individual maintenance expense record
      redmanage.Lines.Add('  Vehicle: ' + Dm.FDM.sqlall.FieldByName('VehicleID').AsString + #9 +
                         'Date: ' + FormatDateTime('yyyy-mm-dd', Dm.FDM.sqlall.FieldByName('MaintenanceDate').AsDateTime) + #9 +
                         'Cost: R' + FormatFloat('0.00', Dm.FDM.sqlall.FieldByName('Payment').AsFloat));

      // Add maintenance details (if available)
      if Dm.FDM.sqlall.FieldByName('tDetails').AsString <> '' then
      begin
        redmanage.Lines.Add('  Details: ' + Dm.FDM.sqlall.FieldByName('tDetails').AsString);
      end;

      // Add separator line between records
      redmanage.Lines.Add('  --------------------------');

      // Accumulate total expenses
      GroupTotal := GroupTotal + Dm.FDM.sqlall.FieldByName('Payment').AsFloat;

      Dm.FDM.sqlall.Next;
    end;

    // Remove the last separator line if we added records
    if Dm.FDM.sqlall.RecordCount > 0 then
    begin
      redmanage.Lines.Delete(redmanage.Lines.Count - 1); // Remove the last separator
    end;

    // Add summary
    redmanage.Lines.Add('');
    redmanage.Lines.Add('==========================================');
    redmanage.Lines.Add('TOTAL MAINTENANCE EXPENSES: R' + FormatFloat('0.00', GroupTotal));
    redmanage.Lines.Add('TOTAL MAINTENANCE RECORDS: ' + IntToStr(Dm.FDM.sqlall.RecordCount));
    redmanage.Lines.Add('DATE: ' + FormatDateTime('yyyy-mm-dd', Now));
  end
  else
  begin
    redmanage.Lines.Add('No maintenance expense records found.');
    redmanage.Lines.Add('(Make sure expenses have ''Maintenance'', ''Repair'', or ''Service'' in Description field)');
  end;
end;

procedure TFManagement.btnreportClick(Sender: TObject);
var
  CurrentDescription: string;
  FirstRecord: Boolean;
  GroupTotal: Double;
 begin
  Dm.FDM.tblVehicles.Open;
  Dm.FDM.tblVehicles.First;

  Dm.FDM.tblexpenses.Open;
  Dm.FDM.tblexpenses.First;

  Dm.FDM.tblinventory.Active := True;
  Dm.FDM.tblinventory.Open;
  Dm.FDM.tblinventory.First;

  redmanage.Lines.Clear;

  Dm.FDM.sqlall.SQL.Clear;
  Dm.FDM.sqlall.SQL.Add('SELECT E.IDNR, E.Description, E.Payment, I.ItemID, I.TeamID, I.ItemName ' +
                        'FROM tblExpenses E, tblInventory I ' +
                        'WHERE (E.IDNR = I.ItemID) AND (I.TeamID = ' + IntToStr(objclass.getteamID) + ') ' +
                        'ORDER BY E.Description, E.IDNR');

  Dm.FDM.sqlall.Open;

  if Dm.FDM.sqlall.RecordCount > 0 then
  begin
    redmanage.Lines.Add('INDIVIDUAL EXPENSE RECORDS');
    redmanage.Lines.Add('==========================');
    redmanage.Lines.Add('');

    Dm.FDM.sqlall.First;
    CurrentDescription := '';
    FirstRecord := True;

    while not Dm.FDM.sqlall.Eof do
    begin
      if CurrentDescription <> Dm.FDM.sqlall.FieldByName('Description').AsString then
      begin
        if not FirstRecord then
        begin
          redmanage.Lines.Add('--------------------------');
        end;

        CurrentDescription := Dm.FDM.sqlall.FieldByName('Description').AsString;
        FirstRecord := False;
      end;

      redmanage.Lines.Add(Dm.FDM.sqlall.FieldByName('Description').AsString + #9 +
                         Dm.FDM.sqlall.FieldByName('Payment').AsString + #9 +
                         '(ID: ' + Dm.FDM.sqlall.FieldByName('IDNR').AsString + ')');

      Dm.FDM.sqlall.Next;
    end;

    redmanage.Lines.Add('');
    redmanage.Lines.Add('==========================================');
    redmanage.Lines.Add('');

    Dm.FDM.sqlall.Close;
    Dm.FDM.sqlall.SQL.Clear;
    Dm.FDM.sqlall.SQL.Add('SELECT E.Description, SUM(E.Payment) AS TotalPayment, COUNT(*) AS RecordCount ' +
                          'FROM tblExpenses E ' +
                          'INNER JOIN tblInventory I ON E.IDNR = I.ItemID ' +
                          'WHERE I.TeamID = ' + IntToStr(objclass.getteamID) + ' ' +
                          'GROUP BY E.Description ' +
                          'ORDER BY E.Description');

    Dm.FDM.sqlall.Open;


    redmanage.Lines.Add('EXPENSE SUMMARY BY DESCRIPTION');
    redmanage.Lines.Add('===============================');
    redmanage.Lines.Add('');

    if Dm.FDM.sqlall.RecordCount > 0 then
    begin
      Dm.FDM.sqlall.First;
      GroupTotal := 0;

      while not Dm.FDM.sqlall.Eof do
      begin

        redmanage.Lines.Add(Dm.FDM.sqlall.FieldByName('Description').AsString + #9 +
                           'Total: R' + FormatFloat('0.00', Dm.FDM.sqlall.FieldByName('TotalPayment').AsFloat) + #9 +
                           'Records: ' + Dm.FDM.sqlall.FieldByName('RecordCount').AsString);

        GroupTotal := GroupTotal + Dm.FDM.sqlall.FieldByName('TotalPayment').AsFloat;
        Dm.FDM.sqlall.Next;
      end;


      redmanage.Lines.Add('------------------------------');
      redmanage.Lines.Add('GRAND TOTAL: R' + FormatFloat('0.00', GroupTotal));
      redmanage.Lines.Add('TOTAL RECORDS: ' + IntToStr(Dm.FDM.sqlall.RecordCount));
    end;
  end
  else
  begin
    redmanage.Lines.Add('No expense records found for this team.');
  end;
end;

procedure TFManagement.btnstaffClick(Sender: TObject);
var
  CurrentRole: string;
  FirstRecord: Boolean;
  GroupTotal: Double;
  RoleTotal: Double;
begin
  redmanage.Lines.Clear;

  // Correct SQL query to join expenses and staff tables properly
  // Filter only for salary-related expenses
  Dm.FDM.sqlall.SQL.Clear;
  Dm.FDM.sqlall.SQL.Add('SELECT S.StaffID, S.Name, S.Role, E.Payment, E.Description ' +
                        'FROM tblExpenses E ' +
                        'INNER JOIN tblStaff S ON E.IDNR = S.StaffID ' +
                        'WHERE S.TeamID = ' + IntToStr(objclass.getteamID) + ' ' +
                        'AND (E.Description LIKE ''%Salary%'' OR E.Description LIKE ''%Salaries%'') ' +
                        'ORDER BY S.Role, S.Name');

  Dm.FDM.sqlall.Open;

  if Dm.FDM.sqlall.RecordCount > 0 then
  begin
    redmanage.Lines.Add('SALARY PAYMENTS');
    redmanage.Lines.Add('===============');
    redmanage.Lines.Add('');

    Dm.FDM.sqlall.First;
    CurrentRole := '';
    FirstRecord := True;
    GroupTotal := 0;
    RoleTotal := 0;

    while not Dm.FDM.sqlall.Eof do
    begin
      // Check if we're starting a new role group
      if CurrentRole <> Dm.FDM.sqlall.FieldByName('Role').AsString then
      begin
        // Add subtotal for previous role group (if not first record)
        if not FirstRecord then
        begin
          redmanage.Lines.Add('  Subtotal for ' + CurrentRole + ': R' + FormatFloat('0.00', RoleTotal));
          redmanage.Lines.Add('--------------------------');
          RoleTotal := 0; // Reset role total for new group
        end;

        CurrentRole := Dm.FDM.sqlall.FieldByName('Role').AsString;
        redmanage.Lines.Add('ROLE: ' + CurrentRole);
        redmanage.Lines.Add('--------------------------');
        FirstRecord := False;
      end;

      // Add individual staff salary record
      redmanage.Lines.Add('  ' + Dm.FDM.sqlall.FieldByName('Name').AsString + #9 +
                         'R' + FormatFloat('0.00', Dm.FDM.sqlall.FieldByName('Payment').AsFloat));

      // Accumulate totals
      RoleTotal := RoleTotal + Dm.FDM.sqlall.FieldByName('Payment').AsFloat;
      GroupTotal := GroupTotal + Dm.FDM.sqlall.FieldByName('Payment').AsFloat;

      Dm.FDM.sqlall.Next;
    end;

    // Add final role subtotal
    if not FirstRecord then
    begin
      redmanage.Lines.Add('  Subtotal for ' + CurrentRole + ': R' + FormatFloat('0.00', RoleTotal));
    end;

    // Add summary
    redmanage.Lines.Add('');
    redmanage.Lines.Add('==========================================');
    redmanage.Lines.Add('TOTAL SALARY PAYMENTS: R' + FormatFloat('0.00', GroupTotal));
    redmanage.Lines.Add('TOTAL EMPLOYEES PAID: ' + IntToStr(Dm.FDM.sqlall.RecordCount));
    redmanage.Lines.Add('DATE: ' + FormatDateTime('yyyy-mm-dd', Now));
  end
  else
  begin
    redmanage.Lines.Add('No salary payment records found for this team.');
    redmanage.Lines.Add('(Make sure expenses have ''Salary'' or ''Salaries'' in Description field)');
  end;
end;

procedure TFManagement.btninvClick(Sender: TObject);
var
  FirstRecord: Boolean;
  GroupTotal: Double;
begin
  redmanage.Lines.Clear;

  // Query for inventory-related expenses
  Dm.FDM.sqlall.SQL.Clear;
  Dm.FDM.sqlall.SQL.Add('SELECT I.ItemID, I.ItemName, I.Quantity, E.Payment, E.Description ' +
                        'FROM tblExpenses E ' +
                        'INNER JOIN tblInventory I ON E.IDNR = I.ItemID ' +
                        'WHERE I.TeamID = ' + IntToStr(objclass.getteamID) + ' ' +
                        'AND (E.Description LIKE ''%Inventory%'' OR E.Description LIKE ''%Stock%'' OR E.Description LIKE ''%Supply%'') ' +
                        'ORDER BY I.ItemName');

  Dm.FDM.sqlall.Open;

  if Dm.FDM.sqlall.RecordCount > 0 then
  begin
    redmanage.Lines.Add('INVENTORY EXPENSES');
    redmanage.Lines.Add('==================');
    redmanage.Lines.Add('');

    Dm.FDM.sqlall.First;
    FirstRecord := True;
    GroupTotal := 0;

    while not Dm.FDM.sqlall.Eof do
    begin
      // Add individual inventory expense record
      redmanage.Lines.Add('  ' + Dm.FDM.sqlall.FieldByName('ItemName').AsString + #9 +
                         'Qty: ' + Dm.FDM.sqlall.FieldByName('Quantity').AsString + #9 +
                         'Cost: R' + FormatFloat('0.00', Dm.FDM.sqlall.FieldByName('Payment').AsFloat) + #9 +
                         'Per Item: R' + FormatFloat('0.00', Dm.FDM.sqlall.FieldByName('Payment').AsFloat /
                         Dm.FDM.sqlall.FieldByName('Quantity').AsFloat));

      // Accumulate total expenses
      GroupTotal := GroupTotal + Dm.FDM.sqlall.FieldByName('Payment').AsFloat;

      Dm.FDM.sqlall.Next;
    end;

    // Add summary
    redmanage.Lines.Add('');
    redmanage.Lines.Add('==========================================');
    redmanage.Lines.Add('TOTAL INVENTORY EXPENSES: R' + FormatFloat('0.00', GroupTotal));
    redmanage.Lines.Add('TOTAL ITEMS PURCHASED: ' + IntToStr(Dm.FDM.sqlall.RecordCount));
    redmanage.Lines.Add('DATE: ' + FormatDateTime('yyyy-mm-dd', Now));
  end
  else
  begin
    redmanage.Lines.Add('No inventory expense records found for this team.');
    redmanage.Lines.Add('(Make sure expenses have ''Inventory'', ''Stock'', or ''Supply'' in Description field)');
  end;
end;

procedure TFManagement.FormActivate(Sender: TObject);
begin
    redmanage.clear;
    IMGBGmanage.picture.loadfromfile('BG'+objclass.assignname+'.jpg');
end;

procedure TFManagement.SpeedButton1Click(Sender: TObject);
begin
 fhomepage.show;
 fmanagement.close;
end;

end.
