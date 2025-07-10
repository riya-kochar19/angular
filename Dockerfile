# # Step 1: Build Angular App
# FROM node:22 AS build-stage
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build
# # Step 2: Serve with Nginx
# FROM nginx:alpine
# COPY --from=build-stage /app/dist/calculator-app /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
# Step 1: Build Angular App (skip or simulate broken build)
FROM node:22 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Optional: intentionally skip build or break it
RUN echo "<h1>Broken build</h1>" > /app/dist/index.html

# Step 2: Serve with broken Nginx
FROM nginx:alpine

# DO NOT copy Angular build (simulate broken deploy)
# COPY --from=build-stage /app/dist/calculator-app /usr/share/nginx/html

# Or copy empty index to still run but fail health check
COPY --from=build-stage /app/dist/index.html /usr/share/nginx/html/index.html

# Break nginx: remove default config so it returns 403
RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
