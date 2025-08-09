import os, json, boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def handle(event, context):
    card_id = event['pathParameters']['id']
    res = table.get_item(Key={'pk': f'CARD#{card_id}', 'sk': 'PROFILE'})
    item = res.get('Item')
    if not item:
        return _resp(404, {'message':'Card not found'})
    return _resp(200, {'cardId': item['cardId'], 'balance': item['balance'], 'status': item['status'], 'version': item['version']})

def _resp(code, obj):
    return {'statusCode': code, 'headers': {'Content-Type':'application/json'}, 'body': json.dumps(obj)}
