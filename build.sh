python3 ./create_schema_sql.py
docker build -t zbvs/kiwizzle:kiwizzle-mysql-1.0.0 .
docker push zbvs/kiwizzle:kiwizzle-mysql-1.0.0
rm -rf ./schema.sql