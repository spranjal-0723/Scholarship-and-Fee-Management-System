SET SQLBLANKLINES ON;

-- ============================================
-- SCHOLARSHIP AND FEE MANAGEMENT SYSTEM
-- SQL QUERIES
-- ============================================

-- Q1. Display all students with their program and department
SELECT
    s.StudentID,
    s.StudentName,
    p.ProgramName,
    d.DeptName
FROM STUDENT s
JOIN PROGRAM p
    ON s.ProgramID = p.ProgramID
JOIN DEPARTMENT d
    ON p.DeptID = d.DeptID
ORDER BY s.StudentID;


-- Q2. Display student profile information
SELECT
    s.StudentID,
    s.StudentName,
    sp.BloodGroup,
    sp.Nationality,
    sp.DateOfBirth,
    sp.Email
FROM STUDENT s
JOIN STUDENT_PROFILE sp
    ON s.StudentID = sp.StudentID
ORDER BY s.StudentID;


-- Q3. Display scholarship applications with student details
SELECT
    sa.ApplicationID,
    s.StudentName,
    sa.ApplicationDate,
    sa.ApplicationStatus
FROM SCHOLARSHIP_APPLICATION sa
JOIN STUDENT s
    ON sa.StudentID = s.StudentID
ORDER BY sa.ApplicationDate;


-- Q4. Display approved scholarship applications and scholarship amount
SELECT
    s.StudentID,
    s.StudentName,
    sa.ApplicationStatus,
    sc.ScholarshipType,
    sc.Amount
FROM STUDENT s
JOIN SCHOLARSHIP_APPLICATION sa
    ON s.StudentID = sa.StudentID
JOIN SCHOLARSHIP sc
    ON sa.ApplicationID = sc.ApplicationID
WHERE sa.ApplicationStatus = 'Approved'
ORDER BY sc.Amount DESC;


-- Q5. Calculate total scholarship amount by scholarship type
SELECT
    ScholarshipType,
    COUNT(*) AS NumberOfScholarships,
    SUM(Amount) AS TotalAmount,
    AVG(Amount) AS AverageAmount
FROM SCHOLARSHIP
GROUP BY ScholarshipType
ORDER BY TotalAmount DESC;


-- Q6. Display students whose fee amount is greater than the average fee
SELECT
    s.StudentID,
    s.StudentName,
    sf.FeeID,
    sf.FeeAmount
FROM STUDENT s
JOIN STUDENT_FEE sf
    ON s.StudentID = sf.StudentID
WHERE sf.FeeAmount > (
    SELECT AVG(FeeAmount)
    FROM STUDENT_FEE
)
ORDER BY sf.FeeAmount DESC;


-- Q7. Display fee payment details with payment method
SELECT
    fp.PaymentID,
    fp.FeeID,
    s.StudentName,
    pm.MethodName,
    fp.PaymentDate,
    fp.AmountPaid,
    fp.TransactionID
FROM FEE_PAYMENT fp
JOIN STUDENT_FEE sf
    ON fp.FeeID = sf.FeeID
JOIN STUDENT s
    ON sf.StudentID = s.StudentID
JOIN PAYMENT_METHOD pm
    ON fp.MethodID = pm.MethodID
ORDER BY fp.PaymentDate;


-- Q8. Calculate total fee paid by each student
SELECT
    s.StudentID,
    s.StudentName,
    sf.FeeAmount,
    NVL(SUM(fp.AmountPaid), 0) AS TotalPaid
FROM STUDENT s
JOIN STUDENT_FEE sf
    ON s.StudentID = sf.StudentID
LEFT JOIN FEE_PAYMENT fp
    ON sf.FeeID = fp.FeeID
GROUP BY
    s.StudentID,
    s.StudentName,
    sf.FeeAmount
ORDER BY s.StudentID;


-- Q9. Calculate outstanding fee for each student
SELECT
    s.StudentID,
    s.StudentName,
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
    sf.FeeAmount
ORDER BY OutstandingAmount DESC;


-- Q10. Display scholarship disbursement details
SELECT
    d.DisbursementID,
    s.StudentName,
    sc.ScholarshipType,
    d.Amount,
    d.DisbursementDate,
    d.DisbursementMode,
    b.BankName,
    b.AccountNo
FROM DISBURSEMENT d
JOIN SCHOLARSHIP sc
    ON d.ScholarshipID = sc.ScholarshipID
JOIN SCHOLARSHIP_APPLICATION sa
    ON sc.ApplicationID = sa.ApplicationID
JOIN STUDENT s
    ON sa.StudentID = s.StudentID
