FROM apache/airflow:slim-2.10.1-python3.12

ENV AIRFLOW_HOME=/opt/airflow
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

USER root
RUN apt-get update && apt-get install -y wget curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER airflow

ENTRYPOINT ["/bin/bash","/entrypoint.sh"]