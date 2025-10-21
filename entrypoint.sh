#!/bin/sh

CADDYFILE="/etc/caddy/Caddyfile"

# Если путь существует и это директория — удаляем её
if [ -d "$CADDYFILE" ]; then
  rm -rf "$CADDYFILE"
fi

# Создаём директорию, если её нет
mkdir -p "$(dirname "$CADDYFILE")"

# Перезаписываем файл нужным содержимым
cat > "$CADDYFILE" <<EOF
localhost {
  log {
    format json
  }

  # Компрессия
  encode zstd
  # Самоподписной сертификат
  tls internal

  # Проксирование всех запросов в app:8080
  # app – имя сервиса в docker-compose.yml
  reverse_proxy app:8080
}
EOF

# Запускаем Caddy
exec caddy run --config "$CADDYFILE"
