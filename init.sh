#!/bin/sh
JBOSS_HOME=./target/jboss-soa-p-5
SERVER_DIR=$JBOSS_HOME/jboss-as/server/default
EDS_HOME=$JBOSS_HOME/eds

# Create the target directory if it does not already exist
if [ ! -d target ]; then
    mkdir target
fi

# Move the old JBoss instance, if it exists, to the OLD position
if [ -x $JBOSS_HOME ]; then
    rm -rf $JBOSS_HOME.OLD
    mv $JBOSS_HOME $JBOSS_HOME.OLD
fi

echo 
# Unzip the JBoss SOA-P instance
echo Unpacking JBoss Enterprise SOA Platform 5.2...
unzip -q -d target installs/soa-p-5.2.0.GA.zip
echo Done!
# Unzip the EDS instance
echo Installing JBoss EDS 5.2...
unzip -q -d $JBOSS_HOME installs/eds-p-5.2.0.GA.zip
echo Done! 
# Add execute permissions to the run.sh script
chmod u+x $JBOSS_HOME/jboss-as/bin/run.sh
echo
#Install EDS by calling ant
echo Setting up EDS on "default" profile...
ant -Dprofile=default -f $EDS_HOME/build.xml
echo Done!
#Copy config files
echo Installing configuration files
cp config/*.xml $SERVER_DIR/deploy
cp config/*.properties $SERVER_DIR/conf/props
echo Done!
#Install File DS
echo Installing File DS
cp -r data $JBOSS_HOME
echo Done!
#Deploy demo VDB
echo Deploying VDB
cp db/Portfolio.vdb $SERVER_DIR/deploy
echo Done!
#Install Postgres driver
echo Install PostgreSQL Driver
cp db/postgresql-8.4-703.jdbc4.jar $SERVER_DIR/lib
echo Done!
echo SOA-P 5.2 and EDS installation complete
echo

