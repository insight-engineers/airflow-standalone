import pendulum
from airflow import DAG
from airflow.providers.ssh.operators.ssh import SSHOperator

class NonTemplateSSHOperator(SSHOperator):
  template_fields = []

with DAG(
    dag_id="ssh_to_centerm_booking_pipeline",
    schedule='00 00 * * *',  # 00:00 GMT+7 Every Day
    start_date=pendulum.datetime(2024, 11, 10, tz="Asia/Ho_Chi_Minh"),
    tags=["ssh"]
) as dag:
    booking_crawler = NonTemplateSSHOperator(
        task_id='booking_crawler',
        ssh_conn_id='ssh.centerm.ubuntu.conn',
        cmd_timeout=1200,
        conn_timeout=1200,
        command='cd /opt/apps/insight-engineers/booking-pipeline && bash execute.sh',
        do_xcom_push=False
    )
    
    load_to_bigquery = NonTemplateSSHOperator(
        task_id='load_to_bigquery',
        ssh_conn_id='ssh.centerm.ubuntu.conn',
        cmd_timeout=1200,
        conn_timeout=1200,
        command='cd /opt/apps/insight-engineers/booking-pipeline && bash execute.sh',
        do_xcom_push=False
    )
    
    booking_crawler >> load_to_bigquery

