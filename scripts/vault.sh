#!/bin/bash

container="vault-dev"

# start container 


echo 'Stop Container Existente'
docker stop $container
sleep 1
echo

echo 'Removendo Existente'
docker rm --force $container
sleep 1
echo

echo 'Iniciando Container'
docker run -d -p 8200:8200 --cap-add=IPC_LOCK --name $container --hostname $container -e VAULT_ADDR='http://0.0.0.0:8200' wilton/vault:1.5.3 
echo

values_doker () {   
echo 'Aguardando Token Vault'
echo
sleep 2

docker logs $container 2>&1 | grep  "Unseal Key"

docker logs $container 2>&1 | grep  "Root Token" 

}

values_doker
echo


