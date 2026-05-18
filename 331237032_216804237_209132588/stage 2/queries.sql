-- =============================================
-- קובץ Queries.sql
-- =============================================

-- =============================================
-- שאילתות SELECT
-- =============================================

-- שאילתה 1: 
-- מציגה רשימה ייחודית (ללא כפילויות) של מנהלים והפרויקטים שלהם, 
-- שבהם יש לפחות משימה אחת שעדיין לא הושלמה.
SELECT DISTINCT m.first_name, m.last_name, p.project_name
FROM manager m
JOIN project p ON m.manager_id = p.manager_id
JOIN task t ON p.project_id = t.project_id
WHERE t.status != 'Completed'; -- מסנן ומביא רק משימות שאינן בסטטוס "הושלם"


-- שאילתה 2: 
-- מבצעת את אותה פעולה כמו השאילתה הקודמת (מציגה מנהלים ופרויקטים עם משימות פתוחות),
-- אך משתמשת ב-EXISTS במקום ב-JOIN. דרך זו לרוב יעילה יותר ומונעת כפילויות ללא צורך ב-DISTINCT.
SELECT m.first_name, m.last_name, p.project_name
FROM manager m
JOIN project p ON m.manager_id = p.manager_id
WHERE EXISTS ( -- בודק האם תת-השאילתה מחזירה לפחות רשומה אחת (כלומר, האם קיימת משימה פתוחה לפרויקט)
    SELECT 1 
    FROM task t 
    WHERE t.project_id = p.project_id 
    AND t.status != 'Completed'
);


-- שאילתה 3: 
-- מציגה את שם הפרויקט, חודש ההתחלה שלו, וכמות המשימות שנמצאות באיחור, 
-- עבור פרויקטים שהתחילו בשנה הנוכחית. השאילתה סופרת את המשימות בעזרת תת-שאילתה (Correlated Subquery).
SELECT 
    p.project_name,
    EXTRACT(MONTH FROM p.start_date) AS start_month, -- מחלץ רק את החודש מתוך תאריך ההתחלה
    (SELECT COUNT(*) 
     FROM task t 
     WHERE t.project_id = p.project_id 
     AND t.due_date < CURRENT_DATE -- בודק אם תאריך היעד קטן מהתאריך של היום (כלומר, המשימה באיחור)
     AND t.status != 'Completed') AS delayed_tasks_count
FROM project p
WHERE EXTRACT(YEAR FROM p.start_date) = EXTRACT(YEAR FROM CURRENT_DATE); -- מסנן כך שיוצגו רק פרויקטים של השנה הנוכחית


-- שאילתה 4: 
-- מבצעת בדיוק את אותה משימה כמו שאילתה 3 (ספירת משימות באיחור לפרויקטים של השנה הנוכחית), 
-- אבל משתמשת ב-LEFT JOIN ו-GROUP BY. לרוב גישה זו נחשבת אופטימלית ויעילה יותר לביצוע במסדי נתונים.
SELECT 
    p.project_name,
    EXTRACT(MONTH FROM p.start_date) AS start_month,
    COUNT(t.task_id) AS delayed_tasks_count -- סופר את המזהים של המשימות שחזרו מה-JOIN
FROM project p
LEFT JOIN task t ON p.project_id = t.project_id 
    AND t.due_date < CURRENT_DATE -- התנאי הזה בתוך ה-JOIN מבטיח שנחבר רק משימות שבאיחור (אחרת יחזור NULL)
    AND t.status != 'Completed'
WHERE EXTRACT(YEAR FROM p.start_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY p.project_id, p.project_name, EXTRACT(MONTH FROM p.start_date); -- קיבוץ התוצאות לפי הפרויקט כדי שנוכל לבצע את הספירה (COUNT)


-- =============================================
-- שאילתות UPDATE 
-- =============================================

-- 1. קידום מנהלים ותיקים
-- השאילתה הראשונה (SELECT) מציגה את המנהלים שמיועדים לקידום לשם בקרה.
SELECT manager_id, first_name, last_name, hire_date, seniority_level 
FROM manager 
WHERE hire_date < '2023-01-01' AND seniority_level = 'Junior';

-- השאילתה השנייה (UPDATE) מקדמת בפועל מנהלים בדרגת Junior שהחלו לעבוד לפני 2023 לדרגת Senior.
UPDATE manager 
SET seniority_level = 'Senior' 
WHERE hire_date < '2023-01-01' AND seniority_level = 'Junior';


-- 2. סגירת משימות בפרויקטים שהסתיימו
-- השאילתה הראשונה (SELECT) מציגה את המשימות שפתוחות תחת פרויקטים שכבר הסתיימו.
SELECT task_id, task_name, status, project_id 
FROM task 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Completed');

-- השאילתה השנייה (UPDATE) מסמנת כ"הושלמו" (Completed) את כל המשימות ששייכות לפרויקטים שהסתיימו.
UPDATE task 
SET status = 'Completed' 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Completed'); -- תת-השאילתה מביאה את מזהי הפרויקטים שהסתיימו


-- 3. הפחתת תקציב לפרויקטים עם ביקורות חמורות
-- השאילתה הראשונה (SELECT) מציגה פרויקטים שקיבלו ביקורת בדרגת חומרה 'High'.
SELECT project_id, project_name, budget 
FROM project 
WHERE project_id IN (SELECT project_id FROM audit WHERE severity = 'High');

-- השאילתה השנייה (UPDATE) חותכת 10% מהתקציב של פרויקטים אלו.
UPDATE project 
SET budget = budget * 0.9 -- הכפלת התקציב ב-0.9 למעשה מפחיתה 10% מערכו הנוכחי
WHERE project_id IN (SELECT project_id FROM audit WHERE severity = 'High');


-- =============================================
-- שאילתות DELETE 
-- =============================================

-- 1. מחיקת דוחות ישנים
-- השאילתה הראשונה מציגה את הדוחות הישנים שיימחקו.
SELECT report_id, report_name, report_date 
FROM report 
WHERE report_date < '2024-01-01';

-- השאילתה השנייה מוחקת מהמערכת כל דוח שהתאריך שלו קודם לשנת 2024.
DELETE FROM report 
WHERE report_date < '2024-01-01';


-- 2. מחיקת ביקורות סגורות בחומרה נמוכה
-- השאילתה הראשונה מציגה את הביקורות שעומדות בקריטריונים למחיקה.
SELECT audit_id, department_name, severity, status 
FROM audit 
WHERE status = 'Closed' AND severity = 'Low';

-- השאילתה השנייה מוחקת ביקורות (audits) שגם טופלו ונסגרו (Closed) וגם החומרה שלהן נמוכה (Low).
DELETE FROM audit 
WHERE status = 'Closed' AND severity = 'Low';


-- 3. מחיקת משימות ללא פרויקט פעיל
-- השאילתה הראשונה מציגה משימות השייכות לפרויקטים ישנים שנתקעו בסטטוס "ממתין".
SELECT task_id, task_name, project_id 
FROM task 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Pending' AND start_date < '2024-01-01');

-- השאילתה השנייה מוחקת משימות אשר משויכות לפרויקטים שנפתחו לפני שנת 2024 ועדיין מוגדרים כ"ממתינים" (Pending).
DELETE FROM task 
WHERE project_id IN (SELECT project_id FROM project WHERE status = 'Pending' AND start_date < '2024-01-01'); -- תת-השאילתה מאתרת את מזהי הפרויקטים התקועים
