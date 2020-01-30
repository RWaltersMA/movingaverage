FROM confluentinc/cp-kafka-connect:5.3.0

ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest
RUN confluent-hub install --no-prompt debezium/debezium-connector-mysql:0.10.0
RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:latest
#0.2
