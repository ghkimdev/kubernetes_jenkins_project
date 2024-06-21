FROM centos:7
MAINTAINER ghkimdev@gmail.com
RUN yum install -y httpd wget zip unzip
WORKDIR /var/www/html/
RUN wget https://www.free-css.com/assets/files/free-css-templates/download/page295/guarder.zip
RUN unzip guarder.zip
RUN cp -rvf guarder/* .
RUN rm -rf guarder guarder.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80 443
