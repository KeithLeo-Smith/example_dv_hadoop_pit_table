select
    h.customer_id,
    pit.effectivedate, 
    pit.effectiveenddate, 
    s1.first_name,
    s1.last_name,
    s1.gender,
    s1.marritalstatus,
    s2.address,
    s2.email,
    s2.phone,
    s3.car_make,
    s3.department,
    s3.has_dependents
from pit_customer as pit
inner join hub as h
    on pit.hashkey = h.meta_hashkey
left outer join sat1 as s1
    on pit.hashkey = s1.meta_hashkey
    and pit.sat1_loaddatetime = s1.meta_loaddatetime
left outer join sat2 as s2
    on pit.hashkey = s2.meta_hashkey
    and pit.sat2_loaddatetime = s2.meta_loaddatetime
left outer join sat3 as s3
    on pit.hashkey = s3.meta_hashkey
    and pit.sat3_loaddatetime = s3.meta_loaddatetime
order by 
    h.customer_id,
    pit.effectivedate