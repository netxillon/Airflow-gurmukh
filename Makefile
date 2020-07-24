# © 2019 Netxillon Technologies.
# ------------------------------
# Author: Gurmukh Singh
# Email: trainings@netxillon.com
# Date: 22-06-2020
# ------------------------------

# You are free to use these as long as you acknowledge it back to the source and give due credit.

**WARNING**
# There is no guarantee for the use of these scripts/roles and the author is in no way liable for any damange caused by the use of these scripts.

# This section enables pass-phraseless access and set sudoers for non root users the install user
first_step:
	ansible all  -m authorized_key -a "user='centos' state='present' key='{{ lookup('file', '~/.ssh/id_rsa.pub')}}'" -i inventory/test/airflow_hosts -k
	ansible-playbook playbooks/set_sudoers.yml -i inventory/test/airflow_hosts -k -K

# The below action does installation of system packages and OS tuning
cluster_prereqs:
	ansible-playbook playbooks/cluster-install.yml -i inventory/test/airflow_hosts  --tags tune-os
	ansible-playbook playbooks/cluster-install.yml -i inventory/test/airflow_hosts  --tags os-packages

# The below action reboot the nodes
cluster_reboot:
	ansible-playbook playbooks/reboot.yml -i inventory/test/airflow_hosts --extra-vars reboot=now

# Install HAproxy
cluster_haproxy:
	ansible-playbook playbooks/cluster-install.yml -i inventory/test/airflow_hosts --tags haproxy

# Install MariaDB before executing the next step in Maridb is not already configured.
cluster_install_mariadb:
	ansible-playbook playbooks/cluster-install.yml -i inventory/test/airflow_hosts  --tags mariadb

# The below action install Rabbitmq and Airflow
cluster_install_airflow_rabbitmq:
	ansible-playbook playbooks/cluster-install.yml -i inventory/test/airflow_hosts  --tags rabbitmq-install
	ansible-playbook playbooks/cluster-install.yml -i inventory/test/airflow_hosts  --tags airflow
