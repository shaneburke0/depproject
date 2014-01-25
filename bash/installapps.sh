# install apps

apt-get -q -y install git-core
echo "Installed Git"

apt-get -q -y install apache2
echo "Installed Apache"

echo mysql-server mysql-server/root_password password password | debconf-set-selections

echo mysql-server mysql-server/root_password_again password password | debconf-set-selections

apt-get -q -y install mysql-server mysql-client
echo "Installed MySQL Server & Client"

apt-get -q -y install libwww-perl
echo "Installed libwww-perl"



