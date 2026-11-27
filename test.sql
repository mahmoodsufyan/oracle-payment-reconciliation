whenever sqlerror exit failure rollback
set serveroutput on
declare
    procedure expect_status(p_ref varchar2, p_expected varchar2) is
        actual recon_report.status%type;
    begin
        select status into actual from recon_report where payment_ref = p_ref;
        if actual is null or actual <> p_expected then
            raise_application_error(-20001, p_ref || ': expected ' || p_expected || ', got ' || actual);
        end if;
        dbms_output.put_line(p_ref || ': ' || actual);
    end;
begin
    expect_status('DEMO-101', 'MATCHED');
    expect_status('DEMO-102', 'MISSING_VOUCHER');
    expect_status('DEMO-103', 'DUPLICATE_VOUCHER');
    expect_status('DEMO-104', 'AMOUNT_MISMATCH');
end;
/
