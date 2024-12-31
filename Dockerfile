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
RUN bun install

# EXPOSE 3000
# ENV PORT=3000
# ENV HOST=0.0.0.0

CMD ["bun", "./build/index.js"]
