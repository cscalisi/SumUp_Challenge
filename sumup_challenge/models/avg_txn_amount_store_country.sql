{{
  config(
    tags = 'stores'
  )
}}

select
  s.typology,
  s.country,
  avg(amount) as avg_txn_amount
from
  {{ref('store')}} as s
  inner join {{ref('device')}} as d on d.store_id = s.id
  inner join {{ref('transaction')}} as t on t.device_id = d.id
group by
  1,
  2