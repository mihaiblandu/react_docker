FROM node:18-alpine AS build
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install

# Copy source and build
COPY public ./public
COPY src ./src
COPY vite.config.js ./
COPY eslint.config.js ./
COPY index.html ./

RUN pnpm run build

# Production stage
FROM macbre/nginx-http3:latest

# Install curl
#RUN apk add --no-cache curl

# Copy built app
COPY --from=build /app/dist /usr/share/nginx/html
# Copy entrypoint.sh docker-entrypoint.sh
#COPY entrypoint.sh /docker-entrypoint.d/entrypoint.sh
#RUN chmod +x /docker-entrypoint.d/entrypoint.sh
# Copy with executable permissions

USER root

# Production stage
# Copy built app
COPY --from=build /app/dist /usr/share/nginx/html

# Copy configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Expose ports
EXPOSE 80 443

# Use sh to run the script (bypasses permission issues)
ENTRYPOINT ["sh", "/entrypoint.sh"]

