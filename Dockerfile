#zbvs/kiwizzle:kiwizzle-mysql-1.0.0
FROM mysql:8.0

#ADD ./schema.sql /docker-entrypoint-initdb.d/schema.sql
#ADD ./kiwizzle.cnf /etc/mysql/conf.d/kiwizzle.cnf
EXPOSE 3306
