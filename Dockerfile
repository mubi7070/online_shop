# Base Image

From node:18-alpine

# Working directory for the app

WORKDIR /app

# Copy only the required code from host to container

COPY src/ /app/src/
COPY public/ /app/public/
COPY index.css package.json eslint.config.js index.html package-lock.json vite.config.js /app/

# RUN the required commands

RUN npm install

# Expose the port

EXPOSE 5173

# To serve the app and keep it running

CMD ["npm","run","dev"]
