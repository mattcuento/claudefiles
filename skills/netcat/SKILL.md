---
name: netcat
description: Use when working with TCP/UDP connections, building client/server communication, transferring data over sockets, port scanning, or testing network daemons using the nc (netcat) command on macOS.
---

# netcat (nc)

## Overview

`nc` opens TCP/UDP connections, listens on arbitrary ports, transfers data, and scans ports. It bridges stdin/stdout to the network, making it scriptable for any protocol interaction.

## Quick Reference

| Task | Command |
|------|---------|
| Listen on port | `nc -l <port>` |
| Connect to host | `nc <host> <port>` |
| Listen, keep alive | `nc -kl <port>` |
| UDP mode | `nc -u <host> <port>` |
| Port scan range | `nc -z <host> <port-range>` |
| Set connect timeout | `nc -w <secs> <host> <port>` |
| No DNS lookup | `nc -n <host> <port>` |
| Verbose output | `nc -v <host> <port>` |
| Unix domain socket | `nc -lU /path/to/socket` |

## Core Patterns

### Client/Server (interactive pipe)

Terminal 1 (server):
```bash
nc -l 1234
```

Terminal 2 (client):
```bash
nc 127.0.0.1 1234
```

Anything typed on either end appears on the other. Terminate with `^D` (EOF).

### File Transfer

Receiver (runs first):
```bash
nc -l 1234 > received_file
```

Sender:
```bash
nc host.example.com 1234 < file_to_send
```

Connection closes automatically after EOF.

### Keep Listening for Multiple Connections

```bash
nc -kl 1234
```

`-k` keeps the listener alive after a client disconnects. Requires `-l`.

### Talking to Protocols by Hand

HTTP:
```bash
echo -n "GET / HTTP/1.0\r\n\r\n" | nc host.example.com 80
```

SMTP:
```bash
nc localhost 25 << EOF
HELO host.example.com
MAIL FROM: <user@host.example.com>
RCPT TO: <dest@host.example.com>
DATA
Body here.
.
QUIT
EOF
```

### Port Scanning

```bash
nc -z host.example.com 20-30
```

Banner grabbing (with timeout):
```bash
nc -w 3 host.example.com 22
```

### Via Proxy

```bash
nc -x 10.2.3.4:8080 -X connect host.example.com 443
```

`-X` protocols: `4` (SOCKS v4), `5` (SOCKS v5, default), `connect` (HTTPS proxy).

## Key Flags

| Flag | Meaning |
|------|---------|
| `-l` | Listen mode (server). Incompatible with `-p`, `-s`, `-z`. |
| `-k` | Keep listening after connection ends. Requires `-l`. |
| `-u` | UDP instead of TCP. |
| `-v` | Verbose (connection status). |
| `-n` | Skip DNS — use raw IPs. Faster, no resolver dependency. |
| `-w <sec>` | Idle timeout in seconds. No effect with `-l`. |
| `-p <port>` | Specify local source port. Incompatible with `-l`. |
| `-s <ip>` | Bind to specific local IP. Incompatible with `-l`. |
| `-z` | Scan only (no data). Incompatible with `-l`. |
| `-4` / `-6` | Force IPv4 / IPv6. |
| `-U` | Unix domain socket mode. |
| `-c` | Send CRLF as line endings (useful for HTTP/SMTP). |

## Caveats

- UDP port scans (`-uz`) always report open — not reliable.
- `-w` timeout is ignored in listen mode.
- Port ranges use `nn-mm` format (e.g., `20-30`).
