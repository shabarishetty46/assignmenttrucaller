Components:

1 Kubernetes master and 2 Worker nodes 
Jenkins server 
Docker Hub : shabarishetty46

Initial setup :
	Unzip the  Shabari_sre.tgz  and unzip in Jenkins Home directory (/var/lib/Jenkins) 

Jenkins Setup:
	Install Kubernetes plugin in Jenkins plugin manager 
	configure the newly install Kubernetes plugin in cloud . Provide the Kubernetes master url and store config file as credentials for deployment.
	Create a Jenkin Pipeline with Jenkinfile from the zip.

Jenkile file will take care of following stages.


1)	Docker images will be created  using DOKCERFILE . the images contains latest version of ruby gems and rails , Java , yorn , Sql lite and Cassandra  which is required to run the application .

2)	Created Docker images push to docker Hub for future use .
 
3)	Final stage of pipline the Jenkins will deploy the cassandra.yml to the kubemaster , which creates  3 pods replicas , load balanced services between pods .
   

  
 









