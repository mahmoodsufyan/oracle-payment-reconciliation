create table recon_payment (
    payment_ref varchar2(40) primary key,
    amount number(14,2) not null check (amount > 0)
);

create table recon_voucher (
    voucher_id number primary key,
    payment_ref varchar2(40) not null references recon_payment(payment_ref),
    amount number(14,2) not null check (amount > 0)
);

create or replace package recon_rules authid definer as
    function classify(p_amount number, p_voucher_count number, p_total number)
        return varchar2 deterministic;
end recon_rules;
/

create or replace package body recon_rules as
    function classify(p_amount number, p_voucher_count number, p_total number)
        return varchar2 deterministic is
    begin
        if p_voucher_count = 0 then
            return 'MISSING_VOUCHER';
        elsif p_voucher_count > 1 then
            return 'DUPLICATE_VOUCHER';
        elsif p_amount = p_total then
            return 'MATCHED';
        end if;
        return 'AMOUNT_MISMATCH';
    end classify;
end recon_rules;
/

create or replace view recon_report as
select p.payment_ref, p.amount as payment_amount,
       nvl(v.voucher_count, 0) as voucher_count,
       v.voucher_total,
       recon_rules.classify(p.amount, nvl(v.voucher_count, 0), v.voucher_total) as status
from recon_payment p
left join (
    select payment_ref, count(*) as voucher_count, sum(amount) as voucher_total
    from recon_voucher
    group by payment_ref
) v on v.payment_ref = p.payment_ref;
