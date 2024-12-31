FROM oven/bun:1 AS builder

WORKDIR /app

COPY package*.json ./
COPY bun.lockb ./

RUN bun install

COPY . .

# RUN bun run build

FROM oven/bun:1-slim AS runner
WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/bun.lockb ./bun.lockb

RUN bun install

ARG PORT=3000
ARG HOST=0.0.0.0

ENV PORT=${PORT}
ENV HOST=${HOST}
ENV NODE_ENV=production

EXPOSE ${PORT}

CMD ["bun", "./build/index.js"]
