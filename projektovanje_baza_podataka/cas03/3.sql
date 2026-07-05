create table Kvadrat(
	ID int not null primary key,
	a float check (a > 0) not null
);

insert into Kvadrat
values (1, 3), (2, 4), (3, 6), (4, 2);

create view PovrsinaKvadrata(ID, POVRSINA) as
select ID, a * a
from Kvadrat;

select *
from PovrsinaKvadrata;


-- 1. INSERT:

-- Unesimo ID, i povrsinu novog kvadrata u pogled
insert into PovrsinaKvadrata
values (6, 36);
-- nastaje greska, zasto?

-- Svaki red unutar pogleda PovrsinaKvadrata predstavlja "pogled" na odgovarajuci red iz tabele KVadrat.
-- Red u pogledu (ID = 6, povrsina = 36) treba da predstavlja "pogled" na red (ID = 6, a = 6) iz tabele Kvadrat.
-- Ukoliko zelimo da se u pogledu nadje novi redi, potrebno je da u tabelu unesemo odgovarajuci red,
-- na osnovu kojeg ce se taj novi red prikazati u pogledu -> potrebno je uneti red (6, 6) u Kvadrat kako
-- bi se u pogledu PovrsinaKvadrata nasao red (6, 36).

-- Pomocu obicne insert naredbe je nemoguce uneti novi red u pogled definisan na ovaj nacin jer nije moguce
-- automatski odrediti sta treba da se unese u tabelu Kvadrat tj. SUBP ne zna da treba da izracuna duzinu stranice
-- kvadrata na osnovu povrsine, ali mu mi mozemo pomoci koriscenjem okidaca nad pogledima (INSTEAD OF okidaca).

-- INSTEAD OF okidaci se mogu kreirati samo nad pogledima. Prilikom njihovog kreiranja (u CREATE TRIGGER naredbi),
-- zadaje se i naredba umesto koje ce se on izvrsiti (INSERT, UPDATE ili DELETE). Tada, prilikom poziva neke
-- od te tri naredbe nad datim pogledom, izvrsice se odgovarajuci okidac.

create or replace function kvadrat_povrsina_insert()
returns trigger as $$
begin
    insert into Kvadrat
    values (new.ID, sqrt(new.POVRSINA));
    return new;
end;
$$ language plpgsql;

create trigger unosNovePovrsine
instead of insert on PovrsinaKvadrata
for each row
execute function kvadrat_povrsina_insert();

-- Sada, kada god napisemo naredbu insert nad pogledom PovrsinaKvadrata, umesto nje
-- ce se izrsiti naredbe definisane unutar okidaca nad tim pogledom. U ovom slucaju
-- smo eksplicitno naveli da je u Kvadrat potrebno uneti ID i koren povrsine reda koji zelimo da se nadje u pogledu.

insert into PovrsinaKvadrata
values (6, 36);
-- U pogledu ce se naci red (6, 36), koji je "pogled" na red (6, 6) u tabeli Kvadrat, jer smo unos izvrsili pomocu okidaca.

select *
from Kvadrat;

select *
from PovrsinaKvadrata;


-- 2. UPDATE:

-- Zelimo da kvadratu sa ID-jem 6 koji se nalaze u pogledu uvecamo ID za 1.
-- Posmatrajmo na primer red (6, 36), on je pogled na red (6, 6) u tabeli Kvadrat.
-- Azuriranje ce se izvrsiti tako sto ce se azurirati red u tabeli Kvadrat i postace (7, 6).
-- Kada zelimo da vIDimo povrsine kvadrata, pomocu pogleda, izvrsice se upit kojim je definisan pogled,
-- i u pogledu ce se naci red (7, 36)

update PovrsinaKvadrata
set ID = ID + 1
where ID = 6;

select *
from Kvadrat;

select *
from PovrsinaKvadrata;

-- Sada zelimo da kvadratu sa ID = 2 koji se nalazi u pogledu, uvecamo povrsinu za 20%.
update PovrsinaKvadrata
set POVRSINA = POVRSINA * 1.2
where ID = 2;

-- Ovakva promena se nece izvrsiti.
-- Kao sto smo vec spomenuli, kada azuriramo odgovarajuci red u pogledu,
-- potrebno je na odgovarajuci nacin azurirati red iz tabele,
-- na osnovu koga nastaje red iz pogleda -> ako uvecavamo povrsinu za 20%,
-- zapravo je potrebno odgovarajucem redu iz tabele Kvadrat uvecati duzinu stranice,
-- cijim kvadriranjem ce nastati povrsina koja je 20% veca.
-- SUBP to ne zna sam da uradi, ali mu mozemo pomoci ponovo koriscenjem okIDaca.

create or replace function kvadrat_povrsina_update()
returns trigger as $$
begin
    update Kvadrat
    set a = sqrt(new.POVRSINA)
    where ID = old.ID;
    return new;
end;
$$ language plpgsql;

create trigger azuriranjePovrsine
instead of update on PovrsinaKvadrata
for each row
execute function kvadrat_povrsina_update();

update PovrsinaKvadrata
set POVRSINA = POVRSINA * 1.2
where ID = 2;

select *
from Kvadrat;

select *
from PovrsinaKvadrata;


-- 3. DELETE:

delete from PovrsinaKvadrata
where POVRSINA = 4;
-- izvrsava brisanje, SUBP zna da nadje odgovarajuci red iz tabele Kvadrat

delete from PovrsinaKvadrata
where ID = 2;
-- izvrsava brisanje

delete from PovrsinaKvadrata
where ID = 42;
-- ne izvrsava brisanje, jer u pogledu PovrsinaKvadrata ne postoji ID = 42

select *
from PovrsinaKvadrata;


-- Ciscenje baze
drop trigger azuriranjePovrsine on PovrsinaKvadrata;
drop trigger unosNovePovrsine on PovrsinaKvadrata;
drop view PovrsinaKvadrata;
drop table Kvadrat;
