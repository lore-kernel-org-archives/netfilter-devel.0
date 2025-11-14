Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38D62163B2
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079961; cv=none; b=rTks6mMomfNfdsD6yGN3VhZnI+5vulBX61sfzNtee2XgbWFwTocCisRnKcUtFNat/Z7ZyQJkkyqIor9BIwi44xQB618sAebkvAHX49wufbH0TmHHLQDMwsrbxMM7yKB//2Paf9dVU6zMCDoxfOh+QvMYbEW37drVT3lPw0m/PYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079961; c=relaxed/simple;
	bh=u1ktGWAN2QDULZxLmFTXxOxjTuApBLx7KwbbOsR1IRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IbiZGv3BderGCD4aiHQOGQDNnRK+OHTXJeQMXaX4CzsiONxWi/XMIaV5vdLVdpfw3ZzUlGh9QKJkaKTQeKMIawU426yEj2IDBASS1pMT1hB0bpo+zBZ9xv5x5UU6JBwxEa9PFGBEaifojWnUOLrR+1BG6vDAJvwxhKwMVdDtYPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=o7l9KxyG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="o7l9KxyG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UAu0dDBMgnWEcxjh/e9IP6LZkZoU7n30dL8P84SYBlg=; b=o7l9KxyGUIXwLeSDEDBfuCOBSi
	pK18yarRbYLSAKypOEzPpFYBZopKM66m/PKolHu1iiafMS1qoZ4OnMAykqMNQY1JqjMNwQ77nyA/l
	4hqozXtxrElk9LY2CSM+IvSCxnlfS+uxEFsBGxJawro4EKFABrl7VdooPMUZxoXuWSqVgwYp8vB4Z
	w80k0gY6EvCox6APDsTdCRPgVWAfgCrffcg9ZmWP19vSngza5HNzMXnAqjL/Q9rBPzYnwZEfWGBZE
	k68dMZpESD22Cp1TK+Yj33aiIrrSg0SxH3dts0bYaM6eGqykZE+x4wHLrcIxx/jNQl9v5q/Z5q06m
	XOYYXE+g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdV-000000005ky-3Og5;
	Fri, 14 Nov 2025 01:25:58 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 00/11] Fix netlink debug output on Big Endian
Date: Fri, 14 Nov 2025 01:25:31 +0100
Message-ID: <20251114002542.22667-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make use of recent changes to libnftnl to make test suites pass on both
Little and Big Endian systems.

Changes since v1:
- First 12 patches accepted and pushed already, patches 27 and 28 as
  well
- Minimize changes to existing code: Drop patch 13 changing string-based
  expressions to be defined as Big Endian as well as related patches 14,
  17 and 18
- Pull a fix for concatenated wildcard interface names upfront
- Follow with set element sorting changes, with improved patch
  descriptions and related test suite record changes folded into them
  for clarification of practical effect
- Review patch descriptions in general
- Add special casing to patch 5 to avoid string-based values being
  printed in reverse by libnftnl, also communicate any byteorder
  conversions from __netlink_gen_concat_key() back to caller for the
  same purpose

Patch 1 works around "funny" behaviour of GMP when partially exporting
data and unwanted prefix-padding when exporting into an oversized
buffer, all happening on Big Endian only.

Patches 2 and 3 deal with sorting of set elements. They are effective on
Little Endian only, changing sort ordering to match that of Big Endian.

Patches 4 and 5 are preparation for the next two patches.

Patches 6 and 7 collect data for calls to newly introduced libnftnl API
functions (in patch 8) to communicate byte order and component sizes in
data regs to libnftnl.

Patch 10 contains the big payload records update, created with help from
the script introduced in patch 9.

Patch 11 still contains the expr_print_debug() macro definition for use
with printf-debugging.

