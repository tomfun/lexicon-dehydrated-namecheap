## lexicon-dehydrated-namecheap

Based on:
 - https://github.com/AnalogJ/lexicon
 - https://hub.docker.com/r/analogj/lexicon/
 - https://github.com/lukas2511/dehydrated
 - https://dehydrated.io/

## Why

> Some providers (like Route53 and TransIP) require additional dependencies. You can install provider specific dependencies separately

Also a small tuning inside and "sugar" outside

## What

Container to run certificate obtaining preconfigured to v2 endpoints and namecheap.
But technically you can use any provider. Just set env variables `PROVIDER` and auth related.

## Requirements
 - docker
 - namecheap API token & username

## Usage

Create 2 files, 1 of them bash for easy use *run.sh*:
```bash
#!/usr/bin/env bash
set -e

docker run --rm -it \
    -v ${PWD}:/data \
	-e EMAIL=user+test-acc-1@example.com \
	-e LEXICON_NAMECHEAP_USERNAME=example \
    -e LEXICON_NAMECHEAP_TOKEN=201927quien5Afei2vaem8choh0ooFah \
	tomfun/lexicon-dehydrated-namecheap:latest \
	$@
```

And `domains.txt` with domains:
```txt
*.example.com
www.tomfun.co demo.tomfun.co
```

### First time
Create account and accept terms
```bash
./run.sh /dehydrated --register --accept-terms
# Or
# ./test-run.sh /dehydrated --register --accept-terms
```

### See configs
Create account and accept terms
```bash
./run.sh /srv/dehydrated/dehydrated -e
# Or
# ./test-run.sh /srv/dehydrated/dehydrated -e
```

### Staging mode

`STAGING=true` means enable staging endpoint for CERTIFICATES, but not for namecheap
Create bash file for easy use like *run.sh* but with `-e STAGING=true \` in *test-run.sh* and use it
