USE Northwind
GO
--- Create table + insert values - please run rows- 7-19
--- Solution  - please run rows -24-55, Names - 76-80
 

create table #Elevator 
(id int, name varchar(6), weight int, turn int)
GO
insert into #Elevator (id, name, weight, turn)
values (1, 'alon', 100, 1),
(2,'ali',80, 3),
(3,'nadav',70, 5),
(4,'yaron',65, 2),
(5,'chen',82, 6),
(6,'dor',45, 4),
(7,'moshe',78, 8),
(8,'hagit',90, 7),
(9,'hadas',120, 9)

SELECT * FROM #Elevator
order by turn
--------------------------------------
---num - # of ride
----mult - comulative weight per ride
WITH CTE (A,num, mult) AS
					(
					SELECT 1,1,WEIGHT FROM #Elevator WHERE turn=1
					UNION ALL
					(SELECT A+1, 
						(case when 
						((SELECT WEIGHT FROM #Elevator WHERE turn=(A+1))+(MULT))>250  
						then
						num+1
						else
						num
						END), 
						(case 
						WHEN ((SELECT WEIGHT FROM #Elevator WHERE turn=(A+1))+(MULT))>250  
						then
						(SELECT WEIGHT FROM #Elevator WHERE turn=(A+1))
						else
						(SELECT WEIGHT FROM #Elevator WHERE turn=(A+1))+mult
						END)
					from CTE where a<9
					))			
--select * from  #elevator join CTE
--on A=TURN
--ORDER BY TURN

select num as '#Ride', max(Kg) Kg
from(
select max (mult) over (partition by num order by num) Kg, NUM , mult, name
from  #elevator join CTE
on A=TURN)tbl1
group by num
-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------
--up to 250 Kg

--alon , yaron , ali - 245
--dor  , nada , chen - 197
--hagit , moshe 
--hadas  

--1 ali
--2 chen
--3 moshe
--4 hadas 

--window function 
--cte recursive 
--case when 
 --5 point in the last grade 

 select  * , lag(weight ,1 )  over ( order by turn ) ,
 sum (weight ) over ( order by turn  
 rows between unbounded preceding 
 and current row ) 
 from #Elevator


