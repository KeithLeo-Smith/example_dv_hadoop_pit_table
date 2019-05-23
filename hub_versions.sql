with hub_versions
as
(
    Select distinct meta_hashkey, to_timestamp('1900-01-01','yyyy-MM-dd') as 
    meta_loaddatetime from hub
    UNION
    Select distinct meta_hashkey, meta_loaddatetime from sat1
    UNION
    Select distinct meta_hashkey, meta_loaddatetime from sat2
    UNION
    Select distinct meta_hashkey, meta_loaddatetime from sat3
),
hub_versions_ended
as
(
     Select
         meta_hashkey,
         meta_loaddatetime,
         LEAD(
            seconds_sub(meta_loaddatetime,1),1,to_timestamp('9999-12-31','yyyy-MM-dd')
            ) OVER (PARTITION BY meta_hashkey ORDER BY meta_loaddatetime ASC)
            as meta_loaddendatetime
    from
        hub_versions
)
select * 
from hub_versions_ended 
order by
meta_hashkey,
meta_loaddatetime