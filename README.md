Moonshot
========

Docker image to test CSC Moonshot

1. Build image
docker build -t moonshot .

2. Start container
docker run -dP --name moonshot moonshot

3. Find out host port for container port 22
docker port moonshot 22

4. Connect with ssh to host port
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -X dev@0.0.0.0 -p "PORT"
password=123

5. Run icommand
ils

