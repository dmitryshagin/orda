
# Servers updater

Эта фигня проходиться по списку серверов и устанавливает/обновляет ддосер.

Обернуто в докер, что бы не устанавливать зависимости.

#### Usage

Из директории с `Dockerfile` собираем контейнер. Надо сделать один раз, ну или если что-то обновится в будущем.

```bash
docker build . -t update_ddos_servers
```

Обновить списко серверов в `servers/servers.txt`. Каждая строка - это один сервер в виде `IP username password`. Обязательна одна пустая строка в конце!

выполнить комманду из директории, в которой находится `servers/servers.txt`

```bash
docker run --rm -v $(pwd)/servers:/servers update_ddos_servers
```

#### Notes

В `runner.sh` должна быть строка `#runner_version=1`, где цифра - версия раннера. Поддерживается только целые числа (1, 2, 3...)

#### Unnecessary details

- `Dockerfile` и так понятно
- `servers_update.sh` запускается в контейнеру
- `init.sh` запускается на сервер, по другому не получилось(
- `servers/servers.txt` список серверов
