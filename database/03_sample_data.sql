-- ============================================
-- SAMPLE DATA FOR SCHOLARSHIP AND FEE SYSTEM
-- ============================================

-- 1. DEPARTMENT
INSERT INTO DEPARTMENT (DeptID, DeptName)
VALUES ('D01', 'Computer Science');

INSERT INTO DEPARTMENT (DeptID, DeptName)
VALUES ('D02', 'Electronics');

INSERT INTO DEPARTMENT (DeptID, DeptName)
VALUES ('D03', 'Mechanical Engineering');


-- 2. PROGRAM
INSERT INTO PROGRAM (ProgramID, ProgramName, DegreeLevel, DeptID)
VALUES ('P01', 'Computer Science and Engineering', 'BTech', 'D01');

INSERT INTO PROGRAM (ProgramID, ProgramName, DegreeLevel, DeptID)
VALUES ('P02', 'Electronics and Communication Engineering', 'BTech', 'D02');

INSERT INTO PROGRAM (ProgramID, ProgramName, DegreeLevel, DeptID)
VALUES ('P03', 'Mechanical Engineering', 'BTech', 'D03');


-- 3. STUDENT
INSERT INTO STUDENT
(StudentID, StudentName, Phone, HouseNo, Street, City, PIN, ProgramID)
VALUES
('S001', 'Aarav Sharma', '9876543210', '12A', 'MG Road', 'Chennai', '600001', 'P01');

INSERT INTO STUDENT
(StudentID, StudentName, Phone, HouseNo, Street, City, PIN, ProgramID)
VALUES
('S002', 'Priya Nair', '9876543211', '24B', 'Anna Nagar', 'Chennai', '600040', 'P02');

INSERT INTO STUDENT
(StudentID, StudentName, Phone, HouseNo, Street, City, PIN, ProgramID)
VALUES
('S003', 'Rahul Verma', '9876543212', '15C', 'Gandhi Road', 'Chennai', '600020', 'P03');

INSERT INTO STUDENT
(StudentID, StudentName, Phone, HouseNo, Street, City, PIN, ProgramID)
VALUES
('S004', 'Ananya Singh', '9876543213', '8D', 'OMR Road', 'Chennai', '600096', 'P01');

INSERT INTO STUDENT
(StudentID, StudentName, Phone, HouseNo, Street, City, PIN, ProgramID)
VALUES
('S005', 'Karan Patel', '9876543214', '17E', 'Velachery Road', 'Chennai', '600042', 'P02');


-- 4. STUDENT_PROFILE
INSERT INTO STUDENT_PROFILE
(StudentID, BloodGroup, Nationality, DateOfBirth, Email)
VALUES
('S001', 'O+', 'Indian', DATE '2006-05-14', 'aarav@example.com');

INSERT INTO STUDENT_PROFILE
(StudentID, BloodGroup, Nationality, DateOfBirth, Email)
VALUES
('S002', 'A+', 'Indian', DATE '2005-11-22', 'priya@example.com');

INSERT INTO STUDENT_PROFILE
(StudentID, BloodGroup, Nationality, DateOfBirth, Email)
VALUES
('S003', 'B+', 'Indian', DATE '2006-02-18', 'rahul@example.com');

INSERT INTO STUDENT_PROFILE
(StudentID, BloodGroup, Nationality, DateOfBirth, Email)
VALUES
('S004', 'AB+', 'Indian', DATE '2006-08-30', 'ananya@example.com');

INSERT INTO STUDENT_PROFILE
(StudentID, BloodGroup, Nationality, DateOfBirth, Email)
VALUES
('S005', 'O-', 'Indian', DATE '2005-12-10', 'karan@example.com');


-- 5. GUARDIAN
INSERT INTO GUARDIAN
(GuardianID, StudentID, GuardianName, Relation, PhoneNo, EmailID)
VALUES
('G001', 'S001', 'Ramesh Sharma', 'Father', '9876500010', 'ramesh@example.com');

INSERT INTO GUARDIAN
(GuardianID, StudentID, GuardianName, Relation, PhoneNo, EmailID)
VALUES
('G002', 'S002', 'Suresh Nair', 'Father', '9876500011', 'suresh@example.com');

