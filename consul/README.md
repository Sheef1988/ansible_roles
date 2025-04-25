ansible-role-consul
=========

Роль для установки/настройки Consul кластера


Переменные
--------------

| Variable | Type | Default | Comment                                                               |
| ------ | ------ | -------  |-----------------------------------------------------------------------|
| consul_version | string | 1.8.3-2 | Версия Consul                                                         |
| consul_hashi_repo_enabled | bool | True | Включен ли репозиторий HashiCorp                              |
| consul_nodename | string | "{{ ansible_nodename }}" | Имя ноды в кластере. Должно быть уникально в кластере.                |
| consul_datadir | string | /opt/consul | Директория с данными Consul агента для хранения состояния             |
| consul_domain |  string | consul | Имя домена                                                            |
| consul_datacenter | string | dct | Имя датацентра                                                        |
| consul_ip | string | "{{ ansible_default_ipv4.address }}" | IP-адрес на котором запущен Consul                                    |
| consul_http_port | int | 8500 | HTTP API порт                                                         |
| consul_dns_port | int | 8600 | DNS порт                                                              |
| consul_serf_lan_port | int | 8301 | LAN Serf порт                                                         |
| consul_serf_wan_port | int | 8302 | WAN Serf порт                                                         |
| consul_rpc_port | int | 8300 | RPC порт                                                              |
| consul_node_role | string | client | Роль Consul агента (клиент или сервер)                                |
| consul_ui | bool | false | Вкл/Выкл Consul UI                                                    |
| consul_ansible_group | string | consul-server | Имя группы узлов Consul агентов (в роли сервер) в ansible hosts файле |
| consul_services | list | [] | Список сервисов для обнаружения                                       |
| consul_enabled | bool | true | Запускать Consul после установки                                      |
| consul_telemetry_prometheus_retention_time | string | 1h | Сколько времени Consul хранит метрики в памяти                        |
| consul_telemetry_disable_hostname | bool | True | Не добавлять префикс hostname к runtime метрикам                      |


Пример Плэйбука
----------------

    - hosts: consul-server
      remote_user: superuser
      become: true
      vars:
        consul_node_role: server
      roles:
        - ansible-role-base
        - ansible-role-consul


Пример ansible hosts файла для Consul
--------------------------------------------
    [consul-server]
    consul-0
    consul-1
    consul-2
