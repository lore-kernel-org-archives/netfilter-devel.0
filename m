Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474515;
	b=tNJIHAMTy2+YCMiPcpuvbwPrfJqcBwU1c0q14gWNPKE2JwbTDnoiZNp/e0gDtLMa4k8a
	 kNZZVdQ5Aj4nu0bj3k68S+iNzfJ4ZOiqVvuW1hz6d6FgCAXvZpWn4BY7WRa+7m6saephd
	 bdysSyCWrGpSDeI8eVm/m0qtR/ZkCxCkkf9SG+xExXW4gLFzT1s6wgWottc0nz2Carnn0
	 AV+/FiZQ8mHCJgR3bSKi2SyJDnw6JF558URldTlP2lvRPkWtYWIfzt2JeOuep6J43Tq/8
	 4D5jGQadW5Gd7k51z2qSbfimTOYGEHTnEracMyHUnAVqATYe3kzIB3AzKg1eZJb7Mww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474515;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Ala9MWQu+4z68BZPcrMGazBvk1wxslpt7okio92DUeo=;
	b=nEK147sfRQ0GYPRHri+CgzgPDnOZSWYJnXIkS10xhQz6FglFWl7g5qGhwi/41hYwnX+9
	 WzrqiH9a9yA/LdgiKFX6wvCpivVqAweQcfibcSoXrBVp04JHzXsHRlBAFa+KPUXQ4fWxo
	 mwQ+1H+x2Dl6z+Jidp9YdlE/ilaWWX3X9NyJxZhtGCJ7+23u5v5Mt51YrxTa8RbKlQBMf
	 TG+nsSNHiG6VIYGcjRlOyudv84bEXgIDk2W5xk67jxx6YJwFtgbByVbiuDaESubC2YWK3
	 DkGXu1iSs0T+GDJcei6PQMqBA7hFWJnFnTYs/nMlsv3hhjA0a06Be7XBuAwZgJGbp0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=px47V+Ib;
	arc=none smtp.remote-ip=109.224.244.25
