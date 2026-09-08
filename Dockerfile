FROM freqtradeorg/freqtrade:latest AS base

FROM base AS clone
USER root
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
USER ftuser
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/iterativv/NostalgiaForInfinity.git

FROM base AS build

USER root
RUN pip install --no-cache-dir pymysql pynacl
USER ftuser

COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/user_data/ /freqtrade/user_data/
COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/configs/recommended_config.json /freqtrade/user_data/config.json
COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/configs/trading_mode-futures.json /freqtrade/configs/trading_mode-futures.json
COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/configs/pairlist-volume-binance-usdt.json /freqtrade/configs/pairlist-volume-binance-usdt.json
COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/configs/blacklist-binance.json /freqtrade/configs/blacklist-binance.json
COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/configs/exampleconfig.json /freqtrade/configs/exampleconfig.json
COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/configs/exampleconfig_secret.json /freqtrade/configs/exampleconfig_secret.json
COPY --from=clone --chown=ftuser:ftuser /tmp/NostalgiaForInfinity/NostalgiaForInfinityX8.py /freqtrade/NostalgiaForInfinityX8.py
