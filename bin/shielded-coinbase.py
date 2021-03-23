#!/usr/bin/env python3
from slickrpc import Proxy
import pandas as pd
from slickrpc.exc import RpcException
import json
from os import path
#TESTNET CONFIG
#api = Proxy("http://username:passw@127.0.0.1:18232")
#MAINNET CONFIG
api = Proxy("http://username:passw@127.0.0.1:8232")
end_block = api.getblock("-1")
end_height = end_block['height']
sbase_count=0
for i in range(903000, int(end_height)):
    b = api.getblock(str(i), 2)
    data = []
    if ( len(b['tx'][0]['vin'][0]['coinbase']) != 0 and len(b['tx'][0]['vShieldedOutput']) != 0 ):
        data.append([b['hash'], b['time'], b['height'], "shieldedcoinbase"])
        print(b['hash'], b['time'], b['height'], "shieldedcoinbase" )
        sbase_count += 1
    elif( len(b['tx'][0]['vin'][0]['coinbase']) != 0 and len(b['tx'][0]['vShieldedOutput']) == 0 ):
        data.append([b['hash'], b['time'], b['height'], "coinbase"])
    df = pd.DataFrame(data)
    if path.exists("blocksmainnetf.csv"):
        df.to_csv("blocksmainnetf.csv", mode='a', header=False)
    else:
        df.columns = ["Hash", "BlockTime", "Height", "Coinbase"]
        df.to_csv("blocksmainnetf.csv", mode='a')
        print("Total shielded coinbase:", sbase_count)
