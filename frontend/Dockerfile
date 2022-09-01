FROM node:16-alpine as build

# install dependencies
RUN apk --no-cache add curl

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# Copy all local files into the image.
COPY . .
RUN curl -L -o static/logo.png "https://drive.google.com/uc?id=13_sIKRsy1FqV_oepcS2jUIeOaawFZzio"
RUN curl -L -o static/logo_mini.png "https://drive.google.com/uc?id=1_z4sgZNGziFXWZ3WksIvKJUjuAdSxXfP"

RUN npm run build

###
# Only copy over the Node pieces we need
# ~> Saves 35MB
###
FROM node:16-alpine

WORKDIR /app
COPY --from=build /app .
COPY . .

EXPOSE 3000
CMD ["node", "./build"]