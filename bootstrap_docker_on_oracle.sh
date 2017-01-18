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
sudo -u vagrant -i git clone -b runs_oracle_enhanced https://github.com/yahonda/docker-images.git \
  /home/vagrant/docker-images
sudo -u vagrant -i cp /vagrant/p17694377_121020_Linux-x86-64_*.zip \
  /home/vagrant/docker-images/OracleDatabase/dockerfiles/12.1.0.2/.
sudo -u vagrant -i cp /vagrant/p24433133_121020_Linux-x86-64.zip \
  /home/vagrant/docker-images/OracleDatabase/dockerfiles/12.1.0.2/.
sudo -u vagrant -i cp /vagrant/p24917069_121020_Linux-x86-64 \
  /home/vagrant/docker-images/OracleDatabase/dockerfiles/12.1.0.2/.
cd /home/vagrant/docker-images/OracleDatabase/dockerfiles
sudo ./buildDockerImage.sh -v 12.1.0.2 -e
sudo docker run -d -p 1521:1521 --name yahonda oracle/database:12.1.0.2-ee

echo setting up Oracle client
sudo -u vagrant -i cp /vagrant/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
  /home/vagrant/.
sudo -u vagrant -i cp /vagrant/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm \
  /home/vagrant/.
sudo -u vagrant -i cp /vagrant/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm \
  /home/vagrant/.

alien -i /home/vagrant/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
alien -i /home/vagrant/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
alien -i /home/vagrant/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

sudo -u vagrant -i echo 'export PATH=/usr/lib/oracle/12.1/client64/bin:$PATH' \
  >> /home/vagrant/.bashrc
sudo -u vagrant -i echo 'export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib:$LD_LIBRARY_PATH' \
  >> /home/vagrant/.bashrc
sudo -u vagrant -i echo 'export NLS_LANG=American_America.AL32UTF8' \
  >> /home/vagrant/.bashrc
sudo -u vagrant -i echo 'export DATABASE_NAME=ORCLPDB1' \
  >> /home/vagrant/.bashrc

echo showing Oracle database status. Wait until "DATABASE IS READY TO USE!" message appears.
docker logs `docker ps -q

echo 'rails-dev-box runs Oracle on Docker now!'
