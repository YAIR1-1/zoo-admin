-- =============================================
-- קובץ Index.sql
-- =============================================

-- 1. אינדקס על עמודת תאריך הביקורת (audit_date)
-- בדיקת זמן ריצה לפני אינדקס:
EXPLAIN ANALYZE 
SELECT * FROM audit WHERE audit_date BETWEEN '2025-01-01' AND '2025-12-31';

-- יצירת האינדקס:
CREATE INDEX idx_audit_date ON audit(audit_date);

-- בדיקת זמן ריצה אחרי אינדקס:
EXPLAIN ANALYZE 
SELECT * FROM audit WHERE audit_date BETWEEN '2025-01-01' AND '2025-12-31';


-- 2. אינדקס על מפתח זר (project_id) בטבלת הביקורות
-- בדיקת זמן ריצה לפני אינדקס:
EXPLAIN ANALYZE 
SELECT * FROM audit WHERE project_id = 150;

-- יצירת האינדקס:
CREATE INDEX idx_audit_project_id ON audit(project_id);

-- בדיקת זמן ריצה אחרי אינדקס:
EXPLAIN ANALYZE 
SELECT * FROM audit WHERE project_id = 150;


-- 3. אינדקס על עמודת שם מחלקה (department_name)
-- בדיקת זמן ריצה לפני אינדקס:
EXPLAIN ANALYZE 
SELECT * FROM audit WHERE department_name = 'Operations';

-- יצירת האינדקס:
CREATE INDEX idx_audit_department ON audit(department_name);

-- בדיקת זמן ריצה אחרי אינדקס:
EXPLAIN ANALYZE 
SELECT * FROM audit WHERE department_name = 'Operations';