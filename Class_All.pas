unit Class_All;

interface
   uses DM, System.SysUtils,fleet;
type
 Tclass = Class
  Private
  FMaintananceID: integer;
  FVehicleID: integer;
  FMDate: Tdate;
  rTeamID  :integer;
  FTeamname : string;
  fjob: string;


  Public

  rVehicleID : array[1..10] of string;
  constructor create(frteamid : integer);
  function getteamID: integer;
  function showbackgrounds: string;
  procedure geteamname(steam: string);
  function assignname: string;
  procedure getjob(sjob:string);



 End;

implementation

function Tclass.assignname: string;
begin
  result := fteamname;
end;

{ TFleet }


constructor Tclass.create(frteamid: integer);
begin
  rTeamID := frteamid;
end;
// This is to get the team name for the background images
procedure Tclass.geteamname(steam: string);
begin
  if steam = 'Mercedes' then
   FTeamname := 'Mercedes'
   else
  if steam = 'Alpine' then
   FTeamname := 'Alpine'
   else
  if steam = 'Red Bull' then
   FTeamname := 'RedBull'
   else
  if steam = 'Racing Bulls' then
   FTeamname := 'Racing'
   else
  if steam = 'Cadillac' then
   FTeamname := 'Cadillac'
   else
  if steam = 'Aston Martin' then
   FTeamname := 'Aston'
   else
  if steam = 'Stake Sauber' then
   FTeamname := 'Stake'
   else
  if steam = 'Williams' then
   FTeamname := 'Williams'
   else
  if steam = 'McLaren' then
   FTeamname := 'McLaren'
   else
  if steam = 'Ferrari' then
   FTeamname := 'Ferrari'
   else
  if steam = 'Haas' then
   FTeamname := 'Haas'
   else
  if steam ='none' then
  Fteamname := 'Transparent'
end;

procedure Tclass.getjob(sjob: string);
begin
 sjob :=  fjob;
end;

function Tclass.getteamID: integer;
begin
   result := rTeamID;
end;

function Tclass.showbackgrounds: string;
begin
 //
end;

end.
