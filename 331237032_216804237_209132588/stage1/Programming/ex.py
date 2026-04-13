import csv
import random
from faker import Faker
from datetime import timedelta

fake = Faker()

# הגדרת כמות הרשומות לפי דרישות המטלה
NUM_MANAGERS = 500
NUM_PROJECTS = 500
NUM_REPORTS = 500
NUM_KPIS = 500
NUM_TASKS = 20000
NUM_AUDITS = 20000

print("מתחיל לייצר נתונים. זה עשוי לקחת כמה שניות...")

# --- 1. MANAGER ---
with open('MANAGER.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['manager_id', 'first_name', 'last_name', 'email', 'phone', 'hire_date', 'seniority_level'])
    for i in range(1, NUM_MANAGERS + 1):
        # הוספת ה-ID לאימייל כדי להבטיח ייחודיות (UNIQUE constraint)
        email = f"mgr{i}_{fake.email()}"
        writer.writerow([
            i,
            fake.first_name(),
            fake.last_name(),
            email,
            fake.numerify('05########'),
            fake.date_between(start_date='-5y', end_date='today'),
            random.choice(['Junior', 'Mid', 'Senior', 'Executive'])
        ])
print("MANAGER.csv נוצר (500 רשומות)")

# --- 2. PROJECT ---
with open('PROJECT.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['project_id', 'project_name', 'description', 'start_date', 'end_date', 'budget', 'status', 'manager_id'])
    for i in range(1, NUM_PROJECTS + 1):
        start_date = fake.date_between(start_date='-2y', end_date='today')
        end_date = start_date + timedelta(days=random.randint(30, 365))
        writer.writerow([
            i,
            fake.catch_phrase(),
            fake.sentence(nb_words=6),
            start_date,
            end_date,
            round(random.uniform(10000, 500000), 2),
            random.choice(['Planning', 'Active', 'On Hold', 'Completed']),
            random.randint(1, NUM_MANAGERS) # מפתח זר
        ])
print("PROJECT.csv נוצר (500 רשומות)")

# --- 3. TASK (20,000 Records) ---
with open('TASK.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['task_id', 'task_name', 'description', 'due_date', 'priority', 'status', 'project_id'])
    for i in range(1, NUM_TASKS + 1):
        writer.writerow([
            i,
            fake.bs(),
            fake.sentence(nb_words=8),
            fake.date_between(start_date='today', end_date='+1y'),
            random.choice(['Low', 'Medium', 'High']), # חייב להתאים ל-CHECK ב-SQL
            random.choice(['Open', 'In Progress', 'Completed', 'Cancelled']), # חייב להתאים ל-CHECK
            random.randint(1, NUM_PROJECTS) # מפתח זר
        ])
print("TASK.csv נוצר (20,000 רשומות)")

# --- 4. REPORT ---
with open('REPORT.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['report_id', 'report_name', 'report_date', 'department_name', 'report_type', 'summary', 'manager_id'])
    for i in range(1, NUM_REPORTS + 1):
        writer.writerow([
            i,
            f"Report {fake.word()}",
            fake.date_this_year(),
            random.choice(['Operations', 'Logistics', 'Analytics', 'Veterinary', 'HR']),
            random.choice(['Weekly', 'Monthly', 'Annual', 'Incident']),
            fake.text(max_nb_chars=100),
            random.randint(1, NUM_MANAGERS) # מפתח זר
        ])
print("REPORT.csv נוצר (500 רשומות)")

# --- 5. KPI ---
with open('KPI.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['kpi_id', 'kpi_name', 'department_name', 'target_value', 'actual_value', 'measurement_date', 'unit', 'project_id'])
    for i in range(1, NUM_KPIS + 1):
        target = round(random.uniform(50, 100), 2)
        actual = round(target * random.uniform(0.8, 1.1), 2) # תוצאה הגיונית קרובה ליעד
        writer.writerow([
            i,
            f"KPI {fake.word()}",
            random.choice(['Operations', 'Logistics', 'Analytics']),
            target,
            actual,
            fake.date_this_month(),
            random.choice(['Percent', 'Days', 'Count', 'USD']),
            random.randint(1, NUM_PROJECTS) # מפתח זר
        ])
print("KPI.csv נוצר (500 רשומות)")

# --- 6. AUDIT (20,000 Records) ---
with open('AUDIT.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['audit_id', 'audit_date', 'department_name', 'finding', 'severity', 'status', 'manager_id', 'project_id'])
    for i in range(1, NUM_AUDITS + 1):
        writer.writerow([
            i,
            fake.date_this_year(),
            random.choice(['Operations', 'Logistics', 'Analytics', 'Veterinary']),
            fake.sentence(nb_words=5),
            random.choice(['Low', 'Medium', 'High', 'Critical']), # חייב להתאים ל-CHECK
            random.choice(['Open', 'In Review', 'Closed']), # חייב להתאים ל-CHECK
            random.randint(1, NUM_MANAGERS), # מפתח זר
            random.randint(1, NUM_PROJECTS)  # מפתח זר
        ])
print("AUDIT.csv נוצר (20,000 רשומות)")

print("\nסיימתי בהצלחה! 6 קובצי CSV מחכים לך בתיקייה.")