# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json .
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build --prod

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/dist/bydjo-ecommerce/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Remove default nginx config
RUN rm -f /etc/nginx/conf.d/default.conf.bak

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
