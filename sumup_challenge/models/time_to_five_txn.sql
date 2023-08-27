{{
  config(
    tag = 'stores'
  )
}}

WITH base AS (
  SELECT
    s.id AS store_id,
    t.happened_at AS txn_ts,
    t.created_at AS etl_updated,
    s.created_at AS store_creation_ts,
    ROW_NUMBER() OVER (
      PARTITION BY s.id
      ORDER BY
        t.happened_at ASC
    ) AS txn_no,
    ROW_NUMBER() OVER (
      PARTITION BY s.id
      ORDER BY
        t.created_at ASC
    ) AS txn_no_alt,
  FROM
    {{ref('transaction')}} AS t
    INNER JOIN {{ref('device')}} AS d ON d.id = t.device_id
    INNER JOIN {{ref('store')}} AS s ON s.id = d.store_id
),
intermediate AS (
  SELECT
    store_id,
    TIMESTAMP_DIFF(base.txn_ts, base.store_creation_ts, day) AS time_to_five_txn,
    TIMESTAMP_DIFF(base.etl_updated, base.store_creation_ts, day) AS time_to_five_txn_alt
  FROM
    base
  WHERE
    txn_no = 5
)
SELECT
  AVG(intermediate.time_to_five_txn) AS avg_time_to_five_txn,
  AVG(intermediate.time_to_five_txn_alt) AS avg_time_to_five_txn_alt
FROM
  intermediate