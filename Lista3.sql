use music;
#zadanie 1

delimiter //
create procedure zad1(tab varchar(90), nrow varchar(120))
begin 
	if tab = 'album' and nrow like '%|%|%' then 
		set @tytul = (select substring_index(nrow, '|',1));
		set @gatunek = (select substring_index(substring_index(nrow, '|',2), '|', -1));
		set @zespol1 = (select substring_index(nrow,'|',-1));
		set @zespol = cast(@zespol1 as int);
		if (select count(*) from zespol where id = @zespol) > 0 then 
			#insert into album values(@tytul, @gatunek, @zespol);
			set @s1 = 'insert into album values(?, ?, ?)';
			prepare stmt from @s1;
			execute stmt using @tytul, @gatunek, @zespol;
			deallocate prepare stmt; 
		else 
			select 'Nieprawid³owe dane wejœciowe';
		end if;
	elseif tab = 'zespol' and  nrow like '%|%' then
		set @nazwa = (select substring_index(nrow, '|',1));
		set @liczbaAlbumow1 = (select substring_index(substring_index(nrow, '|',2), '|', -1));
		set @liczbaalbumow  = cast(@liczbaalbumow1 as int);
		if @liczbaAlbumow1 = '0' then
			#insert into zespol(nazwa, liczbaAlbumow) values (@nazwa, 0);
			set @s2 = 'insert into zespol(nazwa, liczbaAlbumow) values (?, 0)';
			prepare stmt from @s2;
			execute stmt using @nazwa;
			deallocate prepare stmt; 
		else
			select 'Nieprawid³owe dane wejœciowe';
		end if;
	elseif tab = 'utwor' and nrow like '%|%|%' then 
		set @tytul = (select substring_index(nrow, '|',1));
		set @czas1 = (select substring_index(substring_index(nrow, '|',2), '|', -1));
		set @czas = cast(@czas1 as int);
		set @album = (select substring_index(substring_index(nrow, '|',-2), '|', 1));
		set @zespol1 = (select substring_index(nrow,'|',-1));
		set @zespol = cast(@zespol1 as int);
		if (select count(*) from album where tytul = @album and zespol = @zespol) > 0 and @czas > 0 then 
			#insert into utwor(tytul, czas, album, zespol) values (@tytul, @czas, @album, @zespol);
			set @s3 = 'insert into utwor(tytul, czas, album, zespol) values (?, ?, ?, ?)';
			prepare stmt from @s3;
			execute stmt using @tytul, @czas, @album, @zespol;
			deallocate prepare stmt; 
		else
			select 'Nieprawid³owe dane wejœciowe';
		end if;
	else 
		select 'Nieprawid³owe dane wejœciowe';
	end if;
end
delimiter ;

drop procedure zad1
call zad1('album', '’AAA’,0); DROP TABLE zespol- -|0')
call zad1('utwor', 'tak mocno|120|Balls to the Wall|2');


#zadanie 2

delimiter //
create procedure zad2(agg varchar(90), rel varchar(10))
begin 
	set @s = 'select tytul, czas 
		from utwor
		where(
			case concat(?,?)
			when "min<" then czas < (select min(czas) from utwor)
			when "min>" then czas > (select min(czas) from utwor)
			when "min=" then czas = (select min(czas) from utwor)
			when "min<=" then czas <= (select min(czas) from utwor)
			when "min>=" then czas >= (select min(czas) from utwor)
			when "max<" then czas < (select max(czas) from utwor)
			when "max>" then czas > (select max(czas) from utwor)
			when "max<=" then czas <= (select max(czas) from utwor)
			when "max>=" then czas >= (select max(czas) from utwor)
			when "max="  then czas = (select max(czas) from utwor)
			when "avg>" then czas > (select avg(czas) from utwor)
			when "avg<" then czas < (select avg(czas) from utwor)
			when "avg<=" then czas <= (select avg(czas) from utwor)
			when "avg>=" then czas >= (select avg(czas) from utwor)
			when "avg=" then czas = (select avg(czas) from utwor)
			when "Standart Deviation" then czas < (2*(select std(czas) from utwor) + (select avg(czas) from utwor))
			and czas > ((select avg(czas) from utwor) - 2*(select std(czas) from utwor))
			end)';
		prepare stmt from @s;
		execute stmt using agg, rel;
		#execute stmt using 'avg', '>';
		deallocate prepare stmt;
end
delimiter ;

call zad2('max', '=')
call zad2('Standart Deviation', '');
drop procedure zad2


