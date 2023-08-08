# cm2.fi
Personal scripts / URL redirector service

## Usage
- Files in `shorturls/` should contain a URL.
  - for example, if `shorturls/test` contains `https://google.com`, then
    `https://cm2.fi/test` will 302 redirect to `https://google.com`.

- Any file placed in `public/` will be accessible in the root directory.
