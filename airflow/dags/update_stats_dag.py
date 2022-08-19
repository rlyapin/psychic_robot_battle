import os
import datetime
import json
import pendulum
from airflow import DAG
from airflow.operators.python import PythonOperator


N_REQUESTS_QUERY = lambda x: f"""
SELECT COUNT(*) FROM events
WHERE event_time > NOW() - INTERVAL '{x} days';
"""

N_HITS_QUERY = lambda x: f"""
SELECT SUM((click=pred)::int) FROM events
WHERE event_time > NOW() - INTERVAL '{x} days';
"""


def update_stats():
    import redis
    import psycopg2

    r = redis.from_url(os.getenv("AIRFLOW_CONN_REDIS"))
    conn = psycopg2.connect(os.getenv("AIRFLOW_CONN_PSYCHIC_DB"))
    cursor = conn.cursor()
    stats = {}

    for n in [1, 7, 30]:
        cursor.execute(N_REQUESTS_QUERY(n))
        n_requests = cursor.fetchall()[0][0]
        stats[f"n_requests_last_{n}_days"] = n_requests

        cursor.execute(N_HITS_QUERY(n))
        n_hits = cursor.fetchall()[0][0]
        acc = n_hits / n_requests if n_requests > 0 else 0
        stats[f"avg_accuracy_last_{n}_days"] = acc

    now = datetime.datetime.utcnow()
    now = str(now.isoformat("T") + "Z")
    stats["last_updated"] = now

    r.hmset("psychic_stats", stats)

    cursor.close()
    conn.close()


dag = DAG(
    dag_id="update_stats_dag",
    schedule_interval="@daily",
    default_args={'depends_on_past': False},
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    is_paused_upon_creation=False
)

run_update = PythonOperator(task_id="update_stats", python_callable=update_stats, dag=dag)
run_update