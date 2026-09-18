# Scholarship and Fee Management System --- DA-2

## DA-2: SQL and PL/SQL Implementation

This document contains the documentation for **DA-2** of the Scholarship
and Fee Management System.

DA-2 focuses on implementing the database designed in DA-1 using
**Oracle SQL, PL/SQL, and a Flask backend**.

------------------------------------------------------------------------

## Team Responsibilities --- DA-2

  Member     DA-2 Responsibility
  ---------- ------------------------------------------------
  Member 1   Frontend / UI
  Member 2   Oracle Database, SQL, PL/SQL and Flask Backend
  Member 3   Frontend ↔ Flask API Integration

------------------------------------------------------------------------

# Technology Stack

-   **Database:** Oracle Database Free
-   **Database Environment:** Docker
-   **Database Programming:** SQL and PL/SQL
-   **Backend:** Python + Flask
-   **Oracle Driver:** `oracledb`
-   **API:** REST + JSON
-   **Frontend Integration:** HTML/CSS/JavaScript
-   **Version Control:** Git + GitHub

------------------------------------------------------------------------

# DA-2 Architecture

``` text
                    USER
                      |
                      v
             +----------------+
             |    FRONTEND    |
             |  HTML/CSS/JS   |
             +-------+--------+
                     |
                  HTTP/JSON
                     |
                     v
             +----------------+
             |   FLASK API    |
             +-------+--------+
                     |
               python-oracledb
                     |
                     v
             +----------------+
             | ORACLE DATABASE|
             |   FREEPDB1     |
             +----------------+
```

------------------------------------------------------------------------

# DA-2 Database Schema

The DA-2 implementation contains the following 12 main relations:

1.  `DEPARTMENT`
2.  `PROGRAM`
3.  `STUDENT`
4.  `STUDENT_PROFILE`
5.  `GUARDIAN`
6.  `SCHOLARSHIP_APPLICATION`
7.  `SCHOLARSHIP`
8.  `BANK_ACCOUNT`
9.  `DISBURSEMENT`
10. `STUDENT_FEE`
11. `PAYMENT_METHOD`
12. `FEE_PAYMENT`

The database uses:

-   Primary keys
-   Foreign keys
-   Unique constraints
-   Check constraints
-   Business-rule validation

------------------------------------------------------------------------

# DA-2 SQL Files

## 01_create_tables.sql

Creates the 12 main tables and their primary/foreign-key relationships.

## 02_constraints.sql

Adds business-rule constraints:

-   Application status must be `Pending`, `Approved`, or `Rejected`
-   Fee due date is required
-   Disbursement mode must be `Bank Transfer` or `Direct Transfer`
-   Payment method names must be unique

## 03_sample_data.sql

Inserts sample data for:

-   Departments
-   Programs
-   Students
-   Student profiles
-   Guardians
-   Scholarship applications
-   Scholarships
-   Bank accounts
-   Disbursements
-   Student fees
-   Payment methods
-   Fee payments

## 04_queries.sql

Contains 20 SQL queries covering:

-   Student and academic information
-   Scholarship applications
-   Approved scholarships
-   Scholarship totals
-   Fee analysis
-   Payment details
-   Outstanding fees
-   Department-wise student counts
-   Pending applications
-   Highest scholarship
-   Disbursement totals
-   Payment method totals
-   Applications without disbursement

## 05_views.sql

Creates the following views:

-   `VW_STUDENT_ACADEMIC`
-   `VW_SCHOLARSHIP_APPLICATION`
-   `VW_STUDENT_FEE_SUMMARY`
-   `VW_DISBURSEMENT_DETAILS`
-   `VW_PENDING_APPLICATIONS`

## 06_plsql.sql

Contains:

-   `P_STUDENT_FEE_STATUS`
-   `F_OUTSTANDING_FEE`
-   `P_APPROVED_SCHOLARSHIPS`
-   `TRG_CHECK_FEE_PAYMENT`

The trigger prevents total payments for a fee from exceeding the fee
amount.

------------------------------------------------------------------------

# Oracle / Docker Setup

The DA-2 implementation uses an Oracle Free Docker container.

``` text
Container: oracle-free
Port: 1521
PDB: FREEPDB1
Username: system
```

## Check Oracle

``` bash
docker ps
```

## Start Oracle

``` bash
docker start oracle-free
```

## Connect to Oracle

``` bash
docker exec -it oracle-free sqlplus system/oracle@FREEPDB1
```

> The password above is for the current local development setup.
> Database credentials should not be placed in frontend code or
> committed as secrets.

------------------------------------------------------------------------

# Flask Backend

The Flask backend is located in:

``` text
backend/
├── app.py
├── db.py
└── requirements.txt
```

## Start the backend

``` bash
cd ~/Desktop/Scholarship-and-Fee-Management-System/backend
source venv/bin/activate
python app.py
```

