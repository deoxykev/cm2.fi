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
#### HTTPS
- `ssh -R 8080:localhost:9999 cm2fi` will tunnel a service running on
  http://localhost:9999 to `https://x.cm2.fi` with SSL termination

#### TCP
- `ssh -R 4444:localhost:5555 cm2fi` will tunnel any raw TCP service running on
  locahost:5555 to `xx.cm2.fi:4444`

- Tip: you can chain multiple `-R` directives to tunnel multiple services at
  once.
> You'll need to set `AllowTcpForwarding` and `GatewayPorts` to `yes` in
> `/etc/ssh/sshd.conf` to use the raw 

#### UDP
- It's possible to tunnel UDP as well, but you'll need to convert UDP into TCP
  before tunneling

1. On local side:
```
socat -v UDP4-LISTEN:53,fork TCP4:localhost:5553
```
> 53 is the UDP port, 5553 is an arbritrary free TCP port


```
ssh -L 5553:localhost:5553 cm2fi
```
2. On remote side

```
socat -v TCP4-LISTEN:5553,fork UDP4-LISTEN:53
```

- If everything worked, you should be able to access the `udp://localhost:53` service on the
  local machine remotely at `udp://xx.cm2.fi:53`



