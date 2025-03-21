-- CREATE DATABASE library;
-- In PostgreSQL, you have to create the database manually, then run the following commands to set up the tables and data

-- Table structure for table member
CREATE TABLE member (
  mid INTEGER NOT NULL,
  mname VARCHAR,
  maddress VARCHAR,
  mphone VARCHAR,
  membership_type VARCHAR,
  PRIMARY KEY (mid)
);

-- Data for the table "member"
INSERT INTO member("mid","mname","maddress","mphone","membership_type") VALUES 
(1001,'Alice Brown','123 Maple St','5551234567','Regular'),
(1002,'Bob Green','456 Oak St','5552345678','Premium'),
(1003,'Charlie Black','789 Pine St','5553456789','Regular'),
(1004,'David White','321 Birch St','5554567890','Premium'),
(1005,'Emma Blue','654 Cedar St','5555678901','Regular');

-- Table structure for table "library_branch"
CREATE TABLE library_branch (
  lid INTEGER NOT NULL,
  lname VARCHAR,
  laddress VARCHAR,
  PRIMARY KEY (lid)
);

-- Data for the table "library_branch"
INSERT INTO library_branch("lid","lname","laddress") VALUES 
(201,'Central Branch','100 Main St'),
(202,'North Branch','200 North Ave'),
(203,'South Branch','300 South Blvd'),
(204,'East Branch','400 East Rd'),
(205,'West Branch','500 West St');

-- Table structure for table "book"
CREATE TABLE book (
  bid INTEGER NOT NULL,
  title VARCHAR,
  genre VARCHAR,
  year INTEGER,
  PRIMARY KEY (bid)
);

-- Data for the table "book"
INSERT INTO book("bid","title","genre","year") VALUES 
(301,'Harry Potter and the Sorcerer''s Stone','Fantasy',1997),
(302,'Harry Potter and the Chamber of Secrets','Fantasy',1998),
(303,'Harry Potter and the Prisoner of Azkaban','Fantasy',1999),
(305,'1984','Dystopian',1949),
(306,'To Kill a Mockingbird','Fiction',1960),
(307,'Moby-Dick','Adventure',1851),
(308,'The Murder of Roger Ackroyd','Mystery',1926),
(309,'Death on the Nile','Mystery',1937);

-- Table structure for table "book_copy"
CREATE TABLE book_copy (
  copyid INTEGER NOT NULL,
  bid INTEGER,
  lid INTEGER,
  PRIMARY KEY (copyid),
  FOREIGN KEY (bid) REFERENCES book (bid),
  FOREIGN KEY (lid) REFERENCES library_branch (lid)
);

-- Data for the table "book_copy"
INSERT INTO book_copy("copyid","bid","lid") VALUES 
(4001,301,201), (4002,301,201), (4003,301,202), (4004,301,203), (4005,301,204),
(4006,302,201), (4007,302,202), (4008,302,203), (4009,302,204), (4010,302,205),
(4011,303,201), (4012,303,202), (4013,303,203), (4014,303,204), (4015,303,205),
(4021,305,201), (4022,305,202), (4023,305,203), (4024,305,204), (4025,305,205),
(4026,306,201), (4027,306,202), (4028,306,203), (4029,306,204), (4030,306,205),
(4031,307,201), (4032,307,202), (4033,307,203), (4034,307,204), (4035,307,205),
(4036,308,201), (4037,308,202), (4038,308,203),
(4039,309,201), (4040,309,202), (4041,309,203);

-- Table structure for table "loan"
CREATE TABLE loan (
  mid INTEGER NOT NULL,
  copyid INTEGER NOT NULL,
  loandate DATE NOT NULL,
  returndate DATE,
  PRIMARY KEY (mid,copyid,loandate),
  FOREIGN KEY (mid) REFERENCES member (mid),
  FOREIGN KEY (copyid) REFERENCES book_copy (copyid)
);

-- Data for the table "loan"
INSERT INTO loan("mid","copyid","loandate","returndate") VALUES 
(1001,4001,'2023-01-01','2023-01-10'), (1002,4002,'2023-01-02','2023-01-12'), (1003,4003,'2023-01-03','2023-01-13'),
(1004,4004,'2023-01-04',NULL), (1005,4005,'2023-01-05','2023-01-15'), (1001,4006,'2023-01-06','2023-01-16'),
(1002,4007,'2023-01-07','2023-01-17'), (1003,4008,'2023-01-08',NULL),
(1004,4009,'2023-01-09','2023-01-19'),
(1005,4010,'2023-01-10','2023-01-20'), (1001,4011,'2023-01-11','2023-01-21'), (1002,4012,'2023-01-12',NULL),
(1003,4013,'2023-01-13','2023-01-23'), (1004,4014,'2023-01-14','2023-01-24'), (1005,4015,'2023-01-15','2023-01-25'),
(1001,4036,'2023-01-16','2023-01-26'), (1002,4037,'2023-01-17',NULL), (1003,4038,'2023-01-18','2023-01-28'),
(1004,4039,'2023-01-19','2023-01-29'), (1005,4040,'2023-01-20','2023-01-30');

create view everything as
    select
        m.mid,
        b.bid, title, genre, year,
        lb.lid, lname, laddress,
        bc.copyid, l.loandate, l.returndate
    from
        member m,
        book b,
        library_branch lb,
        book_copy bc,
        loan l
    where
        m.mid = l.mid and
        b.bid = bc.bid and
        lb.lid = bc.lid and
        bc.copyid = l.copyid
    ;

create view available_book_copies as
select
	bc.bid bid, title, bc.lid lid, bc.copyid copyid
from
	book b, book_copy bc left join loan l
	on
	bc.copyid	=	l.copyid
where
	-- either the book copy was never loaned from library OR
	(((l.returndate is null)		and (l.loandate is null))
	or
	-- the book copy was loaned, but returned
	((l.returndate is not null)	and (l.loandate is not null)))	and
	b.bid		=	bc.bid
;
