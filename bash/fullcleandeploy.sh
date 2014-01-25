#!/shane/deploy

clear
START=$(date +%s.%N)
echo "Starting deploy script"
echo "..."
echo "Stopping services..."
bash bash/stopservices.sh
echo "..."
echo "Updating apps..."
apt-get update
echo "Finished updating"
echo "..."
echo "Uninstalling apps..."
bash bash/uninstallapps.sh
echo "..."
echo "Clean install apps"
bash bash/installapps.sh
echo "..."
echo "Get & deploy source code"
bash bash/deploycode.sh
echo "..."
echo "Starting services"
bash bash/startservices.sh
echo "..."
echo "Creating DB tables"
bash bash/createDb.sh
echo "..."
echo "Checking Apache"
perl perl/apachecheck.pl
echo "..."
echo "Checking MySQL"
perl perl/mysqlcheck.pl
echo "..."
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
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "Finished in $DIFF seconds"
echo "..."
echo "Starting active monitoring..."
echo "..."
while [ true ]; do
 sleep 60
  bash bash/activemonitoring.sh
done
