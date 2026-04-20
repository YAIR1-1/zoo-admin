-- =============================================
-- קובץ Constraints.sql
-- =============================================

-- 1. אילוץ: תאריך סיום פרויקט חייב להיות אחרי תאריך ההתחלה
ALTER TABLE PROJECT 
ADD CONSTRAINT chk_project_dates CHECK (end_date >= start_date);

-- בדיקת שגיאה לאילוץ 1
INSERT INTO PROJECT (project_id, project_name, start_date, end_date, budget, status, manager_id) 
VALUES (99991, 'Time Travel Project', '2025-12-31', '2024-01-01', 50000, 'Pending', 1);


-- 2. אילוץ: ערך KPI בפועל לא יכול להיות שלילי
ALTER TABLE KPI 
ADD CONSTRAINT chk_actual_positive CHECK (actual_value >= 0);

-- בדיקת שגיאה לאילוץ 2
INSERT INTO KPI (kpi_id, project_id, metric_name, target_value, actual_value) 
VALUES (99992, 101, 'Budget Efficiency', 100, -15);


-- 3. אילוץ: מניעת כפילות של שם פרויקט
ALTER TABLE PROJECT 
ADD CONSTRAINT uni_project_name UNIQUE (project_name);

-- בדיקת שגיאה לאילוץ 3
-- תחילה הכנסה של פרויקט תקין
INSERT INTO PROJECT (project_id, project_name, start_date, end_date, budget, status, manager_id) 
VALUES (99993, 'Zoo Expansion 2026', '2026-01-01', '2026-12-31', 100000, 'Active', 1);

-- ניסיון להכניס פרויקט נוסף עם אותו השם בדיוק
INSERT INTO PROJECT (project_id, project_name, start_date, end_date, budget, status, manager_id) 
VALUES (99994, 'Zoo Expansion 2026', '2027-01-01', '2027-12-31', 200000, 'Pending', 2);