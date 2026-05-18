-- ====================================================================
-- מבט 1: נקודת המבט של האגף המקורי (פרויקטים ומנהלים)
-- המבט מציג איזה מנהל אחראי על איזה פרויקט ואת הסטטוס שלו
-- ====================================================================
CREATE OR REPLACE VIEW Manager_Projects_View AS
SELECT m.first_name AS Manager_First_Name, 
       m.last_name AS Manager_Last_Name, 
       p.project_name, 
       p.status
FROM manager m
JOIN project p ON m.manager_id = p.manager_id;

-- שאילתה 1.1: שליפת כל הפרויקטים הפעילים ('Active') בלבד מתוך המבט
SELECT * FROM Manager_Projects_View 
WHERE status = 'Active';

-- שאילתה 1.2: ספירה כמה פרויקטים יש לכל מנהל
SELECT Manager_First_Name, Manager_Last_Name, COUNT(project_name) AS Total_Projects 
FROM Manager_Projects_View 
GROUP BY Manager_First_Name, Manager_Last_Name;


-- ====================================================================
-- מבט 2: נקודת המבט של אגף השותפים (מבקרים ומנויים)
-- המבט מציג את שמות המבקרים ופרטי המנוי (Membership) שלהם
-- ====================================================================
CREATE OR REPLACE VIEW Visitor_Memberships_View AS
SELECT v.firstname, 
       v.lastname, 
       m.Type AS Membership_Type, 
       m.Expiry_Date
FROM visitors v
JOIN Memberships m ON v.visitorid = m.Visitor_ID;

-- שאילתה 2.1: שליפת המבקרים שיש להם מנוי מסוג 'Family'
SELECT * FROM Visitor_Memberships_View 
WHERE Membership_Type = 'Family';

-- שאילתה 2.2: חלוקת המנויים לפי סוג וכמות מכל סוג
SELECT Membership_Type, COUNT(*) AS Total_Members 
FROM Visitor_Memberships_View 
GROUP BY Membership_Type;


-- ====================================================================
-- מבט 3: מבט אינטגרציה (עובדים ועסקאות) - חובה להשתמש בטבלאות משני האגפים
-- המבט מציג אילו עובדים (מהמערכת החדשה) ביצעו עסקאות, ומתי
-- ====================================================================
CREATE OR REPLACE VIEW Employee_Sales_View AS
SELECT e.First_Name AS Employee_Name, 
       e.Last_Name AS Employee_Last_Name,
       t.Transaction_Date, 
       t.Total_Amount,
       t.Payment_Method
FROM Employees e
JOIN Transactions t ON e.Employee_ID = t.Employee_ID;

-- שאילתה 3.1: הצגת כל העסקאות שבוצעו במזומן ('Cash') מתוך המבט
SELECT * FROM Employee_Sales_View 
WHERE Payment_Method = 'Cash';

-- שאילתה 3.2: סיכום סך כל ההכנסות (Total_Amount) שכל עובד ייצר
SELECT Employee_Name, Employee_Last_Name, SUM(Total_Amount) AS Total_Revenue 
FROM Employee_Sales_View 
GROUP BY Employee_Name, Employee_Last_Name;