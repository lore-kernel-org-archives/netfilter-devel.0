Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792833978;
	b=rMs+c9kkyuQ6i2JAtHlX1JJHYvo4gj3S1QS4vcsWOCStca/4pegbPqYkAXNlFX5oNXJi
	 dX/qcQvIxv1ujG0oDx5Qll7vChEa6KwXUryWPIfnVX/Kfg05kRE/M2ebZTyLY2Gu9D7dR
	 j3D6EYLFAHwynL8KTVCWonHfeVBk95l8KiX8I++0sgNAsmCceywg6aLInPKp/pPZzPj8v
	 PN8oXw7FqUKqujoEb7DRKPut1xVmXtBngIoCXIGYwI50u0ahrDb/O/o2PK5djy03Qh6po
	 Wn8a47rk6jXya+T6cDpFD79bOxNwpjHGlu1HLDjcBk5yv6MGKsN+T2j5AV1VvmhFhvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792833978;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id;
	bh=CtYn2jSKE3zNH8y22788m97cy326kpminN9yuclLntM=;
	b=hAmmEum4vy9RfU9KkFfoxl8KE86rDMd2MnX8phD8JvJnL2S1iu+Auqb91ApKQ1d+e88U
	 GcZdsFEo9PDKtBe3LAQPB8byz0jxeWcdBhne4+zwesqJYSz5poR1ezfcOiaxb7l/pEJ1x
	 J2M8Px0PrulP2DsDBNVgy+0SvJJiBE9SyUpNBqe6CGbdSHvgu6UIJQPbfmBRww76bJcEH
	 Ugqr7yjPpFTHLz5WO5dVDaqOAnjSlSyhK02GkeyNOWKoh7S2VXZj/LivZ/KU59NBNNCY+
	 DVL4hrrXpJEacA7rIiOTnmDxWklWpjSzDyY7jxZUEXz1XnheQnWBfttlPMxoPyAdjmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=LIw+ui87;
	arc=none smtp.remote-ip=195.10.208.51
