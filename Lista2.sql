use music;
#1. Utwórz bazê danych Music. Utwórz u¿ytkownika ’U ’@’localhost’ (lub ’U ’@’%’),
#gdzie U jest twoim imieniem, skonkatenowanym z dwoma ostatnimi cyframi indeksu. 
#Ustaw dla tego u¿ytkownika has³o bêd¹ce twoim numerem indeksu czytanym od ty³u. Nadaj utworzonemu u¿ytkownikowi uprawnienia do Selectowania,
#wstawiania i zmieniania danych w tabeli, jednak nie do tworzenia usuwania i
#modyfikowania tabel.

create database Music;
create user 'wojtek18'@'localhost' identified by '816452';
grant select, insert, update on music.* to 'wojtek18'@'localhost';


drop view

Logowanie:
mysql --user 'wojtek18'@'localhost' --password='816452'

#2. Wewn¹trz utworzonej bazy, utwórz tabele

create table zespol (
	id int auto_increment = 1,
	nazwa varchar(90), 
	liczbaAlbumow int default null,
	primary key(id)
);

create table album (
	tytul varchar(90),
	gatunek varchar(30),
	zespol int,
	primary key(tytul, zespol)
);

create table utwor (
	id int auto_increment = 1,
	tytul varchar(90),
	czas int check (czas >= 0),
	album varchar(90),
	zespol int
	primary key(id),
	foreign key (zespol) references zespol(id),
	foreign key (album) references album(tytul)
);



#3. Korzystaj¹c z bazy danych chinook, uzupe³nij informacje w utworzonych tabelach. Nie importuj danych na temat filmów i seriali.

/* ZESPOL */
create temporary table update_zespol (
	select a.Name, count(tmp.AlbumId)
	from chinook.artist a 
	inner join (select distinct alb.ArtistId, alb.AlbumId 
	from chinook.album alb, chinook.track t
	where t.MediaTypeId <> 3 and 
		alb.AlbumId = t.AlbumId ) as tmp
	on a.ArtistId = tmp.ArtistId
	group by a.Name 
	order by a.ArtistId  
);

insert into zespol(nazwa, liczbaAlbumow)
select * from update_zespol ;

drop temporary table update_zespol;

delete from zespol;
alter table zespol auto_increment = 1;

/* ALBUM */
create temporary table update_album (
	select alb.Title, g.Name gatunek, zespol.id 
	from chinook.album alb, chinook.genre g, chinook.track t, chinook.artist art, zespol
	where t.AlbumId = alb.AlbumId and 
	t.GenreId = g.GenreId and 
	art.ArtistId = alb.ArtistId and 
	t.MediaTypeId <> 3 and 
	art.Name = zespol.nazwa 
	group by alb.AlbumId
);

insert ignore into album 
select * from update_album;

drop temporary table update_album;


/* UTWOR */ 
create temporary table update_utwor (
	select t.Name, floor(t.Milliseconds/1000) , a.tytul, z.id 
	from chinook.track t, chinook.album alb, chinook.artist art, chinook.genre g, zespol z, album a
	where t.AlbumId = alb.AlbumId and 
		alb.ArtistId = art.ArtistId and 
		art.Name = z.nazwa and 
		alb.Title = a.tytul and 
		t.MediaTypeId <> 3
		group by t.TrackId 
);

insert ignore into utwor(tytul, czas, album, zespol)
select * from update_utwor;
 
drop temporary table update_utwor;


#4. Napisz procedurê, która dla ka¿dego artysty podliczy liczbê jego albumów w bazie danych i uzupe³ni odpowiedni¹ kolumnê

delimiter //

create procedure liczbaAlbumow() 
begin 
	update zespol 
	inner join (
		select album.zespol, count(album.tytul) as liczba
		from album
		group by album.zespol) as alb
	on zespol.id = alb.zespol
	set zespol.liczbaAlbumow = alb.liczba;
end //
delimiter ;

call liczbaAlbumow();

drop procedure liczbaAlbumow;


#5. Napisz trigger, który za ka¿dym razem gdy zmieni siê zawartoœæ tabeli album,
#odpowiednio zaktualizuje kolumnê liczbaAlbumow.

