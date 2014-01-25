# tar current www
cd /var
tar -zcvf backup-www.tar.gz www

# tar current cgi
cd /usr/lib
tar -zcvf backup-cgi.tar.gz cgi-bin

# get code from git source
cd /home/shane/scripts/packages/
VERSION=$(ls -d */ | wc -w | cut -f1 -d' ')
SANDBOX=pkg_v$VERSION
mkdir $SANDBOX
chmod 777 $SANDBOX
cd $SANDBOX/
git clone https://github.com/FSlyne/NCIRL.git
echo "Git source cloned to - $SANDBOX"
echo 'Date: ' $(date +"%Y-%m-%d_%H:%M") > log.txt


cd NCIRL/
cp Apache/www/* /var/www/
echo "Deployed www"
cp Apache/cgi-bin/* /usr/lib/cgi-bin/
echo "Deployed cgi"
chmod a+x /usr/lib/cgi-bin/*
cd ../../..


