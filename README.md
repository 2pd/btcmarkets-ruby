# BTCMarkets API wrapper
This is Ruby Wrapper for https://btcmarkets.net/

Supported V3 only

RP is welcome

## Install

```bash
gem 'btcmarkets'

bundle install

```

## Usage

```ruby

require 'btcmarkets'

puts BTCMarkets::Market.markets

# see below for more supported API
```

## Supported API

```bash
# public API
BTCMarkets::Market.markets
BTCMarkets::Market.tikers(%w[BTC-AUD LTC-AUD])
BTCMarkets::Server.time


# private API
# Set up the BTCMakerts API key as environment variables:

ENV['BTCMARKETS_PUBLIC_KEY'] = ''
ENV['BTCMARKETS_PRIVATE_KEY'] = ''

BTCMarkets::Account.blance

BTCMarkets::Account.transactions({limit: 2, after: xxxxx, before: xxxx})
BTCMarkets::Account.transactions

BTCMarkets::Trade.trades
BTCMarkets::Trade.trade('xxxxxx')

BTCMarkets::Fund.deposit_address('BTC')


// create an order
BTCMarkets::Order.create({
  'marketId': 'BTC-AUD',
  'price': '1000.00',
  'amount': '0.1',
  'type': 'Limit',
  'side': 'Bid'
})

// cancel an order
BTCMarkets::Order.cancel('1234567')
```

## Licence
MIT
