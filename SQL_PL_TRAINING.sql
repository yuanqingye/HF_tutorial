--Here we study PL/SQL systematically
--cursors,functions,stored procedures
/*
Data Definition Language (DDL)

These SQL commands are used for creating, modifying, and dropping the structure of database objects. The commands are CREATE, ALTER, DROP, RENAME, and TRUNCATE.

Data Manipulation Language (DML)

These SQL commands are used for storing, retrieving, modifying, and deleting data. These commands are SELECT, INSERT, UPDATE, and DELETE.

Transaction Control Language (TCL)

These SQL commands are used for managing changes affecting the data. These commands are COMMIT, ROLLBACK, and SAVEPOINT.

Data Control Language (DCL)

These SQL commands are used for providing security to database objects. These commands are GRANT and REVOKE.
*/

/**
DECLARE
Variable declaring
BEGIN
statement execution
EXCEPTION
exception handling
END;
**/

set serveroutput on
declare 
playername varchar2(20);
place varchar2(30);
active number(1) not null :=1;
ranking number(4);
begin
select name into playername from qingye where rownum =1; 
dbms_output.put_line(playername); 
end;
/

set serveroutput on
declare 
playername varchar2(20);
place varchar2(30);
active number(1) not null :=1;
ranking number(4);
begin
select name into playername from qingye where rownum =1; 
dbms_output.put_line(playername); 
declare
description varchar2(20) := ' Great Player';
begin
dbms_output.put_line(playername||description); 
end;
end;

set serveroutput on
declare
num constant number(1):=1;
begin
dbms_output.put_line(num);
end;

select * from member where member_id = 1541162;

set serveroutput on
declare
type recordtype is record
(practice_id number(10),member_id number(10),lastname member.last_name%type,firstname member.first_name%type);
memRecord recordtype;
begin
select member_id,practice_id into memRecord.member_id,memRecord.practice_id from member where member_id = 1541162;
dbms_output.put_line(memRecord.member_id);
end;

select * from pp_user where member_id = 1541162;
select * from encounter;
set serveroutput on
declare
ppuser_record pp_user%rowtype;
encounter_record encounter%rowtype;
begin
select * into ppuser_record from pp_user where pp_userid = 140;
select * into encounter_record from encounter where encounter_id = 14181;
dbms_output.put_line(ppuser_record.email_address);
dbms_output.put_line(encounter_record.encounter_id);
end;

set serveroutput on
declare
member_record member%rowtype;
begin
select * into member_record from member where member_id > 1541162;
if upper(member_record.last_name) = 'SUN'  
then
dbms_output.put_line('name may be correct');
elsif upper(member_record.first_name) = 'WUKONG' 
then
dbms_output.put_line('name may be correct');
else
dbms_output.put_line('name not correct');
end if;
end;

select * from qingye;

set serveroutput on
begin
update qingye set city='Haikou' where city = 'Sanya'; 
if SQL%FOUND then
dbms_output.put_line(SQL%ROWCOUNT);
elsif SQL%NOTFOUND then
dbms_output.put_line('We did not find those rows');
end if;
end;

set serveroutput on
declare 
--tennis_player qingye%rowtype;
cursor tennis_players is select * from qingye;
begin
for tennis_player in tennis_players
loop
if tennis_player.birthdate is not null then
dbms_output.put_line(tennis_player.name);
end if;
end loop;
end;

set serveroutput on
declare 
car qingye%rowtype;
cursor cars is select * from qingye;
begin
if not cars%isopen then 
open cars;
end if;
loop
fetch cars into car;
if car.birthdate is null then
dbms_output.put_line(car.name);
end if;
exit when cars%notfound;
end loop;
close cars;
end;

set serveroutput on
declare
cursor allrecords is select * from qingye;
singlerecord allrecords%rowtype;
begin
if not allrecords%isopen then
open allrecords;
end if;
fetch allrecords into singlerecord;
while allrecords%found
loop
dbms_output.put_line(singlerecord.name);
fetch allrecords into singlerecord;
end loop;
end;

create or replace procedure tobedeletedproc (playerid in number)
is
cursor allrecords is select * from qingye;
singlerecord allrecords%rowtype;
begin
if not allrecords%isopen then
open allrecords;
end if;
fetch allrecords into singlerecord;
while allrecords%found
loop
if singlerecord.id = playerid then
dbms_output.put_line(singlerecord.name);
end if;
fetch allrecords into singlerecord;
end loop;
tobedeletedproc2;
end;

set serveroutput on
execute tobedeletedproc(666666);

create or replace procedure tobedeletedproc2
is
cursor allrecords is select * from qingye;
singlerecord allrecords%rowtype;
begin
if not allrecords%isopen then
open allrecords;
end if;
fetch allrecords into singlerecord;
while allrecords%found
loop
dbms_output.put_line(singlerecord.name);
fetch allrecords into singlerecord;
end loop;
end;

set serveroutput on
execute tobedeletedproc(666666);

desc qingye;

create or replace function getRafaPlace
return varchar2
is
rafaplace varchar2(20);
begin
select city into rafaplace from qingye where id = 666666;
return rafaplace;
end;

drop procedure tobedeletefun;

set serveroutput on
begin
dbms_output.put_line(getrafaplace);
end;
select getrafaplace from dual;

create or replace function populateName(playername out varchar2) return number
is
playerrecord qingye%rowtype;
begin
select * into playerrecord from qingye where id = 666666;
playername := playerrecord.name;
return playerrecord.id;
end;


create or replace function tobedeletefun return varchar2
is
playername varchar(20);
begin
dbms_output.put_line(populateName(playername));
return playername;
end;

set serveroutput on
select tobedeletefun from dual;

set serveroutput on
declare 
playername varchar2(20);
playerrecord qingye%rowtype;
begin
begin
select * into playerrecord from qingye;
exception
when too_many_rows then
dbms_output.put_line('too many rows');
end;
select name into playername from qingye where id = 90;
dbms_output.put_line('executed successfully');
exception
when no_data_found then
dbms_output.put_line('no data found');
end;

set serveroutput on
declare
exception_name exception
pragma
exception_init(exception_name,-2292)
begin
exception
when exception_name then
dbms_output_put_line('unknown exception');
end;
end;

select * from qingye;

set serveroutput on
declare 
phenomenon_exception exception;
cursor playercursor is select * from qingye;
playername varchar2(30);
begin
for player in playercursor
loop
if player.name = 'Rafeal Nadal' then
playername := player.name;
raise phenomenon_exception;
else
dbms_output.put_line('display normal player '||player.name);
end if;
end loop;
exception
when phenomenon_exception then
dbms_output.put_line('This is the phenomenon player'||playername);
end;