delimiter //
create trigger aktualizujLiczbeAlbumowIns after insert on album for each row
begin
	update zespol 
	set liczbaAlbumow = liczbaAlbumow + 1
	where zespol.id = new.zespol;	 
end;		
delimiter ;

delimiter //
create trigger aktualizujLiczbeAlbumowDel before delete on album for each row
begin
	update zespol 
	set liczbaAlbumow = liczbaAlbumow - 1
	where zespol.id = old.zespol;
end;		
delimiter ;

delimiter // 
create trigger aktualizujLiczbeAlbumowUpd after update on album for each row 
begin 
	call liczbaAlbumow(); #zadanie4
end;
delimiter ;

show triggers; 


insert into album 
values ('Takie rzeczy', 'hip hop', 1);

delete from album 
where tytul = 'Takie rzeczy';



drop trigger aktualizujLiczbeAlbumowIns;
drop trigger aktualizujLiczbeAlbumowDel;
drop trigger aktualizujLiczbeAlbumowUpd;

#6. Napisz procedurê, która bêdzie sprawdza³a czy w kolumnie gatunek s¹ jedynie
#gatunki uwzglêdnione w bazie chinook. W przypadku niezgodnoœci, zmieñ typ
#na taki, który w bazie chinook ma najmniejszy GenreId. W wersji rozszerzonej,
#takie sprawdzenie (i ew. korekta) powinno odbywaæ siê za pomoc¹ zapytania do
#bazy chinook.


delimiter //
create procedure checkGenre() 
begin 
	update album
	set gatunek = (select Name from chinook.genre where GenreId = 1)
	where gatunek in (
	select distinct gatunek 
	from album
	except (
	select Name from chinook.genre));		
end //
delimiter ;

call checkGenre();

#7. Napisz procedurê, która jako parametr wejœciowy bêdzie przyjmowa³a liczbê albumów do wygenerowania k, a nastêpnie uzupe³ni wszystkie trzy tabele o odpowiednie informacje. Tytu³y albumów mog¹ byæ losowe, np. Album<liczba>,
#ka¿dy powinien zawieraæ nie mniej ni¿ 6 utworów i nie wiêcej ni¿ 20. Utworzone
#albumy mog¹ byæ przydzielane istniej¹cym ju¿ w bazie zespo³om lub zespo³om
#nowym, jednak nie powinna zachodziæ sytuacja (dla k > 2), gdy wszystkie albumy przydzielane s¹ do tego samego zespo³u ani, ¿e dla ka¿dego albumu tworzymy nowy zespó³.
#Zadbaj o weryfikacjê wartoœci k przed rozpoczêciem generowania. Mo¿esz wykorzystaæ pêtle, ogranicz natomiast korzystanie z dodatkowych plików i jêzyków
#programowania

delimiter //
create procedure generateAlbums(k int)
begin
	drop temporary table if exists usedArtist;
	create temporary table usedArtist (
		id int	
	);
	set @liczba = 0;
	set @song_number = 0;
	while (select count(*) from album where tytul = concat('Album', @liczba)) > 0 do
		set @liczba = @liczba + 1;
	end while;

	if k > 2 then
		insert into zespol(nazwa, liczbaAlbumow)
		values(concat('Zespol', @liczba), 1);
		insert into album
		values (concat('Album',@liczba), (select gatunek from album a order by rand() limit 1), (select id from zespol where nazwa = concat('Zespol', @liczba) limit 1));
		set @songs = (select floor(rand() * 14 + 6));
		set @counter = 0;
		set @song_number = 0;
		while @counter < @songs do
			insert into utwor(tytul, czas, album, zespol)
			values(concat('song',@song_number), (select floor(rand() * 400)), concat('Album', @liczba), (select id from zespol where nazwa = concat('Zespol', @liczba) limit 1));
			set @counter = @counter + 1;
			set @song_number = @song_number + 1;
		end while;
		set k = k - 1;
		set @liczba = @liczba + 1;
	end if; 

	while k > 0 do
		set @zespol = (select floor(rand() * (select max(id) from zespol z)));
		if (@zespol not in (select * from usedArtist)) then
			insert into album
			values(concat('Album', @liczba), (select gatunek from album a order by rand() limit 1), @zespol);
			insert into usedArtist
			values (@zespol);
			update zespol 
			set liczbaAlbumow = liczbaAlbumow + 1
			where id = @zespol;
			set @songs = (select floor(rand() * 14 + 6));
			set @counter = 0;
			while @counter < @songs do
				insert into utwor(tytul, czas, album, zespol)
				values(concat('Song', @song_number), (select floor(rand() * 400)), concat('Album', @liczba), @zespol);
				set @counter = @counter + 1;
				set @song_number = @song_number + 1;
			end while;
			set k = k - 1;
			set @liczba = @liczba + 1;
		end if;
	end while;
	

	drop temporary table if exists usedArtist;

