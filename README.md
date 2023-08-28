# SumUp Technical Challenge

This repository contains the work undertaken to solve the technical challenge part of the interview process for the Senior Analytics Engineer role at SumUp.

Please take a look at the comments and descriptions of the PRs in the [pull request section](https://github.com/cscalisi/SumUp_Challenge/pulls?q=is%3Apr+is%3Aclosed), where I left some more explanations and commentary on the work that I have done. 

Happy reviewing!

## Technical set-up

I decided to stand up an end-to-end ETL solution using dbt and a cloud data warehouse, Google BigQuery. Since its launch, dbt has quickly become the industry standard for data (analytics) teams to take control of their ETL processes and create production-grade data pipelines with a handful of commands. It's easy to get started with it and it's a fairly robust tool, even with larger volumes of data. I will make some considerations on this later on.

I chose Google BigQuery because I previously worked with it and it integrates well with dbt. I considered to use Postgres as my database of choice, but I decided otherwise in an effort to "future-proof" this project. While Postgres would've worked just fine right now, given the very small size of the datasets, it would've shown its weaknesses with larger volumes of data, as the project's size expanded.

## Get started

I went with a simple Dockerization for this project. I have put some sample dbt commands wrapped in `docker run` statements in the shell script `docker_build.sh`. 
Make sure to have Docker installed on your machine in order to be able to run the instructions below. Please replace the absolute paths in the `bind` options with the appropriate paths for where you downloaded this repo to and for the `profiles.yml` within it.

If you want to execute all of the commands, simply run:

```shell
cd sumup_challenge
sh docker_build.sh
```
This will download a Docker image with the dbt BigQuery adapter and build a container that runs all seed and models part of this project and finally pushes to port 8080 the dbt docs webpage. Access it at `http://localhost:8080/`. 

You will need a credentials file, which I decided not to upload to GitHub. I will share privately with the appropriate people with instructions on how to use it.

## Data preparation

I was given 3 `.xlsx` files as raw data sources. The easiest and fastest way to surface these in any data warehouse with dbt is to create **seed** data objects. Those are static tables that are created by simply dropping `.csv` files in the appropriate folder and dbt will create a table, automatically inferring data types based on the data stored in the files. 

This procedure works *most of the time* and it almost did in this use case, except for one instance. The timestamp columns in `transaction` and `store` were recognized as `text` fields. In order to answer the last question, I had to work with full timestamp objects and so I had to overwrite dbt's guess at a data type.
Before exporting the `.xslx` files to `.csv` using spreadsheet software, I converted the timestamp columns to the following format: `YYYY-MM-DD HH:mm:ss`. This was necessary in order to cast these 3 columns as `TIMESTAMP`, since that's the pattern dbt expects. Abstracting away from the current situation and thinking of running these operations at scale, we could perform them through some fairly straightforward data manipulation in Python, e.g. as an operator part of an Airflow DAG.

Some manual cleaning up in the spreadsheet had to be done also on the `product_sku` column, which was reported in scientific format. This little bug was probably induced by the fact that the file was opened and saved by spreadsheet software, which occasionally does that. In the context of a full-blown ETL solution, this type of problem should not surface, since files are only moved and manipulated in the background and never visualized through spreadsheet software.


### Data quality checks

I went through some spot data checks on the datasets provided. The text fields, e.g in the `store` file, are clearly random associations of address parts but this did not have any effect in answering the 5 questions proposed. The `created_at` column in that table also has some possible bad data, since some creation dates are in the future. 

The most obvious problem is with the timestamp columns in `transaction`, one recording when the transaction occured, another one when it was written to the database. There is on average a 6 month delay between the two dates, with the latter one happening much later than the former. Not sure if this is due to some bad data generation process, but this resulted in the answer to question 5, about the average time for a store to reach 5 transactions, to be a negative value. I propose two variants of the same metrics, but the results are similar. This is definitely also the result of store creation dates being set in the future, while the latest transaction happened in Q1 2023. If this were data generated by a microservice upstream, I would definitely take a look at what the process there is. Something might be misconfigured.

Last comment is on two sensitive data points, stored in plain text in the `transaction` table, the card number and CVV fields. If this was not a mock dataset, I would not haven uploaded this table as a seed, since these data points are extremely sensitive and should never be exposed in a version-control system like GitHub. I propose some solutions in my [first Pull Request comments](https://github.com/cscalisi/SumUp_Challenge/pull/1).

## dbt project organization

After the 3 `csv` files were properly loaded and configured, I proceded to answer the 5 questions asked in the document. These were pretty straightforward and did not require complicated transformations of the source datasets, so I kept things simple and materialized all models as views.

There was also not much overlap between the 5 questions asked, so I created a model for each of them. Not the most efficient use of objects in a DAG, definitely would not extend this approach to data modeling to a more complex and sophisticated scenario. I added more comments on the topics, together with competing solutions in my [PR comments](https://github.com/cscalisi/SumUp_Challenge/pull/2).

I did introduce `tags` to keep things a bit more organized. These can be used not only to find dbt objects with similar characteristics, but also to run group of dbt objects at once: `tag` is one of the [many selector methods](https://docs.getdbt.com/reference/node-selection/methods) dbt offers.

All models and seeds were documented, tests were added on the primary key where appropriate and a flag for sensitive data can be found too. Simply running the Docker shell script as explained in the **Get Started** section should create the website. Navigate to `http://localhost:8080/` to access it.

## Final considerations

This project relies on just a handful of dbt objects, which is adequate for the size and scope of it. I decided to already adopt a cloud data warehouse instead of a local database like Postgres, because they are generally quite robust to increases in volume of data processed. 
On top of that, a few changes in the project structure and content could be explored too, to scale the project up for larger datasets. 

We could introduce a *join* model, materialized as a table, to speed up a join that I did in 3 of my models. That's the join from `device` to `transaction` through `device`. This will definitely shave some off some computing time, especially if we keep the 5 models materialized as `view`. 

Finally, performance gains can be achieved in BigQuery by introducing partitions on source tables. Assuming that at scale some more complex ETL solution would populate the data found in the `transaction`, `device` and `store` tables, we could think about partitioning those based on a commonly queried attribute like the transaction timestamp or the country a store operates in. This would make any creating dbt models based on subsets of these tables much, much quicker.

