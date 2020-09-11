#!/usr/bin/env python


# Import module support
#import settings, class1, modules

import django
app = Flask(__name__)

@app.route('/module/')
def modules():
    a = settings.greeting("Jonathan")
    return a

@app.route('/')
def hello():
    return "Welcome API"

@app.route('/hello/', methods=['GET', 'POST'])
def welcome():
    return "Hello World!"    

@app.route('/<int:number>/')
def incrementer(number):
    return "Incremented number is " + str(number+10)

@app.route('/person/')
def person():
    return jsonify({'name':'Jimit',
                    'address':'India'})

@app.route('/home/')
def home():
    return "Home page"

@app.route('/contact')
def contact():
    return "Contact page"

@app.route('/numbers/')
def print_list():
    return jsonify(list(range(50)))

@app.route('/teapot/')
def teapot():
    return "Would you like some tea?", 418

@app.before_request
def before():
    print("This is executed BEFORE each request.")

if __name__ == '__main__':
    app.run(host="0.0.0.0", port="5000")
    app.run(debug=True)

# docker container run -ti -d --mount type=volume,source=./,destination=/app  wilton/python:3.9