# Use Node.js to build the React app
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy the rest of the app and build it
COPY . .
RUN npm run build

# Use Nginx to serve the built app
FROM nginx:alpine

# Remove default Nginx configuration and copy our custom config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built app from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose the port Nginx will run on
EXPOSE 80 
# Start Nginx 
CMD ["nginx", "-g", "daemon off;"]
