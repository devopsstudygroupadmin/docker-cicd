                -------------------------------------------------------
			| CONTINUOUS INTEGRATION PIPELINE FOR JAVA APPLICATION |
			-------------------------------------------------------
Author:	LOUIS R. NDJOCK
TOOLS:
	VS Code:		Source code management tool
	Git:			Version Control System	
	GitHub:		Remote Repository 
	Jenkins:		Continuous Integration
	Maven:		Build Tool 
	Tomcat: 		Open source web server
	SonarQube:		Code Analisys
	Jfrog:		Artifact Repository
	Terraform:		Infrastructure as a code tool				
=================================================================================
			O - PREREQUISIST
=================================================================================

1. Login to your AWS console
2. Find Amazon Simple Email Service
3. Create identity and verified your email
	both jenkins admin email and receipiant email
4 Create SMTP creadentials
SMTP settings > Create SMTP credentials > Create > credentials.csv(download)
5. Copy the  SMTP endpoint
SMTP settings
	email-smtp.us-east-1.amazonaws.com

SMTP endpoint:		email-smtp.us-east-1.amazonaws.com
Port:				465
Smtp Username:		"Your SMTP username"
Smtp password:		"your SMTP password"
Jenkins admin:		devopsstudygroup@gmail.com
The Receipiant:		lrndjock@gmail.com

==================================================================================
			I - PREPARING THE SERVERS
==================================================================================
-------------------------------------------
A - SPINNUP ALL THE SERVERS OF THE PROJECT
------------------------------------------
1. Download the CI-Infrastructure-Automation-Terraform zip file
2. Unzip this file and copy the contain of the folder
3. Create a project folder and paste the contain you copied in the project folder
4. Open the project folder using Visual Studio Code
5. In the file main.tf, update your region and your profile
6. Update the "key_name" by your key pair name in all the files in the project
7. Update the "private_key" path in all the files in the project
8. Save all your changes and run:
terraform init
terraform apply

------------------------------------------------------------
B - PREPARING SONARQUBE SERVER FOR INTEGRATION WITH JENKINS
-----------------------------------------------------------

>>>>>>>>>>>>>>>>>>>>>>On SonarQube CLI<<<<<<<<<<<<<<<<<<<<<
1. SSH into the server and start up sonarqube
# Become root
sudo su -
# Set hostname
hostnamectl set-hostname sonarqube
bash
# Verify sonaruser exit
id sonaruser
# Set passwd for sonaruser
passwd sonaruser
	sonarqube123
	sonarqube123
# Become sonaruser
su - sonaruser
# CD to the bin directory of sonarqube
cd /opt/sonarqube/bin/linux-x86-64
# Start SonarQube
./sonar.sh start

>>>>>>>>>>>>>>>>>>>>>>On SonarQube UI<<<<<<<<<<<<<<<<<<<<<
2. Login to the sonarque web browser UI console
http://<public_IP>:9000/
login
admin
admin

3. Generate a Token to authenticate with Jenkins
Administrator > My Account > Security
	Generate Tokens > "jenkins-token" > Generate(Click)
	copy (token)
	1b2d7fde669eff9860369ad4df7401895dcf8b0e

----------------------------------------------------------
C - PREPARING JFROG SERVER FOR INTEGRATION WITH JENKINS
--------------------------------------------------------	

>>>>>>>>>>>>>>>>>>>>On jFrog server CLI<<<<<<<<<<<<<<<<<<<<<<<<<<<
1. SSH into the server and start up jfrog
# Become root
sudo su -
# Set hostname
hostnamectl set-hostname jfrog
bash	
# CD to the bin directory of jfrog
cd /opt/jfrog/bin
# Start jfrog
./artifactory.sh start
	
>>>>>>>>>>>>>>>>>>>>On jFrog server UI<<<<<<<<<<<<<<<<<<<<<<<<<<<
2. Login to the jfrog console, set admin password and create a maven Artifactory repository
http://<PUBLIC_IP_Address>:8081 
username: admin
password: Admin@123
Skip
Maven
Create
Finish

3. Create a jenkins user on jFrog
Admin > Users > + New
User Name:			jfrog-user
Email Address:		myemail@gmail.com
Admin Privileges
Password:			Jfrog@123
Retype Password:		Jfrog@123
Save	

--------------------------------------------------------
D - PREPARING Tomcat SERVER FOR INTEGRATION WITH JENKINS
---------------------------------------------------------
	
>>>>>>>>>>>>>>>>>>>>On Tomcat server CLI<<<<<<<<<<<<<<<<<<<<<<<<<<<
1. SSH into tomcat server and start up tomcat
# Become root
sudo su -
# Set hostname
hostnamectl set-hostname tomcat
bash	
# Start tomcat
tomcatup

