# free memory
free_mem=`free -m |awk 'NR==2 {print $4}'`
# free cache memory
free_cache=`free -m |awk 'NR==3 {print $4}'`
# free swap memory
free_swap=`free -m |awk 'NR==4 {print $4}'`
# total free memory
free_total=$(($free_mem+$free_cache+$free_swap))

limit=1000

if [ $free_total -lt $limit ]; then
	echo "Memory is dangerously low: ${free_total} MB"
else
	echo "Memory free: ${free_total} MB"
fi
