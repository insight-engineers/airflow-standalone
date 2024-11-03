import pendulum
from airflow import DAG
from airflow.providers.ssh.operators.ssh import SSHOperator

class NonTemplateSSHOperator(SSHOperator):
  template_fields = []

with DAG(
    dag_id="ssh_to_centerm_jira_pipeline",
    schedule='00 00 * * *',  # 00:00 GMT+7 Every Day
    start_date=pendulum.datetime(2024, 10, 29, tz="Asia/Ho_Chi_Minh"),
    tags=["ssh"]
) as dag:
    ssh_to_centerm = NonTemplateSSHOperator(
        task_id='ssh_to_centerm_jira_pipeline',
        ssh_conn_id='ssh.centerm.ubuntu.conn',
        cmd_timeout=1200,
        conn_timeout=1200,
        command='cd /opt/apps/insight-engineers/jira-pipeline && bash execute.sh',
        do_xcom_push=False
    )
    ssh_to_centerm

