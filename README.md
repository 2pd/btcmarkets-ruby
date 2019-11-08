# BTCMarkets API wrapper
This is Ruby Wrapper for https://btcmarkets.net/

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
```

## Licence
MIT