Received: from mail-24425.protonmail.ch (mail-24425.protonmail.ch [109.224.244.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92723606A8B9
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 09:08:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92723606A8B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=px47V+Ib
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1794474511; x=1794733711;
	bh=Ala9MWQu+4z68BZPcrMGazBvk1wxslpt7okio92DUeo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=px47V+IbFKEMejLQpnmt4nfAyBCZlltCcPmbRmXpYoXm51PR/QFfo6EQpR5sAQkHR
	 vkWtclKVYM7ok7Ja8vA+vw8SdmTO1qPLFUMn6rJYoN0+nHi9JmxEvhritLfdPdfupl
	 g9McCLuRxsn6l6VBWUcnpsYbt9z0Zc0cESKQBKFipcpWC1XAbpVTNoNTioirGDvhaT
	 5v8y8VAbJ8SOrtXARp0FJNgN+eqILaaAtsCWmbKu3iiqHoBjyvrosKDv0a+ObrnOXE
	 s2BmGTbEgaa1m38ecPpt0xwZPMxNT8Do+xw+g6dAtNMsEaCUH9z4DmBRhFnu3BuotT
	 lCvJwLS0PHEoA==
Date: Thu, 12 Nov 2026 09:08:27 +0000
To: Pablo Neira Ayuso <pablo@netfilter.org>
From: John <shffr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "coreteam@netfilter.org" <coreteam@netfilter.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] netfilter: flowtable: XMIT_NEIGH flows sent to 00:00:00:00:00:00 once the next hop's neighbour entry is gone
Message-ID: <LCJrB-Fde--T9NiYx2QfFb-X-9W-vsYYmtmrHwIKuKgM8enKRWF2DYypz2_zJKSKQBMUdb9sS6xMEfPihv1YO2FLjX1OUN-Td3Hq1eAdLgw=@protonmail.com>
In-Reply-To: <avTngTkNKE5ApQW8@chamomile>
References: <MAEpYNlWKRd7lM0j62YlEZ97Ux1h5AyjSuFRm4Lxk2Q6haeDGTKqX8lpDRZ8slvBu6qA7Bbt18zpr9fyF_jArrEemTgRqzqluxmsGH7UcFk=@protonmail.com> <avSIBUcLH4kZyISX@chamomile> <avTngTkNKE5ApQW8@chamomile>
Feedback-ID: 9232920:user:proton
X-Pm-Message-ID: 4a2ccb05631e1753db86d5225a72dabd5196ddbe
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

Hi Pablo, Thorsten,

Thorsten: I first saw this on 6.18.60 and have reproduced it on
6.18.62 and v7.4-rc2. 6.18.63 has the same nf_flow_table_ip.c.
b5964aac51e0 came into 6.18.y with 6.18.45, the release named in
the thread you linked.

Pablo: on 7.4-rc2 your patch stops the black hole, but as you
noticed, one packet is still lost each time the next hop's entry
goes away, which with neighbour GC happens about every 75 s on a
long-lived flow. 6.18.44, before b5964aac51e0, lost nothing in
the same tests. On 6.18.y the patch only works together with
871df5007eda.

I tested with the namespace setup from my first email. The
server sends UDP datagrams through the router to the client,
which echoes them back, and I count the echoes that never arrive.

  A: 18 datagrams at 1/s. The router's neighbour entry for the
     next hop is deleted by hand after the flow is offloaded.
  B: 150 datagrams, one every 2 s. Nothing is deleted by hand,
     so only neighbour GC can remove the entries (gc_thresh1=3D0
     so that GC runs on the small table).

Echoes lost (IPv4 gave the same results as IPv6, within one
packet):

                            A, of 18     B, of 150
  6.18.44                        0             0
  7.4-rc2                       10           115
  7.4-rc2 + patch                1             4
  6.18.62 + patch               10           118
  6.18.62 + 871df5007eda
          + patch                1             4

With the patch no frame went to 00:00:00:00:00:00 in any run, and
on 7.4-rc2 the flow was offloaded again about 2 s after the lost
packet. The four losses in B are one per GC cycle. The fast path
never refreshes the entry, so it goes STALE and GC removes it
while the flow is busy. On 6.18.44 the entries went from STALE
through PROBE back to REACHABLE and were never deleted, and in A
the deleted entry was resolved again without losing the packet.
Could the fast path keep the entry in use as it did before?

On 6.18.62 the patch alone stops the zero-MAC frames but the
echoes are still dropped. There nft_flow_route() ignores a failed
nft_dev_forward_path(), so every packet in the other direction
offloads the flow again with the next hop unresolved, and the
next echo tears it down and is dropped. 871df5007eda ("netfilter:
flowtable: bail out if forward path cannot be discovered") fixes
that in mainline but has no Fixes tag and is not in 6.18.y. With
it backported, 6.18.62 behaves like 7.4-rc2.

My first email was wrong to say the flow has to be offloaded
without a valid entry. On plain Ethernet every flow uses
XMIT_NEIGH, and GC alone triggers the bug about 70 s in, so the
neigh del steps in the reproducer are not needed.

Thanks,
John


On Wednesday, 11 November 2026 at 23:09, Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:

> On Wed, Nov 11, 2026 at 04:21:44PM +0100, Pablo Neira Ayuso wrote:
> > Hi,
> >
> > Would you give a try to this attached patch?
>=20
> I forgot you provided a reproducer, I can see one packet is lost after
> this patch, then the follow up packets don't get blockholed.
>=20
> Let me revisit this again.
>=20
> > Thanks.
> >
> > On Mon, Nov 09, 2026 at 09:26:55PM +0000, John wrote:
> > > Hi,
> > >
> > > Since commit b5964aac51e0 ("netfilter: flowtable:
> > > consolidate xmit path"), a flow offloaded with
> > > FLOW_OFFLOAD_XMIT_NEIGH keeps being forwarded with
> > > destination MAC 00:00:00:00:00:00 after the next hop's
> > > neighbour entry has been removed. Nothing resolves the next
> > > hop again, so the flow stays black-holed for as long as it
> > > keeps sending.
> > >
> > > Before that commit the XMIT_NEIGH case called neigh_xmit(),
> > > which creates the entry if needed, sends a solicitation and
> > > queues the packet. Now nf_flow_offload_ipv6_hook() does
> > >
> > > =09neigh =3D ip_neigh_gw6(rt->dst.dev, rt6_nexthop(...));
> > > =09if (IS_ERR(neigh)) { ... }
> > > =09xmit.dest =3D neigh->ha;
> > >
> > > and passes the skb to dev_queue_xmit() through
> > > nf_flow_queue_xmit(), without looking at neigh->nud_state.
> > > When ip_neigh_gw6() has just created the entry, ha is all
> > > zeros, and since the neighbour output path is never used, no
> > > solicitation goes out and the entry stays unresolved. The
> > > IPv4 branch has the same construction with ip_neigh_gw4().
> > > In v7.4-rc2 the code has moved into the per-family xmit
> > > functions but is otherwise unchanged.
> > >
> > > This hit a router here running 6.18.60, which has
> > > b5964aac51e0 as a stable backport. A WireGuard endpoint
> > > behind the router talks to nothing else through it, so its
> > > neighbour entry on the router aged out while the tunnel's
> > > flow was offloaded, and the endpoint's handshake retries
> > > every 5 s kept the flow alive. On the router's egress
> > > interface every forwarded packet of the flow then looked
> > > like this (addresses replaced):
> > >
> > >   02:0e:bd:92:63:28 > 00:00:00:00:00:00,
> > >   ethertype IPv6 (0x86dd), length 154:
> > >   2001:db8:1::51.60161 > 2001:db8:2::1f.59320:
> > >   UDP, length 92
> > >
> > > "ip -6 neigh" had no entry for the destination, conntrack
> > > showed the flow as [OFFLOAD], and deleting the conntrack
> > > entry restored the tunnel until the next time the entry aged
> > > out, a few minutes later. Going back to 6.12.115 on the same
> > > router fixed it.
> > >
> > > The script below reproduces it with three network namespaces
> > > and no special hardware (IPv6 only, needs iproute2, nft and
> > > python3). The server has a permanent entry for the router,
> > > so the router only knows the server from its own resolution.
> > > The flow is offloaded while the router has no valid entry
> > > for the server, which gives XMIT_NEIGH, and once it is
> > > offloaded the script removes the router's entry again, which
> > > is what neighbour GC does to an idle STALE entry.
> > >
> > > 6.18.60:
> > >
> > >   flow: [OFFLOAD]
> > >   entry: fd00:2::2 lladdr a2:5b:b4:93:86:a9 REACHABLE
> > >   entry removed, flow offloaded
> > >   2 s later:
> > >   echoes: 7 ok, 11 lost
> > >   destination MAC of echoes to the server:
> > >        10 00:00:00:00:00:00
> > >         7 a2:5b:b4:93:86:a9
> > >
> > > 6.12.116 (Debian 6.12.116+deb13):
> > >
> > >   flow: [OFFLOAD]
> > >   entry: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
> > >   entry removed, flow offloaded
> > >   2 s later: fd00:2::2 lladdr de:9b:d1:db:19:4c REACHABLE
> > >   echoes: 17 ok, 1 lost
> > >   destination MAC of echoes to the server:
> > >        18 de:9b:d1:db:19:4c
> > >
> > > (Datagram 0 is lost on both kernels, during start-up.)
> > >
> > > I have not run the reproducer on mainline. I compared the
> > > code in v7.4-rc2 instead, and the IPv4 path is untested.
> > >
> > > I don't know this code well enough to say which fix you
> > > would want. Handing the packet to neigh_xmit() when the
> > > entry is not NUD_VALID would restore the old behaviour for
> > > that case, and tearing the flow down would also work, since
> > > the next packet would then take the classic path and resolve
> > > the neighbour. I can test a patch on the router or with the
> > > script.
> > >
> > > #regzbot introduced: b5964aac51e0
> > >
> > > --- reproducer ---
> > >
> > > #!/bin/bash
> > > # Flowtable XMIT_NEIGH flow forwarded to 00:00:00:00:00:00
> > > # after the next hop's neighbour entry goes away. Needs
> > > # root, iproute2, nft and python3.
> > > #
> > > # Namespaces c (client), r (router with a flowtable) and s
> > > # (server). The server has a permanent entry for the
> > > # router, so it never solicits and the router only knows
> > > # the server from its own resolution. The flow is set up
> > > # before the flow-add rule exists, the router's entry for
> > > # the server is removed, and only then is the rule added:
> > > # the flow is offloaded while the next hop has no valid
> > > # entry, which gives XMIT_NEIGH. Once it is offloaded the
> > > # entry is removed again, as neighbour GC does with an
> > > # idle STALE entry.
> > > set -u
> > > P=3Dftrepro
> > > W=3D$(mktemp -d)
> > > E() { local ns=3D$1; shift; ip netns exec "$P-$ns" "$@"; }
> > > cleanup() {
> > >   for j in $(jobs -p); do kill "$j" 2>/dev/null; done
> > >   for n in c r s; do ip netns del "$P-$n" 2>/dev/null; done
> > >   rm -rf "$W"
> > > }
> > > trap cleanup EXIT
> > > trap 'exit 1' INT TERM
> > >
> > > for n in c r s; do ip netns add "$P-$n"; done
> > > ip link add rc netns "$P-r" type veth \
> > >   peer name c0 netns "$P-c"
> > > ip link add rs netns "$P-r" type veth \
> > >   peer name s0 netns "$P-s"
> > > for n in c r s; do E $n ip link set lo up; done
> > > E c ip link set c0 up
> > > E r ip link set rc up
> > > E r ip link set rs up
> > > E s ip link set s0 up
> > > E c ip -6 addr add fd00:1::2/64 dev c0 nodad
> > > E r ip -6 addr add fd00:1::1/64 dev rc nodad
> > > E r ip -6 addr add fd00:2::1/64 dev rs nodad
> > > E s ip -6 addr add fd00:2::2/64 dev s0 nodad
> > > E c ip -6 route add default via fd00:1::1
> > > E s ip -6 route add default via fd00:2::1
> > > RMAC=3D$(E r cat /sys/class/net/rs/address)
> > > E s ip -6 neigh replace fd00:2::1 lladdr "$RMAC" \
> > >   dev s0 nud permanent
> > > E r sysctl -qw net.ipv6.conf.all.forwarding=3D1
> > > E r nft -f - <<'NFT'
> > > table inet t {
> > >   flowtable f {
> > >     hook ingress priority 0; devices =3D { rc, rs };
> > >   }
> > >   chain fw {
> > >     type filter hook forward priority 0; policy accept;
> > >   }
> > > }
> > > NFT
> > >
> > > # Client: UDP echo on port 6000.
> > > E c python3 -c '
> > > import socket
> > > s =3D socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
> > > s.bind(("fd00:1::2", 6000))
> > > while True:
> > >     d, a =3D s.recvfrom(100)
> > >     s.sendto(d, a)
> > > ' >/dev/null 2>&1 &
> > >
> > > # Server side of the wire: destination MAC of every echo
> > > # coming back to the server.
> > > E s python3 -c '
> > > import socket, sys
> > > r =3D socket.socket(socket.AF_PACKET, socket.SOCK_RAW,
> > >                   socket.htons(3))
> > > r.bind(("s0", 0))
> > > f =3D open(sys.argv[1], "w")
> > > port =3D (5000).to_bytes(2, "big")
> > > while True:
> > >     p =3D r.recv(2048)
> > >     # IPv6, next header UDP, destination port 5000
> > >     if p[12:14] =3D=3D b"\x86\xdd" and p[20] =3D=3D 17 \
> > >             and p[56:58] =3D=3D port:
> > >         f.write(p[0:6].hex(":") + "\n")
> > >         f.flush()
> > > ' "$W/wire.log" >/dev/null 2>&1 &
> > > sleep 1
> > >
> > > # Server: one datagram a second to the client, port 5000.
> > > E s python3 -c '
> > > import socket, time, sys
> > > c =3D socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
> > > c.bind(("fd00:2::2", 5000))
> > > c.settimeout(0.8)
> > > f =3D open(sys.argv[1], "w")
> > > for i in range(18):
> > >     t =3D time.time()
> > >     c.sendto(str(i).encode(), ("fd00:1::2", 6000))
> > >     try:
> > >         c.recvfrom(100)
> > >         f.write("%d ok\n" % i)
> > >     except socket.timeout:
> > >         f.write("%d lost\n" % i)
> > >     f.flush()
> > >     time.sleep(max(0, 1.0 - (time.time() - t)))
> > > ' "$W/server.log" >/dev/null 2>&1 &
> > > SV=3D$!
> > >
> > > sleep 4
> > > E r ip -6 neigh del fd00:2::2 dev rs
> > > E r nft add rule inet t fw ct state established \
> > >   meta l4proto udp flow add @f
> > > sleep 3
> > > FLOW=3D$(E r grep -o '\[OFFLOAD\]' /proc/net/nf_conntrack |
> > >   head -1)
> > > echo "flow: $FLOW"
> > > echo "entry: $(E r ip -6 neigh show fd00:2::2 dev rs)"
> > > E r ip -6 neigh del fd00:2::2 dev rs &&
> > >   echo "entry removed, flow offloaded"
> > > sleep 2
> > > echo "2 s later: $(E r ip -6 neigh show fd00:2::2 dev rs)"
> > > wait $SV
> > > echo "echoes: $(grep -c ok "$W/server.log") ok," \
> > >   "$(grep -c lost "$W/server.log") lost"
> > > echo "destination MAC of echoes to the server:"
> > > sort "$W/wire.log" | uniq -c
> > >
> > > Thanks,
> > > John
> > >
>=20
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_t=
able_ip.c
> > index 19cafae748ab..73f49dc41157 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -873,7 +873,8 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
> >  =09=09=09return NF_DROP;
> >  =09=09}
> >  =09=09neigh =3D ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_addr->ip))=
;
> > -=09=09if (IS_ERR(neigh)) {
> > +=09=09if (IS_ERR(neigh) ||
> > +=09=09    !(READ_ONCE(neigh->nud_state) & NUD_VALID)) {
> >  =09=09=09flow_offload_teardown(flow);
> >  =09=09=09return NF_DROP;
> >  =09=09}
> > @@ -1202,7 +1203,8 @@ static int nf_flow_queue_xmit6(struct sk_buff *sk=
b,
> >  =09=09=09return NF_DROP;
> >  =09=09}
> >  =09=09neigh =3D ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &ip_addr->in=
6));
> > -=09=09if (IS_ERR(neigh)) {
> > +=09=09if (IS_ERR(neigh) ||
> > +=09=09    !(READ_ONCE(neigh->nud_state) & NUD_VALID)) {
> >  =09=09=09flow_offload_teardown(flow);
> >  =09=09=09return NF_DROP;
> >  =09=09}
>=20
> 
