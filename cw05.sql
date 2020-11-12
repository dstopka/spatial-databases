/* 1) */

CREATE TABLE obiekty(
id SERIAL PRIMARY KEY,
nazwa text,
geometria geometry
);

/* a. */

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt1', ST_Collect(Array[
	'LINESTRING(0 1, 1 1)',
	'CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1)',
	'LINESTRING(5 1, 6 1)'
]));

/* b. */

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt2', ST_Collect(ARRAY[
 	'LINESTRING(10 2, 10 6, 14 6)',
 	'CIRCULARSTRING(14 6, 16 4, 14 2)',
 	'CIRCULARSTRING(14 2, 12 0, 10 2)',
 	ST_Buffer(ST_MakePoint(12, 2), 1)
]));
 
/* c. */

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt3', ST_MakePolygon('LINESTRING(7 15, 10 17, 12 13, 7 15)')
);

/* d. */

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt4', ST_GeomFromText(
	'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)', 0)
);

/* e. */

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt5', ST_Collect(
	ST_MakePoint(30, 30, 59), 
	ST_MakePoint(38, 32, 234)
));

/* f. */

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt6', ST_Collect(
	ST_MakeLine(ST_MakePoint(1, 1), ST_MakePoint(3, 2)),
	ST_MakePoint(4, 2)
));

/* 2) */

SELECT ST_Area(ST_Buffer( ST_ShortestLine(a.geometria, b.geometria), 5))
FROM obiekty a, obiekty b
WHERE a.nazwa='obiekt3' and b.nazwa='obiekt4';

/* 3) */

UPDATE obiekty SET geometria = ST_MakePolygon(ST_AddPoint(geometria, ST_StartPoint(geometria))) WHERE nazwa LIKE 'obiekt4';

/* 4) */

INSERT INTO obiekty(nazwa, geom)
VALUES
('obiekt7', ST_Collect((SELECT geometria FROM obiekty WHERE nazwa='obiekt3'), (SELECT geometria FROM obiekty WHERE nazwa='obiekt4')));

/* 5) */

SELECT SUM(ST_Area(ST_Buffer(geometria, 5)))
FROM obiekty 
WHERE ST_HasArc(geometria)=FALSE;

