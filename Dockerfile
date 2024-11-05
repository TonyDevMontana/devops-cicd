# Build stage
FROM oven/bun:alpine AS builder
WORKDIR /app
COPY package.json bun.lockb ./
RUN bun install
COPY . .
RUN bun run build

# Production stage
FROM oven/bun:alpine
WORKDIR /app
COPY package*.json ./
RUN bun install --production
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./
ENV NODE_ENV=production
EXPOSE 3000
CMD ["bun", "start"]