require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const QUICKNODE_HTTP_URL = process.env.QUICKNODE_HTTP_URL;
const FANTOM_TESTNET_PRIVATE_KEY = process.env.FANTOM_TESTNET_PRIVATE_KEY;
const API_KEY = process.env.API_KEY;
const MUMBAI_API_URL = process.env.MUMBAI_API_URL;

module.exports = {
  solidity: "0.8.4",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
  networks: {
    polygon_mumbai: {
      url: MUMBAI_API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    mainnet: {
      url: `https://rpcapi.fantom.network`,
      chainId: 250,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    testnet: {
      url: `https://rpc.ankr.com/fantom_testnet	`,
      chainId: 4002,
      accounts: [`0x${FANTOM_TESTNET_PRIVATE_KEY}`],
    },
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/v9W516ElVJiumaJMICDZu6uwckxu7oTi`,
      accounts: [PRIVATE_KEY],
    },
    coverage: {
      url: "http://localhost:8555",
    },
    localhost: {
      url: `http://127.0.0.1:8545`,
    },
  },
  etherscan: {
    apiKey: {
      ftmTestnet: API_KEY,
      opera: API_KEY,
    },
  },
};
