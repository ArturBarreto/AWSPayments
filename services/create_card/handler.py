import os, json, uuid, boto3
from datetime import datetime, timezone

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def handle(event, context):
    print("CODE_VERSION:", os.getenv("CODE_VERSION"))

    card_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc).isoformat()
    item = {
        'pk': f'CARD#{card_id}',
        'sk': 'PROFILE',
        'cardId': card_id,
        'createdAt': now,
        'balance': 0,
        'version': 0,
        'status': 'ACTIVE'
    }
    table.put_item(Item=item, ConditionExpression='attribute_not_exists(pk)')
    return _resp(201, {'cardId': card_id, 'status': 'ACTIVE', 'balance': 0, 'createdAt': now})

def _resp(code, obj):
    return {'statusCode': code, 'headers': {'Content-Type':'application/json'}, 'body': json.dumps(obj)}
