#### 로그파일 생성

- geth와 커넥션하여 트랜잭션 로그 기록

```
    screen -dmS GethObserve
    //WebSocket 코드 주의하며
    nc -U ./{geth}/geth.ipc >> ./{__원하는 로그 위치}/__.txt
    { "id": 1, "method": "eth_subscribe", "params": ["logs", {}] } //첫로그는 result만 나오니 주의
```
