DROP TABLE IF EXISTS regr_example;
CREATE TABLE regr_example (
   id int,
   y int,
   x1 int,
   x2 int
);
INSERT INTO regr_example VALUES
   (1,  5, 2, 3),
   (2, 10, 7, 2),
   (3,  6, 4, 1),
   (4,  8, 3, 4);


DROP TABLE IF EXISTS  testdblink
CREATE TABLE testdblink (a int, b text) DISTRIBUTED BY (a);

INSERT INTO testdblink VALUES (1, 'Cheese');

INSERT INTO testdblink VALUES (2, 'Fish');

INSERT INTO testdblink VALUES (3, 'Chicken');
