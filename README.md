# Online Shop 🛍️ – Hackathon Phase 1 Submission
This document provides a step-by-step guide on setting up and running the online_shop project using Linux, Git, and Docker.

## Table of Contents


---

## Tasks
All the tasks and workflows are mentioned in Hackathon branch. (Link: https://github.com/mubi7070/online_shop)

**Note:** Using the Commands from the history to add to this README file.

**Task Descriptions & Implementations:**

## Initializing Git
1. Fork the git repository from the shared repository: https://github.com/iemafzalhassan/online_shop
2. Clone the Git Repository.

```bash
mkdir -p Hackathon
cd Hackathon/
git clone https://github.com/mubi7070/online_shop.git
cd online_shop/
```

3. Initialize Git and Configure Branch

```bash
git init
git branch
git checkout -b dev
git branch
git push origin dev
```

4. Configure Remote Repository
```bash
git remote -v
git remote add origin https://<your-personal-access-token>@github.com/mubi7070/online_shop.git
git remote set-url origin https://<your-personal-access-token>@github.com/mubi7070/online_shop.git
git remote -v
git branch
git push origin dev
git branch
ls
```

## Setting Up the Development Environment
1. Checking System and Installing Dependencies
```bash
sudo apt update
sudo apt install npm
node -v
npm -v
```
2. Initializing the Project
```bash
npm init -y
npm install
```
3. Starting the Development Server for testing
```bash
npm run dev
```

## Implementation of Docker

### Dockerfile
1. create and edit the Dockerfile
```bash
vim Dockerfile
```
2. **Dockerfile code:**
```bash
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
```
3. Building a Docker Image
```bash
docker build -t onlineapp:latest .
docker images
```
4.Running the Docker Container
```bash
docker run -p 5173:5173 --name onlineapp onlineapp:latest
```

## Managing Docker Containers and Images

1. Listing and Stopping Containers
```bash
docker ps
docker ps -l
docker stop f1dbfb957f00 (container_id)
docker rm f1dbfb957f00 (container_id)
```
2. Removing Docker Images
```bash
docker rmi e2999b7661ce (image_id) - (To remove a single image at a time)
docker rmi $(docker images -aq) - (To remove all images in one time)
```



       

