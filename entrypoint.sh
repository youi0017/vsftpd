#!/bin/sh

# adduser -D -s /bin/false abc
adduser -D -s /bin/false $FTP_USER
#echo "abc:321" | /usr/sbin/chpasswd
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

touch "/home/$FTP_USER/ftp_welcome:$FTP_USER"

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf


