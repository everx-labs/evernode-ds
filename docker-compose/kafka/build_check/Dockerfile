FROM confluentinc/cp-kafka-connect:6.0.1
USER root
RUN yum -y update && yum -y install jq findutils
COPY check.sh create_topics.sh create_connectors.sh /work/
COPY connect-cli /usr/bin/connect-cli
COPY /connectors/ /work/connectors/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
