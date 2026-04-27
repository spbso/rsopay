# Базовый образ (можно выбрать версию Node.js, например, node:18, node:alpine)
FROM node:22-alpine AS builder

WORKDIR /app

COPY /app .
RUN npm ci
#RUN npm install
RUN npm run build

FROM nginx:stable AS app
#EXPOSE 3000

WORKDIR /app
COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
