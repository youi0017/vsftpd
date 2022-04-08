#docker fot vsftpd



podman run -itd --name ftpd --net host -v /ftproot:/ftproot ftpd

podman run -itd --name ftpdx2 -p 2001:21 -p 20:20 -v /ftproot:/ftproot ftpdx


说明:
主动模式要开放: 21 和 20 
被动模式要开放:21 和 最小到最大










