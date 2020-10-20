/* 3) */
CREATE EXTENSION postgis;

/* 4) */
CREATE TABLE budynki(
    id SERIAL PRIMARY KEY,
    geometria GEOMETRY,
    nazwa VARCHAR(50)
);

CREATE TABLE drogi(
    id SERIAL PRIMARY KEY,
    geometria GEOMETRY,
    nazwa VARCHAR(50)
);

CREATE TABLE punkty_informacyjne(
    id SERIAL PRIMARY KEY,
    geometria GEOMETRY,
    nazwa VARCHAR(50)
);

/* 5) */
INSERT INTO budynki(geometria, nazwa) VALUES
(ST_GeomFromText('POLYGON((10.5 4, 10.5 1.5, 8 1.5, 8 4, 10.5 4))'), 'BuildingA'),
(ST_GeomFromText('POLYGON((6 7, 6 5, 4 5, 4 7, 6 7))'), 'BuildingB'),
(ST_GeomFromText('POLYGON((5 8, 5 6, 3 6, 3 8, 5 8))'), 'BuildingC'),
(ST_GeomFromText('POLYGON((10 9, 10 8, 9 8, 9 9, 10 9))'), 'BuildingD'),
(ST_GeomFromText('POLYGON((2 2, 2 1, 1 1, 1 2, 2 2))'), 'BuildingF');

INSERT INTO drogi(geometria, nazwa) VALUES
(ST_MakeLine(ST_GeomFromText('POINT(0 4.5)'), ST_GeomFromText('POINT(12 4.5)')), 'RoadX'),
(ST_MakeLine(ST_GeomFromText('POINT(7.5 0)'), ST_GeomFromText('POINT(7.5 10.5)')), 'RoadY');

INSERT INTO punkty_informacyjne(geometria, nazwa) VALUES
(ST_GeomFromText('POINT(1 3.5)'), 'G'),
(ST_GeomFromText('POINT(5.5 1.5)'), 'H'),
(ST_GeomFromText('POINT(9.5 6)'), 'I'),
(ST_GeomFromText('POINT(6.5 6)'), 'J'),
(ST_GeomFromText('POINT(6 9.5)'), 'K');

/* 6) */

SELECT SUM(ST_Length(geometria)) FROM drogi;

SELECT ST_AsText(geometria), ST_Area(geometria), ST_Length(ST_ExteriorRing(geometria)) FROM budynki WHERE nazwa LIKE 'BuildingA';

SELECT nazwa, ST_Area(geometria) FROM budynki ORDER BY nazwa;

SELECT nazwa, ST_Length(ST_ExteriorRing(geometria)) FROM budynki ORDER BY ST_Area(geometria) DESC LIMIT 2;

SELECT ST_Distance(b.geometria, p.geometria) FROM budynki b, punkty_informacyjne p WHERE b.nazwa LIKE 'BuildingC' AND p.nazwa LIKE 'G';

SELECT ST_Area(c.geometria) - ST_Area(ST_Intersection(ST_Buffer(b.geometria, 0.5),c.geometria)) FROM budynki b, budynki c WHERE b.nazwa LIKE 'BuildingB' AND c.nazwa LIKE 'BuildingC';