>>>>>>>>>>>>>>>>>>>>On tomcat server UI<<<<<<<<<<<<<<<<<<<<<<<<<<<
2. Access the Tomcat server UI and Login to Manager App console
# Access Tomcat UI
http://<public+ip>:8080/
# Login to Manager App using admin credentials
http://<public+ip>:8080/Manager app
	admin
	admin	

---------------------------------------------------------	
E - PREPARING Maven SERVER FOR INTEGRATION WITH JENKINS
---------------------------------------------------------
	
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>On your Maven server CLI<<<<<<<<<<<<<<<<<<<<<
1. Create jenkins user on maven server and enable password authentication
# Become root
sudo su -
# Set hostname
hostnamectl set-hostname maven
bash
# Verify maven is install
mvn --version
# Verify if a jenkins user exit
id jenkins
# Set password for thr jenkins user
passwd jenkins
	jenkins123
# Login as jenkins user
su - jenkins
# Print Working Directory
pwd
# List the jenkins home directory
ls -lrt

--------------------------------------------------------------------
F - PREPARING THE JENKINS SERVER FOR INTEGRATION WITH OTHER SERVERS
--------------------------------------------------------------------

>>>>>>>>>>>>>>>>>>>>On jenkins server CLI<<<<<<<<<<<<<<<<<<<<<<<<<<<
1. SSH into the jenkins server and verify if jenkins is running
# Become root
sudo su -
# Set hostname
hostnamectl set-hostname jenkins
bash
# Verify jenkins is running
systemctl status jenkins
clear

2. Prepare the connection of jenkins with maven
# Verify if a jenkins user exit
id jenkins
# Verify that jenkins can SSH into maven server
ssh jenkins@<Maven_public_IP>
exit

3. Prepare the connection of jenkins with SonarQube
# Open the file sonar-scanner.properties using nano
nano /opt/sonar-scanner/conf/sonar-scanner.properties
# Uncomment the following line
	# sonar.host.url=http://localhost:9000
# Replace "localhost" with the private IP of Sonarqube
	sonar.host.url=http://<Sonarqube_private_ip>:9000
# Save and exit the file
Ctrl+x y Enter

4. Gather data for Jenkins configuration on the UI
# Get java and maven home path here
cat .bash_profile
# Get Git path here
whereis git
# Get the Admin default password
cat /var/lib/jenkins/secrets/initialAdminPassword


==================================================================================
			II - CONFIGURING THE JENKINS SERVER TO INTEGRATE OTHER SERVERS
==================================================================================

1. Login into jenkins on web browser, set admin user credentials
# Access Jenkins on the web browser using default admin password
http://<public_IP_Jenkins>:8080/
	(paste password)
# Install suggested plugins
Getting Started
	Install suggested plugins
# Create your first Admin user in Jenkins
Create First Admin User
	Username:			jenkins
	Password:			jenkins123
	Confirm Password:	jenkins123
	Full Name:			jenkins
	E-mail address:		youremail

2. Add all plugins needed for the Jenkins Integration with other servers
Dashboard > Manage Jenkins > Manage Plugins
	Available(search for plugins):
		# Plugins for maven integration
		Maven Integration(checkbox)
		Maven Invoker(checkbox)
		# Plugin for Tomcat integration
		Deploy to container(checkbox)
		# Plugin for Jfrog Artifactory
		Artifactory(checkbox)
		# Plugin for SonarQube
		SonarQube Scanner(checkbox)
	Install without restart(click)

3. Add your maven server to Jenkins as a New Node
Dashboard > Manage Jenkins > Manage Nodes and Clouds > New Node
	Node name	maven_build_server
	Permanent Agent(checkbox) > OK

	Name	
		Maven_build_server
	description	
		Maven build server
	#of executors
		5
	Remote root directory
		/home/jenkins
	Launch method
		Launch agent vis SSH
	Host
		Private_IP_maven
	Credentials > add
			Username		jenkins
			Password		jenkins123
			ID			jenkins	
			Add
		jenkins(select)
	Host Key Verification Strategy
		Non verifying Verification Strategy
	Save

4. Integrate all plugins in the jenkins global configuration tool
Dashboard > Manage Jenkins > Global Tool Configuration
	# Integrating java
	JDK > Add JDK
		Name
			java-11
		JAVA_HOME
			/usr/lib/jvm/java-11-amazon-corretto.x86_64/

	# Integrating Git			
	Git > Git installations
		Name
			git
		Path to Git executable
			/usr/bin/git
			
	# Integrating SonarQube Scanner
	SonarQube Scanner installations > Add SonarQube Scanner
		Name		sonar-scanner
		(uncheck install automatically)
		SONAR_RUNNER_HOME	/opt/sonar-scanner				
			
	# Integrating Maven			
	Maven > Add Maven
		Name
			maven 3.9.1
		MAVEN_HOME
			/opt/maven
