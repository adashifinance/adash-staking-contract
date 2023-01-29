
# Adashi Staking Contract


### Staking Functionalities:

1. Deposit Token and gain a fixed APR calculated daily.
1. Compoundig of rewards.
1. rewards claiming.
1. Withdraw a part of deposit.
1. Withdraw all(your deposit + rewards).
1. fixed APR.
1. fixed compounding frequency limit.


# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
node scripts/deploy.js
npx eslint '**/*.js'
npx eslint '**/*.js' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.js
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

# API Specifications
Adashi Finance API is a set of RESTful endpoints that enable developers to interact with the platform and access its core functionality. The following are the specifications for the core functionalities of Adashi Finance API:

    User registration: This endpoint allows users to create an account on the platform by providing basic information such as name, email, and password. The endpoint will return a unique user ID that can be used to identify the user in subsequent requests.

Endpoint: /register
Method: POST
Request Body: { name: string, email: string, password: string }
Response: { user_id: string }

    User login: This endpoint allows users to log in to the platform by providing their email and password. The endpoint will return an access token that can be used to authenticate subsequent requests.

Endpoint: /login
Method: POST
Request Body: { email: string, password: string }
Response: { access_token: string }

    Asset management: This endpoint allows users to deposit, withdraw, and transfer assets on the platform. The endpoint will require the user to provide their access token for authentication.

Endpoint: /assets
Method: POST
Request Body: { access_token: string, action: string, amount: number, asset_id: string }
Response: { status: string, message: string }

    Staking: This endpoint allows users to stake their assets and earn rewards. The endpoint will require the user to provide their access token for authentication and the amount of assets they wish to stake.

Endpoint: /staking
Method: POST
Request Body: { access_token: string, amount: number }
Response: { status: string, message: string }

    Interoperability: This endpoint allows users to transfer assets across different blockchains. The endpoint will require the user to provide their access token for authentication and the asset_id, the amount and the destination blockchain.

Endpoint: /interoperability
Method: POST
Request Body: { access_token: string, asset_id: string, amount: number, destination_chain: string }
Response: { status: string, message: string }

    Analytics: This endpoint allows users to view analytics data such as transaction history, staking history, and other performance metrics. The endpoint will require the user to provide their access token for authentication.

Endpoint: /analytics
Method: GET
Request Body: { access_token: string }
Response: { analytics_data: Object }

These API specifications enable developers to access the core functionalities of Adashi Finance, such as user registration, asset management, staking, and interoperability. The API's are built using RESTful conventions, and it can be integrated with any application using the HTTP protocol.

    Market Data: This endpoint allows users to view real-time market data such as current prices, trading volume, and order book. The endpoint will require the user to provide the asset id for which they want to see the market data.

Endpoint: /marketdata
Method: GET
Request Body: { asset_id: string }
Response: { market_data: Object }

    Portfolio: This endpoint allows users to view their portfolio, which includes their assets and their value. The endpoint will require the user to provide their access token for authentication.

Endpoint: /portfolio
Method: GET
Request Body: { access_token: string }
Response: { portfolio: Object }

    Smart Contract: This endpoint allows developers to deploy and interact with smart contracts on the Ethereum blockchain. The endpoint will require the user to provide their access token for authentication and the smart contract data.

Endpoint: /smartcontract
Method: POST
Request Body: { access_token: string, smart_contract_data: Object }
Response: { status: string, message: string }

    Event Logs: This endpoint allows users to view the event logs of all the smart contract transactions on the Ethereum blockchain. The endpoint will require the user to provide their access token for authentication and the smart contract address.

Endpoint: /eventlogs
Method: GET
Request Body: { access_token: string, contract_address: string }
Response: { event_logs: Array }

