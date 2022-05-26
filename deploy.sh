#!bin/bash

#Unique Identifier for the image
sha=$(git rev-parse HEAD)

##Build docker images with latest and $sha tag
docker build -t sahilgulati102/multi-client:$sha -f ./client/Dockerfile ./client
docker build -t sahilgulati102/multi-server:$sha -f ./server/Dockerfile ./server
docker build -t sahilgulati102/multi-worker:$sha -f ./worker/Dockerfile ./worker

docker build -t sahilgulati102/multi-client:latest -f ./client/Dockerfile ./client
docker build -t sahilgulati102/multi-server:latest -f ./server/Dockerfile ./server
docker build -t sahilgulati102/multi-worker:latest -f ./worker/Dockerfile ./worker

#Push images to docker hub
docker push sahilgulati102/multi-client:$sha
docker push sahilgulati102/multi-server:$sha
docker push sahilgulati102/multi-worker:$sha

docker push sahilgulati102/multi-client:latest
docker push sahilgulati102/multi-server:latest
docker push sahilgulati102/multi-worker:latest

##Apply all k8s config

kubectl apply -f k8s

##Imperatively set latest image in k8

kubectl set image deployments/server-deployment server=sahilgulati102/multi-server:$sha
kubectl set image deployments/client-deployment client=sahilgulati102/multi-client:$sha
kubectl set image deployments/worker-deployment worker=sahilgulati102/multi-worker:$sha