Phil Sutter (11):
  segtree: Fix range aggregation on Big Endian
  mergesort: Fix sorting of string values
  mergesort: Align concatenation sort order with Big Endian
  intervals: Convert byte order implicitly
  expression: Set range expression 'len' field
  netlink: Introduce struct nft_data_linearize::byteorder
  netlink: Introduce struct nft_data_linearize::sizes
  netlink: Make use of nftnl_{expr,set_elem}_set_imm()
  tests: py: tools: Add regen_payloads.sh
  tests: py: Update payload records
  utils: Introduce expr_print_debug()

 include/netlink.h                             |   2 +
 include/utils.h                               |   9 +
 src/evaluate.c                                |   1 +
 src/expression.c                              |   1 +
 src/intervals.c                               |  10 +-
 src/mergesort.c                               |  11 +-
 src/netlink.c                                 |  84 +++-
 src/netlink_linearize.c                       |  34 +-
 src/segtree.c                                 |   6 +-
 tests/py/any/ct.t.json.output                 |  20 +-
 tests/py/any/ct.t.payload                     |  89 ++--
 tests/py/any/meta.t.json.output               |  54 ---
 tests/py/any/meta.t.payload                   | 232 ++++-----
 tests/py/any/meta.t.payload.bridge            |  10 +-
 tests/py/any/queue.t.json.output              |   4 +-
 tests/py/any/queue.t.payload                  |   2 +-
 tests/py/any/rawpayload.t.payload             |  64 +--
 tests/py/any/rt.t.payload                     |   5 +-
 tests/py/any/tcpopt.t.json.output             |  77 ---
 tests/py/any/tcpopt.t.payload                 |  88 ++--
 tests/py/arp/arp.t.payload                    |  99 ++--
 tests/py/arp/arp.t.payload.netdev             | 189 ++++----
 tests/py/bridge/ether.t.payload               |  43 +-
 tests/py/bridge/icmpX.t.payload               |  25 +-
 tests/py/bridge/meta.t.payload                |  20 +-
 tests/py/bridge/redirect.t.payload            |   2 +-
 tests/py/bridge/reject.t.payload              |  43 +-
 tests/py/bridge/vlan.t.payload                | 262 +++++------
 tests/py/bridge/vlan.t.payload.netdev         | 316 ++++++-------
 tests/py/inet/ah.t.payload                    |  89 ++--
 tests/py/inet/comp.t.payload                  |  53 ++-
 tests/py/inet/ct.t.payload                    |  14 +-
 tests/py/inet/dccp.t.payload                  |  53 ++-
 tests/py/inet/dnat.t.payload                  |  47 +-
 tests/py/inet/esp.t.payload                   |  45 +-
 tests/py/inet/ether-ip.t.payload              |  22 +-
 tests/py/inet/ether-ip.t.payload.netdev       |  23 +-
 tests/py/inet/ether.t.payload                 |  37 +-
 tests/py/inet/ether.t.payload.bridge          |  29 +-
 tests/py/inet/ether.t.payload.ip              |  37 +-
 tests/py/inet/fib.t.payload                   |  12 +-
 tests/py/inet/geneve.t.payload                |  83 ++--
 tests/py/inet/gre.t.payload                   |  53 ++-
 tests/py/inet/gretap.t.payload                |  59 ++-
 tests/py/inet/icmp.t.payload                  |  37 +-
 tests/py/inet/icmpX.t.payload                 |  32 +-
 tests/py/inet/ip.t.payload                    |   4 +-
 tests/py/inet/ip.t.payload.bridge             |   4 +-
 tests/py/inet/ip.t.payload.inet               |   7 +-
 tests/py/inet/ip.t.payload.netdev             |   7 +-
 tests/py/inet/ip_tcp.t.payload                |  36 +-
 tests/py/inet/ip_tcp.t.payload.bridge         |  35 +-
 tests/py/inet/ip_tcp.t.payload.netdev         |  37 +-
 tests/py/inet/ipsec.t.payload                 |  11 +-
 tests/py/inet/map.t.payload                   |  11 +-
 tests/py/inet/map.t.payload.ip                |   7 +-
 tests/py/inet/map.t.payload.netdev            |  11 +-
 tests/py/inet/meta.t.payload                  |  83 ++--
 tests/py/inet/osf.t.json.output               |  54 +++
 tests/py/inet/osf.t.payload                   |  16 +-
 tests/py/inet/payloadmerge.t.payload          |  43 +-
 tests/py/inet/reject.t.payload.inet           |  43 +-
 tests/py/inet/rt.t.payload                    |   7 +-
 tests/py/inet/sctp.t.payload                  | 159 ++++---
 tests/py/inet/sets.t.payload.bridge           |  15 +-
 tests/py/inet/sets.t.payload.inet             |  14 +-
 tests/py/inet/sets.t.payload.netdev           |  14 +-
 tests/py/inet/snat.t.payload                  |  30 +-
 tests/py/inet/socket.t.payload                |   8 +-
 tests/py/inet/tcp.t.payload                   | 360 +++++++-------
 tests/py/inet/tproxy.t.payload                |  45 +-
 tests/py/inet/udp.t.payload                   | 112 ++---
 tests/py/inet/udplite.t.payload               |  81 ++--
 tests/py/inet/vmap.t.payload                  |  13 +-
 tests/py/inet/vmap.t.payload.netdev           |  13 +-
 tests/py/inet/vxlan.t.payload                 |  83 ++--
 tests/py/ip/ct.t.payload                      |  46 +-
 tests/py/ip/dnat.t.payload.ip                 | 117 +++--
 tests/py/ip/dup.t.payload                     |   7 +-
 tests/py/ip/ether.t.payload                   |  37 +-
 tests/py/ip/hash.t.payload                    |   2 +-
 tests/py/ip/icmp.t.payload.ip                 | 312 ++++++-------
 tests/py/ip/igmp.t.payload                    |  61 ++-
 tests/py/ip/ip.t.payload                      | 246 +++++-----
 tests/py/ip/ip.t.payload.bridge               | 440 +++++++++---------
 tests/py/ip/ip.t.payload.inet                 | 440 +++++++++---------
 tests/py/ip/ip.t.payload.netdev               | 434 ++++++++---------
 tests/py/ip/ip_tcp.t.payload                  |   9 +-
 tests/py/ip/masquerade.t.payload              |  71 ++-
 tests/py/ip/meta.t.payload                    |  32 +-
 tests/py/ip/numgen.t.payload                  |   4 +-
 tests/py/ip/objects.t.payload                 |  26 +-
 tests/py/ip/redirect.t.payload                | 121 +++--
 tests/py/ip/reject.t.payload                  |   3 +-
 tests/py/ip/rt.t.payload                      |   3 +-
 tests/py/ip/sets.t.payload.inet               |  38 +-
 tests/py/ip/sets.t.payload.ip                 |  12 +-
 tests/py/ip/sets.t.payload.netdev             |  38 +-
 tests/py/ip/snat.t.payload                    |  74 +--
 tests/py/ip/tcp.t.payload                     |  11 +-
 tests/py/ip/tproxy.t.payload                  |  29 +-
 tests/py/ip6/ct.t.payload                     |  12 +-
 tests/py/ip6/dnat.t.payload.ip6               |  38 +-
 tests/py/ip6/dst.t.payload.inet               |  60 +--
 tests/py/ip6/dst.t.payload.ip6                |  30 +-
 tests/py/ip6/dup.t.payload                    |   7 +-
 tests/py/ip6/ether.t.payload                  |  36 +-
 tests/py/ip6/exthdr.t.payload.ip6             |  25 +-
 tests/py/ip6/frag.t.payload.inet              | 131 +++---
 tests/py/ip6/frag.t.payload.ip6               |  75 ++-
 tests/py/ip6/frag.t.payload.netdev            | 131 +++---
 tests/py/ip6/hbh.t.payload.inet               |  65 ++-
 tests/py/ip6/hbh.t.payload.ip6                |  33 +-
 tests/py/ip6/icmpv6.t.payload.ip6             | 322 ++++++-------
 tests/py/ip6/ip6.t.payload.inet               | 359 +++++++-------
 tests/py/ip6/ip6.t.payload.ip6                | 191 ++++----
 tests/py/ip6/map.t.payload                    |   5 +-
 tests/py/ip6/masquerade.t.payload.ip6         |  71 ++-
 tests/py/ip6/meta.t.payload                   |  36 +-
 tests/py/ip6/mh.t.payload.inet                | 132 +++---
 tests/py/ip6/mh.t.payload.ip6                 |  66 +--
 tests/py/ip6/redirect.t.payload.ip6           | 105 +++--
 tests/py/ip6/reject.t.payload.ip6             |   3 +-
 tests/py/ip6/rt.t.payload.inet                | 121 +++--
 tests/py/ip6/rt.t.payload.ip6                 |  61 ++-
 tests/py/ip6/rt0.t.payload                    |   3 +-
 tests/py/ip6/sets.t.payload.inet              |  18 +-
 tests/py/ip6/sets.t.payload.ip6               |   4 +-
 tests/py/ip6/sets.t.payload.netdev            |  18 +-
 tests/py/ip6/snat.t.payload.ip6               |  23 +-
 tests/py/ip6/srh.t.payload                    |  23 +-
 tests/py/ip6/tproxy.t.payload                 |  29 +-
 tests/py/ip6/vmap.t.payload.inet              | 169 ++++---
 tests/py/ip6/vmap.t.payload.ip6               |  85 ++--
 tests/py/ip6/vmap.t.payload.netdev            | 169 ++++---
 tests/py/netdev/dup.t.payload                 |   3 +-
 tests/py/netdev/fwd.t.payload                 |   5 +-
 tests/py/netdev/reject.t.payload              |  41 +-
 tests/py/netdev/tunnel.t.payload              |   5 +-
 tests/py/tools/regen_payloads.sh              |  74 +++
 .../testcases/maps/dumps/0012map_0.json-nft   |  20 +-
 .../shell/testcases/maps/dumps/0012map_0.nft  |   8 +-
 .../maps/dumps/named_ct_objects.json-nft      |  12 +-
 .../testcases/maps/dumps/named_ct_objects.nft |   6 +-
 .../maps/dumps/typeof_integer_0.json-nft      |  12 +-
 .../testcases/maps/dumps/typeof_integer_0.nft |   4 +-
 .../dumps/0012different_defines_0.json-nft    |   8 +-
 .../nft-f/dumps/0012different_defines_0.nft   |   2 +-
 .../dumps/merge_nat_inet.json-nft             |  12 +-
 .../optimizations/dumps/merge_nat_inet.nft    |   2 +-
 .../optimizations/dumps/merge_reject.json-nft |  16 +-
 .../optimizations/dumps/merge_reject.nft      |   4 +-
 .../dumps/merge_stmts_concat.json-nft         |  42 +-
 .../dumps/merge_stmts_concat.nft              |   8 +-
 .../dumps/merge_stmts_concat_vmap.json-nft    |   4 +-
 .../dumps/merge_stmts_concat_vmap.nft         |   2 +-
 .../sets/dumps/0029named_ifname_dtype_0.nft   |   4 +-
 .../0037_set_with_inet_service_0.json-nft     |  12 +-
 .../dumps/0037_set_with_inet_service_0.nft    |   8 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |   4 +-
 .../sets/dumps/sets_with_ifnames.nft          |   2 +-
 .../testcases/sets/dumps/typeof_sets_0.nft    |   4 +-
 tests/shell/testcases/sets/typeof_sets_0      |   4 +-
 163 files changed, 4743 insertions(+), 4744 deletions(-)
 create mode 100755 tests/py/tools/regen_payloads.sh

-- 
2.51.0

