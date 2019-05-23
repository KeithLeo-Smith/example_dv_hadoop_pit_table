Select
    meta_hashkey,
    meta_loaddatetime,
    LEAD(
    seconds_sub(meta_loaddatetime,1),1,to_timestamp('9999-12-31','yyyy-MM-dd')
    ) OVER (PARTITION BY meta_hashkey ORDER BY meta_loaddatetime ASC) as 
    meta_loaddendatetime
from
    sat2
order by
    meta_hashkey,
    meta_loaddatetime
;