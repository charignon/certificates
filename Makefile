.PHONY: new renew upload download
ENDPOINT=--endpoint-url https://nyc3.digitaloceanspaces.com
AWS=aws ${ENDPOINT}
LEGO=lego --accept-tos --email contact@foobar.com --dns digitalocean
S3_PATH="s3://domain-certificates/acme"
LOCAL_PATH=${PWD}/.lego
DOMAINS=`ls .lego/certificates | grep key | sed "s/.key$$//"`

new:
	@$(if ${DOMAIN}, echo "Setting up ${DOMAIN}", echo "Please set DOMAIN env var" ; exit 1 )
	${LEGO} -d ${DOMAIN} run

renew:
	@echo "Renewing ${DOMAINS}"
	@for d in ${DOMAINS};do ${LEGO} -d $$d renew --days 30 ; done

upload:
	@echo "uploading"
	${AWS} s3 sync ${LOCAL_PATH} ${S3_PATH}

download:
	@echo "Download"
	${AWS} s3 sync ${S3_PATH} ${LOCAL_PATH}
