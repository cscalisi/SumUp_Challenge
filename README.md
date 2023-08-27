# SumUp Technical Challenge

This repository contains the work undertaken to solve the technical challenge part of the interview process for the Senior Analytics Engineer role at SumUp.

## Technical set-up

I decided to stand up an end-to-end ETL solution using dbt and a cloud data warehouse, Google BigQuery. Since its launch, dbt has quickly become the industry standard for data (analytics) teams to take control of their ETL processes and create production-grade data pipelines with a handful of commands. It's easy to get started with it and it's a fairly robust tool, even with larger volumes of data. I will make some considerations on this later on.

I chose Google BigQuery because I previously worked with it and it integrates well with dbt. I considered to use Postgres as my database of choice, but I decided otherwise in an effort to "future-proof" this project. While Postgres would've worked just fine right now, given the very small size of the datasets, it would've shown its weaknesses with larger volumes of data, as the project's size expanded.

## Data preparation

I was given 3 `.xlsx` files as raw data sources. The easiest and fastest way to surface these in any data warehouse with dbt is to create **seed** data objects. Those are static tables that are created by simply dropping `.csv` files in the appropriate folder and dbt will create a table, automatically inferring data types based on the data stored in the files. 

This procedure works *most of the time* and it almost did in this use case, except for one instance. The timestamp columns in `transaction` and `store` were recognized as `text` fields. In order to answer the last question, I had to work with full timestamp objects and so I had to overwrite dbt's guess at a data type.
Before exporting the `.xslx` files to `.csv` using spreadsheet software, I converted the timestamp columns to the following format: `YYYY-MM-DD HH:mm:ss`. This was necessary in order to cast these 3 columns as `TIMESTAMP`, since that's the pattern dbt expects. Abstracting away from the current situation and thinking of running these operations at scale, we could perform them through some fairly straightforward data manipulation in Python, e.g. as an operator part of an Airflow DAG.

Some manual cleaning up in the spreadsheet had to be done also on the `product_sku` column, which was reported in scientific format. This little bug was probably induced by the fact that the file was opened and saved by spreadsheet software, which occasionally does that. In the context of a full-blown ETL solution, this type of problem should not surface, since files are only moved and manipulated in the background and never visualized through spreadsheet software.


### Data quality checks
