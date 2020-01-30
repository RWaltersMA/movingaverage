# MongoDB, MySQL, Kafka Connect, MongoDB Connector for Apache Kafka and R example - Stock example

<p>This demo generates fake stock data and populates two databases - MySQL and MongoDB.  Data flows from these databases to Kafka topics via their respetive connectors - Debezium MySQL and MongoDB Connector for Apache Kafka.  Data from both topics are  then sinked to a MongoDB cluster in MongoDB Atlas using the MongoDB Connector for Apache Kafka as a sink.  With the combined data in Atlas we connect using an R client like RStudio to query the data for a moving average and other queries.</p>

## Requirements
  - Docker 18.09+
  - Docker compose 1.24+
  - [Kafkacat](https://github.com/edenhill/kafkacat) (optional)
  - RStudio (Optional)
  - Mongolite R driver (optional)

## Running the demo
**1. Download/Clone the docker files from the GitHub repository**

[https://github.com/RWaltersMA/movingaverage.git]([https://github.com/RWaltersMA/movingaverage.git])

**2. Build the demo images**

 Run the following script from the command shell:

	`Build-images.sh`

Note: Make sure you are in the same directory as the build-images script file.  Also, you may have to add execute permission via a `chmod +x build-images.sh` to execute the script.

This shell script will build the following demo containers locally: mysqlimg, stockgenmongo, stockgenmysql, stockportal.  You can confirm these four images were created by issuing a “docker images” command.

**3. Copy the Atlas Connection String**

<p>If you do not have a MongoDB Atlas cluster, [follow these instructions](https://docs.atlas.mongodb.com/getting-started/).

Just creating the cluster is not enough to run the demo.  You will need to define a database user for use by the Kafka Connector to connect to the MongoDB Atlas cluster.  You will also have to whitelist the IP address of the docker host.

If you have not created a database user for the Kafka Connector:

Select, “Database Access” from the Atlas menu and click the “Add new User” button.  

Provide a username and password and select, “Read and write to any database”.  Remember the password.

If your docker host is not whitelisted:
Click, “Network Access” from the Atlas menu and click, “Add IP Address”.  Here you can add your current IP address or any IP Address or block of addresses in CIDR format.  Note: If you do not know or can not obtain the IP address of the docker host you can add, “0.0.0.0” as an entry which will allow connections from anywhere on the internet.  This is not a recommended configuration.

To copy the connection string select the “CONNECT” button on your Atlas cluster then choose “Connect your application”.  Click the Copy button to copy the connection string to the clipboard.</p>

**4. Modify the RUN.SH file to update the MongoDB Atlas Connection string**

Update the RUN.SH file in two places:

Location 1. Modify the value of “connection.uri” of **mongo-atlas-sink** and paste in the Atlas connection string.  Note to add the correct password. 

Location 2. Modify the value of “connection.uri” of **mysql-atlas-sink** and paste in the Atlas connection string.  Note to add the correct password. 

**5. Execute the RUN.SH script**

The demo is now ready to go just issue a `sh run.sh` and the script will start the docker containers and configure the connectors.
