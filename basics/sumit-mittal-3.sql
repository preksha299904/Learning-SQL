USE temp;

CREATE TABLE players (
player_id INT PRIMARY KEY,
group_id INT);

CREATE TABLE MATCHES1 (
match_id INT PRIMARY KEY,
first_player INT,
second_player INT,
first_score INT,
second_score INT);

INSERT INTO players VALUES 
(15,1),(25,1),(30,1),(45,1),(10,2),(35,2),(50,2),(20,3),(40,3);

INSERT INTO MATCHES1 VALUES 
(1,15,45,3,0),(2,30,25,1,2),(3,30,15,2,0),(4,40,20,5,2),(5,35,50,1,1);

SELECT * FROM PLAYERS;
SELECT * FROM MATCHES1;

#-------APPROACH 1
#-----step 1 is to convert 5 columns into 3 columns

SELECT match_id, first_player as players, first_score as scores
from matches1
union all
select match_id, second_player as players, second_score as scores
from matches1;

#------step 2 is to get group id as 4th column

WITH CTE AS (SELECT match_id, first_player as players, first_score as scores
from matches1
union all
select match_id, second_player as players, second_score as scores
from matches1)
SELECT C.*, P.GROUP_ID
FROM CTE AS C
JOIN PLAYERS AS P
ON P.PLAYER_ID=C.PLAYERS;

#-----------step 3 is to find the sum of scores as we have repeated players

WITH CTE AS (SELECT match_id, first_player as players, first_score as scores
from matches1
union all
select match_id, second_player as players, second_score as scores
from matches1),
CTE_JOINED as (SELECT C.*, P.GROUP_ID
FROM CTE AS C
JOIN PLAYERS AS P
ON P.PLAYER_ID=C.PLAYERS)
SELECT group_id,players, SUM(scores) as total_scores
FROM CTE_JOINED
GROUP BY group_id,players;

#-----step 4 is to give ranking based on group_id and score desc

WITH CTE AS (SELECT match_id, first_player as players, first_score as scores
from matches1
union all
select match_id, second_player as players, second_score as scores
from matches1),
CTE_JOINED as (SELECT C.*, P.GROUP_ID
FROM CTE AS C
JOIN PLAYERS AS P
ON P.PLAYER_ID=C.PLAYERS),
CTE_GROUPED AS (SELECT group_id,players, SUM(scores) as total_scores
FROM CTE_JOINED
GROUP BY group_id,players)
SELECT *,
RANK() OVER (PARTITION BY GROUP_ID ORDER BY TOTAL_SCORES DESC, PLAYERS) AS RNK
FROM CTE_GROUPED;
#----- we have used ORDER BY TOTAL_SCORES DESC, PLAYERS so that in case of ties, the one having lowest player_id is winner

#-------FINAL, step 5 we have to get the highest scorer as winner so we will use rnk=1

WITH CTE AS (SELECT match_id, first_player as players, first_score as scores
from matches1
union all
select match_id, second_player as players, second_score as scores
from matches1),
CTE_JOINED as (SELECT C.*, P.GROUP_ID
FROM CTE AS C
JOIN PLAYERS AS P
ON P.PLAYER_ID=C.PLAYERS),
CTE_GROUPED AS (SELECT group_id,players, SUM(scores) as total_scores
FROM CTE_JOINED
GROUP BY group_id,players),
CTE_WINNER AS (SELECT *,
RANK() OVER (PARTITION BY GROUP_ID ORDER BY TOTAL_SCORES DESC, PLAYERS) AS RNK
FROM CTE_GROUPED)
SELECT GROUP_ID, PLAYERS AS PLAYER_ID
FROM CTE_WINNER
WHERE RNK = 1;

#--------APPROACH 2
#------step 1 is to join the 2 tables in order to get them all in one place

SELECT P.*, M.*
FROM PLAYERS AS P
JOIN MATCHES1 AS M
ON P.PLAYER_ID IN (M.FIRST_PLAYER, M.SECOND_PLAYER);

#--------step 2 is to reduce the number of columns from 5 to 3

SELECT P.player_id, p.group_id,
CASE WHEN p.player_id=m.first_player then m.first_score else m.second_score 
end as total_score
FROM PLAYERS AS P
JOIN MATCHES1 AS M
ON P.PLAYER_ID IN (M.FIRST_PLAYER, M.SECOND_PLAYER);

#---------step 3 is to sum up all the scores of distinct player id

SELECT P.player_id, p.group_id,
SUM(CASE WHEN p.player_id=m.first_player then m.first_score else m.second_score 
end) as total_score
FROM PLAYERS AS P
JOIN MATCHES1 AS M
ON P.PLAYER_ID IN (M.FIRST_PLAYER, M.SECOND_PLAYER)
GROUP BY p.player_id, p.group_id;

#--------step 4 is to assign them ranks

SELECT P.player_id, p.group_id,
SUM(CASE WHEN p.player_id=m.first_player then m.first_score else m.second_score 
end) as total_score,
RANK() OVER (PARTITION BY GROUP_ID ORDER BY 
SUM(CASE WHEN p.player_id=m.first_player then m.first_score else m.second_score 
end) DESC, PLAYER_ID) AS RNK
FROM PLAYERS AS P
JOIN MATCHES1 AS M
ON P.PLAYER_ID IN (M.FIRST_PLAYER, M.SECOND_PLAYER)
GROUP BY p.player_id, p.group_id;



#---ORDER BY 
#----SUM(CASE WHEN p.player_id=m.first_player then m.first_score else m.second_score 
#----end) THIS Can't be replaced by total_score because this is derived just now in sum so we have to use the entire sentence in order by

#----- OR ELSE WE CAN USE A SUBQUERY

SELECT player_id, group_id, total_score,
RANK() OVER (PARTITION BY GROUP_ID ORDER BY total_score DESC, PLAYER_ID) AS RNK
FROM ( SELECT P.player_id, p.group_id,
SUM(CASE WHEN p.player_id=m.first_player then m.first_score else m.second_score 
end) as total_score
FROM PLAYERS AS P
JOIN MATCHES1 AS M
ON P.PLAYER_ID IN (M.FIRST_PLAYER, M.SECOND_PLAYER)
GROUP BY p.player_id, p.group_id) as c;

#-----------step 5 is to find the winner player id from individual group id

SELECT group_id, player_id
FROM (SELECT player_id, group_id, total_score,
RANK() OVER (PARTITION BY GROUP_ID ORDER BY total_score DESC, PLAYER_ID) AS RNK
FROM ( SELECT P.player_id, p.group_id,
SUM(CASE WHEN p.player_id=m.first_player then m.first_score else m.second_score 
end) as total_score
FROM PLAYERS AS P
JOIN MATCHES1 AS M
ON P.PLAYER_ID IN (M.FIRST_PLAYER, M.SECOND_PLAYER)
GROUP BY p.player_id, p.group_id) as c) AS D
WHERE RNK = 1;






