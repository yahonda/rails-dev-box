# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo installing OS packages
install Docker docker.io
install Alien alien

echo setting up Oracle database server on Docker
sudo -u vagrant -i git clone https://github.com/oracle/docker-images.git /home/vagrant/docker-images
sudo -u vagrant -i cp /vagrant/oracle-database-xe-18c-1.0-1.x86_64.rpm \
  /home/vagrant/docker-images/OracleDatabase/SingleInstance/dockerfiles/18.4.0/.
cd /home/vagrant/docker-images/OracleDatabase/SingleInstance/dockerfiles/
sudo ./buildDockerImage.sh -x -v 18.4.0
sudo docker run -d -p 1521:1521 -e ORACLE_PWD=admin123 --name oracle-container oracle/database:18.4.0-xe

echo setting up Oracle client
sudo -u vagrant -i cp /vagrant/oracle-instantclient18.3-basic-18.3.0.0.0-3.x86_64.rpm \
  /home/vagrant/.
sudo -u vagrant -i cp /vagrant/oracle-instantclient18.3-devel-18.3.0.0.0-3.x86_64.rpm \
  /home/vagrant/.
sudo -u vagrant -i cp /vagrant/oracle-instantclient18.3-sqlplus-18.3.0.0.0-3.x86_64.rpm \
  /home/vagrant/.

alien -i /home/vagrant/oracle-instantclient18.3-basic-18.3.0.0.0-3.x86_64.rpm
alien -i /home/vagrant/oracle-instantclient18.3-devel-18.3.0.0.0-3.x86_64.rpm
alien -i /home/vagrant/oracle-instantclient18.3-sqlplus-18.3.0.0.0-3.x86_64.rpm

sudo -u vagrant -i echo 'export PATH=/usr/lib/oracle/18.3/client64/bin:$PATH' \
  >> /home/vagrant/.bashrc
sudo -u vagrant -i echo 'export LD_LIBRARY_PATH=/usr/lib/oracle/18.3/client64/lib:$LD_LIBRARY_PATH' \
  >> /home/vagrant/.bashrc
sudo -u vagrant -i echo 'export NLS_LANG=American_America.AL32UTF8' \
  >> /home/vagrant/.bashrc
sudo -u vagrant -i echo 'export DATABASE_NAME=XEPDB1' \
  >> /home/vagrant/.bashrc

echo showing Oracle database status. Wait until "DATABASE IS READY TO USE!" message appears.
grep -m 1 "DATABASE IS READY TO USE!" <(sudo docker logs -f oracle-container)

echo 'rails-dev-box runs Oracle on Docker now!'
