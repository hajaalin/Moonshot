Moonshot
========

Docker image to test CSC Moonshot

# build image
docker build -t moonshot .

# start container
docker run -dP --name moonshot moonshot

# find out host port for container port 22
docker port moonshot 22

# connect with ssh to host port
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -X dev@0.0.0.0 -p "PORT"

password=123

