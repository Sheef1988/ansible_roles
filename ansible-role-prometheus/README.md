Роль
=========

Установка/настройка сервера системы мониторинга Prometheus.

Требования
------------

- systemd на целевом хосте

Переменные
------------

| Variable | Type | Default | Comment |
| ------ | ------ | -------  | ---------- |
| prometheus_user | string | prometheus | Пользователь, под которым работает служба |
| prometheus_dir | string | /usr/local/bin | Директория, куда копируется бинарник |
| prometheus_datadir | string | /data/prometheus | Директория хранения метрик  |
| prometheus_etcdir | string | /etc/prometheus | Директория, куда копируется файл конфигурации |
| prometheus_version | string | 2.19.2 | Версия исполняемого файла |
| prometheus_check_address | string | http://127.0.0.1:9090 | Адрес для проверки службы |
| prometheus_node_exporter_targets | list | 127.0.0.1:9100 | Список опрашиваемых хостов с node_exporter |
| prometheus_storage_tsdb_retention | string | 1d | Время жизни метрик в tsdb |
| prometheus_alertmanager_targets | list | 127.0.0.1:9093 | Список хостов с AlertManager |
| prometheus_victoria_url | string | http://localhost:8428/api/v1/write | url для remote write |
| prometheus_victoria_max_samples_per_send | int | 100 | Max samples per send can be adjusted depending on the backend in use. Many systems work very well by sending more samples per batch without a significant increase in latency. |
| prometheus_victoria_capacity | int | 500 | Capacity controls how many samples are queued in memory per shard before blocking reading from the WAL. Once the WAL is blocked, samples cannot be appended to any shards and all throughput will cease. Capacity should be high enough to avoid blocking other shards in most cases, but too much capacity can cause excess memory consumption and longer times to clear queues during resharding. |
| prometheus_victoria_max_shards | int | 1000 | Max shards configures the maximum number of shards, or parallelism, Prometheus will use for each remote write queue. Prometheus will try not to use too many shards, but if the queue falls behind the remote write component will increase the number of shards up to max shards to increase throughput. |
| prometheus_scrape_configs | list | [] | Section specifies a set of targets and parameters describing how to scrape them |

Пример плэйбука
--------------

    - hosts: prometheus
      remote_user: superuser
      become: yes
      vars:
        - prometheus_node_exporter_targets:
          - 127.0.0.1:9100
        - prometheus_victoria_url: "http://localhost:8428/api/v1/write"
        - prometheus_victoria_max_samples_per_send: 10000
        - prometheus_victoria_capacity: 20000
        - prometheus_victoria_max_shards: 30
      roles:
        - ansible-role-prometheus
