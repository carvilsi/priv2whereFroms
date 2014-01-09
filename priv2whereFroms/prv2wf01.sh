#!/bin/bash

# #################################################################################################
# 
# prv2wf ver.1 o3r3 (carvilsi) 2012  GPLv3
# site: http://loshacksdejackburton.wordpress.com
# mail: carvilsi.mail.list@gmail.com (Subject: prv2wf)
# 
# #################################################################################################
# 
#  										LICENSE
# 
#  	  <prv2wf ver.1 Clear metadata that and where you want>
#     Copyright (C) <2012> <carvilsi>
# 
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# #################################################################################################
# 
# 							CONCEPT AND USE OF THIS STUFF															
# 
# The name of the script, prv2wf, comes from "WhereFroms to privacy" as the primordial objective of
# this was to eliminate the attributes "com.apple.metadata: kMDItemWhereFroms" of the downloaded 
# items. In order to ensure user privacy in certain "ostile" environments in fact it even made an 
# application moni2priv 
# (http://loshacksdejackburton.wordpress.com/2011/12/27/mac-os-x-navegadores-y-metadatos-wherefroms-como-librarse-de-ellos-moni2priv/)
# eliminating this attribute in the file has been downloaded, using the kevent.
# Later, the idea becomes more attributes to eliminate more directories, pleasure of the user.
# Need for this new strategy changes, eliminating the metadata listed in directories, before the 
# system shuts down (note that there is always the ability to run the script when the user needs).
# To achieve this, use the Mac OS X StartupItems
# (http://macdevcenter.com/pub/a/mac/2003/10/21/startup.html).
# In order to indicate the directories and attributes to be removed, prv2wf uses a configuration 
# file, by default this it looks in /Applications/priv2whereFroms/prv2wf.conf however it is possible to tell the script the
# location of the configuration file using the "-c /path/to/congiFile ".
# It contains three main elements. path2priv, which lists the directories where it will delete all
# the attributes listed on meta2priv. In both elements must be in quotes and if more than one,
# separated by spaces. And logFile that indicates the path for the logging file.
# The configuration file should look like this:
# 
# path for do logging
# logFile="/Users/jackBurton/Library/Logs/prv2wf.log"
# 
# Privacy paths: the paths space separated in quotation marks
# path2priv = "/Users/jackBurton/Downloads /Users/jackBurton/temp /Users/jackBurton/Mail"
# 
# Privacy metadata: the metadata attributes space separated in quotation marks
# meta2priv = "com.apple.metadata:kMDItemWhereFroms com.apple.quarantine"
# 
# The script has other command line option to perform differens actions:
# 	-h shows the options for command line 
# 	-v verbose mode to show output messages while the script is running otherwise this messages appears on the normal log in Console
# 	-c using different config file otherwise use the default config file. Comment above
# 	-i writes on log (Console) intervened files and path
# 
#  In order to use these options in automatic script, modify /Library/StartupItems/priv2whereFroms/priv2whereFroms
# 
# #################################################################################################
# 
# 											INSTALL
# 
# Two ways for install:
# 
# 1- Execute the install script with sudo:
# 	- $ sh install_prv2wf.sh 
# 		- Customize your configFile
# 
# 2- Complete these spteps:
# 	- Create file for logging: ~/Library/Logs
# 		- Give write permission $ sudo chmod g+w,u+w,o+w "$HOME"/Library/Logs/prv2wf.log  
# 	- Copy priv2whereFroms directory to /Applications
# 		- Give executing privileges $ sudo chmod 775 /Applications/priv2whereFroms/prv2wf01.sh 
# 	- Modify configuration file prv2wf.conf writing the correct pahts
# 	- Copy on /Library/StartupItems/priv2whereFroms/ the files [StartupParameters.plist + priv2whereFroms]
# 		- Give executing privileges $sudo chmod 0775 priv2whereFroms
# 
# #################################################################################################
# 
# TODO:
# 	[] logging mode 
# 		[*] know what logg:
# 			[*] errors (good if can to be on the system and private log)
# 			[*] attribs deleted
#			[*] intervened files
#   	[] where to log:
#			[] path indicated by usr 
# 			[*] path by default ~/Library/Logs 
# 	[] make the files intervened traceables, adding a metadata attribute
# 	[*] make something with de verbose option or delete
# 	[*] check if the configFile exits when there is no -c option
# 	[*] make installer for Mac OS X
# 		[*] prv2wf
# 		[*] startupItems
# 		[*] config file
# 		[*] logg file
# 	[*] make uninstaller
# 	[] check name of attributes
# 
# #################################################################################################

