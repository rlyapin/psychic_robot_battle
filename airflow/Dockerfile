FROM apache/airflow:2.3.3

COPY --chown=airflow:root dag.py /opt/airflow/dags

COPY pod_template_file.yaml /opt/airflow/