Apply
Save

5. Setting System Configuration for Jenkins to integrate other servers
Dashboard > Manage Jenkins > Configure System
System Admin e-mail address:		devopsstudygroup@gmail.com
	SonarQube installations
	Add SonarQube
		Name:					sonarqube-server
		Server URL:			http://<Sonarqube_private_ip>:9000

		Advance > Webhook Secret > add(jenkins)
			Kind:				Secret Test
			Secret:			1b2d7fde669eff9860369ad4df7401895dcf8b0e
			ID:				sonarqube-token
			Description:		sonarqube-token
			Add
		Server authentication token:
							sonarqube-token
			Webhook Secret:		sonarqube-token
			
	JFrog Platform Instances  > Add JFrog Platform Instance
		Instance ID 				ArtifactoryServer
		JFrog Platform URL			http:<jFrog_public_IP>:8081
		Default Deployer Credentials
			Username	     			jfrog-user	
			Password				Jfrog@123
			Test Connection
	Credentials
		Add > jenkins
			Username: 				tomcat
			Password:				tomcat
			ID:					tomcat-user
			Description:			tomcat-user
			Add

	Extended E-mail Notification
		SMTP server
			email-smtp.us-east-1.amazonaws.com
		SMTP Port
			465
		Advance
		+ Add
			SMTP Username
				"From credentials file"
			SMTP Password
				"From credentials file"
		Default Recipients
			lrndjock@gmail.com
		Reply To List
			lrndjock@gmail.com
		Use SSL
		Enable Debug Mode
		Default Triggers
			Always 
		E-mail Notification
		SMTP server
			email-smtp.us-east-1.amazonaws.com
		Advance
		Use SMTP Authentication
			Username
				"From credentials file"
			Password
				"From credentials file"
		Use SSL
		SMTP Port
			465
		Reply To List
			lrndjock@gmail.com
		Test configuration by sending test e-mail
			lrndjock@gmail.com
		Test configuration
Apply
Save


===========================================================================================
			III - TESTING YOUR PIPELINE BY CREATING A JOB
===========================================================================================
1. Enable Webhook on the github repo
under the repository
yourgithubusername > jenkins-ci-demo > Settings > Wbhooks > Add webhook
Payload URL
	http://<IP_JENKINS_SERVER>:8080/github-webhook/
	Or
	http://dns:8080/github-webhook/
Content type
	application/json

Add webhook

2. Create the CI Job on Jenkins
New Item
	CI-Job
	Freestyle project
	OK
	Description
		Demo of continous Integration: Github, Jenkins, Maven, Sonarqube, Tomcat and Jfrog
	Restrict where this project can be run
		Label Expression
			maven_build_server	
 	Git(checkbox)
	https://github.com/devopsstudygroupadmin/jenkins-ci-demo.git
	*/main
	Build Triggers
		GitHub hook trigger for GITScm polling
	Build Environment
		Maven3-Artifactory Integration
			Artifactory server:
				ArtifactoryServer http:<jFrog_public_IP>:8081/artifactory
			Refresh Repositories
			Target release repository:
				libs-release-local
			Target snapshots repository:
				libs-snapshot-local
	Build Steps
		Add build step
			Invoke Artifactory Maven 3
				Maven Version:		maven-3.9.1
				Root POM:			pom.xml
				Goals and options:	clean install
	Post-build Actions 
		Add post-build action 
			SonarQube analysis with Maven
				Advanced 
					Maven Version:	 maven-3.9.1
	Post-build Action
		Add post-build action
			Deploy war/ear to a container
				
				WAR/EAR files 		**/*.war
				Containers 		Tomcat 10x Remote
				Credentials 		tomcat
			Tomcat URL	http://<Tomcat_public_ip>:8080/
	Post-build Action
		Add post-build action
			Editable Email Notification
				Attach Build Log
					Attach Build Log		
	Apply
Save

3. Clone Your repository on your local computer
git clone https://github.com/devopsstudygroupadmin/jenkins-ci-demo.git

4. Open jenkins-ci-demo using visual studio code and make some changes on the index.jsp file
5. Save and commit the changes
6. Verify that jenkins have trigger a new build
7. Verify the other servers for changes
8. Repeat steps 4 to 7 as many times you want.


		---------------------------------------------------
		| CONGRATULATIONS!!! FOR YOUR FIRST CICD PIPELINE |
		---------------------------------------------------







































	
	
	
	
	
	
	
	
	
	
	
	
	
	
	