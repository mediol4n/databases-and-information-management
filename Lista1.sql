use chinook;

# 1. Wypisz wszystkie znajduj�ce si� w bazie tabele

show tables;

#2. Sprawd� schemat (liczb�, nazw� i typ kolumn) tabeli track.

describe track;

#3. Dla ka�dego zespo�u wypisz wszystkie pary (nazwa zespo�u, tytu� albumu).

select Title as "Album title", Name as "Artist"
from album inner join artist 
on album.ArtistId = artist.ArtistId 

#4. Wypisz wszystkie albumy �Various Artists�.

select Title 
from album inner join artist 
on album.ArtistId = artist.ArtistId 
where Name = "Various Artists";

#5. Wypisz wszystkie pliki audio trwaj�ce powy�ej 250 000 milisekund.

select * 
from track 
where Milliseconds > 250000;

#6. Wypisz wszystkie utwory trwaj�ce pomi�dzy 152 000 ms a 2 583 000 ms.

select *
from track
where Milliseconds between 152000 and 2583000
order by Milliseconds;

#7. Wypisz zawarto�� playlisty 90�s Music. Schemat wyj�ciowy powinien zawiera� jedynie nazw� utworu, nazw� albumu, nazw� zespo�u oraz rodzaj muzyki.

select t.Name as "Track name", album.Title as "Album Title", artist.Name as "Artist", g.Name as "Genre"
from playlisttrack pt, album, artist, genre g, playlist p, track t
where 
	pt.PlaylistId = p.PlaylistId  and
	t.TrackId = pt.TrackId and
	t.AlbumId = album.AlbumId and 
	album.ArtistId = artist.ArtistId and 
	g.GenreId = t.GenreId and
	p.Name = "90�s Music"; 

#8. Z tabeli customer wybierz imiona i nazwiska wszystkich klient�w z Niemiec.

select FirstName, LastName 
from customer
where Country = "Germany";

#9. Wypisz miasta oraz kraje, w kt�rych mieszkaj� klienci o znanym kodzie pocztowym.

select distinct Country, City 
from customer 
where PostalCode is not null;

#10. Dla ka�dego artysty wypisz liczb� oferowanych przez sklep album�w. Dane wynikowe powinny mie� format (nazwa zespo�u, liczba album�w).

select artist.Name, count(album.AlbumId) "Liczba album�w"
from album 
inner join artist 
on album.ArtistId = artist.ArtistId
group by artist.ArtistId;

#11. Na podstawie wystawionych faktur, znajd� miasto, z kt�rego ��cznie zam�wiono najdro�sze produkty

select BillingCity, sum(Total) "Suma koszt�w"
from invoice
group by BillingCity 
order by sum(Total) desc
limit 1;

#12. Na podstawie wystawionych faktur, wypisz dla ka�dego kraju warto�� �redniej wystawionej faktury.

select BillingCountry, avg(Total) "�redni koszt"
from invoice 
group by BillingCountry;


#13. Na podstawie tabel customer i employee, wypisz tych pracownik�w, kt�rzy nie odpowiadaj� aktualnie za obs�ug� klient�w.

select *
from employee
except (select distinct e.* 
	from employee e 
	inner join customer c
	on e.EmployeeId = c.SupportRepId);

#14. Wypisz wszystkich pracownik�w, kt�rzy nie obs�uguj� �adnego klienta ze swojego miasta.

select *
from employee
except (select distinct e.*
	from employee e
	inner join customer c 
	on e.City = c.City
	and e.EmployeeId = c.SupportRepId);

#15. Na podstawie tabel track, artist oraz album, wy�wietl informacje o najdro�szych albumach. 
#Schemat wynikowy powinien zawiera� nazw� zespo�u, tytu� albumu, liczb� utwor�w oraz ��czn� cen�.

select artist.Name "Artist", album.Title "Album", count(track.TrackId) "Liczba utwor�w", sum(track.UnitPrice) "Cena za album"
from album 
	inner join artist on album.ArtistId = artist.ArtistId 
	inner join track on album.AlbumId = track.AlbumId 
