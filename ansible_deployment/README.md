Запуск скрипта на jump-ноде. Предварительно убедитесь, что настроили вашему пользователю все ssh-права (setup.sh в корне проекта)

```shell
ansible-playbook -i hosts hadoop_yarn.yml
```
