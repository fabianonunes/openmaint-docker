#!/bin/bash
set -ex

mkdir -p conf/cmdbuild
cat <<- EOF > conf/cmdbuild/database.conf
	db.url=jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}
	db.username=openmaint
	db.password=openmaint
	db.admin.username=${POSTGRES_USER}
	db.admin.password=${POSTGRES_PASS}
EOF

wait-for-it "${POSTGRES_HOST}:${POSTGRES_PORT}" -t 0

{ # try
  webapps/cmdbuild/cmdbuild.sh dbconfig create "$CMDBUILD_DUMP" -configfile conf/cmdbuild/database.conf
} || { # catch
  echo "Database already exists"
}

exec bin/catalina.sh run
