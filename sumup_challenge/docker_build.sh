docker build --tag my-dbt --target dbt-bigquery .

docker run \
  --network=host \
  --mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge,target=/usr/app \
  --mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge/profiles.yml,target=/root/.dbt/profiles.yml \
  my-dbt \
  build

docker run \
  -p 8080:8080 \
  --mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge,target=/usr/app \
  --mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge/profiles.yml,target=/root/.dbt/profiles.yml \
  my-dbt \
  docs generate

docker run \
  -p 8080:8080 \
  --mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge,target=/usr/app \
  --mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge/profiles.yml,target=/root/.dbt/profiles.yml \
  my-dbt \
  docs serve
