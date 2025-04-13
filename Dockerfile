FROM oven/bun

WORKDIR /app

ARG PORT=80
ARG HOST=0.0.0.0

ENV PORT=${PORT}
ENV HOST=${HOST}
ENV IS_DEV=false

COPY package*.json ./
RUN bun install
RUN bun install svelte-adapter-bun

COPY . .
RUN bun run build

EXPOSE ${PORT}

CMD ["bun", "run", "./build/index.js"]
