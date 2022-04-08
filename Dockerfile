#alpine-mariadb:https://wiki.alpinelinux.org/wiki/MariaDB

FROM alpine

WORKDIR /ftproot

RUN \
  apk update && \
  apk add vsftpd

  
COPY src/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY src/welcome_ftp_dir_for_anonymous ./

ENV \
  FTP_USER=ftpuser \
  FTP_PASS=654321


RUN echo "vsftpd构建完成"

VOLUME ["/etc/vsftpd", "/ftproot"]

EXPOSE 21

COPY entrypoint.sh /usr/sbin/
RUN chmod +x /usr/sbin/entrypoint.sh
CMD /usr/sbin/entrypoint.sh




