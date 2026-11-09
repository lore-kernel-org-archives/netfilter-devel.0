Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794259625;
	b=Z5HT6W1KfikdiflwONwdP5ZBPEWT/Opn+sc8VtOE3kBeIGJkAKLnhVZHK/MXI+IRNq3k
	 8fY8wK0jlpB3PXKivQftslG5p2ErTCFkCs1MgPhvg6MBi1o1RPy9+3yObORbQ5mTmS6Mr
	 9F/lAPwl8lDTMW1ctZJ71sMOCO8r6NmAM1tcsxbr0cHa4X2wxoASgEQZ9CnE4tReiuZR3
	 WM/jxMYhS46o+6ObVqTJfL9s0jkSi1BJsaKcRM8GvVfeBzasOxQHGutuiQwck4bf/CfbX
	 gG5PIlgDHUbcSnfmQpoVptTywAvXFUoOvFX0C3I/ZLeY44PYhuVbcRstGmlp4qHaXug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794259625;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=TWfUart03l56VPYm6PEOMJTSBMEYCU2q173Onlmc8KE=;
	b=vJ603berV2TroNJUXtSQDshXcOSxUvyDhpq/CkmeXsgdPfsS0Wr3Vh07YiaHyPieFu6F
	 5Z9JnBYs4AxE3X0H0+/bTOzW9ZwsfBr04SYFRiE8tr1aRwzVIJ9Qn+iYxpSGHWJjFTyN/
	 lLoJ+PGz+5KzoKn/Fd/Urnalc3DSLmCNSL+vhvuEDBOvKgzzHe0IaG09ZomzHsiKtiRYo
	 k70Id+Vit8wERw53T5JZ8Vtow668BjHIWcK/j81JIF+XSPCer/y05tQong7G03SOjEcfN
	 t0seCR+9cD/DXKYueG+c+A+L3Wzg4AosXlbd79h0VzhFfU5W4GfmQYxC9RYLNSq1JzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=UPjFd2rU;
	arc=none smtp.remote-ip=79.135.106.101
