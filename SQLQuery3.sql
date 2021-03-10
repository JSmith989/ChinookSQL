-- highlight a table and alt F1 shows info about it

-- 1 show non usa customers
select LastName, FirstName, CustomerId, Country
FROM customer
WHERE Country != 'USA'
   
-- 2 show brazil customers
select LastName, FirstName, CustomerId, Country
FROM customer
WHERE Country = 'Brazil'

-- 3 show brazil customer invoices
SELECT LastName, FirstName, InvoiceDate, Country, InvoiceId
from customer c
	join invoice i
		on c.CustomerId = i.CustomerId
		WHERE c.Country = 'Brazil' 

-- 4 show sales angents
SELECT *
FROM employee
WHERE title = 'Sales Support Agent'

-- 5 show unique/distinct list of billing countries from invoice table 
SELECT DISTINCT BillingCountry
FROM Invoice

-- 6 show invoice associated with each sales agent
SELECT e.FirstName, e.LastName, i.*
FROM Invoice i
	join Customer c
		on i.CustomerId = c.CustomerId
		join Employee e
			on e.EmployeeId = c.SupportRepId

-- 7 show invoice total, customer name, country and sale agent for all invoices and customers
SELECT i.total, c.LastName, c.FirstName, c.Country, e.LastName, e.FirstName
FROM Invoice i
	join Customer c
		on i.CustomerId = c.CustomerId
		join Employee e
			on e.EmployeeId = c.SupportRepId

-- 8 how many invoices for 2009 and 2011
SELECT count(*)
FROM Invoice i
WHERE InvoiceDate like '%2009%' or InvoiceDate like '%2011%'

-- 9 total sales for year 2009 and 2011
SELECT year(InvoiceDate) as SalesYear, sum(i.total) as Total
FROM Invoice i
WHERE InvoiceDate like '%2009%' or InvoiceDate like '%2011%'
GROUP BY year(InvoiceDate)

-- 10 count number of items for invoice id 37
SELECT count(*) as LineItems
FROM InvoiceLine i
WHERE i.InvoiceId = '37'

-- 11 count the number of line items for each invoice
SELECT count(*), i.InvoiceId
FROM InvoiceLine i
GROUP BY i.InvoiceId

-- 12 Provide query that includes purchase track name with each invoice line item
SELECT t.Name, i.*
FROM InvoiceLine i
	join Track t
		on i.TrackId = t.TrackId

-- 13 purchased track name AND artist name with each invoice
SELECT t.name, ar.ArtistId, i.*
FROM InvoiceLine i 
	join Track t
		on i.TrackId = t.TrackId
	join Album a
		on t.AlbumId = a.AlbumId
	join Artist ar
		on a.ArtistId = ar.ArtistId

-- 14 number of invoices by country
SELECT count(*) as invoices, i.BillingCountry
FROM Invoice i
GROUP BY i.BillingCountry

-- 15 playlist track total 
SELECT count(pt.TrackId) as TotalTracks, p.Name
FROM PlaylistTrack pt
	join Playlist p
		on pt.PlaylistId = p.PlaylistId
	join Track t
		on t.TrackId = pt.PlaylistId
GROUP BY p.Name

-- 16 show all the Tracks, display no IDs. The result: Album name, Media type and Genre.
SELECT distinct a.Title as Album, g.Name as Genre, m.Name as MediaType
FROM Track t
	join Album a
		on a.AlbumId = t.AlbumId
	join MediaType m
		on m.MediaTypeId = t.MediaTypeId
	join Genre g
		on g.GenreId = t.GenreId

-- 17 show all Invoices but includes the # of invoice line items.
SELECT i.*, 
	( SELECT count(il.InvoiceLineId)
		FROM InvoiceLine il
	WHERE il.InvoiceId = i.InvoiceId) as NumberOfInvoiceLines
	from Invoice i


