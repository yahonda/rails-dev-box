export DEBIAN_FRONTEND=noninteractive

# Install mssql-server
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.10/mssql-server.list | sudo tee /etc/apt/sources.list.d/mssql-server.list

apt-get update
apt-get install -y mssql-server

export SA_PASSWORD=Sqlpasswd1
sudo -E /opt/mssql/bin/sqlservr-setup --accept-eula --set-sa-password --start-service --enable-service

# Install mssql-tools

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.10/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
export ACCEPT_EULA=Y
sudo apt-get update
sudo -E apt-get -y install mssql-tools unixodbc-dev
ln -sfn /opt/mssql-tools/bin/sqlcmd-13.0.1.0 /usr/bin/sqlcmd

# create databases
sqlcmd -S localhost -U SA -P $SA_PASSWORD <<EOT
CREATE DATABASE [activerecord_unittest];
CREATE DATABASE [activerecord_unittest2];
GO
CREATE LOGIN [rails] WITH PASSWORD = '', CHECK_POLICY = OFF, DEFAULT_DATABASE = [activerecord_unittest];
GO
USE [activerecord_unittest];
CREATE USER [rails] FOR LOGIN [rails];
GO
EXEC sp_addrolemember N'db_owner', N'rails';
EXEC master..sp_addsrvrolemember @loginame = N'rails', @rolename = N'sysadmin'
GO
exit
EOT
