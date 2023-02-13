-- 1. 테이블 만든다.
--     db는 memo_db 
CREATE TABLE `user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `password` varchar(256) NOT NULL,
  `nickname` varchar(45) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `nickname_UNIQUE` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `schedule` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `content` varchar(100) NOT NULL,
  `is_completed` tinyint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date` timestamp NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `s_user_id_idx` (`user_id`),
  CONSTRAINT `s_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




CREATE TABLE `follow` (
  `follower_id` int unsigned NOT NULL,
  `followee_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followee_id`),
  KEY `f_followee_id_idx` (`followee_id`),
  CONSTRAINT `f_followee_id` FOREIGN KEY (`followee_id`) REFERENCES `user` (`id`),
  CONSTRAINT `f_follower_id` FOREIGN KEY (`follower_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




-- 2. 데이터 넣기.

-- 깃허브 sql 폴더에, memo_ 로 시작하는 파일 3개 인서트.

-- 3. 화면에 필요한 SQL 작성 
--    (클라이언트에 전달할 데이터 가공)


use memo_db;
select * from user;
select * from schedule;
select * from follow;

-- 1. 회원가입 SQL 작성.
insert into user (email, password, nickname)
values ('abc@naver.com', 'abcd1234' , '홍길동');

select * from user;

-- 2. 내일정 가져오는 SQL 
-- 나는 user_id 1번인 사람이다 라고 가정.
select * 
from schedule
where user_id = 43
order by date desc
limit 0, 25;

-- 3. 일정 작성하는 SQL 
insert into schedule (user_id, content, date)
values (101, '일요일에 맛있는 저녁', '2022-12-12 18:30');

select * 
from schedule
order by created_at desc;

-- 4. 일정완료 버튼을 누르면, 일정 완료시키는 SQL  
update schedule
set is_completed = 1
where id = 22;

select * from schedule
order by created_at desc;


-- 5. 친구들의 일정을 가져오는 SQL 
--   내 아이디는 1이다라고 가정하고 만든다. 
select s.user_id, s.content, s.date, 
		s.is_completed, u.nickname
from follow f
join schedule s 
on f.followee_id = s.user_id
join user u
on s.user_id = u.id
where follower_id = 1 and s.date > now()
order by s.date desc
limit 0, 25;

select s.user_id, s.content, s.date, 
		s.is_completed, u.nickname
from follow f
join schedule s 
on f.followee_id = s.user_id
join user u
on s.user_id = u.id
where follower_id = 1 and s.date < now()
order by s.date desc
limit 0, 25;



















