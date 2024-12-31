FROM oven/bun:1 AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY bun.lockb ./

# Install dependencies
RUN bun install

# Copy source files
COPY . .

# Build the application
RUN bun run build

FROM oven/bun:1-slim AS runner
WORKDIR /app

# Copy built application and necessary files
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/bun.lockb ./bun.lockb

# Install only production dependencies
RUN bun install --production

# Define build arguments with default values
ARG PORT=3000
ARG HOST=0.0.0.0

# Set environment variables from build arguments
ENV PORT=${PORT}
ENV HOST=${HOST}
ENV NODE_ENV=production

EXPOSE ${PORT}

# Run the server
CMD ["bun", "./build/index.js"]
