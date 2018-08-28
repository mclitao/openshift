#!/bin/sh

if  [ -f docker_images.txt ]
then

	echo -e "\033[32m ################################################ \033[0m"
     	echo -e "\033[31m ###           www.XcoloundLive.com          #### \033[0m"
      	echo -e "\033[33;5m ###       docker load image starting        #### \033[0m"
      	echo -e "\033[32m ################################################ \033[0m"



	echo -e "\033[32m ###              docke_image.txt           #### \033[0m"
        cat -n docker_images.txt


	while read LINE
        do
          echo -e "\033[32m ### loading.....[ ${LINE} ]... \033[0m"

	  FH_1=${LINE//\//\_}
	  FH_2=${FH_1//:/-}

	  #docker load < ${LINE//\//\_}.tar
          docker load < ${FH_2}.tar
          done < docker_images.txt

          echo -e "\033[32;5m ###        docker load all image finish      #### \033[0m"



else
     echo -e "\033[31;5m ###          docker_images.txt not find       #### \033[0m"
fi




