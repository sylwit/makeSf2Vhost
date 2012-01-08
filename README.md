MakeSf2Vhost
============

1: What is it ?
---------------

makeSf2Vhost is a script wich allow you to create and configure automatically a new Symfony2 Project.
Here is what it does :

- Building the workspace
- Adding the URL to /etc/hosts
- Create the vhost for Apache and enable it
- Restart Apache

- Option : you can add a fresh install of Symfony2 in your workspace

2: How to use it
----------------

You can edit the file and modify any parameters. Most of them will be overwriting if you need by the script

You should execute this script with root. If you need to use sudo, don't forget to configure the _user parameter in the script

``` bash
$ chmod +x makeSf2Vhost
$ sudo ./makeSf2Vhost
```