INSERT INTO GUARDIAN
(GuardianID, StudentID, GuardianName, Relation, PhoneNo, EmailID)
VALUES
('G003', 'S003', 'Mahesh Verma', 'Father', '9876500012', 'mahesh@example.com');

INSERT INTO GUARDIAN
(GuardianID, StudentID, GuardianName, Relation, PhoneNo, EmailID)
VALUES
('G004', 'S004', 'Rajesh Singh', 'Father', '9876500013', 'rajesh@example.com');

INSERT INTO GUARDIAN
(GuardianID, StudentID, GuardianName, Relation, PhoneNo, EmailID)
VALUES
('G005', 'S005', 'Dinesh Patel', 'Father', '9876500014', 'dinesh@example.com');


-- 6. SCHOLARSHIP_APPLICATION
INSERT INTO SCHOLARSHIP_APPLICATION
(ApplicationID, StudentID, ApplicationDate, ApplicationStatus)
VALUES
('APP001', 'S001', DATE '2026-01-10', 'Approved');

INSERT INTO SCHOLARSHIP_APPLICATION
(ApplicationID, StudentID, ApplicationDate, ApplicationStatus)
VALUES
('APP002', 'S002', DATE '2026-01-12', 'Pending');

INSERT INTO SCHOLARSHIP_APPLICATION
(ApplicationID, StudentID, ApplicationDate, ApplicationStatus)
VALUES
('APP003', 'S003', DATE '2026-01-15', 'Approved');

INSERT INTO SCHOLARSHIP_APPLICATION
(ApplicationID, StudentID, ApplicationDate, ApplicationStatus)
VALUES
('APP004', 'S004', DATE '2026-01-18', 'Rejected');

INSERT INTO SCHOLARSHIP_APPLICATION
(ApplicationID, StudentID, ApplicationDate, ApplicationStatus)
VALUES
('APP005', 'S005', DATE '2026-01-20', 'Approved');


-- 7. SCHOLARSHIP
INSERT INTO SCHOLARSHIP
(ScholarshipID, ApplicationID, ScholarshipType, Amount)
VALUES
('SCH001', 'APP001', 'Merit Scholarship', 50000);

INSERT INTO SCHOLARSHIP
(ScholarshipID, ApplicationID, ScholarshipType, Amount)
VALUES
('SCH002', 'APP002', 'Need Based Scholarship', 30000);

INSERT INTO SCHOLARSHIP
(ScholarshipID, ApplicationID, ScholarshipType, Amount)
VALUES
('SCH003', 'APP003', 'Sports Scholarship', 40000);

INSERT INTO SCHOLARSHIP
(ScholarshipID, ApplicationID, ScholarshipType, Amount)
VALUES
('SCH004', 'APP004', 'Merit Scholarship', 25000);

INSERT INTO SCHOLARSHIP
(ScholarshipID, ApplicationID, ScholarshipType, Amount)
VALUES
('SCH005', 'APP005', 'Need Based Scholarship', 35000);


-- 8. BANK_ACCOUNT
INSERT INTO BANK_ACCOUNT
(AccountNo, BankName, IFSC, AccountType)
VALUES
('AC001', 'State Bank of India', 'SBIN0001234', 'Savings');

INSERT INTO BANK_ACCOUNT
(AccountNo, BankName, IFSC, AccountType)
VALUES
('AC002', 'HDFC Bank', 'HDFC0001234', 'Savings');

INSERT INTO BANK_ACCOUNT
(AccountNo, BankName, IFSC, AccountType)
VALUES
('AC003', 'ICICI Bank', 'ICIC0001234', 'Savings');

INSERT INTO BANK_ACCOUNT
(AccountNo, BankName, IFSC, AccountType)
VALUES
('AC004', 'Axis Bank', 'UTIB0001234', 'Savings');

INSERT INTO BANK_ACCOUNT
(AccountNo, BankName, IFSC, AccountType)
VALUES
('AC005', 'Punjab National Bank', 'PUNB0001234', 'Savings');