#zadanie 3

create table muzycy(
	id int auto_increment,
	imie varchar(70),
	nazwisko varchar(90),
	zespol int,
	gaza int check (gaza >= 0),
	primary key(id),
	foreign key(zespol) references zespol(id)
);

delimiter //
create procedure insercik()
begin
	set @zespoly = (select count(*) from zespol);
	set @counter = 1;
	while @counter <= @zespoly do
		set @num = (select floor(rand()*4 + 3));
		while @num > 0 do
			set @imie = concat('zespolId-',(select id from zespol where id = @counter), '-imie-', @num);
			set @nazwisko = concat('zespolId-',(select id from zespol where id = @counter), '-nazwisko-', @num);
			set @gaza = (select floor(rand()*2500 + 1500));
			insert into muzycy(imie, nazwisko, zespol, gaza) values (@imie, @nazwisko, @counter, @gaza);
			set @num = @num - 1;
		end while;
		set @counter = @counter + 1;
	end while;
end
delimiter ;

call insercik();
drop procedure insercik


#zadanie 4


create table hasla(
	idMuzyka int,
	haslo varchar(90),
	foreign key (idmuzyka) references muzycy(id)
);

delimiter //
create procedure generuj_hasla()
begin
	set @counter = 1;
	while @counter <= (select max(id) from muzycy) do 
		insert into hasla(idMuzyka, haslo)
		values (@counter, md5(concat('nazwisko', @counter)));
		set @counter = @counter + 1;
	end while;
end
delimiter ;

call generuj_hasla();



delimiter //
create procedure sprawdz_poprawnosc(imie varchar(90), haslo varchar(90))
begin
	set @hash = (select md5(haslo));
	if (select count(*) from zespol z, muzycy m, hasla h
		where z.id = m.zespol and
		m.id = h.idMuzyka and
		h.haslo = @hash and
		m.imie = imie) > 0 then 
			select z.nazwa from zespol z, muzycy m, hasla h
			where z.id = m.zespol and
			m.id = h.idMuzyka and
			h.haslo = @hash and
			m.imie = imie;
	else 
		select nazwa 
		from zespol
		order by rand()
		limit 1;
	end if;
end
delimiter ;

call sprawdz_poprawnosc('zespolId-1-imie-4', 'nazwisko1'); 
call sprawdz_poprawnosc('zespolId-1-imie-4', 'terminator'); 


#zadanie 5

delimiter //
create function daj_gaze(nazwa_zespolu varchar(90)) returns varchar(80) deterministic
begin
	declare placa int;
	declare koniec smallint unsigned;
	declare k1 cursor for select muzycy.gaza
	from muzycy, zespol
	where zespol.id = muzycy.zespol and 
		zespol.nazwa = nazwa_zespolu;
	declare continue handler for not found
		set koniec = 1;
	open k1;
	set @wynik = '';
	pêtla : loop
		fetch k1 into placa;
		set @wynik = concat(@wynik, placa, ', '); 
		if koniec = 1 then
			leave pêtla;
		end if;
	end loop pêtla;
	close k1;
	return @wynik;
end
delimiter ;

select daj_gaze('AC/DC');

drop function daj_gaze


#zadanie 6 

delimiter //
create procedure rozliczenie(nazwa_zespolu varchar(90), kasa int)
begin 
	declare placa int;
	declare koniec smallint unsigned;
	declare k1 cursor for select gaza from muzycy where zespol = @zespol;
	declare continue handler for not found
		set koniec = 1;
	set @kasa = kasa;
	set @zespol = (select id from zespol where nazwa = nazwa_zespolu);
	start transaction;
		open k1;
		pêtla : loop 
			fetch k1 into placa;
			set @kasa = @kasa - placa;
			if @kasa < 0 then 
				select 'Za ma³o pieniêdzy';
				leave pêtla;
			end if;
			if koniec = 1 then 
				select concat('Uda³o siê wyp³aciæ. Zosta³o ', @kasa, 'pieniêdzy');
				leave pêtla;
			end if;
		end loop pêtla;
	commit;
			
	
end
delimiter ;

call rozliczenie('AC/DC', 15000);




#zadanie 7

#W miejscu w którym chcemy stworzyæ back-up
mysqldump -h 127.0.0.1 -P 3306 -u root -p music > backup1.sql
#usuwamy bazê danych
drop database music;
#przywracamy dane z kopii zapasowej
create database music;
mysql -h 127.0.0.1 -P 3306 -u root -p music1 < backup.sql






















