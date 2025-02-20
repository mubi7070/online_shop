# Base Image

From node:18-alpine

# Working directory for the app

WORKDIR /app

# Copy only the required code from host to container

COPY . .

# RUN the required commands

RUN npm install

# Expose the port

EXPOSE 5173

# To serve the app and keep it running

CMD ["npm","run","dev"]
