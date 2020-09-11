import sys, os
from flask import Flask, jsonify, request, json
from flask_restful import Resource, Api
import boto3
from botocore.exceptions import ClientError

app = Flask(__name__)
api = Api(app)

def greeting(name):
  print("Hello, " + name)