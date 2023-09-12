FROM amazonlinux:2
RUN yum install -y httpd
COPY index.html /var/www/html
CMD [ "httpd", "-D", "FOREGROUND" ]
