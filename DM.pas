unit DM;

interface

uses
  System.SysUtils, System.Classes, DB, ADODB, Dialogs, Datasnap.DBClient;

type
  TFDM = class(TDataModule)
    F1Connect: TADOConnection;
    tblTeams: TADOTable;
    tblVehicles: TADOTable;
    tblMaintenance: TADOTable;
    DSTeams: TDataSource;
    DSVehicles: TDataSource;
    DSMaintenance: TDataSource;
    tblExpenses: TADOTable;
    tblInventory: TADOTable;
    tblStaff: TADOTable;
    DSExpenses: TDataSource;
    DSInventory: TDataSource;
    DSStaff: TDataSource;
    ClientDataSet1: TClientDataSet;
    SQLall: TADOQuery;

  private
    { Private declarations }
  public
    { Public declarations }
    procedure setpath;
  end;

var
  FDM: TFDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TFDM }


{ TFDM }

procedure TFDM.setpath;
begin
 f1connect.connected := false;
 F1Connect.ConnectionString  := 'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=Formula1.mdb;';
 f1connect.connected := True;


  tblVehicles.connection := F1Connect;
  tblVehicles.tableName := 'tblVehicles';
  tblVehicles.active := True;

  tblteams.connection := F1Connect;
  tblteams.tableName := 'tblTeams';
  tblteams.active := True;

  tblMaintenance.connection := F1Connect;
  tblMaintenance.tableName := 'tblMaintenance';
  tblMaintenance.active := True;

  tblStaff.connection := F1Connect;
  tblStaff.tableName := 'tblStaff';
  tblStaff.active := True;

  tblInventory.connection := F1Connect;
  tblInventory.tableName := 'tblInventory';
  tblInventory.active := True;

  tblExpenses.connection := F1Connect;
  tblExpenses.tableName := 'tblExpenses';
  tblExpenses.active := True;

  SQLall.connection := f1connect;

 end;

end.
