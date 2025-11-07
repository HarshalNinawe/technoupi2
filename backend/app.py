from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv
import jwt
import datetime
from functools import wraps
import bcrypt
from pymongo import MongoClient
import json

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)

# Database setup
mongo_client = MongoClient("mongodb://localhost:27017/upi_blockchain")
db = mongo_client.upi_blockchain

# JWT Secret
JWT_SECRET = os.getenv('JWT_SECRET_KEY')

# JWT decorator
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'message': 'Token is missing'}), 401
        try:
            token = token.split(" ")[1]  # Remove "Bearer " prefix
            data = jwt.decode(token, JWT_SECRET, algorithms=["HS256"])
            current_user = db.users.find_one({'upi_id': data['upi_id']})
            if not current_user:
                return jsonify({'message': 'User not found'}), 401
        except:
            return jsonify({'message': 'Token is invalid'}), 401
        return f(current_user, *args, **kwargs)
    return decorated

@app.route('/api/auth/register', methods=['POST'])
def register():
    data = request.get_json()
    name = data.get('name')
    mobile = data.get('mobile')
    email = data.get('email')
    password = data.get('password')

    if not all([name, mobile, email, password]):
        return jsonify({'message': 'All fields are required'}), 400

    # Check if user already exists
    if db.users.find_one({'$or': [{'mobile': mobile}, {'email': email}]}):
        return jsonify({'message': 'User already exists'}), 400

    # Hash password
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    # Generate UPI ID
    upi_id = f"{name.lower().replace(' ', '')}@{mobile[-4:]}"

    # Create user
    user = {
        'name': name,
        'mobile': mobile,
        'email': email,
        'password': hashed_password,
        'upi_id': upi_id,
        'balance': 0.0,
        'created_at': datetime.datetime.utcnow()
    }

    db.users.insert_one(user)
    return jsonify({'message': 'User registered successfully', 'upi_id': upi_id}), 201

@app.route('/api/auth/login', methods=['POST'])
def login():
    data = request.get_json()
    mobile = data.get('mobile')
    password = data.get('password')

    if not all([mobile, password]):
        return jsonify({'message': 'Mobile and password are required'}), 400

    user = db.users.find_one({'mobile': mobile})
    if not user or not bcrypt.checkpw(password.encode('utf-8'), user['password']):
        return jsonify({'message': 'Invalid credentials'}), 401

    # Generate JWT token
    token = jwt.encode({
        'upi_id': user['upi_id'],
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
    }, JWT_SECRET, algorithm="HS256")

    return jsonify({
        'token': token,
        'user': {
            'name': user['name'],
            'mobile': user['mobile'],
            'email': user['email'],
            'upi_id': user['upi_id'],
            'balance': user['balance']
        }
    }), 200

@app.route('/api/user/profile', methods=['GET'])
@token_required
def get_profile(current_user):
    return jsonify({
        'name': current_user['name'],
        'mobile': current_user['mobile'],
        'email': current_user['email'],
        'upi_id': current_user['upi_id'],
        'balance': current_user['balance']
    }), 200

@app.route('/api/transactions/send', methods=['POST'])
@token_required
def send_money(current_user):
    data = request.get_json()
    recipient_upi = data.get('recipient_upi')
    amount = data.get('amount')

    if not all([recipient_upi, amount]):
        return jsonify({'message': 'Recipient UPI and amount are required'}), 400

    amount = float(amount)
    if amount <= 0:
        return jsonify({'message': 'Invalid amount'}), 400

    if current_user['balance'] < amount:
        return jsonify({'message': 'Insufficient balance'}), 400

    # Find recipient
    recipient = db.users.find_one({'upi_id': recipient_upi})
    if not recipient:
        return jsonify({'message': 'Recipient not found'}), 404

    # Create transaction record
    transaction = {
        'sender_upi': current_user['upi_id'],
        'recipient_upi': recipient_upi,
        'amount': amount,
        'type': 'sent',
        'status': 'pending',
        'timestamp': datetime.datetime.utcnow(),
        'blockchain_tx_hash': None
    }

    # Insert transaction
    tx_id = db.transactions.insert_one(transaction).inserted_id

    try:
        # Update balances
        db.users.update_one({'upi_id': current_user['upi_id']}, {'$inc': {'balance': -amount}})
        db.users.update_one({'upi_id': recipient_upi}, {'$inc': {'balance': amount}})

        # Update transaction status
        db.transactions.update_one({'_id': tx_id}, {
            '$set': {
                'status': 'success'
            }
        })

        return jsonify({
            'message': 'Transaction successful',
            'transaction_id': str(tx_id)
        }), 200

    except Exception as e:
        # Revert balances on failure
        db.users.update_one({'upi_id': current_user['upi_id']}, {'$inc': {'balance': amount}})
        db.users.update_one({'upi_id': recipient_upi}, {'$inc': {'balance': -amount}})
        db.transactions.update_one({'_id': tx_id}, {'$set': {'status': 'failed'}})
        return jsonify({'message': 'Transaction failed', 'error': str(e)}), 500

@app.route('/api/transactions/history', methods=['GET'])
@token_required
def get_transaction_history(current_user):
    upi_id = current_user['upi_id']
    transactions = list(db.transactions.find({
        '$or': [
            {'sender_upi': upi_id},
            {'recipient_upi': upi_id}
        ]
    }).sort('timestamp', -1).limit(50))

    # Convert ObjectId to string for JSON serialization
    for tx in transactions:
        tx['_id'] = str(tx['_id'])
        tx['timestamp'] = tx['timestamp'].isoformat()

    return jsonify({'transactions': transactions}), 200

@app.route('/api/balance', methods=['GET'])
@token_required
def get_balance(current_user):
    return jsonify({'balance': current_user['balance']}), 200

@app.route('/api/health', methods=['GET'])
def health_check():
    try:
        db_connected = mongo_client.server_info() is not None
    except:
        db_connected = False
    return jsonify({
        'status': 'healthy',
        'database_connected': db_connected
    }), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
