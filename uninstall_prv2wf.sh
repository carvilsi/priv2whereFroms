#!/bin/bash

#  execute with sudo

# Script to uninstall prv2wf
# the first attempt is to write the config file for prv2wf.conf

deleteFiles()
{
sudo rm -R /Applications/priv2whereFroms
echo "priv2whereFroms deleted from Applications" 
sudo rm -R /Library/StartupItems/priv2whereFroms
echo "priv2whereFroms deleted from StarupItems" 
rm "$HOME"/Library/Logs/prv2wf.log
echo "priv2whereFroms deleted from Logs"
}

deleteFiles