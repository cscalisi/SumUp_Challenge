{{
  config(
    tags = 'products'
  )
}}

select
  d.type as device_type,
  round(count(1) / (sum(count(1)) over()), 2) as pct_sales
from
  {{ref('device')}} as d
  inner join {{ref('transaction')}} as t on t.device_id = d.id
group by
  1
order by
  1