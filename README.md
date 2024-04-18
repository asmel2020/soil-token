# Soil Token


## instalación

```
$ yarn
```

or

```
$ yarn install
```

## Compilación

Para compilar el contrato del token soil por favor ejecute el siguiente comando

```
$ yarn compile
```

## Variables de entorno

Por favor sustituir por sus variables de entorno

```JS
BSC_TESTNET_RPC_URL=https://rpc.ankr.com/bsc_testnet_chapel
MUMBAI_RPC_URL=https://rpc.ankr.com/polygon_mumbai
AVALANCHE_TESTNET_RPC_URL=https://rpc.ankr.com/avalanche_fuji
GOERLI_TESTNET_RPC_URL=https://rpc.ankr.com/eth_goerli
TESTNET_RPC_URL="http://127.0.0.1:7545"

BSC_RPC_URL=https://bscrpc.com
AVALANCHE_RPC_URL=https://rpc.ankr.com/avalanche
POLYGON_RPC_URL=https://rpc.ankr.com/polygon
MAINNET_RPC_URL=https://eth-rpc.gateway.pokt.network

## private key de la wallet (obligatorio)
DEPLOYER_PRIVATE_KEY_TESTNET=
DEPLOYER_PRIVATE_KEY=

## api key para verificar los contratos
ETHERSCAN_API_KEY=
BSCSCAN_API_KEY=
AVALANCHE_API_KEY=
POLYGONSCAN_API_KEY=


## api key para la consulta de gas fee de coinmarketcap
COINMARKETCAP_API_KEY=

```
## Test

```
$ yarn test
```


## Deploy

```
$ yarn deploy:soil --network bsc
```