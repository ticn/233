FROM debian:unstable-slim

ADD shell /home
ADD configure.sh /configure.sh
COPY script/supervisord.conf /etc/supervisord.conf
ADD home.tar.gz /home
COPY script /tmp
COPY upload.sh /home
COPY ali.py /home
RUN /bin/bash -c 'chmod 755 /tmp/bin && mv /tmp/bin/* /bin/ && rm -rf /tmp/* '	
RUN apt update -y \
	&& apt upgrade -y \
 	&& apt install -y nginx supervisor python3-pip git vim screen wget curl \
	&& pip3 install requests \
	&& mkdir -p /run/screen \
	&& chmod -R 777 /run/screen \
	&& chmod +x /configure.sh \
	&& chmod +x /bin/aria2c \
	&& chmod +x /bin/rclone \
	&& chmod +x /bin/frpc \
	&& chmod +x /bin/ttyd \
	&& chmod +x /home/upload.sh \
	&& chmod +x /home/ali.py \
	&& rm -rf /etc/nginx/nginx.conf \
	&& mkdir -p /var/www/html/ttyd
COPY static-html /var/www/html	
COPY nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf

ENV LANG C.UTF-8
WORKDIR /home
CMD /configure.sh