# Config file
CONFIG_FILE=/Applications/priv2whereFroms/prv2wf.conf


# variables
# flag using -v verbose
VFL=0
# flag using -c Config file
CFL=0
# flag using -i Logging info
IFL=0

# for testing
# say cya

# Usage message
usage_script()
{
cat << EOF
usage: $0 options

OPTIONS:
   -c      config file
   -h      show this message
   -i      logging info about intervented files 
   -v      verbose
   
EOF
}

# try to read options
while getopts “hc:vi” OPTION
do
     case $OPTION in
         h)
             usage_script
             exit 1
             ;;
         c)
             CONFIG_FILE=$OPTARG
             CFL=1
             ;;
         v)
             VFL=1
             ;;
         i)
             IFL=1
             ;;
         \?)
             usage_script
             exit 1
             ;;
     esac
done

# cleaning metadata attributes
clearMetadata()
{
	xattr -d $1 $2/* 2> /dev/null
}

# cleaning metadata attributes and logging 
clearMetadataLog()
{
	if [ $VFL == 1 ]
	then
		xattr -lr $2/* | grep $1 | cut -d : -f 1,2
		xattr -lr $2/* | grep $1 | cut -d : -f 1,2 >> $LOG_FILE	
	else
		xattr -lr $2/* | grep $1 | cut -d : -f 1,2 >> $LOG_FILE	
	fi
	xattr -dr $1 $2/* 2> /dev/null	
}

# usage for the config file
usage_configFile()
{
cat << EOF
Usage of the config file:

# prv2wf config file
# The "#" is comment

# paths 2 privacy: Whrite the paths space separated in quotation marks
example: 
path2priv="/Users/jackBurton/Downloads /Users/jackBurton/temp /Users/jackBurton/Mail"

# metadata 2 privacy: Whrite the attributes space separated in quotation marks
example:
meta2priv="com.apple.metadata:kMDItemWhereFroms com.apple.quarantine"

EOF
}

usage_logFile()
{
cat << EOF
	Usage of log file:
	
	prv2wf.log this file should be in "$HOME"/Library/Logs/
	you can use Console for read log
EOF
}

check_logFile()
{
if [ -e "$LOG_FILE" ]
then
		echo "$(date) prv2wf [INFO]: prv2wf Start" >> "$LOG_FILE"	
else
 		usage_logFile 	
		exit 1;
fi
}

# Main part of script
# try reading the config file
if [ -e "$CONFIG_FILE" ] && [ -s "$CONFIG_FILE" ]
then
	source $CONFIG_FILE
	# get the log file
	LOG_FILE=($logFile)
	check_logFile
	# get the paths
	paths=($path2priv)
	attri=($meta2priv)
	# check if all is OK
	if [ ${#paths[@]} = 0 ]
	then 
		usage_configFile
		exit 1
	else
		# check directories
		for j in "${paths[@]}"
		do 
			if [ -d "$j" ]
			then
				# get attributes metadata to delete 
				# TODO: check name of attributes
				for h in "${attri[@]}"
				do
					 	if [ $IFL == 1 ]
						then
							clearMetadataLog $h $j
						else
							clearMetadata $h $j
						fi
				done
			else
				if [ $VFL == 1 ]
				then
					echo "[ERROR]: The especified path2priv is not a directory: $j"
					usage_configFile
					exit 1;
				else
					echo "$(date) prv2wf [ERROR]: The especified path2priv is not a directory: $j" >> "$LOG_FILE"
					exit 1
				fi
			fi
		done
	fi	
else
				 if [ $VFL == 1 ]
				 then
					echo "[ERROR]: The config file is empty or not exist: $CONFIG_FILE"
					usage_configFile
					exit 1
				 else
					echo "$(date) prv2wf [ERROR]: The config file is empty or not exist: $CONFIG_FILE" >> "$LOG_FILE"
					exit 1
				fi
fi

# crear es resistir
# resistir es crear 