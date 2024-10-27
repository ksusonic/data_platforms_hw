# Настройка nginx для проксирования интерфейсов

### Hadoop

Конфиг `hadoop-proxy` поместить в `/etc/nginx/sites-available/hadoop_proxy`

```
sudo ln -s /etc/nginx/sites-available/hadoop_proxy /etc/nginx/sites-enabled/hadoop_proxy
sudo systemctl restart nginx
```
