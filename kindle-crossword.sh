#!/usr/bin/env bash

set -o pipefail
DATE=$(date +%Y%m%d)
URL="https://crosswords-static.guim.co.uk"
QUICK="gdn.quick.$DATE.pdf"
CROPQUICK="gdn.quick.$DATE-crop.pdf"
CRYPTIC="gdn.cryptic.$DATE.pdf"
CROPCRYPTIC="gdn.cryptic.$DATE-crop.pdf"
FROM="your@fromaddress.com"
TO="your@kindleaddress.com"

# Send to Kindle

# Quick crosswords published Mon-Sat
if [ "$(date +%u)" -le 6 ]; then
	wget -q -P /tmp "$URL"/"$QUICK"
	pdfcrop --margins 10 /tmp/"$QUICK"
	BASE64_QUICK=$(base64 -w 0 /tmp/"$CROPQUICK")
	# Beware grim JSON wrangling ahead
	JSON_STRING=$(jq -n \
		--arg from "$FROM" \
		--arg to "$TO" \
		--arg date "$DATE" \
		--arg cropquick "$CROPQUICK" \
		--arg base64quick "$BASE64_QUICK" \
		'{Data: ("From:"+
  $from+
  "\nTo:"+
  $to+
  "\nSubject: Guardian Quick Crossword"+
  "\nMIME-Version: 1.0"+
  "\nContent-type: Multipart/Mixed; boundary=\"NextPart\""+
  "\n\n--NextPart\nContent-Type: text/plain"+
  "\n\nQuick Crossword for "+
  $date+
  "\n\n--NextPart\nContent-Type: application/pdf;"+
  "\nContent-Disposition: attachment; filename="+
  $cropquick+
  "\nContent-Transfer-Encoding: base64"+
  "\n\n"+
  $base64quick+
  "\n\n--NextPart--")}')
	echo "$JSON_STRING" >message.json

	aws ses send-raw-email --region eu-west-2 --cli-binary-format raw-in-base64-out --raw-message file://message.json
fi

# Cryptic crosswords published Mon-Fri
if [ "$(date +%u)" -le 5 ]; then
	wget -q -P /tmp "$URL"/"$CRYPTIC"
	pdfcrop --margins 10 /tmp/"$CRYPTIC"
	BASE64_CRYPTIC=$(base64 -w 0 /tmp/"$CROPCRYPTIC")
	# Beware grim JSON wrangling ahead
	JSON_STRING=$(jq -n \
		--arg from "$FROM" \
		--arg to "$TO" \
		--arg date "$DATE" \
		--arg cropcryptic "$CROPCRYPTIC" \
		--arg base64cryptic "$BASE64_CRYPTIC" \
		'{Data: ("From:"+
  $from+
  "\nTo:"+
  $to+
  "\nSubject: Guardian Cryptic Crossword"+
  "\nMIME-Version: 1.0"+
  "\nContent-type: Multipart/Mixed; boundary=\"NextPart\""+
  "\n\n--NextPart\nContent-Type: text/plain"+
  "\n\nCryptic Crossword for "+
  $date+
  "\n\n--NextPart\nContent-Type: application/pdf;"+
  "\nContent-Disposition: attachment; filename="+
  $cropcryptic+
  "\nContent-Transfer-Encoding: base64"+
  "\n\n"+
  $base64cryptic+
  "\n\n--NextPart--")}')
	echo "$JSON_STRING" >message.json
	aws ses send-raw-email --region eu-west-2 --cli-binary-format raw-in-base64-out --raw-message file://message.json
fi
