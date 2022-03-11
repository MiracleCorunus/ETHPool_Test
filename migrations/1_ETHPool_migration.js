const ETHPool = artifacts.require('ETHPool');

module.exports = async function (deployer, network, accounts) {
    await deployer.deploy(ETHPool, { from: accounts[0] });
}