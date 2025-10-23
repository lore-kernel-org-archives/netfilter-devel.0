Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B5E259CB9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236106; cv=none; b=J/Mv7ve2KGHZpAcJnXo5Sqc1wH77zyNGD6BPmXZibpVip+w7JxG0IOkUXUKus+qRNjk4eZzzOQLHwoQVbMBI7eLqNdPFOhOPurEFGZ04ljASbFKdE0hDL08vLeDKmbx3u2icsnjd5yBDBx0vCWyzmAkH+1JJX95orkC8iTUglFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236106; c=relaxed/simple;
	bh=XjE+WmmBJ1kaQV8cY8ksBZG9T7dTPqy4ejSbBitGDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rS6tzSnd7bSofwiXLo124Jnu5VCxTkwKlHD+CMdLe1FFR9RByXeetyar33shz1cItqPDCYFcVQy8YKLDlJuwbVD6VnuK25TlEedH2VjA4hYhrs86b1tpMd1BPQcGS0X1XSQ+UGTBaAQaXWfvVc4KdacqX4TCOnVDc1sG5OCmV6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=euwVkWFR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="euwVkWFR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sfBjD5eV4mMPGusd4wOv3Z5zA2hCpqd5svkp3uii1+o=; b=euwVkWFRxEgkFEcWJekH101aQe
	p21V957FyRW5iloEv3qZ9G9XmAmLQv/AhIt1w8PbEv7uREFVz/XRmig132JRD9t4tDuz9YOJns7es
	pgnmD5DOoY6kexMZEKAtWN9nEEqgKiymyAjBVCqH7ZazpgqOG7giWk/lh3k5lwer3651DD+IHVcad
	2difC08sIDOv+huuRd980RZANhu+ifqmH6MxqtjbQPrz1GfPybKoen+ddwkNJdbL9yUwJYSwdhN3y
	PWFOWBQUD9xQupzODq3mEdEDbbk6lKV6IHsUCp7yWmwqPPUoUJUVv4xOKaU4ZR81640ieVXbXPPRP
	WvJnIw6w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxt-0000000009Y-45Mz;
	Thu, 23 Oct 2025 18:15:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 00/28] Fix netlink debug output on Big Endian
Date: Thu, 23 Oct 2025 18:13:49 +0200
Message-ID: <20251023161417.13228-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make use of recent changes to libnftnl and make tests/py testsuite pass
on Big Endian systems.

Patches 1-7 fix existing code, are valid without the remaining ones but
required for the target at hand.

Patches 8-12 are a mixture of fixes and preparation for the remaining
ones.

Patches 13-15 change the defined byteorder for all string-based
expressions to BYTEORDER_BIG_ENDIAN. This avoids special casing when
communicating data reg byteorder to libnftnl as they should be printed
left to right, just like with Big Endian values.

Patches 16-21 contain the required changes correcting netlink debug
output.

Patches 22 and 23 change how concatenations are linearized before
comparison for set element sorting. Aside from unifying results between
Little and Big Endian, sorting order now seems "correct" to a human
reader.

Patches 24 and 25 Introduce a tool to refresh stored payload records in
py test suite and record the tool's results.

Patch 26 adds expr_print_debug() macro easing "printf debugging" around
expression use.

Patches 27 and 28 finally fix for BUG() messages missing a terminating
newline at times.

Phil Sutter (28):
  datatype: Fix boolean type on Big Endian
  optimize: Fix verdict expression comparison
  tests: py: any/tcpopt.t.json: Fix JSON equivalent
  tests: py: any/ct.t.json.output: Drop leftover entry
  tests: py: inet/osf.t: Fix element ordering in JSON equivalents
  tests: py: Fix for using wrong payload path
  tests: py: Implement payload_record()
  tests: py: Do not rely upon '[end]' marker
  netlink: No need to reference array when passing as pointer
  datatype: Increase symbolic constant printer robustness
  tests: py: ip6/vmap.t: Drop double whitespace in rule
  netlink: Zero nft_data_linearize objects when populating
  Define string-based data types as Big Endian
  segtree: No byteorder conversion for string prefix len calculation
  Fix byteorder conversion of concatenated value expressions and ranges
  expression: Set range expression 'len' field
  segtree: Export complete data before editing
  segtree: Drop problematic constant expr len adjustment
  netlink: Introduce struct nft_data_linearize::byteorder
  netlink: Introduce struct nft_data_linearize::sizes
  netlink: Make use of nftnl_{expr,set_elem}_set_imm()
  mergesort: Linearize concatentations in network byte order
  tests: Adjust JSON records to improved element sorting
  tests: py: tools: Add regen_payloads.sh
  tests: py: Update payload records
  utils: Introduce expr_print_debug()
  utils: Cover for missing newline after BUG() messages
  Drop no longer needed newline in BUG() messages

 include/netlink.h                             |   2 +
 include/utils.h                               |  11 +-
 src/ct.c                                      |   2 +-
 src/datatype.c                                |  28 +-
 src/erec.c                                    |   2 +-
 src/evaluate.c                                |  65 +--
 src/expression.c                              |   7 +-
 src/fib.c                                     |   7 +-
 src/intervals.c                               |  23 +-
 src/json.c                                    |   6 +-
 src/mergesort.c                               |   6 +-
 src/meta.c                                    |  16 +-
 src/mnl.c                                     |  10 +-
 src/netlink.c                                 |  84 +++-
 src/netlink_delinearize.c                     |  25 +-
 src/netlink_linearize.c                       |  62 +--
 src/optimize.c                                |  13 +-
 src/osf.c                                     |   3 +-
 src/parser_bison.y                            |  10 +-
 src/parser_json.c                             |   4 +-
 src/rule.c                                    |  20 +-
 src/segtree.c                                 |  25 +-
 src/statement.c                               |   2 +-
 tests/py/any/ct.t.json.output                 |  51 +-
 tests/py/any/ct.t.payload                     |  89 ++--
 tests/py/any/meta.t.json.output               |  54 ---
 tests/py/any/meta.t.payload                   | 232 ++++-----
 tests/py/any/meta.t.payload.bridge            |  10 +-
 tests/py/any/queue.t.json.output              |   4 +-
 tests/py/any/queue.t.payload                  |   2 +-
 tests/py/any/rawpayload.t.payload             |  64 +--
 tests/py/any/rt.t.payload                     |   5 +-
 tests/py/any/tcpopt.t.json                    |  24 +-
 tests/py/any/tcpopt.t.json.output             |   1 -
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
 tests/py/inet/osf.t.json                      |  12 +-
 tests/py/inet/osf.t.json.output               | 107 +++++
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
 tests/py/ip6/vmap.t                           |   2 +-
 tests/py/ip6/vmap.t.json                      |   2 +-
 tests/py/ip6/vmap.t.payload.inet              | 171 ++++---
 tests/py/ip6/vmap.t.payload.ip6               |  87 ++--
 tests/py/ip6/vmap.t.payload.netdev            | 171 ++++---
 tests/py/netdev/dup.t.payload                 |   3 +-
 tests/py/netdev/fwd.t.payload                 |   5 +-
 tests/py/netdev/reject.t.payload              |  41 +-
 tests/py/netdev/tunnel.t.payload              |   5 +-
 tests/py/nft-test.py                          | 138 +++---
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
 182 files changed, 5023 insertions(+), 4931 deletions(-)
 create mode 100644 tests/py/inet/osf.t.json.output
 create mode 100755 tests/py/tools/regen_payloads.sh

-- 
2.51.0

