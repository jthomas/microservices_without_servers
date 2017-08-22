const request = require('request-promise')

function bitcoinPrices () {
  return request('https://api.coindesk.com/v1/bpi/currentprice.json', { json: true })
}

function main (params) {
  if (!params.amount) {
    return { error: 'Missing mandatory argument: amount' }
  }

  if (!params.currency) {
    return { error: 'Missing mandatory argument: currency' }
  }

  return bitcoinPrices().then(prices => {
    if (!prices.bpi[params.currency]) {
      return { error: 'Currency not listed in Bitcoin prices' }
    }

    const rate = prices.bpi[params.currency].rate_float
    const converted = params.amount / rate
    const bitcoins = converted.toFixed(6)
    return { 'amount': bitcoins, 'label': `${params.amount} ${params.currency} is worth ${bitcoins} bitcoins.` }

  })
}
