# Step 1
FROM node:13.12.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN apk update && \
    apk add docker && \
    npm ci --silent && \
    npm install react-scripts@3.4.1 --silent
COPY . ./
RUN npm run build

# Step 2
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

