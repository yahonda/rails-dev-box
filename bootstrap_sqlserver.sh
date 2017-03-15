export DEBIAN_FRONTEND=noninteractive

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce -y

# Allow ubuntu user to run docker without sudo
sudo gpasswd -a ubuntu docker
sudo service docker restart

# Install mssql-tools
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.10/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
export ACCEPT_EULA=Y
sudo apt-get update
sudo -E apt-get -y install mssql-tools unixodbc-dev
ln -sfn /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd