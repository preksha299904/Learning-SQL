use orders;

CREATE TABLE support_tickets (
  ticket_id INT PRIMARY KEY,
  created_at DATE NOT NULL,
  customer_name VARCHAR(80) NOT NULL,
  channel VARCHAR(20) NOT NULL,        -- Email, Chat, Phone
  priority VARCHAR(20) NOT NULL,       -- Low, Medium, High, Urgent
  status VARCHAR(20) NOT NULL,         -- Open, In Progress, Resolved, Closed
  agent_name VARCHAR(80),              -- can be NULL if unassigned
  resolution_hours INT,                -- can be NULL if not resolved yet
  satisfaction_score INT               -- 1..5, can be NULL if not rated
);


INSERT INTO support_tickets
(ticket_id, created_at, customer_name, channel, priority, status, agent_name, resolution_hours, satisfaction_score)
VALUES
(1,'2024-06-01','Asha Rao','Email','High','Resolved','Neha',18,5),
(2,'2024-06-01','Ravi Kumar','Chat','Medium','Resolved','Neha',6,4),
(3,'2024-06-02','Meera Nair','Phone','Urgent','In Progress','John',NULL,NULL),
(4,'2024-06-02','John Mathew','Email','Low','Closed','Fatima',48,3),
(5,'2024-06-03','Sara Ali','Chat','High','Resolved','Neha',10,5),
(6,'2024-06-03','Kiran Das','Phone','Medium','Open',NULL,NULL,NULL),
(7,'2024-06-04','Priya Sharma','Email','Urgent','Resolved','John',30,2),
(8,'2024-06-04','Amit Verma','Chat','Low','Closed','Fatima',12,4),
(9,'2024-06-05','Ananya Gupta','Email','Medium','Resolved','John',20,NULL),
(10,'2024-06-05','Luis Fernandes','Phone','High','Resolved','Neha',8,4),
(11,'2024-06-06','Divya Menon','Chat','Urgent','Open',NULL,NULL,NULL),
(12,'2024-06-06','Chen Li','Email','High','In Progress','Fatima',NULL,NULL);

select * from support_tickets;
SELECT * FROM agents;


CREATE TABLE agents (
  agent_name VARCHAR(80) PRIMARY KEY,
  team VARCHAR(40) NOT NULL,          -- Alpha, Beta, Gamma
  location VARCHAR(50) NOT NULL,      -- Bengaluru, Delhi, Remote
  join_date DATE NOT NULL,
  active_flag VARCHAR(10) NOT NULL    -- Yes/No
);

INSERT INTO agents (agent_name, team, location, join_date, active_flag) VALUES
('Neha','Alpha','Bengaluru','2023-01-15','Yes'),
('John','Beta','Delhi','2022-06-10','Yes'),
('Fatima','Gamma','Remote','2021-09-05','Yes'),
('Rohit','Alpha','Bengaluru','2024-02-01','No');

SELECT * FROM agents;

#Show each ticket with agent_name, team, and a derived column agent_state such that it is Assigned to Active Agent when an agent exists and active_flag='Yes',
#Assigned to Inactive Agent when agent exists and active_flag='No', otherwise Unassigned/Unknown.
SELECT b.agent_name, b.team,
CASE b.active_flag
WHEN "Yes" THEN "Active agent"
WHEN "No" THEN "Inactive agent" 
ELSE "Unassigned"
END as agent_state
from support_tickets as a
right join agents as b
on b.agent_name=a.agent_name
group by b.agent_name, b.team;

#Return ticket counts by team with a derived column team_load such that teams with 5+ tickets are High Load, 2–4 are Medium Load,
#and 0–1 are Low Load. Include tickets with NULL agent_name in a bucket called No Team.
select b.agent_name, b.team, count(a.ticket_id) as ticket_count,
CASE 
WHEN count(a.ticket_id) >= 5 THEN "High Load"
WHEN (count(a.ticket_id) BETWEEN 2 AND 4) THEN "Medium Load"
WHEN count(a.ticket_id) >= 1 THEN "Low Load"
ELSE "No Team"
END as team_load
from support_tickets as a
right join agents as b
on a.agent_name=b.agent_name
group by b.agent_name, b.team;

#For each ticket, show priority, status, team, and a derived column attention_flag such that it is Immediate when priority is Urgent and status is not Resolved/Closed,
#Follow-up when priority is High and status is In Progress, otherwise Normal.
SELECT a.priority, a.status, b.team, a.ticket_id,
Case
WHEN status not in ("Resolved","Closed") and priority in ("Urgent") THEN "Immediate"
WHEN status in ("In Progress") and priority in ("High") THEN "Follow-Up"
ELSE "Normal"
END as attention_flag
from support_tickets as a
left join agents as b
on a.agent_name=b.agent_name
group by a.priority, a.status, b.team, a.ticket_id;

#List agents with the number of resolved tickets they handled and a derived column quality_flag such that
#it is Great when average satisfaction_score is >= 4, Ok when between 3 and 3.99, Needs Work when < 3, and No Ratings when the agent has no rated tickets.
SELECT b.agent_name, count(a.ticket_id),a.status, avg(satisfaction_score),
CASE 
WHEN avg(satisfaction_score) >= 4 THEN "GREAT"
WHEN avg(satisfaction_score) BETWEEN 3 AND 3.99 THEN "OK"
WHEN avg(satisfaction_score) < 3 THEN "NEEDS WORK"
ELSE "No Ratings"
END as quality_flag
from support_tickets as a
right JOIN agents as b
on b.agent_name=a.agent_name
where a.status = "Resolved"
group by b.agent_name,a.status;









