##########################################################################

# stage1 - build react app first
FROM node:14.20.0-alpine3.16 as build

WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# Don’t run Node.js apps as root
# Docker defaults to running the process in the container as the
# root user, which is a precarious security practice. Use a low
# privileged user and proper filesystem permissions:
# USER node
# • COPY --chown=node:node . /usr/src/app

# it works if file in the same folder as Dockerfile
COPY --chown=node:node ./package.json .
COPY --chown=node:node ./package-lock.json .

# Optimize Node.js apps for production
# Some Node.js libraries and frameworks will only enable
# production-related optimization if they detect that the
# NODE_ENV env var set to production
ENV NODE_ENV production

# If you are building your code for production
# RUN npm install --only=production
#RUN npm ci --only=production
RUN npm install

# When you use COPY it will copy the files from the local source, in this case . meaning the files in the current directory, to the location defined by WORKDIR. In the above example, the second . refers to the current directory in the working directory within the image.
COPY --chown=node:node . .

RUN npm run build
# Only locally, on prod we use Jenkins for that.
#CMD "npm" "start"

##########################################################################

# stage 2 - build the final image and copy the react build files
FROM nginx:1.23.0-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80
# ENTRYPOINT ["nginx", "-g", "daemon off;"]
# CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
# CMD ["nginx", "-g", "daemon off;"]
# CMD ["nginx"]
