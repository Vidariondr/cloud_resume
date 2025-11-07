import boto3
import pytest
import json
from moto import mock_aws
import os

@pytest.fixture(scope="function")
def aws_credentials():
    os.environ["AWS_ACCESS_KEY_ID"] = "testing"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
    os.environ["AWS_SECURITY_TOKEN"] = "testing"
    os.environ["AWS_SESSION_TOKEN"] = "testing"
    os.environ["AWS_DEFAULT_REGION"] = "eu-central-1"

@pytest.fixture(scope="function")
def dynamodb(aws_credentials):
    with mock_aws():
        yield boto3.resource("dynamodb", region_name="eu-central-1")

@pytest.fixture(scope="function")
def mocked_aws(aws_credentials):
    with mock_aws():
        yield

@pytest.fixture
def create_visitor_table(dynamodb):
    dynamodb.create_table(TableName='visitor-counter', AttributeDefinitions=[{ 'AttributeName': 'var_name', 'AttributeType': 'S'}], KeySchema=[{ 'AttributeName': 'var_name', 'KeyType': 'HASH'}], BillingMode='PAY_PER_REQUEST')

@pytest.fixture
def put_item(create_visitor_table):
    boto3.resource('dynamodb').Table('visitor-counter').put_item(Item={'var_name': 'visitors', 'number': 1})

def test_update_item(put_item):
    from app import lambda_handler
    response = lambda_handler({}, None)
    assert json.loads(response["body"]) == 2
    response2 = lambda_handler({}, None)
    assert json.loads(response2["body"]) == 3
    response3 = boto3.resource('dynamodb').Table('visitor-counter').get_item(Key={'var_name': 'visitors'})
    assert response3['Item']['number'] == 3

def test_no_initial_value(create_visitor_table):
    from app import lambda_handler
    response = lambda_handler({}, None)
    assert json.loads(response["body"]) == 1
    response2 = lambda_handler({}, None)
    assert json.loads(response2["body"]) == 2
    response3 = boto3.resource('dynamodb').Table('visitor-counter').get_item(Key={'var_name': 'visitors'})
    assert response3['Item']['number'] == 2