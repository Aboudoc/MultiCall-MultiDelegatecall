require("@nomicfoundation/hardhat-toolbox")
require("dotenv").config()

module.exports = {
    solidity: "0.8.10",
    dafaultNetwork: "hardhat",
    networks: {
        goerli: {
            url: GOERLI_RPC_URL,
            accounts: [PRIVATE_KEY],
        },
    },
}
