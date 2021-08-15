const Sector5slums = artifacts.require('Sector5slums')
module.exports = async callback => {
	const s5s = await Sector5slums.deployed()
	console.log('Overview of aerith')
	const overview = await s5s.aeriths(0)
	console.log(overview)
	callback(overview.tx)
}