JOIN BANK_ACCOUNT b
    ON d.AccountNo = b.AccountNo
ORDER BY d.DisbursementDate;


-- Q11. Count students in each department
SELECT
    d.DeptID,
    d.DeptName,
    COUNT(s.StudentID) AS StudentCount
FROM DEPARTMENT d
LEFT JOIN PROGRAM p
    ON d.DeptID = p.DeptID
LEFT JOIN STUDENT s
    ON p.ProgramID = s.ProgramID
GROUP BY
    d.DeptID,
    d.DeptName
ORDER BY StudentCount DESC;


-- Q12. Display scholarship applications that are still pending
SELECT
    sa.ApplicationID,
    s.StudentID,
    s.StudentName,
    sa.ApplicationDate,
    sa.ApplicationStatus
FROM SCHOLARSHIP_APPLICATION sa
JOIN STUDENT s
    ON sa.StudentID = s.StudentID
WHERE sa.ApplicationStatus = 'Pending'
ORDER BY sa.ApplicationDate;


-- Q13. Find the student receiving the highest scholarship amount
SELECT
    s.StudentID,
    s.StudentName,
    sc.ScholarshipType,
    sc.Amount
FROM STUDENT s
JOIN SCHOLARSHIP_APPLICATION sa
    ON s.StudentID = sa.StudentID
JOIN SCHOLARSHIP sc
    ON sa.ApplicationID = sc.ApplicationID
WHERE sc.Amount = (
    SELECT MAX(Amount)
    FROM SCHOLARSHIP
);


-- Q14. Calculate total amount disbursed by each bank
SELECT
    b.BankName,
    COUNT(d.DisbursementID) AS NumberOfDisbursements,
    SUM(d.Amount) AS TotalDisbursed
FROM BANK_ACCOUNT b
JOIN DISBURSEMENT d
    ON b.AccountNo = d.AccountNo
GROUP BY b.BankName
ORDER BY TotalDisbursed DESC;


-- Q15. Display students who have made more than one fee payment
SELECT
    s.StudentID,
    s.StudentName,
    COUNT(fp.PaymentID) AS NumberOfPayments,
    SUM(fp.AmountPaid) AS TotalPaid
FROM STUDENT s
JOIN STUDENT_FEE sf
    ON s.StudentID = sf.StudentID
JOIN FEE_PAYMENT fp
    ON sf.FeeID = fp.FeeID
GROUP BY
    s.StudentID,
    s.StudentName
HAVING COUNT(fp.PaymentID) > 1
ORDER BY NumberOfPayments DESC;


-- Q16. Display all guardians along with their students
SELECT
    g.GuardianID,
    g.GuardianName,
    g.Relation,
    g.PhoneNo,
    s.StudentID,
    s.StudentName
FROM GUARDIAN g
JOIN STUDENT s
    ON g.StudentID = s.StudentID
ORDER BY s.StudentID;


-- Q17. Find the total scholarship amount approved
SELECT
    SUM(sc.Amount) AS TotalApprovedScholarship
FROM SCHOLARSHIP sc
JOIN SCHOLARSHIP_APPLICATION sa
    ON sc.ApplicationID = sa.ApplicationID
WHERE sa.ApplicationStatus = 'Approved';


-- Q18. Display students who have an outstanding fee
SELECT
    s.StudentID,
    s.StudentName,
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
    sf.FeeAmount
HAVING sf.FeeAmount - NVL(SUM(fp.AmountPaid), 0) > 0
ORDER BY OutstandingAmount DESC;


-- Q19. Display scholarship applications with no disbursement
SELECT
    sa.ApplicationID,
    s.StudentName,
    sc.ScholarshipID,
    sc.Amount
FROM SCHOLARSHIP_APPLICATION sa
JOIN STUDENT s
    ON sa.StudentID = s.StudentID
JOIN SCHOLARSHIP sc
    ON sa.ApplicationID = sc.ApplicationID
LEFT JOIN DISBURSEMENT d
    ON sc.ScholarshipID = d.ScholarshipID
WHERE d.DisbursementID IS NULL
ORDER BY sa.ApplicationID;


-- Q20. Display payment methods and total amount collected through each method
SELECT
    pm.MethodID,
    pm.MethodName,
    COUNT(fp.PaymentID) AS NumberOfPayments,
    NVL(SUM(fp.AmountPaid), 0) AS TotalCollected
FROM PAYMENT_METHOD pm
LEFT JOIN FEE_PAYMENT fp
    ON pm.MethodID = fp.MethodID
GROUP BY
    pm.MethodID,
    pm.MethodName
ORDER BY TotalCollected DESC;
