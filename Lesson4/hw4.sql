--Домашняя работа 4
--Углубленный уровень SQL
--4.	Решите на базе данных AdventureWorks2017 следующие задачи. 

--a)	Изучите данные в таблице Production.UnitMeasure. Проверьте, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’. Сколько всего различных кодов здесь есть? 
--Вставьте следующий набор данных в таблицу:
--•	TT1, Test 1, 9 сентября 2020
--•	TT2, Test 2, getdate()

select *
from Production.UnitMeasure un
where un.UnitMeasureCode like 'T%' --left(un.UnitMeasureCode, 1) = 'T'

select count(distinct un.UnitMeasureCode)
from Production.UnitMeasure un

insert into Production.UnitMeasure values('TT1', 'Test 1', '2020-09-09')
insert into Production.UnitMeasure values('TT2', 'Test 2', GETDATE())

--insert into Production.UnitMeasure 
--select 'TT2', 'Test 2', GETDATE()

--Проверьте теперь, есть ли здесь UnitMeasureCode, начинающиеся на букву ‘Т’. 

--b)	Теперь загрузите вставленный набор в новую, не существующую таблицу Production.UnitMeasureTest. Догрузите сюда информацию из Production.UnitMeasure по UnitMeasureCode = ‘CAN’.  Посмотрите результат в отсортированном виде по коду. 
select *
into Production.UnitMeasureTest
from Production.UnitMeasure un
where un.UnitMeasureCode like 'T%' 

--c)	Измените UnitMeasureCode для всего набора из Production.UnitMeasureTest на ‘TTT’.
update Production.UnitMeasureTest set UnitMeasureCode = 'TTT'

select * from Production.UnitMeasureTest
--d)	Удалите все строки из Production.UnitMeasureTest.
delete from Production.UnitMeasureTest


--e)	Найдите информацию из Sales.SalesOrderDetail по заказам 43659,43664.  С помощью оконных функций MAX, MIN, AVG найдем агрегаты по LineTotal для каждого SalesOrderID.

select sod.SalesOrderID as [SalesOrderID], max(sod.LineTotal) as [max], min(sod.LineTotal) as [min], avg(sod.LineTotal) as [avg]
from sales.SalesOrderDetail sod
where sod.SalesOrderID in (43659, 43664)
group by sod.SalesOrderID

--f)	Изучите данные в объекте Sales.vSalesPerson. Создайте рейтинг cреди продавцов на основе годовых продаж SalesYTD, используя ранжирующую оконную функцию. 
--Добавьте поле Login, состоящий из 3 первых букв фамилии в верхнем регистре + ‘login’ + TerritoryGroup (Null заменить на пустое значение). 
--Кто возглавляет рейтинг? А кто возглавлял рейтинг в прошлом году (SalesLastYear). 
select upper(left(sp.LastName, 3)) as [login], isnull(sp.TerritoryGroup, '') as [TerritoryGroup], sp.LastName
, sp.SalesYTD, ROW_NUMBER() over(order by sp.SalesYTD desc) as [rank]
, sp.SalesLastYear, ROW_NUMBER() over(order by sp.SalesLastYear desc) as [rank_last_year] 
from sales.vSalesPerson sp
order by [rank]


--g)	Найдите первый будний день месяца (FROM не используем). Нужен стандартный код на все времена.
select case 
        when datename(weekday, dateadd(mm, datediff(mm, 0, getdate()), 0)) = 'saturday'
            then dateadd(mm, datediff(mm, 0, getdate()), 0) + 2 
        when datename(weekday, dateadd(mm, datediff(mm, 0, getdate()), 0)) = 'sunday'
            then dateadd(mm, datediff(mm, 0, getdate()), 0) + 1
        else dateadd(mm, datediff(mm, 0, getdate()), 0) 
        end, datename(weekday, dateadd(mm, datediff(mm, 0, getdate()), 0)) as day


--5.	 Давайте еще раз остановимся и отточим понимание функции count. Найдите значения count(1), count(name), count(id), count(*) для следующей таблицы:
--Id(PK)	Name		DepName
--1			null		A
--2			null		null
--3	A		C
--4	B		C

--Ответ: 
--count(1) = 4 -- возвращает общее количество записей (включая NULL)
--count(name) = 2
--count(id) = 4
--count(*) = 4 
