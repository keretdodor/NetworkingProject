#!/bin/bash


if [ -z $1 ]; then
    echo "an IP is needed to excute the script"
    exit 1
fi

cp newkey oldkey
cp newkey.pub oldkey.pub

ssh-keygen -t rsa -b 4096 -f newkey -N ""

chmod 600 ~/key.pem
if scp -i ~/key.pem ~/newkey.pub ubuntu@$1:~; then
   cp key.pem oldkey
   ssh -i key.pem ubuntu@$1 mv ~/newkey.pub .ssh/authorized_keys
else
  if [ $? -eq 1 ]; then
    chmod 600 oldkey
    cp newkey oldkey
    cp newkey.pub oldkey.pub
    scp -i ~/oldkey ~/newkey.pub ubuntu@$1:~ 
    ssh -i old_key ubuntu@$1 mv ~/newkey.pub .ssh/authorized_keys
  fi
fi