USE TEMP;

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

#--------step 1 to get a single column for all the countries who played the matches


with icc_cte as (SELECT distinct(team_1) as team_name
from icc_world_cup
UNION ALL
SELECT DISTINCT(TEAM_2) AS TEAM_NAME
from icc_world_cup)
select team_name
from icc_cte
group by team_name;

#-----step 2 to get the total number of matches for which the column must be aggregated in the form of sum outside the cte as we are using count as aggregation in the cte

with icc_cte as (SELECT distinct(team_1) as team_name, count(team_1) as total_matches
from icc_world_cup
group by team_1
UNION ALL
SELECT DISTINCT(TEAM_2) AS TEAM_NAME, count(team_2) as total_matches
from icc_world_cup
group by team_2)
select team_name, SUM(total_matches) as matches_played
from icc_cte
group by team_name;

#----step 3 is to count the number of matches won and lost

with icc_cte as (SELECT distinct(team_1) as team_name, count(team_1) as total_matches,
COUNT( CASE WHEN winner = team_2 then 1 else null END ) as WON,
COUNT( CASE WHEN winner = team_1 then 1 else null END ) as LOST
from icc_world_cup
group by team_1
UNION ALL
SELECT DISTINCT(TEAM_2) AS TEAM_NAME, count(team_2) as total_matches,
COUNT( CASE WHEN winner = team_2 then 1 else null END ) as WON,
COUNT( CASE WHEN winner = team_1 then 1 else null END ) as LOST
from icc_world_cup
group by team_2)
select team_name, SUM(total_matches) as matches_played, SUM(WON) AS matches_won, SUM(LOST) AS matches_lost
from icc_cte
group by team_name;



