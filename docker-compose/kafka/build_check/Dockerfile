FROM confluentinc/cp-kafka-connect:7.3.3
USER root
RUN yum -y update && yum -y install jq findutils
USER appuser
COPY check.sh create_topics.sh create_connectors.sh /work/
COPY connect-cli /usr/bin/connect-cli
COPY /connectors/ /work/connectors/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
