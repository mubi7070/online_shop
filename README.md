# Online Shop 🛍️ – Hackathon Phase 1 Submission
**Creator:** Mubashir Ahmed

**Branch:** final-solution-phase1

This document provides a step-by-step guide on setting up and running the online_shop project using Linux, Git, and Docker.

## Table of Contents
- [Tasks](#tasks)
- [Initializing Git](#initializing-git)
- [Setting Up the Development Environment](#setting-up-the-development-environment)
- [Implementation of Docker](#implementation-of-docker)
  - [Dockerfile](#dockerfile)
  - [Building a Docker Image](#building-a-docker-image)
  - [Running the Docker Container](#running-the-docker-container)
- [Managing Docker Containers and Images](#managing-docker-containers-and-images)
- [Working with Multi-Stage Builds (Distroless Images)](#working-with-multi-stage-builds-distroless-images)
- [Creating and Managing Docker Networks and Volumes](#creating-and-managing-docker-networks-and-volumes)
- [Using Docker Compose](#using-docker-compose)
- [Pushing Docker Image to Docker Hub](#pushing-docker-image-to-docker-hub)
- [Managing Git Repository And Finalizing the project](#managing-git-repository-and-finalizing-the-project)
- [Conclusion](#conclusion)

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
4. Running the Docker Container
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

docker stop d5f8 && docker rm d5f8  (To stop & remove in a single command)
```
2. Removing Docker Images
```bash
docker rmi e2999b7661ce (image_id) - (To remove a single image at a time)
docker rmi $(docker images -aq) - (To remove all images in one time)
```
3. Pruning Docker System (Remove all)
```bash
docker system prune
```

## Working with Multi-Stage Builds (Distroless Images)
1. Creating a Multi-Stage Docker Build / Distroless Images
```bash
vim dockerfile-multi-stage-new
```
2. **dockerfile-multi-stage-new code:**
```bash
#Stage 1
#Base Image
FROM node:18-alpine AS builder

# Here is Work directory
WORKDIR /app

# Copy and install dependencies from package.json and package-lock.json
COPY package.json package-lock.json ./

# Installation here
RUN npm install

#Copy the stuff and run the build
COPY . .
RUN npm run build

#Stage 2
# Distroless Image
FROM gcr.io/distroless/nodejs:18

#work directory
WORKDIR /app

# Copy required files from builder (Stage 1)
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# Expose port
EXPOSE 5173

# Run
# Need to define this path (node_modules/.bin/serve) as the app is not reading it automatically in distroless.
CMD [ "node_modules/.bin/serve", "-s", "dist", "-l", "5173" ]
```

**Note / Instructions:**
In this distroless image docker file, 
  - I took the base image of node (node:18-alpine) and give an alias to it (builder)
  - I have set the working directory
  - I have copied the files "package.json" and "package-lock.json" first as these files contains all the dependencies which are required to run this application.
  - Then, I run "RUN npm install" which means now it will install all the dependencies mentioned in the above files.
  - Then, I copied (COPY . .) all the files and directories from local to the container.
  - Then, I have initialized the build creation using the command. (RUN npm run build)
  - Here the 1st stage is ended.
  - In the 2nd Phase, I took the distroless image of node (FROM gcr.io/distroless/nodejs:18)
  - I have set the working directory for this stage also.
  - Then, I have copied only the required directories from stage 1 to stage 2 to reduce the image size and maintain security. 
  - COPY --from=builder /app/dist ./dist (The app creates the static files in the dist directories so that's why i have copied this)
  - COPY --from=builder /app/node_modules ./node_modules (The node_modules are required as all the dependencies are stored in it)
  - Now, I have exposed the port which is defined in the code of the application (EXPOSE 5173)
  - Then, I need to define this path (node_modules/.bin/serve) as the app is not reading it automatically in distroless. The server command is used to run the app and the distroless image doesn't have npm.

3. Building the Distroless Image
```bash
docker build -f ./dockerfile-multi-stage -t onlineapp-mini:latest .
```
(-f represents docker file path and -t represents the tag)

4. Running the Multi-Stage Container using distroless image
```bash
docker run -p 3000:5173 --name onlineapp-mini onlineapp-mini:latest
docker run -d -p 3000:5173 --name onlineapp-mini onlineapp-mini:latest  (To run in detach mode)
```

## Creating and Managing Docker Networks and Volumes
1. Creating Docker Volume
```bash
docker volume create onlineapp
docker inspect onlineapp
```
2. Creating Docker Network
```bash
docker network create onlineapp-network
docker inspect onlineapp-network
```
3. Updating Permissions for Docker Volume
```bash
sudo chmod 777 /var/lib/docker/volumes/onlineapp/_data
```

## Using Docker Compose

1. Creating and Editing docker-compose.yml
```bash
vim docker-compose.yml
```
2. **docker-compose.yml code:**
```bash
services:
  onlineapp:
    build:
      context: .
      dockerfile: dockerfile-multi-stage-new
    container_name: onlineapp
    networks:
      - onlineapp-network
    ports:
      - "3000:5173"

networks:
  onlineapp-network:
```

**Note / Instructions:**
In this docker compose file, 
  - We have a single container (onlineapp)
  - First, we have configured the directory and docker file name in the build for the build creation.
  - then, we assigned the container name
  - then, we have linked it with a user defined bridge network.
  - Assign the external and internal ports as the app is accessible on port 3000 externally and the app is running on port 5173 as per it's configuration.
  - We need to change the port as per the requirement in the task.


3. Starting Services with Docker Compose
```bash
docker compose up
docker compose up -d   (To run it in detach mode)
```
4. Stopping Services (It will remove also)
```bash
docker compose down
```

## Pushing Docker Image to Docker Hub
1. Logging into Docker Hub
```bash
docker login
```
2. Tagging and Pushing Image
```bash
docker image tag online-app:latest mubashirahmed324/online-app:latest
docker push mubashirahmed324/online-app:latest
```
3. Verification
```bash
Go to your docker hub account and in repositories, you will see this image.
```

## Managing Git Repository And Finalizing the project
1. Checking Git Branch
```bash
git branch
```
2. Committing and Pushing Changes
```bash
git status
git add *
git commit -m "Dockerfile created successfully"
git push origin dev
```
(Not included all the commits here.)

3. Creating a New Branch for Final Submission
```bash
git checkout -b final-solution-phase1
git status
git push origin final-solution-phase1
```
4. Updating README File
```bash
mv README.md README-old.md   (Rename the old README.md file)
git rm README.md
git add README-old.md
git commit -m "Updating the README.md File for submission"
git push origin final-solution-phase1
touch README.md
git add README.md
git commit -m "Adding New README.md file"
git push origin final-solution-phase1
```

## Conclusion
This document provides a comprehensive guide and steps to setting up, running, and managing the online_shop project using Linux, Git, and Docker. By following these steps, you can successfully build and deploy the application while maintaining a clean and organized development environment.
The video link is also attached in which i am explaining the flow and the code part.

Video Link: https://drive.google.com/file/d/1tKAIIsrygYqsdLos6xPrhdUQqeFU4rXH/view?usp=sharing

Happy Learning :)
