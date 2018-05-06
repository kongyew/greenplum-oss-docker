DROP TABLE IF EXISTS  testdblink
CREATE TABLE testdblink (a int, b text) DISTRIBUTED BY (a);
INSERT INTO testdblink VALUES (1, 'Cheese');

INSERT INTO testdblink VALUES (2, 'Fish');

INSERT INTO testdblink VALUES (3, 'Chicken');
