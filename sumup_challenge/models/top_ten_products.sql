{{
  config(
    tags = 'products'
  )
}}

SELECT
  product_name,
  product_sku,
  count(1) as no_transactions
FROM
  {{ref('transaction')}}
group by
  1,
  2
order by
  count(1) desc
LIMIT
  10