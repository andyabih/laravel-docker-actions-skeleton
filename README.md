# Laravel Skeleton for Docker & Github Actions
This is a template for Laravel projects that you are planning to run with both Docker & Github Actions.

# Installation & Usage
Due to the fact that you can't create a new Laravel project in a non-empty directory, you'll have to do some additional steps.

1. Follow the steps on the [Laravel website](https://laravel.com/docs/8.x/installation) to create a brand new Laravel project.
2. Clone this repository to a brand new folder outside your Laravel project.
3. Copy all the files that were cloned into your Laravel project.
4. Configure the environment by following the steps below.
5. Set up two branches on your repo. A `main` brancha and a `production` branch.
6. When you want to deploy to the server, simply push your changes to the `main` branch, and run the `deploy.sh` script which will merge your work to the `production` branch and run the workflow to deploy to the server.
7. To run the docker container, use the command the below command replacing the docker-compose file for different environments.
```
CURRENT_UID=$(id -u):$(id -g) docker-compose -f docker-compose-local.yml up -d
```

# Files
| File | Description |
|------|-------------|
| Dockerfile | Text document that Docker uses to build your image. |
| docker-compose-local.yml | Local docker compose file to create the PHP/Nginx/MySQL services. |
| docker-compose-dev.yml | Development server docker compose file to create the PHP/Nginx services using Traefik |
| deploy.sh | Quick bash script to push changes to production |
| .github/workflows/laravel.yml | Github Actions workflow to deploy to your server. |
| server_deploy.sh | Bash script that will run on the server by GitHub Actions to finish deployment. |
| docker/ | Folder containing MySQL, Nginx, and PHP configuration.

# Configuration
## .env
A sample .env file is included in the repository. Please add the configuration inside to your project's .env file.

`DOCKER_APP_NAME` is required for both environments and is used to create the docker containers, whereas the remaining MySQL variables are only required if you are using the `docker-compose-local.yml` file. 

## Dockerfile
Currently the two available versions for this skeleton are PHP 8.0 & PHP 7.4. To change between images, change the `FROM` value to either `FROM yllwdigital/yllwdev:8.0` or `FROM yllwdigital/yllwdev:7.4`

## server_deploy.sh
Add any additional steps you need to run while deploying (queues, for example) into that script.

## Github Actions
This was setup with the help of a [brilliant article by Samuel Stancl](https://laravel-news.com/push-deploy-with-github-actions) over at Laravel News. It should contain sufficient information for you to configure whatever is needed.

The primary thing that needs to be done is to create three [secrets](https://docs.github.com/en/actions/reference/encrypted-secrets) on Github.

`SSH_USERNAME` to contain your SSH username.
`SSH_HOST` to contain your host IP or domain.
`SSH_PRIVATE_KEY` to contain your private key to connect to the server.

You can change the configuration to use a password instead of a key by creating a secret called `SSH_PASSWORD` and changing line 17 to be `key: ${{  secrets.SSH_PASSWORD }}`.

It is also assumed that your website runs under the `/var/www/<domain>` directory. If that is not the case, you will need to modify the path on line 18 in the laravel.yml file.

## docker-compose-dev.yml
This docker-compose file should not be just copy pasted and ran. It primarily depends on your server configuration online and how you have things set up. 

The version in this repo assumes you have an external database server and not on the same server. If that is not the case, please incorporate the MySQL service from the local docker-compose file as well as the .env variables.

In addition, it uses Traefik to properly route everything and set up SSL certificates. [DigitalOcean have a brilliant article](https://www.digitalocean.com/community/tutorials/how-to-use-traefik-v2-as-a-reverse-proxy-for-docker-containers-on-ubuntu-20-04) explaining all about setting Traefik up and using it as a reverse proxy for Docker containers. Highly suggest using that.

If you are using Traefik, be sure to modify line 38 (`traefik.frontend.rule`) with the domain to your application.
