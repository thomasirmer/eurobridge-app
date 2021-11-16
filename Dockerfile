# Build stage
FROM quay.io/upslopeio/node-alpine as builder

WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

# Run stage
FROM quay.io/upslopeio/node-alpine

WORKDIR /app
COPY --from=builder /app/public .
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
EXPOSE 3000

CMD ["npm", "run", "start"]