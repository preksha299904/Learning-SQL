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

#Show each ticket with a derived column assignment_state such that it is Unassigned when agent_name is NULL, otherwise Assigned.
SELECT customer_name,
CASE  
WHEN agent_name is null THEN "Unassigned"
ELSE "Assigned"
END as Assignment_state
FROM support_tickets;

#Show each ticket with a derived column urgency_bucket based on priority where Urgent stays Urgent, High becomes High, and everything else becomes Normal.
SELECT ticket_id, customer_name,
CASE 
WHEN priority= "Urgent" THEN "Urgent"
WHEN priority = "High" THEN "High"
ELSE "Normal"
END as Urgency_bucket
from support_tickets;

#Show each ticket with a derived column resolution_sla where tickets with resolution_hours <= 12 are Within 12h, 13–24 are Within 24h, more than 24 are Over 24h, and tickets not resolved yet (NULL) are Pending.
SELECT ticket_id, customer_name,
CASE 
WHEN resolution_hours <= 12 THEN "Within 12h"
WHEN resolution_hours between 13 and 24 THEN "Within 24h"
WHEN resolution_hours > 24 THEN "Over 24h"
ELSE "Pending"
END as resolution_sla
from support_tickets;

#Show each ticket with a derived column csat_label where satisfaction_score 5 is Excellent, 4 is Good, 3 is Average, 2 is Poor, 1 is Bad, and NULL is Not Rated.
SELECT ticket_id, customer_name,
CASE satisfaction_score
WHEN 5 THEN "Excellent"
WHEN 4 THEN "Good"
WHEN 3 THEN "Average"
WHEN 2 THEN "Poor"
WHEN 1 THEN "Bad"
ELSE "Null"
End as csat_label
from support_tickets;

#Return ticket counts by channel, plus a derived column channel_type where Chat is Live, Phone is Live, and Email is Async.
SELECT count(*),channel,
CASE channel
WHEN "chat" THEN "Live"
when "phone" THEN "Live"
WHEN "Email" then "Async"
ELSE "Null"
END as channel_type
from support_tickets
group by channel;

#For each agent_name (exclude NULL agents), return total resolved tickets and a derived column performance_flag where agents with 3 or more resolved tickets are Top Performer, otherwise Needs Improvement.
SELECT agent_name, count(status),
CASE 
WHEN count(status) >= 3 THEN "Top Performer"
ELSE "Needs Improvement"
END as performance_flag
from support_tickets
where status="Resolved"
group by agent_name, status;


#Show each ticket with a derived column status_group where Open and In Progress map to Active, and Resolved and Closed map to Completed.
SELECT ticket_id, customer_name,status,
CASE 
WHEN status in ("Open","In Progress") THEN "Active"
WHEN status in ("Closed","Resolved")  THEN "Completed"
ELSE "NULL"
END as status_group
from support_tickets;