group by album.AlbumId
order by sum(track.UnitPrice) desc;

#16. Wy�wietl wszystkie oferowane produkty nale��ce do Sci Fi & Fantasy lub Science Fiction. Wy�wietlane dane powinny zawiera� tytu� oraz cen�.

select t.Name, t.UnitPrice 
from track t 
inner join genre g 
on g.GenreId = t.GenreId
where g.Name = "Science Fiction" or g.Name = "Sci Fi & Fantasy";

#17. Zbadaj, kt�ry zesp� ma na swoim koncie najwi�cej utwor�w Metalowych i Heavy Metalowych (��cznie). Wy�wietl nazw� zespo�u oraz liczb� utwor�w.

select artist.Name, count(t.TrackId)
from track t, artist, album, genre g  
where t.AlbumId = album.AlbumId and 
	album.ArtistId = artist.ArtistId and
	t.GenreId = g.GenreId and 
	(g.Name = "Heavy Metal" or g.Name = "Metal")
group by artist.ArtistId;  


select artist.Name, count(t.TrackId) as "Number of tracks"
from track t
	inner join album on album.AlbumId = t.AlbumId 
	inner join artist on album.ArtistId = artist.ArtistId 
	inner join genre g on g.GenreId = t.GenreId 
where g.Name="Heavy Metal" or g.Name="Metal"
group by artist.ArtistId
order by count(t.TrackId) desc
limit 1;

#18. Wy�wietl wszystkie oferowane odcinki Battlestar Galactica, uwzgl�dnij wszystkie sezony.

select *
from track 
where Name like "%Battlestar Galactica%";

#19. Wy�wietl nazwy artyst�w oraz tytu�y album�w, dla przypadk�w kiedy ten sam tytu� nadany zosta� przez dwa r�ne zespo�y. (Uwaga: Je�li wyst�puje para
#(X, Y ), to wynik nie powinien zawiera� pary (Y, X)).

select  art1.Name "Artysta 1", art2.Name "Artysta 2", a1.Title "Tytu�" 
from album a1, album a2, artist art1, artist art2
where a1.Title = a2.Title and 
		a1.ArtistId < a2.ArtistId and 
		a1.ArtistId = art1.ArtistId and 
		a2.ArtistId = art2.ArtistId;


#20. Wy�wietl wszystkie utwory, kt�re nagra� Santana, niezale�nie od tego, kto mu w danym utworze towarzyszy�.

select *
from track 
where Composer like "%Santana%";

#21. Uszereguj wszystkich wykonawc�w malej�co wzgl�dem �redniego czasu trwania ich utworu rockowego. Nie uwzgl�dniaj artyst�w, kt�rzy nagrali mniej ni� 13
#utwor�w z kategorii Rock.

select artist.Name, avg(Milliseconds), count(TrackId)
from track, album, artist, genre
where track.AlbumId = album.AlbumId and 
	album.ArtistId = artist.ArtistId and
	track.GenreId = genre.GenreId and 
	genre.Name = "Rock"
group by artist.Name
having count(TrackId) >= 13
order by avg(Milliseconds) desc;


#22. Na podstawie tabeli customer, wypisz informacje w postaci pary: (domena poczty email, liczba klientow), zliczaj�cych popularno�� poszczeg�lnych serwis�w.
#Dane powinny by� uporz�dkowane malej�co wzgl�dem liczby korzystaj�cych z danej domeny.

select regexp_substr(Email, '(?<=@)[^.]+(?=\.)') "domena", count(CustomerId) 
from customer
group by regexp_substr(Email, '(?<=@)[^.]+(?=\.)')
order by count(CustomerId) desc;

#23. Wprowad� 1 nowego klienta do tabeli customer, nie tw�rz dla niego �adnych faktur.

insert into chinook.customer (CustomerId,FirstName,LastName,Company,Address,City,State,Country,PostalCode,Phone,Fax,Email,SupportRepId) values
	 (60,'Wojtek','XYZ', NULL,'Celsiusg. 993/2','Stockholm',NULL,'Sweden','55-200','+46 08-65666 6662',NULL,'wojtek@yaho12o.se',5);

