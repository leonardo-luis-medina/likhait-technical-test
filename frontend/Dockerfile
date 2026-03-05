FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Fix npm optional dependency bug
RUN rm -rf node_modules package-lock.json && npm install --legacy-peer-deps

# Copy application code
COPY . .

# Expose port
EXPOSE 5173

# Start Vite dev server
CMD ["npm", "run", "dev", "--", "--host"]