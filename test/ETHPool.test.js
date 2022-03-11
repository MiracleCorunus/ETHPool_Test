const ETHPool = artifacts.require('ETHPool');

const { toWei, toBN } = web3.utils;

contract('ETHPool', function ([alice, bob, david, carol, eve, paul, ben]) {

    context("Test Deposit ETH to Pool", () => {
        before(async function () {
            this.ethPool = await ETHPool.new({ from: alice })
        })
        it("Should success to deposit ETH to Pool by Bob", async function () {
            await this.ethPool.depositETH({ from: bob, value: toWei('10', 'ether') });
            const balancePool = await this.ethPool.getBalance();
            assert.equal(balancePool.toString(), '10000000000000000000');
        })
        it("Should success to deposit Reward to Pool", async function () {
            await this.ethPool.depositReward({ from: alice, value: toWei('5', 'ether') });
            const balancePool = await this.ethPool.getBalance();
            assert.equal(balancePool.toString(), '15000000000000000000')
        })
        it("Should success to deposit ETH to Pool by David", async function () {
            await this.ethPool.depositETH({ from: david, value: toWei('30', 'ether') });
            const balancePool = await this.ethPool.getBalance();
            assert.equal(balancePool.toString(), '45000000000000000000')
        })
        it("Should success to deposit Reward to Pool", async function () {
            await this.ethPool.depositReward({ from: alice, value: toWei('40', 'ether') });
            const balancePool = await this.ethPool.getBalance();
            assert.equal(balancePool.toString(), '85000000000000000000')
        })
        it("Should success to claim Reward & deposited ETH from Pool by Bob", async function () {
            await this.ethPool.withdraw({ from: bob });
            const balancePool = await this.ethPool.getBalance();
            assert.equal(balancePool.toString(), '60000000000000000000')
        })
        it("Should success to claim Reward & deposited ETH from Pool by David", async function () {
            await this.ethPool.withdraw({ from: david });
            const balancePool = await this.ethPool.getBalance();
            assert.equal(balancePool.toString(), '0')
        })
    })
})