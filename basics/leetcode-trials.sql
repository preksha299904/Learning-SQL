CREATE DATABASE temp;
USE temp;

CREATE TABLE Logs(
id int primary key,
num int) ;

INSERT INTO Logs VALUES
(1,1),
(2,1),
(3,1),
(4,2),
(5,5),
(6,5),
(7,5);

SELECT * FROM LOGS;

SELECT DISTINCT L1.num AS ConsecutiveNums
FROM Logs L1
JOIN Logs L2 ON L1.id = L2.id - 1 AND L1.num = L2.num
JOIN Logs L3 ON L1.id = L3.id - 2 AND L1.num = L3.num;
