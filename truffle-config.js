const HDWalletProvider = require('@truffle/hdwallet-provider');

const privateKey = '5ad9465c096333d12787d055551775817a43c1aacaa735cf0befeba31231c92d'; // Приватный ключ
const mantleSepoliaRPC = 'https://5003.rpc.thirdweb.com';

module.exports = {
  networks: {
    mantle_sepolia: {
      provider: () =>
        new HDWalletProvider(privateKey, 'https://5003.rpc.thirdweb.com'),
      network_id: 5003,
      gas: 100000,        // Увеличенный лимит газа
      gasPrice: 20000000, // 2 Gwei
      confirmations: 2,
      timeoutBlocks: 500,   // Увеличенный тайм-аут
      skipDryRun: true
    }
  },
  compilers: {
    solc: {
      version: '0.8.20',
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};

