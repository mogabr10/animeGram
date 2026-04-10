# Build stage
FROM cirrusci/flutter:latest as builder

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web --release

# Production stage
FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
