#!/bin/bash

# Script to install prv2wf
#  execute with sudo


# Copy the files
copyFiles()
{

# log file
cp ./prv2wf.log "$HOME"/Library/Logs/
sudo chmod g+w,u+w,o+w "$HOME"/Library/Logs/prv2wf.log 

# Applications 
mkdir /Applications/priv2whereFroms
cp ./priv2whereFroms/prv2wf.conf /Applications/priv2whereFroms/
cp ./priv2whereFroms/prv2wf01.sh /Applications/priv2whereFroms/
sudo chmod 775 /Applications/priv2whereFroms/prv2wf01.sh 

# StartupItems
sudo mkdir /Library/StartupItems/priv2whereFroms
sudo cp ./startUpitems/priv2whereFroms/priv2whereFroms /Library/StartupItems/priv2whereFroms/ 
sudo cp ./startUpitems/priv2whereFroms/StartupParameters.plist /Library/StartupItems/priv2whereFroms/ 
sudo chmod 0755 /Library/StartupItems/priv2whereFroms/priv2whereFroms
}


# About config file

CONFIG_FILE=/Applications/priv2whereFroms/prv2wf.conf

writeConfigFile()
{
if [ -e "$CONFIG_FILE" ] && [ -w "$CONFIG_FILE" ]
then
	echo " " >> "$CONFIG_FILE"
	echo "logFile=\"$HOME/Library/Logs/prv2wf.log\"" >> "$CONFIG_FILE"
	echo " " >> "$CONFIG_FILE"
	echo "path2priv=\"$HOME/Downloads\"" >> "$CONFIG_FILE"
	echo " " >> "$CONFIG_FILE"
	echo "meta2priv=\"com.apple.metadata:kMDItemWhereFroms\"" >> "$CONFIG_FILE"
	echo "ConfigFile OK"
	exit 0
else
 		echo "The $CONFIG_FILE does not exits or have not write permission"
		exit 1
fi
}

# To test if the files exits
# define the files

PRIV2WF_SI_PLIST=/Library/StartupItems/priv2whereFroms/StartupParameters.plist
PRIV2WF_SI_SCRPT=/Library/StartupItems/priv2whereFroms/priv2whereFroms
PRIV2WF_APP_SCRPT=/Applications/priv2whereFroms/prv2wf01.sh 

testFile()
{
RET=0
if [ -e "$PRIV2WF_SI_PLIST" ] && [ -x "$PRIV2WF_SI_PLIST" ] 
then 
	echo "plist OK" 
else
	echo "plist NOK"
	RET=1 
fi
if [ -e "$PRIV2WF_SI_SCRPT" ] && [ -x "$PRIV2WF_SI_SCRPT" ] 
then 
	echo "script OK"
else 
	echo "script NOK"
	RET=1
fi
if [ -e "$PRIV2WF_APP_SCRPT" ] && [ -x "$PRIV2WF_APP_SCRPT" ] 
then 
	echo "script app OK"
else 
	echo "script app NOK"
	RET=1
fi	
exit $RET	
}

copyFiles
# testFile
writeConfigFile