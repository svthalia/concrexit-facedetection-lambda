# concrexit-facedetection-lambda

An AWS Lambda function that extracts face encodings for [svthalia/concrexit](https://github.com/svthalia/concrexit).

## Usage

This function is meant to be invoked with an [AWS API call](https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html).

From python, this can be done with []`boto3`](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/lambda/client/invoke.html), given the `InvokeFunction` permission:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "<lambda-arn>"
    }
  ]
}
```

The function expects a payload as follows (at least one source):

```json
{
  "api_url": "https://thalia.nu/",
  "sources": [
    {
      "pk": 1,
      "type": "'photo' or 'reference'",
      "photo_url": "url to download photo file from",
      "token": "base64 token for authentication",
    },
    ...
  ]
}
```

If everything goes right, for each source, the function will POST to e.g. `https://thalia.nu/api/facedetection/encodings/photo/1/` with body (0 or more encodings):
    
```json
{
  "token": "base64 token for authentication",
  "encodings": [
    [<128 floats>],
    ...
  ]
}
```

## Deployment

Deploying this function takes a few steps:

1. First, there needs to be an AWS Elastic Container Registry (ECR) repository to store the Docker image in. 
  We assume that this is created manuallyn and has the name `concrexit/facedetection-lambda`. See https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-console.html.
2. Then, the Docker image needs to be built and pushed to the ECR repository, with a `production` or `staging` tag. See https://docs.aws.amazon.com/lambda/latest/dg/images-create.html#images-create-from-base.
