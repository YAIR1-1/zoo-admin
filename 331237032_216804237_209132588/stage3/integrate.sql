ALTER TABLE users RENAME TO Employees;
ALTER TABLE Employees RENAME COLUMN id TO Employee_ID;
ALTER TABLE Employees RENAME COLUMN name TO First_Name;
ALTER TABLE Employees ADD COLUMN Last_Name VARCHAR(50);
ALTER TABLE Employees ADD COLUMN manager_ID INT;

ALTER TABLE tickets RENAME TO Transactions;
ALTER TABLE Transactions RENAME COLUMN ticketid TO Transaction_ID;
ALTER TABLE Transactions RENAME COLUMN purchasedate TO Transaction_Date;
ALTER TABLE Transactions ADD COLUMN Payment_Method VARCHAR(50);
ALTER TABLE Transactions ADD COLUMN Total_Amount NUMERIC(10,2);
ALTER TABLE Transactions ADD COLUMN Employee_ID INT;
ALTER TABLE Transactions ADD COLUMN Manager_ID INT;

ALTER TABLE Employees DROP CONSTRAINT IF EXISTS fk_emp_manager;
ALTER TABLE Employees ADD CONSTRAINT fk_emp_manager FOREIGN KEY (manager_ID) REFERENCES manager(manager_id);

ALTER TABLE Transactions DROP CONSTRAINT IF EXISTS fk_trans_emp;
ALTER TABLE Transactions ADD CONSTRAINT fk_trans_emp FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID);

ALTER TABLE Transactions DROP CONSTRAINT IF EXISTS fk_trans_manager;
ALTER TABLE Transactions ADD CONSTRAINT fk_trans_manager FOREIGN KEY (Manager_ID) REFERENCES manager(manager_id);

CREATE TABLE IF NOT EXISTS Memberships (
    Membership_ID SERIAL PRIMARY KEY,
    Type VARCHAR(50),
    Expiry_Date DATE,
    Visitor_ID INT REFERENCES visitors(visitorid)
);

CREATE TABLE IF NOT EXISTS Ticket_Types (
    Ticket_ID SERIAL PRIMARY KEY,
    Ticket_Name VARCHAR(50),
    Category VARCHAR(50),
    Base_Price NUMERIC(10,2),
    Max_Capacity INT
);

CREATE TABLE IF NOT EXISTS Transaction_Items (
    Item_ID SERIAL PRIMARY KEY,
    Transaction_ID INT REFERENCES Transactions(Transaction_ID),
    Ticket_ID INT,
    Quantity INT,
    Price_At_Sale NUMERIC(10,2)
);

INSERT INTO Ticket_Types (Ticket_Name, Category, Base_Price, Max_Capacity)
VALUES
    ('כרטיס רגיל',   'General',  50.00, 500),
    ('כרטיס משפחה', 'Family',  150.00, 200),
    ('כרטיס מנוי',  'Member',   30.00, 300)
ON CONFLICT DO NOTHING;

INSERT INTO Employees (First_Name, Last_Name) 
VALUES ('Israel', 'Israeli'), ('Avi', 'Cohen')
ON CONFLICT DO NOTHING;

INSERT INTO Transactions (Transaction_Date, Payment_Method, Total_Amount, Visitor_ID, Employee_ID, Manager_ID)
VALUES
    ('2023-06-01', 'Credit Card', 100.00, 1, 1, 1),
    ('2023-06-05', 'Cash',         50.00, 2, 2, 1),
    ('2023-07-10', 'Credit Card', 150.00, 3, 1, 2)
ON CONFLICT DO NOTHING;

INSERT INTO Transaction_Items (Transaction_ID, Ticket_ID, Quantity, Price_At_Sale)
VALUES
    (1, 1, 2, 50.00),
    (2, 1, 1, 50.00),
    (3, 2, 1, 150.00)
ON CONFLICT DO NOTHING;

SELECT 'audit' AS table_name, COUNT(*) AS row_count FROM audit
UNION ALL
SELECT 'kpi', COUNT(*) FROM kpi
UNION ALL
SELECT 'manager', COUNT(*) FROM manager
UNION ALL
SELECT 'project', COUNT(*) FROM project
UNION ALL
SELECT 'report', COUNT(*) FROM report
UNION ALL
SELECT 'task', COUNT(*) FROM task
UNION ALL
SELECT 'visitors', COUNT(*) FROM visitors
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Transactions', COUNT(*) FROM Transactions
UNION ALL
SELECT 'Transaction_Items', COUNT(*) FROM Transaction_Items
UNION ALL
SELECT 'Ticket_Types', COUNT(*) FROM Ticket_Types
UNION ALL
SELECT 'Memberships', COUNT(*) FROM Memberships;