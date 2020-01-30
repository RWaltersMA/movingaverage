#!/bin/bash

cd mysqlimg
docker build -t mysqlimg:0.1 .

cd ../stockgenmysql
docker build -t stockgenmysql:0.1 .

cd ../stockgenmongo
docker build -t stockgenmongo:0.1 .

cd ../stockgenmysql
docker build -t stockgenmysql:0.1 .

cd ../stockportal
docker build -t stockportal:0.1 .

echo "Finished buiding demo images\n"

