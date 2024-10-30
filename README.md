# Практические задания по курсу "Введение в платформы данных"

https://my.mts-link.ru/courseInstance/1004347

---


## Деплоймент

Развернуты следующие сервисы и прокинуты интерфейсы:

- *Hadoop* на 80 порту http://176.109.91.9/dfshealth.html#tab-overview
- *YARN*   на 81 порту http://176.109.91.9:81/cluster/
- *API YARN History server* на 82 порту http://176.109.91.9:83/
- *Hiveserver2* на 83 порту http://176.109.91.9:83/
- Логи YARN с ноды team-42-dn-0 на 8000 порту http://176.109.91.9:8000/node/
- Логи YARN с ноды team-42-dn-1 на 8001 порту http://176.109.91.9:8001/node/

### Инструкция по поднятию сервисов в кластере

1) Настройте окружение для выполнения ansible-скриптов. Чтобы не прокидывать пароль в sudo-команды только от пользователя team (!), данный пользователь добавляется в nopasswd-sudoers. 
2) Запустите ansible-playbook в соответствии с заданиями: задание 1-2: hadoop_yarn.yaml задание 3: hive.yml

## Практическое задание №1. Развертывание Hadoop.

1. Необходимо развернуть кластер hdfs включающий в себя 3 DataNode. Должны быть запущены и выполняться следующие демоны: NameNode, Secondary NameNode и три DataNode
2. Кластер должен быть развернут на разных виртуальных машинах, которые будут вам предоставлены. Информация о хостах появится в чате курса.
3. Распределение демонов зависит от числа хостов. Более подробная информация будет доступна, когда станет известно количество предоставляемых виртуальных машин.
4. Кластер должен быть целостным, в логах демонов не должно быть сообщений о критических ошибках и они должны быть в работоспособном состоянии
Как понять, что кластер целостный:
Вариант 1. Зайти в интерфейс NameNode в Hadoop. В нем не должны быть деградировавших нод, должны присутстовать 3 работающих DataNode.
Вариант 2. В логах кластера не должно быть критических ошибок
5. Ограничения по операционной системе: Ubuntu 20 и Debian 10
6. На узлах должно обеспечение по ssh
7. Виртуальные машины будут чистые. Пишите инструкции так, как будто вам нужно научить кого-то разоврачивать кластер.
8. Этот кластер будет использован для выполнения последующих практических заданий


| Оценка | Критерии |
|---|---|
| 8-10 | Кластер разворачивается полностью, все необходимые материалы присутствуют в репозитории |
| 6-7 | Есть скрипты, структура понятна, но есть упущенные фрагменты. Кластер разворачивается, но для выполнения этого необходимо обращение к другим источникам информации, не только к тем, которые есть в репозитории |
| 4-5 | Есть скрипты, структура понятна, но кластер разворачивается не полностью |
| 1-3 | Есть разрозненные скрипты, не понятна последовательность их выполнения |
| 0 | Задание на сдано / не выполнено |


## Практическое задание №2. Развертывание YARN

Развернуть YARN и опубликовать веб-интерфейсы основных и вспомогательных демонов для внешнего использования.

| Оценка | Критерии |
|---|---|
| 8-10 | **на 10 баллов**: Описаны все демоны кластера (ResourceManager, NodeManager, History Server), их конфигурация и работа. Кластер функционирует стабильно, без ошибок. Все веб-интерфейсы опубликованы и доступны извне, работают без сбоев. **на 9 баллов**: Незначительные ошибки в работе веб-интерфейсов **на 8 баллов**: Не полное описание всех демонов или их конфигурации. |
...
| 0 | Задание на сдано / не выполнено |

## Практическое задание №3. Развертывание Hive

Развернуть Hive, выполнить базовые операции с файлами и описать как это проецируется в метаданные

| Оценка | Критерии |
|---|---|
| 8-10 | **на 10 баллов**: Преобразовать полученную таблицу в партиционированную. **на 9 баллов**: Трансформировать загруженные данные в таблицу Hive. **на 8 баллов**: Есть небольшие недочеты или ошибки |
...
| 0 | Задание на сдано / не выполнено |