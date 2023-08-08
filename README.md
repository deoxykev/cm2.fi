# ㎠.ﬁ
- Personal script/files hosting
- World's shortest URL redirector service using IDN normalization at
  5 characters (`㎠.ﬁ/test`)
- http localhost ssh forwarding tunnel to `https://x.cm2.fi` with SSL

## Usage
### URL redirector
- Files in `shorturls/` should contain a URL.
  - for example, if `shorturls/test` contains `https://google.com`, then
    `https://cm2.fi/test` will 302 redirect to `https://google.com`.

### File hoster
- Any file placed in `public/` will be accessible in the root directory.

### Tunnel service
- `ssh -R 8080:localhost:9999 cm2fi` will tunnel a service running on
  http://localhost:9999 to `https://x.cm2.fi` with SSL termination

- `ssh -R 4444:localhost:5555 cm2fi` will tunnel any raw UDP or TCP service running on
  locahost:5555 to `xx.cm2.fi:4444`


