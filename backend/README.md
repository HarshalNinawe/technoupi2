# TechnoUPI2 Backend

A blockchain-integrated Python backend for the TechnoUPI2 Flutter UPI application.

## Features

- User authentication with JWT tokens
- Secure UPI transactions via blockchain
- MongoDB database for user and transaction data
- RESTful API endpoints
- Smart contract integration with Ethereum

## Setup Instructions

### Prerequisites

- Python 3.8+
- MongoDB
- Infura account for Ethereum access
- MetaMask or similar wallet for private key

### Installation

1. **Clone the repository and navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create a virtual environment:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables:**
   - Copy `.env` file and fill in your values:
     ```
     INFURA_PROJECT_ID=your_infura_project_id_here
     PRIVATE_KEY=your_private_key_here
     CONTRACT_ADDRESS=your_deployed_contract_address_here
     MONGODB_URI=mongodb://localhost:27017/upi_blockchain
     JWT_SECRET_KEY=your_jwt_secret_key_here
     ```

### Blockchain Setup

1. **Get Infura Project ID:**
   - Sign up at [Infura](https://infura.io/)
   - Create a new project for Sepolia testnet

2. **Deploy Smart Contract:**
   ```bash
   python deploy_contract.py
   ```
   This will deploy the UPI smart contract to Sepolia testnet and update your `.env` file.

3. **Fund your account:**
   - Get Sepolia ETH from [Sepolia Faucet](https://sepoliafaucet.com/)
   - Fund the account associated with your `PRIVATE_KEY`

### Database Setup

1. **Install MongoDB:**
   - Download from [MongoDB Community Server](https://www.mongodb.com/try/download/community)

2. **Start MongoDB:**
   ```bash
   mongod
   ```

### Running the Application

1. **Start the Flask server:**
   ```bash
   python app.py
   ```

2. **The API will be available at:** `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login

### User Management
- `GET /api/user/profile` - Get user profile (requires auth)

### Transactions
- `POST /api/transactions/send` - Send money (requires auth)
- `GET /api/transactions/history` - Get transaction history (requires auth)

### Balance
- `GET /api/balance` - Get user balance (requires auth)

### Health Check
- `GET /api/health` - Check service health

## Smart Contract

The `UPI.sol` contract provides:
- ERC-20 compatible token functionality
- Minting and burning capabilities
- Transfer functions for UPI payments
- Balance checking

## Security Features

- Password hashing with bcrypt
- JWT token authentication
- Blockchain-based transaction verification
- CORS enabled for Flutter app integration

## Testing

Run the health check endpoint to verify all services are connected:
```bash
curl http://localhost:5000/api/health
```

## Deployment

For production deployment:
1. Use a production MongoDB instance (MongoDB Atlas)
2. Deploy smart contract to mainnet
3. Use environment-specific configuration
4. Set up proper logging and monitoring
5. Use a WSGI server like Gunicorn

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.
