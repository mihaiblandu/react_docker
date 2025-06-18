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
FROM nginx:1.23.3-alpine

# Install curl
RUN apk add --no-cache curl

# Copy built app
COPY --from=build /app/dist /usr/share/nginx/html
# Copy entrypoint.sh docker-entrypoint.sh
#COPY entrypoint.sh /docker-entrypoint.d/entrypoint.sh
#RUN chmod +x /docker-entrypoint.d/entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port
EXPOSE 80

# Set entrypoint and default command
CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["/entrypoint.sh"]

