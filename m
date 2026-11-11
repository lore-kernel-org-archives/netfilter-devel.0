Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794434952;
	b=Q96ETIagd/eBZl630CuBLdBCTAWoB82DIwkL26HsMHdSO/lUC/wMhM8lq6TCgA9SNxum
	 ybGdG6Fk00FDcVanxTXIwZh18VoBe+WShJPoqVYr6uoJyub6S+QlYEUOCb+Kx1adwDcEd
	 IFIJMBFAncbcVbTo4f2pT+l8h8Q5XXRVoxYK33V8IqB+8NSWAcg7P7H8davlEyPxr0AN2
	 Ayxe+haNY/qrgkBriLFowzjGLykyTsaBeiCoXODGDRDGvWIs3yODAGWzfAq/ZJR5UC+sO
	 9GfkYYtSqtUdM7GezkwaEpm7pDbbRmlYVjAmPMV4BCv8URjNq1LHDAmcC67jtRRSqfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794434952;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=am6gB5NdWXXZW/etXsOg3KYf+73ebZ11VyaFMSvoC9Y=;
	b=AH+3mi0drukOq8oVOVD0EVe1TkTSNNsFUM6lxU7TMg8UiGTXuDhb3+22kmRD9t+lan+T
	 hdZvnv3b082K8hQxbI5ZHO30gOlU0jmmb2GsHt9MFkZjmufDW8N/MjNLEaAS8q89N+ufA
	 hvDnmlVX8h/fIVVIW7FJPgTxywuMsEUMMj2bI+7x/+Hjac6R706Eew63e1DpBOzDb7WPP
	 bcrj1BNMH35YS+8XHFsTSaAanp1tUBUCABH2BGQSP/i7kAPFppLlNXU62OtillCe8BqPn
	 jsQ52pCGgv8De3dnhp7wsWd5NxSdDwrNBU8SxcDMpiFwa/qHPd23g46RmZ9DzhY31Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ga1RZDqB;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B5FD6606A321;
	Wed, 11 Nov 2026 22:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5FD6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ga1RZDqB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794434948;
	bh=am6gB5NdWXXZW/etXsOg3KYf+73ebZ11VyaFMSvoC9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ga1RZDqBCfh9F7lsHrh434WKtLNlqDdE3hiw7ReTJ7O6x6pbJWZP7eo9tPad4fOSH
	 cqoKF07i0Vfm/9sJ+jGyC/HxBDIekJ9F3w52TrHEQ/f07sQxJACnEPFK1uTIcWBJCt
	 pI+Z0z0mWQIFlqmZGVgtLrhduQLggrPcEdtPa3X6wEBmFPz+FMpj7hnYNK1K6Du3EY
	 V7d7MIYbyGhyfHxhzK+cyGjEi0pwWAU0TlEBlFKZOJ8OCVnRmZf/xcRyLZyFw0i36l
	 IfKT7xkqpT2Xln3qfSIh2C4v4htWYQWlLPOFBk3ZSr5NDqLXuQbXpil6TOxGyUUlg+
	 kJz4WrbtylJfQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 85CC060074;
	Wed, 11 Nov 2026 23:09:08 +0100 (CET)
Date: Wed, 11 Nov 2026 23:09:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: John <shffr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] netfilter: flowtable: XMIT_NEIGH flows sent to
 00:00:00:00:00:00 once the next hop's neighbour entry is gone
Message-ID: <avTngTkNKE5ApQW8@chamomile>
References: <MAEpYNlWKRd7lM0j62YlEZ97Ux1h5AyjSuFRm4Lxk2Q6haeDGTKqX8lpDRZ8slvBu6qA7Bbt18zpr9fyF_jArrEemTgRqzqluxmsGH7UcFk=@protonmail.com>
 <avSIBUcLH4kZyISX@chamomile>
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
Content-Disposition: inline
In-Reply-To: <avSIBUcLH4kZyISX@chamomile>

On Wed, Nov 11, 2026 at 04:21:44PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> Would you give a try to this attached patch?

I forgot you provided a reproducer, I can see one packet is lost after
this patch, then the follow up packets don't get blockholed.

Let me revisit this again.

