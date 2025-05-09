FROM node:22-alpine AS base

# Set working directory
WORKDIR /app

# Use non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app

# Set production environment
ENV NODE_ENV=production

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci --only=production

# Install development dependencies for migrations
FROM deps AS dev-deps
RUN npm ci

# Build and test stage
FROM dev-deps AS builder
WORKDIR /app
COPY . .
RUN npm run test:workflow

# Production stage
FROM base AS production
WORKDIR /app

# Copy from deps stage
COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --chown=appuser:appgroup . .

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:5000/ || exit 1

# Expose port
EXPOSE 5000

# Command to run the application
CMD ["npm", "start"]