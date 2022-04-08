# docker fot vsftpd

### 启动容器
匿名帐户型(挂载目录,侦听端口):  
podman run -itd --name ftpd -p 2121:21 -v /ftproot:/ftproot ftpd  
//podman run -itd --name ftpd --net host -v /ftproot:/ftproot ftpd  

系统用户(完整版): 设置用户名和密码(abc:123),侦听端口,并挂载到本地目录
podman run -itd --name ftpd -p 2121:21 -v /ftproot:/home -e FTP_USER=abc -e FTP_PASS=123 ftpd


### 测试
命令: ftp [ip] [端口]

示例一:匿名登陆
```
root@deb11:~# podman run -itd --name ftpd -p 2121:21 -v /ftproot:/ftproot ftpd 

root@deb11:~# ftp 192.168.10.101 2121
Connected to 192.168.10.101.
220 (vsFTPd 3.0.5)
Name (192.168.10.101:xxx): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxrwxrwx    2 0        0            4096 Apr 08 06:21 allmod
-rwxrwxrwx    1 0        0               0 Apr 08 02:59 hello.txt
226 Directory send OK.
ftp> bye
221 Goodbye.
```

示例一:匿名登陆
```
root@deb11:~# podman run -itd --name ftpd -p 2121:21 -v /ftproot:/home -e FTP_USER=abc -e FTP_PASS=123 ftpd

root@deb11:~# ftp 192.168.10.101 2121
Connected to 192.168.10.101.
220 (vsFTPd 3.0.5)
Name (192.168.10.101:xxx): abc
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-r--r--    1 0        1000            0 Apr 08 08:34 ftp_welcome:abc
-rw-r--r--    1 0        1000            0 Apr 08 08:05 xyz
226 Directory send OK.
ftp>
221 Goodbye.
```








