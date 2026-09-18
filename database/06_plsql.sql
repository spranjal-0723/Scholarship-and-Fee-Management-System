SET SERVEROUTPUT ON;
SET SQLBLANKLINES ON;

-- ============================================
-- SCHOLARSHIP AND FEE MANAGEMENT SYSTEM
-- PL/SQL IMPLEMENTATION
-- ============================================


-- ============================================
-- P1. Procedure to display student fee status
-- ============================================

CREATE OR REPLACE PROCEDURE P_STUDENT_FEE_STATUS (
    p_student_id IN STUDENT.StudentID%TYPE
)
IS
    v_student_name STUDENT.StudentName%TYPE;
    v_fee_amount STUDENT_FEE.FeeAmount%TYPE;
    v_total_paid NUMBER(10,2);
    v_outstanding NUMBER(10,2);
BEGIN

    SELECT s.StudentName, sf.FeeAmount
    INTO v_student_name, v_fee_amount
    FROM STUDENT s
    JOIN STUDENT_FEE sf
        ON s.StudentID = sf.StudentID
    WHERE s.StudentID = p_student_id;

    SELECT NVL(SUM(AmountPaid), 0)
    INTO v_total_paid
    FROM FEE_PAYMENT fp
    JOIN STUDENT_FEE sf
        ON fp.FeeID = sf.FeeID
    WHERE sf.StudentID = p_student_id;

    v_outstanding := v_fee_amount - v_total_paid;

    DBMS_OUTPUT.PUT_LINE('Student: ' || v_student_name);
    DBMS_OUTPUT.PUT_LINE('Fee Amount: ' || v_fee_amount);
    DBMS_OUTPUT.PUT_LINE('Total Paid: ' || v_total_paid);
    DBMS_OUTPUT.PUT_LINE('Outstanding Amount: ' || v_outstanding);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student or fee record not found.');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- ============================================
-- P2. Function to calculate outstanding fee
-- ============================================

CREATE OR REPLACE FUNCTION F_OUTSTANDING_FEE (
    p_fee_id IN STUDENT_FEE.FeeID%TYPE
)
RETURN NUMBER
IS
    v_fee_amount STUDENT_FEE.FeeAmount%TYPE;
    v_total_paid NUMBER(10,2);
BEGIN

    SELECT FeeAmount
    INTO v_fee_amount
    FROM STUDENT_FEE
    WHERE FeeID = p_fee_id;

    SELECT NVL(SUM(AmountPaid), 0)
    INTO v_total_paid
    FROM FEE_PAYMENT
    WHERE FeeID = p_fee_id;

    RETURN v_fee_amount - v_total_paid;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;

    WHEN OTHERS THEN
        RETURN NULL;
END;
/


-- ============================================
-- P3. Procedure to display approved scholarships
-- ============================================

CREATE OR REPLACE PROCEDURE P_APPROVED_SCHOLARSHIPS
IS
    CURSOR c_scholarships IS
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
        WHERE sa.ApplicationStatus = 'Approved'
        ORDER BY sc.Amount DESC;

BEGIN

    FOR r IN c_scholarships LOOP
        DBMS_OUTPUT.PUT_LINE(
            r.StudentID || ' | ' ||
            r.StudentName || ' | ' ||
            r.ScholarshipType || ' | ' ||
            r.Amount
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- ============================================
-- P4. Trigger to prevent payment exceeding fee
-- ============================================

CREATE OR REPLACE TRIGGER TRG_CHECK_FEE_PAYMENT
BEFORE INSERT ON FEE_PAYMENT
FOR EACH ROW
DECLARE
    v_fee_amount STUDENT_FEE.FeeAmount%TYPE;
    v_total_paid NUMBER(10,2);
BEGIN

    SELECT FeeAmount
    INTO v_fee_amount
    FROM STUDENT_FEE
    WHERE FeeID = :NEW.FeeID;

    SELECT NVL(SUM(AmountPaid), 0)
    INTO v_total_paid
    FROM FEE_PAYMENT
    WHERE FeeID = :NEW.FeeID;

    IF v_total_paid + :NEW.AmountPaid > v_fee_amount THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Payment exceeds the total fee amount.'
        );
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Fee record does not exist.'
        );
END;
/


-- ============================================
-- P5. Anonymous PL/SQL block
-- Demonstrate function usage
-- ============================================

DECLARE
    v_outstanding NUMBER(10,2);
BEGIN

    v_outstanding := F_OUTSTANDING_FEE('F001');

    DBMS_OUTPUT.PUT_LINE(
        'Outstanding amount for F001: ' || v_outstanding
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- ============================================
-- P6. Anonymous PL/SQL block
-- Demonstrate procedure usage
-- ============================================

BEGIN

    P_STUDENT_FEE_STATUS('S001');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- ============================================
-- P7. Anonymous PL/SQL block
-- Display approved scholarships
-- ============================================

BEGIN

    P_APPROVED_SCHOLARSHIPS;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
