# DA-3 Member 3 — Neo4j Test Plan

## Environment
- Database: local Neo4j 5, database `neo4j`.
- Graph scripts from Member 1: `01_constraints.cypher` through `04_verify_graph.cypher`.
- Member 3 read-only queries: `05_graph_queries.cypher` and `06_query_verification.cypher`.
- Do not run destructive test setup against the baseline database. Use a separate disposable database for synthetic fixtures.

## Execution record
Mark a test PASS only after actually running it and inspecting the result. The three core queries (student scholarship journey, department-wise exploration, and fee/payment traceability) were shown by the user in Neo4j Browser with successful output. Baseline node and relationship verification was also shown as successful.

| Test ID | Purpose | Input / query | Expected result | Actual result | Status |
|---|---|---|---|---|---|
| N3-01 | Existing student | `studentId = 'S001'` | Aarav Sharma is returned | S001 appeared in the journey and financial outputs | PASS (observed) |
| N3-02 | Nonexistent student | `studentId = 'S999'` | No matching student row | Not yet executed | NOT RUN |
| N3-03 | Application status coverage | Group applications by `applicationStatus` | Approved 3, Pending 1, Rejected 1 | Query output shown in source data; grouped verification not yet shown | NOT RUN (query-level check pending) |
| N3-04 | Application with no scholarship | Use an isolated test fixture with an unawarded application | Optional traversal retains application with null scholarship | Baseline has a scholarship for each application | NOT RUN (requires isolated fixture) |
| N3-05 | Approved application without scholarship | Query 06, Query 2 | No rows for current baseline | Not yet executed | NOT RUN |
| N3-06 | Scholarship without disbursement | Query 06, Query 3 | SCH004, Merit Scholarship, 25000 | Journey output shows SCH004 has no disbursement; query not yet run separately | NOT RUN (query-level check pending) |
| N3-07 | Partially paid fee | Query 05, Query 3 or Query 06, Query 4; inspect F001 | F001: fee 75000, paid 35000, outstanding 40000 | User-provided output confirms these values | PASS (observed) |
| N3-08 | Fully paid fee | Create a fee and payments that sum exactly to fee amount in an isolated test database | Outstanding equals 0 | Baseline contains no fully paid fee | NOT RUN (requires isolated fixture) |
| N3-09 | Optional scholarship payment link | Inspect PAY005 | Payment exists and scholarship reference is null; fee/payment-method links remain valid | PAY005 returned with null scholarship fields and linksValid TRUE | PASS (observed) |
| N3-10 | Duplicate canonical identifier | Attempt duplicate `Student.studentId` in disposable test DB | Uniqueness constraint rejects duplicate | Constraints were created; duplicate-write test not run | NOT RUN |
| N3-11 | Duplicate transaction ID | Attempt duplicate `Payment.transactionId` in disposable test DB and verify API validation | Duplicate should be rejected if uniqueness is enforced by schema/backend | Not yet executed; transactionId uniqueness is not among the 12 identifier constraints shown | NOT RUN / REVIEW NEEDED |
| N3-12 | Payment exceeds fee | Submit amount greater than outstanding through the financial API | API rejects operation; fee/payment totals unchanged | Financial Neo4j API not confirmed available yet | BLOCKED — coordinate with Member 2 |
| N3-13 | Missing payment relationships | Member 1 verification query 4 | Every baseline payment has a Fee and PaymentMethod link | All 5 rows were TRUE | PASS (observed) |
| N3-14 | Missing scholarship-application links | Member 1 verification query 5 | Every baseline scholarship has an Application link | All 5 rows were TRUE | PASS (observed) |
| N3-15 | Missing disbursement links | Member 1 verification query 6 | Every baseline disbursement has Scholarship and BankAccount links | All 4 rows were TRUE | PASS (observed) |
| N3-16 | Empty result handling | Query 06, Query 2 on current baseline | Valid empty result, no query error | Not yet executed | NOT RUN |

## Important data-quality observation
The imported baseline links `SCH002` to `APP002` (`Pending`) and `SCH004` to `APP004` (`Rejected`). Both conflict with the DA-2 business rule that scholarships should only be created for approved applications. Preserve the source dataset for comparison and report these as inherited sample-data inconsistencies; do not silently alter Member 1's import or graph schema. Confirm with the team whether analytical queries should include all source rows or filter to approved applications for a specific business use case.

## Financial API ownership
The test for overpayment depends on the financial operations/API being implemented. Coordinate with Member 2 on the Neo4j connection conventions and API boundaries before adding or changing backend code.
