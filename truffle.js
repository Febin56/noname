require('babel-register');
require('babel-polyfill');
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "finish nothing ribbon today scout tobacco ivory staff quote wasp lecture spend";
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 2400000
    }
  }
};
module.exports = {
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/EtNq2cv60m36VxoZxwpo")
      },
      network_id: "*",
      gas: 4700000
    }   
  }
};




