-- =============================================
-- קובץ Queries.sql
-- =============================================

-- שאילתות UPDATE 

-- 1. קידום מנהלים ותיקים
SELECT manager_id, first_name, last_name, hire_date, seniority_level 
FROM manager 
WHERE hire_date < '2023-01-01' AND seniority_level = 'Junior';

UPDATE manager 
SET seniority_level = 'Senior' 
WHERE hire_date < '2023-01-01' AND seniority_level = 'Junior';

-- 2. סגירת משימות בפרויקטים שהסתיימו
SELECT task_id, task_name, status, project_id 
FROM task 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Completed');

UPDATE task 
SET status = 'Completed' 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Completed');

-- 3. הפחתת תקציב לפרויקטים עם ביקורות חמורות
SELECT project_id, project_name, budget 
FROM project 
WHERE project_id IN (SELECT project_id FROM audit WHERE severity = 'High');

UPDATE project 
SET budget = budget * 0.9 
WHERE project_id IN (SELECT project_id FROM audit WHERE severity = 'High');


-- שאילתות DELETE 

-- 1. מחיקת דוחות ישנים
SELECT report_id, report_name, report_date 
FROM report 
WHERE report_date < '2024-01-01';

DELETE FROM report 
WHERE report_date < '2024-01-01';

-- 2. מחיקת ביקורות סגורות בחומרה נמוכה
SELECT audit_id, department_name, severity, status 
FROM audit 
WHERE status = 'Closed' AND severity = 'Low';

DELETE FROM audit 
WHERE status = 'Closed' AND severity = 'Low';

-- 3. מחיקת משימות ללא פרויקט פעיל
SELECT task_id, task_name, project_id 
FROM task 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Pending' AND start_date < '2024-01-01');

DELETE FROM task 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Pending' AND start_date < '2024-01-01');