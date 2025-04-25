ansible-role-opensearch-dashboards
==================================

Роль для установки/настройки OpenSearch Dashboards

Требования
------------

- Доступ к ресурсу https://artifacts.opensearch.org
 полный список релизов https://artifacts.opensearch.org

Переменные
--------------

| Variable | Type | Default | Comment |
| ------ | ------ | -------  | ---------- |
| dashboards_version | string | 1.2.0 | Версия OpenSearch Dashboards |
| dashboards_server_host | string |"{{ ansible_default_ipv4.address }}" | Адрес для подключения к Dashboards  |
| dashboards_user | string | opensearch | Пользователь от которого запускается Dashboards |
| dashboards_path_install | string | /usr/share/opensearch-dashboards | Полный путь к каталогу для установки Dashboards |
| dashboards_server_port |  int | 5601 | Порт для подключения к Dashboards |
| dashboards_os_port | int | 9200 | Порт для подключения Dashboards к OpenSearch |
| dashboards_server_name | string| DTC | A human-readable display name that identifies this Dashboard instance  |
| dashboards_ansible_group | string | opensearch | Имя ansible группы(в inventory файле) c нодами OpenSearch |
| dashboards_os_hosts | string | вычисляется из inventory | Хосты OpenSearch к которым подключается каждый инстанс Kibana |
| dashboards_os_username | string | kibanaserver | Пользователь для подключения к OpenSearch |
| dashboards_os_password | string | kibanaserver | Пароль для пользователя {{ dashboards_os_username}} |
| dashboards_openid_enabled | bool | True | Вкл/выкл авторизацию через IdP |
| dashboards_base_redirect_url | string | http://logs.prod.platform.tatar.ru | The base of the redirect URL that will be sent to your IdP |
| dashboards_connect_url | string | https://sso.platform.tatar.ru/auth/realms/tatar.ru/.well-known/openid-configuration | The URL where the IdP publishes the OpenID metadata |
| dashboards_client_id | string | change_me | The ID of the OpenID Connect client configured in your IdP |
| dashboards_client_secret | string | change_me | The client secret of the OpenID Connect client configured in your IdP |




Пример Плэйбука
----------------

    - hosts: dashboards
      remote_user: rashaev
      become: true
      roles:
        - ansible-role-opensearch-dashboards
    

Пример ansible inventory файла для OpenSearch + Dashboards (depricated)
----------------------------------------------------------
    [opensearch]
    opensearch-1
    opensearch-2
    opensearch-3

    [dashboards]
    opensearch-1
    opensearch-2
    opensearch-3

Создание приложения в аванпост
----------------------------------------------------------
Для интеграции OpenSearch с Модулем идентификации и аутентификации необходимо создать приложение типа «OpenID» в Avanpost.FAM с парметрами, представленными ниже:

| Атрибут                                  | Значение                                                                               |
| ---------------------------------------- | -------------------------------------------------------------------------------------- |
| Наименование                             | platform_logging-s<tand_code>                                                           |
| Публичный                                | Деактивировано                                                                         |
| Client ID                                | Значение задается автоматически                                                        |
| ID synonym                               | platform_logging-<stand_code>                                                           |
| Base URL                                 | https://logging.<stand_code>.platform.tatar.ru                                          |
| Redirect URls                            | https://logging.<stand_code>.platform.tatar.ru/auth/openid/login
|                                          |   https://logging.<stand_code>.platform.tatar.ru                                        |
| Backchannel-logout URI                   | Пусто                                                                                  |
| Post logout redirect URIs                | https://logging.<stand_code>.platform.tatar.ru                                          |
| Audience                                 | Пусто                                                          |
| Client assertion type                    | client_secret_basic                                                                    |
| Audience type                            | Массив                                                                                 |
| Allowed grant types                      | Authorization code                                                                     |
| Access token lifetime (in seconds)       | 1800                                                                                   |
| Access token type                        | Случайное значение                                                                     |
| Authorization code lifetime (in seconds) | 300                                                                                    |
| Refresh token lifetime (in seconds)      | 3600                                                                                   |
| Refresh token strategy                   | Деактивировано                                                                         |
| ID token lifetime (in seconds)           | 3600                                                                                   |
| End session strategy                     | Clear                                                                                  |
| Scope (default)                          | openid profile email groups:name:by_app                                                |
| Ошибки аутентификации                    | Деактивировано                                                                         |
| Allowed origins                          | Пусто                                                                                  |
| Client_secret                            | Случайно сгенерированное значение из 20 любых символов (без использования символа <?>) |


После чего создать группу с наименованием «platform_logging-<stand_code>-admin» и добавить в нее созданное приложение.

