# Kindle Crosswords

Get crosswords freshly delivered to your [Amazon Scribe][1] every morning.

Currently supported

- [The Guardian Cryptic Crossword][2]
- [The Guardian Quick Crossword][3]

Amazon doesn't offer an API for the Kindle Scribe so this uses Amazon's [Send
to Email][4] feature.

## Prequisites

- [aws-cli][5] and an SES sending domain configured
- [jq][6]
- [texlive-core][7] which provides `pdfcrop`
- [ghostcript][8]

## Installation

- Copy `kindle-crossword.sh` to `/usr/local/bin/` and make it executable.
- Install the systemd service and timer scripts.

## Configuration

Edit the shell variables to your liking at the top of the script.

## TODO

- Maybe move this to a lambda function

[1]: https://www.amazon.com/Essentials-including-Premium-Leather-Magnetic/dp/B0BG1GBK1P/
[2]: https://www.theguardian.com/crosswords/series/cryptic
[3]: https://www.theguardian.com/crosswords/series/quick
[4]: https://www.amazon.co.uk/gp/help/customer/display.html?nodeId=G7NECT4B4ZWHQ8WV
[5]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
[6]: https://stedolan.github.io/jq/
[7]: https://archlinux.org/packages/extra/any/texlive-core/
[8]: https://archlinux.org/packages/extra/x86_64/ghostscript/
