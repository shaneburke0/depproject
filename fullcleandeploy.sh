# run fullcleandeployscript and save all out o a text file with todays date and time
bash bash/fullcleandeploy.sh | tee logs/deploy/log-$(date +"%Y-%m-%d_%H:%M").log