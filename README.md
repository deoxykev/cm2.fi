# cm2.fi
- Personal scripts hosting
- URL redirector service (`cm2.fi/test`)
- http localhost ssh forwarding tunnel to `https://x.cm2.fi` with SSL

## Usage
- Files in `shorturls/` should contain a URL.
  - for example, if `shorturls/test` contains `https://google.com`, then
    `https://cm2.fi/test` will 302 redirect to `https://google.com`.

- Any file placed in `public/` will be accessible in the root directory.