Received: from mail-106101.protonmail.ch (mail-106101.protonmail.ch [79.135.106.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ABC606A321
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 21:27:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4ABC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=UPjFd2rU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1794259621; x=1794518821;
	bh=TWfUart03l56VPYm6PEOMJTSBMEYCU2q173Onlmc8KE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=UPjFd2rUHS2ISPEyx5ZIiXMUo3P14IW1yHuo8ARGT7LdLOj5sPtnF2RuHWZK7nelh
	 M3NPjSjaqqU2CiQGTM/S3x23/eNsY3IZQdWRnJITkuJyBW+eU2fWhs4VOoiLxQy83u
	 3vhvs7QcUta3qmZEZ2kCHvP0ELszgv92QpYMJDaZWWxmhhDCb/ozE3QbVGrGqNrRHi
	 XR56Dbggfga3h75gWMPUURLxJyVK+w2mqQhq9Rivc5N8kmoyo+38UuzkJJYEABTZGE
	 LANyVGuLxIBW7pc1T11ionNTT0TRgt03Zq6LRI3HGTICxu1d27qKwWDRAg9pFdx2x1
	 LIRDIFEBdEo7Q==
Date: Mon, 09 Nov 2026 21:26:55 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: John <shffr@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "coreteam@netfilter.org" <coreteam@netfilter.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: [REGRESSION] netfilter: flowtable: XMIT_NEIGH flows sent to 00:00:00:00:00:00 once the next hop's neighbour entry is gone
Message-ID: <MAEpYNlWKRd7lM0j62YlEZ97Ux1h5AyjSuFRm4Lxk2Q6haeDGTKqX8lpDRZ8slvBu6qA7Bbt18zpr9fyF_jArrEemTgRqzqluxmsGH7UcFk=@protonmail.com>
Feedback-ID: 9232920:user:proton
X-Pm-Message-ID: 89aa4064441d68e5335e520866a766b6fe40e168
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Since commit b5964aac51e0 ("netfilter: flowtable:
consolidate xmit path"), a flow offloaded with
FLOW_OFFLOAD_XMIT_NEIGH keeps being forwarded with
destination MAC 00:00:00:00:00:00 after the next hop's
neighbour entry has been removed. Nothing resolves the next
hop again, so the flow stays black-holed for as long as it
keeps sending.

Before that commit the XMIT_NEIGH case called neigh_xmit(),
which creates the entry if needed, sends a solicitation and
queues the packet. Now nf_flow_offload_ipv6_hook() does

=09neigh =3D ip_neigh_gw6(rt->dst.dev, rt6_nexthop(...));
=09if (IS_ERR(neigh)) { ... }
=09xmit.dest =3D neigh->ha;

and passes the skb to dev_queue_xmit() through
nf_flow_queue_xmit(), without looking at neigh->nud_state.
When ip_neigh_gw6() has just created the entry, ha is all
zeros, and since the neighbour output path is never used, no
solicitation goes out and the entry stays unresolved. The
IPv4 branch has the same construction with ip_neigh_gw4().
In v7.4-rc2 the code has moved into the per-family xmit
functions but is otherwise unchanged.

This hit a router here running 6.18.60, which has
b5964aac51e0 as a stable backport. A WireGuard endpoint
behind the router talks to nothing else through it, so its
neighbour entry on the router aged out while the tunnel's
flow was offloaded, and the endpoint's handshake retries
every 5 s kept the flow alive. On the router's egress
interface every forwarded packet of the flow then looked
like this (addresses replaced):

  02:0e:bd:92:63:28 > 00:00:00:00:00:00,
  ethertype IPv6 (0x86dd), length 154:
  2001:db8:1::51.60161 > 2001:db8:2::1f.59320:
  UDP, length 92

"ip -6 neigh" had no entry for the destination, conntrack
showed the flow as [OFFLOAD], and deleting the conntrack
entry restored the tunnel until the next time the entry aged
out, a few minutes later. Going back to 6.12.115 on the same
router fixed it.

The script below reproduces it with three network namespaces
and no special hardware (IPv6 only, needs iproute2, nft and
python3). The server has a permanent entry for the router,
so the router only knows the server from its own resolution.
The flow is offloaded while the router has no valid entry
for the server, which gives XMIT_NEIGH, and once it is
offloaded the script removes the router's entry again, which
is what neighbour GC does to an idle STALE entry.

6.18.60:

  flow: [OFFLOAD]
  entry: fd00:2::2 lladdr a2:5b:b4:93:86:a9 REACHABLE
  entry removed, flow offloaded
  2 s later:
  echoes: 7 ok, 11 lost
  destination MAC of echoes to the server:
       10 00:00:00:00:00:00
        7 a2:5b:b4:93:86:a9

6.12.116 (Debian 6.12.116+deb13):

  flow: [OFFLOAD]
  entry: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
  entry removed, flow offloaded
  2 s later: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
  echoes: 17 ok, 1 lost
  destination MAC of echoes to the server:
       18 de:9b:d1:db:19:4c

(Datagram 0 is lost on both kernels, during start-up.)

I have not run the reproducer on mainline. I compared the
code in v7.4-rc2 instead, and the IPv4 path is untested.

I don't know this code well enough to say which fix you
would want. Handing the packet to neigh_xmit() when the
entry is not NUD_VALID would restore the old behaviour for
that case, and tearing the flow down would also work, since
the next packet would then take the classic path and resolve
the neighbour. I can test a patch on the router or with the
script.

#regzbot introduced: b5964aac51e0

--- reproducer ---

#!/bin/bash
# Flowtable XMIT_NEIGH flow forwarded to 00:00:00:00:00:00
# after the next hop's neighbour entry goes away. Needs
# root, iproute2, nft and python3.
#
# Namespaces c (client), r (router with a flowtable) and s
# (server). The server has a permanent entry for the
# router, so it never solicits and the router only knows
# the server from its own resolution. The flow is set up
# before the flow-add rule exists, the router's entry for
# the server is removed, and only then is the rule added:
# the flow is offloaded while the next hop has no valid
# entry, which gives XMIT_NEIGH. Once it is offloaded the
# entry is removed again, as neighbour GC does with an
# idle STALE entry.
set -u
P=3Dftrepro
W=3D$(mktemp -d)
E() { local ns=3D$1; shift; ip netns exec "$P-$ns" "$@"; }
cleanup() {
  for j in $(jobs -p); do kill "$j" 2>/dev/null; done
  for n in c r s; do ip netns del "$P-$n" 2>/dev/null; done
  rm -rf "$W"
}
trap cleanup EXIT
trap 'exit 1' INT TERM

for n in c r s; do ip netns add "$P-$n"; done
ip link add rc netns "$P-r" type veth \
  peer name c0 netns "$P-c"
ip link add rs netns "$P-r" type veth \
  peer name s0 netns "$P-s"
for n in c r s; do E $n ip link set lo up; done
E c ip link set c0 up
E r ip link set rc up
E r ip link set rs up
E s ip link set s0 up
E c ip -6 addr add fd00:1::2/64 dev c0 nodad
E r ip -6 addr add fd00:1::1/64 dev rc nodad
E r ip -6 addr add fd00:2::1/64 dev rs nodad
E s ip -6 addr add fd00:2::2/64 dev s0 nodad
E c ip -6 route add default via fd00:1::1
E s ip -6 route add default via fd00:2::1
RMAC=3D$(E r cat /sys/class/net/rs/address)
E s ip -6 neigh replace fd00:2::1 lladdr "$RMAC" \
  dev s0 nud permanent
E r sysctl -qw net.ipv6.conf.all.forwarding=3D1
E r nft -f - <<'NFT'
table inet t {
  flowtable f {
    hook ingress priority 0; devices =3D { rc, rs };
  }
  chain fw {
    type filter hook forward priority 0; policy accept;
  }
}
NFT

# Client: UDP echo on port 6000.
E c python3 -c '
import socket
s =3D socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
s.bind(("fd00:1::2", 6000))
while True:
    d, a =3D s.recvfrom(100)
    s.sendto(d, a)
' >/dev/null 2>&1 &

# Server side of the wire: destination MAC of every echo
# coming back to the server.
E s python3 -c '
import socket, sys
r =3D socket.socket(socket.AF_PACKET, socket.SOCK_RAW,
                  socket.htons(3))
r.bind(("s0", 0))
f =3D open(sys.argv[1], "w")
port =3D (5000).to_bytes(2, "big")
while True:
    p =3D r.recv(2048)
    # IPv6, next header UDP, destination port 5000
    if p[12:14] =3D=3D b"\x86\xdd" and p[20] =3D=3D 17 \
            and p[56:58] =3D=3D port:
        f.write(p[0:6].hex(":") + "\n")
        f.flush()
' "$W/wire.log" >/dev/null 2>&1 &
sleep 1

# Server: one datagram a second to the client, port 5000.
E s python3 -c '
import socket, time, sys
c =3D socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
c.bind(("fd00:2::2", 5000))
c.settimeout(0.8)
f =3D open(sys.argv[1], "w")
for i in range(18):
    t =3D time.time()
    c.sendto(str(i).encode(), ("fd00:1::2", 6000))
    try:
        c.recvfrom(100)
        f.write("%d ok\n" % i)
    except socket.timeout:
        f.write("%d lost\n" % i)
    f.flush()
    time.sleep(max(0, 1.0 - (time.time() - t)))
' "$W/server.log" >/dev/null 2>&1 &
SV=3D$!

sleep 4
E r ip -6 neigh del fd00:2::2 dev rs
E r nft add rule inet t fw ct state established \
  meta l4proto udp flow add @f
sleep 3
FLOW=3D$(E r grep -o '\[OFFLOAD\]' /proc/net/nf_conntrack |
  head -1)
echo "flow: $FLOW"
echo "entry: $(E r ip -6 neigh show fd00:2::2 dev rs)"
E r ip -6 neigh del fd00:2::2 dev rs &&
  echo "entry removed, flow offloaded"
sleep 2
echo "2 s later: $(E r ip -6 neigh show fd00:2::2 dev rs)"
wait $SV
echo "echoes: $(grep -c ok "$W/server.log") ok," \
  "$(grep -c lost "$W/server.log") lost"
echo "destination MAC of echoes to the server:"
sort "$W/wire.log" | uniq -c

Thanks,
John

