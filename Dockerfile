FROM analogj/lexicon:latest

COPY config /srv/dehydrated/

VOLUME /data

RUN pip install dns-lexicon[namecheap]

CMD bash /srv/dehydrated/dehydrated --cron
