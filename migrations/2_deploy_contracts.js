const NFTTree = artifacts.require('NFTTree');

module.exports = async function (deployer) {
  await deployer.deploy(NFTTree);
};

