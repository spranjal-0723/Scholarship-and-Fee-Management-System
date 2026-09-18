SET SQLBLANKLINES ON;

-- SCHOLARSHIP AND FEE MANAGEMENT SYSTEM
-- DA-2 - DATABASE TABLE CREATION

CREATE TABLE DEPARTMENT (
    DeptID VARCHAR2(10) PRIMARY KEY,
    DeptName VARCHAR2(100) NOT NULL
);

CREATE TABLE PROGRAM (
    ProgramID VARCHAR2(10) PRIMARY KEY,
    ProgramName VARCHAR2(100) NOT NULL,
    DegreeLevel VARCHAR2(20) NOT NULL,
    DeptID VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_program_department
        FOREIGN KEY (DeptID)
        REFERENCES DEPARTMENT(DeptID)
);

CREATE TABLE STUDENT (
    StudentID VARCHAR2(10) PRIMARY KEY,
    StudentName VARCHAR2(100) NOT NULL,
    Phone VARCHAR2(15) NOT NULL,
    HouseNo VARCHAR2(20),
    Street VARCHAR2(100),
    City VARCHAR2(50),
    PIN VARCHAR2(10),
    ProgramID VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_student_program
        FOREIGN KEY (ProgramID)
        REFERENCES PROGRAM(ProgramID)
);

CREATE TABLE STUDENT_PROFILE (
    StudentID VARCHAR2(10) PRIMARY KEY,
    BloodGroup VARCHAR2(5),
    Nationality VARCHAR2(50),
    DateOfBirth DATE,
    Email VARCHAR2(100),
    CONSTRAINT fk_profile_student
        FOREIGN KEY (StudentID)
        REFERENCES STUDENT(StudentID)
);

CREATE TABLE GUARDIAN (
    GuardianID VARCHAR2(10) PRIMARY KEY,
    StudentID VARCHAR2(10) NOT NULL,
    GuardianName VARCHAR2(100) NOT NULL,
    Relation VARCHAR2(30),
    PhoneNo VARCHAR2(15),
    EmailID VARCHAR2(100),
    CONSTRAINT fk_guardian_student
        FOREIGN KEY (StudentID)
        REFERENCES STUDENT(StudentID)
);

CREATE TABLE SCHOLARSHIP_APPLICATION (
    ApplicationID VARCHAR2(10) PRIMARY KEY,
    StudentID VARCHAR2(10) NOT NULL,
    ApplicationDate DATE NOT NULL,
    ApplicationStatus VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_application_student
        FOREIGN KEY (StudentID)
        REFERENCES STUDENT(StudentID)
);

CREATE TABLE SCHOLARSHIP (
    ScholarshipID VARCHAR2(10) PRIMARY KEY,
    ApplicationID VARCHAR2(10) NOT NULL UNIQUE,
    ScholarshipType VARCHAR2(50) NOT NULL,
    Amount NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_scholarship_application
        FOREIGN KEY (ApplicationID)
        REFERENCES SCHOLARSHIP_APPLICATION(ApplicationID),
    CONSTRAINT chk_scholarship_amount
        CHECK (Amount >= 0)
);

CREATE TABLE BANK_ACCOUNT (
    AccountNo VARCHAR2(20) PRIMARY KEY,
    BankName VARCHAR2(100) NOT NULL,
    IFSC VARCHAR2(20) NOT NULL,
    AccountType VARCHAR2(30) NOT NULL
);

CREATE TABLE DISBURSEMENT (
    DisbursementID VARCHAR2(10) PRIMARY KEY,
    ScholarshipID VARCHAR2(10) NOT NULL,
    AccountNo VARCHAR2(20) NOT NULL,
    DisbursementDate DATE NOT NULL,
    Amount NUMBER(10,2) NOT NULL,
    DisbursementMode VARCHAR2(30) NOT NULL,
    CONSTRAINT fk_disbursement_scholarship
        FOREIGN KEY (ScholarshipID)
        REFERENCES SCHOLARSHIP(ScholarshipID),
    CONSTRAINT fk_disbursement_account
        FOREIGN KEY (AccountNo)
        REFERENCES BANK_ACCOUNT(AccountNo),
    CONSTRAINT chk_disbursement_amount
        CHECK (Amount >= 0)
);

CREATE TABLE STUDENT_FEE (
    FeeID VARCHAR2(10) PRIMARY KEY,
    StudentID VARCHAR2(10) NOT NULL,
    FeeAmount NUMBER(10,2) NOT NULL,
    DueDate DATE NOT NULL,
    CONSTRAINT fk_fee_student
        FOREIGN KEY (StudentID)
        REFERENCES STUDENT(StudentID),
    CONSTRAINT chk_fee_amount
        CHECK (FeeAmount >= 0)
);

CREATE TABLE PAYMENT_METHOD (
    MethodID VARCHAR2(10) PRIMARY KEY,
    MethodName VARCHAR2(50) NOT NULL
);

CREATE TABLE FEE_PAYMENT (
    PaymentID VARCHAR2(10) PRIMARY KEY,
    FeeID VARCHAR2(10) NOT NULL,
    ScholarshipID VARCHAR2(10),
    MethodID VARCHAR2(10) NOT NULL,
    PaymentDate DATE NOT NULL,
    AmountPaid NUMBER(10,2) NOT NULL,
    TransactionID VARCHAR2(30) NOT NULL UNIQUE,
    CONSTRAINT fk_payment_fee
        FOREIGN KEY (FeeID)
        REFERENCES STUDENT_FEE(FeeID),
    CONSTRAINT fk_payment_scholarship
        FOREIGN KEY (ScholarshipID)
        REFERENCES SCHOLARSHIP(ScholarshipID),
    CONSTRAINT fk_payment_method
        FOREIGN KEY (MethodID)
        REFERENCES PAYMENT_METHOD(MethodID),
    CONSTRAINT chk_payment_amount
        CHECK (AmountPaid >= 0)
);