The API runs at:

``` text
http://127.0.0.1:5000
```

------------------------------------------------------------------------

# Backend Database Connection

`db.py` uses environment variables for database configuration:

``` python
DB_USER = os.getenv("ORACLE_USER", "system")
DB_PASSWORD = os.getenv("ORACLE_PASSWORD", "oracle")
DB_DSN = os.getenv("ORACLE_DSN", "localhost:1521/FREEPDB1")
```

This allows the database configuration to be changed without modifying
the application code.

------------------------------------------------------------------------

# DA-2 REST APIs

## Base URL

``` text
http://127.0.0.1:5000
```

## Health Check

### GET `/`

Checks whether the Flask API is running.

------------------------------------------------------------------------

## Student APIs

### GET `/api/students`

Returns all students with program and department information.

### POST `/api/students`

Adds a student.

Example:

``` json
{
  "student_id": "S006",
  "student_name": "New Student",
  "phone": "9876543210",
  "house_no": "12",
  "street": "Main Street",
  "city": "Chennai",
  "pin": "600001",
  "program_id": "P01"
}
```

Required fields:

``` text
student_id
student_name
phone
program_id
```

### GET `/api/students/<student_id>`

Returns details of one student.

### GET `/api/students/<student_id>/scholarships`

Returns scholarship information for a student.

### GET `/api/students/<student_id>/fees`

Returns fee information including paid and outstanding amounts.

### GET `/api/students/<student_id>/payments`

Returns payments associated with a student's fees.

------------------------------------------------------------------------

# Scholarship Application APIs

### GET `/api/applications`

Returns all scholarship applications.

### POST `/api/applications`

Creates a new scholarship application.

Example:

``` json
{
  "application_id": "APP006",
  "student_id": "S001",
  "application_date": "2026-09-18"
}
```

New applications are created with:

``` text
ApplicationStatus = Pending
```

### PUT `/api/applications/<application_id>/status`

Updates an application's status.

Example:

``` json
{
  "status": "Approved"
}
```

Allowed values:

``` text
Pending
Approved
Rejected
```

------------------------------------------------------------------------

# Scholarship APIs

### GET `/api/scholarships`

Returns scholarship records.

### POST `/api/scholarships`

Creates a scholarship.

Example:

``` json
{
  "scholarship_id": "SCH006",
  "application_id": "APP001",
  "scholarship_type": "Merit",
  "amount": 30000
}
```

Business rule:

> A scholarship can only be created for an **Approved** application.

------------------------------------------------------------------------

# Disbursement APIs

### GET `/api/disbursements`

Returns disbursement records.

### POST `/api/disbursements`

Creates a disbursement.

Example:

``` json
{
  "disbursement_id": "DIS005",
  "scholarship_id": "SCH001",
  "account_no": "AC001",
  "disbursement_date": "2026-09-18",
  "amount": 50000,
  "disbursement_mode": "Bank Transfer"
}
```

Allowed modes:

``` text
Bank Transfer
Direct Transfer
```

------------------------------------------------------------------------

# Fee APIs

### GET `/api/fees`

Returns student fee records including:

-   Fee amount
-   Amount paid
-   Outstanding amount
-   Due date

### POST `/api/fees`

Creates a student fee.

Example:

``` json
{
  "fee_id": "F006",
  "student_id": "S001",
  "fee_amount": 75000,
  "due_date": "2026-10-15"
}
```

Rules:

-   Student must exist.
-   Fee amount cannot be negative.
-   Due date is required.

------------------------------------------------------------------------

# Payment APIs

### GET `/api/payments`

Returns fee payment records.

### POST `/api/payments`

Creates a fee payment.

Example:

``` json
{
  "payment_id": "PAY006",
  "fee_id": "F001",
  "scholarship_id": null,
  "method_id": "M01",
  "payment_date": "2026-09-18",
  "amount_paid": 10000,
  "transaction_id": "TXN10001"
}
```

Sample payment methods:

``` text
M01 → UPI
M02 → Net Banking
M03 → Credit Card
M04 → Debit Card
```

The Oracle trigger `TRG_CHECK_FEE_PAYMENT` prevents payments from
exceeding the total fee amount.

------------------------------------------------------------------------

# Dashboard API

### GET `/api/dashboard`

Returns system-wide statistics.

Example:

``` json
{
  "total_students": 5,
  "total_scholarships": 5,
  "total_scholarship_amount": 180000,
  "total_fees": 380000,
  "total_paid": 100000,
  "total_outstanding": 280000,
  "pending_applications": 1,
  "approved_applications": 3
}
```

------------------------------------------------------------------------

