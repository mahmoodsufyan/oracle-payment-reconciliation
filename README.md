# Payment reconciliation in Oracle PL/SQL

A runnable Oracle example by Mahmood Sufyan. A finance team receives payments from a provider and checks them against accounting vouchers. This independent example uses invented references and amounts. No company schema or records are included.

| Payment reference | Vouchers | Expected report status |
| --- | ---: | --- |
| DEMO-101 | 1 with the same amount | MATCHED |
| DEMO-102 | 0 | MISSING_VOUCHER |
| DEMO-103 | 2 | DUPLICATE_VOUCHER |
| DEMO-104 | 1 with a different amount | AMOUNT_MISMATCH |

## Run

Use an **empty demo schema** in an Oracle database, with privileges and tablespace quota to create two tables, a view and a PL/SQL package. In SQLcl or SQL*Plus, connect as that user and run `@run.sql` from this directory. Run installation once. To read the report again, use `select * from recon_report order by payment_ref;`. To rerun the assertions use `@test.sql`.

[Schema and package](schema.sql) · [Synthetic fixtures](seed.sql) · [Assertions](test.sql) · [Oracle CI run](../../actions)

## Design

The SQL view groups vouchers by external payment reference before comparing them with each payment. The package classifies each group. Two vouchers require review even when their sum equals the expected amount. Payment references are unique per payment, while several vouchers may deliberately share a reference. All values in this example use one currency. The report covers incoming payments and leaves the underlying records unchanged.

[Microfinance work at the National Microfinance Foundation](https://mahmoodsufyan.github.io/national-microfinance.html) · [GitHub profile](https://github.com/mahmoodsufyan)
