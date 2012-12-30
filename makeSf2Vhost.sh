#!/bin/bash
# Copyright (c) 2012 myeshop <http://www.myeshop.fr>
# This script is licensed under GNU GPL version 2.0 or above
# Author Sylvain Witmeyer <s.witmeyer@myeshop.fr>
#
# ------------------------------------------------------------

##Default vars
_name='new_sf2'
_path='/var/www/html/'
_url='local'
_sfVersion='2.1.6' 
_user='sylvain'
_vhostFile='/etc/apache2/sites-available'

#### No editing below #####
read -p "Name  [${_name}]: " tmpName
if [ -n "$tmpName" ]
then
	_name="$tmpName"
fi

read -p "Path  [${_path}]: " tmpPath
if [ -n "$tmpPath" ]
then
	_path="$tmpPath"
fi

_workspace="${_path}/${_name}"

_url="${_name}.${_url}"
read -p "URL  [${_url}]: " tmpUrl
if [ -n "$tmpUrl" ]
then
	_url="$tmpUrl"
fi

echo -e 'Adding URL to hosts'
echo -e "# Automatic add by makeSfVhost\n127.0.0.1	${_url}" >> /etc/hosts


echo -e 'Adding Vhost'
_vhost="
<VirtualHost *:80>\n
	\tServerName ${_url}\n
        \tDocumentRoot ${_workspace}/web\n
\n
        \t<Directory \"${_workspace}\">\n
                \t\tDirectoryIndex app.php\n
                \t\tOptions -Indexes FollowSymLinks SymLinksifOwnerMatch\n
                \t\tAllowOverride All\n
                \t\tAllow from All\n
        \t</Directory>\n
</VirtualHost>
"
touch ${_vhostFile}/${_name}
echo -e ${_vhost} > ${_vhostFile}/${_name}

a2ensite ${_name}

echo -e 'Restarting Apache'
apachectl restart

read -p "Do you want to install Symfony in your workspace : [N] " tmpInstallSf
if [ "$tmpInstallSf" = 'Y' ]
then
        read -p "Specify a version of Symfony : [${_sfVersion}] " _sfVersionInteractive

        if [ -n "$_sfVersionInteractive" ]
        then
                _sfVersion=$_sfVersionInteractive
        fi

        echo -e "Get Composer"
        curl -s http://getcomposer.org/installer | php

        echo -e "Installing Symfony ${_sfVersion}"
        php composer.phar create-project symfony/framework-standard-edition ${_workspace} ${_sfVersion}

	chown -R ${_user}: ${_workspace}
	chmod -R 777 ${_workspace}/app/cache ${_workspace}/app/logs
fi


echo -e "You can now access your workspace at ${_url}"
