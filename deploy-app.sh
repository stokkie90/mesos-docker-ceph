#!/bin/bash

curl -i -H 'Content-Type: application/json' -d@$1 http://192.168.42.11:8080/v2/apps
