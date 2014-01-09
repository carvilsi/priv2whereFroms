												README


The name of the script, prv2wf, comes from "WhereFroms to privacy" as the primordial objective of
this was to eliminate the attributes "com.apple.metadata: kMDItemWhereFroms" of the downloaded 
items. In order to ensure user privacy in certain "hostile" environments in fact it even made an 
application moni2priv 
(http://loshacksdejackburton.wordpress.com/2011/12/27/mac-os-x-navegadores-y-metadatos-wherefroms-como-librarse-de-ellos-moni2priv/)
eliminating this attribute in the file has been downloaded, using the kevent.
Later, the idea becomes more attributes to eliminate more directories, pleasure of the user.
Need for this new strategy changes, eliminating the metadata listed in directories, before the 
system shuts down (note that there is always the ability to run the script when the user needs).
To achieve this, use the Mac OS X StartupItems
(http://macdevcenter.com/pub/a/mac/2003/10/21/startup.html).
In order to indicate the directories and attributes to be removed, prv2wf uses a configuration 
file, by default this it looks in /Applications/priv2whereFroms/prv2wf.conf however it is possible to tell the script the
location of the configuration file using the "-c /path/to/congiFile ".
It contains three main elements. path2priv, which lists the directories where it will delete all
the attributes listed on meta2priv. In both elements must be in quotes and if more than one,
separated by spaces. And logFile that indicates the path for the logging file.
The configuration file should look like this:

path for do logging
logFile="/Users/jackBurton/Library/Logs/prv2wf.log"

Privacy paths: the paths space separated in quotation marks
path2priv = "/Users/jackBurton/Downloads /Users/jackBurton/temp /Users/jackBurton/Mail"

Privacy metadata: the metadata attributes space separated in quotation marks
meta2priv = "com.apple.metadata:kMDItemWhereFroms com.apple.quarantine"

The script has other command line option to perform differens actions:
	-h shows the options for command line 
	-v verbose mode to show output messages while the script is running otherwise this messages appears on the normal log in Console
	-c using different config file otherwise use the default config file. Comment above
	-i writes on log (Console) intervened files and path
	
In order to use these options in automatic script, modify /Library/StartupItems/priv2whereFroms/priv2whereFroms

											INSTALL

Two ways for install:

1- Execute the install script with sudo:
	- $ sh install_prv2wf.sh 
		- Customize your configFile

2- Complete these spteps:
	- Create file for logging: ~/Library/Logs
		- Give write permission $ sudo chmod g+w,u+w,o+w "$HOME"/Library/Logs/prv2wf.log  
	- Copy priv2whereFroms directory to /Applications
		- Give executing privileges $ sudo chmod 775 /Applications/priv2whereFroms/prv2wf01.sh 
	- Modify configuration file prv2wf.conf writing the correct pahts
	- Copy on /Library/StartupItems/priv2whereFroms/ the files [StartupParameters.plist + priv2whereFroms]
		- Give executing privileges $sudo chmod 0775 priv2whereFroms

 									LICENSE

 	  <prv2wf ver.1 Clear metadata that and where you want>
    Copyright (C) <2012> <carvilsi>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
