ansible-role-vault
=========

Роль для установки/настройки Vault кластера

Требования
------------

- Доступ к ресурсу https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo с целевых машин.
- На хосте с которого запускается роль должен быть установлен модуль ansible-modules-hashivault  (https://pypi.org/project/ansible-modules-hashivault)

Переменные
--------------

| Variable | Type | Default | Comment |
| ------ | ------ | -------  | ---------- |
| vault_version | string | 1.5.2-1 | Версия Vault |
| vault_cluster_name | string | dct | Имя Vault кластера |
| vault_max_lease_ttl | string | 768h | Устанавливает max_lease_ttl параметр |
| vault_default_lease_ttl |  string | 768h | Устанавливает default_lease_ttl параметр |
| vault_cluster_disable | bool | false | Устанавливает disable_clustering параметр |
| vault_cluster_addr | string | "{{ vault_protocol }}://{{ vault_address }}:{{ (vault_port \| int) + 1}}" | Устанавливает cluster_addr параметр |
| vault_api_addr | string | "{{ vault_protocol }}://{{ vault_address }}:{{ vault_port }}" | Устанавливает api_addr параметр |
| vault_protocol | string | http | Использовать http или https протокол |
| vault_address | string | "{{ ansible_default_ipv4.address }}" | IP-адрес на котором запущен Vault  |
| vault_port | int| 8200 | На каком порту слушает Vault |
| vault_tls_disable | bool | true | Устанавливает tls_disable параметр |
| vault_consul | string | 127.0.0.1:8500 | Адрес Consul клиента |
|vault_consul_path | string | vault/ | Путь по которому будут храниться данные в  Consul |
| vault_consul_service | string | vault | Имя сервиса для регистрации в Consul |
| vault_consul_scheme | string | http | Схема для взаимодействия с Consul. "http" или "https" |
| vault_repo_url | string | https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo | URL HashiCorp репозитория |
| vault_unseal | bool | true | Если true - делать init и unseal при установки |
| vault_secret_shares | int | 5 | Количество share ключей на которые будет разбит master ключ |
| vault_secret_threshold | int | 3 | Количество share ключей для воссоздания master ключа |
| vault_backend | string | raft | Тип бэкенда для хранения секретов. Возможные значения: raft, consul |
| vault_raft_data_path | string | /srv/vault | Путь в файловой системе, где Vault хранит данные |
| vault_raft_node_id | string | "{{ ansible_nodename }}" | ID ноды в Raft кластере |
| vault_disable_mlock | bool | true | Отключает swap на диск |
| vault_service_registration_enabled | bool | True | Зарегистрировать сервис vault в consul когда используется Integrated storage |
| vault_telemetry_enabled | bool | True | Вкл/Выкл Vault метрики |
| vault_telemetry_prometheus_retention_time | string | 24h | Как долго Vault метрики хранятся в памяти |
| vault_telemetry_disable_hostname | bool | True | Не добавлять префикс hostname к метрикам |
| vault_telemetry_unauthenticated_metrics_access | bool | True | Доступ к метрикам без аутентификации(токена) |


Пример Плэйбука
----------------

    - hosts: vault-server
      remote_user: superuser
      become: yes
      vars:
        consul_node_role: client
      roles:
        - ansible-role-base
        - ansible-role-consul
        - ansible-role-vault


Пример ansible hosts файла для Consul+Vault
--------------------------------------------
    [consul-server]
    consul-0
    consul-1
    consul-2

    [vault-server]
    vault-0
    vault-1
    vault-2

Подключение Vault к FreeIPA
----------------------------
```
vault auth enable ldap
vault write auth/ldap/config url="ldap://10.193.92.22" \
    userdn="cn=users,cn=accounts,dc=platform,dc=tatar,dc=ru" \
    userattr="uid" \
    groupdn="cn=groups,cn=accounts,dc=platform,dc=tatar,dc=ru" \
    groupattr="cn" \
    binddn="uid=vault,cn=sysaccounts,cn=etc,dc=platform,dc=tatar,dc=ru" \
    bindpass='<STRONG_PASSWORD>' \
    starttls=false
```
Как создать системный аккаунт во FreeIPA: https://www.freeipa.org/page/HowTo/LDAP