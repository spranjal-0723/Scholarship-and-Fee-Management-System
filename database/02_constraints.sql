-- Additional business-rule constraints

ALTER TABLE SCHOLARSHIP_APPLICATION
ADD CONSTRAINT chk_application_status
CHECK (ApplicationStatus IN ('Pending', 'Approved', 'Rejected'));

ALTER TABLE STUDENT_FEE
ADD CONSTRAINT chk_fee_due_date
CHECK (DueDate IS NOT NULL);

ALTER TABLE DISBURSEMENT
ADD CONSTRAINT chk_disbursement_mode
CHECK (DisbursementMode IN ('Bank Transfer', 'Direct Transfer'));

ALTER TABLE PAYMENT_METHOD
ADD CONSTRAINT uq_payment_method_name
UNIQUE (MethodName);

