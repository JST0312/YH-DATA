select * from users;
select * from follows;
select * from comments;
select * from likes;
select * from photos;
select * from photo_tags;
select * from tags;

use instar_db;
-- 1. 가장 오래된 회원 5명은???
select *
from users
order by created_at 
limit 5;


-- 2. 회원가입을 가장 많이 하는 요일은???
select dayname(created_at) as day , count(dayname(created_at)) as count
from users
group by day
order by count desc;

-- 3. 회원가입은 했지만, 사진은 한번도 올린적 없는, 유령회원들의 데이터를 가져오시오.
select u.username 
from users u
left join photos p 
on u.id = p.user_id
where p.id is null ;

-- 4. 좋아요를 가장 많이 받은, 유명한 사진은 무엇인지, 
-- 그 사진의 아이디, 유저이름, 사진url주소, 좋아요 수 를 가져오세요. 
select photo_id, count(photo_id) as count , p.image_url, u.username
from likes l 
join photos p 
on l.photo_id = p.id
join users u 
on p.user_id = u.id
group by photo_id
order by count desc;

-- 5. 가장 많이 사용된 해쉬태그가 있을것이다.
-- 가장 많이 사용된 상위 5개의 해쉬태그 이름과, 갯수를 조회하시오. 
select t.tag_name, count(tag_id) as count
from photo_tags pt
join tags t
on pt.tag_id = t.id
group by tag_id
order by count desc
limit 5;

-- 좋아요를 80개 이상 한 사람들의, 이름과 그사람이 누른 좋아요 수를 나타내세요
select count(user_id) as count , u.username
from likes l
join users u 
on l.user_id = u.id
group by user_id having count >= 80
order by count desc;









