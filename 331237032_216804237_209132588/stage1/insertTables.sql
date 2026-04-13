INSERT INTO MANAGER (manager_id, first_name, last_name, email, phone, hire_date, seniority_level) VALUES
(1, 'Noa', 'Levi', 'noa.levi@example.com', '0501234567', '2021-03-10', 'Senior'),
(2, 'Dan', 'Cohen', 'dan.cohen@example.com', '0529876543', '2020-06-15', 'Mid'),
(3, 'Maya', 'Aviv', 'maya.aviv@example.com', '0534567890', '2022-01-20', 'Junior');

INSERT INTO PROJECT (project_id, project_name, description, start_date, end_date, budget, status, manager_id) VALUES
(101, 'Zoo Expansion', 'Expansion of animal habitats', '2024-01-01', '2024-12-31', 250000.00, 'Active', 1),
(102, 'Visitor Analytics', 'Improving visitor flow analysis', '2024-02-01', '2024-10-31', 120000.00, 'Planning', 2),
(103, 'Food Supply Optimization', 'Optimization of animal food logistics', '2024-03-01', '2024-11-30', 80000.00, 'Active', 3);

INSERT INTO TASK (task_id, task_name, description, due_date, priority, status, project_id) VALUES
(1001, 'Design habitats', 'Prepare initial habitat design', '2024-03-15', 'High', 'Open', 101),
(1002, 'Install sensors', 'Install movement sensors in visitor areas', '2024-04-01', 'Medium', 'In Progress', 102),
(1003, 'Map suppliers', 'Create supplier map and logistics routes', '2024-05-10', 'Low', 'Completed', 103);

INSERT INTO REPORT (report_id, report_name, report_date, department_name, report_type, summary, manager_id) VALUES
(201, 'Monthly Operations', '2024-03-31', 'Operations', 'Monthly', 'Monthly management summary', 1),
(202, 'Visitor Trends', '2024-03-31', 'Analytics', 'Performance', 'Visitor trend analysis', 2),
(203, 'Food Logistics Report', '2024-03-31', 'Logistics', 'Monthly', 'Food supply efficiency report', 3);

INSERT INTO KPI (kpi_id, kpi_name, department_name, target_value, actual_value, measurement_date, unit, project_id) VALUES
(301, 'Completion Rate', 'Operations', 90.00, 82.00, '2024-03-31', 'Percent', 101),
(302, 'Visitor Satisfaction', 'Analytics', 95.00, 91.50, '2024-03-31', 'Percent', 102),
(303, 'Delivery Accuracy', 'Logistics', 98.00, 96.20, '2024-03-31', 'Percent', 103);

INSERT INTO AUDIT (audit_id, audit_date, department_name, finding, severity, status, manager_id, project_id) VALUES
(401, '2024-04-10', 'Operations', 'Minor delay in implementation', 'Medium', 'Open', 1, 101),
(402, '2024-04-12', 'Analytics', 'Incomplete reporting procedure', 'High', 'In Review', 2, 102),
(403, '2024-04-15', 'Logistics', 'Stock count mismatch found', 'Low', 'Closed', 3, 103);