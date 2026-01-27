import pendulum
from airflow.decorators import dag
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.operators.bash import BashOperator

from config import (
    PAGILA_SCHEMA_URL, PAGILA_DATA_URL,
    SAKILA_SCHEMA_URL, SAKILA_DATA_URL
)

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
    download_files = BashOperator(
        task_id='download_sql_files',
        bash_command=f"""
            curl -L "{PAGILA_SCHEMA_URL}" -o /opt/airflow/scripts/pagila-schema.sql && \
            curl -L "{PAGILA_DATA_URL}" -o /opt/airflow/scripts/pagila-insert-data.sql && \
            curl -L "{SAKILA_SCHEMA_URL}" -o /opt/airflow/scripts/sakila-schema.sql && \
            curl -L "{SAKILA_DATA_URL}" -o /opt/airflow/scripts/sakila-data.sql
        """
    )

    clean_pagila_db = SQLExecuteQueryOperator(
        task_id='clean_pagila_db',
        conn_id='postgres_pagila',
        sql="DROP SCHEMA public CASCADE; CREATE SCHEMA public;",
        split_statements=True,
    )

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

    refresh_pagila_mviews = SQLExecuteQueryOperator(
        task_id='refresh_pagila_mviews',
        conn_id='postgres_pagila',
        sql="REFRESH MATERIALIZED VIEW rental_by_category;",
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

    download_files >> init_pagila_schema >> init_pagila_data >> refresh_pagila_mviews
    download_files >> init_sakila_schema >> init_sakila_data


init_databases()
