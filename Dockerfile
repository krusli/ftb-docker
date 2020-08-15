FROM adoptopenjdk/openjdk8:alpine

# NOTE ca-certificates:
# https://hackernoon.com/alpine-docker-image-with-secured-communication-ssl-tls-go-restful-api-128eb6b54f1f
RUN apk update && \
    apk add ca-certificates wget openssh

RUN mkdir -p /home/ftb && cd /home/ftb

# change directory to /home/ftb
WORKDIR /home/ftb

# Copy modpack server files
COPY SevTech-Ages_Server_3.1.5.zip server.zip
RUN unzip -q server.zip && rm server.zip

# setup the server
# make scripts executable
# RUN chmod u+x FTBInstall.sh ServerStart.sh settings.sh
RUN chmod u+x Install.sh ServerStart.sh settings.sh

# agree to the EULA
RUN echo "eula=TRUE" >> eula.txt

# modify settings
RUN echo 'export MIN_RAM="2048M"' >> settings.sh && \
    echo 'export MAX_RAM="4096M"' >> settings.sh && \
    echo 'export JAVA_PARAMETERS="-XX:+UseG1GC -XX:+UseStringDeduplication -XX:+DisableExplicitGC -XX:MaxGCPauseMillis=10 -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=4"' >> settings.sh

# Setup FTB
WORKDIR /home/ftb
# RUN ./FTBInstall.sh
RUN ./Install.sh
RUN ./settings.sh
EXPOSE 25565

# Expose as volume to persist any changes from this point onwards
# Also allows modifications
VOLUME /home/ftb/

CMD ./ServerStart.sh
