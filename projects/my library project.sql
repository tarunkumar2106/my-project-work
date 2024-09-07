-- project task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

-- Task 2: Update an Existing Member's Address

UPDATE members 
SET 
    member_address = '125 Main St'
WHERE
    member_id = 'c101';
select * from members;

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

select * from issued_status
where issued_id = 'IS121';

DELETE FROM issued_status 
WHERE
    issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status 
where issued_emp_id = 'e101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
    issued_emp_id -- count(issued_id) as total_books 
FROM
    issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE books_cnts 
AS 
SELECT b.isbn, b.book_title, 
COUNT(ist.issued_id) AS no_issued 
FROM
    books AS b
        JOIN
    issued_status AS ist 
    ON b.isbn = ist.issued_book_isbn
GROUP BY 1 , 2;

select * from books_cnts;

-- Task 7. Retrieve All Books in a Specific Category

SELECT 
    *
FROM
    books
WHERE
    category = 'classic';
    
-- Task 8: Find Total Rental Income by Category:

SELECT 
    b.category,
    SUM(b.rental_price) as rental_income,
    COUNT(*)
FROM 
books as b
GROUP BY 1
order by rental_income desc;

-- task 9 List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= current_date - INTERVAL 180 day;

-- task 10 List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    ep1.*, b1.manager_id, ep2.emp_name AS manager
FROM
    employees AS ep1
        JOIN
    branch AS b1 ON ep1.branch_id = b1.branch_id
        JOIN
    employees AS ep2 ON b1.manager_id = ep2.emp_id;
    
-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7 usd:

create table rental_bk_prc (select * from books where rental_price > 7);
select * from rental_bk_prc;

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT DISTINCT
    ist.issued_book_name
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rs ON ist.issued_id = rs.issued_id
WHERE
    rs.return_id IS NULL;

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT 
	 ist.issued_member_id,
     m.member_name,
     b.book_title,
     ist.issued_date,
     current_date - ist.issued_date as over_dues_days
FROM
    issued_status AS ist
        JOIN
    members AS m ON m.member_id =ist.issued_member_id 
        JOIN
    books AS b ON b.isbn = ist.issued_book_isbn
		left JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
where rs.return_date is null
and (current_date - ist.issued_date)>30;
/*
Task 14: branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals.
*/

create table branch_reports
as
SELECT 
    b.branch_id,
    b.manager_id,
    count(ist.issued_id) as number_of_books,
    count(return_id)as return_books,
    sum(bk.rental_price) as total_books_price
FROM
    issued_status AS ist
        JOIN
    employees AS e ON e.emp_id = ist.issued_emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
        JOIN
    books AS bk ON ist.issued_book_isbn = bk.isbn
    group by 1,2;
    
    select * from branch_reports;
    
-- Task 15: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

create table active_members
as
SELECT 
    *
FROM
    members
WHERE
    member_id IN (SELECT DISTINCT
            issued_member_id
        FROM
            issued_status
        WHERE
            issued_date >= CURRENT_DATE - INTERVAL 2 MONTH);
            
select * from active_members;  

-- Task 16: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

SELECT 
    e.emp_name, b.*, COUNT(ist.issued_id) AS number_of_books
FROM
    issued_status AS ist
        JOIN
    employees AS e ON ist.issued_emp_id = e.emp_id
        JOIN
    branch AS b ON b.branch_id = e.branch_id
GROUP BY 1 , 2;

        






