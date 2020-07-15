migrate:
	@read -p "DB password:" password; \
	echo Password: $$password; \
	mysql -u root -p$$password -e "CREATE DATABASE IF NOT EXISTS tickmill"; \
	cat db_testtask.sql | mysql -u root -p$$password tickmill; \
	cat migrations/*.sql | mysql -u root -p$$password tickmill; \
	cat seeds/*.sql | mysql -u root -p$$password tickmill