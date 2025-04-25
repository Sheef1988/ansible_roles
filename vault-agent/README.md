ansible-role-vault-agent
========================

Роль для установки/настройки Vault агента

Требования
------------

- Доступ к ресурсу https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo с целевых машин.

Переменные
--------------

| Variable | Type | Default | Comment |
| ------ | ------ | -------  | ---------- |
| vault_version | string | 1.5.2-1 | Версия Vault |
| vault_hashi_repo_enabled | bool | True | Включен ли репозиторий HashiCorp                              |
| vault_server_address | string | https://vault.prod.platform.ru | Адрес Vault сервера |
| vault_agent_address | string | 127.0.0.1:{{ vault_agent_port }} | На каком адресе запускать Vault агент |
| vault_agent_port |  int | 8200 | Устанавливает порт для Vault агента |
| vault_dir | string | /opt/vault | Корневая директория для агента |
| vault_secret_id_remove | bool | false | Удалить secret_id после получения токена |
| vault_cache_enabled | bool | true | Вкл/Выкл кэширование |
| vault_role_id | string | changeme | Role ID AppRole |
| vault_secret_id | string | changeme | Secret ID AppRole  |
| vault_role_id_file_path | string |/opt/vault/role-id | Файл, где хранится Role ID |
| vault_secret_id_file_path | string |/opt/vault/secret-id | Файл, где хранится Secret ID |
| vault_tls_disable | bool | true | Устанавливает tls_disable параметр |
| vault_token_path | string | /opt/vault/.vault-token | Файл, где хранится выданный токен |
| vault_num_retries | int | 10 | Количество повторов аутентификации и рендеринга шаблонов |
| vault_max_backoff | string | 300m | The maximum time Agent will delay before retrying after a failed auth attempt |
| vault_min_backoff | string | 30s | The minimum backoff time Agent will delay before retrying after a failed auth attempt |



Пример Плэйбука
----------------

    - hosts: all
      become: yes
      vars:
        vault_role_id: <very_secure_role_id>
        vault_secret_id: <very_secure_secret_id>
      roles:
        - ansible-role-vault-agent
