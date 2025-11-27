import pendulum
from airflow.decorators import dag
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

default_args = {
    'owner': 'airflow',
    'retries': 1,
}


@dag(
    dag_id='init_databases',
    default_args=default_args,
    schedule=None,
    start_date=pendulum.today('UTC'),
    catchup=False,
    tags=['setup', 'pagila', 'sakila'],
    template_searchpath=['/opt/airflow/scripts']
)
def init_databases():
    init_pagila_schema = SQLExecuteQueryOperator(
        task_id='init_pagila_schema',
        conn_id='postgres_pagila',
        sql='pagila-schema.sql',
        split_statements=True,
    )

    init_pagila_data = SQLExecuteQueryOperator(
        task_id='init_pagila_data',
        conn_id='postgres_pagila',
        sql='pagila-insert-data.sql',
        split_statements=True,
    )

    init_sakila_schema = SQLExecuteQueryOperator(
        task_id='init_sakila_schema',
        conn_id='mysql_sakila',
        sql='sakila-schema.sql',
        split_statements=True,
    )

    init_sakila_data = SQLExecuteQueryOperator(
        task_id='init_sakila_data',
        conn_id='mysql_sakila',
        sql='sakila-data.sql',
        split_statements=True,
    )

    init_pagila_schema >> init_pagila_data
    init_sakila_schema >> init_sakila_data


init_databases()
