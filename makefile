init: copy_config #Start container
	@echo ""

start: #Start container
	@docker-compose up -d

stop: #stop docker container
	@sudo docker-compose down

stop_remove: #stop docker container and remove DB
	@docker-compose down --volumes

connect_wordpress: #connect to Wordpress docker container
	@docker-compose exec app bash

connect_db: #connect to DB docker container
	@docker-compose exec db bash

connect_nginx: #connect to DB docker container
	@docker-compose exec webserver bash

show: #Show containers
	@sudo docker ps


##########################################################
###########            Install WP            #############
##########################################################

install_wordpress: load_wordpress config_wordpress
	echo "install WP was finished."

load_wordpress: #
	@sudo docker exec -it app bash -c 'wget -c http://wordpress.org/latest.tar.gz && tar -xzvf latest.tar.gz && rsync -av wordpress/* ./public/ && rm latest.tar.gz && rm -rf wordpress/'

copy_config: rewrite_wordpress_config
	@cp .env.default .env && cp sedscript.default sedscript && echo "Fill data to envs files and after run - config_wordpress"

config_wordpress: rewrite_wordpress_config
	echo "WP was config"

rewrite_wordpress_config: #
	@sudo docker exec -it app bash -c 'sed -f sedscript <./public/wp-config-sample.php > ./public/wp-config.php'