end;
delimiter ;
			
call generateAlbums(2);
drop procedure generateAlbums;

#8. Napisz funkcjê lub procedurê, która dla podanej nazwy zespo³u wypisze tytu³
#najd³u¿szego albumu tego zespo³u.
#W wersji podstawowej zadania – za³ó¿, ¿e nazwa zespo³u zawsze podana jest
#prawid³owo. W wersji rozszerzonej – w razie braku zespo³u, zwróæ informacjê
#o b³êdzie (informacja nie powinna byæ wyœwietlana, jeœli zespó³ istnieje, ale nie
#wyda³ ¿adnego albumu).

delimiter //
create function longestAlbum (zespol1 varchar(120)) returns varchar(90) deterministic
begin 
	if ((select count(*) from zespol where nazwa = zespol1) > 0) then
		set @value = (select tmp.album
		from (
			select u.album album, sum(u.czas) as calosc
			from zespol z, utwor u
			where z.id = u.zespol and
			z.nazwa = zespol1
			group by u.album ) as tmp
		where calosc = (select sum(czas) 
			from utwor, zespol 
			where zespol.id = utwor.zespol and 
			zespol.nazwa = zespol1  
			group by utwor.album 
			order by sum(czas) desc
			limit 1));
			return @value;
	else 
		return 'Brak zespolu';
	end if;
end; //
delimiter ; 

select longestAlbum('AC/DC')
select longestAlbum('Keke')


#9. Napisz widok zawieraj¹cy informacje o nazwie zespo³u, tytu³ach ich albumów
#oraz gatunku tych albumów.


create view widok_zespol as
	select z.nazwa, a.tytul, a.gatunek
	from zespol z, album a
	where z.id = a.zespol;
	
drop view widok_zespol; 

#10. Napisz trigger (lub zmodyfikuj istniej¹ce), który po usuniêciu albumu, usuwa
#z bazy wszystkie utwory z tego albumu. Zadbaj o to, by procedura usuwania
#przebieg³a pomyœlnie, pamiêtaj o kolumnie liczbaAlbumów.

delimiter //
create trigger deleteSongs before delete on album for each row 
begin 
	delete from utwor 
	where utwor.album = old.tytul;
	update zespol 
	set liczbaAlbumow = liczbaAlbumow - 1
	where zespol.id = old.zespol; 
end;
delimiter ;

drop trigger deleteSongs;

show triggers;

insert into utwor(tytul, czas, album, zespol)
values ('tak mocno', 100, 'Takie rzeczy', 1);

#11. Napisz procedurê lub funkcjê, która przyjmowaæ bêdzie podci¹g patt, a nastêpnie
#usunie z bazy danych wszystkie albumy zespo³ów, w których nazwach wystêpuje
#patt. Zadbaj by podany podci¹g nie by³ pusty.
#Zastanów siê jakie niebezpieczeñstwa dla bazy (zarówno zawartych w niej danych,
#jak i struktury) mo¿e mieæ umo¿liwienie u¿ytkownikowi korzystanie z takiej procedury

