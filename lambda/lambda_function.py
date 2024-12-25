import boto3
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    response = table.get_item(Key={'id': 'visits'})
    count = response['Item']['count'] if 'Item' in response else 0

    count += 1
    table.put_item(Item={'id': 'visits', 'count': count})

    return {
    'statusCode': 200,
    'headers': {
        'Access-Control-Allow-Origin': 'https://d3shgougbc5d8d.cloudfront.net',
        'Content-Type': 'application/json'
    },
    'body': f'{{"count": {count}}}'
}
