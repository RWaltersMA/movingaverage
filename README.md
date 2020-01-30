# MongoDB, MySQL, Kafka Connect, MongoDB Connector for Apache Kafka and R example - Stock example

This demo generates fake stock data and populates two databases - MySQL and MongoDB.  Data flows from these databases to Kafka topics via their respetive connectors - Debezium MySQL and MongoDB Connector for Apache Kafka.  Data from both topics are  then sinked to a MongoDB cluster in MongoDB Atlas using the MongoDB Connector for Apache Kafka as a sink.  With the combined data in Atlas we connect using an R client like RStudio to query the data for a moving average and other queries.

## Requirements
  - Docker 18.09+
  - Docker compose 1.24+
  - [Kafkacat](https://github.com/edenhill/kafkacat) (optional)
  - RStudio (Optional)
  - Mongolite R driver (optional)

## Running the demo
### 1. Download/Clone the docker files from the GitHub repository

[https://github.com/RWaltersMA/movingaverage.git](https://github.com/RWaltersMA/movingaverage.git)

### 2. Build the demo images**

Run the following script from the command shell:

	`Build-images.sh`

Note: Make sure you are in the same directory as the build-images script file.  Also, you may have to add execute permission via a `chmod +x build-images.sh` to execute the script.

This shell script will build the following demo containers locally: mysqlimg, stockgenmongo, stockgenmysql, stockportal.  You can confirm these four images were created by issuing a “docker images” command.

### 3. Copy the Atlas Connection String**

If you do not have a MongoDB Atlas cluster, [follow these instructions](https://docs.atlas.mongodb.com/getting-started/).

Just creating the cluster is not enough to run the demo.  You will need to define a database user for use by the Kafka Connector to connect to the MongoDB Atlas cluster.  You will also have to whitelist the IP address of the docker host.

If you have not created a database user for the Kafka Connector:

Select, “Database Access” from the Atlas menu and click the “Add new User” button.  

Provide a username and password and select, “Read and write to any database”.  Remember the password.

If your docker host is not whitelisted:
Click, “Network Access” from the Atlas menu and click, “Add IP Address”.  Here you can add your current IP address or any IP Address or block of addresses in CIDR format.  Note: If you do not know or can not obtain the IP address of the docker host you can add, “0.0.0.0” as an entry which will allow connections from anywhere on the internet.  This is not a recommended configuration.

To copy the connection string select the “CONNECT” button on your Atlas cluster then choose “Connect your application”.  Click the Copy button to copy the connection string to the clipboard.</p>

### 4. Modify the RUN.SH file to update the MongoDB Atlas Connection string**

Update the RUN.SH file in two places:

Location 1. Modify the value of “connection.uri” of **mongo-atlas-sink** and paste in the Atlas connection string.  Note to add the correct password. 

Location 2. Modify the value of “connection.uri” of **mysql-atlas-sink** and paste in the Atlas connection string.  Note to add the correct password. 

### 5. Execute the RUN.SH script**

The demo is now ready to go just issue a `sh run.sh` and the script will start the docker containers and configure the connectors.



## Running the Demo

Once the docker images and containers are built and deployed, the demo can be run repeatedly by simply executing the `RUN.SH` script file.

### 1. Execute the `RUN.SH` script file

### 2. View the generates stock entities by navigating on your docker host to http://localhost:8888

The demo will randomly generate 10 securities, 5 for MySQL and 5 for MongoDB respectively.  This web page simply connects to MySQL and MongoDB and shows the names of the stocks.

### 3. View the topic messages

View the messages in the Kafka topics using the Kafkacat tool. 

Messages in mysqlstock.Stocks.StockData topic are using the Debezium MySQL connector.  Messages in the stockdata.Stocks.StockData topic came from the MongoDB Connector for Apache Kafka.  This validates that our connectors are set up and the supportive stockgenmongo and stockgenmysql python generation apps are working.

#### View messages in MySQL topic
`kafkacat -b 127.0.0.1:9092  -t mysqlstock.Stocks.StockData -s avro -r 127.0.0.1:8081`

...
{"before": null, "after": {"Value": {"company_symbol": {"string": "WTP"}, "company_name": {"string": "WHIMSICAL TAMBOUR PRODUCTIONS"}, "price": {"bytes": "%\u0017"}, "tx_time": {"string": "2020-01-28T18:30:34Z"}}}, "source": {"version": "0.10.0.Final", "connector": "mysql", "name": "mysqlstock", "ts_ms": 1580236234000, "snapshot": {"string": "false"}, "db": "Stocks", "table": {"string": "StockData"}, "server_id": 223344, "gtid": null, "file": "mysql-bin.000003", "pos": 1906765, "row": 0, "thread": {"long": 9}, "query": null}, "op": "c", "ts_ms": {"long": 1580236234223}}

#### View messages in MongoDB topic
`kafkacat -b 127.0.0.1:9092  -t stockdata.Stocks.StockData`

…
"{\"_id\": {\"$oid\": \"5e307e3940bacb724265e4a8\"}, \"company_symbol\": \"ISH\", \"company_name\": \"ITCHY STANCE HOLDINGS\", \"price\": 35.02, \"tx_time\": \"2020-01-28T18:32:25Z\"}"

### 4. View the combined data in MongoDB Atlas

As the MongoDB sink connector writes data to MongoDB Atlas you can see it show up in the StockData collection.  Click on "Collections" in MongoDB Atlas and view the StockData collection in the Stocks database. These data are from both the MySQL and MongoDB databases.

### 7. Calculate the moving average using R

Launch RStudio and run through the script, "R-Demo-Script.txt" located in this github repository.  In this script it has two plots, one will display a blox plot of all the stock entities and the next plot will show the moving average for a selected entity.  Note:  Make sure you change the stock ticker symbol to a stock that exists in your demo.

