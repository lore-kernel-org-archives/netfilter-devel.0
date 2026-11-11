Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=188.68.63.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387094;
	b=SBfpimoEhl657xbYoYhUPNVXa78q3Z9kQ7l+3mJEueY95IQqeM1PiI1r204Q61izVIKk
	 I9nOY5E/hqpddQ+D7TsBAM/UJSDepnmosh/zt36IXmciREKBFbXNFjwFk45+ggnPIRfv7
	 qavE9zOnxPuV+Yw+v3De5noNVlztQIp4WUG2WdDxP9ePw7rcjHryEDU3u4XOkpHduwpTr
	 Mbf3M4CmgtFX1X4pYBHr8YSJiZSQ+MVSCD87uVqowXxyCBgFx7CGw2GPxjZUwlGCqfhj1
	 UNE6sjwYfR8W/wGhUIBwSEbKLmHDBx/NJ0hGMClFfFxdm2/EEIPj3VaMG7spuGoUiJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387094;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received-SPF:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-PPP-Message-ID:X-NC-CID;
	bh=/cXvrjxaxtiLwCTSR70YQw6p3gSt0zzRCwkzyB4NNMQ=;
	b=f3HvyvJmaVVXcON8UplQIiXo09a7oI7IJJeidC9CLpEgjpI/6xW+Jmboluj8fVtoD9vt
	 PzxZk7Xz4GSRUKjvkPiFk9TgnIjjCHls/Nx1zEXiDOHAH6q0ZrXnH+AdindoHEcld4M3K
	 7QuuWNMKbhCsAhY1eRp+3xUrgcs7szRqwXGJkeXfFuWzoSd+95lkLRXxe8qzpttDGLPTr
	 91ArPS6pFScnv0fm+eS2NmzLUde9vF5cZJZxxbDb3Mf9KRFCe68OY+yPJU/YyJAvebQuT
	 /S3HDKJmYczx+1LafhHw8YU8jIy+Yvc1YGSoXIDtUHjl4UzdiJQVUXWXsAen6sac1vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leemhuis.info;
	spf=pass smtp.mailfrom=leemhuis.info;
	dkim=pass header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=e6fA9fyt;
	arc=none smtp.remote-ip=188.68.63.174
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24576606A31C;
	Wed, 11 Nov 2026 08:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24576606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=e6fA9fyt
Received: from mors-relay8204.netcup.net (localhost [127.0.0.1])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4jPcgS60xgz8ktM;
	Wed, 11 Nov 2026 08:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1794387060;
	bh=+m6MXRy6xcls6uK9v/6CjaI8XNi4BpSqrQa6quN16Rw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e6fA9fyt8iR8tgyKP4noOtnHdIJCj/Ea+ZN9oHoxVgF8b+4T/iYqjfbOuoxcZEtIe
	 izsMiZdwP13HKLENGJRW6h6WT139/XPzoc/wdVJjLJ5dxMUViobfUUCEhht8oIAXIN
	 ybfMPyO0SrvyO8rTmAoMn+ss+9pvXfcjKjCKcYZWPVXRzC7Qa+UzpwpgsNI7ULX5a4
	 +M2nrY2TYwqQLSVYypfXPdf5JduXCxj/xg0eberVdjwUun9RNPCwjlX52MbYKpjVCA
	 9CZ1rxYeRvp54BbIurLG/6+1lTDv7Bou7xi3cbp9ltv1qG9NpCodi7qJLk57r433Q4
	 wA3rP/RgZ3eXQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4jPcfK1NqYz8gtl;
	Wed, 11 Nov 2026 08:50:01 +0000 (UTC)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4jPcfJ2QgLz8svZ;
	Wed, 11 Nov 2026 09:50:00 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 6B7E65FA05;
	Wed, 11 Nov 2026 09:49:48 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <f58b7e7c-1160-4728-bade-e73bd794940f@leemhuis.info>
Date: Wed, 11 Nov 2026 09:49:46 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] netfilter: flowtable: XMIT_NEIGH flows sent to
 00:00:00:00:00:00 once the next hop's neighbour entry is gone
To: John <shffr@protonmail.com>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "coreteam@netfilter.org"
 <coreteam@netfilter.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: 
 <MAEpYNlWKRd7lM0j62YlEZ97Ux1h5AyjSuFRm4Lxk2Q6haeDGTKqX8lpDRZ8slvBu6qA7Bbt18zpr9fyF_jArrEemTgRqzqluxmsGH7UcFk=@protonmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <MAEpYNlWKRd7lM0j62YlEZ97Ux1h5AyjSuFRm4Lxk2Q6haeDGTKqX8lpDRZ8slvBu6qA7Bbt18zpr9fyF_jArrEemTgRqzqluxmsGH7UcFk=@protonmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <179438698886.595945.14822771298955473457@mxe9fb.netcup.net>
