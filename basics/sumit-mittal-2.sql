USE temp;

CREATE TABLE Matches (
player_id int,
match_day VARCHAR(50),
result VARCHAR(50));

INSERT INTO matches VALUES 
(1,'2022-01-17', "win"),
(1,'2022-01-18', "win"),
(1,'2022-01-25', "win"),
(1,'2022-01-31', "draw"),
(1,'2022-02-08', "win"),
(2,'2022-02-06', "lose"),
(2,'2022-02-08', "lose"),
(3,'2022-03-30', "win");

SELECT * FROM MATCHES;

SELECT *,
SUM(result!="win") OVER (PARTITION BY player_id ORDER BY match_day) as grp_num
from matches;

With grp_cte as (SELECT *,
SUM(result!="win") OVER (PARTITION BY player_id ORDER BY match_day) as grp_num
from matches),
num_cte as (SELECT player_id, grp_num, count(*) as streak,
ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY count(*) desc) as row_num
from grp_cte
where result = "win"
group by player_id, grp_num)
SELECT a.player_id, 
CASE WHEN b.player_id is null then 0 ELSE b.streak END as longest_streak
from (SELECT distinct player_id from matches) as a
LEFT JOIN (select * from num_cte where row_num = 1) as b
on a.player_id=b.player_id;

#count(0), count(1), count(*) as streak will give the same result table