Далее на любом (не имеет значение на каком сервере OpenSearch вносятся изменения, т.к. сама конфигурация записывается в БД – данную операцию достаточно выполнить один раз) сервере platform-<stand_code>-opensearch-cluster_number>-host_number> необходимо отредактировать раздел authc в файле /usr/share/opensearch/opensearch-Y.Y.Y/plugins/opensearch-security/securityconfig/config.yml (Y.Y.Y – версия opensearch) применив следующие строки (при этом всё предыдущее содержимое раздела authc следует закомментить):

```
authc:
   basic_internal_auth_domain:
     description: "Authenticate via HTTP Basic against internal users database"
     http_enabled: true
     transport_enabled: true
     order: 0
     http_authenticator:
       type: basic
       challenge: false
     authentication_backend:
       type: internal
   openid_auth_domain:
     http_enabled: true
     transport_enabled: true
     order: 1
     http_authenticator:
       type: openid
       challenge: true
       config:
         subject_key: preferred_username
         roles_key: groups
         openid_connect_url: https://sso.<stand_code>.platform.tatar.ru/.well-known/openid-configuration
         skip_users:
           - kibanaserver
     authentication_backend:
       type: noop
```
После редактирования файла конфигурации для того, чтобы записать настройки в базу данных необходимо выполнить следующую команду:

```
sudo /usr/share/opensearch/opensearch-X.X.X/plugins/opensearch-security/tools/securityadmin.sh   -f /usr/share/opensearch/opensearch-X.X.X/plugins/opensearch-security/securityconfig/config.yml -icl -nhnv -cacert /usr/share/opensearch/opensearch-X.X.X/config/root-ca.pem -cert /usr/share/opensearch/opensearch-X.X.X/config/admin.pem -key /usr/share/opensearch/opensearch-X.X.X/config/admin-key.pem h <ip address>
```

Далее на сервере platform-stand_code>-dashboards-cluster_number>-host_number> необходимо отредактировать файл /usr/share/opensearch-dashboards/opensearch-dashboards-Y.Y.Y/config/opensearch_dashboards.yml (Y.Y.Y – версия opensearch-dashboards) закоментировать следующие строки:

```
#opensearch_security.auth.type: "openid"
#opensearch_security.openid.connect_url: "https://sso..platform.tatar.ru/.well-known/openid-configuration"
#opensearch_security.openid.client_id: "platform_logging-"
#opensearch_security.openid.client_secret: "XXXXXXXXXX"
#opensearch_security.openid.scope: "openid profile email groups:name:by_app"
#opensearch_security.openid.base_redirect_url: "https://logging.<stand_code>.platform.tatar.ru"
#opensearch_security.multitenancy.tenants.enable_private: false
#opensearch_security.multitenancy.tenants.enable_global: false
```

После редактирования выполнить перезагрузку с помощью команды:
`sudo systemctl restart opensearch-dashboards.service`

После чего необходимо добавить бэкенд-роль администратора OpenSearch. Для этого необходимо перейти в веб интерфейс OpenSearch (в Identity Provider должна быть назначена группа с наименованием «admins»), далее перейти в раздел Security > Roles, найти в перечне ролей строку «all_access» и перейти по ней, далее перейти на вкладку «Mapped_users», нажать на кнопку «Manage mapping», далее нажать кнопку «Add another backend role» и в поле «Type in backend role» внести значение:
`platform_logging-<stand_code>-admin`

Сохранить и применить изменения, нажав на кнопку «Map». В результате в Модуле добавится бэкенд-роль для обеспечения доступа администратора.

Далее на сервере platform-stand_code>-dashboards-cluster_number>-host_number> необходимо отредактировать файл /usr/share/opensearch-dashboards/opensearch-dashboards-Y.Y.Y/config/opensearch_dashboards.yml (Y.Y.Y – версия opensearch-dashboards) раскоментировать следующие строки:

```
opensearch_security.auth.type: "openid"
opensearch_security.openid.connect_url: "https://sso..platform.tatar.ru/.well-known/openid-configuration"
opensearch_security.openid.client_id: "platform_logging-"
opensearch_security.openid.client_secret: "XXXXXXXXXX"
opensearch_security.openid.scope: "openid profile email groups:name:by_app"
opensearch_security.openid.base_redirect_url: "https://logging.<stand_code>.platform.tatar.ru"
opensearch_security.multitenancy.tenants.enable_private: false
opensearch_security.multitenancy.tenants.enable_global: false
```

После редактирования выполнить перезагрузку с помощью команды:
`sudo systemctl restart opensearch-dashboards.service`