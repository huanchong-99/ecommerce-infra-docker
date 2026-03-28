# Placeholder Dockerfile for Web-frontend
# Replace this file with your actual application Dockerfile
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
run npm run build
FROM node:18-alpine
WORKdir /app
COPY --from=build /app/.next . ./.next . .
COPY --from=build /app/.next/standalone . .
    .next/ . /usr/share/nginx/html:/usr/share/nginx/html:50
HEALTHcheck --interval=30s --timeout=10s --start-period=30s --retries=3 \
  curl -f http://localhost:3000/health || exit 1
cmd ["node", "server.js"]
EXPOSE 3000