-- 9. DISBURSEMENT
INSERT INTO DISBURSEMENT
(DisbursementID, ScholarshipID, AccountNo, DisbursementDate, Amount, DisbursementMode)
VALUES
('DIS001', 'SCH001', 'AC001', DATE '2026-02-10', 50000, 'Bank Transfer');

INSERT INTO DISBURSEMENT
(DisbursementID, ScholarshipID, AccountNo, DisbursementDate, Amount, DisbursementMode)
VALUES
('DIS002', 'SCH002', 'AC002', DATE '2026-02-02', 30000, 'Direct Transfer');

INSERT INTO DISBURSEMENT
(DisbursementID, ScholarshipID, AccountNo, DisbursementDate, Amount, DisbursementMode)
VALUES
('DIS003', 'SCH003', 'AC003', DATE '2026-02-15', 40000, 'Bank Transfer');

INSERT INTO DISBURSEMENT
(DisbursementID, ScholarshipID, AccountNo, DisbursementDate, Amount, DisbursementMode)
VALUES
('DIS004', 'SCH005', 'AC005', DATE '2026-02-20', 35000, 'Bank Transfer');


-- 10. STUDENT_FEE
INSERT INTO STUDENT_FEE
(FeeID, StudentID, FeeAmount, DueDate)
VALUES
('F001', 'S001', 75000, DATE '2026-03-01');

INSERT INTO STUDENT_FEE
(FeeID, StudentID, FeeAmount, DueDate)
VALUES
('F002', 'S002', 80000, DATE '2026-03-01');

INSERT INTO STUDENT_FEE
(FeeID, StudentID, FeeAmount, DueDate)
VALUES
('F003', 'S003', 70000, DATE '2026-03-01');

INSERT INTO STUDENT_FEE
(FeeID, StudentID, FeeAmount, DueDate)
VALUES
('F004', 'S004', 75000, DATE '2026-03-01');

INSERT INTO STUDENT_FEE
(FeeID, StudentID, FeeAmount, DueDate)
VALUES
('F005', 'S005', 80000, DATE '2026-03-01');


-- 11. PAYMENT_METHOD
INSERT INTO PAYMENT_METHOD
(MethodID, MethodName)
VALUES
('M01', 'UPI');

INSERT INTO PAYMENT_METHOD
(MethodID, MethodName)
VALUES
('M02', 'Net Banking');

INSERT INTO PAYMENT_METHOD
(MethodID, MethodName)
VALUES
('M03', 'Credit Card');

INSERT INTO PAYMENT_METHOD
(MethodID, MethodName)
VALUES
('M04', 'Debit Card');


-- 12. FEE_PAYMENT
INSERT INTO FEE_PAYMENT
(PaymentID, FeeID, ScholarshipID, MethodID, PaymentDate, AmountPaid, TransactionID)
VALUES
('PAY001', 'F001', 'SCH001', 'M01', DATE '2026-02-25', 25000, 'TXN1001');

INSERT INTO FEE_PAYMENT
(PaymentID, FeeID, ScholarshipID, MethodID, PaymentDate, AmountPaid, TransactionID)
VALUES
('PAY002', 'F002', 'SCH002', 'M02', DATE '2026-02-26', 20000, 'TXN1002');

INSERT INTO FEE_PAYMENT
(PaymentID, FeeID, ScholarshipID, MethodID, PaymentDate, AmountPaid, TransactionID)
VALUES
('PAY003', 'F003', 'SCH003', 'M03', DATE '2026-02-27', 30000, 'TXN1003');

INSERT INTO FEE_PAYMENT
(PaymentID, FeeID, ScholarshipID, MethodID, PaymentDate, AmountPaid, TransactionID)
VALUES
('PAY004', 'F005', 'SCH005', 'M04', DATE '2026-02-28', 15000, 'TXN1004');

INSERT INTO FEE_PAYMENT
(PaymentID, FeeID, ScholarshipID, MethodID, PaymentDate, AmountPaid, TransactionID)
VALUES
('PAY005', 'F001', NULL, 'M01', DATE '2026-03-02', 10000, 'TXN1005');

COMMIT;