> Thanks.
> 
> On Mon, Nov 09, 2026 at 09:26:55PM +0000, John wrote:
> > Hi,
> > 
> > Since commit b5964aac51e0 ("netfilter: flowtable:
> > consolidate xmit path"), a flow offloaded with
> > FLOW_OFFLOAD_XMIT_NEIGH keeps being forwarded with
> > destination MAC 00:00:00:00:00:00 after the next hop's
> > neighbour entry has been removed. Nothing resolves the next
> > hop again, so the flow stays black-holed for as long as it
> > keeps sending.
> > 
> > Before that commit the XMIT_NEIGH case called neigh_xmit(),
> > which creates the entry if needed, sends a solicitation and
> > queues the packet. Now nf_flow_offload_ipv6_hook() does
> > 
> > 	neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(...));
> > 	if (IS_ERR(neigh)) { ... }
> > 	xmit.dest = neigh->ha;
> > 
> > and passes the skb to dev_queue_xmit() through
> > nf_flow_queue_xmit(), without looking at neigh->nud_state.
> > When ip_neigh_gw6() has just created the entry, ha is all
> > zeros, and since the neighbour output path is never used, no
> > solicitation goes out and the entry stays unresolved. The
> > IPv4 branch has the same construction with ip_neigh_gw4().
> > In v7.4-rc2 the code has moved into the per-family xmit
> > functions but is otherwise unchanged.
> > 
> > This hit a router here running 6.18.60, which has
> > b5964aac51e0 as a stable backport. A WireGuard endpoint
> > behind the router talks to nothing else through it, so its
> > neighbour entry on the router aged out while the tunnel's
> > flow was offloaded, and the endpoint's handshake retries
> > every 5 s kept the flow alive. On the router's egress
> > interface every forwarded packet of the flow then looked
> > like this (addresses replaced):
> > 
> >   02:0e:bd:92:63:28 > 00:00:00:00:00:00,
> >   ethertype IPv6 (0x86dd), length 154:
> >   2001:db8:1::51.60161 > 2001:db8:2::1f.59320:
> >   UDP, length 92
> > 
> > "ip -6 neigh" had no entry for the destination, conntrack
> > showed the flow as [OFFLOAD], and deleting the conntrack
> > entry restored the tunnel until the next time the entry aged
> > out, a few minutes later. Going back to 6.12.115 on the same
> > router fixed it.
> > 
> > The script below reproduces it with three network namespaces
> > and no special hardware (IPv6 only, needs iproute2, nft and
> > python3). The server has a permanent entry for the router,
> > so the router only knows the server from its own resolution.
> > The flow is offloaded while the router has no valid entry
> > for the server, which gives XMIT_NEIGH, and once it is
> > offloaded the script removes the router's entry again, which
> > is what neighbour GC does to an idle STALE entry.
> > 
> > 6.18.60:
> > 
> >   flow: [OFFLOAD]
> >   entry: fd00:2::2 lladdr a2:5b:b4:93:86:a9 REACHABLE
> >   entry removed, flow offloaded
> >   2 s later:
> >   echoes: 7 ok, 11 lost
> >   destination MAC of echoes to the server:
> >        10 00:00:00:00:00:00
> >         7 a2:5b:b4:93:86:a9
> > 
> > 6.12.116 (Debian 6.12.116+deb13):
> > 
> >   flow: [OFFLOAD]
> >   entry: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
> >   entry removed, flow offloaded
> >   2 s later: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
> >   echoes: 17 ok, 1 lost
> >   destination MAC of echoes to the server:
> >        18 de:9b:d1:db:19:4c
> > 
> > (Datagram 0 is lost on both kernels, during start-up.)
> > 
> > I have not run the reproducer on mainline. I compared the
> > code in v7.4-rc2 instead, and the IPv4 path is untested.
> > 
> > I don't know this code well enough to say which fix you
> > would want. Handing the packet to neigh_xmit() when the
> > entry is not NUD_VALID would restore the old behaviour for
> > that case, and tearing the flow down would also work, since
> > the next packet would then take the classic path and resolve
> > the neighbour. I can test a patch on the router or with the
> > script.
> > 
> > #regzbot introduced: b5964aac51e0
> > 
> > --- reproducer ---
> > 
> > #!/bin/bash
> > # Flowtable XMIT_NEIGH flow forwarded to 00:00:00:00:00:00
> > # after the next hop's neighbour entry goes away. Needs
> > # root, iproute2, nft and python3.
> > #
> > # Namespaces c (client), r (router with a flowtable) and s
> > # (server). The server has a permanent entry for the
> > # router, so it never solicits and the router only knows
> > # the server from its own resolution. The flow is set up
> > # before the flow-add rule exists, the router's entry for
> > # the server is removed, and only then is the rule added:
> > # the flow is offloaded while the next hop has no valid
> > # entry, which gives XMIT_NEIGH. Once it is offloaded the
> > # entry is removed again, as neighbour GC does with an
> > # idle STALE entry.
> > set -u
> > P=ftrepro
> > W=$(mktemp -d)
> > E() { local ns=$1; shift; ip netns exec "$P-$ns" "$@"; }
> > cleanup() {
> >   for j in $(jobs -p); do kill "$j" 2>/dev/null; done
> >   for n in c r s; do ip netns del "$P-$n" 2>/dev/null; done
> >   rm -rf "$W"
> > }
> > trap cleanup EXIT
> > trap 'exit 1' INT TERM
> > 
> > for n in c r s; do ip netns add "$P-$n"; done
> > ip link add rc netns "$P-r" type veth \
> >   peer name c0 netns "$P-c"
> > ip link add rs netns "$P-r" type veth \
> >   peer name s0 netns "$P-s"
> > for n in c r s; do E $n ip link set lo up; done
> > E c ip link set c0 up
> > E r ip link set rc up
> > E r ip link set rs up
> > E s ip link set s0 up
> > E c ip -6 addr add fd00:1::2/64 dev c0 nodad
> > E r ip -6 addr add fd00:1::1/64 dev rc nodad
> > E r ip -6 addr add fd00:2::1/64 dev rs nodad
> > E s ip -6 addr add fd00:2::2/64 dev s0 nodad
> > E c ip -6 route add default via fd00:1::1
> > E s ip -6 route add default via fd00:2::1
> > RMAC=$(E r cat /sys/class/net/rs/address)
> > E s ip -6 neigh replace fd00:2::1 lladdr "$RMAC" \
> >   dev s0 nud permanent
> > E r sysctl -qw net.ipv6.conf.all.forwarding=1
> > E r nft -f - <<'NFT'
> > table inet t {
> >   flowtable f {
> >     hook ingress priority 0; devices = { rc, rs };
> >   }
> >   chain fw {
> >     type filter hook forward priority 0; policy accept;
> >   }
> > }
> > NFT
> > 
> > # Client: UDP echo on port 6000.
> > E c python3 -c '
> > import socket
> > s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
> > s.bind(("fd00:1::2", 6000))
> > while True:
> >     d, a = s.recvfrom(100)
> >     s.sendto(d, a)
> > ' >/dev/null 2>&1 &
> > 
> > # Server side of the wire: destination MAC of every echo
> > # coming back to the server.
> > E s python3 -c '
> > import socket, sys
> > r = socket.socket(socket.AF_PACKET, socket.SOCK_RAW,
> >                   socket.htons(3))
> > r.bind(("s0", 0))
> > f = open(sys.argv[1], "w")
> > port = (5000).to_bytes(2, "big")
> > while True:
> >     p = r.recv(2048)
> >     # IPv6, next header UDP, destination port 5000
> >     if p[12:14] == b"\x86\xdd" and p[20] == 17 \
> >             and p[56:58] == port:
> >         f.write(p[0:6].hex(":") + "\n")
> >         f.flush()
> > ' "$W/wire.log" >/dev/null 2>&1 &
> > sleep 1
> > 
> > # Server: one datagram a second to the client, port 5000.
> > E s python3 -c '
> > import socket, time, sys
> > c = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
> > c.bind(("fd00:2::2", 5000))
> > c.settimeout(0.8)
> > f = open(sys.argv[1], "w")
> > for i in range(18):
> >     t = time.time()
> >     c.sendto(str(i).encode(), ("fd00:1::2", 6000))
> >     try:
> >         c.recvfrom(100)
> >         f.write("%d ok\n" % i)
> >     except socket.timeout:
> >         f.write("%d lost\n" % i)
> >     f.flush()
> >     time.sleep(max(0, 1.0 - (time.time() - t)))
> > ' "$W/server.log" >/dev/null 2>&1 &
> > SV=$!
> > 
> > sleep 4
> > E r ip -6 neigh del fd00:2::2 dev rs
> > E r nft add rule inet t fw ct state established \
> >   meta l4proto udp flow add @f
> > sleep 3
> > FLOW=$(E r grep -o '\[OFFLOAD\]' /proc/net/nf_conntrack |
> >   head -1)
> > echo "flow: $FLOW"
> > echo "entry: $(E r ip -6 neigh show fd00:2::2 dev rs)"
> > E r ip -6 neigh del fd00:2::2 dev rs &&
> >   echo "entry removed, flow offloaded"
> > sleep 2
> > echo "2 s later: $(E r ip -6 neigh show fd00:2::2 dev rs)"
> > wait $SV
> > echo "echoes: $(grep -c ok "$W/server.log") ok," \
> >   "$(grep -c lost "$W/server.log") lost"
> > echo "destination MAC of echoes to the server:"
> > sort "$W/wire.log" | uniq -c
> > 
> > Thanks,
> > John
> > 

> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 19cafae748ab..73f49dc41157 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -873,7 +873,8 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
>  			return NF_DROP;
>  		}
>  		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_addr->ip));
> -		if (IS_ERR(neigh)) {
> +		if (IS_ERR(neigh) ||
> +		    !(READ_ONCE(neigh->nud_state) & NUD_VALID)) {
>  			flow_offload_teardown(flow);
>  			return NF_DROP;
>  		}
> @@ -1202,7 +1203,8 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
>  			return NF_DROP;
>  		}
>  		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &ip_addr->in6));
> -		if (IS_ERR(neigh)) {
> +		if (IS_ERR(neigh) ||
> +		    !(READ_ONCE(neigh->nud_state) & NUD_VALID)) {
>  			flow_offload_teardown(flow);
>  			return NF_DROP;
>  		}

