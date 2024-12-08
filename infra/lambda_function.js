const AWS = require("aws-sdk");
const {
  EC2Client,
  CreateVpcPeeringConnectionCommand,
} = require("@aws-sdk/client-ec2");
const sqs = new AWS.SQS(); // Initialize the SQS client

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  const queueUrl = process.env.SQS_QUEUE_URL; // Pass the SQS queue URL as an environment variable
  const processedMessages = [];

  // Process each SQS message
  for (const record of event.Records) {
    try {
      // The message body is in `record.body`
      const message = JSON.parse(record.body);
      console.log("Processing message:", message);

      // Perform your desired action here (e.g., update a database, call an API, etc.)
      await processMessage(message);

      // Keep track of processed messages
      processedMessages.push(record.receiptHandle); // Receipt handle is used to delete the message
    } catch (error) {
      console.error("Error processing message:", error);
    }
  }

  // After processing all messages, delete them from the queue
  if (processedMessages.length > 0) {
    for (const receiptHandle of processedMessages) {
      await deleteMessageFromQueue(queueUrl, receiptHandle);
    }
  }

  return {
    statusCode: 200,
    body: JSON.stringify("Messages processed and deleted successfully"),
  };
};

const processMessage = async (message) => {
  // Example business logic for processing the message
  console.log("Message details:", message);
  const { Message } = message;
  const parsedMessage = JSON.parse(Message);
  console.log("Parsed message:", parsedMessage);
  const { vpcId, peerVcpId, peerOwnerId } = parsedMessage.body;
  const client = new EC2Client(config);
  const input = {
    PeerRegion: "eu-north-1",
    VpcId: vpcId,
    PeerVpcId: peerVcpId,
    PeerOwnerId: peerOwnerId,
  };
  const command = new CreateVpcPeeringConnectionCommand(input);
  const response = await client.send(command);
  console.log("CreateVpcPeeringConnection command sent", response);

  // Add your custom logic here (e.g., update a database, call an API, etc.)
};

const deleteMessageFromQueue = async (queueUrl, receiptHandle) => {
  try {
    await sqs
      .deleteMessage({
        QueueUrl: queueUrl,
        ReceiptHandle: receiptHandle, // Receipt handle used to delete the message
      })
      .promise();
    console.log(`Deleted message with receipt handle: ${receiptHandle}`);
  } catch (error) {
    console.error("Failed to delete message:", error);
  }
};
