# iphone
1. Prepare to use:

`# apt update && apt install zenity ifuse`

2. Configure environment:

`# groupadd iphone`

`# usermod -aG iphone $USER`
 
3. Configure sudo to permit umount iphone device only iphone group members:

`echo '%iphone   ALL=(ALL) NOPASSWD: /bin/umount' > /etc/sudoers.d/99_iphone`
	 	
4. Install copy script to /usr/local/sbin/iphone
