# DA-3 Evaluation — Oracle Relational Database vs Neo4j Graph Database

## Scope and evidence
This comparison uses the DA-2 relational design and the DA-3 Neo4j graph model for the Scholarship and Fee Management System. Local Neo4j Browser results supplied during implementation confirm 54 nodes across 12 labels, 55 relationships across 12 types, and successful link-integrity checks for the baseline. No timed benchmark has been run, so this report makes no claim that one database is universally faster.

## Model differences

- **Oracle:** data is organized in tables with primary/foreign keys. Relationships are reconstructed through joins. This is a natural fit for structured financial records, constraints, grouped totals, and transactions.
- **Neo4j:** entities are nodes and foreign-key relationships are explicit typed edges. A query can traverse the graph directly along relationships such as `Student-[:SUBMITTED]->Application-[:AWARDS]->Scholarship`.

## Graph queries where Neo4j is a natural fit

1. **Scholarship journey tracing:** one traversal can follow a student through application, scholarship, disbursement and bank-account nodes. OPTIONAL MATCH preserves students whose path is incomplete, making missing links visible.
2. **Department-to-scholarship exploration:** the query follows Department → Program → Student → Application → Scholarship without manually spelling out a sequence of SQL joins. The returned association alone does not prove eligibility.
3. **Financial traceability:** traversing Student → Fee → Payment → PaymentMethod and an optional scholarship link makes it straightforward to inspect the connected records for a specific student or fee.

These examples demonstrate model and query expressiveness; they do not, by themselves, prove a performance advantage. Equivalent SQL can also express these queries using joins.

## Financial aggregation and correctness
Financial totals are sensitive to row multiplication. If a fee has multiple payments and additional optional relationships, combining every one-to-many path in a single match may duplicate amounts. The provided financial traceability query calculates total paid per fee in a separate subquery before collecting payment details. This avoids inflating totals through the payment-detail collection.

The baseline totals are: scholarship amounts 180000, fees 380000, payments 100000, and outstanding fees 280000. These values should be recalculated from the live graph using the verification queries and compared with Oracle; they are reference values, not hardcoded query outputs.

## Constraints and business rules
Neo4j supports uniqueness constraints for canonical node identifiers, and the team's script creates one for each of the 12 labels. Cross-record financial rules—such as preventing total payments from exceeding a fee—need transactional application logic or a suitable explicit enforcement design. A uniqueness constraint on `Payment.paymentId` does not automatically make `Payment.transactionId` unique. The current visible 12-constraint script should be reviewed with Member 1/2 if transaction ID uniqueness is required.

Oracle can enforce a broad range of relational constraints and PL/SQL-trigger business rules close to the data. When migrating to Neo4j, those rules must be deliberately reimplemented; they do not transfer automatically from the original schema.

## Transaction handling
Both systems support transactions, but operations must be designed appropriately for the driver's transaction model. Payment validation should read the current fee and linked payments and create the payment in a controlled transaction so concurrent requests cannot each pass validation against a stale total. Coordinate implementation with Member 2's Neo4j Python driver conventions.

## Limitations and implementation considerations

- Neo4j requires clear node identity and relationship conventions; schema drift across team members can break traversal queries.
- Aggregate financial reports remain possible in Cypher, but Oracle is already suited to traditional relational reporting and constraints.
- Data migration correctness depends on preserving identifiers, optional relationships, dates, and amounts.
- The migrated sample includes `SCH002` linked to pending `APP002` and `SCH004` linked to rejected `APP004`, contrary to the DA-2 business rule that scholarships should only be created for approved applications. These are inherited baseline data inconsistencies and should be discussed/documented rather than silently removed.
- No performance benchmark, concurrency test, or production-scale load test has been executed as part of the current evidence. Do not report claims about measured speed or scalability without those tests.

## Conclusion
Neo4j is useful for this project when questions focus on multi-step connected paths—student scholarship journeys, departmental discovery, and tracing financial records. Oracle remains a strong fit for conventional relational integrity and transaction-heavy financial operations. The most defensible conclusion is that Neo4j gives a graph-native representation and readable traversals for relationship-centric questions, while correctness, transactions, performance, and business-rule enforcement must be demonstrated with tests rather than assumed.
