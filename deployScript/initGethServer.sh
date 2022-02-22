#! /bin/bash
#scp -P 22 -i ~/officer/RNlogics/xrunrpc.pem ./initGethServer.sh ubuntu@18.141.189.104:~/geth

echo "ip 정보를 입력주세요 :"
read ipAddress

genesisData='
{
  "config": {
    "chainId": 6794,
    "homesteadBlock": 0,
     "byzantiumBlock": 0,
  "constantinopleBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "alloc": {},
  "coinbase": "0x3333333333333333333333333333333333333333",
  "difficulty": "0x4000",
  "extraData": "",
  "gasLimit": "0x80000000",
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
}'


sudo rm -rf ./data
mkdir ./data
wait
touch ./genesis.json
echo $genesisData >> ./genesis.json
mv ./genesis.json ./data
wait
touch ./static-nodes.json

# screen -dmS gethServer
# screen -r
# screen 접근후 geth 명령어 실행
#######  geth init ####### 
geth --datadir ./data/ \
        init ./data/genesis.json

wait
result=$?
echo $result
if [ -gt $result ]; then
  echo "====================Geth init error==================== "
  exit 2;
fi
####### geth start#######
geth --networkid 6794 \
    --http --http.api "admin,debug,db,eth,net,web3,miner,personal" \
    --http.port "5006" \
    --port 5007 \
    --vmdebug \
    --nodiscover \
    --datadir ./data/ \
    --http.addr "$ipAddress"      \
    --http.corsdomain "*" \
    --allow-insecure-unlock
wait

if [ ! -e "start.sh" ]; then
  getStartCommand='geth --networkid 6794 \
    --http --http.api "admin,debug,db,eth,net,web3,miner,personal" \
    --http.port "5006" \
    --port 5007 \
    --vmdebug \
    --nodiscover \
    --datadir ./data/ \
    --http.addr "$ipAddress"      \
    --http.corsdomain "*" \
    --allow-insecure-unlock
'
  touch start.sh
  echo $getStartCommand >> start.sh
  sudo chmod  +x start.sh 
fi

# Attach geth console 
# admin.nodeInfo.enode >> Node정보 
# personal.newAccount("1234")
# personal.newAccount("1234")
# miner.start()

# add staic-nodes.json
# >> [Node정보 , Node정보 ]
result=$?
echo $result
