
    "ccxt_config": {
          "aiohttp_proxy": "http://127.0.0.1:1087",
          "proxies": {
            "http": "http://127.0.0.1:1087",
            "https": "http://127.0.0.1:1087"
          }
      }
https://github.com/iterativv/NostalgiaForInfinity

--------
套利
    freqtrade download-data --pairs-file user_data/data/binance/spot/arbi.json --config config_arbi.json --exchange binance --days 120 --timeframes 5m

freqtrade backtesting --config config_arbi.json --strategy ArbiStrategy --fee 0

-----------
   binance
   freqtrade download-data --pairs-file user_data/data/binance/pairs.json --config config_v7.json --exchange binance --days 360 --timeframes 4h 8h
   freqtrade download-data --pairs-file user_data/data/binance/spot/pairs.json --config config_dryrun_3.json --exchange binance --days 90 --timeframes 5m 15m 1h 4h 1d
   freqtrade download-data --pairs-file user_data/data/binance/spot/pairs.json --config config_claude.json --exchange binance --days 90 --timeframes 5m 15m 30m 1h 4h
    freqtrade download-data --pairs-file user_data/data/gate/futures/pairs.json --config config_claude_btc_high_profit.json --exchange gate --days 120 --timeframes 30m 1h 4h
     freqtrade download-data --pairs-file user_data/data/bitget/futures/pairs.json --config config_claude_bitget_high_profit.json --exchange binance --days 120 --timeframes 30m 1h 4h
    freqtrade download-data --pairs-file user_data/data/binance/spot/pairs.json --config config_claude_btc_high_profit.json --exchange binance --days 120 --timeframes 30m 1h 4h 1d

   freqtrade backtesting --config config_v7.json --strategy NFIv7_SMA_Rallipanos --dry-run-wallet 1000  --enable-protections
   freqtrade backtesting-analysis -c config_v7.json --analysis-to-csv --analysis-csv-path ./


    freqtrade backtesting --config config_claude_bitget_high_profit.json --strategy EMABITGETHIGHPROFITStrategy
    freqtrade hyperopt --hyperopt-loss SharpeHyperOptLoss --strategy MultiTimeframeEMAStrategy --spaces buy --config config_claude.json -e 100 && freqtrade hyperopt --hyperopt-loss SortinoHyperOptLoss --strategy MultiTimeframeEMAStrategy --spaces buy --config config_claude.json -e 100 && freqtrade hyperopt --hyperopt-loss CalmarHyperOptLoss --strategy MultiTimeframeEMAStrategy --spaces buy --config config_claude.json -e 100

    freqtrade backtesting --config config_claude.json --strategy MultiTimeframeEMAStrategy

   freqtrade hyperopt --hyperopt-loss OnlyProfitHyperOptLoss --strategy EMAHIGHPROFITStrategy --spaces  roi stoploss --config config_claude_high_profit.json -e 300 || true
   freqtrade hyperopt --hyperopt-loss OnlyProfitHyperOptLoss --strategy EMAHIGHPROFITStrategy --spaces  buy sell  --config config_claude_high_profit.json -e 300
   freqtrade hyperopt --hyperopt-loss OnlyProfitHyperOptLoss --strategy NFIv7_SMA_Rallipanos --spaces buy  --config config_v7.json -e 200
   freqtrade hyperopt --hyperopt-loss MaxDrawDownHyperOptLoss --strategy NFIv7_SMA_Rallipanos --spaces sell  --config config_v7.json -e 200
   freqtrade hyperopt --hyperopt-loss OnlyProfitHyperOptLoss --strategy SMAOffset_Hippocritical_dca   --config config_v7.json -e 200
   freqtrade hyperopt --hyperopt-loss OnlyProfitHyperOptLoss --strategy NFIv7_SMA_Rallipanos_60M_OKX --spaces buy  --config config_dryrun_3.json -e 200


   freqtrade download-data --pairs-file user_data/data/binance/pairs.json --config config_NFIX2.json --exchange binance --days 120 --timeframes 15m 1h 4h 1d
   freqtrade download-data --pairs-file user_data/data/binance/pairs_spot.json --config config_NFIX2.json --exchange binance --days 120 --timeframes 5m 15m 1h 4h 1d
   freqtrade backtesting --config config_NFIX2.json --strategy NFIX2 --dry-run-wallet 4000

   # spot
   freqtrade download-data --pairs-file user_data/data/binance/pairs_spot.json --config config_v7_spot.json --exchange binance --days 120 --timeframes 5m 1h
   freqtrade hyperopt --hyperopt-loss OnlyProfitHyperOptLoss --strategy NFIv7_SMA_Rallipanos --spaces buy  --config config_v7_spot.json -e 200
   freqtrade hyperopt --hyperopt-loss CalmarHyperOptLoss --strategy NFIv7_SMA_Rallipanos --spaces sell  --config config_v7_spot.json -e 200
   freqtrade backtesting --config config_v7_spot.json --strategy NFIv7_SMA_Rallipanos --dry-run-wallet 4000
   #  NFIX2
   freqtrade download-data --pairs-file user_data/data/binance/pairs.json --config config_NFIX2.json --exchange binance --days 120 --timeframes 5m 15m 1h 4h 1d
   freqtrade download-data --pairs-file user_data/data/binance/pairs_spot.json --config config_NFIX2.json --exchange binance --days 120 --timeframes 5m 15m 1h 4h 1d
   freqtrade hyperopt --hyperopt-loss SharpeHyperOptLoss --strategy NFIX2 --spaces buy  --config config_NFIX2.json -e 200
   freqtrade hyperopt --hyperopt-loss CalmarHyperOptLoss --strategy NFIX2 --spaces sell  --config config_NFIX2.json -e 200
   freqtrade backtesting --config config_NFIX2.json --strategy NFIX2 --dry-run-wallet 4000
