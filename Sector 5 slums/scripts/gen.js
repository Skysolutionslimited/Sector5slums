const Sector5slums = artifacts.require('Sector5slums')
module.exports = async callback => {
	const s5s = await Sector5slums.deployed()
	console.log('Creating request on contract:', s5s.address)
	const tx = await s5s.requestNewRandomAerith('Aerith #1')
	const tx2 = await s5s.requestNewRandomAerith('Aerith #2')
	const tx3 = await s5s.requestNewRandomAerith('Aerith #3')
	const tx4 = await s5s.requestNewRandomAerith('Aerith #4')
	const tx5 = await s5s.requestNewRandomAerith('Aerith #5')
	const tx6 = await s5s.requestNewRandomAerith('Aerith #6')
	const tx7 = await s5s.requestNewRandomAerith('Aerith #7')
	const tx8 = await s5s.requestNewRandomAerith('Aerith #8')
	const tx9 = await s5s.requestNewRandomAerith('Aerith #9')
	const tx10 = await s5s.requestNewRandomAerith('Aerith #10')
	callback(tx.tx)
}