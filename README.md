# SumUp Technical Challenge

This repository contains the work undertaken to solve the technical challenge part of the interview process for the Senior Analytics Engineer role at SumUp.

## Technical set-up

I decided to stand up an end-to-end ETL solution using dbt and a cloud data warehouse, Google BigQuery. Since its launch, dbt has quickly become the industry standard for data (analytics) teams to take control of their ETL processes and create production-grade data pipelines with a handful of commands. It's easy to get started with it and it's a fairly robust tool, even with larger volumes of data. I will make some considerations on this later on.

I chose Google BigQuery because I previously worked with it and it integrates well with dbt. I considered to use Postgres as my database of choice, but I decided otherwise in an effort to "future-proof" this project. While Postgres would've worked just fine right now, given the very small size of the datasets, it would've shown its weaknesses with larger volumes of data, as the project's size expanded.

## Data preparation

I was given 3 `.xlsx` files as raw data sources. The easiest and fastest way to surface these in any data warehouse with dbt is to create **seed** data objects. Those are static tables that are created by simply dropping `.csv` files in the appropriate folder