-----------
    okx
   freqtrade download-data --pairs-file user_data/data/okx/pairs.json --config config_okx.json --exchange okx --timeframes 1h
   freqtrade backtesting --config config_okx.json --strategy OKX --dry-run-wallet 4000
   freqtrade hyperopt --hyperopt-loss OnlyProfitHyperOptLoss --strategy OKX --spaces buy  --config config_okx.json -e 200
   freqtrade hyperopt --hyperopt-loss CalmarHyperOptLoss --strategy OKX --spaces sell  --config config_v7.json -e 200



-------
    远程机器

   docker-compose   run --rm  freqtrade download-data --pairs-file user_data/data/binance/pairs.json --config user_data/config.json --exchange binance --timeframes 5m 1h
   docker-compose run --rm freqtrade backtesting --config user_data/config.json --strategy NFIv7_SMA_Rallipanos_Short --dry-run-wallet 4000
   docker-compose  run -d --rm   freqtrade hyperopt --hyperopt-loss SharpeHyperOptLoss --strategy NFIv7_SMA_Rallipanos_Short --spaces buy --config user_data/config.json -e 200

-------
 AI
freqtrade trade --config config_examples/config_freqai.example.json --strategy FreqaiExampleStrategy --freqaimodel LightGBMRegressor --strategy-path freqtrade/templates


------
   公共

   freqtrade webserver --config config_v7.json

   freqtrade show-trades --db-url sqlite:////freqtrade/user_data/tradesv3_bn.sqlite --print-json --trade-ids 531

   freqtrade trade --strategy FreqaiExampleStrategy --config config_ai.json --freqaimodel LightGBMRegressor


ShortTradeDurHyperOptLoss：评估交易的短期回报率，目标是最大化交易的回报率。

OnlyProfitHyperOptLoss：评估只有盈利交易的回报率，目标是最大化交易的回报率，同时减少亏损交易的影响。

SharpeHyperOptLoss：评估交易的夏普比率，目标是最大化交易的回报率和最小化交易的风险。

SharpeHyperOptLossDaily：评估交易的日度夏普比率，目标是最大化交易的回报率和最小化交易的风险。

SortinoHyperOptLoss：评估交易的Sortino比率，目标是最大化交易的回报率和最小化交易的下行风险。

SortinoHyperOptLossDaily：评估交易的日度Sortino比率，目标是最大化交易的回报率和最小化交易的下行风险。

CalmarHyperOptLoss：评估交易的Calmar比率，目标是最大化交易的回报率和最小化交易的最大回撤。

MaxDrawDownHyperOptLoss：评估交易的最大回撤，目标是最小化交易的最大回撤。

MaxDrawDownRelativeHyperOptLoss：评估交易的相对最大回撤，目标是最小化交易的相对最大回


ProfitDrawDownHyperOptLoss: 以最大利润和最小损失为目标进行优化。hyperoptloss文件中的DRAWDOWN_MULT变量可以调整为更严格或更灵活的缩编目的。