X-NC-CID: awbssBF2p47zCo4FOS8C6qe2DLm+TCwf/FyGvLCghZdvGQKIvdM=

On 11/9/26 22:26, John wrote:
> 
> Since commit b5964aac51e0 ("netfilter: flowtable:
> consolidate xmit path"),

This is a 6.19 commit, but you later talk about 6.18 and only briefly
mention 7.4-rc. So where do you actually see this bug? If 6.18.y, please
also state if 7.4-rc2 or later has the same problem (everything needs to
be fixed in mainline first, so focusing on it is usually best).

And is this maybe the same issue as this:

network flow offloading broken in 6.18.45+
https://lore.kernel.org/all/7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de/t/#u

If not: that was just one of the hits I found when searching for the
commit id, you might want to check if the others provide something
helpful: https://lore.kernel.org/all/?q=b5964aac5*

Ciao, Thorsten

> a flow offloaded with
> FLOW_OFFLOAD_XMIT_NEIGH keeps being forwarded with
> destination MAC 00:00:00:00:00:00 after the next hop's
> neighbour entry has been removed. Nothing resolves the next
> hop again, so the flow stays black-holed for as long as it
> keeps sending.
> 
> Before that commit the XMIT_NEIGH case called neigh_xmit(),
> which creates the entry if needed, sends a solicitation and
> queues the packet. Now nf_flow_offload_ipv6_hook() does
> 
> 	neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(...));
> 	if (IS_ERR(neigh)) { ... }
> 	xmit.dest = neigh->ha;
> 
> and passes the skb to dev_queue_xmit() through
> nf_flow_queue_xmit(), without looking at neigh->nud_state.
> When ip_neigh_gw6() has just created the entry, ha is all
> zeros, and since the neighbour output path is never used, no
> solicitation goes out and the entry stays unresolved. The
> IPv4 branch has the same construction with ip_neigh_gw4().
> In v7.4-rc2 the code has moved into the per-family xmit
> functions but is otherwise unchanged.
> 
> This hit a router here running 6.18.60, which has
> b5964aac51e0 as a stable backport. A WireGuard endpoint
> behind the router talks to nothing else through it, so its
> neighbour entry on the router aged out while the tunnel's
> flow was offloaded, and the endpoint's handshake retries
> every 5 s kept the flow alive. On the router's egress
> interface every forwarded packet of the flow then looked
> like this (addresses replaced):
> 
>   02:0e:bd:92:63:28 > 00:00:00:00:00:00,
>   ethertype IPv6 (0x86dd), length 154:
>   2001:db8:1::51.60161 > 2001:db8:2::1f.59320:
>   UDP, length 92
> 
> "ip -6 neigh" had no entry for the destination, conntrack
> showed the flow as [OFFLOAD], and deleting the conntrack
> entry restored the tunnel until the next time the entry aged
> out, a few minutes later. Going back to 6.12.115 on the same
> router fixed it.
> 
> The script below reproduces it with three network namespaces
> and no special hardware (IPv6 only, needs iproute2, nft and
> python3). The server has a permanent entry for the router,
> so the router only knows the server from its own resolution.
> The flow is offloaded while the router has no valid entry
> for the server, which gives XMIT_NEIGH, and once it is
> offloaded the script removes the router's entry again, which
> is what neighbour GC does to an idle STALE entry.
> 
> 6.18.60:
> 
>   flow: [OFFLOAD]
>   entry: fd00:2::2 lladdr a2:5b:b4:93:86:a9 REACHABLE
>   entry removed, flow offloaded
>   2 s later:
>   echoes: 7 ok, 11 lost
>   destination MAC of echoes to the server:
>        10 00:00:00:00:00:00
>         7 a2:5b:b4:93:86:a9
> 
> 6.12.116 (Debian 6.12.116+deb13):
> 
>   flow: [OFFLOAD]
>   entry: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
>   entry removed, flow offloaded
>   2 s later: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
>   echoes: 17 ok, 1 lost
>   destination MAC of echoes to the server:
>        18 de:9b:d1:db:19:4c
> 
> (Datagram 0 is lost on both kernels, during start-up.)
> 
> I have not run the reproducer on mainline. I compared the
> code in v7.4-rc2 instead, and the IPv4 path is untested.
> 
> I don't know this code well enough to say which fix you
> would want. Handing the packet to neigh_xmit() when the
> entry is not NUD_VALID would restore the old behaviour for
> that case, and tearing the flow down would also work, since
> the next packet would then take the classic path and resolve
> the neighbour. I can test a patch on the router or with the
> script.
> 
> #regzbot introduced: b5964aac51e0
> 
> --- reproducer ---
> 
> #!/bin/bash
> # Flowtable XMIT_NEIGH flow forwarded to 00:00:00:00:00:00
> # after the next hop's neighbour entry goes away. Needs
> # root, iproute2, nft and python3.
> #
> # Namespaces c (client), r (router with a flowtable) and s
> # (server). The server has a permanent entry for the
> # router, so it never solicits and the router only knows
> # the server from its own resolution. The flow is set up
> # before the flow-add rule exists, the router's entry for
> # the server is removed, and only then is the rule added:
> # the flow is offloaded while the next hop has no valid
> # entry, which gives XMIT_NEIGH. Once it is offloaded the
> # entry is removed again, as neighbour GC does with an
> # idle STALE entry.
> set -u
> P=ftrepro
> W=$(mktemp -d)
> E() { local ns=$1; shift; ip netns exec "$P-$ns" "$@"; }
> cleanup() {
>   for j in $(jobs -p); do kill "$j" 2>/dev/null; done
>   for n in c r s; do ip netns del "$P-$n" 2>/dev/null; done
>   rm -rf "$W"
> }
> trap cleanup EXIT
> trap 'exit 1' INT TERM
> 
> for n in c r s; do ip netns add "$P-$n"; done
> ip link add rc netns "$P-r" type veth \
>   peer name c0 netns "$P-c"
> ip link add rs netns "$P-r" type veth \
>   peer name s0 netns "$P-s"
> for n in c r s; do E $n ip link set lo up; done
> E c ip link set c0 up
> E r ip link set rc up
> E r ip link set rs up
> E s ip link set s0 up
> E c ip -6 addr add fd00:1::2/64 dev c0 nodad
> E r ip -6 addr add fd00:1::1/64 dev rc nodad
> E r ip -6 addr add fd00:2::1/64 dev rs nodad
> E s ip -6 addr add fd00:2::2/64 dev s0 nodad
> E c ip -6 route add default via fd00:1::1
> E s ip -6 route add default via fd00:2::1
> RMAC=$(E r cat /sys/class/net/rs/address)
> E s ip -6 neigh replace fd00:2::1 lladdr "$RMAC" \
>   dev s0 nud permanent
> E r sysctl -qw net.ipv6.conf.all.forwarding=1
> E r nft -f - <<'NFT'
> table inet t {
>   flowtable f {
>     hook ingress priority 0; devices = { rc, rs };
>   }
>   chain fw {
>     type filter hook forward priority 0; policy accept;
>   }
> }
> NFT
> 
> # Client: UDP echo on port 6000.
> E c python3 -c '
> import socket
> s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
> s.bind(("fd00:1::2", 6000))
> while True:
>     d, a = s.recvfrom(100)
>     s.sendto(d, a)
> ' >/dev/null 2>&1 &
> 
> # Server side of the wire: destination MAC of every echo
> # coming back to the server.
> E s python3 -c '
> import socket, sys
> r = socket.socket(socket.AF_PACKET, socket.SOCK_RAW,
>                   socket.htons(3))
> r.bind(("s0", 0))
> f = open(sys.argv[1], "w")
> port = (5000).to_bytes(2, "big")
> while True:
>     p = r.recv(2048)
>     # IPv6, next header UDP, destination port 5000
>     if p[12:14] == b"\x86\xdd" and p[20] == 17 \
>             and p[56:58] == port:
>         f.write(p[0:6].hex(":") + "\n")
>         f.flush()
> ' "$W/wire.log" >/dev/null 2>&1 &
> sleep 1
> 
> # Server: one datagram a second to the client, port 5000.
> E s python3 -c '
> import socket, time, sys
> c = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
> c.bind(("fd00:2::2", 5000))
> c.settimeout(0.8)
> f = open(sys.argv[1], "w")
> for i in range(18):
>     t = time.time()
>     c.sendto(str(i).encode(), ("fd00:1::2", 6000))
>     try:
>         c.recvfrom(100)
>         f.write("%d ok\n" % i)
>     except socket.timeout:
>         f.write("%d lost\n" % i)
>     f.flush()
>     time.sleep(max(0, 1.0 - (time.time() - t)))
> ' "$W/server.log" >/dev/null 2>&1 &
> SV=$!
> 
> sleep 4
> E r ip -6 neigh del fd00:2::2 dev rs
> E r nft add rule inet t fw ct state established \
>   meta l4proto udp flow add @f
> sleep 3
> FLOW=$(E r grep -o '\[OFFLOAD\]' /proc/net/nf_conntrack |
>   head -1)
> echo "flow: $FLOW"
> echo "entry: $(E r ip -6 neigh show fd00:2::2 dev rs)"
> E r ip -6 neigh del fd00:2::2 dev rs &&
>   echo "entry removed, flow offloaded"
> sleep 2
> echo "2 s later: $(E r ip -6 neigh show fd00:2::2 dev rs)"
> wait $SV
> echo "echoes: $(grep -c ok "$W/server.log") ok," \
>   "$(grep -c lost "$W/server.log") lost"
> echo "destination MAC of echoes to the server:"
> sort "$W/wire.log" | uniq -c
> 
> Thanks,
> John

