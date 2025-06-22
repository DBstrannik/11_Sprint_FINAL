# Используем официальный образ Go для сборки
FROM golang:1.22-alpine AS builder

# Устанавливаем зависимости для сборки SQLite
RUN apk add --no-cache gcc musl-dev

# Создаем рабочую директорию
WORKDIR /app

# Копируем файлы модулей и загружаем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код
COPY *.go ./

# Собираем приложение
RUN CGO_ENABLED=1 GOOS=linux go build -o /tracker

# Используем минимальный образ для запуска
FROM alpine:latest

# Устанавливаем зависимости для работы SQLite
RUN apk add --no-cache libc6-compat

# Копируем бинарный файл из стадии builder
COPY --from=builder /tracker /tracker

# Копируем файл базы данных (если нужно)
COPY tracker.db /tracker.db

# Указываем точку входа
ENTRYPOINT ["/tracker"]
