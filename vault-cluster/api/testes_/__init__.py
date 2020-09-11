import sys, os
from flask import Flask, jsonify, request, json
from flask_restful import Resource, Api
import boto3
from botocore.exceptions import ClientError
import settings
from dotenv import load_dotenv