-- 18 show total sales made by each sales agent.
SELECT sum(il.Quantity * il.UnitPrice) as TotalSales, e.LastName, e.FirstName
FROM InvoiceLine il
	join Invoice i
		on il.InvoiceId = i.InvoiceId
	join Customer c
		on c.CustomerId = i.CustomerId
	join Employee e
		on e.EmployeeId = c.SupportRepId
GROUP BY e.LastName, e.FirstName

-- 19 Which sales agent made the most in sales in 2009?
SELECT TOP 1 sum(il.Quantity * il.UnitPrice) as TotalSales, e.LastName, e.FirstName
FROM InvoiceLine il
	join Invoice i
		on il.InvoiceId = i.InvoiceId
	join Customer c
		on c.CustomerId = i.CustomerId
	join Employee e
		on e.EmployeeId = c.SupportRepId
		WHERE i.InvoiceDate like '%2009%'
GROUP BY e.LastName, e.FirstName
ORDER BY TotalSales desc

-- 20 Which sales agent made the most in sales over all?
SELECT TOP 1 sum(il.Quantity * il.UnitPrice) as TotalSales, e.LastName, e.FirstName
FROM InvoiceLine il
	join Invoice i
		on il.InvoiceId = i.InvoiceId
	join Customer c
		on c.CustomerId = i.CustomerId
	join Employee e
		on e.EmployeeId = c.SupportRepId
GROUP BY e.LastName, e.FirstName
ORDER BY TotalSales desc

-- 21 show the count of customers assigned to each sales agent
SELECT (e.LastName + ', ' + e.FirstName) as SalesAgent ,Count(c.CustomerId) as Customers
FROM Customer c
	join Employee e
		on c.SupportRepId = e.EmployeeId
GROUP BY e.LastName, e.FirstName

-- 22 show the total sales per country
SELECT sum(i.total) as Sales, i.BillingCountry
FROM Customer c
	join Invoice i
		on i.CustomerId = c.CustomerId
GROUP BY i.BillingCountry

-- 23 Which country's customers spent the most?
SELECT sum(i.total) as Sales, i.BillingCountry
FROM Customer c
	join Invoice i
		on i.CustomerId = c.CustomerId
GROUP BY i.BillingCountry
ORDER BY Sales DESC

-- 24 show the most purchased track of 2013
SELECT Top 1 count(il.trackId) as PurchaseTotal, t.name
FROM InvoiceLine il
	join Track t
		on t.TrackId = il.TrackId
	join Invoice i
		on i.InvoiceId = il.InvoiceId
WHERE InvoiceDate like '%2013%'
GROUP BY t.name
ORDER BY PurchaseTotal DESC

-- 25 shows the top 5 most purchased songs
SELECT Top 5 count(il.trackId) as PurchaseTotal, t.name
FROM InvoiceLine il
	join Track t
		on t.TrackId = il.TrackId
	join Invoice i
		on i.InvoiceId = il.InvoiceId
GROUP BY t.name
ORDER BY PurchaseTotal DESC

--26 shows the top 3 best selling artists
SELECT Top 3 count(il.trackId) as PurchaseTotal, ar.name
FROM InvoiceLine il
	join Invoice i
		on i.InvoiceId = il.InvoiceId
	join Track t
		on t.TrackId = il.TrackId
	join Album a
		on a.AlbumId = t.AlbumId
	join Artist ar
		on ar.ArtistId = a.ArtistId
GROUP BY ar.name
ORDER BY PurchaseTotal DESC

-- 27 shows the most purchased Media Type
SELECT Top 1 count(il.trackId) as PurchaseTotal, m.Name
FROM InvoiceLine il
	join Invoice i
		on i.InvoiceId = il.InvoiceId
	join Track t
		on t.TrackId = il.TrackId
	join MediaType m
		on m.MediaTypeId = t.MediaTypeId
GROUP BY m.Name
ORDER BY PurchaseTotal DESC