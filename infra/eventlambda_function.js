exports.handler = async (event) => {
  console.log("Received Event:", JSON.stringify(event, null, 2));

  event.Records.forEach((record) => {
    const detail = record.detail;

    const eventName = detail.eventName;
    const peeringId =
      detail.responseElements?.vpcPeeringConnectionId || "Unknown";

    console.log(`Event: ${eventName}, VPC Peering Connection ID: ${peeringId}`);
  });

  return { statusCode: 200 };
};
