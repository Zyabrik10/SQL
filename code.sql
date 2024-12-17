-- 1) Wyświetl imiona i nazwiska pracowników, którzy nie obsługiwali zamówień w dniu 1997-09-05. 
-- Zbór wynikowy powinien zawierać imię, nazwisko oraz wiek (liczbę lat) pracownika (baza northwind)
use Northwind;

select e.FirstName, e.LastName, (year(GETDATE()) - year(e.BirthDate)) as Age
from Employees e
where e.EmployeeID not in (
    select o.EmployeeID
    from Employees e
    join Orders o
    on o.EmployeeID = e.EmployeeID
    where o.OrderDate = '1997-09-05'
)


-- 2) Wyświetl listę dzieci będących członkami biblioteki, które w dniu '2001-12-14' zwróciły do biblioteki książkę dla której title_no = 12. 
-- Zbiór wynikowy powinien zawierać identyfikatory (member_no) tych dzieci (baza library)
use library;

select j.member_no
from juvenile j
join loanhist l
on l.member_no = j.member_no 
and year(l.in_date) = 2001
and month(l.in_date) = 12
and day(l.in_date) = 14
and l.title_no = 12

-- 3) Dla każdego przewoźnika podaj "łączną wartość opłat za presyłkę" zamówień przewiezionych przez tego przewoźnika
-- w okresie od 3 do 4 kwietnia 1998. 
-- Jeśli któryś z przewoźników nie przewiózł w tym czasie żadnego zamówienia, to też powinien pojawić się na liście, 
-- a wartość opłat za przesyłkę powinna wynosić 0. Zbiór wynikowy powinien zawierać nazwę przewoźnika, nr telefonu, oraz łączną wartość opłat za przesyłkę (baza northwind)
use Northwind;

select s.CompanyName, s.Phone, cast( sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) as money) as price
from Shippers s
left join Orders o
on s.ShipperID = o.ShipVia and year(o.OrderDate) = 1998 and month(o.OrderDate) = 5 and (day(o.OrderDate) = 3 or day(o.OrderDate) = 4)
join [Order Details] od
on od.OrderID = o.OrderID
group by s.CompanyName, s.Phone

-- 4) Wyświetl zamówienia złożone w 1997r. dla których krajem odbiorcy jest Argentyna. 
-- Zbiór wynikowy powinien zawierać nr zamówienia, datę wysyłki, opłatę za przesyłkę oraz nazwę klienta  (baza northwind)
use Northwind;

select o.OrderID, o.ShippedDate, c.CompanyName, cast( sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) as money) as price
from Orders o
join Customers c
on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997 and o.ShipCountry = 'Argentina'
join [Order Details] od
on od.OrderID = o.OrderID
group by o.OrderID, c.CompanyName, o.ShippedDate