FROM analogj/lexicon:latest

VOLUME /data

ENV PROVIDER=namecheap

ENV PROVIDER_UPDATE_DELAY=300

COPY config /srv/dehydrated/

RUN apt update \
    && apt install -y bsdmainutils \
    && apt-get clean \
    && pip install dns-lexicon[namecheap]

CMD bash /srv/dehydrated/dehydrated --cron
