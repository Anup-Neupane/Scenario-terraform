import json
import boto3

def handler(event, context):
    """
    Lambda function to process S3 uploads
    """
    print("Received event: " + json.dumps(event))
    
    # Process S3 event
    for record in event.get('Records', []):
        if record['eventSource'] == 'aws:s3':
            bucket = record['s3']['bucket']['name']
            key = record['s3']['object']['key']
            
            print(f"Processing file: s3://{bucket}/{key}")
            
            # Add your file processing logic here
            # Example: read file, transform, upload to another location, etc.
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': f'Successfully processed {key}',
                    'bucket': bucket,
                    'key': key
                })
            }
    
    return {
        'statusCode': 400,
        'body': json.dumps({'message': 'No S3 records found'})
    }
