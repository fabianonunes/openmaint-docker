FROM tomcat:9.0.71-jdk17-temurin

WORKDIR $CATALINA_HOME

ENV CMDBUILD_URL https://sourceforge.net/projects/openmaint/files/2.3/openmaint-2.3-3.4.1-d.war/download

RUN set -ex;                                        \
  apt-get update;                                   \
  apt-get install -y --no-install-recommends        \
    postgresql-client                               \
    unzip                                           \
    wait-for-it;                                    \
  rm -rf /var/lib/apt/lists/*;                      \
  mkdir conf/cmdbuild;                              \
  curl -fSLo webapps/cmdbuild.war "$CMDBUILD_URL";  \
  unzip -d webapps/cmdbuild webapps/cmdbuild.war;

RUN set -ex;                           \
  adduser --system --uid 1000 --group  \
    --home "$CATALINA_HOME" tomcat;    \
  chown tomcat -R .
USER tomcat

ENV POSTGRES_HOST openmaint_db
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER postgres
ENV POSTGRES_PASS postgres
ENV POSTGRES_DB openmaint

ENV CMDBUILD_DUMP empty.dump.xz

COPY docker-entrypoint.sh /
ENTRYPOINT /docker-entrypoint.sh