insert into chinook.customer (CustomerId,FirstName,LastName,Company,Address,City,State,Country,PostalCode,Phone,Email,SupportRepId) values
	 (60,'Wojtek','XYZ', NULL,'Celsiusg. 993/2','Stockholm',NULL,'Sweden','55-200','+46 08-65666 6662','wojtek@yaho12o.se',5);	
	
#24. Do tabeli customer dodaj, jako ostatni�, kolumn� FavGenre. Dla wszystkich klient�w ustaw j� pocz�tkowo na NULL.

alter table customer 
add FavGenre int(11);

#drop column FavGenre

#25. Dla ka�dego klienta ustaw warto�� FavGenre na dowolne ID oferowanego gatunku.

select max(GenreId), min(GenreId) into @imax, @imin
from genre;
update customer 
set FavGenre = (select floor(rand()*(@imax - @imin
 + 1)+ @imin));

#26. Z tabeli customer usu� kolumn� Fax.

alter table customer
drop Fax;

#27. Dla ka�dego klienta ustaw warto�� FavGenre w oparciu o dokonywane zakupy �
#dla klient�w, kt�rzy nic nie zam�wili - wstaw NULL, dla pozosta�ych ten gatunek,
#z kt�rego zam�wili najwi�cej produkt�w (w przypadku r�wnej liczby wybierz np.
#alfabetycznie).

create temporary table customer_genre_count (
	select count(track.TrackId) as genre_count, invoice.CustomerId, genre.GenreId 
	from customer, invoiceline, track, genre, invoice 
	where customer.CustomerId = invoice.CustomerId and 	
		invoice.InvoiceId = invoiceline.InvoiceId and 
		genre.GenreId = track.GenreId and 
		invoiceline.TrackId = track.TrackId
	group by genre.GenreId, customer.CustomerId
	order by invoice.CustomerId 
);


create temporary table customer_favgenre (
	select cgc.CustomerId, cgc.GenreId 
	from customer_genre_count cgc 
	where cgc.genre_count = (select max(cgc2.genre_count) from customer_genre_count cgc2 where cgc.CustomerId = cgc2.CustomerId)
	group by cgc.CustomerId
);

update customer 
set FavGenre = null;

update customer  
inner join customer_favgenre
	on customer.CustomerId = customer_favgenre.CustomerId
set customer.FavGenre = customer_favgenre.GenreId;

drop temporary table customer_genre_count;
drop temporary table customer_favgenre;

#28. Z tabeli invoice usu� wszystkie faktury wystawione przed rokiem 2010.
 
drop table invoiceline;
delete from invoice 
where InvoiceDate < "2010.01.01";


#29. Usu� z bazy informacj� o klientach, kt�rzy nie s� powi�zani z �adn� transakcj�.

delete c1 from customer c1
where c1.CustomerId in(
select CustomerId from (select * from customer) as c2
        where not exists (
            select * from invoice i where i.CustomerId = c2.CustomerId 
        ));  
       
#30. Uzupe�nij tabl� track o informacje dotycz�ce utwor�w z album�w The Unforgiving oraz Gigaton, uzupe�nij informacje w pozosta�ych tabelach tak, aby baza
#zachowa�a sp�jno�� (tzn. dodaj informacje o nieistniej�cych wcze�niej zespo�ach,
#albumach etc. a dla istniej�cych wprowad� poprawne ID). Zastan�w si�, jak ten
#proces zautomatyzowa�.

       
#dodawanie artyst�w
insert into artist (ArtistId, Name)
select * from (select max(a.ArtistId) + 1, 'Pearl Jam' from artist a) as tmp
where not exists (
    select Name from artist where Name = 'Pearl Jam'
) limit 1;

insert into artist (ArtistId, Name)
select * from (select max(a.ArtistId) + 1 , 'Within Temptation' from artist a) as tmp
where not exists (
    select Name from artist where Name = 'Within Temptation'
) limit 1;


