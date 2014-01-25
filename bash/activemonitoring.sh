echo "Monitoring website"
sudo perl perl/sitecheck.pl
echo "..."
echo "Monitoring apps"
perl perl/monitorapps.pl
echo "..."
echo "Monitoring disk space"
bash bash/monitordiskspace.sh
echo "..."
echo "Monitoring memory"
bash bash/monitormemory.sh
echo "..."