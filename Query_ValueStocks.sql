WITH cte_1 as
(SELECT *,
MOD(fiscal_year,10000) this_year,
LAG(MOD(fiscal_year,10000)) OVER (PARTITION BY company) as Prev_add1,
MOD(fiscal_year,10000)-LAG(MOD(fiscal_year,10000)) OVER (PARTITION BY company) as diff
FROM dividend), cte_2 as
(SELECT *,
(CASE WHEN diff= 1 THEN
SUM(diff) OVER (PARTITION BY company rows between current row and 1 following) 
END) as count
FROM cte_1)

-- select * from cte_2; 

SELECT array_agg (DISTINCT company || ' ') as valuestocks
FROM cte_2
WHERE
	count=2
;
