#!/usr/bin/env python
# -*- coding: utf-8 -*-
from flask import Flask, request, jsonify, current_app, abort, send_from_directory,json
from flask_cors import CORS, cross_origin
from functools import wraps
from flaskext.mysql import MySQL
import json
import requests
from datetime import datetime, timedelta
import sys
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)

app.secret_key = b'mq\xa8x\xcc[\n\xa2\xb3.~\x94\x16\xd0\xd6w'
app.config['MYSQL_DATABASE_USER'] = "root"
app.config['MYSQL_DATABASE_PASSWORD'] = "12345678"
app.config['MYSQL_DATABASE_DB'] = 'py_con'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif' ])
mysql = MySQL()
mysql.init_app(app)


def connect_sql():
    def wrap(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            try:
                # Setup connection
                connection = mysql.connect()
                cursor = connection.cursor()
                return_val = fn(cursor, *args, **kwargs)
            finally:
                # Close connection
                connection.commit()
                connection.close()
            return return_val
        return wrapper
    return wrap

def toJson(data,columns):
    results = []
    for row in data:
        results.append(dict(zip(columns, row)))
    return results