delimiter // 
create procedure deletePattern(patt varchar(90))
begin 
	if (patt is not null and patt <> ' ') then 
		delete from utwor
		where zespol in (select id from zespol where nazwa like concat('%',patt,'%'));
		delete from album
		where zespol in (select id from zespol where nazwa like concat('%',patt,'%'));
		update zespol 
		set liczbaAlbumow = 0
		where nazwa like concat('%',patt,'%');
	end if;
end //
delimiter ;

drop procedure deletePattern 

insert into zespol(nazwa, liczbaAlbumow)
values ('Kêkê', 1);
insert into album
values ('Takie rzeczy', 'hip hop', 199);
insert into utwor(tytul, czas, album, zespol)
values ('Tak mocno', 100, 'Takie rzeczy', 199);

call deletePattern('Kêk');

#12. Utwórz index dla kolumny gatunek – zastanów siê jaki jest odpowiedni typ indeksu.
#Podaj przyk³ad zapytañ odnosz¹cych siê do tej kolumny, które wykorzystuj¹ indeks oraz takich, które nie mog¹ z niego skorzystaæ.

alter table album add index indx (gatunek);

/*___uzycie indeksu___*/
select * from album where gatunek like 'R%';

/*___brak u¿ycia____*/
select * from album where gatunek = 'Alternative';
select * from album where gatunek like '%tive';

show indexes from album
explain select gatunek from album;

#13. Utwórz widok, który, dla ka¿dego zespo³u, bêdzie zawiera³ informacjê o liczbie
#jego utworów d³u¿szych ni¿ 120s

create view longSongs as (
	select z.nazwa, count(tt.tytul) as 'Liczba utworów'
	from zespol z
	inner join
	(select zespol, tytul 
	from utwor u 
	where czas > 120) as tt
	on z.id = tt.zespol
	group by z.nazwa 
);


drop view longSongs;

#14. Za pomoc¹ konstrukcji PREPARE statement przygotuj zapytanie, które zwraca
#listê wszystkich utworów konkretnego zespo³u, zawartych na albumie o podanym
#gatunku. Nazwa zespo³u oraz nazwa gatunku powinny byæ podane dopiero przy
#wywo³aniu EXECUTE.

set @q = 'select z.nazwa, u.tytul, a.gatunek
	from utwor u, zespol z, album a
	where u.album = a.tytul and
		a.zespol = z.id and
		z.nazwa = ? and
		a.gatunek = ?';
prepare stmt from @q;
set @zespol = 'AC/DC';
set @gatunek = 'Rock';
execute stmt using @zespol, @gatunek;
deallocate prepare stmt;

#15. Za pomoc¹ konstrukcji PREPARE statement przygotuj zapytanie, które najd³u¿szy utwór zamieszczony na albumie o podanym gatunku, który nie przekracza
#thresh sekund. Ograniczenie na d³ugoœæ oraz nazwa gatunku powinny byæ podane
#dopiero przy wywo³aniu EXECUTE.

set @q = 'select tmp.tytul, a.tytul, czas1, gatunek
	from (select utwor.tytul, utwor.album alb, max(czas) czas1
	from utwor
	group by album) as tmp
	inner join album a
	on tmp.alb = a.tytul
	where czas1 <= ? and
	a.gatunek = ?';
prepare stmt from @q;
set @thresh = 300;
set @gatunek = 'Rock';
execute stmt using @thresh, @gatunek;
deallocate prepare stmt;

#16. Korzystaj¹c z DESCRIBE lub SHOW napisz procedurê, która jako parametry wejœciowe bêdzie przyjmowa³a nazwê tabeli t oraz nazwê kolumny k, a nastêpnie
#zwróci ostatni¹ w porz¹dku rosn¹cym wartoœæ w tej tabeli, w podanej kolumnie.
#W wersji podstawowej wykorzystaj instrukcje warunkowe, które sprawdz¹ odpowiednie warunki. W wersji rozszerzonej wykorzystaj wskazane polecenia oraz
#PREPARE statement.

delimiter //
create procedure biggestElement(kolumna  varchar(90), tabela  varchar(90))
begin
	 if ((select count(*) from information_schema.columns where TABLE_NAME = tabela and COLUMN_NAME = kolumna) > 0) then
		 set @t1 =concat('select max(', kolumna, ') as Max from ',tabela );
		 prepare stmt3 from @t1;
		 execute stmt3;
		 deallocate prepare stmt3;
	else
		 select 'niew³aœciwe dane';
	end if;
