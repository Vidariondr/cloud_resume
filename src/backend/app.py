import boto3
import json
import logging
from botocore.config import Config
from botocore.exceptions import ClientError, BotoCoreError

cfg = Config(retries={"max_attempts": 8, "mode": "standard"})
dynamodb = boto3.resource("dynamodb", config=cfg)
table = dynamodb.Table("visitor-counter")

logger = logging.getLogger()
logger.setLevel("INFO")


def update_item():
    try:
        response = table.update_item(
            Key={"var_name": "visitors"},
            UpdateExpression="ADD #num :val",
            ExpressionAttributeNames={"#num": "number"},
            ExpressionAttributeValues={":val": 1},
            ReturnValues="UPDATED_NEW",
        )
        return int(response["Attributes"]["number"])
    except (ClientError, BotoCoreError) as e:
        logger.error(f"Failed to update value in DynamoDB: {str(e)}")
        raise


def lambda_handler(event, context):
    value = update_item()

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(value),
    }
