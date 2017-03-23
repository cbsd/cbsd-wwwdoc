cbsd-wwwdoc
===========

cbsd documentation part for https://bsdstore.ru site

nginx-vhost.conf sample for site:

============

    server {
	listen       *:80;
	listen      [::]:80;

	server_name  bsdstore.ru www.bsdstore.ru;
	access_log /var/log/httpd/www.bsdstore.ru.acc main buffer=1m;
	error_log /var/log/httpd/www.bsdstore.err;

	root   /usr/home/web/www.bsdstore.ru;

	if ($host !~* ^www\.) {
		rewrite ^(.*)$ http://www.$host$1 permanent;
	}

	rewrite  ^/ru/$  /ru/about.html permanent;
	rewrite  ^/en/$  /en/about.html permanent;

	location ~* \.(css|txt|html|js|xsl)$ {
		ssi on;
		ssi_types text/css text/javascript application/x-javascript;
	}

	location ~* \.(jpg|jpeg|gif|png|swf|tiff|swf|flv|zip|rar|bz2|iso|xz|img)$ {
		add_header Cache-Control "public";
		expires     1d;
	}

	location / {
		set $language_suffix 'en';

		if ($http_accept_language ~* '^(en|ru|de){1}') {
			set $language_suffix $1;
		}
		rewrite ^/$ /$language_suffix/about.html permanent;

	}

	error_page      404     /404.html;
}

============
