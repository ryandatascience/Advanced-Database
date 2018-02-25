--Q1--23 rows returned
SELECT DISTINCT p.firstname, p.lastname FROM players p, player_rs prs, teams t
WHERE p.ilkid = prs.ilkid AND prs.tid = t.tid AND t.location = 'Boston' 
AND EXISTS (SELECT t2.tid FROM teams t2, player_rs prs2 WHERE t2.location = 'Denver'
AND prs.ilkid = prs2.ilkid AND prs2.tid = t2.tid);

--Q2--48 rows returned
SELECT p.firstname, p.lastname FROM players p
WHERE p.first_season >= 1990 AND p.last_season <= 1992 
ORDER BY p.lastname, p.firstname;

--Q3--10 rows returned
SELECT DISTINCT p.firstname, p.lastname, p.year, t1.name, t2.name 
FROM player_rs p, coaches_season c, teams t1, teams t2 
WHERE p.ilkid = c.cid AND p.year = c.year AND p.tid != c.tid AND p.tid = t1.tid AND c.tid = t2.tid 
order by lastname;

--Q4--124 rows returned 
SELECT d.draft_year, d.draft_from FROM draft d 
GROUP BY d.draft_year, d.draft_from
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM draft d2 
						WHERE d.draft_year = d2.draft_year
						GROUP BY d2.draft_from);

--Q5--1 row
SELECT c.firstname, c.lastname, COUNT (DISTINCT c.tid) FROM coaches_season c 
WHERE c.year >= 1981 AND c.year <= 2004 
GROUP BY c.cid, c.firstname, c.lastname 
HAVING COUNT (DISTINCT c.tid) >= ALL (SELECT COUNT (DISTINCT c2.tid) FROM coaches_season c2     
									  WHERE c2.year >= 1981 AND c2.year <= 2004     
									  GROUP BY c2.cid);

--Q6--1 row
SELECT d.draft_from, COUNT(distinct d.ilkid) FROM draft d 
GROUP BY d.draft_from ORDER BY COUNT(distinct d.ilkid) DESC 
LIMIT 1 OFFSET 1;

--Q7--42 rows returned
SELECT DISTINCT c.firstname, c.lastname FROM coaches_season c
WHERE NOT EXISTS ((SELECT t.league FROM teams t) EXCEPT
(SELECT t1.league FROM teams t1 WHERE t1.tid = c.tid));

--Q8--42 rows returned
SELECT DISTINCT c.firstname, c.lastname FROM coaches_season c, teams t 
WHERE c.tid = t.tid GROUP BY c.cid, c.firstname, c.lastname
HAVING COUNT(DISTINCT t.league) = (SELECT COUNT(DISTINCT t1.league) FROM teams t1); 

--Q9--46 rows returned
SELECT DISTINCT t.name, prs.firstname, prs.lastname, p.height 
FROM player_rs prs, teams t, (SELECT ilkid, ((h_feet*30.48) + (h_inches*2.54)) AS height FROM players) AS p 
WHERE prs.ilkid = p.ilkid AND prs.tid = t.tid AND prs.league = t.league AND prs.year = 2003 
AND p.height >= ALL (SELECT ((p2.h_feet*30.48) + (p2.h_inches*2.54)) FROM player_rs prs2, players p2 
					 WHERE prs2.ilkid = p2.ilkid AND prs2.tid = prs.tid AND prs2.league = prs.league AND prs2.year = prs.year) 
					 ORDER BY t.name;

--Q10--5 rows returned
SELECT p.firstname, p.lastname, p.pts FROM player_rs_career p
GROUP BY p.ilkid, p.firstname, p.lastname, p.pts
ORDER BY p.pts DESC LIMIT 5;

--Q11--1 row
SELECT a.firstname, a.lastname, (CAST(a.pts AS FLOAT)/a.minutes) as efficiency
FROM (SELECT * FROM player_rs_career p WHERE p.minutes > 50) a
WHERE (CAST(a.pts AS FLOAT)/a.minutes)  = (SELECT MAX(CAST(b.pts AS FLOAT)/b.minutes) FROM
(SELECT * FROM player_rs_career p1 WHERE p1.minutes > 50) b);

--Q12--1 row
SELECT c.firstname, c.lastname, c.season_win 
FROM coaches_season c
WHERE (c.firstname like 'Phil' AND c.lastname like 'Jackson' AND c.year = 1994)
	  OR (c.firstname like 'Allan' AND c.lastname like 'Bristow' AND c.year = 1994)
ORDER BY c.season_win DESC
LIMIT 1;


