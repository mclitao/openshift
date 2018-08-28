[点击查看官网](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#image-layering-and-sharing)
###### Log in to the Docker host you want to configure and stop the Docker daemon.
###### Install the LVM2 package. The LVM2 package includes the userspace toolset that provides logical volume management facilities on linux.
###### Create a physical volume replacing /dev/xvdf with your block device.

	$ systemctl stop docker
	$ pvcreate /dev/xvdf
	$ vgcreate docker /dev/xvdf

###### Create a thin pool named thinpool.
###### In this example, the data logical is 95% of the ‘docker’ volume group size.
###### Leaving this free space allows for auto expanding of either the data or metadata if space runs low as a temporary stopgap.
	$ lvcreate --wipesignatures y -n thinpool docker -l 95%VG
	$ lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
	$ lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta
	$ vim /etc/lvm/profile/docker-thinpool.profile
	activation {
	    thin_pool_autoextend_threshold=80
	    thin_pool_autoextend_percent=20
	}

	$ lvchange --metadataprofile docker-thinpool docker/thinpool

###### If the Docker daemon was previously started, clear your graph driver directory.
###### Clearing your graph driver removes any images, containers, and volumes in your Docker installation.
	$ rm -rf /var/lib/docker/*

###### Configure the Docker daemon with specific devicemapper options.
###### There are two ways to do this. You can set options on the command line if you start the daemon there:
	--storage-driver=devicemapper --storage-opt=dm.thinpooldev=/dev/mapper/docker-thinpool --storage-opt dm.use_deferred_removal=true

###### You can also set them for startup in the daemon.json configuration, for example:
	 {	
	     "storage-driver": "devicemapper",
	     "storage-opts": [
	         "dm.thinpooldev=/dev/mapper/docker-thinpool",
	         "dm.use_deferred_removal=true"
	     ]
	 }
 
 
###### If using systemd and modifying the daemon configuration via unit or drop-in file, reload systemd to scan for changes.
	$ systemctl daemon-reload && systemctl start docker

###### After you start the Docker daemon, ensure you monitor your thin pool and volume group free space.
###### While the volume group will auto-extend, it can still fill up. To monitor logical volumes, 
###### use lvs without options or lvs -a to see tha data and metadata sizes. To monitor volume group free space, use the vgs command.
###### Logs can show the auto-extension of the thin pool when it hits the threshold, to view the logs use:

	$ journalctl -fu dm-event.service

