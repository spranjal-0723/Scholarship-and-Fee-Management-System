SET SQLBLANKLINES ON;

-- ============================================
-- SCHOLARSHIP AND FEE MANAGEMENT SYSTEM
-- DATABASE VIEWS
-- ============================================


-- V1. Student academic information
CREATE OR REPLACE VIEW VW_STUDENT_ACADEMIC AS
SELECT
    s.StudentID,
    s.StudentName,
    s.Phone,
    p.ProgramID,
    p.ProgramName,
    p.DegreeLevel,
    d.DeptID,
    d.DeptName
FROM STUDENT s
JOIN PROGRAM p
    ON s.ProgramID = p.ProgramID
JOIN DEPARTMENT d
    ON p.DeptID = d.DeptID;


-- V2. Scholarship application summary
CREATE OR REPLACE VIEW VW_SCHOLARSHIP_APPLICATION AS
SELECT
    sa.ApplicationID,
    s.StudentID,
    s.StudentName,
    sa.ApplicationDate,
    sa.ApplicationStatus,
    sc.ScholarshipID,
    sc.ScholarshipType,
    sc.Amount AS ScholarshipAmount
FROM SCHOLARSHIP_APPLICATION sa
JOIN STUDENT s
    ON sa.StudentID = s.StudentID
LEFT JOIN SCHOLARSHIP sc
    ON sa.ApplicationID = sc.ApplicationID;


-- V3. Student fee payment summary
CREATE OR REPLACE VIEW VW_STUDENT_FEE_SUMMARY AS
SELECT
    s.StudentID,
    s.StudentName,
    sf.FeeID,
    sf.FeeAmount,
    NVL(SUM(fp.AmountPaid), 0) AS TotalPaid,
    sf.FeeAmount - NVL(SUM(fp.AmountPaid), 0) AS OutstandingAmount
FROM STUDENT s
JOIN STUDENT_FEE sf
    ON s.StudentID = sf.StudentID
LEFT JOIN FEE_PAYMENT fp
    ON sf.FeeID = fp.FeeID
GROUP BY
    s.StudentID,
    s.StudentName,
    sf.FeeID,
    sf.FeeAmount;


-- V4. Scholarship disbursement details
CREATE OR REPLACE VIEW VW_DISBURSEMENT_DETAILS AS
SELECT
    d.DisbursementID,
    s.StudentID,
    s.StudentName,
    sc.ScholarshipID,
    sc.ScholarshipType,
    d.Amount AS DisbursedAmount,
    d.DisbursementDate,
    d.DisbursementMode,
    b.AccountNo,
    b.BankName,
    b.IFSC
FROM DISBURSEMENT d
JOIN SCHOLARSHIP sc
    ON d.ScholarshipID = sc.ScholarshipID
JOIN SCHOLARSHIP_APPLICATION sa
    ON sc.ApplicationID = sa.ApplicationID
JOIN STUDENT s
    ON sa.StudentID = s.StudentID
JOIN BANK_ACCOUNT b
    ON d.AccountNo = b.AccountNo;


-- V5. Pending scholarship applications
CREATE OR REPLACE VIEW VW_PENDING_APPLICATIONS AS
SELECT
    sa.ApplicationID,
    s.StudentID,
    s.StudentName,
    s.Phone,
    sa.ApplicationDate,
    sa.ApplicationStatus
FROM SCHOLARSHIP_APPLICATION sa
JOIN STUDENT s
    ON sa.StudentID = s.StudentID
WHERE sa.ApplicationStatus = 'Pending';


COMMIT;
