const Sector5slums = artifacts.require('Sector5slums')
const LinkTokenInterface = artifacts.require('LinkTokenInterface')
const payment = process.env.TRUFFLE_CL_BOX_PAYMENT || '2000000000000000000'
module.exports = async callback => {
	try {
		const s5s = await Sector5slums.deployed()
		const tokenAddress = await s5s._LinkToken()
		console.log('Chainlink Token Address:', tokenAddress)
		const token = await LinkTokenInterface.at(tokenAddress)
		console.log('Funding contract:', s5s.address)
		const tx = await token.transfer(s5s.address, payment)
		callback(tx.tx)
	} catch(err) {
		callback(err)
	}
}