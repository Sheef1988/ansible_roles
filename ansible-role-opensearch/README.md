ansible-role-opensearch
=======================

Роль для установки/настройки OpenSearch кластера

Требования
------------

- Доступ к ресурсу https://artifacts.opensearch.org
- Рекомендованное количество RAM на хосте: {{ opensearch_jvm_xmx }} * 2

Переменные
--------------

| Variable | Type  | Default | Comment                                                                                                    |
| ------ |-------| -------  |------------------------------------------------------------------------------------------------------------|
| opensearch_version | string | 1.2.2 | Версия OpenSearch                                                                                          |
| opensearch_cluster_name | string | dtc | Имя кластера OpenSearch                                                                                    |
| opensearch_path_data | string | /var/lib/opensearch | Путь к директории с данным OpenSearch                                                                      |
| opensearch_path_logs | string |/var/log/opensearch | Путь к директории с логами OpenSearch                                                                      |
| opensearch_path_install | string | /usr/share/opensearch | Путь куда устанавливается OpenSearch                                                                       |
| opensearch_path_conf | string | /etc/opensearch | Путь с дополнительными конфигами и файлами, создаваемыми в процессе установки OpenSearch (ключи, lock файлы) |
| opensearch_http_port | int   | 9200 | HTTP порт для opensearch                                                                                   |
| opensearch_master_ansible_group | string | opensearch | Имя ansible группы(в inventory файле) c мастер-нодами OpenSearch                                           |
| opensearch_data_ansible_group | string | | Имя ansible группы(в inventory файле) c data-нодами OpenSearch                                             |
| opensearch_node_master | bool  | True | устанавливает роль master-ноды для хоста                                                                   |
| opensearch_node_data | bool  | True | устанавливает роль data-ноды для хоста                                                                     |
| opensearch_jvm_xms | string | 4g | минимальная выделяемая память Java virtual machine                                                         |
| opensearch_jvm_xmx | string | 4g | максимально выделяемая память Java virtual machine                                                         |
| opensearch_user | string | opensearch | opensearch пользователь от которого запускается процесс                                                    |
| opensearch_admin_password | string | admin | OpenSearch admin аккаунт                                                                                   |
| opensearch_java_home | string | /usr/lib/jvm/jre-openjdk | Устанавливает JAVA_HOME переменную среды                                                                   |
| opensearch_ldap_* |       | | Параметры для подключения к LDAP                                                                           |
| opensearch_openid_auth_domain | dict  | | Конфигурация интеграции с OIDC провайдером  |


Пример Плэйбука (OpenSearch + OpenSearch Dashboards)
----------------------------------------------------

    - hosts: opensearch_data
      remote_user: superuser
      become: True
      vars:
          opensearch_masters_ansible_group: opensearch_masters
          opensearch_data_ansible_group: opensearch_data
          opensearch_node_master: False
          opensearch_node_data: True
      vars_files:
        - certificates.yml
      roles:
        - ansible-role-openjdk
        - ansible-role-opensearch

    - hosts: opensearch_masters
      remote_user: superuser
      become: True
      vars:
          opensearch_masters_ansible_group: opensearch_masters
          opensearch_data_ansible_group: opensearch_data
          opensearch_node_master: True
          opensearch_node_data: False
          opensearch_openid_auth_domain:
            openid_auth_domain:
              http_enabled: true
              transport_enabled: true
              order: 0
              http_authenticator:
                type: openid
                challenge: false
                config:
                  subject_key: preferred_username
                  roles_key: roles
                  openid_connect_url: "https://sso.ru/auth/realms/myrealm.ru/.well-known/openid-configuration"
              authentication_backend:
                type: noop
      vars_files:
        - certificates.yml
      roles:
        - ansible-role-openjdk
        - ansible-role-opensearch
    
    - hosts: dashboards
      remote_user: superuser
      become: yes
      roles:
        - ansible-role-opensearch-dashboards
    

Пример ansible hosts файла для OpenSearch + Dashboards
--------------------------------------------
    [opensearch_data]
    opensearch-data-0
    opensearch-data-1
    
    [opensearch_masters]
    opensearch-0
    opensearch-1
    opensearch-2

    [dashboards]
    opensearch-0
    opensearch-1
    opensearch-2


Примечание
-----------------------------
Файл certificates.yml зашифрован с помощью ansible-vault. Он содержит самоподписные сертификаты и приватные ключи для работы Security плагина в OpenSearch
Пароль для ansible-vault лежит тут https://vault.platform.tatar.ru/ui/vault/secrets/secret/show/_common/ansible_vault
