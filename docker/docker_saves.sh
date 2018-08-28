#！/bin/bash

echo -e "\033[32m ################################################ \033[0m"
echo -e "\033[31m ###           www.XcoloundLive.com          #### \033[0m"
echo -e "\033[33;5m ###    docker saveing all image starting    #### \033[0m"
echo -e "\033[32m ################################################ \033[0m"


docker images --filter dangling=false |grep -v "REPOSITORY"|awk '{print $1":"$2}' >docker_images.txt

echo -e "\033[32m ###              docker image list          #### \033[0m"

cat -n docker_images.txt


if  [ -f docker_images.txt ]
then
	while read LINE
	do
		echo -e "\033[32m ### saveing.....[ ${LINE} ]... \033[0m"

		FH_1=${LINE//\//_}
		FH_2=${FH_1//:/-}
		docker save $LINE > ${FH_2}.tar

		done < docker_images.txt

	echo -e "\033[32;5m ###        docker saver all image finish      #### \033[0m"
else
	echo -e "\033[31;5m ###          docker_images.txt not find       #### \033[0m"
fi



