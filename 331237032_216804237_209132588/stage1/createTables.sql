CREATE TABLE MANAGER (
    manager_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL,
    seniority_level VARCHAR(30) NOT NULL
);

CREATE TABLE PROJECT (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    budget NUMERIC(12,2) NOT NULL CHECK (budget >= 0),
    status VARCHAR(30) NOT NULL,
    manager_id INT NOT NULL,
    CONSTRAINT fk_project_manager
        FOREIGN KEY (manager_id) REFERENCES MANAGER(manager_id),
    CONSTRAINT chk_project_dates
        CHECK (end_date >= start_date)
);

CREATE TABLE TASK (
    task_id INT PRIMARY KEY,
    task_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    due_date DATE NOT NULL,
    priority VARCHAR(20) NOT NULL CHECK (priority IN ('Low', 'Medium', 'High')),
    status VARCHAR(30) NOT NULL CHECK (status IN ('Open', 'In Progress', 'Completed', 'Cancelled')),
    project_id INT NOT NULL,
    CONSTRAINT fk_task_project
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id)
);

CREATE TABLE REPORT (
    report_id INT PRIMARY KEY,
    report_name VARCHAR(100) NOT NULL,
    report_date DATE NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    summary VARCHAR(255) NOT NULL,
    manager_id INT NOT NULL,
    CONSTRAINT fk_report_manager
        FOREIGN KEY (manager_id) REFERENCES MANAGER(manager_id)
);

CREATE TABLE KPI (
    kpi_id INT PRIMARY KEY,
    kpi_name VARCHAR(100) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    target_value NUMERIC(10,2) NOT NULL CHECK (target_value >= 0),
    actual_value NUMERIC(10,2) NOT NULL CHECK (actual_value >= 0),
    measurement_date DATE NOT NULL,
    unit VARCHAR(30) NOT NULL,
    project_id INT NOT NULL,
    CONSTRAINT fk_kpi_project
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id)
);

CREATE TABLE AUDIT (
    audit_id INT PRIMARY KEY,
    audit_date DATE NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    finding VARCHAR(255) NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
    status VARCHAR(30) NOT NULL CHECK (status IN ('Open', 'In Review', 'Closed')),
    manager_id INT NOT NULL,
    project_id INT NOT NULL,
    CONSTRAINT fk_audit_manager
        FOREIGN KEY (manager_id) REFERENCES MANAGER(manager_id),
    CONSTRAINT fk_audit_project
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id)
);