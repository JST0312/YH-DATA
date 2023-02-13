use movie_db;

-- 1. 테이블 만들기
CREATE TABLE `user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `password` varchar(256) NOT NULL,
  `nickname` varchar(45) NOT NULL,
  `gender` tinyint NOT NULL COMMENT '0 : 여자 \n1 : 남자 ',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `nickname_UNIQUE` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `movie` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `genre` varchar(300) NOT NULL,
  `image_url` varchar(256) NOT NULL,
  `year` timestamp NOT NULL,
  `attendance` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `review` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `movie_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `content` varchar(100) NOT NULL,
  `rating` tinyint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `movie_id_user_id` (`movie_id`,`user_id`),
  KEY `r_movie_id_idx` (`movie_id`),
  KEY `r_user_id_idx` (`user_id`),
  CONSTRAINT `r_movie_id` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `r_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `history` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `word` varchar(45) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `h_user_id_idx` (`user_id`),
  CONSTRAINT `h_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `favorite` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `movie_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `movie_id_user_id` (`movie_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




-- 2. 더미 데이터 insert ( 깃허브 sql폴더에, movie.sql )

-- 3. 화면 기획서를 보고, 필요한 SQL문을 작성.
--    중요! 순서 : 단일 테이블 처리 가능한 것부터 작성하고,
--    메인 화면처럼, 여러 테이블 조인하는 것은 맨 나중에 작성한다.

-- 회원가입
select * from user;

insert into user (email, password, nickname, gender)
values('abc@naver.com', '1234abcd', '홍길동', 1);

-- 리뷰 작성 
select * from review;

insert into review (movie_id, user_id, content, rating)
values (100, 7, '재밌어요.', 4);

-- 특정 영화에 대한 리뷰 가져오는 SQL
select r.id, u.nickname, r.content, r.rating, r.created_at
from review r
join user u 
on r.user_id = u.id 
where movie_id = 10
order by r.created_at desc
limit 0, 25;

-- 내정보 화면에서, 내 리뷰 리스트 가져오는 SQL 
select r.id, m.title, r.rating, r.created_at
from review r
join movie m
on r.movie_id = m.id
where user_id = 1
order by r.created_at desc ;

-- 영화 상세정보 가져오는 화면의 SQL 
select ifnull(count(r.user_id) , 0) as review_cnt , 
		ifnull(avg(r.rating) , 0) as rating_avg, 
		m.title, m.genre, 
		m.image_url, date( m.year ), m.attendance
from movie m
left join review r
on r.movie_id = m.id
where movie_id = 10;

-- 검색어를 저장하는 SQL 
insert into history (user_id, word)
values (7, 'mon');

select * from history;

-- 검색어가 포함된 영화의 목록을 가져오는 SQL 
select m.title, count( r.user_id ) as review_cnt, 
	ifnull( avg(r.rating) , 0 ) as rating_avg
from movie m
left join review r
on m.id = r.movie_id
where title like '%mon%'
group by m.id;


select *
from movie m
left join review r
on m.id = r.movie_id
where title like '%mon%';
use movie_db;
select * from user;
-- 즐겨찾기 설정하는 SQL 
insert into favorite (movie_id, user_id)
values (87, 7);

-- 즐겨찾기 해제하는 SQL
delete from favorite
where id = 1;

delete from favorite
where user_id = 7 and movie_id = 33;

-- 즐겨찾기 설정된 영화목록 가져오는 SQL 
select f.id as favorite_id, m.title, 
		count(r.id) as review_cnt, 
        ifnull( avg(r.rating) , 0) as rating_avg, 
		m.id as movie_id
from favorite f 
join movie m 
on f.movie_id = m.id
left join review r 
on f.movie_id = r.movie_id
where f.user_id = 7
group by f.movie_id
order by f.created_at desc;



-- 메인화면의 영화 리스트 가져오는 SQL : 리뷰갯수가 많은것부터
-- ( 내가 즐겨찾기 한 영화와 아닌 영화를 구분할수 있는 컬럼 필요)
select m.id, m.title, 
		count(r.id) as review_cnt, avg(r.rating) as rating_avg, 
		if( f.id is null, 0 , 1 ) as is_my_favorite
from movie m 
left join review r
on m.id = r.movie_id 
left join favorite f 
on m.id = f.movie_id and f.user_id = 7
group by m.id
order by review_cnt desc
limit 0, 25;
-- 메인화면의 영화 리스트 가져오는 SQL : 별점 평균 높은 순으로 
-- ( 내가 즐겨찾기 한 영화와 아닌 영화를 구분할수 있는 컬럼 필요)
select m.id, m.title, 
		count(r.id) as review_cnt, avg(r.rating) as rating_avg, 
		if( f.id is null, 0 , 1 ) as is_my_favorite
from movie m 
left join review r
on m.id = r.movie_id 
left join favorite f 
on m.id = f.movie_id and f.user_id = 7
group by m.id
order by rating_avg desc
limit 0, 25;