end // 
delimiter ;

drop procedure biggestElement

set @q = 'call biggestElement(?, ?)';
prepare stmt from @q;
set @kolumna = 'id';
set @tabela = 'zespol';
execute stmt using @kolumna, @tabela;
deallocate prepare stmt;

#zadanie 17 ///////////////////////////////

with recursive stirling (n, k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12) as 
(
	select 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	union all 
	select n+1, 0, n*k1+k0, n*k2+k1, n*k3+k2, n*k4+k3, n*k5+k4, n*k6+k5, n*k7+k6, n*k8+k7, n*k9+k8, n*k10+k9, n*k11+k10, n*k12+k11
	from stirling where n < 13	
)
select * from stirling;
	

delimiter // 
create procedure stirling(my_n int, my_k int)
begin
	with recursive
		cte1(n, k, res) as 
		(
			select 0, 0, 1
			union all
			select n+1, k, n*res
			from cte1
			where n < my_n
			union all 
			select n+1, k+1, res
			from cte1
			where n < my_n
		),
		
		cte2 as 
		(
			select n, k, sum(res) as wynik 
			from cte1
			group by n, k
		)
select wynik from cte2 where n = my_n and k = my_k;
end //
delimiter ;
		
call stirling(3, 2); 


#18. Wykorzystuj¹c CTE oraz rekursjê napisz zapytanie, które dla podanej nieujemnej liczby n oblicz¹ liczbê Bella Bn. SprawdŸ dla jakich n jesteœ w stanie otrzymaæ
#rozwi¹zanie


with recursive bell(n, k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12) as
(
	select 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	union all select n+1, 0, 1*k1+k0, 2*k2+k1, 3*k3+k2, 4*k4+k3, 5*k5+k4, 6*k6+k5, 7*k7+k6, 8*k8+k7, 9*k9+k8, 10*k10+k9, 11*k11+k10, 12*k12+k11
)
select * from bell;



delimiter //
create function factorial(n int)
returns int(11)
begin
declare factorial int;
set factorial = n ;
if n <= 0 then
return 1;
end if;

bucle: loop
set n = n - 1 ;
if n<1 then
leave bucle;
end if;
set factorial = factorial * n ;
end loop bucle;

return factorial;

end//
delimiter ;



#19. SprawdŸ czy wszystkie triggery z listy mog¹ istnieæ w bazie jednoczeœnie. Jeœli
#tak – uzasadnij, jeœli nie – zastanów siê nad powodem.

Trigger po insert w zadaniu 5 mo¿e wspó³dzia³aæ albo z triggerem po delete w zadaniu 5 albo z triggerem z zadania 10.
Triggery po delete w zad. 5 oraz w zad. 10 nie mog¹ wspó³graæ bo oba zmniejszaja kolumnê liczbaAlbumow w tabeli album
i po usuniêciu albumu kolumna liczbaAlbumow jest zmniejszana podwójnie

#20. SprawdŸ, które polecenia mo¿na wykonaæ za pomoc¹ u¿ytkownika utworzonego
#w zadaniu 1.

Mo¿e wykonaæ polecenia w kórych wykorzystywane s¹ insert, update, select.
Nie mo¿e wywo³ywaæ procedur, funkcji, triggerów wykorzystuj¹cych inne mechanizmy.

create view widok as 
select tytul, count(*) suma
from album
group by tytul
having suma = (select count(*) from album group by tytul order by count(*) desc limit 1)

select tytul from widok

select *
from album a
inner join zespol z 
on a.zespol = z.id 











SET @views = NULL;
SELECT GROUP_CONCAT(table_schema, '.', table_name) INTO @views
 FROM information_schema.views 
 WHERE table_schema = @database_name; -- Your DB name here 

SET @views = IFNULL(CONCAT('DROP VIEW ', @views), 'SELECT "No Views"');
PREPARE stmt FROM @views;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;