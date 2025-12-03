import json
import pendulum
from airflow.decorators import dag
from airflow.providers.http.operators.http import SimpleHttpOperator

PAGILA_CONN_ID = '55d1f91d-7b2d-42a4-ba2e-b0094f39cc8a'
SAKILA_CONN_ID = '787236bc-05bc-4900-84fc-0625fa07dc67'

default_args = {
    'owner': 'airflow',
    'retries': 1,
}


@dag(
    dag_id='airbyte_syncs',
    default_args=default_args,
    schedule=None,
    start_date=pendulum.today('UTC'),
    catchup=False,
    tags=['airbyte']
)
def airbyte_syncs():
    trigger_pagila = SimpleHttpOperator(
        task_id='trigger_pagila_postgres',
        http_conn_id='airbyte_conn',
        endpoint='api/v1/connections/sync',
        method='POST',
        data=json.dumps({"connectionId": PAGILA_CONN_ID}),
        headers={"Content-Type": "application/json"},
        response_check=lambda response: response.status_code == 200
    )

    trigger_sakila = SimpleHttpOperator(
        task_id='trigger_sakila_mysql',
        http_conn_id='airbyte_conn',
        endpoint='api/v1/connections/sync',
        method='POST',
        data=json.dumps({"connectionId": SAKILA_CONN_ID}),
        headers={"Content-Type": "application/json"},
        response_check=lambda response: response.status_code == 200
    )

    [trigger_pagila, trigger_sakila]


airbyte_syncs()
