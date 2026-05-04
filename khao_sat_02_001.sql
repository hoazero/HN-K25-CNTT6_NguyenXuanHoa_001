create database khao_sat_thuoc;
use khao_sat_thuoc;

create table books (
	book_id VARCHAR(5) primary key,
    title VARCHAR(150) not null unique,
    author VARCHAR(100) not null,
	category VARCHAR(50) not null,
    price DECIMAL(10,2) not null,
    status VARCHAR(20) not null default 'Available'
);

create table members (
	member_id VARCHAR(5) primary key,
    full_name VARCHAR(100) not null,
    email VARCHAR(100) not null unique,
	phone VARCHAR(15) not null,
    membership_type VARCHAR(50) not null default 'Student'
);

create table loans (
	loan_id INT primary key auto_increment,
    book_id VARCHAR(5) not null,
    member_id VARCHAR(5) not null,
    loan_date DATE not null,
    return_date DATE not null,
    foreign key (book_id) references books (book_id),
    foreign key (member_id) references members (member_id),
    unique (book_id, member_id)
);

create table fines (
	fine_id INT primary key auto_increment,
    loan_id INT not null,
    fine_amount DECIMAL(10,2) not null,
    fine_reason VARCHAR(255) not null,
    foreign key (loan_id) references loans (loan_id)
);

-- cau 1
alter table books
modify column price DECIMAL(10,2) not null check (price > 0);

-- cau 2
alter table books 
modify column status VARCHAR(20) not null default 'Available';

-- cau 3
alter table books  
add column published_year int;
 
insert into books 
values 
('B01', 'Đất rừng phương Nam', 'Đoàn Giỏi', 'Tiểu thuyết', 120000.00, 'Available', 2020),
('B02', 'Lập trình Python', 'Nguyễn Anh', 'Công nghệ', 250000.00, 'Borrowed', 2022),
('B03', 'Kỹ thuật lập trình C', 'Lê Nam', 'Công nghệ', 180000.00, 'Available', 2021),
('B04', 'Số đỏ', 'Vũ Trọng Phụng', 'Tiểu thuyết', 85000.00, 'Borrowed', 2019),
('B05', 'Tư duy logic', 'Phạm Minh', 'Kỹ năng', 150000.00, 'Available', 2023);

insert into members
values
('M01', 'Trần Văn An', 'an.tv@gmail.com', '0912345678', 'Student'),
('M02', 'Nguyễn Thị Bình', 'binh.nt@gmail.com', '0987654321', 'Teacher'),
('M03', 'Nguyễn Minh Hiếu', 'hieu.nm@gmail.com', '0911223344', 'Student'),
('M04', 'Phạm Bảo Ngọc', 'ngoc.pb@gmail.com', '0922334455', 'Guest'),
('M05', 'Lê Hồng Anh', 'anh.lh@gmail.com', '0933445566', 'Student');

alter table loans  
modify column return_date date;

insert into loans
values
(1, 'B02', 'M01', '2025-11-10', '2025-11-20'),
(2, 'B04', 'M03', '2025-11-12', NULL),
(3, 'B01', 'M02', '2025-11-15', '2025-11-25'),
(4, 'B02', 'M05', '2025-12-01', NULL),
(5, 'B03', 'M01', '2025-12-05', '2025-12-15'),
(6, 'B05', 'M03', '2025-12-10', NULL);

insert into fines
values
(1, 1, 15000.00, 'Quá hạn 5 ngày'),
(2, 3, 5000.00, 'Làm rách trang sách'),
(3, 5, 20000.00, 'Quá hạn 7 ngày');

-- update/delete
-- cau 1
update members
set membership_type = 'Teacher'
where member_id = 'M01';

-- cau 2
set sql_safe_updates = 0;
update books 
set price = price * 1.05
where category = 'Công nghệ';

-- cau 3
delete from fines
where fine_amount < 10000;

-- cau 4
update books
set status = 'Lost'
where published_year < 2020;

-- update loans
-- set return_date = 

-- truy van
-- cau 1
select title, author, category, price, published_year
from books
where price > 100000 and price < 500000;

-- cau 2
select full_name, email
from members 
where full_name like '%Nguyễn%';

-- cau 3
select title, author
from books
order by price desc;

-- cau 4
select title, author
from books
order by published_year desc
limit 3;

-- cau 5
select loan_id, book_id, member_id, loan_date, return_date
from loans
where month(loan_date) = 11 and year(loan_date) = 2025;

-- cau 6
select title, author, category, price, published_year
from books
where title like 'L%' or title like '%n';

-- cau 7
select loan_id, book_id, member_id, loan_date, return_date
from loans
where loan_date between '2025-11-01' and '2025-12-15';

-- cau 8
select member_id, full_name, phone
from members
order by full_name asc;

-- nang cao
-- cau 1
select l.loan_id, m.full_name, b.title, l.loan_date
from members m
inner join loans l on m.member_id = l.member_id
inner join books b on b.book_id = l.book_id
where membership_type = 'Student';

-- cau 2
select category, count(book_id) as sum_book_by_cat
from books
group by category;

-- cau 3
select m.full_name, count(l.member_id) as sum_loan_book
from loans l
inner join members m on m.member_id = l.member_id
group by l.member_id;

-- cau 4
select title
from books
where book_id not in (
	select book_id
	from loans
);

-- cau 5
select m.full_name, sum(f.fine_amount) as total_fine
from members m
join loans l on l.member_id = m.member_id
join fines f on f.loan_id = l.loan_id
where m.member_id in (
	select l.member_id
	from loans l
	where l.loan_id in (
		select f.loan_id
		from fines
	)
)
group by m.member_id;

-- cau 6
select full_name
from members
where member_id in (
	select member_id
	from loans
	group by member_id
	having count(member_id) > 1
);

-- cau 7
select full_name
from members
where member_id IN (
	select member_id
	from loans
	where book_id = (
		select book_id
		from books 
		where price = (
			select max(price)
			from books
		)
	)
);





