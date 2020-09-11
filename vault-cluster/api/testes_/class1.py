import sys, os
import boto3
import settings
from flask import Flask, jsonify, request, json
from flask_restful import Resource, Api
from botocore.exceptions import ClientError

app = Flask(__name__)
api = Api(app)

class Quotes(Resource):
    def get(self):
        return {
            'William Shakespeare': {
                'quote': ['Love all,trust a few,do wrong to none',
                'Some are born great, some achieve greatness, and some greatness thrust upon them.']
        },
        'Linus': {
            'quote': ['Talk is cheap. Show me the code.']
            }
        }
api.add_resource(Quotes, '/quota')
