import pendulum
from airflow.decorators import dag
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from config import AIRBYTE_PAGILA_CONN_ID, AIRBYTE_SAKILA_CONN_ID

default_args = {
    'owner': 'airflow',
    'retries': 1,
}


@dag(
    dag_id='airbyte_syncs_polling',
    default_args=default_args,
    schedule=None,
    start_date=pendulum.today('UTC'),
    catchup=False,
    tags=['airbyte', 'polling']
)
def airbyte_syncs_polling():
    trigger_pagila = AirbyteTriggerSyncOperator(
        task_id='trigger_pagila_postgres',
        airbyte_conn_id='airbyte_conn_polling',
        connection_id=AIRBYTE_PAGILA_CONN_ID,
        asynchronous=False,
        timeout=3600,
        wait_seconds=10
    )

    trigger_sakila = AirbyteTriggerSyncOperator(
        task_id='trigger_sakila_mysql',
        airbyte_conn_id='airbyte_conn_polling',
        connection_id=AIRBYTE_SAKILA_CONN_ID,
        asynchronous=False,
        timeout=3600,
        wait_seconds=10
    )

    [trigger_pagila, trigger_sakila]


airbyte_syncs_polling()
