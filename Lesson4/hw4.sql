--�������� ������ 4
--����������� ������� SQL
--4.	������ �� ���� ������ AdventureWorks2017 ��������� ������. 

--a)	������� ������ � ������� Production.UnitMeasure. ���������, ���� �� ����� UnitMeasureCode, ������������ �� ����� �Ғ. ������� ����� ��������� ����� ����� ����? 
--�������� ��������� ����� ������ � �������:
--�	TT1, Test 1, 9 �������� 2020
--�	TT2, Test 2, getdate()

select *
from Production.UnitMeasure un
where un.UnitMeasureCode like 'T%' --left(un.UnitMeasureCode, 1) = 'T'

select count(distinct un.UnitMeasureCode)
from Production.UnitMeasure un

insert into Production.UnitMeasure values('TT1', 'Test 1', '2020-09-09')
insert into Production.UnitMeasure values('TT2', 'Test 2', GETDATE())

--insert into Production.UnitMeasure 
--select 'TT2', 'Test 2', GETDATE()

--��������� ������, ���� �� ����� UnitMeasureCode, ������������ �� ����� �Ғ. 

--b)	������ ��������� ����������� ����� � �����, �� ������������ ������� Production.UnitMeasureTest. ��������� ���� ���������� �� Production.UnitMeasure �� UnitMeasureCode = �CAN�.  ���������� ��������� � ��������������� ���� �� ����. 
select *
into Production.UnitMeasureTest
from Production.UnitMeasure un
where un.UnitMeasureCode like 'T%' 

--c)	�������� UnitMeasureCode ��� ����� ������ �� Production.UnitMeasureTest �� �TTT�.
update Production.UnitMeasureTest set UnitMeasureCode = 'TTT'

select * from Production.UnitMeasureTest
--d)	������� ��� ������ �� Production.UnitMeasureTest.
delete from Production.UnitMeasureTest


--e)	������� ���������� �� Sales.SalesOrderDetail �� ������� 43659,43664.  � ������� ������� ������� MAX, MIN, AVG ������ �������� �� LineTotal ��� ������� SalesOrderID.

select sod.SalesOrderID as [SalesOrderID], max(sod.LineTotal) as [max], min(sod.LineTotal) as [min], avg(sod.LineTotal) as [avg]
from sales.SalesOrderDetail sod
where sod.SalesOrderID in (43659, 43664)
group by sod.SalesOrderID

--f)	������� ������ � ������� Sales.vSalesPerson. �������� ������� c���� ��������� �� ������ ������� ������ SalesYTD, ��������� ����������� ������� �������. 
--�������� ���� Login, ��������� �� 3 ������ ���� ������� � ������� �������� + �login� + TerritoryGroup (Null �������� �� ������ ��������). 
--��� ����������� �������? � ��� ���������� ������� � ������� ���� (SalesLastYear). 
select upper(left(sp.LastName, 3)) as [login], isnull(sp.TerritoryGroup, '') as [TerritoryGroup], sp.LastName
, sp.SalesYTD, ROW_NUMBER() over(order by sp.SalesYTD desc) as [rank]
, sp.SalesLastYear, ROW_NUMBER() over(order by sp.SalesLastYear desc) as [rank_last_year] 
from sales.vSalesPerson sp
order by [rank]


--g)	������� ������ ������ ���� ������ (FROM �� ����������). ����� ����������� ��� �� ��� �������.
select case 
        when datename(weekday, dateadd(mm, datediff(mm, 0, getdate()), 0)) = 'saturday'
            then dateadd(mm, datediff(mm, 0, getdate()), 0) + 2 
        when datename(weekday, dateadd(mm, datediff(mm, 0, getdate()), 0)) = 'sunday'
            then dateadd(mm, datediff(mm, 0, getdate()), 0) + 1
        else dateadd(mm, datediff(mm, 0, getdate()), 0) 
        end, datename(weekday, dateadd(mm, datediff(mm, 0, getdate()), 0)) as day


--5.	 ������� ��� ��� ����������� � ������� ��������� ������� count. ������� �������� count(1), count(name), count(id), count(*) ��� ��������� �������:
--Id(PK)	Name		DepName
--1			null		A
--2			null		null
--3	A		C
--4	B		C

--�����: 
--count(1) = 4 -- ���������� ����� ���������� ������� (������� NULL)
--count(name) = 2
--count(id) = 4
--count(*) = 4 
