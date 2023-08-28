docker build --tag my-dbt --target dbt-bigquery .

docker run \
--network=host \
--mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge,target=/usr/app \
--mount type=bind,source=/Users/carloscalisi/Documents/SumUp_Challenge/sumup_challenge/profiles.yml,target=/root/.dbt/profiles.yml \
    my-dbt \
    debug

docker run \\n  --network=host \\n  --mount type=bind,source=/Users/anaisly/Downloads/SumUp_Challenge-main/sumup_challenge,target=/usr/app \\n  --mount type=bind,source=/Users/anaisly/Downloads/SumUp_Challenge-main/sumup_challenge/profiles.yml,target=/root/.dbt/profiles.yml \\n  my-dbt \\n  seed
docker run \\n  --network=host \\n  --mount type=bind,source=/Users/anaisly/Downloads/SumUp_Challenge-main/sumup_challenge,target=/usr/app \\n  --mount type=bind,source=/Users/anaisly/Downloads/SumUp_Challenge-main/sumup_challenge/profiles.yml,target=/root/.dbt/profiles.yml \\n  my-dbt \\n  build --resource-type model