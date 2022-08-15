FROM apache/airflow:2.3.3

USER root

COPY dags/ /opt/airflow/dags/
COPY pod_template_file.yaml /opt/airflow/

USER airflow