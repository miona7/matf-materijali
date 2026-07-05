create table Ucenik(
    ID int not null primary key,
	IME varchar(10) not null,
	PREZIME varchar(20) not null,
	PROSEK decimal(3, 2) check(prosek between 1.0 and 5.0)
);

insert into Ucenik
values (1, 'Filip', 'Ogrenjac', 3.0),
       (2, 'Milica', 'Obradovic', 4.8),
       (3, 'Nemanja', 'Rsumovic', 4.2),
       (4, 'Mihaela', 'Filipovic', 4.5);

select *
from Ucenik;

create view ODLICNI_UCENICI(ID, IME, PREZIME) as
select ID, IME, PREZIME
from Ucenik
where PROSEK >= 4.5;

select *
from ODLICNI_UCENICI;


-- Nad pogledima mozemo izvrsiti operacije INSERT, UPDATE i DELETE
-- Nemamo garanciju da ce se ove operacije izvrsiti, jer to zavisi od same definicije pogleda


--1. INSERT:
-- Novi red ce se zapravo preko pogleda unosi u tabelu nad kojim je pogled definisan, ukoliko je to moguce
-- Ukoliko takav red ne zadovoljava uslov unutar upita kojim je definisan pogled, onda se nece nadji u tom pogledu

insert into ODLICNI_UCENICI values (5, 'Petar', 'Petrovic');
-- zapravo se unosi (5, 'Petar', 'Petrovic', null) u tabelu Ucenik

select *
from Ucenik;
-- vidimo da je red unet u tabelu, da li ce biti prikazan u pogledu?

-- Kada god koristimo pogled, upit kojim je definisan pogled se izvrsava iznova
-- Posto je u tabelu Ucenik unet novi ucenik bez informacije o proseku,
-- on nece zadovoljiti uslov da mu je prosek >=4.5, tako da se on kao takav
-- nece naci u pogledu

select *
from ODLICNI_UCENICI;
-- vidimo da se Petar Petrovic ne nalazi medju odlicnim ucenicima

-- Ono sto mozemo da uradimo da bi sprecili ovakvo ponasanje je da definisemo
-- pogled sa CHECK opcijom. Ukoliko zadamo ovakvu opciju, dodavanje (ili azuriranje)
-- podataka kroz pogled bice moguce samo ukoliko ono ne narusava definiciju pogleda
-- U tom slucaju, sintaksa za kreiranje pogleda je:

-- CREATE VIEW naziv_pogleda (nazivi kolona) AS
-- [UPIT]
-- WITH [CASCADED | LOCAL] CHECK OPTION;

-- Razlika izmedju CASCADED i LOCAL CHECK opcije je u tome LOCAL opcija proverava samo
-- definiciju pogleda nad kojim se izvrsava INSERT ili UPDATE, a CASCADE i one poglede
-- nad kojim je taj pogled definisan (pogledi se mogu definisati i nad drugim pogledima)

create view ODLICNI_UCENICI_sa_proverom(ID, IME, PREZIME) as
select ID, IME, PREZIME
from Ucenik
where PROSEK >= 4.5
with local check option;

-- Naredna naredba ne uspeva zbog zadate CHECK opcije:
-- insert into ODLICNI_UCENICI_sa_proverom
-- values (6, 'Mika', 'Mikic');

drop view ODLICNI_UCENICI_sa_proverom;

--2. UPDATE:

-- Posmatramo redove u pogledu, tj. redove koji su rezultat upita koji prikazuje id, ime i prezime odlicnih ucenika
-- Hocemo da promenimo ime odlicnom uceniku sa id = 2. Takav red postoji u pogledu, i on je "pogled" na odredjeni
-- red iz tabele Ucenik. Promena imena se izvrsava nad tim redom iz tabele Ucenik.

update ODLICNI_UCENICI
set IME = 'Milan'
where ID = 2;

-- Hocemo da se uverimo da je promena imena izvrsena. Kad god koristimo pogled, izvrsava se upit kojim je taj
-- pogled definisan. Taj upit se izvrsava nad tabelom Ucenik, unutar koje je izvrsena promena imena uceniku sa id = 2.
-- U rezultatu tog upita (u pogledu) naci se red s promenjenim imenom

select *
from Ucenik;

select *
from ODLICNI_UCENICI;

-- Promenimo prezime odlicnom uceniku sa id = 1...
update ODLICNI_UCENICI
set PREZIME = 'Filipovic'
where ID = 1;

-- Ova promena se nece izvrsiti.
-- Trenutno se u pogledu ne nalazi ni jedan odlican ucenik koji ima id=1, tako da se promena nece izvrsiti,
-- iako ucenik sa id=1 postoji u tabeli Ucenik. Ukoliko bi korisnik na koriscenje imao samo pogled,
-- ali ne i tabelu Ucenik, na ovaj nacin bi mu postavili ogranicenje da moze azurirati samo odlicne ucenike.

--3. DELETE:

-- Zelimo da obrisemo red iz pogleda sa id = 4. U pogledu se nalazi red koji ima id = 4, on predstavlja "pogled"
-- na red koji se cuva u tabeli Ucenik -> brise se red iz tabele Ucenik.
delete from ODLICNI_UCENICI
where ID = 4;

-- Posto je iz tabele Ucenik obrisan red sa id = 4, kada izvrsimo upit koji izlistava odlicne ucenike,
-- ucenik sa id = 4 se nece prikazati u tom pogledu posto ga vise nema u tabeli Ucenik.
select *
from Ucenik;

select *
from ODLICNI_UCENICI;

delete from ODLICNI_UCENICI
where ID = 1;
-- Ovo brisanje se nece izvrsiti.
-- U tabeli Ucenik se nalazi red sa id = 1, ali takav ucenik nije odlican, tako da se on nece naci u
-- pogledu ODLICNI_UCENICI, pa ga ne mozemo obrisati iz pogleda jer nije u njemu.

select *
from Ucenik;
-- vidimo da se ucenik sa id = 1 i dalje nalazi u tabeli Ucenik

select *
from ODLICNI_UCENICI;
-- ali se ne nalazi u pogledu, posto ucenik sa id = 1 nije odlican

-- ciscenje baze
drop view ODLICNI_UCENICI;
drop table Ucenik;
