## Setup

1. Copy `.env.docker_example` to `docker/(prod|dev)/`
1. rename to .env
1. add your values
1. `cd /docker/(prod|dev)/` and build the docker container with `docker-compose up -d --build` or a GUI app
1. build the server with `yarn tsc`
1. run the DB migration `yarn migration:run` (the server uses typeORM)
1. run the server `yarn dev`

_(check package.json for other scripts)_

_you can now open the container with VSCode or another editor_
