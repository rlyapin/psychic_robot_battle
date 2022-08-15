import datetime
import pendulum
import os
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python import PythonOperator


def restart_psychic():
    from kubernetes import client, config
    from kubernetes.client.rest import ApiException

    config.load_incluster_config()
    v1 = client.AppsV1Api()

    now = datetime.datetime.utcnow()
    now = str(now.isoformat("T") + "Z")
    body = {
        'spec': {
            'template':{
                'metadata': {
                    'annotations': {
                        'kubectl.kubernetes.io/restartedAt': now
                    }
                }
            }
        }
    }
    try:
        v1.patch_namespaced_deployment("psychic", namespace="default", body=body, pretty="true")
    except ApiException as e:
        print("Exception when calling AppsV1Api->read_namespaced_deployment_status: %s\n" % e)

dag =  DAG(
    dag_id="update_psychic_dag",
    schedule_interval="@daily",
    default_args={'depends_on_past': False},
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    is_paused_upon_creation=False
)

run_stats = PostgresOperator(task_id="calculate_click_stats",
                             postgres_conn_id="psychic_db",
                             sql="sql/calculate_click_probs.sql", 
                             dag=dag)
run_restart = PythonOperator(task_id="restart_psychic", python_callable=restart_psychic, dag=dag)
run_stats >> run_restart
