#alpine-mariadb:https://wiki.alpinelinux.org/wiki/MariaDB

FROM alpine

WORKDIR /ftproot

RUN \
  apk update && \
  apk add vsftpd

  

COPY src/vsftpd.conf /etc/vsftpd/vsftpd.conf
# COPY src/php/www.conf /etc/php7/php-fpm.d/www.conf
# COPY src/index.html ./
# COPY src/info.php ./


ENV \
  FTP_USER=ftpuser \
  FTP_PASS=654321


RUN echo "vsftpd构建完成"


# #可挂载目录：虚拟主机配置目录，www目录，日志目录
VOLUME ["/etc/vsftpd", "/ftproot"]

EXPOSE 21

COPY entrypoint.sh /usr/sbin/
RUN chmod +x /usr/sbin/entrypoint.sh
CMD /usr/sbin/entrypoint.sh