#dodawanie album�w
insert into album (AlbumId, Title, ArtistId)
select * from (select max(alb.AlbumId) + 1, 'Gigaton', artist.ArtistId 
from artist, album alb
where Name = 'Pearl Jam') as tmp
where not exists (
	select Title from album where Title = 'Gigaton'
) limit 1;

insert into album (AlbumId, Title, ArtistId)
select * from (select max(alb.AlbumId) + 1, 'The Unforgiving', artist.ArtistId 
from artist, album alb
where Name = 'Within Temptation') as tmp
where not exists (
	select Title from album where Title = 'The Unforgiving'
) limit 1;


#dodawanie utwor�w do albumu 'Gigaton'
insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Who Ever Said', album.AlbumId, 2, 1, 'Vedder', 311000, 10220000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Who Ever Said'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Superblood Wolfmoon', album.AlbumId, 2, 1, 'Vedder', 229000, 9420000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Superblood Wolfmoon'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Dance of the Clairvoyants', album.AlbumId, 2, 1, 'Vedder', 266000, 9020000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Dance of the Clairvoyants'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Quick Escape', album.AlbumId, 2, 1, 'Ament', 287000, 94220000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Quick Escape'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Alright', album.AlbumId, 2, 1, 'Ament', 224000, 9020000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Alright'
) limit 1;


insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Seven O�Clock', album.AlbumId, 2, 1, 'Ament', 374000, 13410000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Seven O�Clock'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Never Destination', album.AlbumId, 2, 1, 'Vedder', 257000, 10020000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Never Destination'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Take the Long Way', album.AlbumId, 2, 1, 'Cameron', 222000, 8220000, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Take the Long Way'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Buckle Up', album.AlbumId, 2, 1, 'Gossard', 210000, 8111111, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Buckle Up'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Comes Then Goes', album.AlbumId, 2, 1, 'Vedder', 362000, 10224030, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Comes Then Goes'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Retrograde', album.AlbumId, 2, 1, 'McCready', 322000, 11220800, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'Retrograde'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'River Cross', album.AlbumId, 2, 1, 'Vedder', 353000, 11220920, 0.89
from album, track t
where Title = 'Gigaton') as tmp 
where not exists (
	select Name from track where Name = 'River Cross'
) limit 1;


#dodawanie utwor�w do albumu 'The unforgiving'
insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Shot in the Dark', album.AlbumId, 1, 3, 'den Adel', 302000, 10113000, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Shot in the Dark'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Why Not Me', album.AlbumId, 1, 3, 'den Adel, Westerholt', 34000, 513000, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Why Not Me'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'In the Middle of the Night', album.AlbumId, 1, 3, 'den Adel, Westerholt, Gibson', 311000, 1333000, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'In the Middle of the Night'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Faster', album.AlbumId, 1, 3, 'den Adel, Westerholt, Gibson', 263000, 1011001, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Faster'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Fire and Ice', album.AlbumId, 1, 3, 'den Adel', 237000, 9121000, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Fire and Ice'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Iron', album.AlbumId, 1, 3, 'Westerholt, Gibson', 341000, 12263000, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Iron'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Where Is the Edge', album.AlbumId, 1, 3, 'den Adel, Westerholt, Gibson', 239000, 9910021, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Where Is the Edge'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Sin�ad', album.AlbumId, 1, 3, 'den Adel, Westerholt, Gibson, Spierenburg', 263000, 1002115, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Sin�ad'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Lost', album.AlbumId, 1, 3, 'den Adel, Westerholt, Gibson', 314000, 12115090, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Lost'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Murder', album.AlbumId, 1, 3, 'den Adel, Westerholt, Gibson', 2560000, 9913421, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Murder'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'A Demon�s Fate', album.AlbumId, 1, 3, 'den Adel, Gibson', 630000, 11563000, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'A Demon�s Fate'
) limit 1;

insert into track (TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
select * from (select max(t.TrackId) + 1, 'Stairway to the Skies', album.AlbumId, 1, 3, 'den Adel, Spierenburg', 632000, 11982200, 0.99
from album, track t
where Title = 'The Unforgiving') as tmp 
where not exists (
	select Name from track where Name = 'Stairway to the Skies'
) limit 1;
















