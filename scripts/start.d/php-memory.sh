#!/bin/bash

sed -i "s/;MEMORY/memory_limit = ${PHP_MEMORY_LIMIT}/" \
  /usr/local/etc/php/php.ini
