Запуск скрипта на jump-ноде. Предварительно убедитесь, что настроили вашему пользователю все ssh-права (setup.sh в корне проекта)

Для разворачивания Hadoop + YARN используется playbook `hadoop_yarn.yml`:
```shell
ansible-playbook -i hosts hadoop_yarn.yml
```

Для разворачивания Hive используется playbook `hive.yml`:
```shell
ansible-playbook -i hosts hive.yml
```

Для разворачивания Spark используется playbook `spark.yml`:
```shell
ansible-playbook -i hosts spark.yml
```

Для разворачивания Airflow используется playbook `airflow.yml`:
```shell
ansible-playbook -i hosts airflow.yml
```
