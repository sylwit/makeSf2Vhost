#!/bin/bash
# Copyright (c) 2011 myeshop <http://www.myeshop.fr>
# This script is licensed under GNU GPL version 2.0 or above
# Author Sylvain Witmeyer <s.witmeyer@myeshop.fr>
#
# ------------------------------------------------------------

##Default vars
_name='new_sf2'
_path='/var/www/html/'
_url='local'

_user='sylvain'

_sfTGZ='http://symfony.com/download?v=Symfony_Standard_Vendors_2.0.9.tgz'
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
echo -e 'Building workspace ... [OK]'
mkdir "${_workspace}"


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

_installSf='N'
read -p "Do you want to install Sf in your workspace [${_sfTGZ}]: [N] " tmpInstallSf
if [ "$tmpInstallSf" = 'Y' ]
then
	echo -e 'Installing Symfony'
	cd ${_workspace}
	wget -O symfony.tar.gz ${_sfTGZ}
	tar -zxf "${_workspace}/symfony.tar.gz"
	mv Symfony/* .
	rm -Rf Symfony
	chown -R ${_user}: ${_workspace}
	chmod -R 777 app/cache app/logs
fi


echo -e "You can now access your workspace at ${_url}"
