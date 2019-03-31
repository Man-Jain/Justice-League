from web3 import Web3
import json

w3 = Web3(Web3.HTTPProvider("https://testnet.matic.network"))

file = open('abi.json', encoding='utf-8')
j = json.load(file)
abi = j
contractAddress = '0x080b2ff34504d65ce7842f51f1fe42d992c8bb0a'

greeter = w3.eth.contract(address=Web3.toChecksumAddress(contractAddress), abi=abi)
BLOCKCHAIN = greeter.functions