# API Endpoint Summary

  Method   Endpoint                            Purpose
  -------- ----------------------------------- ---------------------------
  GET      `/`                                 API health check
  GET      `/api/students`                     Get students
  POST     `/api/students`                     Add student
  GET      `/api/students/<id>`                Get student
  GET      `/api/applications`                 Get applications
  POST     `/api/applications`                 Submit application
  PUT      `/api/applications/<id>/status`     Update application status
  GET      `/api/students/<id>/scholarships`   Student scholarships
  GET      `/api/scholarships`                 Get scholarships
  POST     `/api/scholarships`                 Create scholarship
  GET      `/api/disbursements`                Get disbursements
  POST     `/api/disbursements`                Create disbursement
  GET      `/api/fees`                         Get fees
  POST     `/api/fees`                         Create fee
  GET      `/api/students/<id>/fees`           Student fees
  GET      `/api/payments`                     Get payments
  POST     `/api/payments`                     Make payment
  GET      `/api/students/<id>/payments`       Student payments
  GET      `/api/dashboard`                    Dashboard statistics

------------------------------------------------------------------------

# DA-2 Business Rules

The implementation validates:

1.  Student must exist before creating a fee.
2.  Application status must be `Pending`, `Approved`, or `Rejected`.
3.  Scholarship can only be created for an approved application.
4.  Bank account must exist before creating a disbursement.
5.  Disbursement mode must be `Bank Transfer` or `Direct Transfer`.
6.  Fee amount cannot be negative.
7.  Fee due date is required.
8.  Payment amount cannot cause total payments to exceed the fee amount.
9.  Payment transaction ID must be unique.
10. Payment method name must be unique.

------------------------------------------------------------------------

# DA-2 Error Handling

Examples of API validation errors:

``` text
Student not found
Application not found
Status must be Pending, Approved, or Rejected
Scholarship can only be created for an approved application
Bank account not found
Disbursement mode must be Bank Transfer or Direct Transfer
Fee amount cannot be negative
Payment exceeds the total fee amount
```

------------------------------------------------------------------------

# DA-2 Testing

The backend and database were tested using both successful and invalid
requests.

## Successful Tests

-   Student retrieval
-   Application retrieval
-   Scholarship retrieval
-   Disbursement retrieval
-   Fee retrieval
-   Payment retrieval
-   Dashboard statistics
-   Student-specific scholarship API
-   Student-specific fee API
-   Student-specific payment API
-   Student creation
-   Application creation
-   Application status update
-   Scholarship creation
-   Disbursement creation
-   Fee creation
-   Payment creation

## Negative Tests

The following validation cases were tested successfully:

-   Non-existent student
-   Invalid application status
-   Non-existent application
-   Scholarship for a pending application
-   Non-existent bank account
-   Invalid disbursement mode
-   Fee for a non-existent student
-   Negative fee amount
-   Payment exceeding the fee amount

------------------------------------------------------------------------

# Current Database Test Baseline

After cleanup of temporary test records:

``` text
Students:                 5
Scholarships:             5
Scholarship amount:   ₹1,80,000
Total fees:           ₹3,80,000
Total paid:           ₹1,00,000
Outstanding:          ₹2,80,000
Pending applications:     1
Approved applications:    3
```

These values can be used to verify the dashboard.

------------------------------------------------------------------------

# Running the Complete DA-2 Application

## Terminal 1 --- Oracle

``` bash
docker ps
```

If necessary:

``` bash
docker start oracle-free
```

## Terminal 2 --- Flask

``` bash
cd ~/Desktop/Scholarship-and-Fee-Management-System/backend
source venv/bin/activate
python app.py
```

## Terminal 3 --- Frontend

``` bash
cd ~/Desktop/Scholarship-and-Fee-Management-System
python3 -m http.server 5500
```

Open:

``` text
http://127.0.0.1:5500
```

------------------------------------------------------------------------

# Git / DA-2 Version Control

The DA-2 backend/database implementation was developed on:

``` text
feature/backend-database
```

and merged into:

``` text
main
```

The frontend/API integration was developed on:

``` text
feature/member3-frontend-integration
```

and merged into:

``` text
main
```

The repository uses `.gitignore` to exclude local files such as:

``` text
backend/venv/
__pycache__/
.env
```

------------------------------------------------------------------------

# DA-2 Deliverables

The completed DA-2 implementation includes:

-   Oracle database implementation
-   12 normalized relations
-   Primary keys
-   Foreign keys
-   Unique constraints
-   Check constraints
-   Sample data
-   20 SQL queries
-   5 database views
-   PL/SQL procedures
-   PL/SQL function
-   PL/SQL trigger
-   Flask REST APIs
-   Oracle-Python integration
-   API validation
-   Error handling
-   Dashboard statistics
-   Frontend/API integration
-   Git/GitHub version control

------------------------------------------------------------------------

## DA-2 Status

**SQL + PL/SQL Database Implementation:** Completed\
**Flask Backend:** Completed\
**REST API:** Completed\
**Frontend/API Integration:** Completed\
**Backend and API Testing:** Completed\
**GitHub Integration:** Completed
