use orders;

CREATE TABLE colors (
  color_id INT PRIMARY KEY,
  color_name VARCHAR(20) NOT NULL
);

CREATE TABLE sizes (
  size_id INT PRIMARY KEY,
  size_label VARCHAR(10) NOT NULL
);

INSERT INTO colors (color_id, color_name) VALUES
(1, 'Red'),
(2, 'Green'),
(3, 'Blue'),
(4, 'Black');

INSERT INTO sizes (size_id, size_label) VALUES
(1, 'S'),
(2, 'M'),
(3, 'L'),
(4, 'XL');

select * from colors;
select * from sizes;

#Generate all possible combinations of color_name and size_label. Show color_name, size_label.
select * 
from colors 
cross join sizes;

#From all color–size combinations, return only those where the color is in (Red, Black) and the size is not in (S). Show color_name, size_label.
select c.color_name , s.size_label
from colors as c
cross join sizes as s
where c.color_name in ("Red","Black")  AND s.size_label not in ("s"); 

#Return all combinations of color_name and size_label, ordered by color_name ascending and size_label descending.
select c.color_name , s.size_label
from colors as c
cross join sizes as s
order by c.color_name asc, s.size_label desc;

#Treat each combination as a potential product variant and assign a synthetic SKU like COLOR-SIZE using string concatenation. Show sku (e.g., Red-M), color_name, size_label.

SELECT CONCAT(c.color_name, '-', s.size_label) AS sku,
       c.color_name, s.size_label
FROM colors c
CROSS JOIN sizes s
ORDER BY sku;
#ye topic padhna hai


#Count how many total combinations are possible between colors and sizes using a query (do not manually count). Return a single row with a column called total_combinations.
select count(*)
from colors as c
cross join sizes as s;


#Assume all combinations of colors and sizes are available but “small” (S) is not produced in Green or Blue. Return all possible combinations except (Green,S) and (Blue,S).
select c.color_name , s.size_label
from colors as c
cross join sizes as s
where not (c.color_name in ("green","Blue") and s.size_label = ("s")); 


