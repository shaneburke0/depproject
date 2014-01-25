# remove all files from www
rm /var/www/*

# un-tar current www
cd /var
tar xf backup-www.tar.gz
echo "Unzipped WWW directory" /var


# remove all files from gci
rm /usr/lib/cgi-bin/*

# tar current cgi
cd /usr/lib
tar xf backup-cgi.tar.gz
echo "Unzipped CGI directory" /usr/lib


