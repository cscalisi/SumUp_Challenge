{{ 
 config(
    tags = 'stores'
  )
}}

SELECT
    d.store_id,
    s.name,
    s.city,
    s.country,
    s.typology,
    SUM(t.amount) AS transacted_amount
FROM
    {{ref('device')}} as d
    INNER JOIN {{ref('transaction')}} AS t ON d.id = t.device_id
    LEFT JOIN {{ref('store')}} AS s ON s.id = d.store_id
GROUP BY
    1,
    2,
    3,
    4,
    5
ORDER BY
    SUM(t.amount) DESC
LIMIT
    10