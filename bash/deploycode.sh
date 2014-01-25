# tar current www
cd /var
tar -zcvf backup-www.tar.gz www

# tar current cgi
cd /usr/lib
tar -zcvf backup-cgi.tar.gz cgi-bin

cd /home/shane/scripts/packages/
# version is a variable which stores the num of file/dirs in the current directory
VERSION=$(ls -d */ | wc -w | cut -f1 -d' ')
SANDBOX=pkg_v$VERSION
# make sandbox folder
mkdir $SANDBOX
# apply read/write
chmod 777 $SANDBOX
cd $SANDBOX/
# get code from git source
git clone https://github.com/FSlyne/NCIRL.git
echo "Git source cloned to - $SANDBOX"
echo 'Date: ' $(date +"%Y-%m-%d_%H:%M") > log.txt


cd NCIRL/
# deploy www code to apache
cp Apache/www/* /var/www/
echo "Deployed www"
# deploy cgi code
cp Apache/cgi-bin/* /usr/lib/cgi-bin/
echo "Deployed cgi"
chmod a+x /usr/lib/cgi-bin/*
cd ../../..


