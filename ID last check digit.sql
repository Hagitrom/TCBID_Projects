---ID last check digit 
--A. Recursive cte - ROWS 6-33 (INSERT ID IN ROW 7)
--B. SUB QUERY - COLUMNS - ROWS - 35-67 (INSERT ID IN ROW 44)
--C ROWS  - 69-143 (INSERT ID IN ROW 70)

--SOLUTION 1 - ROWS: 7-33- (Insert first 8 ID digits in row 3, and run the script in rows 7-33 to find the last check digit)
declare @id  varchar(8) = '12345678'
;WITH CTE (num,digit,multiplier,mult,mult1) as 
		(select 1,Substring(@id,1,1),1,0,0
		union all
		select num+1,
		Substring(@id,1+num,1),
		case 
			when num%2 =0
			then
			1
			else
			2
		end,
		(digit)*(multiplier),
		case 
			when num=1
			then
			0
			when len(mult) =1
			then
			mult
			else
			 (cast (right (mult,1) as int)+cast (left (mult,1)as int))
		end
		from cte where num+1<11)
		select  @id as 'ID8', (ceiling (sum(mult1)*0.1))*10-sum (mult1) 'CHECK DIGIT 9'
		from cte   
---------------------------------------------------------------------------------------------------------------------------------
--SOLUTION 2 - ROWS: 37 -77- (Insert first 8 ID digits in row 44, and run the script in rows 37-67 to find the last check digit)

Drop table ID
---1. Create table ID
CREATE TABLE ID (
					#		INT		NOT NULL	IDENTITY(1,1),
					Digit	INT		NOT NULL,
					Parm	INT		NOT NULL)
---2. insert 3 columns into table ID : # (IDENTITY), DIGIT, MULTIPLIER (as 'Parm'
declare @id  varchar(8) = '12345678'
INSERT INTO ID (Digit,Parm)
VALUES 
		(Substring(@id,1,1),1),
		(Substring(@id,2,1),2),
		(Substring(@id,3,1),1),
		(Substring(@id,4,1),2),
		(Substring(@id,5,1),1),
		(Substring(@id,6,1),2),
		(Substring(@id,7,1),1),
		(Substring(@id,8,1),2)

--3 multiple column digit in table ID 

SELECT TOP 1 @id 'ID8', CEILD-SUMD AS 'Check Digit 9'
FROM
	(SELECT #,digit, parm, dp,mult,SUM(mult) over (order by # rows between unbounded preceding and unbounded following) as 'SUMD',
	ceiling(SUM(mult) over (order by # rows between unbounded preceding and unbounded following)*0.1)*10 as 'CEILD' 
	FROM 
			(SELECT #,digit, parm, digit*parm as 'dp',
			(CASE WHEN parm%2 = 1 or len(parm*digit)=1
			THEN digit*parm 
			ELSE (cast (right (digit*parm,1) as int)+cast (left (digit*parm,1)as int))
			END) mult FROM ID)TBL1)TBL2
----------------------------------------------------------------------------------------------------------------------
--SOLUTION 3 --FROM ROW 70 (Insert first 8 ID digits in row 70, and run the script in rows 70-143 to find the last check digit)
declare @id  varchar(8) = '12345678'
 select @id 'ID8', LEFT((ceiling((
							(Substring(@id,1,1)*1)+
							(CASE
								WHEN
								len (Substring(@id,2,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,2,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,2,1)*2,1)AS INT) 
								ELSE
								Substring(@id,2,1)*2
							END) +
							(Substring(@id,3,1)*1) +
							(CASE
								WHEN
								len (Substring(@id,4,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,4,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,4,1)*2,1)AS INT) 
								ELSE
								Substring(@id,4,1)*2
							END) +
								(Substring(@id,5,1)*1) +
							(CASE
								WHEN
								len (Substring(@id,6,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,6,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,6,1)*2,1)AS INT) 
								ELSE
								Substring(@id,6,1)*2
							END) +
							(Substring(@id,7,1)*1)+
							(CASE
								WHEN
								len (Substring(@id,8,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,8,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,8,1)*2,1)AS INT) 
								ELSE
								Substring(@id,8,1)*2
						END)) *0.1)*10.0)-
							((Substring(@id,1,1)*1)+
							(CASE
								WHEN
								len (Substring(@id,2,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,2,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,2,1)*2,1)AS INT) 
								ELSE
								Substring(@id,2,1)*2
							END) +
							(Substring(@id,3,1)*1) +
							(CASE
								WHEN
								len (Substring(@id,4,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,4,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,4,1)*2,1)AS INT) 
								ELSE
								Substring(@id,4,1)*2
							END) +
							(Substring(@id,5,1)*1) +
							(CASE
								WHEN
								len (Substring(@id,6,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,6,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,6,1)*2,1)AS INT) 
								ELSE
								Substring(@id,6,1)*2
							END) +
							(Substring(@id,7,1)*1)+
							(CASE
								WHEN
								len (Substring(@id,8,1)*2)=2 
								THEN 
								CAST(RIGHT(Substring(@id,8,1)*2,1)AS INT)+CAST (LEFT (Substring(@id,8,1)*2,1)AS INT) 
								ELSE
								Substring(@id,8,1)*2
							END) ),1) 'Check Digit 9'
---Row 39 -  left > decimal i.e. 2.0
--WHY???
---select ceiling(38*0.1)*10
----select ceiling (38/10)*10
