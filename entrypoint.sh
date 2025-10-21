#!/usr/bin/env bash
set -e

# Путь к Caddyfile внутри контейнера
CADDYFILE="/etc/caddy/Caddyfile"

# Если путь существует и это директория — удаляем
if [ -d "$CADDYFILE" ]; then
  echo "[INFO] $CADDYFILE is a directory. Removing..."
  rm -rf "$CADDYFILE"
fi

# Создаём директорию /etc/caddy, если её нет
mkdir -p "$(dirname "$CADDYFILE")"

# Создаём Caddyfile с нужной конфигурацией
cat > "$CADDYFILE" <<'EOF'
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

echo "[INFO] Caddyfile created at $CADDYFILE"

# Запускаем Caddy
exec caddy run --config "$CADDYFILE"
