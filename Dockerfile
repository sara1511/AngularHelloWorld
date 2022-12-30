### Step 1 using node image and serve command
# FROM node:14
# # Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends openssh-server \
#     && echo "root:Docker!" | chpasswd
# # Copy resources
# RUN mkdir /app
# WORKDIR /app
# ENV PATH ./node_modules/.bin:$PATH
# COPY package*.json .
# # Run install build scripts
# RUN npm install --silent
# RUN npm install -g serve --silent
# COPY . .
# RUN npm run build
# # Copy the sshd_config file to the /etc/ssh/ directory
# COPY sshd_config /etc/ssh/
# # Copy startup script and make it executable
# COPY startup.sh .
# # Open port 2222 for SSH access
# EXPOSE 8080 2222
# RUN chmod 755 ./startup.sh
# ENTRYPOINT ["./startup.sh"]



### Step 2 using node image and nginx command
### STAGE 1: Build ###
FROM node:14 as build
RUN mkdir /app
WORKDIR /app
ENV PATH ./node_modules/.bin:$PATH
COPY package*.json .
RUN npm install --silent
COPY . .
RUN npm run build

### STAGE 2: Production Environment ###
FROM nginx:alpine
RUN mkdir /start
WORKDIR /start
# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/
# Copy startup script and make it executable
COPY startup.sh .
# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apk add openssh \
     && echo "root:Docker!" | chpasswd \
     && chmod +x /start/startup.sh \
     && cd /etc/ssh/ \
     && ssh-keygen -A

COPY --from=build /app/dist/hello-world /usr/share/nginx/html

EXPOSE 80 2222
ENTRYPOINT ["/start/startup.sh"]
