import os, json, boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def _to_jsonable(v):
    if isinstance(v, Decimal):
        # keep integers as int, others as float
        return int(v) if v % 1 == 0 else float(v)
    return v

def handle(event, context):
    card_id = event['pathParameters']['id']
    res = table.get_item(Key={'pk': f'CARD#{card_id}', 'sk': 'PROFILE'})
    item = res.get('Item')
    if not item:
        return _resp(404, {'message': 'Card not found'})
    body = {
        'cardId': item['cardId'],
        'balance': _to_jsonable(item['balance']),
        'status': item['status'],
        'version': _to_jsonable(item['version'])
    }
    return _resp(200, body)

def _resp(code, obj):
    return {
        'statusCode': code,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(obj)
    }
