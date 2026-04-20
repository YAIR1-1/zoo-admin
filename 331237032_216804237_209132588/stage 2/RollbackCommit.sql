BEGIN;


SELECT manager_id, first_name FROM manager WHERE manager_id = 1;


UPDATE manager SET first_name = 'Yair' WHERE manager_id = 1;

SELECT manager_id, first_name FROM manager WHERE manager_id = 1;


COMMIT;

SELECT manager_id, first_name FROM manager WHERE manager_id = 1;