FROM analogj/lexicon:latest

VOLUME /data

ENV PROVIDER=namecheap

ENV PROVIDER_UPDATE_DELAY=300

COPY config /srv/dehydrated/

RUN pip install dns-lexicon[namecheap]

CMD bash /srv/dehydrated/dehydrated --cron
