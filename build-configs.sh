#!/bin/bash

PHP_VERSIONS="7.3 7.4 8.0 8.2"
NODE_VERSIONS="14 16 18 19"

for PHP_VERSION in $PHP_VERSIONS;
do
    for NODE_VERSION in $NODE_VERSIONS;
    do

        echo "Building php$PHP_VERSION node$NODE_VERSION config"

        DIR_NAME="php$PHP_VERSION-node$NODE_VERSION"
        mkdir -p "$DIR_NAME"

        cp entrypoint.sh "$DIR_NAME/entrypoint.sh"
        chmod +x "$DIR_NAME/entrypoint.sh"
        cp sudoers "$DIR_NAME/sudoers"

        PHP_PACKAGES=$(cat "packages-php$PHP_VERSION.txt" | xargs)

        sed "s/\#\#php-packages\#\#/$PHP_PACKAGES/" Dockerfile.template | sed "s/\#\#php-version\#\#/$PHP_VERSION/" > "$DIR_NAME/Dockerfile"
        sed -i "s/\#\#node-version\#\#/$NODE_VERSION/" $DIR_NAME/Dockerfile
    done
done
