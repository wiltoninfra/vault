import sys, os
import boto3
import settings
from flask import Flask, jsonify, request, json
from flask_restful import Resource, Api
from botocore.exceptions import ClientError


def jprint(obj):
    # create a formatted string of the Python JSON object
    text = json.dumps(obj, sort_keys=True, indent=4)
    print(text)

jprint(response.json())

response = requests.get("http://api.open-notify.org/astros.json")
print(response.status_code)