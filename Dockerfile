FROM oven/bun:1 AS builder

WORKDIR /app
COPY package*.json ./
RUN bun install
COPY . .
RUN bun run build

FROM oven/bun:1-slim AS runner
WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules

# Define build arguments with default values
ARG PORT=3000
ARG HOST=0.0.0.0

# Set environment variables from build arguments
ENV PORT=${PORT}
ENV HOST=${HOST}

EXPOSE ${PORT}

CMD ["bun", "./build/index.js"]
