#!/shane/scripts/bash
# awk grabs the fifth column, and cut removes the trailing percentage.
DISKSPACE=`df -H /dev/sda1 | sed '1d' | awk '{print $5}' | cut -d'%' -f1`

# Disk capacity threshold
HIGHPERC=70
MINPERC=20
if [ ${DISKSPACE} -ge ${HIGHPERC} ]; then
    echo "Disk space dangerously low....${DISKSPACE}% capacity."
elif [ ${DISKSPACE} -lt ${MINPERC} ]; then
    echo "Still plenty of disk space....${DISKSPACE}% capacity."
else
    echo "Disk space ....${DISKSPACE}% capacity."	
fi
