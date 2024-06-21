FROM centos:7
MAINTAINER ghkimdev@gmail.com
RUN yum install -y httpd \
 zip\
 unzip
ADD https://www.free-css.com/assets/files/free-css-templates/download/page295/guarder.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip guarder.zip
RUN cp -rvf guarder/* .
RUN rm -rf guarder guarder.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80 443
