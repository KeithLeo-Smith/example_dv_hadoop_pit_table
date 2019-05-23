with
sat1_ended
as
(
    Select
        meta_hashkey,
        meta_loaddatetime,
        LEAD(
        seconds_sub(meta_loaddatetime,1),1,to_timestamp('9999-12-31','yyyy-MM-dd')
        ) OVER (PARTITION BY meta_hashkey ORDER BY meta_loaddatetime ASC) as 
        meta_loaddendatetime
    from
        sat1
),
sat2_ended
as
(
    Select
        meta_hashkey,
        meta_loaddatetime,
        LEAD(
        seconds_sub(meta_loaddatetime,1),1,to_timestamp('9999-12-31','yyyy-MM-dd')
        ) OVER (PARTITION BY meta_hashkey ORDER BY meta_loaddatetime ASC) as 
        meta_loaddendatetime
    from
        sat2
),
sat3_ended
as
(
    Select
        meta_hashkey,
        meta_loaddatetime,
        LEAD(
        seconds_sub(meta_loaddatetime,1),1,to_timestamp('9999-12-31','yyyy-MM-dd')
        ) OVER (PARTITION BY meta_hashkey ORDER BY meta_loaddatetime ASC) as 
        meta_loaddendatetime
    from
        sat3
),
hub_versions
as
(
    Select distinct meta_hashkey, to_timestamp('1900-01-01','yyyy-MM-dd') as meta_loaddatetime from hub
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
Select
     pit.meta_hashkey,
     pit.meta_loaddatetime as effectivedate,
     pit.meta_loaddendatetime as effectiveenddate,
     sat1.meta_loaddatetime as sat1_loaddatetime,
     sat2.meta_loaddatetime as sat2_loaddatetime,
     sat3.meta_loaddatetime as sat3_loaddatetime
from
    hub_versions_ended as pit
left outer join
    sat1_ended as sat1 on
    sat1.meta_hashkey = pit.meta_hashkey and
    sat1.meta_loaddatetime <= pit.meta_loaddatetime and
    sat1.meta_loaddendatetime >= pit.meta_loaddendatetime
left outer join
    sat2_ended as sat2 on
    sat2.meta_hashkey = pit.meta_hashkey and
    sat2.meta_loaddatetime <= pit.meta_loaddatetime and
    sat2.meta_loaddendatetime >= pit.meta_loaddendatetime
left outer join
    sat3_ended as sat3 on
    sat3.meta_hashkey = pit.meta_hashkey and
    sat3.meta_loaddatetime <= pit.meta_loaddatetime and
    sat3.meta_loaddendatetime >= pit.meta_loaddendatetime
;