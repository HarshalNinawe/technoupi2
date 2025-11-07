from web3 import Web3
from solcx import compile_source
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Connect to blockchain
infura_url = f"https://sepolia.infura.io/v3/{os.getenv('INFURA_PROJECT_ID')}"
web3 = Web3(Web3.HTTPProvider(infura_url))

if not web3.is_connected():
    print("Failed to connect to blockchain")
    exit(1)

print("Connected to blockchain")

# Load contract source
with open('contracts/UPI.sol', 'r') as file:
    contract_source = file.read()

# Compile contract
compiled_sol = compile_source(contract_source, output_values=['abi', 'bin'])
contract_interface = compiled_sol['<stdin>:UPI']

# Get contract details
abi = contract_interface['abi']
bytecode = contract_interface['bin']

# Create contract instance
UPIContract = web3.eth.contract(abi=abi, bytecode=bytecode)

# Get account details
private_key = os.getenv('PRIVATE_KEY')
account = web3.eth.account.from_key(private_key)
print(f"Deploying from account: {account.address}")

# Get nonce
nonce = web3.eth.get_transaction_count(account.address)

# Build transaction
initial_supply = 1000000  # 1 million tokens
transaction = UPIContract.constructor(initial_supply).build_transaction({
    'chainId': 11155111,  # Sepolia testnet
    'gas': 2000000,
    'gasPrice': web3.eth.gas_price,
    'nonce': nonce,
})

# Sign transaction
signed_txn = web3.eth.account.sign_transaction(transaction, private_key)

# Send transaction
print("Deploying contract...")
tx_hash = web3.eth.send_raw_transaction(signed_txn.raw_transaction)
print(f"Transaction hash: {tx_hash.hex()}")

# Wait for transaction receipt
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
contract_address = tx_receipt.contractAddress

print(f"Contract deployed at: {contract_address}")

# Save contract address to .env file
with open('.env', 'a') as env_file:
    env_file.write(f"\nCONTRACT_ADDRESS={contract_address}")

print("Contract address saved to .env file")
print("Update your .env file with the contract address and restart the server")
