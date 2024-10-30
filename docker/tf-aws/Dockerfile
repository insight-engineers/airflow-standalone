FROM apache/airflow:slim-2.10.1-python3.12

ENV AIRFLOW_HOME=/opt/airflow

USER root
RUN apt-get update && apt-get install -y wget curl gnupg software-properties-common unzip zip

# Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list && \
    sudo apt update && sudo apt install -y terraform

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER airflow

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

ENTRYPOINT ["/bin/bash","/entrypoint.sh"]