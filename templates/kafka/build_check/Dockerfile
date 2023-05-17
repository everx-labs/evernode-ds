FROM confluentinc/cp-kafka-connect:7.3.3-1-ubi8.amd64
USER root
RUN microdnf update
RUN microdnf install jq findutils
COPY check.sh /work/check.sh
COPY /connectors/ /work/connectors/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
