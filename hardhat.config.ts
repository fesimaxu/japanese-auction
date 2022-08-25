import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require('dotenv').config({path:'JAPANESE-AUCTION/.env'});

const { API_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: {
    version : "0.8.9"
  },

  networks : {

    ropsten : {
      url : "https://ropsten.infura.io/v3/f02904b738024f4fabbabdb404d4c0f4",
      accounts : ["bde66b5a1eca5fc91aeb23e06bff90c39baa4ef0e3dd2a5a91fdaf4352b71606"]
    }

  }
};

export default config;
