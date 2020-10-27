/* Ćwiczenia 4 - BDP - Dariusz Stopka */

/* 4 */
SELECT DISTINCT p.* INTO tableB FROM popp p, majrivers m
WHERE p.f_codedesc LIKE 'Building' AND ST_DISTANCE(p.geom, m.geom) < 100000;

SELECT COUNT(gid) FROM tableB;

/* 5 */
CREATE TABLE airportsNew (
    gid SERIAL PRIMARY KEY,
    name VARCHAR(50),
    geom geometry,
    elev numeric );

INSERT INTO airportsNew(name, geom, elev) SELECT name, geom, elev FROM airports;

SELECT airportsNew.*, ST_Y(geom) AS y FROM airportsNew
ORDER BY y DESC LIMIT 1;
SELECT airportsNew.*, ST_Y(geom) AS y FROM airportsNew
ORDER BY y LIMIT 1;

INSERT INTO airportsNew(name, geom, elev) VALUES
('airportB',
CONCAT('Point(',
	(SELECT
	((SELECT ST_Y(geom) FROM airportsNew ORDER BY ST_Y(geom) DESC LIMIT 1) +
	(SELECT ST_Y(geom) FROM airportsNew ORDER BY ST_Y(geom) LIMIT 1)) / 2),
	' ',
	(SELECT
	((SELECT ST_X(geom) AS x FROM airportsNew ORDER BY x DESC LIMIT 1) +
	(SELECT ST_X(geom) AS x FROM airportsNew ORDER BY x LIMIT 1)) / 2),
	')'),
500.00);

/* 6 */
SELECT ST_Area(ST_Buffer(ST_ShortestLine(a.geom,l.geom),1000)) FROM airports a, lakes l
WHERE a.name LIKE 'AMBLER' AND l.names LIKE 'Iliamna Lake';

/* 7 */
SELECT vegdesc, SUM(area_km2) as area FROM (SELECT vegdesc, trees.area_km2 FROM cw4.trees JOIN tundra ON trees.geom = tundra.geom) AS trees_tundra GROUP BY vegdesc;
SELECT vegdesc, SUM(area_km2) as area FROM (SELECT vegdesc, trees.area_km2 FROM cw4.trees JOIN swamp ON trees.geom = swamp.geom) AS trees_swamp GROUP BY vegdesc;