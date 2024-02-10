Use `sql_unversity_details`;

-- Binary Tree Nodes
SELECT BT.ID,
CASE
    WHEN BT.P_ID IS NULL THEN 'Root'
    WHEN EXISTS (SELECT B.P_ID FROM Tree B WHERE B.P_ID = BT.ID) THEN 'Inner'        
    ELSE 'Leaf'
END AS `NODE_TYPE`
FROM Tree AS BT 
ORDER BY BT.ID;
Select * from tree;

/*Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy:
Founder --> Lead Manager --> Senior Manager --> Manager --> Employee
Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers,
total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.

Note:

1. The tables may contain duplicate records.
2. The company_code is string, so the sorting should not be numeric. 
For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.*/

SELECT
  c.company_code,
  c.founder,
  count(distinct l.lead_manager_code) as no_of_lead_manager,
  count(distinct s.senior_manager_code) as no_of_senior_manager,
  count(distinct m.manager_code) as no_of_manager,
  count(distinct e.employee_code) as no_of_employee
FROM
  `Company Table` c
  LEFT JOIN `Lead_Manager Table` l ON c.company_code = l.company_code
  LEFT JOIN `Senior_Manager Table` s ON c.company_code = s.company_code
  AND l.lead_manager_code = s.lead_manager_code
  LEFT JOIN `Manager Table` m ON c.company_code = m.company_code
  AND l.lead_manager_code = m.lead_manager_code
  AND s.senior_manager_code = m.senior_manager_code
  LEFT JOIN `Employee Table` e ON c.company_code = e.company_code
  AND l.lead_manager_code = e.lead_manager_code
  AND s.senior_manager_code = e.senior_manager_code
  AND m.manager_code = e.manager_code
GROUP BY
  c.company_code,
  founder
ORDER BY
  c.company_code asc;
  
  
SET @d = 0, @p = 0, @s = 0, @a = 0;
SELECT Max(DOCTOR_NAMES), Max(PROFESSOR_NAMES), Max(SINGER_NAMES), Max(ACTOR_NAMES)
FROM
  (
    SELECT
      CASE WHEN OCCUPATION = 'Doctor' THEN NAME END AS DOCTOR_NAMES,
      CASE WHEN OCCUPATION = 'Professor' THEN NAME END AS PROFESSOR_NAMES,
      CASE WHEN OCCUPATION = 'Singer' THEN NAME END AS SINGER_NAMES,
      CASE WHEN OCCUPATION = 'Actor' THEN NAME END AS ACTOR_NAMES,
      CASE
        WHEN OCCUPATION = 'Doctor' THEN (@d := @d + 1)
        WHEN OCCUPATION = 'Professor' THEN (@p := @p + 1)
        WHEN OCCUPATION = 'Singer' THEN (@s := @s + 1)
        WHEN OCCUPATION = 'Actor' THEN (@a := @a + 1)
      END AS ROW_NUM
    FROM OCCUPATIONS
    ORDER BY NAME
  ) AS TEMP
GROUP BY ROW_NUM;

select
    Doctor,
    Professor,
    Singer,
    Actor
from (
    select
        NameOrder,
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
    from (
            select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations
         ) as NameLists
    group by NameOrder
    ) as Names;
    
    
    
    select
        NameOrder,
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
    from (
            select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations)as x;
	select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations;
            
	Select max(case Occupation when 'Doctor' then Name end) as Doctor from occupations;
    Select max(case when o.Occupation='Doctor' then o.Name end) as Doctor from occupations as o;
    Select * from occupations;
    
    
    
    Select * from sql_unversity_details.players;
    Select * from sql_unversity_details.goals;
    Select * from sql_unversity_details.countries;
    
-- -----------------------------------------------------------------------------------------------------------------------------







---------------------------------------    


With count_of_lead_manager_per_firm as (
	Select company_code,count(distinct lead_manager_code) as `count` from `lead_manager table`
    group by company_code),
count_of_senior_manager_per_firm as (
	Select lm.company_code,count(distinct senior_manager_code) as `count` from `lead_manager table` lm
    right join `senior_manager table` sm
    on lm.lead_manager_code=sm.lead_manager_code
    group by lm.company_code),
count_of_manager_per_firm as (
	Select sm.company_code,count(distinct manager_code) as `count` from `senior_manager table` sm
    right join `manager table` m
    on sm.senior_manager_code=m.senior_manager_code
    group by sm.company_code),
count_of_employee_per_firm as (
	Select m.company_code,count(distinct employee_code) as `count` from `manager table` m
    right join `employee table` e
    on m.manager_code=e.manager_code
    group by m.company_code)
Select concat(c.company_code,' ',c.founder,' ',lm.count,' ',sm.count,' ',m.count,' ',e.count) as 'count' from `company table` c
left join count_of_lead_manager_per_firm lm
on c.company_code=lm.company_code
left join count_of_senior_manager_per_firm sm
on lm.company_code=sm.company_code
left join count_of_manager_per_firm m
on sm.company_code=m.company_code
left join count_of_employee_per_firm e
on m.company_code=e.company_code;

Select  order_rank,
		min(CASE WHEN Occupation='Actor' THEN NAME END) AS 'ACTOR_NAME',
        min(CASE WHEN Occupation='Doctor' THEN NAME END) AS 'DOCTOR_NAME',
        min(CASE WHEN Occupation='Professor' THEN NAME END) AS 'PROFESSOR_NAME',
        min(CASE WHEN Occupation='Singer' THEN NAME END) AS'SINGER_NAME' from (
Select *,rank() over (partition by occupation order by name asc) as order_rank from occupations) as occupation group by order_rank;

Select *,rank() over (partition by occupation order by name asc) as order_rank from occupations group by order_rank;

Select * from triangles;

SELECT A,B,C,(CASE
			WHEN (A+B<C) OR (B+C<A) OR (A+C<B) THEN 'Not A Triangle'
			WHEN A=B AND B=C THEN 'Equilateral Triangle'
			WHEN (A=B AND B!=C) OR (B=C AND A!=C) OR (A=C AND B!=C) THEN 'Isoseles Triangle'
            ELSE 'Scalene Triangle'
            END) AS Triangle_Type FROM triangles;
            


Select name,sum(goals) as total_goals from goals g
left join countries c
on g.country_id=c.id
group by name
order by total_goals desc;

Select ID,(Case
				When P_ID Is NULL Then 'Root Node'
                When ID In (Select distinct(P_ID) from tree) Then 'Inner Node'
                When ID NOT In (Select distinct(P_ID) from tree where P_ID is not null) Then 'Leaf Node'
                END
) As NodeType from tree;

