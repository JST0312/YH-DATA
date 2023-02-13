select *
from books;
use YHDB;


-- 문자열을 합치는 함수 concat()
-- author_fname 과 author_lname 컬럼의 값을 합해서
-- full_name 이라고 보여주고 싶다. 
select  concat(author_fname , ' ' , author_lname) as full_name   
from books;

-- concat_ws() 함수를 이용하는 방법
select concat_ws(' ' , author_fname, author_lname ) as full_name
from books;

-- 문자열의 일부분만 가져오는 함수 substring()
-- 책 제목을 첫글자부터 10번째까지만 가져오기
-- 서브스트링 함수의 시작위치는 1부터!!!
select  substring( title, 1 )  
from books;

select  substring( title, 1, 10 ) as title
from books;

-- 타이틀 컬럼의 내용을, 맨 뒤에서 5번째 글자부터 끝까지 가져오시오.
select substring( title , -5) as title_end
from books;

-- 타이틀을 가져오되, 5번째 글자부터 15번째 글자까지 가져오시오.
select substr(title , 5, 15) as title_end
from books;

-- 문자열의 내용을 바꾸는, replace() 함수
-- 책 제목에 The 가 있으면, 제거하고 싶다.
select replace(title , 'The' , 'Hello')
from books;


-- 문자열의 순서를 역순으로 바꿔주는 reverse() 함수
-- 작가 author_lname 을 역순으로 가져오시오.
select reverse( author_lname )
from books;

-- 책 제목을 맨 앞부터 10글자만 가져오고, 뒤에 ... 을 붙인다.
-- 예) The Namesa... 
--     Norse Myth...
select concat( substring(title , 1, 10) , '...' ) as title
from books;

-- 문자열의 개수(길이) 를 구하는 함수 char_length()
-- 책 제목의 길이를 구하시오. 
select char_length( title ) as title_cnt
from books;

-- 대소문자 처리하는 함수 upper()  lower() 
-- 작가 이름 author_fname을 대문자로 바꾸시오.
select upper( author_fname ) as upper_fname
from books;



select replace( title , ' ' , '->') as title
from books;

select author_lname as forwards, reverse(author_lname) as backwards
from books;

select  upper(concat( author_fname, ' ', author_lname ) ) as 
		'full name in caps'
from books;

use YHDB;

select concat( title, ' was released in '  , released_year ) as blurb
from books;


select title , char_length(title) as 'character count'
from books;





select  concat( substring(title, 1, 10) , '...') as 'short title' , 
	    concat(	author_lname, ',' ,author_fname ) as author, 
        concat( stock_quantity , ' in stock') as quantity
from books;

insert into books
(title, author_fname, author_lname, released_year, stock_quantity,
pages)
values
('10% Happier', 'Dan', 'Harris', 2014, 29, 256),
('fake_book', 'Freida', 'Harris', 2001, 287, 428),
('Lincoln In The Bardo', 'George', 'Saunders', 2017, 111, 388);


select * 
from books;

-- 데이터를 유니크하게 만드는 키워드 distinct
-- author_lname 은 카테고리컬 데이터다. 유니크한 데이터를 확인하자.
select  distinct author_lname
from books;

-- 작가의 퍼스트네임과 라스트네임을 합친, full name 으로 유니크하게 확인하자.
select distinct concat( author_fname,' ' ,author_lname) as full_name
from books;

-- 정렬하는 방법 : order by 키워드 (위치가 중요)
-- author_lname 으로 정렬
select *
from books
order by author_lname ;

-- full_name 으로 정렬 (SQL동작 방식을 이해)
select id, title, concat(author_fname, ' ' , author_lname) as full_name,
		released_year, stock_quantity, pages
from books
order by full_name;

-- full_name 내림차순으로 정렬 ( desc)  , 오름차순은 ( 아무것도 쓰지않거나 asc )
select id, title, concat(author_fname, ' ' , author_lname) as full_name,
		released_year, stock_quantity, pages
from books
order by full_name desc;

-- 출간년도로 내림차순 정렬하여, 책 제목, 출간년도, 페이지수를 가져오시오.
select title, released_year, pages
from books
order by released_year desc;

-- author_lname 으로 정렬하되, 이름이 같으면 author_fname 으로 정렬하시오.
select *
from books
order by author_lname , author_fname ;

-- author_lname 으로 정렬하되, author_lname은 내림차순, 
-- author_fname 은 오름차순으로 정렬하시오.

select *
from books
order by author_lname desc , author_fname asc ;

-- 데이터를 끊어서 가져오는 방법  limit 와 offset 
-- 테이블의 데이터를 5개만 가져오시오.
select *
from books
limit 5;
-- limit 에 숫자가 2개 나오면, 왼쪽은 시작위치(offset), 오른쪽은 갯수
select *
from books
limit 0, 5;

-- 위에서 가져온 5개 이후로, 5개의 데이터를 가져오시오.
select *
from books
limit 5, 5;
-- 위에서 가져온 5개 이후로, 5개의 데이터를 가져오시오.
select *
from books
limit 10, 5;
-- 위에서 가져온 5개 이후로, 5개의 데이터를 가져오시오.
select *
from books
limit 15, 5;

-- 출간년도 내림차순으로 정렬하여, 처음부터 7개의 데이터를 가져오시오.(순서 중요)
select *
from books
order by released_year desc
limit 0,7;

select *
from books
order by released_year desc
limit 7,7;

-- 문자열 안에 원하는 문자가 들어있는지 검색 :  like 키워드 
-- 책 제목에 the 가 들어가 있는 데이터를 가져오시오.
select * 
from books
where title like '%the%';
-- 책 제목에 시작이 the 로 시작하는 데이터를 가져오시오.
select * 
from books
where title like 'the%';
-- 책 제목이, the 로 끝나는 데이터를 가져오시오.
select * 
from books
where title like '%the';

-- stock_quantity 의 숫자가 두자리인 데이터만 가져오시오. _ 언더스코어로 표시.
select *
from books
where stock_quantity like '__';

-- pages 수는 100보다 크고, 책 제목에 the 가 들어간 책을 가져오되,
-- 재고수량 내림차순으로 데이터를 3개만 가져오시오.
select * 
from books;

















