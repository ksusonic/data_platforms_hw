# Настройка nginx для проксирования интерфейсов

### Hadoop

Конфиг `hadoop-proxy` поместить в `/etc/nginx/sites-available/hadoop-proxy`

```
sudo ln -s /etc/nginx/sites-available/hadoop-proxy /etc/nginx/sites-enabled/hadoop-proxy
sudo systemctl restart nginx
```
