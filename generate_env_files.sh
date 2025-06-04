#!/bin/bash
set -e

if [ ! -f .env ]; then
  echo "❌ .env 파일이 없습니다. .env.example을 복사해 작성해 주세요."
  exit 1
fi

# 안전하게 .env 파일 읽기
set -a
source .env
set +a

# Create Backend application.properties

mkdir -p ./Backend
cat <<EOF > Backend/application.properties
spring.application.name=KNU-2025S-CDP-Team06-Backend

spring.datasource.url=jdbc:$DATABASE_URL
spring.datasource.username=root
spring.datasource.password=$DATABASE_PW

spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update

springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.swagger-ui.operations-sorter=method
springdoc.swagger-ui.tags-sorter=alpha
springdoc.swagger-ui.tryItOutEnabled=true
springdoc.default-produces-media-type=application/json

jwt.secret=$JWT_SECRET
jwt.expiration=$JWT_EXPIRATION

moki.api.url=$MOKI_SALES_API_URL
spring.jackson.property-naming-strategy=SNAKE_CASE
EOF

# Create MLOps config.py
mkdir -p MLOps
cat <<EOF > ./MLOps/config.py
class Config:
    OPEN_WEAHTER_API_KEY = "$OPEN_WEATHER_API_KEY"
    KAKAO_REST_API_KEY = "$KAKAO_REST_API_KEY"
    MOKI_SALES_API_URL = "$MOKI_SALES_API_URL"
    MOKI_STORE_INFO_URL = "$MOKI_STORE_INFO_URL"
    MOKI_MENU_API_URL = "$MOKI_MENU_API_URL"
    AI_TRIGGER_URL = "$AI_TRIGGER_URL"
    STORE_PASSWORD = "$STORE_PASSWORD"
    TEMPORARY_ADDRESS = "$TEMPORARY_ADDRESS"
    ADMIN_ID = "$ADMIN_ID"
    ADMID_NAME = "Admin"
    ADMIN_PASSWORD = "$ADMIN_PASSWORD"

    DB_CONFIG = {
        "host": "moki-db",
        "user": "root",
        "password": "$DATABASE_PW",
        "database": "moki",
        "port": $MYSQL_INNER_PORT
    }
    DATABASE_URL = "mysql+py$DATABASE_URL"
config = Config
EOF

# Create MLOps stores.json
echo "$STORES_JSON" > MLOps/stores.json

# Create AI config.py
mkdir -p AI
cat <<EOF > AI/config.py
class Config:
    BACKEND_URL = "$BACKEND_URL"
    ADMIN_ID = "$ADMIN_ID"
    ADMIN_PASSWORD = "$ADMIN_PASSWORD"
config=Config
EOF
