whenever oserror exit failure
whenever sqlerror exit failure rollback
@@schema.sql
@@seed.sql
@@test.sql
select payment_ref, payment_amount, voucher_count, voucher_total, status
from recon_report order by payment_ref;
exit success