Received: from mout-b-206.mailbox.org (mout-b-206.mailbox.org [195.10.208.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB12606A320;
	Sat, 24 Oct 2026 09:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFB12606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=LIw+ui87
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-206.mailbox.org (Postfix) with ESMTPS id 4jBZJ94B0DzZ8;
	Sat, 24 Oct 2026 11:26:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1792833961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CtYn2jSKE3zNH8y22788m97cy326kpminN9yuclLntM=;
	b=LIw+ui87VUgXGmh5WO3jooIfdYkN/bAGF0h7wGjBCsNZ8xUnJ///BR0gCg5kK5VoeRJATI
	YzdeAqjqRmWW1HxurAcEP51kda8oNP9JEj4ubZbQjEwnOXzIjmnExNaVBpDN0PWnlhul2V
	qCWKZn+O/92L4fIzMJ5Zq6+sAnREFtBxnzGjUtoyxu7UttuU1nbkUtj/czO/TSLjUPGQi3
	Im694NlGbnf+ckN957t9e2zJp0BGiPH1V4PyH4tnnVtKeueTmvYLrPdxeU6zmG5m9rwx6v
	nZSewNMlVQj354LA01Mkvn+rsVX+5ORp4PnSfHc60Wydw1iHm8wg4tYFc/HLUQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
	Beniamino Galvani <bgalvani@redhat.com>,
	Xavier Hsinyuan <xavierhsinyuan@outlook.com>,
	=?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [RFC net-next v2 00/18] net: introduce ipxlat stateless IPv4/IPv6 translation
Date: Sat, 24 Oct 2026 11:25:10 +0200
Message-ID: <20261024092532.172005-1-ralf@mandelbit.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4jBZJ94B0DzZ8

Hi all,

apologies for the long gap since RFC v1; the attachment redesign and the
related fragmentation work took longer than expected.

This RFC introduces ipxlat, an in-kernel engine for stateless IPv4/IPv6
and ICMP translation, together with a lightweight-tunnel attachment.

ipxlat implements the SIIT algorithm from RFC 7915, RFC 6052 address
embedding, optional RFC 7757 Explicit Address Mapping, transport
checksum and GSO metadata, and ICMP translation including quoted packets
and RFC 4884 extensions. It is intended as a common building block for
CLAT, stateful NAT64, 464XLAT, and SIIT border translators.

NetworkManager currently provides CLAT with BPF [1], and
systemd-networkd is developing a similar implementation [2]. Those
implementations cannot cover some paths which need facilities outside
the BPF program, including fragmentation, fragmented ICMP, and complete
checksum generation for zero-checksum UDPv4. A reusable native
translator lets network managers share those mechanisms rather than each
maintaining another partial implementation.

This RFC has 18 patches. The first four are networking-core
prerequisites for LWT continuation and IPv6 refragmentation. Keeping the
remaining 14 changes separate makes the engine, LWT attachment,
selftests, and documentation substantially easier to review. NIPA’s
series_format will complain that the series is too long, but the split
can be adjusted for a non-RFC posting once the design has settled.

See Documentation/networking/ipxlat.rst for the full configuration and
operational model.

The latest code can also be found at:
https://codeberg.org/IPv6-Monostack/ipxlat-net-next


== Architecture ==

RFC v1 exposed ipxlat as a virtual netdevice which translated packets in
ndo_start_xmit and injected them back into the receive path. Review
identified that this required artificial device, MTU, routing, and
statistics semantics and made the packet appear to have arrived from a
device after translation.

v2 instead separates a reusable engine under net/ipxlat from its (first)
attachment. An IPv4 or IPv6 route carrying encap ipxlat selects the
packet and supplies immutable translation configuration. The selecting
route terminates in translation; after the family switch, the packet
gets a fresh route in the translated family. There is no translator
device or ipxlat-specific netlink family.

The engine performs validation and translation but does not decide which
traffic should use it. Routing rules and filters remain responsible for
deployment policy such as CLAT source selection and downstream source
validation. Keeping the engine independent also leaves room for later
netfilter or BPF kfunc attachments without duplicating the translator.


== Address configuration ==

Each attachment has one required RFC 6052 prefix and an optional RFC
7757 Explicit Address Mapping. Each source and destination is considered
independently: an EAM match takes precedence, while an address outside
the EAM uses RFC 6052 conversion.

This represents both CLAT addressing models requested during v1 review.
A single-host CLAT maps one dedicated IPv4 address to one IPv6 address.
A delegated-prefix CLAT maps the downstream IPv4 prefix into a prefix
delegated to the CLAT, while remote IPv4 destinations continue to use
the far-side NAT64 prefix. This v2 accepts at most one EAM per
attachment and does not implement RFC 7757 hairpinning.

Configuration belongs to each selecting route rather than to a shared
ipxlat object. A bidirectional setup therefore repeats the configuration
on its original and translated family selecting routes. Userspace must
update both routes whenever a configured address or prefix changes, for
example after DHCPv6-PD assigns a new prefix.

The dev associated with an ipxlat route belongs only to the
original family selecting route; it is not a translator interface and
does not select the translated packet's egress device. The fresh
translated family route lookup does that.


== Family switch and policy traversal ==

The original family route lookup ends at the LWT callback. The callback
discards route, conntrack, security, socket, and other metadata which no
longer describes the translated packet.

For received traffic, the translated packet enters the translated
family's PRE_ROUTING hook and receives a fresh route lookup. For locally
originated traffic, it enters translated family LOCAL_OUT with no
socket. The normal translated family path then owns:
- forwarding,
- TTL or Hop Limit,
- PMTU,
- XFRM,
- conntrack, and
- NAT.

This allows a stateful NAT64 PLAT to be built from stateless ipxlat plus
ordinary IPv4 conntrack and masquerading. No conntrack object crosses
the family switch.

Translated output is socketless. It uses the normal kernel-originated
UID and global XFRM policy; socket, cgroup, and per socket XFRM identity
cannot cross the family switch.

If preparation determines that a packet is valid but unsupported, the
LWT invokes the route's original input or output callback and leaves the
packet in its original family. This is needed, for example, so native
IPv6 Neighbor Discovery still works for a local address selected by an
ipxlat route. Malformed packets and failures after translation begins
are dropped.

This continuation is the central semantic choice in v2. Does PRE_ROUTING
for received translated traffic and LOCAL_OUT for locally generated
translated traffic provide the right policy visibility for a
cross-family LWT action? And does the harness discard and retain the
right skb metadata across the family switch?


== Fragmentation ==

v1 fragmented oversized DF-clear IPv4 packets before translation, using
a synthetic route to supply an MTU. v2 translates first and lets IPv6
output use the real translated route and PMTU.

IPv4 packets which are already fragments carry an IPv6 Fragment Header
after translation. This series extends IPv6 output so it can fragment
that representation again while preserving the translated
identification, base offset, and More Fragments state. IPv6 conntrack
reassembly preserves the indication needed for the later output path to
do the same. An MTU metric on a translated family route can be used as
an administrative ceiling where Packet Too Big feedback is unreliable.

If an earlier original-family component has already reassembled a
datagram, ipxlat cannot recover its previous fragment boundaries or
identification. Fragmented ICMP and zero-checksum UDPv4 must likewise be
reassembled before translation because their translated checksums need
the complete datagram.


== Testing ==

The selftests use an iproute2-configured namespace topology and cover:
- local and forwarded translation,
- native fallback,
- zero-checksum UDPv4,
- translated family conntrack and masquerading,
- route-PMTU fragmentation,
- conntrack reassembly followed by refragmentation,
- PMTU feedback, and
- ICMP errors.

Along with this series, an iproute2 ipxlat-enabled tree is provided [3].

[1] https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/blob/1.57.2-dev/src/core/bpf/clat.bpf.c
[2] https://github.com/systemd/systemd/pull/41412
[3] https://codeberg.org/IPv6-Monostack/iproute2/src/branch/ipxlat-lwt


== Points for discussion ==

- Is the translated-family continuation described above the right
  contract for an LWT family switch?

- Is an LWT attachment with inline immutable route configuration the
  right first harness for the reusable engine?

- Is reusing an existing IPv6 Fragment Header in the output
  fragmentation path a suitable general mechanism for translated IPv4
  fragments?


== Acknowledgements ==

The ipxlat translation engine is derived from Jool so it can benefit
from the project's accumulated implementation experience and
golden-packet tests. Thanks to Jool's principal author, Alberto Leiva
Popper, for maintaining that work and for writing the original joolif
prototype from which ipxlat started.

Thanks to Toke Høiland-Jørgensen, Beniamino Galvani, Xavier Hsinyuan,
and Jonathan Corbet for their RFC v1 review and deployment input.

Thanks to NLnet's NGI0 Core Fund for supporting ipxlat development.


Thanks for your review,

Ralf Lici
Mandelbit SRL

---

Changes since RFC v1 https://lore.kernel.org/netdev/20260319151230.655687-1-ralf@mandelbit.com/

- Replaced the virtual netdevice and generic-netlink control plane with
  a reusable translation engine under net/ipxlat and a route-selected
  LWT attachment. Deployment policy remains outside the engine. (Toke)

- Added an optional RFC 7757 EAM before RFC 6052 conversion, covering
  both single-host and delegated-prefix CLAT addressing. (Beniamino)

- Defined received and local traffic continuations into the translated
  family, including fresh routing, conntrack, NAT, and XFRM processing.
  Added native LWT fallback for packets the engine does not support.

- Removed the lowest-ipv6-mtu parameter and IPv4 pre-fragmentation. The
  translated IPv6 route now owns PMTU and fragmentation, including
  refragmentation which preserves an existing Fragment Header across
  conntrack reassembly.

- Moved TTL and Hop Limit handling to the translated family forwarding
  path, so translation itself does not consume a hop.

- Replaced the v1 netdevice tests and documentation with LWT coverage
  and deployment examples.


Ralf Lici (18):
  lwtunnel: track callback dispatch separately from return value
  ipv4/ipv6: add LWT receive helpers
  ipv6: allow output fragmentation to reuse a Fragment Header
  netfilter: preserve IPv6 refragmentation state across reassembly
  net: ipxlat: add engine skeleton and configuration model
  net: ipxlat: add RFC 6052 and EAM address translation
  net: ipxlat: add packet metadata and header helpers
  net: ipxlat: add IPv4 packet validation
  net: ipxlat: add IPv6 packet validation
  net: ipxlat: add checksum and offload helpers
  net: ipxlat: add IPv4/IPv6 header and transport translation
  net: ipxlat: add translation preparation and dispatch
  net: ipxlat: add translator-generated ICMP errors
  net: ipxlat: add ICMP informational translation
  net: ipxlat: add ICMP error and quoted-packet translation
  net: ipxlat: add lightweight tunnel attachment
  selftests: net: add ipxlat coverage
  docs: networking: add ipxlat guide

 Documentation/networking/index.rst           |   1 +
 Documentation/networking/ipxlat.rst          | 333 ++++++++++
 include/linux/ipv6.h                         |   2 +
 include/net/ip.h                             |   1 +
 include/net/ipv6.h                           |   2 +
 include/net/ipv6_frag.h                      |   2 +
 include/net/ipxlat.h                         | 113 ++++
 include/uapi/linux/ipxlat.h                  |  56 ++
 include/uapi/linux/lwtunnel.h                |   1 +
 net/Kconfig                                  |   1 +
 net/Makefile                                 |   1 +
 net/core/lwtunnel.c                          |  15 +-
 net/ipv4/ip_input.c                          |  10 +
 net/ipv6/ip6_input.c                         |  11 +
 net/ipv6/ip6_output.c                        |  53 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c      |  11 +-
 net/ipxlat/Kconfig                           |  27 +
 net/ipxlat/Makefile                          |  19 +
 net/ipxlat/address.c                         | 218 +++++++
 net/ipxlat/address.h                         |  57 ++
 net/ipxlat/config.c                          |  82 +++
 net/ipxlat/core.c                            | 156 +++++
 net/ipxlat/icmp.h                            |  70 ++
 net/ipxlat/icmp_46.c                         | 588 +++++++++++++++++
 net/ipxlat/icmp_64.c                         | 615 ++++++++++++++++++
 net/ipxlat/lwt.c                             | 643 +++++++++++++++++++
 net/ipxlat/packet.h                          | 243 +++++++
 net/ipxlat/packet4.c                         | 410 ++++++++++++
 net/ipxlat/packet6.c                         | 468 ++++++++++++++
 net/ipxlat/translate_46.c                    | 217 +++++++
 net/ipxlat/translate_46.h                    |  77 +++
 net/ipxlat/translate_64.c                    | 226 +++++++
 net/ipxlat/translate_64.h                    |  96 +++
 net/ipxlat/transport.c                       | 179 ++++++
 net/ipxlat/transport.h                       | 127 ++++
 tools/testing/selftests/Makefile             |   1 +
 tools/testing/selftests/net/ipxlat/Makefile  |   5 +
 tools/testing/selftests/net/ipxlat/config    |  13 +
 tools/testing/selftests/net/ipxlat/ipxlat.sh | 554 ++++++++++++++++
 39 files changed, 5694 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/networking/ipxlat.rst
 create mode 100644 include/net/ipxlat.h
 create mode 100644 include/uapi/linux/ipxlat.h
 create mode 100644 net/ipxlat/Kconfig
 create mode 100644 net/ipxlat/Makefile
 create mode 100644 net/ipxlat/address.c
 create mode 100644 net/ipxlat/address.h
 create mode 100644 net/ipxlat/config.c
 create mode 100644 net/ipxlat/core.c
 create mode 100644 net/ipxlat/icmp.h
 create mode 100644 net/ipxlat/icmp_46.c
 create mode 100644 net/ipxlat/icmp_64.c
 create mode 100644 net/ipxlat/lwt.c
 create mode 100644 net/ipxlat/packet.h
 create mode 100644 net/ipxlat/packet4.c
 create mode 100644 net/ipxlat/packet6.c
 create mode 100644 net/ipxlat/translate_46.c
 create mode 100644 net/ipxlat/translate_46.h
 create mode 100644 net/ipxlat/translate_64.c
 create mode 100644 net/ipxlat/translate_64.h
 create mode 100644 net/ipxlat/transport.c
 create mode 100644 net/ipxlat/transport.h
 create mode 100644 tools/testing/selftests/net/ipxlat/Makefile
 create mode 100644 tools/testing/selftests/net/ipxlat/config
 create mode 100755 tools/testing/selftests/net/ipxlat/ipxlat.sh

-- 
2.55.0

