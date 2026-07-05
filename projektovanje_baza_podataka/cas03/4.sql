create table Kvadrat(
	ID int not null primary key,
	a float check (a > 0) not null
);

create table Trougao(
	ID int not null primary key,
	a float check (a > 0) not null
);

insert into Kvadrat
values (1, 3), (2, 4), (3, 6), (4, 2);

insert into Trougao
values (1, 3), (2, 4), (3, 7), (4, 6);

-- Zelimo da kreiramo pogled Oblici, koji ispisuje ID i duzinu stranice svih kvadrata i trouglova

create view Oblici(ID, a) as
select * from Kvadrat
union all
select * from Trougao;

select *
from Oblici;

-- Probajmo da unesemo novi oblik kroz kreirani pogled
-- insert into Oblici
-- values(5, 10);

-- Kada izaberemo nasumican red iz pogleda Oblici, da li znamo da li je u pitanju Kvadrat ili Trougao? Ne bas.

-- Ukoliko zelimo da unesemo (5,10) u pogled Oblici, SUBP ne zna u koju to tabelu treba zapravo da smesti,
-- da li je to Kvadrat ili Troguao. Zbog toga ce prijaviti gresku i unos novog reda u pogled definisan
-- na ovaj nacin nece biti nemoguc.

-- Recimo da kada unosimo novi red u pogled, zelimo da se taj red posmatra kao da je i Kvadrat i Troguao.
-- Ovako nesto je moguce pomocu okIDaca nad pogledima.

create function oblici_insert()
returns trigger as $$
begin
    insert into Kvadrat
    values (new.ID, new.a);

    insert into Trougao
    values (new.ID, new.a);

    return new;
end;
$$ language plpgsql;

create trigger unosOblika
instead of insert on Oblici
for each row
execute function oblici_insert();

insert into Oblici
values (10, 4);
-- unose se dva reda u pogled, 1 IDe u Kvadrat 1 u Trougao

select *
from Kvadrat;

select *
from Trougao;

select *
from Oblici;

-- Posto je pogled definisan nad vise od jedne tabele, nije moguce izvrsiti ni UPDATE i DELETE naredbe.
-- Da bi omogucili i njih, potrebno je da definisemo nove INSTEAD OF okIDace i za njih.

create function oblici_update()
returns trigger as $$
begin
    update Kvadrat
    set a = new.a, ID = new.ID
    where ID = old.ID;

    update Trougao
    set a = new.a, ID = new.ID
    where ID = old.ID;

    return new;
end;
$$ language plpgsql;

create trigger azuriranjeOblika
instead of update on Oblici
for each row
execute function oblici_update();

update Oblici
set a = a + 10
where ID = 10;

select *
from Kvadrat;

select *
from Trougao;

select *
from Oblici;

create function oblici_delete()
returns trigger as $$
begin
    delete from Kvadrat
    where ID = old.ID;

    delete from Trougao
    where ID = old.ID;

    return old;
end;
$$ language plpgsql;

create trigger brisanjeOblika
instead of delete on Oblici
for each row
execute function oblici_delete();

delete from Oblici
where ID = 10;

select *
from Kvadrat;

select *
from Trougao;

select *
from Oblici;

drop trigger brisanjeOblika on Oblici;
drop trigger azuriranjeOblika on Oblici;
drop trigger unosOblika on Oblici;
drop function oblici_delete();
drop function oblici_update();
drop function oblici_insert();

-- Umesto kreiranja tri razlicita okidaca za svaku od operacija, mozemo kreirati i jedan
-- koji ce se izvrsavati za sve (ili neke) od njih. U funkciji okidaca mozemo proveriti
-- koja operacija je pozvana na osnovu vrednosti tg_op parametra, a operacije umesto kojih
-- ce se okidac izvrsavati se razdvajaju sa veznikom or (instead of insert or update or delete...).

create function oblici_modify()
returns trigger as $$
begin
    if (tg_op = 'INSERT') then
        insert into Kvadrat values (new.ID, new.a);
        insert into Trougao values (new.ID, new.a);
        return new;
    elsif (tg_op = 'UPDATE') then
        update Kvadrat
        set a = new.a, ID = new.ID
        where ID = old.ID;
        update Trougao
        set a = new.a, ID = new.ID
        where ID = old.ID;
        return new;
    elsif (tg_op = 'DELETE') then
        delete from Kvadrat
        where ID = old.ID;
        delete from Trougao
        where ID = old.ID;
        return old;
    end if;
end;
$$ language plpgsql;

create trigger modifikacijeNadOblicima
instead of insert or update or delete on Oblici
for each row
execute function oblici_modify();

insert into Oblici
values (42, 6);

select *
from Oblici;

update Oblici
set a = a + 11
where ID = 42;

select *
from Oblici;

delete from Oblici
where ID = 42;

select *
from Oblici;

drop trigger modifikacijeNadOblicima on Oblici;
drop function oblici_modify();

drop view Oblici;
drop table Kvadrat;
drop table Trougao;
