# docker-php71

## What is this?

This is a custom build based on PHP 7.1's docker image, with changes to make Laravel testing easily possible.

## Where can I find it?

You can find the image on Docker Hub here: https://hub.docker.com/r/nicoverbruggen/php71/.

## GitLab CI

For example, if you are running GitLab, you can use `.gitlab-ci` on your custom GitLab instance:

```
image: nicoverbruggen/php71:latest

cache:
  paths:
  - vendor/

tests:
  script:
  - curl -sS https://getcomposer.org/installer | php
  - php composer.phar install
  - cp .env.testing .env
  - vendor/bin/phpunit --configuration phpunit.xml --coverage-text --colors=never
```

This will allow automatic tests of your application to occur.

## How can I build this myself?

Use the Dockerfile, customize it as desired and build it!

    Docker build -t yourname/nameofimage .
    docker push yourname/nameofimage

Anyone can run it afterwards:

    docker run yourname/nameofimage