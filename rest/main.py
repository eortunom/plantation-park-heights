import os
from flask import Flask
import pymysql
from flask import jsonify
from flask import flash, request
import sqlalchemy
import json

db_user = os.environ.get('CLOUD_SQL_USERNAME')
db_password = os.environ.get('CLOUD_SQL_PASSWORD')
db_name = os.environ.get('CLOUD_SQL_DATABASE_NAME')
db_connection_name = os.environ.get('CLOUD_SQL_CONNECTION_NAME')

# When deployed to App Engine, the `GAE_ENV` environment variable will be
# set to `standard`
if os.environ.get('GAE_ENV') == 'standard':
    # If deployed, use the local socket interface for accessing Cloud SQL
    unix_socket = '/cloudsql/{}'.format(db_connection_name)
    engine_url = 'mysql+pymysql://{}:{}@/{}?unix_socket={}'.format(db_user, db_password, db_name, unix_socket)
else:
    # If running locally, use the TCP connections instead
    # Set up Cloud SQL Proxy (cloud.google.com/sql/docs/mysql/sql-proxy)
    # so that your application can use 127.0.0.1:3306 to connect to your
    # Cloud SQL instance
    host = '127.0.0.1'
    engine_url = 'mysql+pymysql://{}:{}@{}/{}'.format(db_user, db_password, host, db_name)

# The Engine object returned by create_engine() has a QueuePool integrated
# See https://docs.sqlalchemy.org/en/latest/core/pooling.html for more
# information
engine = sqlalchemy.create_engine(engine_url, pool_size=5)

app = Flask(__name__)

def __getDBConnection():
    # When deployed to App Engine, the `GAE_ENV` environment variable will be
    # set to `standard`
    if os.environ.get('GAE_ENV') == 'standard':
        # If deployed, use the local socket interface for accessing Cloud SQL
        unix_socket = '/cloudsql/{}'.format(db_connection_name)
        engine_url = 'mysql+pymysql://{}:{}@/{}?unix_socket={}'.format(db_user, db_password, db_name, unix_socket)
#        cnx = engine.connect()
        cnx = pymysql.connect(user=db_user, password=db_password, unix_socket=unix_socket, db=db_name)
    else:
        # If running locally, use the TCP connections instead
        # Set up Cloud SQL Proxy (cloud.google.com/sql/docs/mysql/sql-proxy)
        # so that your application can use 127.0.0.1:3306 to connect to your
        # Cloud SQL instance
        engine_url = 'mysql+pymysql://{}:{}@/{}'.format(db_user, db_password, db_name)
#        cnx = engine.connect()
        cnx = pymysql.connect(user=db_user, password=db_password, host='127.0.0.1', db=db_name)
    return cnx;    

@app.route('/')
def main():
    conn = __getDBConnection()
    cursor = conn.cursor()
    cursor.execute('SELECT NOW() as now;')
    result = cursor.fetchall()
    current_time = result[0][0]
    # If the connection comes from a pool, close() will send the connection
    # back to the pool instead of closing it
    conn.close()

    return str(current_time)

@app.route('/add', methods=['POST'])
def create_notification():
    try:
        _json = request.json
        _sumry = _json['summary']
        _txt = _json['text']
        # validate the received values
        if _sumry and _txt and request.method == 'POST':

            # save edits
            sql = "INSERT INTO T_NTFY(NTFY_CRT_USER_ID, NTFY_SUMRY, NTFY_TXT, NTFY_SENT_DATE) VALUES(1, %s, %s, NOW());"
            data = (_sumry, _txt)
            conn = __getDBConnection()
            cursor = conn.cursor()
            cursor.execute(sql, data)
            conn.commit()
            resp = jsonify('Notification added successfully!')
            resp.status_code = 200
            return resp
        else:
            return not_found()
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()
        
@app.route('/notifications')
def get_notifications():
    try:
        conn = __getDBConnection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute("SELECT * FROM T_NTFY order by NTFY_SENT_DATE desc")
        rows = cursor.fetchall()
        resp = jsonify(rows)
        resp.status_code = 200
        return resp
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()
        
@app.route('/notification/')
def get_notification(id):
    try:
        conn = __getDBConnection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute("SELECT * FROM T_NTFY WHERE NTFY_ID=%s", id)
        row = cursor.fetchone()
        resp = jsonify(row)
        resp.status_code = 200
        return resp
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()

@app.route('/event/add', methods=['POST'])
def create_event():
    try:
        _json = request.json
        _name = _json['name']
        _desc = _json['description']
        _start_date = _json['start_date']
        _end_date = _json['end_date']
        # validate the received values
        if _name and _desc and _start_date and _end_date and request.method == 'POST':

            # save edits
            sql = "INSERT INTO T_EVNT(EVNT_NAME, EVNT_DESC, EVNT_CRT_USER_ID, EVNT_START_DATE, EVNT_END_DATE) VALUES(%s, %s, 1, STR_TO_DATE(%s,'%%m-%%d-%%Y %%h:%%i %%p'), STR_TO_DATE(%s,'%%m-%%d-%%Y %%h:%%i %%p'));"
            data = (_name, _desc, _start_date, _end_date)
            conn = __getDBConnection()
            cursor = conn.cursor()
            cursor.execute(sql, data)
            conn.commit()
            resp = jsonify('Event added successfully!')
            resp.status_code = 200
            return resp
        else:
            return not_found()
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()
        
@app.route('/events')
def get_events():
    try:
        conn = __getDBConnection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute("SELECT EVNT_ID, EVNT_NAME, EVNT_DESC, DATE_FORMAT(EVNT_START_DATE,'%m-%d-%Y %h:%i %p') AS EVNT_START_DATE, DATE_FORMAT(EVNT_END_DATE,'%m-%d-%Y %h:%i %p') AS EVNT_END_DATE, EVNT_CRT_USER_ID FROM T_EVNT order by EVNT_START_DATE desc")
        rows = cursor.fetchall()
        resp = jsonify(rows)
        resp.status_code = 200
        return resp
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()
        
@app.route('/event/')
def get_event(id):
    try:
        conn = __getDBConnection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute("SELECT * FROM T_EVNT WHERE EVNT_ID=%s", id)
        row = cursor.fetchone()
        resp = jsonify(row)
        resp.status_code = 200
        return resp
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()
                
@app.errorhandler(404)
def not_found(error=None):
    message = {
        'status': 404,
        'message': 'Not Found: ' + request.url,
    }
    resp = jsonify(message)
    resp.status_code = 404

    return resp


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)
