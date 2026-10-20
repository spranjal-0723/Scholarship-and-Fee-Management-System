# DA-3 Member 3 — Expected Results and Baseline Comparison

## Source baseline
Values below are based on the DA-2 sample records reflected in Member 1's Neo4j import script and on results the user shared from the local Neo4j Browser. They are not performance measurements.

## Graph verification — observed

- Node counts matched for all 12 labels: total 54 nodes.
- Relationship counts from the provided result: 55 total relationships across 12 types.
- Payment → Fee and Payment → PaymentMethod checks: all 5 TRUE.
- Scholarship → Application checks: all 5 TRUE.
- Disbursement → Scholarship and Disbursement → BankAccount checks: all 4 TRUE.

| Label | Expected | Actual shown | Match |
|---|---:|---:|---|
| Department | 3 | 3 | TRUE |
| Program | 3 | 3 | TRUE |
| Student | 5 | 5 | TRUE |
| StudentProfile | 5 | 5 | TRUE |
| Guardian | 5 | 5 | TRUE |
| Application | 5 | 5 | TRUE |
| Scholarship | 5 | 5 | TRUE |
| BankAccount | 5 | 5 | TRUE |
| Disbursement | 4 | 4 | TRUE |
| Fee | 5 | 5 | TRUE |
| PaymentMethod | 4 | 4 | TRUE |
| Payment | 5 | 5 | TRUE |

## Financial baseline

| Measure | Expected value | Calculation / note |
|---|---:|---|
| Scholarship amount total | 180000 | 50000 + 30000 + 40000 + 25000 + 35000 |
| Merit scholarship total | 75000 | SCH001 50000 + SCH004 25000 |
| Need Based scholarship total | 65000 | SCH002 30000 + SCH005 35000 |
| Sports scholarship total | 40000 | SCH003 40000 |
| Total fees | 380000 | 75000 + 80000 + 70000 + 75000 + 80000 |
| Total payments | 100000 | 25000 + 20000 + 30000 + 15000 + 10000 |
| Total outstanding | 280000 | Total fees 380000 minus total payments 100000 |
| Applications Approved | 3 | APP001, APP003, APP005 |
| Applications Pending | 1 | APP002 |
| Applications Rejected | 1 | APP004 |
| Disbursement count | 4 | DIS001–DIS004 |
| Total disbursed | 155000 | 50000 + 30000 + 40000 + 35000 |

## Outstanding amount by student — expected

| Student | Fee | Fee amount | Total paid | Outstanding |
|---|---|---:|---:|---:|
| S001 — Aarav Sharma | F001 | 75000 | 35000 | 40000 |
| S002 — Priya Nair | F002 | 80000 | 20000 | 60000 |
| S003 — Rahul Verma | F003 | 70000 | 30000 | 40000 |
| S004 — Ananya Singh | F004 | 75000 | 0 | 75000 |
| S005 — Karan Patel | F005 | 80000 | 15000 | 65000 |
| **Total** | | **380000** | **100000** | **280000** |

## Core query execution evidence — observed from user-provided Neo4j output

1. Student scholarship journey returned five students. S004 / APP004 / SCH004 has no linked disbursement in the current data; later fields are null as intended by OPTIONAL MATCH.
2. Department-wise scholarship exploration returned five student/application-linked rows across D01, D02, and D03.
3. Financial traceability returned five fee rows; S001/F001 includes two payment details (PAY001 and PAY005); S004/F004 has no payments and shows zero paid with 75000 outstanding.

## Data-quality finding
The sample graph has SCH002 linked to APP002 (`Pending`) and SCH004 linked to APP004 (`Rejected`). These are inconsistencies inherited from the DA-2 sample dataset and should be reported, not silently changed during migration. Query 2 is a relationship exploration query, not an eligibility decision.
