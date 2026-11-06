FROM node:18-alpine

WORKDIR /usr/src/app

COPY app/package*.json ./
RUN npm install

COPY app/ .

# Configuration is supplied when the container is created.
# No API_KEY or misleading LOGLEVEL default belongs in this image.

CMD [ "npm", "start" ]
