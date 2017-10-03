FROM java:8

MAINTAINER Jose Ventura [ventura.jos3@gmail.com]

# Init ENV
ENV PENTAHO_VERSION 7.1
ENV PENTAHO_TAG 7.1.0.0-12

ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN apt-get update; apt-get install zip netcat -y; \
    apt-get install wget unzip git postgresql-client-9.4 vim -y; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    curl -O https://bootstrap.pypa.io/get-pip.py; \
    python get-pip.py; \
    pip install awscli; \
    rm -f get-pip.py

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown pentaho:pentaho ${PENTAHO_HOME}

USER pentaho

# Download Pentaho BI Server
RUN /usr/bin/wget --progress=dot:giga http://downloads.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/${PENTAHO_VERSION}/pentaho-server-ce-${PENTAHO_TAG}.zip -O /tmp/pentaho-server-${PENTAHO_TAG}.zip
#COPY pentaho-server-ce-7.1.0.0-12.zip /tmp/pentaho-server-${PENTAHO_TAG}.zip

RUN /usr/bin/unzip -q /tmp/pentaho-server-${PENTAHO_TAG}.zip -d  $PENTAHO_HOME; \
    rm -f $PENTAHO_HOME/pentaho-server/promptuser.sh; \
    sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/pentaho-server/tomcat/bin/startup.sh; \
    chmod +x $PENTAHO_HOME/pentaho-server/start-pentaho.sh

COPY config $PENTAHO_HOME/config
COPY scripts $PENTAHO_HOME/scripts

WORKDIR /opt/pentaho

EXPOSE 8080

CMD ["sh", "scripts/run.sh"]    