# alpine+vsftpd

最后修改：dahang 20230211

### 主动模式

注：在阿里云ECS中，主动模式必需使用21+20端口组合，否则可登陆但无法取得数据。

  
运行容器：使用匿名帐户(挂载目录,侦听端口):  
```
root@deb11:~# podman run -itd --name ftpd -p 21:21 -v /ftproot:/ftproot vsftpd  
或
root@deb11:~# podman run -itd --name ftpd --net host -v /ftproot:/ftproot vsftpd  
```

运行容器：创建ftp用户, 设置用户名和密码(abc:123),侦听端口,并挂载到本地目录
```
root@deb11:~# podman run -itd --name ftpd -p 21:21 -v /ftproot:/home -e FTP_USER=abc -e FTP_PASS=123 vsftpd
```

**说明**:在测试时,root启动容器不用映射20端口.非root即使映射20端口也没有,使用`--net host`方有效.


### 二、被动模式：

经测无论本地还是公网中，被动均可自定义端口。

使用指引：

#### 2.1 运行容器

```
# podman run -itd --name ftpd -p 6621:21 -p 6601-6609:6601-6609  -v /var/www:/home/dahang -e FTP_USER=dahang -e FTP_PASS=dh663621 vsftpd  
```
请参考上面自行修改参数。

####  2.1 进入容器修改配置
```
# podman exec -it ftpd /bin/sh
# vi /etc/vsftpd/vsftpd.conf



//找到并修改为下面相关信息：
#port 关闭主动模式
port_enable=NO
connect_from_port_20=YES
ftp_data_port=20

#pasv 开启被模式，并替换下面相关信息
pasv_enable=YES
pasv_address=10.0.0.1
pasv_min_port=21001
pasv_max_port=21009

//上面内容保存后，ctrl+D退出容器

```

####  3 重启容器

```
podman stop ftpd
podman start ftpd
```




### 三、测试
命令: ftp [ip] [端口]
      或 ftp / open [ip] [端口]

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

示例二:密码登陆
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
