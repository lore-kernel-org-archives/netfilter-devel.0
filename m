Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E2E27FD62
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236120; cv=none; b=oHBGdwPEjbSimns11LIq/PxrtxrXDBhRt5mKizfCU2OGQ5jNxhzrQ9RBmolL7yPGxkmfjcwuosuJTEPJMd9pZjbHWJ9jLHROQyl9Ie6QvpC6t2OiN2iVLjhIgkQDBoykRt/7Hy6PfWUD3mtSyE2LtbX7je9iBqskRxHI3sr9B6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236120; c=relaxed/simple;
	bh=qMdA6oY6qceY7Mh3tS2I1P06sYiwYD7GWa+Z8vWWK7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhJHhlLzj+FKjqt0S1lBWlLBcTOXJICWOpSoidqvjw2vINCbvV8DBTG3732yYr6224gIgg7xD+RQJvjfje5WjswyKXXT2+aTp/ZjXBiFIRPpzR0OdAUA8uP6k8rC21avX4tI1crZHjGtNjpHcpg9UA0bYRpAHwsvAt7uJ2vREUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SHPI28if; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SHPI28if"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8lJMxT4a/RyGTGFwL9MJw2MgPsAT/meonfrrUWwt87U=; b=SHPI28ifwz+P4kOLROv+nAxfJM
	iyQKzjI3rNdeyCERVweqkFuzdzL/k+K9qjQ15RBAOFpDHFOl/nhjdWF7PexKo/hHzKNvQ1gANqytp
	uiIj7wkSKFKneEZx27y6EFhfpuv4Lgosndjkauw1jn9F3GwI74TjpBxfbGSy+ftAN8fA6ZXoY0wjh
	Qomhx97H32n94lFFxkpNr45PrU+ZXrNpv2lz6vX6ig5xcLczQlL7P+LMie1V8OGjCaEwasByPtW4l
	nbVV765Kj5kd6BM9ZO+kl0KHawl8Z/9BZM8ByWb9fRVkpi1sINHhhNgTVfmfUoMUPha6yEjABGmEi
	6RCl1vVw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxe-0000000006v-47ok;
	Thu, 23 Oct 2025 18:14:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 25/28] tests: py: Update payload records
Date: Thu, 23 Oct 2025 18:14:14 +0200
Message-ID: <20251023161417.13228-26-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the bulk change.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/ct.t.payload               |  89 +++--
 tests/py/any/meta.t.payload             | 232 ++++++-------
 tests/py/any/meta.t.payload.bridge      |  10 +-
 tests/py/any/queue.t.payload            |   2 +-
 tests/py/any/rawpayload.t.payload       |  64 ++--
 tests/py/any/rt.t.payload               |   5 +-
 tests/py/any/tcpopt.t.payload           |  88 ++---
 tests/py/arp/arp.t.payload              |  99 +++---
 tests/py/arp/arp.t.payload.netdev       | 189 +++++-----
 tests/py/bridge/ether.t.payload         |  43 ++-
 tests/py/bridge/icmpX.t.payload         |  25 +-
 tests/py/bridge/meta.t.payload          |  20 +-
 tests/py/bridge/redirect.t.payload      |   2 +-
 tests/py/bridge/reject.t.payload        |  43 ++-
 tests/py/bridge/vlan.t.payload          | 262 +++++++-------
 tests/py/bridge/vlan.t.payload.netdev   | 316 ++++++++---------
 tests/py/inet/ah.t.payload              |  89 +++--
 tests/py/inet/comp.t.payload            |  53 ++-
 tests/py/inet/ct.t.payload              |  14 +-
 tests/py/inet/dccp.t.payload            |  53 ++-
 tests/py/inet/dnat.t.payload            |  47 ++-
 tests/py/inet/esp.t.payload             |  45 ++-
 tests/py/inet/ether-ip.t.payload        |  22 +-
 tests/py/inet/ether-ip.t.payload.netdev |  23 +-
 tests/py/inet/ether.t.payload           |  37 +-
 tests/py/inet/ether.t.payload.bridge    |  29 +-
 tests/py/inet/ether.t.payload.ip        |  37 +-
 tests/py/inet/fib.t.payload             |  12 +-
 tests/py/inet/geneve.t.payload          |  83 +++--
 tests/py/inet/gre.t.payload             |  53 ++-
 tests/py/inet/gretap.t.payload          |  59 ++--
 tests/py/inet/icmp.t.payload            |  37 +-
 tests/py/inet/icmpX.t.payload           |  32 +-
 tests/py/inet/ip.t.payload              |   4 +-
 tests/py/inet/ip.t.payload.bridge       |   4 +-
 tests/py/inet/ip.t.payload.inet         |   7 +-
 tests/py/inet/ip.t.payload.netdev       |   7 +-
 tests/py/inet/ip_tcp.t.payload          |  36 +-
 tests/py/inet/ip_tcp.t.payload.bridge   |  35 +-
 tests/py/inet/ip_tcp.t.payload.netdev   |  37 +-
 tests/py/inet/ipsec.t.payload           |  11 +-
 tests/py/inet/map.t.payload             |  11 +-
 tests/py/inet/map.t.payload.ip          |   7 +-
 tests/py/inet/map.t.payload.netdev      |  11 +-
 tests/py/inet/meta.t.payload            |  83 +++--
 tests/py/inet/osf.t.payload             |  16 +-
 tests/py/inet/payloadmerge.t.payload    |  43 ++-
 tests/py/inet/reject.t.payload.inet     |  43 ++-
 tests/py/inet/rt.t.payload              |   7 +-
 tests/py/inet/sctp.t.payload            | 159 +++++----
 tests/py/inet/sets.t.payload.bridge     |  15 +-
 tests/py/inet/sets.t.payload.inet       |  14 +-
 tests/py/inet/sets.t.payload.netdev     |  14 +-
 tests/py/inet/snat.t.payload            |  30 +-
 tests/py/inet/socket.t.payload          |   8 +-
 tests/py/inet/tcp.t.payload             | 360 +++++++++----------
 tests/py/inet/tproxy.t.payload          |  45 ++-
 tests/py/inet/udp.t.payload             | 112 +++---
 tests/py/inet/udplite.t.payload         |  81 +++--
 tests/py/inet/vmap.t.payload            |  13 +-
 tests/py/inet/vmap.t.payload.netdev     |  13 +-
 tests/py/inet/vxlan.t.payload           |  83 +++--
 tests/py/ip/ct.t.payload                |  46 +--
 tests/py/ip/dnat.t.payload.ip           | 117 ++++---
 tests/py/ip/dup.t.payload               |   7 +-
 tests/py/ip/ether.t.payload             |  37 +-
 tests/py/ip/hash.t.payload              |   2 +-
 tests/py/ip/icmp.t.payload.ip           | 312 ++++++++---------
 tests/py/ip/igmp.t.payload              |  61 ++--
 tests/py/ip/ip.t.payload                | 246 ++++++-------
 tests/py/ip/ip.t.payload.bridge         | 440 ++++++++++++------------
 tests/py/ip/ip.t.payload.inet           | 440 ++++++++++++------------
 tests/py/ip/ip.t.payload.netdev         | 434 +++++++++++------------
 tests/py/ip/ip_tcp.t.payload            |   9 +-
 tests/py/ip/masquerade.t.payload        |  71 ++--
 tests/py/ip/meta.t.payload              |  32 +-
 tests/py/ip/numgen.t.payload            |   4 +-
 tests/py/ip/objects.t.payload           |  26 +-
 tests/py/ip/redirect.t.payload          | 121 ++++---
 tests/py/ip/reject.t.payload            |   3 +-
 tests/py/ip/rt.t.payload                |   3 +-
 tests/py/ip/sets.t.payload.inet         |  38 +-
 tests/py/ip/sets.t.payload.ip           |  12 +-
 tests/py/ip/sets.t.payload.netdev       |  38 +-
 tests/py/ip/snat.t.payload              |  74 ++--
 tests/py/ip/tcp.t.payload               |  11 +-
 tests/py/ip/tproxy.t.payload            |  29 +-
 tests/py/ip6/ct.t.payload               |  12 +-
 tests/py/ip6/dnat.t.payload.ip6         |  38 +-
 tests/py/ip6/dst.t.payload.inet         |  60 ++--
 tests/py/ip6/dst.t.payload.ip6          |  30 +-
 tests/py/ip6/dup.t.payload              |   7 +-
 tests/py/ip6/ether.t.payload            |  36 +-
 tests/py/ip6/exthdr.t.payload.ip6       |  25 +-
 tests/py/ip6/frag.t.payload.inet        | 131 ++++---
 tests/py/ip6/frag.t.payload.ip6         |  75 ++--
 tests/py/ip6/frag.t.payload.netdev      | 131 ++++---
 tests/py/ip6/hbh.t.payload.inet         |  65 ++--
 tests/py/ip6/hbh.t.payload.ip6          |  33 +-
 tests/py/ip6/icmpv6.t.payload.ip6       | 322 ++++++++---------
 tests/py/ip6/ip6.t.payload.inet         | 359 ++++++++++---------
 tests/py/ip6/ip6.t.payload.ip6          | 191 +++++-----
 tests/py/ip6/map.t.payload              |   5 +-
 tests/py/ip6/masquerade.t.payload.ip6   |  71 ++--
 tests/py/ip6/meta.t.payload             |  36 +-
 tests/py/ip6/mh.t.payload.inet          | 132 +++----
 tests/py/ip6/mh.t.payload.ip6           |  66 ++--
 tests/py/ip6/redirect.t.payload.ip6     | 105 +++---
 tests/py/ip6/reject.t.payload.ip6       |   3 +-
 tests/py/ip6/rt.t.payload.inet          | 121 ++++---
 tests/py/ip6/rt.t.payload.ip6           |  61 ++--
 tests/py/ip6/rt0.t.payload              |   3 +-
 tests/py/ip6/sets.t.payload.inet        |  18 +-
 tests/py/ip6/sets.t.payload.ip6         |   4 +-
 tests/py/ip6/sets.t.payload.netdev      |  18 +-
 tests/py/ip6/snat.t.payload.ip6         |  23 +-
 tests/py/ip6/srh.t.payload              |  23 +-
 tests/py/ip6/tproxy.t.payload           |  29 +-
 tests/py/ip6/vmap.t.payload.inet        | 169 +++++----
 tests/py/ip6/vmap.t.payload.ip6         |  85 +++--
 tests/py/ip6/vmap.t.payload.netdev      | 169 +++++----
 tests/py/netdev/dup.t.payload           |   3 +-
 tests/py/netdev/fwd.t.payload           |   5 +-
 tests/py/netdev/reject.t.payload        |  41 ++-
 tests/py/netdev/tunnel.t.payload        |   5 +-
 125 files changed, 4385 insertions(+), 4461 deletions(-)

diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 645041341ca86..ae4e0ec344876 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -12,7 +12,7 @@ ip test-ip4 output
 # ct state {new,established, related, untracked}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000040  : 0 [end]
+	element 00000008	element 00000002	element 00000004	element 00000040
 ip test-ip4 output
   [ ct load state => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -20,7 +20,7 @@ ip test-ip4 output
 # ct state != {new,established, related, untracked}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000040  : 0 [end]
+	element 00000008	element 00000002	element 00000004	element 00000040
 ip test-ip4 output
   [ ct load state => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -48,27 +48,27 @@ ip test-ip4 output
 # ct direction original
 ip test-ip4 output
   [ ct load direction => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # ct direction != original
 ip test-ip4 output
   [ ct load direction => reg 1 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ cmp neq reg 1 0x00 ]
 
 # ct direction reply
 ip test-ip4 output
   [ ct load direction => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # ct direction != reply
 ip test-ip4 output
   [ ct load direction => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # ct direction {reply, original}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000000  : 0 [end]
+	element 01	element 00
 ip test-ip4 output
   [ ct load direction => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -76,7 +76,7 @@ ip test-ip4 output
 # ct direction != {reply, original}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000000  : 0 [end]
+	element 01	element 00
 ip test-ip4 output
   [ ct load direction => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -106,7 +106,7 @@ ip test-ip4 output
 # ct status {expected, seen-reply, assured, confirmed, dying}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000200  : 0 [end]
+	element 00000001	element 00000002	element 00000004	element 00000008	element 00000200
 ip test-ip4 output
   [ ct load status => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -114,7 +114,7 @@ ip test-ip4 output
 # ct status != {expected, seen-reply, assured, confirmed, dying}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000200  : 0 [end]
+	element 00000001	element 00000002	element 00000004	element 00000008	element 00000200
 ip test-ip4 output
   [ ct load status => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -172,18 +172,18 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0x32000000 0x45000000 ]
+  [ range eq reg 1 0x00000032 0x00000045 ]
 
 # ct mark != 0x00000032-0x00000045
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0x32000000 0x45000000 ]
+  [ range neq reg 1 0x00000032 0x00000045 ]
 
 # ct mark {0x32, 0x2222, 0x42de3}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000032  : 0 [end]	element 00002222  : 0 [end]	element 00042de3  : 0 [end]
+	element 00000032	element 00002222	element 00042de3
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -191,7 +191,7 @@ ip test-ip4 output
 # ct mark {0x32-0x2222, 0x4444-0x42de3}
 __set%d test-ip4 7
 __set%d test-ip4 0
-        element 00000000  : 1 [end]     element 32000000  : 0 [end]     element 23220000  : 1 [end]     element 44440000  : 0 [end]     element e42d0400  : 1 [end]
+	element 00000000 flags 1	element 00000032	element 00002223 flags 1	element 00004444	element 00042de4 flags 1
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -200,7 +200,7 @@ ip test-ip4 output
 # ct mark != {0x32, 0x2222, 0x42de3}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000032  : 0 [end]	element 00002222  : 0 [end]	element 00042de3  : 0 [end]
+	element 00000032	element 00002222	element 00042de3
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -239,13 +239,13 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0x60ea0000 0x80ee3600 ]
+  [ range eq reg 1 0x0000ea60 0x0036ee80 ]
 
 # ct expiration > 4d23h59m59s
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gt reg 1 0x18c8bf19 ]
+  [ cmp gt reg 1 0x19bfc818 ]
 
 # ct expiration != 233
 ip test-ip4 output
@@ -256,18 +256,18 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0xe8800000 0xc8af0000 ]
+  [ range eq reg 1 0x000080e8 0x0000afc8 ]
 
 # ct expiration != 33-45
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0xe8800000 0xc8af0000 ]
+  [ range neq reg 1 0x000080e8 0x0000afc8 ]
 
 # ct expiration {33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 000080e8  : 0 [end]	element 0000d6d8  : 0 [end]	element 000105b8  : 0 [end]	element 000157c0  : 0 [end]
+	element 000080e8	element 0000d6d8	element 000105b8	element 000157c0
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -275,7 +275,7 @@ ip test-ip4 output
 # ct expiration != {33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 000080e8  : 0 [end]	element 0000d6d8  : 0 [end]	element 000105b8  : 0 [end]	element 000157c0  : 0 [end]
+	element 000080e8	element 0000d6d8	element 000105b8	element 000157c0
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -283,7 +283,7 @@ ip test-ip4 output
 # ct expiration {33-55, 66-88}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element e8800000  : 0 [end]	element d9d60000  : 1 [end]	element d0010100  : 0 [end]	element c1570100  : 1 [end]
+	element 00000000 flags 1	element 000080e8	element 0000d6d9 flags 1	element 000101d0	element 000157c1 flags 1
 ip test-ip4 output 
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -292,7 +292,7 @@ ip test-ip4 output
 # ct expiration != {33-55, 66-88}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element e8800000  : 0 [end]	element d9d60000  : 1 [end]	element d0010100  : 0 [end]	element c1570100  : 1 [end]
+	element 00000000 flags 1	element 000080e8	element 0000d6d9 flags 1	element 000101d0	element 000157c1 flags 1
 ip test-ip4 output 
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -301,12 +301,12 @@ ip test-ip4 output
 # ct helper "ftp"
 ip test-ip4 output
   [ ct load helper => reg 1 ]
-  [ cmp eq reg 1 0x00707466 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x66747000 0x00000000 0x00000000 0x00000000 ]
 
 # ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008 12345678  : 0 [end]	element 00000008 34127856  : 0 [end]	element 00000002 12785634  : 0 [end]
+	element 00000008 . 12345678	element 00000008 . 34127856	element 00000002 . 12785634
 ip test-ip4 output
   [ ct load state => reg 1 ]
   [ ct load mark => reg 9 ]
@@ -327,7 +327,7 @@ inet test-inet output
 # ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 }
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 00000001  : 0000000a 0 [end]    element 00000002  : 00000014 0 [end]    element 00000003  : 0000001e 0 [end]
+	element 00000001 : 0000000a	element 00000002 : 00000014	element 00000003 : 0000001e
 ip test-ip4 output
   [ meta load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -346,31 +346,31 @@ ip
 ip test-ip4 output
   [ ct load bytes => reg 1 , dir original ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp gt reg 1 0x00000000 0xa0860100 ]
+  [ cmp gt reg 1 0x00000000 0x000186a0 ]
 
 # ct reply packets < 100
 ip test-ip4 output
   [ ct load packets => reg 1 , dir reply ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp lt reg 1 0x00000000 0x64000000 ]
+  [ cmp lt reg 1 0x00000000 0x00000064 ]
 
 # ct bytes > 100000
 ip test-ip4 output
   [ ct load bytes => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp gt reg 1 0x00000000 0xa0860100 ]
+  [ cmp gt reg 1 0x00000000 0x000186a0 ]
 
 # ct avgpkt > 200
 ip test-ip4 output
   [ ct load avgpkt => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp gt reg 1 0x00000000 0xc8000000 ]
+  [ cmp gt reg 1 0x00000000 0x000000c8 ]
 
 # ct original avgpkt < 500
 ip test-ip4 output
   [ ct load avgpkt => reg 1 , dir original ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp lt reg 1 0x00000000 0xf4010000 ]
+  [ cmp lt reg 1 0x00000000 0x000001f4 ]
 
 # ct status expected,seen-reply,assured,confirmed,snat,dnat,dying
 ip test-ip4 output
@@ -423,53 +423,53 @@ ip test-ip4 output
 # ct label 127
 ip test-ip4 output
   [ ct load label => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000000 0x00000000 0x00000000 0x80000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x80000000 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
   [ cmp neq reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
 
 # ct label set 127
 ip test-ip4 output
-  [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x80000000 ]
+  [ immediate reg 1 0x80000000 0x00000000 0x00000000 0x00000000 ]
   [ ct set label with reg 1 ]
 
 # ct zone 0
 ip test-ip4 output
   [ ct load zone => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0000 ]
 
 # ct zone 23
 ip test-ip4 output
   [ ct load zone => reg 1 ]
-  [ cmp eq reg 1 0x00000017 ]
+  [ cmp eq reg 1 0x0017 ]
 
 # ct original zone 1
 ip test-ip4 output
   [ ct load zone => reg 1 , dir original ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # ct reply zone 1
 ip test-ip4 output
   [ ct load zone => reg 1 , dir reply ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # ct zone set 1
 ip test-ip4 output
-  [ immediate reg 1 0x00000001 ]
+  [ immediate reg 1 0x0001 ]
   [ ct set zone with reg 1 ]
 
 # ct original zone set 1
 ip test-ip4 output
-  [ immediate reg 1 0x00000001 ]
+  [ immediate reg 1 0x0001 ]
   [ ct set zone with reg 1 , dir original ]
 
 # ct reply zone set 1
 ip test-ip4 output
-  [ immediate reg 1 0x00000001 ]
+  [ immediate reg 1 0x0001 ]
   [ ct set zone with reg 1 , dir reply ]
 
 # ct zone set mark map { 1 : 1,  2 : 2 }
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 00000001  : 00000001 0 [end]    element 00000002  : 00000002 0 [end]
+	element 00000001 : 0001	element 00000002 : 0002
 ip test-ip4 output
   [ meta load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -482,7 +482,7 @@ ip test-ip4 output
 # ct direction . ct mark { original . 0x12345678, reply . 0x87654321}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-	element 00000000 12345678  : 0 [end]	element 00000001 87654321  : 0 [end]
+	element 00 . 12345678	element 01 . 87654321
 ip test-ip4 output 
   [ ct load direction => reg 1 ]
   [ ct load mark => reg 9 ]
@@ -491,7 +491,7 @@ ip test-ip4 output
 # ct state . ct mark vmap { new . 0x12345678 : drop, established . 0x87654321 : accept}
 __map%d test-ip4 b size 2
 __map%d test-ip4 0
-	element 00000008 12345678  : drop 0 [end]	element 00000002 87654321  : accept 0 [end]
+	element 00000008 . 12345678 : drop	element 00000002 . 87654321 : accept
 ip test-ip4 output 
   [ ct load state => reg 1 ]
   [ ct load mark => reg 9 ]
@@ -512,7 +512,7 @@ ip test-ip4 output
 # ct id 12345
 ip test-ip4 output
   [ ct load id => reg 1 ]
-  [ cmp eq reg 1 0x39300000 ]
+  [ cmp eq reg 1 0x00003039 ]
 
 # ct status ! dnat
 ip6
@@ -527,4 +527,3 @@ ip test-ip4 output
 # ct count over 3
 ip test-ip4 output
   [ connlimit count 3 flags 1 ]
-
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 3f9f3f22aecf9..a031148e5adfa 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -17,18 +17,18 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # meta length != 33-45
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # meta length { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -36,7 +36,7 @@ ip test-ip4 input
 # meta length { 33-55, 67-88}
 __set%d test-ip4 7
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]	element 43000000  : 0 [end]	element 59000000  : 1 [end]
+	element 00000000 flags 1	element 00000021	element 00000038 flags 1	element 00000043	element 00000059 flags 1
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -45,7 +45,7 @@ ip test-ip4 input
 # meta length { 33-55, 56-88, 100-120}
 __set%d test-ip4 7
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 59000000  : 1 [end]	element 64000000  : 0 [end]	element 79000000  : 1 [end]
+	element 00000000 flags 1	element 00000021	element 00000059 flags 1	element 00000064	element 00000079 flags 1
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -54,7 +54,7 @@ ip test-ip4 input
 # meta length != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -62,7 +62,7 @@ ip test-ip4 input
 # meta protocol { ip, arp, ip6, vlan }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000608  : 0 [end]	element 0000dd86  : 0 [end]	element 00000081  : 0 [end]
+	element 0800	element 0806	element 86dd	element 8100
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -70,7 +70,7 @@ ip test-ip4 input
 # meta protocol != {ip, arp, ip6, 8021q}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000608  : 0 [end]	element 0000dd86  : 0 [end]	element 00000081  : 0 [end]
+	element 0800	element 0806	element 86dd	element 8100
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -78,37 +78,37 @@ ip test-ip4 input
 # meta protocol ip
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
 
 # meta protocol != ip
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
-  [ cmp neq reg 1 0x00000008 ]
+  [ cmp neq reg 1 0x0800 ]
 
 # meta l4proto 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # meta l4proto != 233
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # meta l4proto 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # meta l4proto != 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # meta l4proto { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -116,7 +116,7 @@ ip test-ip4 input
 # meta l4proto != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -196,17 +196,17 @@ ip test-ip4 input
 # meta iifname "dummy0"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x64756d6d 0x79300000 0x00000000 0x00000000 ]
 
 # meta iifname != "dummy0"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp neq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
+  [ cmp neq reg 1 0x64756d6d 0x79300000 0x00000000 0x00000000 ]
 
 # meta iifname {"dummy0", "lo"}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 6d6d7564 00003079 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
+	element 64756d6d 79300000 00000000 00000000	element 6c6f0000 00000000 00000000 00000000
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -214,7 +214,7 @@ ip test-ip4 input
 # meta iifname != {"dummy0", "lo"}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 6d6d7564 00003079 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
+	element 64756d6d 79300000 00000000 00000000	element 6c6f0000 00000000 00000000 00000000
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -222,17 +222,17 @@ ip test-ip4 input
 # meta iifname "dummy*"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x6d6d7564 0x00000079 ]
+  [ cmp eq reg 1 0x64756d6d 0x79 ]
 
 # meta iifname "dummy\*"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x6d6d7564 0x00002a79 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x64756d6d 0x792a0000 0x00000000 0x00000000 ]
 
 # meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
+	element 0001	element 0200	element 0300	element 0301	element 0304	element 0308	element 030a
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -240,7 +240,7 @@ ip test-ip4 input
 # meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
+	element 0001	element 0200	element 0300	element 0301	element 0304	element 0308	element 030a
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -248,22 +248,22 @@ ip test-ip4 input
 # meta iiftype != ether
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x0001 ]
 
 # meta iiftype ether
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # meta iiftype != ppp
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp neq reg 1 0x00000200 ]
+  [ cmp neq reg 1 0x0200 ]
 
 # meta iiftype ppp
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ cmp eq reg 1 0x0200 ]
 
 # meta oif "lo" accept
 ip test-ip4 input
@@ -280,17 +280,17 @@ ip test-ip4 input
 # meta oifname "dummy0"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x64756d6d 0x79300000 0x00000000 0x00000000 ]
 
 # meta oifname != "dummy0"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp neq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
+  [ cmp neq reg 1 0x64756d6d 0x79300000 0x00000000 0x00000000 ]
 
 # meta oifname { "dummy0", "lo"}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 6d6d7564 00003079 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
+	element 64756d6d 79300000 00000000 00000000	element 6c6f0000 00000000 00000000 00000000
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -298,17 +298,17 @@ ip test-ip4 input
 # meta oifname "dummy*"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x6d6d7564 0x00000079 ]
+  [ cmp eq reg 1 0x64756d6d 0x79 ]
 
 # meta oifname "dummy\*"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x6d6d7564 0x00002a79 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x64756d6d 0x792a0000 0x00000000 0x00000000 ]
 
 # meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
+	element 0001	element 0200	element 0300	element 0301	element 0304	element 0308	element 030a
 ip test-ip4 input
   [ meta load oiftype => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -316,7 +316,7 @@ ip test-ip4 input
 # meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
+	element 0001	element 0200	element 0300	element 0301	element 0304	element 0308	element 030a
 ip test-ip4 input
   [ meta load oiftype => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -324,17 +324,17 @@ ip test-ip4 input
 # meta oiftype != ether
 ip test-ip4 input
   [ meta load oiftype => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x0001 ]
 
 # meta oiftype ether
 ip test-ip4 input
   [ meta load oiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # meta skuid {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
+	element 00000001	element 00000000	element 00000002
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -343,7 +343,7 @@ ip test-ip4 input
 # meta skuid != {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
+	element 00000001	element 00000000	element 00000002
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -363,14 +363,14 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0xb80b0000 ]
+  [ cmp lt reg 1 0x00000bb8 ]
   [ immediate reg 0 accept ]
 
 # meta skuid gt 3000 accept
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gt reg 1 0xb80b0000 ]
+  [ cmp gt reg 1 0x00000bb8 ]
   [ immediate reg 0 accept ]
 
 # meta skuid eq 3000 accept
@@ -383,20 +383,20 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0xb90b0000 0xbd0b0000 ]
+  [ range eq reg 1 0x00000bb9 0x00000bbd ]
   [ immediate reg 0 accept ]
 
 # meta skuid != 2001-2005 accept
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0xd1070000 0xd5070000 ]
+  [ range neq reg 1 0x000007d1 0x000007d5 ]
   [ immediate reg 0 accept ]
 
 # meta skgid {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
+	element 00000001	element 00000000	element 00000002
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -405,7 +405,7 @@ ip test-ip4 input
 # meta skgid != {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
+	element 00000001	element 00000000	element 00000002
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -425,14 +425,14 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0xb80b0000 ]
+  [ cmp lt reg 1 0x00000bb8 ]
   [ immediate reg 0 accept ]
 
 # meta skgid gt 3000 accept
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gt reg 1 0xb80b0000 ]
+  [ cmp gt reg 1 0x00000bb8 ]
   [ immediate reg 0 accept ]
 
 # meta skgid eq 3000 accept
@@ -445,14 +445,14 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0xd1070000 0xd5070000 ]
+  [ range eq reg 1 0x000007d1 0x000007d5 ]
   [ immediate reg 0 accept ]
 
 # meta skgid != 2001-2005 accept
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0xd1070000 0xd5070000 ]
+  [ range neq reg 1 0x000007d1 0x000007d5 ]
   [ immediate reg 0 accept ]
 
 # meta mark set 0xffffffc8 xor 0x16
@@ -508,7 +508,7 @@ ip test-ip4 input
 # meta oifname "dummy2" accept
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x6d6d7564 0x00003279 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x64756d6d 0x79320000 0x00000000 0x00000000 ]
   [ immediate reg 0 accept ]
 
 # meta skuid 3000
@@ -529,37 +529,37 @@ ip test-ip4 input
 # meta pkttype broadcast
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # meta pkttype host
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # meta pkttype multicast
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
 
 # meta pkttype != broadcast
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # meta pkttype != host
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ cmp neq reg 1 0x00 ]
 
 # meta pkttype != multicast
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ cmp neq reg 1 0x02 ]
 
 # pkttype { broadcast, multicast} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000002  : 0 [end]
+	element 01	element 02
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -579,18 +579,18 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0x01000000 0x03000000 ]
+  [ range eq reg 1 0x00000001 0x00000003 ]
 
 # meta cpu != 1-2
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0x01000000 0x02000000 ]
+  [ range neq reg 1 0x00000001 0x00000002 ]
 
 # meta cpu { 2,3}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000002  : 0 [end]	element 00000003  : 0 [end]
+	element 00000002	element 00000003
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -598,7 +598,7 @@ ip test-ip4 input
 # meta cpu != { 2,3}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000002  : 0 [end]	element 00000003  : 0 [end]
+	element 00000002	element 00000003
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -606,7 +606,7 @@ ip test-ip4 input
 # meta cpu { 2-3, 5-7}
 __set%d test-ip4 7
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 02000000  : 0 [end]	element 04000000  : 1 [end]	element 05000000  : 0 [end]	element 08000000  : 1 [end]
+	element 00000000 flags 1	element 00000002	element 00000004 flags 1	element 00000005	element 00000008 flags 1
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -635,7 +635,7 @@ ip test-ip4 input
 # meta iifgroup { 11,33}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+	element 0000000b	element 00000021
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -663,7 +663,7 @@ ip test-ip4 input
 # meta oifgroup { 11,33}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+	element 0000000b	element 00000021
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -681,7 +681,7 @@ ip test-ip4 input
 # meta cgroup { 1048577, 1048578 }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00100001  : 0 [end]	element 00100002  : 0 [end]
+	element 00100001	element 00100002
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -689,7 +689,7 @@ ip test-ip4 input
 # meta cgroup != { 1048577, 1048578}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00100001  : 0 [end]	element 00100002  : 0 [end]
+	element 00100001	element 00100002
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -698,18 +698,18 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0x01001000 0x02001000 ]
+  [ range eq reg 1 0x00100001 0x00100002 ]
 
 # meta cgroup != 1048577-1048578
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0x01001000 0x02001000 ]
+  [ range neq reg 1 0x00100001 0x00100002 ]
 
 # meta iif . meta oif { "lo" . "lo" }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001 00000001  : 0 [end]
+	element 00000001 . 00000001
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
@@ -718,7 +718,7 @@ ip test-ip4 output
 # meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001 00000001 0000000a  : 0 [end]
+	element 00000001 . 00000001 . 0000000a
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
@@ -728,7 +728,7 @@ ip test-ip4 output
 # meta iif . meta oif vmap { "lo" . "lo" : drop }
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000001 00000001  : drop 0 [end]
+	element 00000001 . 00000001 : drop
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
@@ -737,12 +737,12 @@ ip test-ip4 output
 # meta random eq 1
 ip test-ip4 input
   [ meta load prandom => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # meta random gt 1000000
 ip test-ip4 input
   [ meta load prandom => reg 1 ]
-  [ cmp gt reg 1 0x40420f00 ]
+  [ cmp gt reg 1 0x000f4240 ]
 
 # meta priority root
 ip test-ip4 input
@@ -783,18 +783,18 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0xdadaadbc 0xdcdaadbc ]
+  [ range eq reg 1 0xbcaddada 0xbcaddadc ]
 
 # meta priority != bcad:dada-bcad:dadc
 ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0xdadaadbc 0xdcdaadbc ]
+  [ range neq reg 1 0xbcaddada 0xbcaddadc ]
 
 # meta priority {bcad:dada, bcad:dadc, aaaa:bbbb}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element bcaddada  : 0 [end]	element bcaddadc  : 0 [end]	element aaaabbbb  : 0 [end]
+	element bcaddada	element bcaddadc	element aaaabbbb
 ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -807,7 +807,7 @@ ip test-ip4 input
 # meta priority != {bcad:dada, bcad:dadc, aaaa:bbbb}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element bcaddada  : 0 [end]	element bcaddadc  : 0 [end]	element aaaabbbb  : 0 [end]
+	element bcaddada	element bcaddadc	element aaaabbbb
 ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -825,7 +825,7 @@ ip test-ip4 input
 # meta length { 33-55, 66-88}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]	element 42000000  : 0 [end]	element 59000000  : 1 [end]
+	element 00000000 flags 1	element 00000021	element 00000038 flags 1	element 00000042	element 00000059 flags 1
 ip test-ip4 input 
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -834,7 +834,7 @@ ip test-ip4 input
 # meta length != { 33-55, 66-88}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]	element 42000000  : 0 [end]	element 59000000  : 1 [end]
+	element 00000000 flags 1	element 00000021	element 00000038 flags 1	element 00000042	element 00000059 flags 1
 ip test-ip4 input 
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -843,7 +843,7 @@ ip test-ip4 input
 # meta l4proto { 33-55, 66-88}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]	element 00000042  : 0 [end]	element 00000059  : 1 [end]
+	element 00 flags 1	element 21	element 38 flags 1	element 42	element 59 flags 1
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -851,7 +851,7 @@ ip test-ip4 input
 # meta l4proto != { 33-55, 66-88}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]	element 00000042  : 0 [end]	element 00000059  : 1 [end]
+	element 00 flags 1	element 21	element 38 flags 1	element 42	element 59 flags 1
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -859,7 +859,7 @@ ip test-ip4 input
 # meta skuid { 2001-2005, 3001-3005} accept
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]	element b90b0000  : 0 [end]	element be0b0000  : 1 [end]
+	element 00000000 flags 1	element 000007d1	element 000007d6 flags 1	element 00000bb9	element 00000bbe flags 1
 ip test-ip4 input 
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -869,7 +869,7 @@ ip test-ip4 input
 # meta iifgroup {"default", 11}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+	element 00000000	element 0000000b
 ip test-ip4 input 
   [ meta load iifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -877,7 +877,7 @@ ip test-ip4 input
 # meta iifgroup != {"default", 11}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+	element 00000000	element 0000000b
 ip test-ip4 input 
   [ meta load iifgroup => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -885,7 +885,7 @@ ip test-ip4 input
 # meta iifgroup {11-33, 44-55}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+	element 00000000 flags 1	element 0000000b	element 00000022 flags 1	element 0000002c	element 00000038 flags 1
 ip test-ip4 input 
   [ meta load iifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -894,7 +894,7 @@ ip test-ip4 input
 # meta iifgroup != { 11,33}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+	element 0000000b	element 00000021
 ip test-ip4 input 
   [ meta load iifgroup => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -902,7 +902,7 @@ ip test-ip4 input
 # meta iifgroup != {11-33, 44-55}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+	element 00000000 flags 1	element 0000000b	element 00000022 flags 1	element 0000002c	element 00000038 flags 1
 ip test-ip4 input 
   [ meta load iifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -911,7 +911,7 @@ ip test-ip4 input
 # meta oifgroup {"default", 11}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+	element 00000000	element 0000000b
 ip test-ip4 input 
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -919,7 +919,7 @@ ip test-ip4 input
 # meta oifgroup {11-33, 44-55}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+	element 00000000 flags 1	element 0000000b	element 00000022 flags 1	element 0000002c	element 00000038 flags 1
 ip test-ip4 input 
   [ meta load oifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -928,7 +928,7 @@ ip test-ip4 input
 # meta oifgroup != { 11,33}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+	element 0000000b	element 00000021
 ip test-ip4 input 
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -936,7 +936,7 @@ ip test-ip4 input
 # meta oifgroup != {11-33, 44-55}
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+	element 00000000 flags 1	element 0000000b	element 00000022 flags 1	element 0000002c	element 00000038 flags 1
 ip test-ip4 input 
   [ meta load oifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -945,7 +945,7 @@ ip test-ip4 input
 # meta skuid != { 2001-2005, 3001-3005} accept
 __set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]	element b90b0000  : 0 [end]	element be0b0000  : 1 [end]
+	element 00000000 flags 1	element 000007d1	element 000007d6 flags 1	element 00000bb9	element 00000bbe flags 1
 ip test-ip4 input 
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
@@ -955,7 +955,7 @@ ip test-ip4 input
 # meta oifgroup != {"default", 11}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+	element 00000000	element 0000000b
 ip test-ip4 input 
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -963,63 +963,63 @@ ip test-ip4 input
 # meta time "1970-05-23 21:07:14" drop
 ip meta-test input
   [ meta load time => reg 1 ]
-  [ cmp eq reg 1 0x43f05400 0x002bd503 ]
+  [ cmp eq reg 1 0x002bd503 0x43f05400 ]
   [ immediate reg 0 drop ]
 
 # meta time 12341234 drop
 ip meta-test input
   [ meta load time => reg 1 ]
-  [ cmp eq reg 1 0x74a8f400 0x002bd849 ]
+  [ cmp eq reg 1 0x002bd849 0x74a8f400 ]
   [ immediate reg 0 drop ]
 
 # meta time "2019-06-21 17:00:00" drop
 ip meta-test input
   [ meta load time => reg 1 ]
-  [ cmp eq reg 1 0x767d6000 0x15aa3ebc ]
+  [ cmp eq reg 1 0x15aa3ebc 0x767d6000 ]
   [ immediate reg 0 drop ]
 
 # meta time "2019-07-01 00:00:00" drop
 ip meta-test input
   [ meta load time => reg 1 ]
-  [ cmp eq reg 1 0xe750c000 0x15ad18e0 ]
+  [ cmp eq reg 1 0x15ad18e0 0xe750c000 ]
   [ immediate reg 0 drop ]
 
 # meta time "2019-07-01 00:01:00" drop
 ip meta-test input
   [ meta load time => reg 1 ]
-  [ cmp eq reg 1 0xdf981800 0x15ad18ee ]
+  [ cmp eq reg 1 0x15ad18ee 0xdf981800 ]
   [ immediate reg 0 drop ]
 
 # meta time "2019-07-01 00:00:01" drop
 ip meta-test input
   [ meta load time => reg 1 ]
-  [ cmp eq reg 1 0x22eb8a00 0x15ad18e1 ]
+  [ cmp eq reg 1 0x15ad18e1 0x22eb8a00 ]
   [ immediate reg 0 drop ]
 
 # meta time < "2022-07-01 11:00:00" accept
 ip test-ip4 input
   [ meta load time => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp lt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ cmp lt reg 1 0x16fda8f3 0x1977a000 ]
   [ immediate reg 0 accept ]
 
 # meta time > "2022-07-01 11:00:00" accept
 ip test-ip4 input
   [ meta load time => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp gt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ cmp gt reg 1 0x16fda8f3 0x1977a000 ]
   [ immediate reg 0 accept ]
 
 # meta day "Saturday" drop
 ip test-ip4 input
   [ meta load day => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ immediate reg 0 drop ]
 
 # meta day 6 drop
 ip test-ip4 input
   [ meta load day => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ immediate reg 0 drop ]
 
 # meta hour "17:00" drop
@@ -1079,66 +1079,66 @@ ip test-ip4 input
 # meta hour "00:00"-"02:02" drop
   [ meta load hour => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0x78000000 0x60350100 ]
+  [ range neq reg 1 0x00000078 0x00013560 ]
   [ immediate reg 0 drop ]
 
 # meta hour "01:01"-"03:03" drop
 ip test-ip4 input
   [ meta load hour => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0xc40e0000 0xac430100 ]
+  [ range neq reg 1 0x00000ec4 0x000143ac ]
   [ immediate reg 0 drop ]
 
 # meta hour "02:02"-"04:04" drop
 ip test-ip4 input
   [ meta load hour => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range eq reg 1 0x78000000 0x101d0000 ]
+  [ range eq reg 1 0x00000078 0x00001d10 ]
   [ immediate reg 0 drop ]
 
 # meta hour "21:00"-"02:00" drop
 ip test-ip4 input
   [ meta load hour => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ range neq reg 1 0x00000000 0x300b0100 ]
+  [ range neq reg 1 0x00000000 0x00010b30 ]
   [ immediate reg 0 drop ]
 
 # time < "2022-07-01 11:00:00" accept
 ip test-ip4 input
   [ meta load time => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp lt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ cmp lt reg 1 0x16fda8f3 0x1977a000 ]
   [ immediate reg 0 accept ]
 
 # time > "2022-07-01 11:00:00" accept
 ip test-ip4 input
   [ meta load time => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
-  [ cmp gt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ cmp gt reg 1 0x16fda8f3 0x1977a000 ]
   [ immediate reg 0 accept ]
 
 # meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }
 __map%d test-ip4 b size 2
 __map%d test-ip4 0
-	element 00000100  : 00000001 0 [end]	element 0000ff0f  : 00004095 0 [end]
+	element 0001 : 00000001	element 0fff : 00004095
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
 # meta mark set vlan id map @map1
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set map1 dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/any/meta.t.payload.bridge b/tests/py/any/meta.t.payload.bridge
index 5997ccc7ba52b..b4e7ba374b4f0 100644
--- a/tests/py/any/meta.t.payload.bridge
+++ b/tests/py/any/meta.t.payload.bridge
@@ -1,20 +1,20 @@
 # meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }
 __map%d test-bridge b size 2
 __map%d test-bridge 0
-	element 00000100  : 00000001 0 [end]	element 0000ff0f  : 00004095 0 [end]
+	element 0001 : 00000001	element 0fff : 00004095
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
 # meta mark set vlan id map @map1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set map1 dreg 1 ]
   [ meta set mark with reg 1 ]
diff --git a/tests/py/any/queue.t.payload b/tests/py/any/queue.t.payload
index 2f221930a1efc..b3b5dc051cdb2 100644
--- a/tests/py/any/queue.t.payload
+++ b/tests/py/any/queue.t.payload
@@ -50,7 +50,7 @@ ip
 # queue flags bypass to oifname map { "eth0" : 0, "ppp0" : 2, "eth1" : 2 }
 __map%d test-ip4 b size 3
 __map%d test-ip4 0
-	element 30687465 00000000 00000000 00000000  : 00000000 0 [end]	element 30707070 00000000 00000000 00000000  : 00000002 0 [end]	element 31687465 00000000 00000000 00000000  : 00000002 0 [end]
+	element 65746830 00000000 00000000 00000000 : 0000	element 70707030 00000000 00000000 00000000 : 0002	element 65746831 00000000 00000000 00000000 : 0002
 ip
   [ meta load oifname => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index dfc651e2886a9..2d6ae565ea229 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -1,10 +1,10 @@
 # meta l4proto { tcp, udp, sctp} @th,16,16 { 22, 23, 80 }
 __set%d test-inet 3 size 3
 __set%d test-inet 0
-	element 00000006  : 0 [end]	element 00000011  : 0 [end]	element 00000084  : 0 [end]
+	element 06	element 11	element 84
 __set%d test-inet 3 size 3
 __set%d test-inet 0
-	element 00001600  : 0 [end]	element 00001700  : 0 [end]	element 00005000  : 0 [end]
+	element 0016	element 0017	element 0050
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -14,105 +14,105 @@ inet test-inet input
 # meta l4proto tcp @th,16,16 { 22, 23, 80}
 __set%d test-inet 3 size 3
 __set%d test-inet 0
-	element 00001600  : 0 [end]	element 00001700  : 0 [end]	element 00005000  : 0 [end]
+	element 0016	element 0017	element 0050
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # @nh,8,8 0xff
 inet test-inet input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x000000ff ]
+  [ cmp eq reg 1 0xff ]
 
 # @nh,8,16 0x0
 inet test-inet input
   [ payload load 2b @ network header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0000 ]
 
 # @ll,0,1 1
 inet test-inet input
   [ payload load 1b @ link header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ bitwise reg 1 = ( reg 1 & 0x80 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x80 ]
 
 # @ll,0,8 & 0x80 == 0x80
 inet test-inet input
   [ payload load 1b @ link header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ bitwise reg 1 = ( reg 1 & 0x80 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x80 ]
 
 # @ll,0,128 0xfedcba987654321001234567890abcde
 inet test-inet input
   [ payload load 16b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x98badcfe 0x10325476 0x67452301 0xdebc0a89 ]
+  [ cmp eq reg 1 0xfedcba98 0x76543210 0x01234567 0x890abcde ]
 
 # meta l4proto 91 @th,400,16 0x0 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000005b ]
+  [ cmp eq reg 1 0x5b ]
   [ payload load 2b @ transport header + 50 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0000 ]
   [ immediate reg 0 accept ]
 
 # meta l4proto 91 @th,0,16 0x0 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000005b ]
+  [ cmp eq reg 1 0x5b ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0000 ]
   [ immediate reg 0 accept ]
 
 # @ih,32,32 0x14000000
 inet test-inet input
   [ payload load 4b @ inner header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000014 ]
+  [ cmp eq reg 1 0x14000000 ]
 
 # @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0
 inet test-inet input
   [ payload load 2b @ inner header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffc0 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ inner header + 6 csum_type 0 csum_off 0 csum_flags 0x1 ]
   [ payload load 2b @ inner header + 10 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000ffc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc0f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ inner header + 10 csum_type 0 csum_off 0 csum_flags 0x1 ]
   [ payload load 4b @ inner header + 20 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffc00000 ) ^ 0x00000000 ]
   [ payload write reg 1 => 4b @ inner header + 20 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # @ih,58,6 set 0x1 @ih,86,6 set 0x2 @ih,170,22 set 0x3
 inet test-inet input
   [ payload load 2b @ inner header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffc0 ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ inner header + 6 csum_type 0 csum_off 0 csum_flags 0x1 ]
   [ payload load 2b @ inner header + 10 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000ffc ) ^ 0x00002000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc0f ) ^ 0x0020 ]
   [ payload write reg 1 => 2b @ inner header + 10 csum_type 0 csum_off 0 csum_flags 0x1 ]
   [ payload load 4b @ inner header + 20 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x03000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffc00000 ) ^ 0x00000003 ]
   [ payload write reg 1 => 4b @ inner header + 20 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # @ih,58,6 0x0 @ih,86,6 0x0 @ih,170,22 0x0
 inet test-inet input
   [ payload load 1b @ inner header + 7 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x3f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
   [ payload load 2b @ inner header + 10 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f003 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x03f0 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0000 ]
   [ payload load 3b @ inner header + 21 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff3f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x3fffff ) ^ 0x000000 ]
+  [ cmp eq reg 1 0x000000 ]
 
 # @ih,1,2 0x2
 inet test-inet input
   [ payload load 1b @ inner header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000060 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000040 ]
+  [ bitwise reg 1 = ( reg 1 & 0x60 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x40 ]
 
 # @ih,35,3 0x2
 inet test-inet input
   [ payload load 1b @ inner header + 4 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000001c ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1c ) ^ 0x00 ]
+  [ cmp eq reg 1 0x08 ]
diff --git a/tests/py/any/rt.t.payload b/tests/py/any/rt.t.payload
index e1ecb2860ed08..a3d7a7ccec743 100644
--- a/tests/py/any/rt.t.payload
+++ b/tests/py/any/rt.t.payload
@@ -6,10 +6,9 @@ ip test-ip4 input
 # rt ipsec exists
 ip test-ip4 input
   [ rt load ipsec => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # rt ipsec missing
 ip test-ip4 input
   [ rt load ipsec => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
+  [ cmp eq reg 1 0x00 ]
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 437e073aae1c9..15b111ba57c5a 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -1,203 +1,203 @@
 # tcp option eol exists
 inet 
   [ exthdr load tcpopt 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option nop exists
 inet 
   [ exthdr load tcpopt 1b @ 1 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option maxseg exists
 inet 
   [ exthdr load tcpopt 1b @ 2 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option maxseg length 1
 inet 
   [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option maxseg size 1
 inet 
   [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # tcp option window length 1
 inet 
   [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option window count 1
 inet 
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option sack-perm exists
 inet 
   [ exthdr load tcpopt 1b @ 4 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option sack-perm length 1
 inet 
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option sack exists
 inet 
   [ exthdr load tcpopt 1b @ 5 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option sack length 1
 inet 
   [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option sack left 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack0 left 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack1 left 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack2 left 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack3 left 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack right 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack0 right 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack1 right 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack2 right 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack3 right 1
 inet 
   [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp exists
 inet 
   [ exthdr load tcpopt 1b @ 8 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option timestamp length 1
 inet 
   [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option timestamp tsval 1
 inet 
   [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp tsecr 1
 inet 
   [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # tcp option 255 missing
 inet
   [ exthdr load tcpopt 1b @ 255 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # tcp option 6 exists
 inet
   [ exthdr load tcpopt 1b @ 6 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option @255,8,8 255
 inet
   [ exthdr load tcpopt 1b @ 255 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x000000ff ]
+  [ cmp eq reg 1 0xff ]
 
 # tcp option window exists
 inet 
   [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option window missing
 inet 
   [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # tcp option maxseg size set 1360
 inet 
-  [ immediate reg 1 0x00005005 ]
+  [ immediate reg 1 0x0550 ]
   [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
 
 # tcp option md5sig exists
-inet
+ip test-ip4 input
   [ exthdr load tcpopt 1b @ 19 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option fastopen exists
 inet
   [ exthdr load tcpopt 1b @ 34 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option mptcp exists
 inet
   [ exthdr load tcpopt 1b @ 30 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tcp option mptcp subtype mp-capable
 inet
   [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # tcp option mptcp subtype 1
 inet
   [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
 
 # tcp option mptcp subtype { mp-capable, mp-join, remove-addr, mp-prio, mp-fail, mp-fastclose, mp-tcprst }
 __set%d test-ip4 3 size 7
 __set%d test-ip4 0
-	element 00000000  : 0 [end]	element 00000010  : 0 [end]	element 00000040  : 0 [end]	element 00000050  : 0 [end]	element 00000060  : 0 [end]	element 00000070  : 0 [end]	element 00000080  : 0 [end]
+	element 00	element 10	element 40	element 50	element 60	element 70	element 80
 ip test-ip4 input
   [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp option mptcp subtype . tcp dport { mp-capable . 10, mp-join . 100, add-addr . 200, remove-addr . 300, mp-prio . 400, mp-fail . 500, mp-fastclose . 600, mp-tcprst . 700 }
 __set%d test-ip4 3
 __set%d test-ip4 0
-        element 00000000 00000a00  : 0 [end]    element 00000001 00006400  : 0 [end]    element 00000003 0000c800  : 0 [end]    element 00000004 00002c01  : 0 [end]    element 00000005 00009001  : 0 [end]    element 00000006 0000f401  : 0 [end]    element 00000007 00005802  : 0 [end]    element 00000008 0000bc02  : 0 [end]
+	element 00 . 000a	element 01 . 0064	element 03 . 00c8	element 04 . 012c	element 05 . 0190	element 06 . 01f4	element 07 . 0258	element 08 . 02bc
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000004 ) ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __set%d ]
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index 0182bb1b14386..e23c540ca8bc1 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -1,37 +1,37 @@
 # arp htype 1
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # arp htype != 1
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000100 ]
+  [ cmp neq reg 1 0x0001 ]
 
 # arp htype 22
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # arp htype != 233
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # arp htype 33-45
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # arp htype != 33-45
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # arp htype { 33, 55, 67, 88}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -39,7 +39,7 @@ arp test-arp input
 # arp htype != { 33, 55, 67, 88}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -47,32 +47,32 @@ arp test-arp input
 # arp ptype 0x0800
 arp test-arp input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
 
 # arp hlen 22
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # arp hlen != 233
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # arp hlen 33-45
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # arp hlen != 33-45
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # arp hlen { 33, 55, 67, 88}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -80,7 +80,7 @@ arp test-arp input
 # arp hlen != { 33, 55, 67, 88}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -88,27 +88,27 @@ arp test-arp input
 # arp plen 22
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # arp plen != 233
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # arp plen 33-45
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # arp plen != 33-45
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # arp plen { 33, 55, 67, 88}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -116,7 +116,7 @@ arp test-arp input
 # arp plen != { 33, 55, 67, 88}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -124,7 +124,7 @@ arp test-arp input
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
+	element 000a	element 0009	element 0008	element 0004	element 0003	element 0002	element 0001
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -132,7 +132,7 @@ arp test-arp input
 # arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-arp 3
 __set%d test-arp 0
-	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
+	element 000a	element 0009	element 0008	element 0004	element 0003	element 0002	element 0001
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -140,118 +140,117 @@ arp test-arp input
 # arp operation 1-2
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00000100 0x00000200 ]
+  [ range eq reg 1 0x0001 0x0002 ]
 
 # arp operation request
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # arp operation reply
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ cmp eq reg 1 0x0002 ]
 
 # arp operation rrequest
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000300 ]
+  [ cmp eq reg 1 0x0003 ]
 
 # arp operation rreply
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000400 ]
+  [ cmp eq reg 1 0x0004 ]
 
 # arp operation inrequest
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000800 ]
+  [ cmp eq reg 1 0x0008 ]
 
 # arp operation inreply
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000900 ]
+  [ cmp eq reg 1 0x0009 ]
 
 # arp operation nak
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a00 ]
+  [ cmp eq reg 1 0x000a ]
 
 # arp operation != request
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000100 ]
+  [ cmp neq reg 1 0x0001 ]
 
 # arp operation != reply
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000200 ]
+  [ cmp neq reg 1 0x0002 ]
 
 # arp operation != rrequest
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000300 ]
+  [ cmp neq reg 1 0x0003 ]
 
 # arp operation != rreply
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000400 ]
+  [ cmp neq reg 1 0x0004 ]
 
 # arp operation != inrequest
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000800 ]
+  [ cmp neq reg 1 0x0008 ]
 
 # arp operation != inreply
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000900 ]
+  [ cmp neq reg 1 0x0009 ]
 
 # arp operation != nak
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000a00 ]
+  [ cmp neq reg 1 0x000a ]
 
 # meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566
 arp test-arp input
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x61766e69 0x0064696c 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x696e7661 0x6c696400 0x00000000 0x00000000 ]
   [ payload load 4b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00080100 ]
+  [ cmp eq reg 1 0x00010800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000406 ]
+  [ cmp eq reg 1 0x0604 ]
   [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x108fa8c0 ]
-  [ immediate reg 1 0x44332211 0x00006655 ]
+  [ cmp eq reg 1 0xc0a88f10 ]
+  [ immediate reg 1 0x11223344 0x5566 ]
   [ payload write reg 1 => 6b @ network header + 18 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # arp saddr ip 1.2.3.4
 arp test-arp input 
   [ payload load 4b @ network header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
 
 # arp daddr ip 4.3.2.1
 arp test-arp input 
   [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x01020304 ]
+  [ cmp eq reg 1 0x04030201 ]
 
 # arp saddr ether aa:bb:cc:aa:bb:cc
 arp test-arp input 
   [ payload load 6b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+  [ cmp eq reg 1 0xaabbccaa 0xbbcc ]
 
 # arp daddr ether aa:bb:cc:aa:bb:cc
 arp test-arp input 
   [ payload load 6b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+  [ cmp eq reg 1 0xaabbccaa 0xbbcc ]
 
 # arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee
 arp 
   [ payload load 10b @ network header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
+  [ cmp eq reg 1 0xc0a80101 0xfeed00c0 0xffee ]
 
 # arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1
 arp 
   [ payload load 10b @ network header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
-
+  [ cmp eq reg 1 0xc0a80101 0xfeed00c0 0xffee ]
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index d118811263e08..ea238978fa73b 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -1,347 +1,346 @@
 # arp htype 1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # arp htype != 1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000100 ]
+  [ cmp neq reg 1 0x0001 ]
 
 # arp htype 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # arp htype != 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # arp htype 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # arp htype != 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # arp htype { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # arp htype != { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # arp ptype 0x0800
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
 
 # arp hlen 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # arp hlen != 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # arp hlen 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # arp hlen != 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # arp hlen { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # arp hlen != { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # arp plen 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # arp plen != 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # arp plen 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # arp plen != 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # arp plen { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # arp plen != { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
+	element 000a	element 0009	element 0008	element 0004	element 0003	element 0002	element 0001
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
+	element 000a	element 0009	element 0008	element 0004	element 0003	element 0002	element 0001
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # arp operation 1-2
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00000100 0x00000200 ]
+  [ range eq reg 1 0x0001 0x0002 ]
 
 # arp operation request
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # arp operation reply
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ cmp eq reg 1 0x0002 ]
 
 # arp operation rrequest
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000300 ]
+  [ cmp eq reg 1 0x0003 ]
 
 # arp operation rreply
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000400 ]
+  [ cmp eq reg 1 0x0004 ]
 
 # arp operation inrequest
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000800 ]
+  [ cmp eq reg 1 0x0008 ]
 
 # arp operation inreply
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000900 ]
+  [ cmp eq reg 1 0x0009 ]
 
 # arp operation nak
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a00 ]
+  [ cmp eq reg 1 0x000a ]
 
 # arp operation != request
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000100 ]
+  [ cmp neq reg 1 0x0001 ]
 
 # arp operation != reply
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000200 ]
+  [ cmp neq reg 1 0x0002 ]
 
 # arp operation != rrequest
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000300 ]
+  [ cmp neq reg 1 0x0003 ]
 
 # arp operation != rreply
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000400 ]
+  [ cmp neq reg 1 0x0004 ]
 
 # arp operation != inrequest
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000800 ]
+  [ cmp neq reg 1 0x0008 ]
 
 # arp operation != inreply
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000900 ]
+  [ cmp neq reg 1 0x0009 ]
 
 # arp operation != nak
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000a00 ]
+  [ cmp neq reg 1 0x000a ]
 
 # meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566
 netdev test-netdev ingress
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x61766e69 0x0064696c 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x696e7661 0x6c696400 0x00000000 0x00000000 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 4b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00080100 ]
+  [ cmp eq reg 1 0x00010800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000406 ]
+  [ cmp eq reg 1 0x0604 ]
   [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x108fa8c0 ]
-  [ immediate reg 1 0x44332211 0x00006655 ]
+  [ cmp eq reg 1 0xc0a88f10 ]
+  [ immediate reg 1 0x11223344 0x5566 ]
   [ payload write reg 1 => 6b @ network header + 18 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # arp saddr ip 1.2.3.4
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 4b @ network header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
 
 # arp daddr ip 4.3.2.1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x01020304 ]
+  [ cmp eq reg 1 0x04030201 ]
 
 # arp saddr ether aa:bb:cc:aa:bb:cc
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 6b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+  [ cmp eq reg 1 0xaabbccaa 0xbbcc ]
 
 # arp daddr ether aa:bb:cc:aa:bb:cc
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 6b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+  [ cmp eq reg 1 0xaabbccaa 0xbbcc ]
 
 # arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 10b @ network header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
+  [ cmp eq reg 1 0xc0a80101 0xfeed00c0 0xffee ]
 
 # arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
+  [ cmp eq reg 1 0x0806 ]
   [ payload load 10b @ network header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
-
+  [ cmp eq reg 1 0xc0a80101 0xfeed00c0 0xffee ]
diff --git a/tests/py/bridge/ether.t.payload b/tests/py/bridge/ether.t.payload
index eaff9c312bae4..6f9deba9ba26b 100644
--- a/tests/py/bridge/ether.t.payload
+++ b/tests/py/bridge/ether.t.payload
@@ -1,60 +1,59 @@
 # tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
 
 # ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 bridge test-bridge input
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ immediate reg 0 accept ]
 
 # ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop
 bridge test-bridge input
   [ payload load 6b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x03020100 0x00000504 ]
-  [ immediate reg 1 0xbadcfeff 0x00007698 ]
+  [ cmp eq reg 1 0x00010203 0x0405 ]
+  [ immediate reg 1 0xfffedcba 0x9876 ]
   [ payload write reg 1 => 6b @ link header + 6 csum_type 0 csum_off 0 csum_flags 0x0 ]
   [ immediate reg 0 drop ]
-
diff --git a/tests/py/bridge/icmpX.t.payload b/tests/py/bridge/icmpX.t.payload
index f9ea7b60450af..d6634beadb26b 100644
--- a/tests/py/bridge/icmpX.t.payload
+++ b/tests/py/bridge/icmpX.t.payload
@@ -1,36 +1,35 @@
 # ip protocol icmp icmp type echo-request
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # icmp type echo-request
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # ip6 nexthdr icmpv6 icmpv6 type echo-request
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ cmp eq reg 1 0x80 ]
 
 # icmpv6 type echo-request
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
-
+  [ cmp eq reg 1 0x80 ]
diff --git a/tests/py/bridge/meta.t.payload b/tests/py/bridge/meta.t.payload
index 0a39842aedf3e..bbbf7968ed6ca 100644
--- a/tests/py/bridge/meta.t.payload
+++ b/tests/py/bridge/meta.t.payload
@@ -1,37 +1,37 @@
 # meta obrname "br0"
 bridge test-bridge input
   [ meta load bri_oifname => reg 1 ]
-  [ cmp eq reg 1 0x00307262 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x62723000 0x00000000 0x00000000 0x00000000 ]
 
 # meta ibrname "br0"
 bridge test-bridge input
   [ meta load bri_iifname => reg 1 ]
-  [ cmp eq reg 1 0x00307262 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x62723000 0x00000000 0x00000000 0x00000000 ]
 
 # meta ibrvproto vlan
 bridge test-bridge input
   [ meta load bri_iifvproto => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
 
 # meta ibrpvid 100
 bridge test-bridge input
   [ meta load bri_iifpvid => reg 1 ]
-  [ cmp eq reg 1 0x00000064 ]
+  [ cmp eq reg 1 0x0064 ]
 
 # meta protocol ip udp dport 67
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00004300 ]
+  [ cmp eq reg 1 0x0043 ]
 
 # meta protocol ip6 udp dport 67
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00004300 ]
+  [ cmp eq reg 1 0x0043 ]
diff --git a/tests/py/bridge/redirect.t.payload b/tests/py/bridge/redirect.t.payload
index 1fcfa5f1b04ff..a0afec94171fa 100644
--- a/tests/py/bridge/redirect.t.payload
+++ b/tests/py/bridge/redirect.t.payload
@@ -1,4 +1,4 @@
 # meta broute set 1
 bridge test-bridge prerouting
-  [ immediate reg 1 0x00000001 ]
+  [ immediate reg 1 0x01 ]
   [ meta set broute with reg 1 ]
diff --git a/tests/py/bridge/reject.t.payload b/tests/py/bridge/reject.t.payload
index bad9adc028524..76ef007ebf71d 100644
--- a/tests/py/bridge/reject.t.payload
+++ b/tests/py/bridge/reject.t.payload
@@ -1,67 +1,67 @@
 # reject with icmp host-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 1 ]
 
 # reject with icmp net-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 0 ]
 
 # reject with icmp prot-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 2 ]
 
 # reject with icmp port-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 3 ]
 
 # reject with icmp net-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 9 ]
 
 # reject with icmp host-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 10 ]
 
 # reject with icmp admin-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 13 ]
 
 # reject with icmpv6 no-route
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 0 ]
 
 # reject with icmpv6 admin-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 1 ]
 
 # reject with icmpv6 addr-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 3 ]
 
 # reject with icmpv6 port-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 4 ]
 
 # mark 12345 ip protocol tcp reject with tcp reset
@@ -69,9 +69,9 @@ bridge test-bridge input
   [ meta load mark => reg 1 ]
   [ cmp eq reg 1 0x00003039 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ reject type 1 code 0 ]
 
 # reject
@@ -81,13 +81,13 @@ bridge test-bridge input
 # ether type ip reject
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 3 ]
 
 # ether type ip6 reject
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 4 ]
 
 # reject with icmpx host-unreachable
@@ -109,32 +109,31 @@ bridge test-bridge input
 # ether type ip reject with icmpx admin-prohibited
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 2 code 3 ]
 
 # ether type ip6 reject with icmpx admin-prohibited
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 2 code 3 ]
 
 # ether type vlan reject
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ reject type 2 code 1 ]
 
 # ether type vlan reject with tcp reset
 bridge
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ reject type 1 code 0 ]
 
 # ether type 8021q reject with icmpx admin-prohibited
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ reject type 2 code 3 ]
-
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 0144a9a5b036b..e5907371aab3a 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -1,313 +1,313 @@
 # vlan id 4094
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
 
 # vlan id 0
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0000 ]
 
 # vlan id 4094 vlan cfi 1
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
 
 # vlan id 4094 vlan dei 0
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # vlan id 4094 vlan dei != 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x10 ]
 
 # vlan id 4094 vlan dei 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
 
 # ether type vlan vlan id 4094
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
 
 # ether type vlan vlan id 0
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0000 ]
 
 # ether type vlan vlan id 4094 vlan dei 0
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # ether type vlan vlan id 4094 vlan dei 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
 
 # vlan id 4094 tcp dport 22
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # vlan id 1 ip saddr 10.0.0.1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0100000a ]
+  [ cmp eq reg 1 0x0a000001 ]
 
 # vlan id 1 ip saddr 10.0.0.0/23
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffe00 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a000000 ]
 
 # vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffe00 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
 
 # ether type vlan vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffe00 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
 
 # vlan id 4094 vlan dei 1 vlan pcp 7
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x000000e0 ]
+  [ bitwise reg 1 = ( reg 1 & 0xe0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0xe0 ]
 
 # vlan id 4094 vlan dei 1 vlan pcp 3
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000060 ]
+  [ bitwise reg 1 = ( reg 1 & 0xe0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x60 ]
 
 # vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
 __set%d test-bridge 3
 __set%d test-bridge 0
-	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000400  : 0 [end]	element 00006400  : 0 [end]	element 0000ff0f  : 0 [end]
+	element 0001	element 0002	element 0004	element 0064	element 0fff
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ range eq reg 1 0x00000020 0x00000060 ]
+  [ bitwise reg 1 = ( reg 1 & 0xe0 ) ^ 0x00 ]
+  [ range eq reg 1 0x20 0x60 ]
 
 # ether type vlan ip protocol 1 accept
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ immediate reg 0 accept ]
 
 # ether type 8021ad vlan id 1 ip protocol 6 accept
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000a888 ]
+  [ cmp eq reg 1 0x88a8 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ immediate reg 0 accept ]
 
 # ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000a888 ]
+  [ cmp eq reg 1 0x88a8 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 18 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
   [ payload load 2b @ link header + 20 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ counter pkts 0 bytes 0 ]
 
 # ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip ip protocol 6
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000a888 ]
+  [ cmp eq reg 1 0x88a8 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 18 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
   [ payload load 2b @ link header + 20 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # vlan id 1 vlan id set 2
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf000 ) ^ 0x0002 ]
   [ payload write reg 1 => 2b @ link header + 14 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # ether saddr 00:01:02:03:04:05 vlan id 1
 bridge test-bridge input
   [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x03020100 0x00810504 ]
+  [ cmp eq reg 1 0x00010203 0x04058100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # vlan id 2 ether saddr 0:1:2:3:4:6
 bridge test-bridge input
   [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x03020100 0x00810604 ]
+  [ cmp eq reg 1 0x00010203 0x04068100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
 
 # ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 }
 __set%d test-bridge 3 size 2
 __set%d test-bridge 0
-	element 0d0c0b0a 00000f0e 00002a00  : 0 [end]	element 0d0c0b0a 00000f0e 0000ff0f  : 0 [end]
+	element 0a0b0c0d 0e0f . 002a	element 0a0b0c0d 0e0f . 0fff
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
   [ payload load 2b @ link header + 14 => reg 10 ]
-  [ bitwise reg 10 = ( reg 10 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 10 = ( reg 10 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
 
 # ether saddr 00:11:22:33:44:55 counter ether type 8021q
 bridge test-bridge input
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x33221100 0x00005544 ]
+  [ cmp eq reg 1 0x00112233 0x4455 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 330fb4a32df5e..6c5352c6be8bc 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -1,367 +1,367 @@
 # vlan id 4094
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
 
 # vlan id 0
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0000 ]
 
 # vlan id 4094 vlan dei 0
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # vlan id 4094 vlan dei != 1
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x10 ]
 
 # vlan id 4094 vlan cfi 1
 netdev
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
 
 # vlan id 4094 vlan dei 1
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
 
 # ether type vlan vlan id 4094
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
 
 # ether type vlan vlan id 0
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0000 ]
 
 # ether type vlan vlan id 4094 vlan dei 0
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # ether type vlan vlan id 4094 vlan dei 1
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
 
 # vlan id 4094 tcp dport 22
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # vlan id 1 ip saddr 10.0.0.1
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0100000a ]
+  [ cmp eq reg 1 0x0a000001 ]
 
 # vlan id 1 ip saddr 10.0.0.0/23
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffe00 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a000000 ]
 
 # vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffe00 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
 
 # ether type vlan vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffe00 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
 
 # vlan id 4094 vlan dei 1 vlan pcp 7
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x000000e0 ]
+  [ bitwise reg 1 = ( reg 1 & 0xe0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0xe0 ]
 
 # vlan id 4094 vlan dei 1 vlan pcp 3
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000fe0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0ffe ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0x10 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x10 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000060 ]
+  [ bitwise reg 1 = ( reg 1 & 0xe0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x60 ]
 
 # vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000400  : 0 [end]	element 00006400  : 0 [end]	element 0000ff0f  : 0 [end]
+	element 0001	element 0002	element 0004	element 0064	element 0fff
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ range eq reg 1 0x00000020 0x00000060 ]
+  [ bitwise reg 1 = ( reg 1 & 0xe0 ) ^ 0x00 ]
+  [ range eq reg 1 0x20 0x60 ]
 
 # ether type vlan ip protocol 1 accept
 netdev test-netdev ingress
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ immediate reg 0 accept ]
 
 # ether type 8021ad vlan id 1 ip protocol 6 accept
 netdev
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000a888 ]
+  [ cmp eq reg 1 0x88a8 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ immediate reg 0 accept ]
 
 # ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter
 netdev
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000a888 ]
+  [ cmp eq reg 1 0x88a8 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 18 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
   [ payload load 2b @ link header + 20 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ counter pkts 0 bytes 0 ]
 
 # ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip ip protocol 6
 netdev
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000a888 ]
+  [ cmp eq reg 1 0x88a8 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 18 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
   [ payload load 2b @ link header + 20 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # vlan id 1 vlan id set 2
 netdev
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf000 ) ^ 0x0002 ]
   [ payload write reg 1 => 2b @ link header + 14 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # vlan id 2 ether saddr 0:1:2:3:4:6
 netdev test-netdev ingress
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x03020100 0x00810604 ]
+  [ cmp eq reg 1 0x00010203 0x04068100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
 
 # ether saddr 00:01:02:03:04:05 vlan id 1
 netdev test-netdev ingress
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x03020100 0x00810504 ]
+  [ cmp eq reg 1 0x00010203 0x04058100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 }
 __set%d test-netdev 3 size 2
 __set%d test-netdev 0
-	element 0d0c0b0a 00000f0e 00002a00  : 0 [end]	element 0d0c0b0a 00000f0e 0000ff0f  : 0 [end]
+	element 0a0b0c0d 0e0f . 002a	element 0a0b0c0d 0e0f . 0fff
 netdev test-netdev ingress
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
   [ payload load 2b @ link header + 14 => reg 10 ]
-  [ bitwise reg 10 = ( reg 10 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 10 = ( reg 10 & 0x0fff ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
 
 # ether saddr 00:11:22:33:44:55 counter ether type 8021q
 bridge test-bridge input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x33221100 0x00005544 ]
+  [ cmp eq reg 1 0x00112233 0x4455 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
diff --git a/tests/py/inet/ah.t.payload b/tests/py/inet/ah.t.payload
index e0cd2002ba55d..cc89ebb7b31d9 100644
--- a/tests/py/inet/ah.t.payload
+++ b/tests/py/inet/ah.t.payload
@@ -1,178 +1,177 @@
 # ah hdrlength 11-23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range eq reg 1 0x0000000b 0x00000017 ]
+  [ range eq reg 1 0x0b 0x17 ]
 
 # ah hdrlength != 11-23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x0000000b 0x00000017 ]
+  [ range neq reg 1 0x0b 0x17 ]
 
 # ah hdrlength {11, 23, 44 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
+	element 0b	element 17	element 2c
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ah hdrlength != {11, 23, 44 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
+	element 0b	element 17	element 2c
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah reserved 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ah reserved != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ah reserved 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ah reserved != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ah reserved {23, 100}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
+	element 0017	element 0064
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ah reserved != {23, 100}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
+	element 0017	element 0064
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah spi 111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x6f000000 ]
+  [ cmp eq reg 1 0x0000006f ]
 
 # ah spi != 111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x6f000000 ]
+  [ cmp neq reg 1 0x0000006f ]
 
 # ah spi 111-222
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x6f000000 0xde000000 ]
+  [ range eq reg 1 0x0000006f 0x000000de ]
 
 # ah spi != 111-222
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
+  [ range neq reg 1 0x0000006f 0x000000de ]
 
 # ah spi {111, 122}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
+	element 0000006f	element 0000007a
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ah spi != {111, 122}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
+	element 0000006f	element 0000007a
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah sequence 123
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x7b000000 ]
+  [ cmp eq reg 1 0x0000007b ]
 
 # ah sequence != 123
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x7b000000 ]
+  [ cmp neq reg 1 0x0000007b ]
 
 # ah sequence {23, 25, 33}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
+	element 00000017	element 00000019	element 00000021
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ah sequence != {23, 25, 33}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
+	element 00000017	element 00000019	element 00000021
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah sequence 23-33
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range eq reg 1 0x17000000 0x21000000 ]
+  [ range eq reg 1 0x00000017 0x00000021 ]
 
 # ah sequence != 23-33
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x17000000 0x21000000 ]
-
+  [ range neq reg 1 0x00000017 0x00000021 ]
diff --git a/tests/py/inet/comp.t.payload b/tests/py/inet/comp.t.payload
index 2ffe3b3186518..3c684139b6480 100644
--- a/tests/py/inet/comp.t.payload
+++ b/tests/py/inet/comp.t.payload
@@ -1,103 +1,102 @@
 # comp nexthdr != esp
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000032 ]
+  [ cmp neq reg 1 0x32 ]
 
 # comp flags 0x0
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # comp flags != 0x23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp neq reg 1 0x00000023 ]
+  [ cmp neq reg 1 0x23 ]
 
 # comp flags 0x33-0x45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range eq reg 1 0x00000033 0x00000045 ]
+  [ range eq reg 1 0x33 0x45 ]
 
 # comp flags != 0x33-0x45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x00000033 0x00000045 ]
+  [ range neq reg 1 0x33 0x45 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
+	element 33	element 55	element 67	element 88
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # comp flags != {0x33, 0x55, 0x67, 0x88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
+	element 33	element 55	element 67	element 88
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # comp cpi 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # comp cpi != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # comp cpi 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # comp cpi != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # comp cpi {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # comp cpi != {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
+  [ cmp eq reg 1 0x6c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/ct.t.payload b/tests/py/inet/ct.t.payload
index 216dad2bb531c..4e9d5f04a6a2c 100644
--- a/tests/py/inet/ct.t.payload
+++ b/tests/py/inet/ct.t.payload
@@ -1,31 +1,31 @@
 # meta nfproto ipv4 ct original saddr 1.2.3.4
 ip test-ip4 output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ ct load src => reg 1 , dir original ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
 
 # ct original ip6 saddr ::1
 inet test-inet input
   [ ct load src_ip6 => reg 1 , dir original ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000001 ]
 
 # ct original ip daddr 1.2.3.4 accept
 inet test-inet input
   [ ct load dst_ip => reg 1 , dir original ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ immediate reg 0 accept ]
 
 # meta nfproto ipv4 ct mark 0x00000001
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ ct load mark => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # meta nfproto ipv6 ct protocol 6
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ ct load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
diff --git a/tests/py/inet/dccp.t.payload b/tests/py/inet/dccp.t.payload
index b5edfa5daed92..d447fe58022f3 100644
--- a/tests/py/inet/dccp.t.payload
+++ b/tests/py/inet/dccp.t.payload
@@ -1,99 +1,98 @@
 # dccp sport 21-35
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x00001500 0x00002300 ]
+  [ range eq reg 1 0x0015 0x0023 ]
 
 # dccp sport != 21-35
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001500 0x00002300 ]
+  [ range neq reg 1 0x0015 0x0023 ]
 
 # dccp sport {23, 24, 25}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dccp sport != {23, 24, 25}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dccp sport 20-50
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x00001400 0x00003200 ]
+  [ range eq reg 1 0x0014 0x0032 ]
 
 # dccp dport {23, 24, 25}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dccp dport != {23, 24, 25}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
+	element 00	element 02	element 04	element 06	element 08	element 0a	element 0c	element 0e	element 10	element 12
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1e ) ^ 0x00 ]
   [ lookup reg 1 set __set%d ]
 
 # dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
+	element 00	element 02	element 04	element 06	element 08	element 0a	element 0c	element 0e	element 10	element 12
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1e ) ^ 0x00 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dccp type request
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1e ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # dccp type != request
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
+  [ cmp eq reg 1 0x21 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
-
+  [ bitwise reg 1 = ( reg 1 & 0x1e ) ^ 0x00 ]
+  [ cmp neq reg 1 0x00 ]
diff --git a/tests/py/inet/dnat.t.payload b/tests/py/inet/dnat.t.payload
index ce1601ab5c9e8..75dd723575e82 100644
--- a/tests/py/inet/dnat.t.payload
+++ b/tests/py/inet/dnat.t.payload
@@ -1,41 +1,41 @@
 # iifname "foo" tcp dport 80 redirect to :8080
 inet test-inet prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x666f6f00 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 1 0x0000901f ]
+  [ cmp eq reg 1 0x0050 ]
+  [ immediate reg 1 0x1f90 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # iifname "eth0" tcp dport 443 dnat ip to 192.168.3.2
 inet test-inet prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000bb01 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ cmp eq reg 1 0x01bb ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 443 dnat ip6 to [dead::beef]:4443
 inet test-inet prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000bb01 ]
-  [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
-  [ immediate reg 2 0x00005b11 ]
+  [ cmp eq reg 1 0x01bb ]
+  [ immediate reg 1 0xdead0000 0x00000000 0x00000000 0x0000beef ]
+  [ immediate reg 2 0x115b ]
   [ nat dnat ip6 addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # dnat ip to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-inet b size 1
 __map%d test-inet 0
-        element 00000014  : 04030201 0 [end]
+	element 00000014 : 01020304
 inet test-inet prerouting
   [ ct load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -44,10 +44,10 @@ inet test-inet prerouting
 # dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
 __map%d test-inet b size 1
 __map%d test-inet 0
-        element 00000014 01010101  : 04030201 0 [end]
+	element 00000014 . 01010101 : 01020304
 inet test-inet prerouting
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ ct load mark => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -56,31 +56,30 @@ inet test-inet prerouting
 # meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000006  : 0 [end]     element 00000011  : 0 [end]
+	element 06	element 11
 inet
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x01010101 ]
-  [ immediate reg 2 0x00005000 ]
+  [ immediate reg 2 0x0050 ]
   [ nat dnat ip addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # ip protocol { tcp, udp } dnat ip to 1.1.1.1:80
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000006  : 0 [end]     element 00000011  : 0 [end]
+	element 06	element 11
 inet
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x01010101 ]
-  [ immediate reg 2 0x00005000 ]
+  [ immediate reg 2 0x0050 ]
   [ nat dnat ip addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # meta l4proto tcp dnat to :80
 inet
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00005000 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x0050 ]
   [ nat dnat inet proto_min reg 1 flags 0x2 ]
-
diff --git a/tests/py/inet/esp.t.payload b/tests/py/inet/esp.t.payload
index bb67aad6848f2..c315c97ca8898 100644
--- a/tests/py/inet/esp.t.payload
+++ b/tests/py/inet/esp.t.payload
@@ -1,89 +1,88 @@
 # esp spi 100
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x64000000 ]
+  [ cmp eq reg 1 0x00000064 ]
 
 # esp spi != 100
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x64000000 ]
+  [ cmp neq reg 1 0x00000064 ]
 
 # esp spi 111-222
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x6f000000 0xde000000 ]
+  [ range eq reg 1 0x0000006f 0x000000de ]
 
 # esp spi != 111-222
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
+  [ range neq reg 1 0x0000006f 0x000000de ]
 
 # esp spi { 100, 102}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
+	element 00000064	element 00000066
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # esp spi != { 100, 102}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
+	element 00000064	element 00000066
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # esp sequence 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # esp sequence 22-24
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x16000000 0x18000000 ]
+  [ range eq reg 1 0x00000016 0x00000018 ]
 
 # esp sequence != 22-24
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x16000000 0x18000000 ]
+  [ range neq reg 1 0x00000016 0x00000018 ]
 
 # esp sequence { 22, 24}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
+	element 00000016	element 00000018
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # esp sequence != { 22, 24}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
+	element 00000016	element 00000018
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/ether-ip.t.payload b/tests/py/inet/ether-ip.t.payload
index 62e37a597b967..912a19b857dfd 100644
--- a/tests/py/inet/ether-ip.t.payload
+++ b/tests/py/inet/ether-ip.t.payload
@@ -1,28 +1,28 @@
 # tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00080411 ]
+  [ cmp eq reg 1 0x000f540c 0x11040800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
diff --git a/tests/py/inet/ether-ip.t.payload.netdev b/tests/py/inet/ether-ip.t.payload.netdev
index b0fa6d84b31b1..aca7a4b72ab7f 100644
--- a/tests/py/inet/ether-ip.t.payload.netdev
+++ b/tests/py/inet/ether-ip.t.payload.netdev
@@ -1,29 +1,28 @@
 # tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
 
 # tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00080411 ]
+  [ cmp eq reg 1 0x000f540c 0x11040800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ immediate reg 0 accept ]
-
diff --git a/tests/py/inet/ether.t.payload b/tests/py/inet/ether.t.payload
index 8b74a7815d8ec..e0a36d43745b6 100644
--- a/tests/py/inet/ether.t.payload
+++ b/tests/py/inet/ether.t.payload
@@ -1,52 +1,51 @@
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # ether saddr 00:0f:54:0c:11:04 accept
 inet test-inet input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # vlan id 1
 netdev test-netdev ingress
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # ether type vlan vlan id 2
 netdev test-netdev ingress
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
-
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
diff --git a/tests/py/inet/ether.t.payload.bridge b/tests/py/inet/ether.t.payload.bridge
index 0128d5f02b978..d5d4f5c0d49f7 100644
--- a/tests/py/inet/ether.t.payload.bridge
+++ b/tests/py/inet/ether.t.payload.bridge
@@ -1,44 +1,43 @@
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # ether saddr 00:0f:54:0c:11:04 accept
 bridge test-bridge input
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # vlan id 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # ether type vlan vlan id 2
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
-
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
diff --git a/tests/py/inet/ether.t.payload.ip b/tests/py/inet/ether.t.payload.ip
index 7c91f412c33ee..5a4fb00808b15 100644
--- a/tests/py/inet/ether.t.payload.ip
+++ b/tests/py/inet/ether.t.payload.ip
@@ -1,52 +1,51 @@
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # ether saddr 00:0f:54:0c:11:04 accept
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # vlan id 1
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # ether type vlan vlan id 2
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000200 ]
-
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0002 ]
diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
index 02d92b57a4776..612e5ba827a64 100644
--- a/tests/py/inet/fib.t.payload
+++ b/tests/py/inet/fib.t.payload
@@ -6,7 +6,7 @@ ip test-ip prerouting
 # fib saddr . iif oifname "lo"
 ip test-ip prerouting
   [ fib saddr . iif oifname => reg 1 ]
-  [ cmp eq reg 1 0x00006f6c 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x6c6f0000 0x00000000 0x00000000 0x00000000 ]
 
 # fib daddr . iif type local
 ip test-ip prerouting
@@ -16,7 +16,7 @@ ip test-ip prerouting
 # fib daddr . iif type vmap { blackhole : drop, prohibit : drop, unicast : accept }
 __map%d test-ip b
 __map%d test-ip 0
-	element 00000006  : drop 0 [end]	element 00000008  : drop 0 [end]	element 00000001  : accept 0 [end]
+	element 00000006 : drop	element 00000008 : drop	element 00000001 : accept
 ip test-ip prerouting
   [ fib daddr . iif type => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -24,21 +24,21 @@ ip test-ip prerouting
 # fib daddr oif exists
 ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # fib daddr check missing
 ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # fib daddr check vmap { missing : drop, exists : accept }
-        element 00000000  : drop 0 [end]        element 00000001  : accept 0 [end]
+	element 00 : drop	element 01 : accept
 ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x00000001 }
-        element 00000001 00000000  : 00000001 0 [end]
+	element 01 . 00000000 : 00000001
 ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
   [ ct load mark => reg 9 ]
diff --git a/tests/py/inet/geneve.t.payload b/tests/py/inet/geneve.t.payload
index 5977873886af6..f38a63a7eaf17 100644
--- a/tests/py/inet/geneve.t.payload
+++ b/tests/py/inet/geneve.t.payload
@@ -1,114 +1,113 @@
 # udp dport 6081 geneve vni 10
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 3b @ tunnel header + 4 => reg 1 ] ]
-  [ cmp eq reg 1 0x000a0000 ]
+  [ cmp eq reg 1 0x00000a ]
 
 # udp dport 6081 geneve ip saddr 10.141.11.2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x020b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b02 ]
 
 # udp dport 6081 geneve ip saddr 10.141.11.0/24
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 3b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x000b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b ]
 
 # udp dport 6081 geneve ip protocol 1
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 1b @ network header + 9 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # udp dport 6081 geneve udp sport 8888
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 2b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x0000b822 ]
+  [ cmp eq reg 1 0x22b8 ]
 
 # udp dport 6081 geneve icmp type echo-reply
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 2b @ link header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 2 hdrsize 8 flags f [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 1b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # udp dport 6081 geneve ether saddr 62:87:4d:d6:19:05
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 6b @ link header + 6 => reg 1 ] ]
-  [ cmp eq reg 1 0xd64d8762 0x00000519 ]
+  [ cmp eq reg 1 0x62874dd6 0x1905 ]
 
 # udp dport 6081 geneve vlan id 10
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 2b @ link header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 2b @ link header + 14 => reg 1 ] ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000a00 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x000a ]
 
 # udp dport 6081 geneve ip dscp 0x02
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 1b @ network header + 1 => reg 1 ] ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x08 ]
 
 # udp dport 6081 geneve ip saddr . geneve ip daddr { 1.2.3.4 . 4.3.2.1 }
 __set%d test-ip4 3 size 1
 __set%d test-ip4 0
-	element 04030201 01020304  : 0 [end]
+	element 01020304 . 04030201
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000c117 ]
+  [ cmp eq reg 1 0x17c1 ]
   [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 2 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
   [ inner type 2 hdrsize 8 flags f [ payload load 4b @ network header + 16 => reg 9 ] ]
   [ lookup reg 1 set __set%d ]
-
diff --git a/tests/py/inet/gre.t.payload b/tests/py/inet/gre.t.payload
index 333133ede4153..6ca6680dc132f 100644
--- a/tests/py/inet/gre.t.payload
+++ b/tests/py/inet/gre.t.payload
@@ -1,78 +1,77 @@
 # gre version 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000007 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x07 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # gre ip saddr 10.141.11.2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 3 hdrsize 4 flags c [ payload load 4b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x020b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b02 ]
 
 # gre ip saddr 10.141.11.0/24
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 3 hdrsize 4 flags c [ payload load 3b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x000b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b ]
 
 # gre ip protocol 1
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 3 hdrsize 4 flags c [ payload load 1b @ network header + 9 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # gre udp sport 8888
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 3 hdrsize 4 flags c [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ inner type 3 hdrsize 4 flags c [ payload load 2b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x0000b822 ]
+  [ cmp eq reg 1 0x22b8 ]
 
 # gre icmp type echo-reply
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 3 hdrsize 4 flags c [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ inner type 3 hdrsize 4 flags c [ payload load 1b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # gre ip dscp 0x02
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 3 hdrsize 4 flags c [ payload load 1b @ network header + 1 => reg 1 ] ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x08 ]
 
 # gre ip saddr . gre ip daddr { 1.2.3.4 . 4.3.2.1 }
 __set%d test-ip4 3 size 1
 __set%d test-ip4 0
-	element 04030201 01020304  : 0 [end]
+	element 01020304 . 04030201
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 3 hdrsize 4 flags c [ payload load 4b @ network header + 12 => reg 1 ] ]
   [ inner type 3 hdrsize 4 flags c [ payload load 4b @ network header + 16 => reg 9 ] ]
   [ lookup reg 1 set __set%d ]
-
diff --git a/tests/py/inet/gretap.t.payload b/tests/py/inet/gretap.t.payload
index 654c71e4541ac..222a10e7faa7d 100644
--- a/tests/py/inet/gretap.t.payload
+++ b/tests/py/inet/gretap.t.payload
@@ -1,87 +1,86 @@
 # gretap ip saddr 10.141.11.2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 4b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x020b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b02 ]
 
 # gretap ip saddr 10.141.11.0/24
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 3b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x000b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b ]
 
 # gretap ip protocol 1
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 1b @ network header + 9 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # gretap udp sport 8888
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 2b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x0000b822 ]
+  [ cmp eq reg 1 0x22b8 ]
 
 # gretap icmp type echo-reply
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ payload load 2b @ link header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 4 hdrsize 4 flags e [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 1b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # gretap ether saddr 62:87:4d:d6:19:05
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ payload load 6b @ link header + 6 => reg 1 ] ]
-  [ cmp eq reg 1 0xd64d8762 0x00000519 ]
+  [ cmp eq reg 1 0x62874dd6 0x1905 ]
 
 # gretap vlan id 10
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ payload load 2b @ link header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 2b @ link header + 14 => reg 1 ] ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000a00 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x000a ]
 
 # gretap ip dscp 0x02
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 1b @ network header + 1 => reg 1 ] ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x08 ]
 
 # gretap ip saddr . gretap ip daddr { 1.2.3.4 . 4.3.2.1 }
 __set%d test-ip4 3 size 1
 __set%d test-ip4 0
-	element 04030201 01020304  : 0 [end]
+	element 01020304 . 04030201
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000002f ]
+  [ cmp eq reg 1 0x2f ]
   [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 4 hdrsize 4 flags e [ payload load 4b @ network header + 12 => reg 1 ] ]
   [ inner type 4 hdrsize 4 flags e [ payload load 4b @ network header + 16 => reg 9 ] ]
   [ lookup reg 1 set __set%d ]
-
diff --git a/tests/py/inet/icmp.t.payload b/tests/py/inet/icmp.t.payload
index f98cfc39abed4..4db6b6fe2326e 100644
--- a/tests/py/inet/icmp.t.payload
+++ b/tests/py/inet/icmp.t.payload
@@ -1,54 +1,53 @@
 # icmp type echo-request
 inet test-inet output 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # icmpv6 type echo-request
 inet test-inet output 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ cmp eq reg 1 0x80 ]
 
 # meta nfproto ipv4 icmp type echo-request
 inet test-inet output 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # meta nfproto ipv4 icmpv6 type echo-request
 inet test-inet output 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ cmp eq reg 1 0x80 ]
 
 # meta nfproto ipv6 icmp type echo-request
 inet test-inet output 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # meta nfproto ipv6 icmpv6 type echo-request
 inet test-inet output 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
-
+  [ cmp eq reg 1 0x80 ]
diff --git a/tests/py/inet/icmpX.t.payload b/tests/py/inet/icmpX.t.payload
index 9a761eef632ed..61b857b52737a 100644
--- a/tests/py/inet/icmpX.t.payload
+++ b/tests/py/inet/icmpX.t.payload
@@ -1,46 +1,46 @@
 # ip protocol icmp icmp type echo-request
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # icmp type echo-request
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # ip6 nexthdr icmpv6 icmpv6 type echo-request
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ cmp eq reg 1 0x80 ]
 
 # icmpv6 type echo-request
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ cmp eq reg 1 0x80 ]
 
 # ip protocol ipv6-icmp meta l4proto ipv6-icmp icmpv6 type 1
 inet filter input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
diff --git a/tests/py/inet/ip.t.payload b/tests/py/inet/ip.t.payload
index 589a5cd35a806..6ed1967d29ae3 100644
--- a/tests/py/inet/ip.t.payload
+++ b/tests/py/inet/ip.t.payload
@@ -1,10 +1,10 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
+	element 01010101 . 02020202 . cafecafe cafe
 inet test-ip input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
diff --git a/tests/py/inet/ip.t.payload.bridge b/tests/py/inet/ip.t.payload.bridge
index 57dbc9eb42e77..3e7421c8152d3 100644
--- a/tests/py/inet/ip.t.payload.bridge
+++ b/tests/py/inet/ip.t.payload.bridge
@@ -1,10 +1,10 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
 __set%d test-bridge 3
 __set%d test-bridge 0
-	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
+	element 01010101 . 02020202 . cafecafe cafe
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
diff --git a/tests/py/inet/ip.t.payload.inet b/tests/py/inet/ip.t.payload.inet
index 8df41defea0a1..f566c98814c5b 100644
--- a/tests/py/inet/ip.t.payload.inet
+++ b/tests/py/inet/ip.t.payload.inet
@@ -1,14 +1,13 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
+	element 01010101 . 02020202 . cafecafe cafe
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
   [ lookup reg 1 set __set%d ]
-
diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
index 95be9194f2fed..e3799893f7428 100644
--- a/tests/py/inet/ip.t.payload.netdev
+++ b/tests/py/inet/ip.t.payload.netdev
@@ -1,14 +1,13 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
+	element 01010101 . 02020202 . cafecafe cafe
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
   [ lookup reg 1 set __set%d ]
-
diff --git a/tests/py/inet/ip_tcp.t.payload b/tests/py/inet/ip_tcp.t.payload
index 1e16f8522849b..cf68b98a1468f 100644
--- a/tests/py/inet/ip_tcp.t.payload
+++ b/tests/py/inet/ip_tcp.t.payload
@@ -1,52 +1,52 @@
 # ip protocol tcp tcp dport 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp ip saddr 1.2.3.4 tcp dport 22
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp counter ip saddr 1.2.3.4 tcp dport 22
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp counter tcp dport 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ether type ip tcp dport 22
 inet test-inet input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
diff --git a/tests/py/inet/ip_tcp.t.payload.bridge b/tests/py/inet/ip_tcp.t.payload.bridge
index 0344cd66668cc..121052d901137 100644
--- a/tests/py/inet/ip_tcp.t.payload.bridge
+++ b/tests/py/inet/ip_tcp.t.payload.bridge
@@ -1,51 +1,50 @@
 # ip protocol tcp tcp dport 22
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp ip saddr 1.2.3.4 tcp dport 22
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp counter ip saddr 1.2.3.4 tcp dport 22
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp counter tcp dport 22
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ether type ip tcp dport 22
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
+  [ cmp eq reg 1 0x0016 ]
diff --git a/tests/py/inet/ip_tcp.t.payload.netdev b/tests/py/inet/ip_tcp.t.payload.netdev
index 915a78706d598..bef0d6f575a98 100644
--- a/tests/py/inet/ip_tcp.t.payload.netdev
+++ b/tests/py/inet/ip_tcp.t.payload.netdev
@@ -1,53 +1,52 @@
 # ip protocol tcp tcp dport 22
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp ip saddr 1.2.3.4 tcp dport 22
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp counter ip saddr 1.2.3.4 tcp dport 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp counter tcp dport 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ether type ip tcp dport 22
 netdev test-netdev ingress
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
+  [ cmp eq reg 1 0x0016 ]
diff --git a/tests/py/inet/ipsec.t.payload b/tests/py/inet/ipsec.t.payload
index f8ecd9d1cc1f3..2e012db1f6436 100644
--- a/tests/py/inet/ipsec.t.payload
+++ b/tests/py/inet/ipsec.t.payload
@@ -16,12 +16,12 @@ ip ipsec-ip4 ipsec-input
 # ipsec out spi 1-561
 inet ipsec-inet ipsec-post
   [ xfrm load out 0 spi => reg 1 ]
-  [ range eq reg 1 0x01000000 0x31020000 ]
+  [ range eq reg 1 0x00000001 0x00000231 ]
 
 # ipsec in spnum 2 ip saddr { 1.2.3.4, 10.6.0.0/16 }
 __set%d ipsec-ip4 7 size 5
 __set%d ipsec-ip4 0
-        element 00000000  : 1 [end]     element 04030201  : 0 [end]     element 05030201  : 1 [end]     element 0000060a  : 0 [end]     element 0000070a  : 1 [end]
+	element 00000000 flags 1	element 01020304	element 01020305 flags 1	element 0a060000	element 0a070000 flags 1
 ip ipsec-ip4 ipsec-input
   [ xfrm load in 2 saddr4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -29,16 +29,15 @@ ip ipsec-ip4 ipsec-input
 # ipsec in ip6 daddr dead::beef
 ip ipsec-ip4 ipsec-forw
   [ xfrm load in 0 daddr6 => reg 1 ]
-  [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
+  [ cmp eq reg 1 0xdead0000 0x00000000 0x00000000 0x0000beef ]
 
 # ipsec out ip6 saddr dead::feed
 ip ipsec-ip4 ipsec-forw
   [ xfrm load out 0 saddr6 => reg 1 ]
-  [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xedfe0000 ]
+  [ cmp eq reg 1 0xdead0000 0x00000000 0x00000000 0x0000feed ]
 
 # counter ipsec out ip daddr 192.168.1.2
 ip ipsec-ip4 ipsec-forw
   [ counter pkts 0 bytes 0 ]
   [ xfrm load out 0 daddr4 => reg 1 ]
-  [ cmp eq reg 1 0x0201a8c0 ]
-
+  [ cmp eq reg 1 0xc0a80102 ]
diff --git a/tests/py/inet/map.t.payload b/tests/py/inet/map.t.payload
index 50344ada9161a..f9ab4ef6d9125 100644
--- a/tests/py/inet/map.t.payload
+++ b/tests/py/inet/map.t.payload
@@ -1,10 +1,10 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
 __map%d test-inet b
 __map%d test-inet 0
-	element 0203020a  : 0000002a 0 [end]	element 0103020a  : 00000017 0 [end]
+	element 0a020302 : 0000002a	element 0a020301 : 00000017
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
@@ -12,12 +12,11 @@ inet test-inet input
 # mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
+	element 05 : 00000017	element 04 : 00000001
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
-
diff --git a/tests/py/inet/map.t.payload.ip b/tests/py/inet/map.t.payload.ip
index 3e45667573394..33c03e49d17f9 100644
--- a/tests/py/inet/map.t.payload.ip
+++ b/tests/py/inet/map.t.payload.ip
@@ -1,7 +1,7 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 0203020a  : 0000002a 0 [end]	element 0103020a  : 00000017 0 [end]
+	element 0a020302 : 0000002a	element 0a020301 : 00000017
 ip test-ip4 input 
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -10,10 +10,9 @@ ip test-ip4 input
 # mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
+	element 05 : 00000017	element 04 : 00000001
 ip test-ip4 input 
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
-
diff --git a/tests/py/inet/map.t.payload.netdev b/tests/py/inet/map.t.payload.netdev
index 2e60f09d752d6..af1cfeb72a630 100644
--- a/tests/py/inet/map.t.payload.netdev
+++ b/tests/py/inet/map.t.payload.netdev
@@ -1,10 +1,10 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 0203020a  : 0000002a 0 [end]	element 0103020a  : 00000017 0 [end]
+	element 0a020302 : 0000002a	element 0a020301 : 00000017
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
@@ -12,12 +12,11 @@ netdev test-netdev ingress
 # mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
+	element 05 : 00000017	element 04 : 00000001
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
-
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index 04dfbd8fbd335..44c18c63ec739 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -1,17 +1,17 @@
 # meta nfproto ipv4
 ip test-ip4 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
 
 # meta nfproto ipv6
 ip test-ip4 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
 
 # meta nfproto {ipv4, ipv6}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
+	element 02	element 0a
 ip test-ip4 input
   [ meta load nfproto => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -19,7 +19,7 @@ ip test-ip4 input
 # meta nfproto != {ipv4, ipv6}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
+	element 02	element 0a
 ip test-ip4 input
   [ meta load nfproto => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -27,52 +27,52 @@ ip test-ip4 input
 # meta nfproto ipv6 tcp dport 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # meta nfproto ipv4 tcp dport 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # meta nfproto ipv4 ip saddr 1.2.3.4
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
 
 # meta nfproto ipv6 meta l4proto tcp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # meta nfproto ipv4 counter ip saddr 1.2.3.4
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
 
 # meta ipsec exists
 inet test-inet input
   [ meta load secpath => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # meta secpath missing
 inet test-inet input
   [ meta load secpath => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # meta mark set ct mark >> 8
 inet test-inet input
@@ -92,28 +92,28 @@ inet test-inet input
 # meta protocol ip udp dport 67
 inet test-inet input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00004300 ]
+  [ cmp eq reg 1 0x0043 ]
 
 # meta protocol ip6 udp dport 67
 inet test-inet input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00004300 ]
+  [ cmp eq reg 1 0x0043 ]
 
 # meta mark . tcp dport { 0x0000000a-0x00000014 . 80-90, 0x00100000-0x00100123 . 100-120 }
 __set%d test-inet 87 size 1
 __set%d test-inet 0
-	element 0a000000 00005000  - 14000000 00005a00  : 0 [end]       element 00001000 00006400  - 23011000 00007800  : 0 [end]
+	element 0000000a . 0050 - 00000014 . 005a	element 00100000 . 0064 - 00100123 . 0078
 ip test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ meta load mark => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
@@ -122,10 +122,10 @@ ip test-inet input
 # ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 1.2.3.6-1.2.3.8 . 0x00000200-0x00000300 }
 __set%d test-inet 87 size 2
 __set%d test-inet 0
-        element 04030201 00010000  - 04030201 00010000  : 0 [end]       element 06030201 00020000  - 08030201 00030000  : 0 [end]
+	element 01020304 . 00000100 - 01020304 . 00000100	element 01020306 . 00000200 - 01020308 . 00000300
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ meta load mark => reg 9 ]
   [ byteorder reg 9 = hton(reg 9, 4, 4) ]
@@ -134,10 +134,10 @@ inet test-inet input
 # ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 5.6.7.8 . 0x00000200 }
 __set%d test-inet 3 size 2
 __set%d test-inet 0
-        element 04030201 00000100  : 0 [end]    element 08070605 00000200  : 0 [end]
+	element 01020304 . 00000100	element 05060708 . 00000200
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ meta load mark => reg 9 ]
   [ lookup reg 1 set __set%d ]
@@ -145,18 +145,18 @@ inet test-inet input
 # meta mark set ip dscp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ meta set mark with reg 1 ]
 
 # meta mark set ip dscp | 0x40
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffbf ) ^ 0x00000040 ]
   [ meta set mark with reg 1 ]
@@ -164,9 +164,9 @@ inet test-inet input
 # meta mark set ip6 dscp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ meta set mark with reg 1 ]
@@ -174,9 +174,9 @@ inet test-inet input
 # meta mark set ip6 dscp | 0x40
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffbf ) ^ 0x00000040 ]
@@ -185,14 +185,13 @@ inet test-inet input
 # ip saddr . ether saddr . meta l4proto { 1.2.3.4 . aa:bb:cc:dd:ee:ff . 6 }
 __set%d test-inet 3 size 1
 __set%d test-inet 0
-	element 04030201 ddccbbaa 0000ffee 00000006  : 0 [end]
+	element 01020304 . aabbccdd eeff . 06
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 6b @ link header + 6 => reg 9 ]
   [ meta load l4proto => reg 11 ]
   [ lookup reg 1 set __set%d ]
-
diff --git a/tests/py/inet/osf.t.payload b/tests/py/inet/osf.t.payload
index 6ddab9763b649..65d0a2e01a8d6 100644
--- a/tests/py/inet/osf.t.payload
+++ b/tests/py/inet/osf.t.payload
@@ -1,27 +1,27 @@
 # osf name "Linux"
 inet osfinet osfchain
   [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x4c696e75 0x78000000 0x00000000 0x00000000 ]
 
 # osf ttl loose name "Linux"
 inet osfinet osfchain
   [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x4c696e75 0x78000000 0x00000000 0x00000000 ]
 
 # osf ttl skip name "Linux"
 inet osfinet osfchain
   [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x4c696e75 0x78000000 0x00000000 0x00000000 ]
 
 # osf ttl skip version "Linux:3.0"
 inet osfinet osfchain
   [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
+  [ cmp eq reg 1 0x4c696e75 0x783a332e 0x30000000 0x00000000 ]
 
 # osf name { "Windows", "MacOs" }
 __set%d osfinet 3 size 2
 __set%d osfinet 0
-	element 646e6957 0073776f 00000000 00000000  : 0 [end]	element 4f63614d 00000073 00000000 00000000  : 0 [end]
+	element 57696e64 6f777300 00000000 00000000	element 4d61634f 73000000 00000000 00000000
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -29,7 +29,7 @@ inet osfinet osfchain
 # osf version { "Windows:XP", "MacOs:Sierra" }
 __set%d osfinet 3 size 2
 __set%d osfinet 0
-	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
+	element 57696e64 6f77733a 58500000 00000000	element 4d61634f 733a5369 65727261 00000000
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -37,7 +37,7 @@ inet osfinet osfchain
 # ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
 __map%d osfinet b size 2
 __map%d osfinet 0
-	element 646e6957 0073776f 00000000 00000000  : 00000001 0 [end]	element 4f63614d 00000073 00000000 00000000  : 00000002 0 [end]
+	element 57696e64 6f777300 00000000 00000000 : 00000001	element 4d61634f 73000000 00000000 00000000 : 00000002
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -46,7 +46,7 @@ inet osfinet osfchain
 # ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
 __map%d osfinet b size 2
 __map%d osfinet 0
-	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
+	element 57696e64 6f77733a 58500000 00000000 : 00000003	element 4d61634f 733a5369 65727261 00000000 : 00000004
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
diff --git a/tests/py/inet/payloadmerge.t.payload b/tests/py/inet/payloadmerge.t.payload
index a0465cdd080ca..e94adcc5f437a 100644
--- a/tests/py/inet/payloadmerge.t.payload
+++ b/tests/py/inet/payloadmerge.t.payload
@@ -1,66 +1,65 @@
 # tcp sport 1 tcp dport 2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x02000100 ]
+  [ cmp eq reg 1 0x00010002 ]
 
 # tcp sport != 1 tcp dport != 2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000100 ]
+  [ cmp neq reg 1 0x0001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00000200 ]
+  [ cmp neq reg 1 0x0002 ]
 
 # tcp sport 1 tcp dport != 2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00000200 ]
+  [ cmp neq reg 1 0x0002 ]
 
 # tcp sport != 1 tcp dport 2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000100 ]
+  [ cmp neq reg 1 0x0001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ cmp eq reg 1 0x0002 ]
 
 # meta l4proto != 6 th dport 2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
+  [ cmp neq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ cmp eq reg 1 0x0002 ]
 
 # meta l4proto 6 tcp dport 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # tcp sport > 1 tcp dport > 2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gt reg 1 0x00000100 ]
+  [ cmp gt reg 1 0x0001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gt reg 1 0x00000200 ]
+  [ cmp gt reg 1 0x0002 ]
 
 # tcp sport 1 tcp dport > 2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gt reg 1 0x00000200 ]
-
+  [ cmp gt reg 1 0x0002 ]
diff --git a/tests/py/inet/reject.t.payload.inet b/tests/py/inet/reject.t.payload.inet
index 828cb839c30cc..00f3f2ad3bed6 100644
--- a/tests/py/inet/reject.t.payload.inet
+++ b/tests/py/inet/reject.t.payload.inet
@@ -1,73 +1,73 @@
 # reject with icmp host-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 1 ]
 
 # reject with icmp net-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 0 ]
 
 # reject with icmp prot-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 2 ]
 
 # reject with icmp port-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 3 ]
 
 # reject with icmp net-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 9 ]
 
 # reject with icmp host-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 10 ]
 
 # reject with icmp admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 13 ]
 
 # reject with icmpv6 no-route
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ reject type 0 code 0 ]
 
 # reject with icmpv6 admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ reject type 0 code 1 ]
 
 # reject with icmpv6 addr-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ reject type 0 code 3 ]
 
 # reject with icmpv6 port-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ reject type 0 code 4 ]
 
 # mark 12345 reject with tcp reset
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ meta load mark => reg 1 ]
   [ cmp eq reg 1 0x00003039 ]
   [ reject type 1 code 0 ]
@@ -79,13 +79,13 @@ inet test-inet input
 # meta nfproto ipv4 reject
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 3 ]
 
 # meta nfproto ipv6 reject
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ reject type 0 code 4 ]
 
 # reject with icmpx host-unreachable
@@ -111,34 +111,33 @@ inet test-inet input
 # meta nfproto ipv4 reject with icmp host-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 0 code 1 ]
 
 # meta nfproto ipv6 reject with icmpv6 no-route
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ reject type 0 code 0 ]
 
 # meta nfproto ipv4 reject with icmpx admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ reject type 2 code 3 ]
 
 # meta nfproto ipv6 reject with icmpx admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ reject type 2 code 3 ]
 
 # ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject
 inet test-inet input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0xddccbbaa 0x0008ffee ]
+  [ cmp eq reg 1 0xaabbccdd 0xeeff0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
   [ reject type 0 code 3 ]
-
diff --git a/tests/py/inet/rt.t.payload b/tests/py/inet/rt.t.payload
index 84dea12caad5d..3d65fef625a45 100644
--- a/tests/py/inet/rt.t.payload
+++ b/tests/py/inet/rt.t.payload
@@ -1,18 +1,17 @@
 # meta nfproto ipv4 rt nexthop 192.168.0.1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ rt load nexthop4 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # rt ip6 nexthop fd00::1
 inet test-inet output
   [ rt load nexthop6 => reg 1 ]
-  [ cmp eq reg 1 0x000000fd 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0xfd000000 0x00000000 0x00000000 0x00000001 ]
 
 # tcp option maxseg size set rt mtu
 inet test-inet output
   [ rt load tcpmss => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 2, 2) ]
   [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
-
diff --git a/tests/py/inet/sctp.t.payload b/tests/py/inet/sctp.t.payload
index 0f6b3a8b1fc84..baeda137c3b28 100644
--- a/tests/py/inet/sctp.t.payload
+++ b/tests/py/inet/sctp.t.payload
@@ -1,347 +1,346 @@
 # sctp sport 23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
+  [ cmp eq reg 1 0x0017 ]
 
 # sctp sport != 23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
+  [ cmp neq reg 1 0x0017 ]
 
 # sctp sport 23-44
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x00001700 0x00002c00 ]
+  [ range eq reg 1 0x0017 0x002c ]
 
 # sctp sport != 23-44
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
+  [ range neq reg 1 0x0017 0x002c ]
 
 # sctp sport { 23, 24, 25}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # sctp sport != { 23, 24, 25}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # sctp dport 23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
+  [ cmp eq reg 1 0x0017 ]
 
 # sctp dport != 23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
+  [ cmp neq reg 1 0x0017 ]
 
 # sctp dport 23-44
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00001700 0x00002c00 ]
+  [ range eq reg 1 0x0017 0x002c ]
 
 # sctp dport != 23-44
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
+  [ range neq reg 1 0x0017 0x002c ]
 
 # sctp dport { 23, 24, 25}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # sctp dport != { 23, 24, 25}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+	element 0017	element 0018	element 0019
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # sctp checksum 1111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x57040000 ]
+  [ cmp eq reg 1 0x00000457 ]
 
 # sctp checksum != 11
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x0b000000 ]
+  [ cmp neq reg 1 0x0000000b ]
 
 # sctp checksum 21-333
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range eq reg 1 0x15000000 0x4d010000 ]
+  [ range eq reg 1 0x00000015 0x0000014d ]
 
 # sctp checksum != 32-111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x20000000 0x6f000000 ]
+  [ range neq reg 1 0x00000020 0x0000006f ]
 
 # sctp checksum { 22, 33, 44}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
+	element 00000016	element 00000021	element 0000002c
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # sctp checksum != { 22, 33, 44}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
+	element 00000016	element 00000021	element 0000002c
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # sctp vtag 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # sctp vtag != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
+  [ cmp neq reg 1 0x000000e9 ]
 
 # sctp vtag 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # sctp vtag != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # sctp vtag {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # sctp vtag != {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # sctp chunk data exists
 ip
   [ exthdr load 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk init exists
 ip
   [ exthdr load 1b @ 1 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk init-ack exists
 ip
   [ exthdr load 1b @ 2 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk sack exists
 ip
   [ exthdr load 1b @ 3 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk heartbeat exists
 ip
   [ exthdr load 1b @ 4 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk heartbeat-ack exists
 ip
   [ exthdr load 1b @ 5 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk abort exists
 ip
   [ exthdr load 1b @ 6 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk shutdown exists
 ip
   [ exthdr load 1b @ 7 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk shutdown-ack exists
 ip
   [ exthdr load 1b @ 8 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk error exists
 ip
   [ exthdr load 1b @ 9 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk cookie-echo exists
 ip
   [ exthdr load 1b @ 10 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk cookie-ack exists
 ip
   [ exthdr load 1b @ 11 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk ecne exists
 ip
   [ exthdr load 1b @ 12 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk cwr exists
 ip
   [ exthdr load 1b @ 13 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk shutdown-complete exists
 ip
   [ exthdr load 1b @ 14 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk asconf-ack exists
 ip
   [ exthdr load 1b @ 128 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk forward-tsn exists
 ip
   [ exthdr load 1b @ 192 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk asconf exists
 ip
   [ exthdr load 1b @ 193 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # sctp chunk data type 0
 ip
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # sctp chunk init flags 23
 ip
   [ exthdr load 1b @ 1 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000017 ]
+  [ cmp eq reg 1 0x17 ]
 
 # sctp chunk init-ack length 42
 ip
   [ exthdr load 2b @ 2 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00002a00 ]
+  [ cmp eq reg 1 0x002a ]
 
 # sctp chunk data stream 1337
 ip
   [ exthdr load 2b @ 0 + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003905 ]
+  [ cmp eq reg 1 0x0539 ]
 
 # sctp chunk init initial-tsn 5
 ip
   [ exthdr load 4b @ 1 + 16 => reg 1 ]
-  [ cmp eq reg 1 0x05000000 ]
+  [ cmp eq reg 1 0x00000005 ]
 
 # sctp chunk init-ack num-outbound-streams 3
 ip
   [ exthdr load 2b @ 2 + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000300 ]
+  [ cmp eq reg 1 0x0003 ]
 
 # sctp chunk sack a-rwnd 1
 ip
   [ exthdr load 4b @ 3 + 8 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # sctp chunk shutdown cum-tsn-ack 65535
 ip
   [ exthdr load 4b @ 7 + 4 => reg 1 ]
-  [ cmp eq reg 1 0xffff0000 ]
+  [ cmp eq reg 1 0x0000ffff ]
 
 # sctp chunk ecne lowest-tsn 5
 ip
   [ exthdr load 4b @ 12 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x05000000 ]
+  [ cmp eq reg 1 0x00000005 ]
 
 # sctp chunk cwr lowest-tsn 8
 ip
   [ exthdr load 4b @ 13 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x08000000 ]
+  [ cmp eq reg 1 0x00000008 ]
 
 # sctp chunk asconf-ack seqno 12345
 ip
   [ exthdr load 4b @ 128 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x39300000 ]
+  [ cmp eq reg 1 0x00003039 ]
 
 # sctp chunk forward-tsn new-cum-tsn 31337
 ip
   [ exthdr load 4b @ 192 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x697a0000 ]
+  [ cmp eq reg 1 0x00007a69 ]
 
 # sctp chunk asconf seqno 12345
 ip
   [ exthdr load 4b @ 193 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x39300000 ]
-
+  [ cmp eq reg 1 0x00003039 ]
diff --git a/tests/py/inet/sets.t.payload.bridge b/tests/py/inet/sets.t.payload.bridge
index 3dd9d57bc0ce8..c5be4cae0f730 100644
--- a/tests/py/inet/sets.t.payload.bridge
+++ b/tests/py/inet/sets.t.payload.bridge
@@ -1,7 +1,7 @@
 # ip saddr @set1 drop
 bridge test-inet input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
@@ -9,7 +9,7 @@ bridge test-inet input
 # ip6 daddr != @set2 accept
 bridge test-inet input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 accept ]
@@ -17,9 +17,9 @@ bridge test-inet input
 # ip saddr . ip daddr . tcp dport @set3 accept
 bridge 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 2b @ transport header + 2 => reg 10 ]
@@ -29,14 +29,13 @@ bridge
 # ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
 __set%d test-inet 87
 __set%d test-inet 0
-        element 0000000a 00000a00  - ffffff0a 00001700  : 0 [end]    element 0101a8c0 00005000  - 0803a8c0 0000bb01  : 0 [end]
+	element 0a000000 . 000a - 0affffff . 0017	element c0a80101 . 0050 - c0a80308 . 01bb
 bridge 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
-
diff --git a/tests/py/inet/sets.t.payload.inet b/tests/py/inet/sets.t.payload.inet
index 53c6b1821af7c..8c903b35aa49c 100644
--- a/tests/py/inet/sets.t.payload.inet
+++ b/tests/py/inet/sets.t.payload.inet
@@ -1,7 +1,7 @@
 # ip saddr @set1 drop
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
@@ -9,7 +9,7 @@ inet test-inet input
 # ip6 daddr != @set2 accept
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 accept ]
@@ -17,9 +17,9 @@ inet test-inet input
 # ip saddr . ip daddr . tcp dport @set3 accept
 inet 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 2b @ transport header + 2 => reg 10 ]
@@ -29,12 +29,12 @@ inet
 # ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
 __set%d test-inet 87
 __set%d test-inet 0
-        element 0000000a 00000a00  - ffffff0a 00001700  : 0 [end]    element 0101a8c0 00005000  - 0803a8c0 0000bb01  : 0 [end]
+	element 0a000000 . 000a - 0affffff . 0017	element c0a80101 . 0050 - c0a80308 . 01bb
 inet 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __set%d ]
diff --git a/tests/py/inet/sets.t.payload.netdev b/tests/py/inet/sets.t.payload.netdev
index e31aeb9274e66..376600152cc38 100644
--- a/tests/py/inet/sets.t.payload.netdev
+++ b/tests/py/inet/sets.t.payload.netdev
@@ -1,7 +1,7 @@
 # ip saddr @set1 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
@@ -9,7 +9,7 @@ netdev test-netdev ingress
 # ip6 daddr != @set2 accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 accept ]
@@ -17,9 +17,9 @@ netdev test-netdev ingress
 # ip saddr . ip daddr . tcp dport @set3 accept
 netdev
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 2b @ transport header + 2 => reg 10 ]
@@ -29,12 +29,12 @@ netdev
 # ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
 __set%d test-netdev 87
 __set%d test-netdev 0
-        element 0000000a 00000a00  - ffffff0a 00001700  : 0 [end]    element 0101a8c0 00005000  - 0803a8c0 0000bb01  : 0 [end]
+	element 0a000000 . 000a - 0affffff . 0017	element c0a80101 . 0050 - c0a80308 . 01bb
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __set%d ]
diff --git a/tests/py/inet/snat.t.payload b/tests/py/inet/snat.t.payload
index 50519c6b6bb6f..3399d33ece150 100644
--- a/tests/py/inet/snat.t.payload
+++ b/tests/py/inet/snat.t.payload
@@ -1,42 +1,42 @@
 # iifname "eth0" tcp dport 81 snat ip to 192.168.3.2
 inet test-inet postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005100 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ cmp eq reg 1 0x0051 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat to 192.168.3.2
 inet test-inet postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005100 ]
+  [ cmp eq reg 1 0x0051 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0101010a ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ cmp eq reg 1 0x0a010101 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 81 snat ip6 to dead::beef
 inet test-inet postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005100 ]
-  [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
+  [ cmp eq reg 1 0x0051 ]
+  [ immediate reg 1 0xdead0000 0x00000000 0x00000000 0x0000beef ]
   [ nat snat ip6 addr_min reg 1 ]
 
 # iifname "foo" masquerade random
 inet test-inet postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x666f6f00 0x00000000 0x00000000 0x00000000 ]
   [ masq flags 0x4 ]
diff --git a/tests/py/inet/socket.t.payload b/tests/py/inet/socket.t.payload
index e66ccbf70aeaf..c3520db81833c 100644
--- a/tests/py/inet/socket.t.payload
+++ b/tests/py/inet/socket.t.payload
@@ -1,12 +1,12 @@
 # socket transparent 0
 inet sockin sockchain 
   [ socket load transparent => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # socket transparent 1
 inet sockin sockchain 
   [ socket load transparent => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # socket mark 0x00000005
 inet sockin sockchain 
@@ -16,9 +16,9 @@ inet sockin sockchain
 # socket wildcard 0
 inet sockin sockchain
   [ socket load wildcard => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # socket wildcard 1
 inet sockin sockchain
   [ socket load wildcard => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 5c36ad3e4a214..cbf433a508eae 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -1,58 +1,58 @@
 # tcp dport 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # tcp dport != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # tcp dport 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # tcp dport != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # tcp dport { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp dport != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp dport {telnet, http, https} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
+	element 0017	element 0050	element 01bb
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -60,259 +60,259 @@ inet test-inet input
 # tcp dport vmap { 22 : accept, 23 : drop }
 __map%d test-inet b
 __map%d test-inet 0
-	element 00001600  : accept 0 [end]	element 00001700  : drop 0 [end]
+	element 0016 : accept	element 0017 : drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport vmap { 25:accept, 28:drop }
 __map%d test-inet b
 __map%d test-inet 0
-	element 00001900  : accept 0 [end]	element 00001c00  : drop 0 [end]
+	element 0019 : accept	element 001c : drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport { 22, 53, 80, 110 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
+	element 0016	element 0035	element 0050	element 006e
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp dport != { 22, 53, 80, 110 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
+	element 0016	element 0035	element 0050	element 006e
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp sport 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # tcp sport != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # tcp sport 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # tcp sport != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # tcp sport { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp sport != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp sport vmap { 25:accept, 28:drop }
 __map%d test-inet b
 __map%d test-inet 0
-	element 00001900  : accept 0 [end]	element 00001c00  : drop 0 [end]
+	element 0019 : accept	element 001c : drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp sport 8080 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000901f ]
+  [ cmp eq reg 1 0x1f90 ]
   [ immediate reg 0 drop ]
 
 # tcp sport 1024 tcp dport 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 ]
+  [ cmp eq reg 1 0x04000016 ]
 
 # tcp sport 1024 tcp dport 22 tcp sequence 0
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 ]
+  [ cmp eq reg 1 0x04000016 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # tcp sequence 0 tcp sport 1024 tcp dport 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 ]
+  [ cmp eq reg 1 0x04000016 ]
 
 # tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
+	element 0400	element 03fe
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # tcp sequence 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # tcp sequence != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
+  [ cmp neq reg 1 0x000000e9 ]
 
 # tcp sequence 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # tcp sequence != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # tcp sequence { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp sequence != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp ackseq 42949672 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x285c8f02 ]
+  [ cmp eq reg 1 0x028f5c28 ]
   [ immediate reg 0 drop ]
 
 # tcp ackseq 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # tcp ackseq != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
+  [ cmp neq reg 1 0x000000e9 ]
 
 # tcp ackseq 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # tcp ackseq != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # tcp ackseq { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp ackseq != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
+	element 01	element 02	element 04	element 08	element 10	element 20	element 40	element 80
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
@@ -320,10 +320,10 @@ inet test-inet input
 # tcp flags != { fin, urg, ecn, cwr} drop
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
+	element 01	element 20	element 40	element 80
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 drop ]
@@ -331,337 +331,337 @@ inet test-inet input
 # tcp flags cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x80 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x00 ]
 
 # tcp flags != cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ cmp neq reg 1 0x00000080 ]
+  [ cmp neq reg 1 0x80 ]
 
 # tcp flags == syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
 
 # tcp flags fin,syn / fin,syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ bitwise reg 1 = ( reg 1 & 0x03 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x03 ]
 
 # tcp flags != syn / fin,syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x03 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x02 ]
 
 # tcp flags & syn != 0
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x02 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x00 ]
 
 # tcp flags & syn == 0
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x02 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # tcp flags & (syn | ack) != 0
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000012 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x12 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x00 ]
 
 # tcp flags & (syn | ack) == 0
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000012 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x12 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # tcp flags & syn == syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x02 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x02 ]
 
 # tcp flags & syn != syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x02 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x02 ]
 
 # tcp flags & (fin | syn | rst | ack) syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x17 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x02 ]
 
 # tcp flags & (fin | syn | rst | ack) == syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x17 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x02 ]
 
 # tcp flags & (fin | syn | rst | ack) != syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x17 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x02 ]
 
 # tcp flags & (fin | syn | rst | ack) == syn | ack
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000012 ]
+  [ bitwise reg 1 = ( reg 1 & 0x17 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x12 ]
 
 # tcp flags & (fin | syn | rst | ack) != syn | ack
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000012 ]
+  [ bitwise reg 1 = ( reg 1 & 0x17 ) ^ 0x00 ]
+  [ cmp neq reg 1 0x12 ]
 
 # tcp flags & (syn | ack) == syn | ack
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000012 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000012 ]
+  [ bitwise reg 1 = ( reg 1 & 0x12 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x12 ]
 
 # tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x000000ff ]
+  [ bitwise reg 1 = ( reg 1 & 0xff ) ^ 0x00 ]
+  [ cmp eq reg 1 0xff ]
 
 # tcp window 22222
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0000ce56 ]
+  [ cmp eq reg 1 0x56ce ]
 
 # tcp window 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # tcp window != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # tcp window 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # tcp window != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # tcp window { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp window != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp checksum 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # tcp checksum != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # tcp checksum 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # tcp checksum != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # tcp checksum { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp checksum != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp urgptr 1234 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000d204 ]
+  [ cmp eq reg 1 0x04d2 ]
   [ immediate reg 0 accept ]
 
 # tcp urgptr 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # tcp urgptr != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # tcp urgptr 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # tcp urgptr != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # tcp urgptr { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp urgptr != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp doff 8
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x80 ]
 
 # tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000001  : 0 [end]     element 00000010  : 0 [end]     element 00000018  : 0 [end]     element 00000019  : 0 [end]
+	element 01	element 10	element 18	element 19
 ip
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x3f ) ^ 0x00 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp flags { syn, syn | ack }
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000002  : 0 [end]     element 00000012  : 0 [end]
+	element 02	element 12
 inet
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp flags ! fin,rst
 inet
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000005 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x05 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
diff --git a/tests/py/inet/tproxy.t.payload b/tests/py/inet/tproxy.t.payload
index 2f41904261144..ac30070ab910b 100644
--- a/tests/py/inet/tproxy.t.payload
+++ b/tests/py/inet/tproxy.t.payload
@@ -1,75 +1,74 @@
 # meta l4proto 17 tproxy ip to 192.0.2.1
 inet x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x010200c0 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0xc0000201 ]
   [ tproxy ip addr reg 1 ]
 
 # meta l4proto 6 tproxy ip to 192.0.2.1:50080
 inet x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x010200c0 ]
-  [ immediate reg 2 0x0000a0c3 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0xc0000201 ]
+  [ immediate reg 2 0xc3a0 ]
   [ tproxy ip addr reg 1 port reg 2 ]
 
 # meta l4proto 6 tproxy ip6 to [2001:db8::1]
 inet x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0xb80d0120 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x20010db8 0x00000000 0x00000000 0x00000001 ]
   [ tproxy ip6 addr reg 1 ]
 
 # meta l4proto 17 tproxy ip6 to [2001:db8::1]:50080
 inet x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0xb80d0120 0x00000000 0x00000000 0x01000000 ]
-  [ immediate reg 2 0x0000a0c3 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0x20010db8 0x00000000 0x00000000 0x00000001 ]
+  [ immediate reg 2 0xc3a0 ]
   [ tproxy ip6 addr reg 1 port reg 2 ]
 
 # meta l4proto 17 tproxy to :50080
 inet x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x0000a0c3 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0xc3a0 ]
   [ tproxy port reg 1 ]
 
 # meta l4proto 17 tproxy ip to :50080
 inet x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x0000a0c3 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0xc3a0 ]
   [ tproxy ip port reg 1 ]
 
 # meta l4proto 17 tproxy ip6 to :50080
 inet x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x0000a0c3 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0xc3a0 ]
   [ tproxy ip6 port reg 1 ]
 
 # ip daddr 0.0.0.0/0 meta l4proto 6 tproxy ip to :2000
 inet x y 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x00000000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x0000d007 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x07d0 ]
   [ tproxy ip port reg 1 ]
 
 # meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 23, 1 : 42 }
 __map%d x b size 2
 __map%d x 0
-	element 00000000  : 00001700 0 [end]	element 00000001  : 00002a00 0 [end]
+	element 00000000 : 0017	element 00000001 : 002a
 inet x y
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x0100007f ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x7f000001 ]
   [ hash reg 2 = symhash() % mod 2 ]
   [ lookup reg 2 set __map%d dreg 2 ]
   [ tproxy ip addr reg 1 port reg 2 ]
-
diff --git a/tests/py/inet/udp.t.payload b/tests/py/inet/udp.t.payload
index d2c62d92653b4..7731137878706 100644
--- a/tests/py/inet/udp.t.payload
+++ b/tests/py/inet/udp.t.payload
@@ -1,42 +1,42 @@
 # udp sport 80 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
+  [ cmp eq reg 1 0x0050 ]
   [ immediate reg 0 accept ]
 
 # udp sport != 60 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
+  [ cmp neq reg 1 0x003c ]
   [ immediate reg 0 accept ]
 
 # udp sport 50-70 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x00003200 0x00004600 ]
+  [ range eq reg 1 0x0032 0x0046 ]
   [ immediate reg 0 accept ]
 
 # udp sport != 50-60 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
+  [ range neq reg 1 0x0032 0x003c ]
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+	element 0031	element 0032
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
@@ -44,10 +44,10 @@ inet test-inet input
 # udp sport != { 50, 60} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+	element 0032	element 003c
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -55,42 +55,42 @@ inet test-inet input
 # udp dport 80 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
+  [ cmp eq reg 1 0x0050 ]
   [ immediate reg 0 accept ]
 
 # udp dport != 60 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
+  [ cmp neq reg 1 0x003c ]
   [ immediate reg 0 accept ]
 
 # udp dport 70-75 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00004600 0x00004b00 ]
+  [ range eq reg 1 0x0046 0x004b ]
   [ immediate reg 0 accept ]
 
 # udp dport != 50-60 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
+  [ range neq reg 1 0x0032 0x003c ]
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+	element 0031	element 0032
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
@@ -98,10 +98,10 @@ inet test-inet input
 # udp dport != { 50, 60} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+	element 0032	element 003c
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -109,40 +109,40 @@ inet test-inet input
 # udp length 6666
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
+  [ cmp eq reg 1 0x1a0a ]
 
 # udp length != 6666
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x00000a1a ]
+  [ cmp neq reg 1 0x1a0a ]
 
 # udp length 50-65 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x00003200 0x00004100 ]
+  [ range eq reg 1 0x0032 0x0041 ]
   [ immediate reg 0 accept ]
 
 # udp length != 50-65 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00004100 ]
+  [ range neq reg 1 0x0032 0x0041 ]
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+	element 0032	element 0041
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -150,10 +150,10 @@ inet test-inet input
 # udp length != { 50, 65} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+	element 0032	element 0041
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -161,18 +161,18 @@ inet test-inet input
 # udp checksum 6666 drop
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
+  [ cmp eq reg 1 0x1a0a ]
   [ immediate reg 0 drop ]
 
 # udp checksum != { 444, 555} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+	element 01bc	element 022b
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -180,48 +180,48 @@ inet test-inet input
 # udp checksum 22
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # udp checksum != 233
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # udp checksum 33-45
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # udp checksum != 33-45
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # udp checksum { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # udp checksum != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -230,8 +230,8 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ transport header + 6 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # iif "lo" udp dport set 65535
@@ -239,6 +239,6 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x0000ffff ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0xffff ]
   [ payload write reg 1 => 2b @ transport header + 2 csum_type 0 csum_off 0 csum_flags 0x1 ]
diff --git a/tests/py/inet/udplite.t.payload b/tests/py/inet/udplite.t.payload
index dbaeaa78c3542..945b3051bf092 100644
--- a/tests/py/inet/udplite.t.payload
+++ b/tests/py/inet/udplite.t.payload
@@ -1,42 +1,42 @@
 # udplite sport 80 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
+  [ cmp eq reg 1 0x0050 ]
   [ immediate reg 0 accept ]
 
 # udplite sport != 60 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
+  [ cmp neq reg 1 0x003c ]
   [ immediate reg 0 accept ]
 
 # udplite sport 50-70 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x00003200 0x00004600 ]
+  [ range eq reg 1 0x0032 0x0046 ]
   [ immediate reg 0 accept ]
 
 # udplite sport != 50-60 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
+  [ range neq reg 1 0x0032 0x003c ]
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+	element 0031	element 0032
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
@@ -44,10 +44,10 @@ inet test-inet input
 # udplite sport != { 49, 50} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+	element 0031	element 0032
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -55,42 +55,42 @@ inet test-inet input
 # udplite dport 80 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
+  [ cmp eq reg 1 0x0050 ]
   [ immediate reg 0 accept ]
 
 # udplite dport != 60 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
+  [ cmp neq reg 1 0x003c ]
   [ immediate reg 0 accept ]
 
 # udplite dport 70-75 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00004600 0x00004b00 ]
+  [ range eq reg 1 0x0046 0x004b ]
   [ immediate reg 0 accept ]
 
 # udplite dport != 50-60 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
+  [ range neq reg 1 0x0032 0x003c ]
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+	element 0031	element 0032
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
@@ -98,10 +98,10 @@ inet test-inet input
 # udplite dport != { 49, 50} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+	element 0031	element 0032
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -109,18 +109,18 @@ inet test-inet input
 # udplite checksum 6666 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
+  [ cmp eq reg 1 0x1a0a ]
   [ immediate reg 0 drop ]
 
 # udplite checksum != { 444, 555} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+	element 01bc	element 022b
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -128,48 +128,47 @@ inet test-inet input
 # udplite checksum 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # udplite checksum != 233
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # udplite checksum 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # udplite checksum != 33-45
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # udplite checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # udplite checksum != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/vmap.t.payload b/tests/py/inet/vmap.t.payload
index 29ec846deb2ee..c905f80eb2cf9 100644
--- a/tests/py/inet/vmap.t.payload
+++ b/tests/py/inet/vmap.t.payload
@@ -1,10 +1,10 @@
 # iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop }
 __map%d test-inet b size 2
 __map%d test-inet 0
-	element 30687465 00000000 00000000 00000000 00000006 00001600  : accept 0 [end]	element 31687465 00000000 00000000 00000000 00000011 00004300  : drop 0 [end]
+	element 65746830 00000000 00000000 00000000 . 06 . 0016 : accept	element 65746831 00000000 00000000 00000000 . 11 . 0043 : drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ meta load iifname => reg 1 ]
   [ payload load 1b @ network header + 9 => reg 2 ]
   [ payload load 2b @ transport header + 2 => reg 13 ]
@@ -13,10 +13,10 @@ inet test-inet input
 # ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
 __set%d test-inet 3 size 2
 __set%d test-inet 0
-        element 01010101 14000000  : 0 [end]    element 02020202 1e000000  : 0 [end]
+	element 01010101 . 00000014	element 02020202 . 0000001e
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ inner header + 4 => reg 9 ]
   [ lookup reg 1 set __set%d ]
@@ -24,11 +24,10 @@ inet test-inet input
 # udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
 __map%d x 8f size 1
 __map%d x 0
-	element 00002f00 3531370e 33303136 37303131 03323535  - 00003f00 3531370e 33303136 37303131 03323535  : accept 0 [end]
+	element 002f . 0e373135 36313033 31313037 35353203 - 003f . 0e373135 36313033 31313037 35353203 : accept
 inet x y
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ payload load 16b @ transport header + 20 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 0 ]
-
diff --git a/tests/py/inet/vmap.t.payload.netdev b/tests/py/inet/vmap.t.payload.netdev
index 3f51bb33054a2..881550df2883f 100644
--- a/tests/py/inet/vmap.t.payload.netdev
+++ b/tests/py/inet/vmap.t.payload.netdev
@@ -1,10 +1,10 @@
 # iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop }
 __map%d test-netdev b size 2
 __map%d test-netdev 0
-	element 30687465 00000000 00000000 00000000 00000006 00001600  : accept 0 [end]	element 31687465 00000000 00000000 00000000 00000011 00004300  : drop 0 [end]
+	element 65746830 00000000 00000000 00000000 . 06 . 0016 : accept	element 65746831 00000000 00000000 00000000 . 11 . 0043 : drop
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load iifname => reg 1 ]
   [ payload load 1b @ network header + 9 => reg 2 ]
   [ payload load 2b @ transport header + 2 => reg 13 ]
@@ -13,10 +13,10 @@ netdev test-netdev ingress
 # ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
 __set%d test-netdev 3 size 2
 __set%d test-netdev 0
-	element 01010101 14000000  : 0 [end]	element 02020202 1e000000  : 0 [end]
+	element 01010101 . 00000014	element 02020202 . 0000001e
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ inner header + 4 => reg 9 ]
   [ lookup reg 1 set __set%d ]
@@ -24,11 +24,10 @@ netdev test-netdev ingress
 # udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
 __map%d test-netdev 8f size 1
 __map%d test-netdev 0
-	element 00002f00 3531370e 33303136 37303131 03323535  - 00003f00 3531370e 33303136 37303131 03323535  : accept 0 [end]
+	element 002f . 0e373135 36313033 31313037 35353203 - 003f . 0e373135 36313033 31313037 35353203 : accept
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ payload load 16b @ transport header + 20 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 0 ]
-
diff --git a/tests/py/inet/vxlan.t.payload b/tests/py/inet/vxlan.t.payload
index b9e4ca2c57b03..f7d8116f0c2dc 100644
--- a/tests/py/inet/vxlan.t.payload
+++ b/tests/py/inet/vxlan.t.payload
@@ -1,114 +1,113 @@
 # udp dport 4789 vxlan vni 10
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 3b @ tunnel header + 4 => reg 1 ] ]
-  [ cmp eq reg 1 0x000a0000 ]
+  [ cmp eq reg 1 0x00000a ]
 
 # udp dport 4789 vxlan ip saddr 10.141.11.2
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x020b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b02 ]
 
 # udp dport 4789 vxlan ip saddr 10.141.11.0/24
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 3b @ network header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x000b8d0a ]
+  [ cmp eq reg 1 0x0a8d0b ]
 
 # udp dport 4789 vxlan ip protocol 1
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 1b @ network header + 9 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # udp dport 4789 vxlan udp sport 8888
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 2b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x0000b822 ]
+  [ cmp eq reg 1 0x22b8 ]
 
 # udp dport 4789 vxlan icmp type echo-reply
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 2b @ link header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 1 hdrsize 8 flags f [ meta load l4proto => reg 1 ] ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 1b @ transport header + 0 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # udp dport 4789 vxlan ether saddr 62:87:4d:d6:19:05
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 6b @ link header + 6 => reg 1 ] ]
-  [ cmp eq reg 1 0xd64d8762 0x00000519 ]
+  [ cmp eq reg 1 0x62874dd6 0x1905 ]
 
 # udp dport 4789 vxlan vlan id 10
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 2b @ link header + 12 => reg 1 ] ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x8100 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 2b @ link header + 14 => reg 1 ] ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000a00 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fff ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x000a ]
 
 # udp dport 4789 vxlan ip dscp 0x02
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 1b @ network header + 1 => reg 1 ] ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x08 ]
 
 # udp dport 4789 vxlan ip saddr . vxlan ip daddr { 1.2.3.4 . 4.3.2.1 }
 __set%d test-netdev 3 size 1
 __set%d test-netdev 0
-        element 04030201 01020304  : 0 [end]
+	element 01020304 . 04030201
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000b512 ]
+  [ cmp eq reg 1 0x12b5 ]
   [ inner type 1 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ inner type 1 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
   [ inner type 1 hdrsize 8 flags f [ payload load 4b @ network header + 16 => reg 9 ] ]
   [ lookup reg 1 set __set%d ]
-
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 823de59742285..6fc8b5c93ca0b 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -1,66 +1,66 @@
 # ct original ip saddr 192.168.0.1
 ip test-ip4 output
   [ ct load src_ip => reg 1 , dir original ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ct reply ip saddr 192.168.0.1
 ip test-ip4 output
   [ ct load src_ip => reg 1 , dir reply ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ct original ip daddr 192.168.0.1
 ip test-ip4 output
   [ ct load dst_ip => reg 1 , dir original ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ct reply ip daddr 192.168.0.1
 ip test-ip4 output
   [ ct load dst_ip => reg 1 , dir reply ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ct original ip saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src_ip => reg 1 , dir original ]
-  [ cmp eq reg 1 0x0001a8c0 ]
+  [ cmp eq reg 1 0xc0a801 ]
 
 # ct reply ip saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src_ip => reg 1 , dir reply ]
-  [ cmp eq reg 1 0x0001a8c0 ]
+  [ cmp eq reg 1 0xc0a801 ]
 
 # ct original ip daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst_ip => reg 1 , dir original ]
-  [ cmp eq reg 1 0x0001a8c0 ]
+  [ cmp eq reg 1 0xc0a801 ]
 
 # ct reply ip daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst_ip => reg 1 , dir reply ]
-  [ cmp eq reg 1 0x0001a8c0 ]
+  [ cmp eq reg 1 0xc0a801 ]
 
 # ct l3proto ipv4
 ip test-ip4 output
   [ ct load l3protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
 
 # ct protocol 6 ct original proto-dst 22
 ip test-ip4 output
   [ ct load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ ct load proto_dst => reg 1 , dir original ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ct original protocol 17 ct reply proto-src 53
 ip test-ip4 output
   [ ct load protocol => reg 1 , dir original ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ ct load proto_src => reg 1 , dir reply ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
 
 # meta mark set ct original ip daddr map { 1.1.1.1 : 0x00000011 }
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 01010101  : 00000011 0 [end]
+	element 01010101 : 00000011
 ip
   [ ct load dst_ip => reg 1 , dir original ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -69,7 +69,7 @@ ip
 # meta mark set ct original ip saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x0000001e }
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 01010101 00000014  : 0000001e 0 [end]
+	element 01010101 . 00000014 : 0000001e
 ip
   [ ct load src_ip => reg 1 , dir original ]
   [ meta load mark => reg 9 ]
@@ -79,7 +79,7 @@ ip
 # ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 }
 __set%d test-ip4 3
 __set%d test-ip4 0
-        element 01010101 00000014  : 0 [end]
+	element 01010101 . 00000014
 ip
   [ ct load src_ip => reg 1 , dir original ]
   [ meta load mark => reg 9 ]
@@ -88,7 +88,7 @@ ip
 # ct mark set ip dscp << 2 | 0x10
 ip test-ip4 output
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
@@ -97,7 +97,7 @@ ip test-ip4 output
 # ct mark set ip dscp << 26 | 0x10
 ip
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
@@ -106,7 +106,7 @@ ip
 # ct mark set ip dscp & 0x0f << 1
 ip test-ip4 output
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
   [ ct set mark with reg 1 ]
@@ -114,7 +114,7 @@ ip test-ip4 output
 # ct mark set ip dscp & 0x0f << 2
 ip test-ip4 output
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
   [ ct set mark with reg 1 ]
@@ -122,7 +122,7 @@ ip test-ip4 output
 # ct mark set ip dscp | 0x04
 ip test-ip4 output
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
   [ ct set mark with reg 1 ]
@@ -130,7 +130,7 @@ ip test-ip4 output
 # ct mark set ip dscp | 1 << 20
 ip test-ip4 output
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffefffff ) ^ 0x00100000 ]
   [ ct set mark with reg 1 ]
@@ -139,7 +139,7 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ payload load 1b @ network header + 1 => reg 2 ]
-  [ bitwise reg 2 = ( reg 2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffdff ) ^ 0x00000200 ]
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 72b52546c64ee..d76e9eecbf3fd 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -1,80 +1,80 @@
 # iifname "eth0" tcp dport 80-90 dnat to 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 80-90 dnat to 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ range neq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport {80, 90, 23} dnat to 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
+	element 0050	element 005a	element 0017
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
+	element 0050	element 005a	element 0017
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 23-34 dnat to 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002200 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ range neq reg 1 0x0017 0x0022 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 81 dnat to 192.168.3.2:8080
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005100 ]
-  [ immediate reg 1 0x0203a8c0 ]
-  [ immediate reg 2 0x0000901f ]
+  [ cmp eq reg 1 0x0051 ]
+  [ immediate reg 1 0xc0a80302 ]
+  [ immediate reg 2 0x1f90 ]
   [ nat dnat ip addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # dnat to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000014  : 04030201 0 [end]
+	element 00000014 : 01020304
 ip test-ip4 prerouting
   [ ct load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -83,7 +83,7 @@ ip test-ip4 prerouting
 # dnat to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000014 01010101  : 04030201 0 [end]
+	element 00000014 . 01010101 : 01020304
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
@@ -93,10 +93,10 @@ ip test-ip4 output
 # dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 8888 - 8999 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-        element 0201a8c0 00005000  : 000a8d0a 0000b822 ff0a8d0a 00002723 0 [end]
+	element c0a80102 . 0050 : 0a8d0a00 . 22b8 . 0a8d0aff . 2327
 ip
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -105,10 +105,10 @@ ip
 # dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 80 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-        element 0201a8c0 00005000  : 000a8d0a 00005000 ff0a8d0a 00005000 0 [end]
+	element c0a80102 . 0050 : 0a8d0a00 . 0050 . 0a8d0aff . 0050
 ip
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -117,10 +117,10 @@ ip
 # dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2 . 8888 - 8999 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-        element 0201a8c0 00005000  : 020a8d0a 0000b822 020a8d0a 00002723 0 [end]
+	element c0a80102 . 0050 : 0a8d0a02 . 22b8 . 0a8d0a02 . 2327
 ip
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -129,52 +129,52 @@ ip
 # iifname "eth0" tcp dport 81 dnat to 192.168.3.2:8080-8999
 ip
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005100 ]
-  [ immediate reg 1 0x0203a8c0 ]
-  [ immediate reg 2 0x0000901f ]
-  [ immediate reg 3 0x00002723 ]
+  [ cmp eq reg 1 0x0051 ]
+  [ immediate reg 1 0xc0a80302 ]
+  [ immediate reg 2 0x1f90 ]
+  [ immediate reg 3 0x2327 ]
   [ nat dnat ip addr_min reg 1 proto_min reg 2 proto_max reg 3 flags 0x2 ]
 
 # iifname "eth0" tcp dport 81 dnat to 192.168.3.2-192.168.3.4:8080
 ip
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005100 ]
-  [ immediate reg 1 0x0203a8c0 ]
-  [ immediate reg 2 0x0403a8c0 ]
-  [ immediate reg 3 0x0000901f ]
+  [ cmp eq reg 1 0x0051 ]
+  [ immediate reg 1 0xc0a80302 ]
+  [ immediate reg 2 0xc0a80304 ]
+  [ immediate reg 3 0x1f90 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 2 proto_min reg 3 flags 0x2 ]
 
 # iifname "eth0" tcp dport 81 dnat to 192.168.3.2-192.168.3.4:8080-8999
 ip
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005100 ]
-  [ immediate reg 1 0x0203a8c0 ]
-  [ immediate reg 2 0x0403a8c0 ]
-  [ immediate reg 3 0x0000901f ]
-  [ immediate reg 4 0x00002723 ]
+  [ cmp eq reg 1 0x0051 ]
+  [ immediate reg 1 0xc0a80302 ]
+  [ immediate reg 2 0xc0a80304 ]
+  [ immediate reg 3 0x1f90 ]
+  [ immediate reg 4 0x2327 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 flags 0x2 ]
 
 # ip daddr 192.168.0.1 dnat ip to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 }
 __map%d test-ip4 b size 2
 __map%d test-ip4 0
-        element 0000bb01  : 040a8d0a 0000fb20 0 [end]   element 00005000  : 040a8d0a 0000901f 0 [end]
+	element 01bb : 0a8d0a04 . 20fb	element 0050 : 0a8d0a04 . 1f90
 ip
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 proto_min reg 9 ]
@@ -182,10 +182,10 @@ ip
 # meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
 __map%d test-ip4 8f size 2
 __map%d test-ip4 0
-        element 32706e65 00003073 00000000 00000000 8801010a  - 32706e65 00003073 00000000 00000000 8801010a  : 45020101 00001600 45020101 00001600 0 [end]     element 32706e65 00003073 00000000 00000000 0101010a  - 32706e65 00003073 00000000 00000000 8701010a  : 42020101 00001600 4eec5401 00001600 0 [end]
+	element 656e7032 73300000 00000000 00000000 . 0a010188 - 656e7032 73300000 00000000 00000000 . 0a010188 : 01010245 . 0016 . 01010245 . 0016	element 656e7032 73300000 00000000 00000000 . 0a010101 - 656e7032 73300000 00000000 00000000 . 0a010187 : 01010242 . 0016 . 0154ec4e . 0016
 ip test-ip4 prerouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ meta load iifname => reg 1 ]
   [ payload load 4b @ network header + 12 => reg 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -194,10 +194,9 @@ ip test-ip4 prerouting
 # dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
 __map%d test-ip4 8f size 2
 __map%d test-ip4 0
-        element 32706e65 00003073 00000000 00000000 8801010a  - 32706e65 00003073 00000000 00000000 8801010a  : 45020101 45020101 0 [end]       element 32706e65 00003073 00000000 00000000 0101010a  - 32706e65 00003073 00000000 00000000 8701010a  : 42020101 4eec5401 0 [end]
+	element 656e7032 73300000 00000000 00000000 . 0a010188 - 656e7032 73300000 00000000 00000000 . 0a010188 : 01010245 . 01010245	element 656e7032 73300000 00000000 00000000 . 0a010101 - 656e7032 73300000 00000000 00000000 . 0a010187 : 01010242 . 0154ec4e
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ payload load 4b @ network header + 12 => reg 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 9 ]
-
diff --git a/tests/py/ip/dup.t.payload b/tests/py/ip/dup.t.payload
index 347dc07ad0be2..4e1c90702fa7e 100644
--- a/tests/py/ip/dup.t.payload
+++ b/tests/py/ip/dup.t.payload
@@ -1,21 +1,20 @@
 # dup to 192.168.2.1
 ip test-ip4 test 
-  [ immediate reg 1 0x0102a8c0 ]
+  [ immediate reg 1 0xc0a80201 ]
   [ dup sreg_addr 1 ]
 
 # dup to 192.168.2.1 device "lo"
 ip test-ip4 test 
-  [ immediate reg 1 0x0102a8c0 ]
+  [ immediate reg 1 0xc0a80201 ]
   [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
 # dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device "lo"
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 7802a8c0  : 0102a8c0 0 [end]
+	element c0a80278 : c0a80201
 ip test-ip4 test 
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
-
diff --git a/tests/py/ip/ether.t.payload b/tests/py/ip/ether.t.payload
index bd7c8f1506329..7d134894f1196 100644
--- a/tests/py/ip/ether.t.payload
+++ b/tests/py/ip/ether.t.payload
@@ -1,50 +1,49 @@
 # tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept
 ip test-ip input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4
 ip test-ip input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
 
 # tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
 ip test-ip input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
 
 # ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 ip test-ip input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ immediate reg 0 accept ]
-
diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index fefe492d8cbef..f7241250628a3 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -36,7 +36,7 @@ ip test-ip4 pre
 # dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 }
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000000  : 6414a8c0 0 [end]	element 00000001  : 641ea8c0 0 [end]
+	element 00000000 : c0a81464	element 00000001 : c0a81e64
 ip test-ip4 pre 
   [ payload load 4b @ network header + 12 => reg 2 ]
   [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 ]
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 04a53cff4635d..6568dcc987a60 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -1,206 +1,206 @@
 # icmp type echo-reply accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
   [ immediate reg 0 accept ]
 
 # icmp type destination-unreachable accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ immediate reg 0 accept ]
 
 # icmp type source-quench accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ immediate reg 0 accept ]
 
 # icmp type redirect accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ immediate reg 0 accept ]
 
 # icmp type echo-request accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
   [ immediate reg 0 accept ]
 
 # icmp type time-exceeded accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000000b ]
+  [ cmp eq reg 1 0x0b ]
   [ immediate reg 0 accept ]
 
 # icmp type parameter-problem accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000000c ]
+  [ cmp eq reg 1 0x0c ]
   [ immediate reg 0 accept ]
 
 # icmp type timestamp-request accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000000d ]
+  [ cmp eq reg 1 0x0d ]
   [ immediate reg 0 accept ]
 
 # icmp type timestamp-reply accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000000e ]
+  [ cmp eq reg 1 0x0e ]
   [ immediate reg 0 accept ]
 
 # icmp type info-request accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000000f ]
+  [ cmp eq reg 1 0x0f ]
   [ immediate reg 0 accept ]
 
 # icmp type info-reply accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000010 ]
+  [ cmp eq reg 1 0x10 ]
   [ immediate reg 0 accept ]
 
 # icmp type address-mask-request accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ immediate reg 0 accept ]
 
 # icmp type address-mask-reply accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000012 ]
+  [ cmp eq reg 1 0x12 ]
   [ immediate reg 0 accept ]
 
 # icmp type != {echo-reply, destination-unreachable, source-quench}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000000  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]
+	element 00	element 03	element 04
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp code 111 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x0000006f ]
+  [ cmp eq reg 1 0x6f ]
   [ immediate reg 0 accept ]
 
 # icmp code != 111 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp neq reg 1 0x0000006f ]
+  [ cmp neq reg 1 0x6f ]
   [ immediate reg 0 accept ]
 
 # icmp code 33-55
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x00000037 ]
+  [ range eq reg 1 0x21 0x37 ]
 
 # icmp code != 33-55
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x00000037 ]
+  [ range neq reg 1 0x21 0x37 ]
 
 # icmp code { 2, 4, 54, 33, 56}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000036  : 0 [end]	element 00000021  : 0 [end]	element 00000038  : 0 [end]
+	element 02	element 04	element 36	element 21	element 38
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmp code != { prot-unreachable, frag-needed, 33, 54, 56}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000036  : 0 [end]	element 00000021  : 0 [end]	element 00000038  : 0 [end]
+	element 02	element 04	element 21	element 36	element 38
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp checksum 12343 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003730 ]
+  [ cmp eq reg 1 0x3037 ]
   [ immediate reg 0 accept ]
 
 # icmp checksum != 12343 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003730 ]
+  [ cmp neq reg 1 0x3037 ]
   [ immediate reg 0 accept ]
 
 # icmp checksum 11-343 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00000b00 0x00005701 ]
+  [ range eq reg 1 0x000b 0x0157 ]
   [ immediate reg 0 accept ]
 
 # icmp checksum != 11-343 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00000b00 0x00005701 ]
+  [ range neq reg 1 0x000b 0x0157 ]
   [ immediate reg 0 accept ]
 
 # icmp checksum { 1111, 222, 343} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
+	element 0457	element 00de	element 0157
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -208,10 +208,10 @@ ip test-ip4 input
 # icmp checksum != { 1111, 222, 343} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
+	element 0457	element 00de	element 0157
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -219,74 +219,74 @@ ip test-ip4 input
 # icmp id 1245 log
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x0000dd04 ]
+  [ cmp eq reg 1 0x04dd ]
   [ log ]
 
 # icmp id 22
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # icmp id != 233
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # icmp id 33-45
 __set%d test-ip4 3
 __set%d  test-ip4 input
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # icmp id != 33-45
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # icmp id { 22, 34, 333}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
+	element 0016	element 0022	element 014d
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
@@ -295,13 +295,13 @@ ip test-ip4 input
 # icmp id != { 22, 34, 333}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
+	element 0016	element 0022	element 014d
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
@@ -310,61 +310,61 @@ ip test-ip4 input
 # icmp sequence 22
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # icmp sequence != 233
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # icmp sequence 33-45
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # icmp sequence != 33-45
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # icmp sequence { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
@@ -373,13 +373,13 @@ ip test-ip4 input
 # icmp sequence != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
@@ -388,218 +388,218 @@ ip test-ip4 input
 # icmp id 1 icmp sequence 2
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+	element 08	element 00
 ip 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x02000100 ]
+  [ cmp eq reg 1 0x00010002 ]
 
 # icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000000  : 0 [end]	element 00000008  : 0 [end]
+	element 00	element 08
 ip 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x02000100 ]
+  [ cmp eq reg 1 0x00010002 ]
 
 # icmp type echo-reply icmp id 1
 ip
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # icmp mtu 33
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00002100 ]
+  [ cmp eq reg 1 0x0021 ]
 
 # icmp mtu 22-33
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range eq reg 1 0x00001600 0x00002100 ]
+  [ range eq reg 1 0x0016 0x0021 ]
 
 # icmp mtu 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # icmp mtu != 233
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # icmp mtu 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # icmp mtu != 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # icmp mtu { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmp mtu != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp gateway 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # icmp gateway != 233
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
+  [ cmp neq reg 1 0x000000e9 ]
 
 # icmp gateway 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # icmp gateway != 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # icmp gateway { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmp gateway != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp gateway != 34
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x22000000 ]
+  [ cmp neq reg 1 0x00000022 ]
 
 # icmp gateway != { 333, 334}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 4d010000  : 0 [end]	element 4e010000  : 0 [end]
+	element 0000014d	element 0000014e
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ cmp eq reg 1 0x05 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp type router-advertisement accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000009 ]
+  [ cmp eq reg 1 0x09 ]
   [ immediate reg 0 accept ]
 
 # icmp type router-solicitation accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ immediate reg 0 accept ]
 
 # icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply, router-advertisement, router-solicitation} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000000  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000008  : 0 [end]     element 0000000b  : 0 [end]     element 0000000c  : 0 [end]     element 0000000d  : 0 [end]     element 0000000e  : 0 [end]     element 0000000f  : 0 [end]     element 00000010  : 0 [end]     element 00000011  : 0 [end]     element 00000012  : 0 [end]     element 00000009  : 0 [end]     element 0000000a  : 0 [end]
+	element 00	element 03	element 04	element 05	element 08	element 0b	element 0c	element 0d	element 0e	element 0f	element 10	element 11	element 12	element 09	element 0a
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -607,6 +607,6 @@ ip test-ip4 input
 # icmp code 1 icmp type 2
 ip 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000102 ]
+  [ cmp eq reg 1 0x0201 ]
diff --git a/tests/py/ip/igmp.t.payload b/tests/py/ip/igmp.t.payload
index 872fc3afa3b7d..d72b52c11baff 100644
--- a/tests/py/ip/igmp.t.payload
+++ b/tests/py/ip/igmp.t.payload
@@ -1,117 +1,116 @@
 # igmp type membership-query
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
 
 # igmp type membership-report-v1
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000012 ]
+  [ cmp eq reg 1 0x12 ]
 
 # igmp type membership-report-v2
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # igmp type membership-report-v3
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000022 ]
+  [ cmp eq reg 1 0x22 ]
 
 # igmp type leave-group
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000017 ]
+  [ cmp eq reg 1 0x17 ]
 
 # igmp checksum 12343
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003730 ]
+  [ cmp eq reg 1 0x3037 ]
 
 # igmp checksum != 12343
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003730 ]
+  [ cmp neq reg 1 0x3037 ]
 
 # igmp checksum 11-343
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00000b00 0x00005701 ]
+  [ range eq reg 1 0x000b 0x0157 ]
 
 # igmp checksum != 11-343
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00000b00 0x00005701 ]
+  [ range neq reg 1 0x000b 0x0157 ]
 
 # igmp checksum { 1111, 222, 343}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
+	element 0457	element 00de	element 0157
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # igmp checksum != { 1111, 222, 343}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
+	element 0457	element 00de	element 0157
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # igmp type { membership-report-v1, membership-report-v2, membership-report-v3}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
-	element 00000012  : 0 [end]	element 00000016  : 0 [end]	element 00000022  : 0 [end]
+	element 12	element 16	element 22
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # igmp type != { membership-report-v1, membership-report-v2, membership-report-v3}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
-	element 00000012  : 0 [end]	element 00000016  : 0 [end]	element 00000022  : 0 [end]
+	element 12	element 16	element 22
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # igmp mrt 10
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
 
 # igmp mrt != 10
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp neq reg 1 0x0000000a ]
-
+  [ cmp neq reg 1 0x0a ]
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 0e9936278008b..b3442e49e5979 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -1,79 +1,79 @@
 # ip dscp cs1
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x20 ]
 
 # ip dscp != cs1
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x20 ]
 
 # ip dscp 0x38
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x000000e0 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0xe0 ]
 
 # ip dscp != 0x20
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000080 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x80 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-ip4 3
 __set%d test-ip4 0
-        element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
+	element 00	element 20	element 40	element 60	element 80	element a0	element c0	element e0	element 28	element 30	element 38	element 48	element 50	element 58	element 68	element 70	element 78	element 88	element 90	element 98	element b8
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
 __set%d test-ip4 3
 __set%d test-ip4 0
-        element 00000000  : 0 [end]     element 00000060  : 0 [end]
+	element 00	element 60
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-ip4 b size 2
 __map%d test-ip4 0
-	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
+	element 20 : continue	element 80 : accept
 ip test-ip4 input 
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
 # ip length 232
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000e800 ]
+  [ cmp eq reg 1 0x00e8 ]
 
 # ip length != 233
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip length 333-435
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range eq reg 1 0x00004d01 0x0000b301 ]
+  [ range eq reg 1 0x014d 0x01b3 ]
 
 # ip length != 333-453
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range neq reg 1 0x00004d01 0x0000c501 ]
+  [ range neq reg 1 0x014d 0x01c5 ]
 
 # ip length { 333, 553, 673, 838}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -81,7 +81,7 @@ ip test-ip4 input
 # ip length != { 333, 553, 673, 838}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -89,27 +89,27 @@ ip test-ip4 input
 # ip id 22
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip id != 233
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip id 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip id != 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip id { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -117,7 +117,7 @@ ip test-ip4 input
 # ip id != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -125,28 +125,28 @@ ip test-ip4 input
 # ip frag-off 0xde accept
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0000de00 ]
+  [ cmp eq reg 1 0x00de ]
   [ immediate reg 0 accept ]
 
 # ip frag-off != 0xe9
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip frag-off 0x21-0x2d
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip frag-off != 0x21-0x2d
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -154,7 +154,7 @@ ip test-ip4 input
 # ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -162,46 +162,46 @@ ip test-ip4 input
 # ip frag-off & 0x1fff != 0x0
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x2000 != 0x0
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x2000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x4000 != 0x0
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x4000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip ttl 0 drop
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
   [ immediate reg 0 drop ]
 
 # ip ttl 233
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
+  [ cmp eq reg 1 0xe9 ]
 
 # ip ttl 33-55
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x00000037 ]
+  [ range eq reg 1 0x21 0x37 ]
 
 # ip ttl != 45-50
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range neq reg 1 0x0000002d 0x00000032 ]
+  [ range neq reg 1 0x2d 0x32 ]
 
 # ip ttl {43, 53, 45 }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -209,7 +209,7 @@ ip test-ip4 input
 # ip ttl != {43, 53, 45 }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -217,17 +217,17 @@ ip test-ip4 input
 # ip protocol tcp
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # ip protocol != tcp
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
+  [ cmp neq reg 1 0x06 ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -236,7 +236,7 @@ ip test-ip4 input
 # ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -245,38 +245,38 @@ ip test-ip4 input
 # ip protocol 255
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x000000ff ]
+  [ cmp eq reg 1 0xff ]
 
 # ip checksum 13172 drop
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00007433 ]
+  [ cmp eq reg 1 0x3374 ]
   [ immediate reg 0 drop ]
 
 # ip checksum 22
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip checksum != 233
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip checksum 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip checksum != 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -284,7 +284,7 @@ ip test-ip4 input
 # ip checksum != { 33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -292,19 +292,19 @@ ip test-ip4 input
 # ip saddr 192.168.2.0/24
 ip test-ip4 input
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0002a8c0 ]
+  [ cmp eq reg 1 0xc0a802 ]
 
 # ip saddr != 192.168.2.0/24
 ip test-ip4 input
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp neq reg 1 0x0002a8c0 ]
+  [ cmp neq reg 1 0xc0a802 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0103a8c0 ]
+  [ cmp eq reg 1 0xc0a80301 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x6403a8c0 ]
+  [ cmp eq reg 1 0xc0a80364 ]
 
 # ip saddr != 1.1.1.1
 ip test-ip4 input
@@ -319,32 +319,32 @@ ip test-ip4 input
 # ip daddr 192.168.0.1-192.168.0.250
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range eq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0000000a 0xffffff0a ]
+  [ range eq reg 1 0x0a000000 0x0affffff ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x000010ac 0xffff1fac ]
+  [ range eq reg 1 0xac100000 0xac1fffff ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
+  [ range eq reg 1 0xc0a80301 0xc0a804fa ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range neq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -353,7 +353,7 @@ ip test-ip4 input
 # ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -362,85 +362,85 @@ ip test-ip4 input
 # ip daddr 192.168.1.2-192.168.1.55
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range eq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range neq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range eq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range neq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip daddr 192.168.0.1
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ip daddr 192.168.0.1 drop
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
   [ immediate reg 0 drop ]
 
 # ip daddr 192.168.0.2
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0200a8c0 ]
+  [ cmp eq reg 1 0xc0a80002 ]
 
 # ip saddr & 0xff == 1
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp lt reg 1 0x7f000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp lt reg 1 0x0000007f ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000ffff ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0xffff0000 ]
 
 # ip version 4 ip hdrlength 5
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000040 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x40 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x05 ]
 
 # ip hdrlength 0
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # ip hdrlength 15
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x0f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-ip4 f size 4
 __map%d test-ip4 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
+	element 00 : drop	element 05 : accept	element 06 : continue	element 07 flags 1
 ip test-ip4 input 
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -448,21 +448,21 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ immediate reg 1 0x0100007f ]
+  [ immediate reg 1 0x7f000001 ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip checksum set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ immediate reg 1 0x00000000 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip id set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ immediate reg 1 0x00000000 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set 1
@@ -470,7 +470,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -478,7 +478,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0003 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
@@ -486,7 +486,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0058 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -494,7 +494,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -502,7 +502,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ff ) ^ 0x1700 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -510,13 +510,13 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff00 ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
 __set%d test-ip4 87 size 1
 __set%d test-ip4 0
-        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+	element c0000201 . 0a000001 - c0000201 . 0a000002
 ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
@@ -525,7 +525,7 @@ ip
 # ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
 __map%d test-ip4 8f size 1
 __map%d test-ip4 0
-        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+	element c0a80501 . c0a80601 - c0a80580 . c0a80680 : accept
 ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
@@ -534,104 +534,104 @@ ip
 # ip saddr 1.2.3.4 ip daddr 3.4.5.6
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip dscp 1/6
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0x3f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x01 ]
 
 # ip ecn set ip ecn | ect0
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0002 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn | ect1
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect0
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect1
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff3f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
 
 # tcp flags set tcp flags | ecn | cwr
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x0000c000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff3f ) ^ 0x00c0 ]
   [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
 
 # ip dscp set ip dscp | lephb
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffb ) ^ 0x0004 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & lephb
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff07 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & 0x1f
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff7f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version | 1
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0xefff ) ^ 0x1000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version & 1
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength | 1
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfeff ) ^ 0x0100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength & 1
 ip test-ip4 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf1ff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 663f87d7b4acf..9da3fc266f52f 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -1,308 +1,308 @@
 # ip dscp cs1
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x20 ]
 
 # ip dscp != cs1
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x20 ]
 
 # ip dscp 0x38
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x000000e0 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0xe0 ]
 
 # ip dscp != 0x20
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000080 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x80 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-bridge 3 size 21
 __set%d test-bridge 0
-	element 00000000  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000060  : 0 [end]	element 00000080  : 0 [end]	element 000000a0  : 0 [end]	element 000000c0  : 0 [end]	element 000000e0  : 0 [end]	element 00000028  : 0 [end]	element 00000030  : 0 [end]	element 00000038  : 0 [end]	element 00000048  : 0 [end]	element 00000050  : 0 [end]	element 00000058  : 0 [end]	element 00000068  : 0 [end]	element 00000070  : 0 [end]	element 00000078  : 0 [end]	element 00000088  : 0 [end]	element 00000090  : 0 [end]	element 00000098  : 0 [end]	element 000000b8  : 0 [end]
+	element 00	element 20	element 40	element 60	element 80	element a0	element c0	element e0	element 28	element 30	element 38	element 48	element 50	element 58	element 68	element 70	element 78	element 88	element 90	element 98	element b8
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
 __set%d test-bridge 3 size 2
 __set%d test-bridge 0
-	element 00000000  : 0 [end]	element 00000060  : 0 [end]
+	element 00	element 60
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-bridge b size 2
 __map%d test-bridge 0
-	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
+	element 20 : continue	element 80 : accept
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
 # ip length 232
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000e800 ]
+  [ cmp eq reg 1 0x00e8 ]
 
 # ip length != 233
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip length 333-435
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range eq reg 1 0x00004d01 0x0000b301 ]
+  [ range eq reg 1 0x014d 0x01b3 ]
 
 # ip length != 333-453
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range neq reg 1 0x00004d01 0x0000c501 ]
+  [ range neq reg 1 0x014d 0x01c5 ]
 
 # ip length { 333, 553, 673, 838}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip length != { 333, 553, 673, 838}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip id 22
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip id != 233
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip id 33-45
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip id != 33-45
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip id { 33, 55, 67, 88}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip id != { 33, 55, 67, 88}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip frag-off 0xde accept
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0000de00 ]
+  [ cmp eq reg 1 0x00de ]
   [ immediate reg 0 accept ]
 
 # ip frag-off != 0xe9
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip frag-off 0x21-0x2d
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip frag-off != 0x21-0x2d
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip frag-off & 0x1fff != 0x0
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x2000 != 0x0
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x2000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x4000 != 0x0
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x4000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip ttl 0 drop
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
   [ immediate reg 0 drop ]
 
 # ip ttl 233
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
+  [ cmp eq reg 1 0xe9 ]
 
 # ip ttl 33-55
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x00000037 ]
+  [ range eq reg 1 0x21 0x37 ]
 
 # ip ttl != 45-50
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range neq reg 1 0x0000002d 0x00000032 ]
+  [ range neq reg 1 0x2d 0x32 ]
 
 # ip ttl {43, 53, 45 }
 __set%d test-bridge 3 size 3
 __set%d test-bridge 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip ttl != {43, 53, 45 }
 __set%d test-bridge 3 size 3
 __set%d test-bridge 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip protocol tcp
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # ip protocol != tcp
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
+  [ cmp neq reg 1 0x06 ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-bridge 3 size 9
 __set%d test-bridge 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -310,10 +310,10 @@ bridge test-bridge input
 # ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-bridge 3 size 9
 __set%d test-bridge 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -321,145 +321,145 @@ bridge test-bridge input
 # ip protocol 255
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x000000ff ]
+  [ cmp eq reg 1 0xff ]
 
 # ip checksum 13172 drop
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00007433 ]
+  [ cmp eq reg 1 0x3374 ]
   [ immediate reg 0 drop ]
 
 # ip checksum 22
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip checksum != 233
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip checksum 33-45
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip checksum != 33-45
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip checksum { 33, 55, 67, 88}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip checksum != { 33, 55, 67, 88}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip saddr 192.168.2.0/24
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0002a8c0 ]
+  [ cmp eq reg 1 0xc0a802 ]
 
 # ip saddr != 192.168.2.0/24
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp neq reg 1 0x0002a8c0 ]
+  [ cmp neq reg 1 0xc0a802 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0103a8c0 ]
+  [ cmp eq reg 1 0xc0a80301 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x6403a8c0 ]
+  [ cmp eq reg 1 0xc0a80364 ]
 
 # ip saddr != 1.1.1.1
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x01010101 ]
 
 # ip saddr 1.1.1.1
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x01010101 ]
 
 # ip daddr 192.168.0.1-192.168.0.250
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range eq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0000000a 0xffffff0a ]
+  [ range eq reg 1 0x0a000000 0x0affffff ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x000010ac 0xffff1fac ]
+  [ range eq reg 1 0xac100000 0xac1fffff ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
+  [ range eq reg 1 0xc0a80301 0xc0a804fa ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range neq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-bridge 3 size 3
 __set%d test-bridge 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -467,10 +467,10 @@ bridge test-bridge input
 # ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-bridge 3 size 3
 __set%d test-bridge 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -478,113 +478,113 @@ bridge test-bridge input
 # ip daddr 192.168.1.2-192.168.1.55
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range eq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range neq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range eq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range neq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip daddr 192.168.0.1
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ip daddr 192.168.0.1 drop
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
   [ immediate reg 0 drop ]
 
 # ip daddr 192.168.0.2
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0200a8c0 ]
+  [ cmp eq reg 1 0xc0a80002 ]
 
 # ip saddr & 0xff == 1
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp lt reg 1 0x7f000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp lt reg 1 0x0000007f ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000ffff ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0xffff0000 ]
 
 # ip version 4 ip hdrlength 5
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000040 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x40 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x05 ]
 
 # ip hdrlength 0
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # ip hdrlength 15
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x0f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-bridge f size 4
 __map%d test-bridge 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
+	element 00 : drop	element 05 : accept	element 06 : continue	element 07 flags 1
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -593,8 +593,8 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ immediate reg 1 0x0100007f ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x7f000001 ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip checksum set 0
@@ -602,8 +602,8 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ immediate reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip id set 0
@@ -611,8 +611,8 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ immediate reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set 1
@@ -620,9 +620,9 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -630,9 +630,9 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0003 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -640,9 +640,9 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ff ) ^ 0x1700 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -650,9 +650,9 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff00 ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip dscp set af23
@@ -660,9 +660,9 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0058 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -670,18 +670,18 @@ bridge test-bridge input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
 __set%d test-bridge 87 size 1
 __set%d test-bridge 0
-        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+	element c0000201 . 0a000001 - c0000201 . 0a000002
 bridge
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
@@ -689,10 +689,10 @@ bridge
 # ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
 __map%d test-bridge 8f size 1
 __map%d test-bridge 0
-        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+	element c0a80501 . c0a80601 - c0a80580 . c0a80680 : accept
 bridge
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -700,132 +700,132 @@ bridge
 # ip saddr 1.2.3.4 ip daddr 3.4.5.6
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip dscp 1/6
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0x3f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x01 ]
 
 # ip ecn set ip ecn | ect0
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0002 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn | ect1
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect0
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect1
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff3f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
 
 # tcp flags set tcp flags | ecn | cwr
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x0000c000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff3f ) ^ 0x00c0 ]
   [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
 
 # ip dscp set ip dscp | lephb
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffb ) ^ 0x0004 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & lephb
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff07 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & 0x1f
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff7f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version | 1
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0xefff ) ^ 0x1000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version & 1
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength | 1
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfeff ) ^ 0x0100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength & 1
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf1ff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index b8ab49c871430..912ce58aa8bcf 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -1,308 +1,308 @@
 # ip dscp cs1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x20 ]
 
 # ip dscp != cs1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x20 ]
 
 # ip dscp 0x38
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x000000e0 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0xe0 ]
 
 # ip dscp != 0x20
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000080 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x80 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
+	element 00	element 20	element 40	element 60	element 80	element a0	element c0	element e0	element 28	element 30	element 38	element 48	element 50	element 58	element 68	element 70	element 78	element 88	element 90	element 98	element b8
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000000  : 0 [end]     element 00000060  : 0 [end]
+	element 00	element 60
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-inet b size 2
 __map%d test-inet 0
-	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
+	element 20 : continue	element 80 : accept
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
 # ip length 232
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000e800 ]
+  [ cmp eq reg 1 0x00e8 ]
 
 # ip length != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip length 333-435
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range eq reg 1 0x00004d01 0x0000b301 ]
+  [ range eq reg 1 0x014d 0x01b3 ]
 
 # ip length != 333-453
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range neq reg 1 0x00004d01 0x0000c501 ]
+  [ range neq reg 1 0x014d 0x01c5 ]
 
 # ip length { 333, 553, 673, 838}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip length != { 333, 553, 673, 838}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip id 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip id != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip id 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip id != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip id { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip id != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip frag-off 0xde accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0000de00 ]
+  [ cmp eq reg 1 0x00de ]
   [ immediate reg 0 accept ]
 
 # ip frag-off != 0xe9
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip frag-off 0x21-0x2d
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip frag-off != 0x21-0x2d
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip frag-off & 0x1fff != 0x0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x2000 != 0x0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x2000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x4000 != 0x0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x4000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip ttl 0 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
   [ immediate reg 0 drop ]
 
 # ip ttl 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
+  [ cmp eq reg 1 0xe9 ]
 
 # ip ttl 33-55
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x00000037 ]
+  [ range eq reg 1 0x21 0x37 ]
 
 # ip ttl != 45-50
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range neq reg 1 0x0000002d 0x00000032 ]
+  [ range neq reg 1 0x2d 0x32 ]
 
 # ip ttl {43, 53, 45 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip ttl != {43, 53, 45 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip protocol tcp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # ip protocol != tcp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
+  [ cmp neq reg 1 0x06 ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -310,10 +310,10 @@ inet test-inet input
 # ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -321,145 +321,145 @@ inet test-inet input
 # ip protocol 255
 ip test-ip4 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x000000ff ]
+  [ cmp eq reg 1 0xff ]
 
 # ip checksum 13172 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00007433 ]
+  [ cmp eq reg 1 0x3374 ]
   [ immediate reg 0 drop ]
 
 # ip checksum 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip checksum != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip checksum 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip checksum != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip checksum { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip checksum != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip saddr 192.168.2.0/24
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0002a8c0 ]
+  [ cmp eq reg 1 0xc0a802 ]
 
 # ip saddr != 192.168.2.0/24
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp neq reg 1 0x0002a8c0 ]
+  [ cmp neq reg 1 0xc0a802 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0103a8c0 ]
+  [ cmp eq reg 1 0xc0a80301 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x6403a8c0 ]
+  [ cmp eq reg 1 0xc0a80364 ]
 
 # ip saddr != 1.1.1.1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x01010101 ]
 
 # ip saddr 1.1.1.1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x01010101 ]
 
 # ip daddr 192.168.0.1-192.168.0.250
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range eq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0000000a 0xffffff0a ]
+  [ range eq reg 1 0x0a000000 0x0affffff ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x000010ac 0xffff1fac ]
+  [ range eq reg 1 0xac100000 0xac1fffff ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
+  [ range eq reg 1 0xc0a80301 0xc0a804fa ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range neq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -467,10 +467,10 @@ inet test-inet input
 # ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-inet 3
 __set%d test-inet 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -478,113 +478,113 @@ inet test-inet input
 # ip daddr 192.168.1.2-192.168.1.55
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range eq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range neq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range eq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range neq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip daddr 192.168.0.1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ip daddr 192.168.0.1 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
   [ immediate reg 0 drop ]
 
 # ip daddr 192.168.0.2
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0200a8c0 ]
+  [ cmp eq reg 1 0xc0a80002 ]
 
 # ip saddr & 0xff == 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp lt reg 1 0x7f000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp lt reg 1 0x0000007f ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000ffff ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0xffff0000 ]
 
 # ip version 4 ip hdrlength 5
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000040 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x40 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x05 ]
 
 # ip hdrlength 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # ip hdrlength 15
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x0f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-inet f size 4
 __map%d test-inet 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
+	element 00 : drop	element 05 : accept	element 06 : continue	element 07 flags 1
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -593,8 +593,8 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ immediate reg 1 0x0100007f ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x7f000001 ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip checksum set 0
@@ -602,8 +602,8 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ immediate reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip id set 0
@@ -611,8 +611,8 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ immediate reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set 1
@@ -620,9 +620,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -630,9 +630,9 @@ inet test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0003 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
@@ -640,9 +640,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0058 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -650,9 +650,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -660,9 +660,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ff ) ^ 0x1700 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -670,18 +670,18 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff00 ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
 __set%d test-inet 87 size 1
 __set%d test-inet 0
-        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+	element c0000201 . 0a000001 - c0000201 . 0a000002
 inet
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
@@ -689,10 +689,10 @@ inet
 # ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
 __map%d test-inet 8f size 1
 __map%d test-inet 0
-        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+	element c0a80501 . c0a80601 - c0a80580 . c0a80680 : accept
 inet
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -700,132 +700,132 @@ inet
 # ip saddr 1.2.3.4 ip daddr 3.4.5.6
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip dscp 1/6
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0x3f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x01 ]
 
 # ip ecn set ip ecn | ect0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0002 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn | ect1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff3f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
 
 # tcp flags set tcp flags | ecn | cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x0000c000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff3f ) ^ 0x00c0 ]
   [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
 
 # ip dscp set ip dscp | lephb
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffb ) ^ 0x0004 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & lephb
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff07 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & 0x1f
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff7f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version | 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0xefff ) ^ 0x1000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version & 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength | 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfeff ) ^ 0x0100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength & 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf1ff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index bd3495324b918..9103ffcc0e8e7 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -1,221 +1,221 @@
 # ip length 232
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000e800 ]
+  [ cmp eq reg 1 0x00e8 ]
 
 # ip length != 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip length 333-435
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range eq reg 1 0x00004d01 0x0000b301 ]
+  [ range eq reg 1 0x014d 0x01b3 ]
 
 # ip length != 333-453
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ range neq reg 1 0x00004d01 0x0000c501 ]
+  [ range neq reg 1 0x014d 0x01c5 ]
 
 # ip length { 333, 553, 673, 838}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip length != { 333, 553, 673, 838}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+	element 014d	element 0229	element 02a1	element 0346
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip id 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip id != 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip id 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip id != 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip id { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip id != { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip frag-off 0xde accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0000de00 ]
+  [ cmp eq reg 1 0x00de ]
   [ immediate reg 0 accept ]
 
 # ip frag-off != 0xe9
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip frag-off 0x21-0x2d
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip frag-off != 0x21-0x2d
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip frag-off & 0x1fff != 0x0
 netdev x y
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x2000 != 0x0
 netdev x y
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x2000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip frag-off & 0x4000 != 0x0
 netdev x y
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x4000 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0000 ]
 
 # ip ttl 0 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
   [ immediate reg 0 drop ]
 
 # ip ttl 33-55
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x00000037 ]
+  [ range eq reg 1 0x21 0x37 ]
 
 # ip ttl != 45-50
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ range neq reg 1 0x0000002d 0x00000032 ]
+  [ range neq reg 1 0x2d 0x32 ]
 
 # ip ttl {43, 53, 45 }
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip ttl != {43, 53, 45 }
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+	element 2b	element 35	element 2d
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -223,10 +223,10 @@ netdev test-netdev ingress
 # ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 01	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -234,138 +234,138 @@ netdev test-netdev ingress
 # ip protocol 255
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x000000ff ]
+  [ cmp eq reg 1 0xff ]
 
 # ip checksum 13172 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00007433 ]
+  [ cmp eq reg 1 0x3374 ]
   [ immediate reg 0 drop ]
 
 # ip checksum 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip checksum != 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip checksum 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip checksum != 33-45
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip checksum { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip checksum != { 33, 55, 67, 88}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip saddr 192.168.2.0/24
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0002a8c0 ]
+  [ cmp eq reg 1 0xc0a802 ]
 
 # ip saddr != 192.168.2.0/24
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 3b @ network header + 12 => reg 1 ]
-  [ cmp neq reg 1 0x0002a8c0 ]
+  [ cmp neq reg 1 0xc0a802 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0103a8c0 ]
+  [ cmp eq reg 1 0xc0a80301 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x6403a8c0 ]
+  [ cmp eq reg 1 0xc0a80364 ]
 
 # ip saddr 1.1.1.1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x01010101 ]
 
 # ip daddr 192.168.0.1-192.168.0.250
-netdev test-netdev ingress 
+netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range eq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0000000a 0xffffff0a ]
+  [ range eq reg 1 0x0a000000 0x0affffff ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x000010ac 0xffff1fac ]
+  [ range eq reg 1 0xac100000 0xac1fffff ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
+  [ range eq reg 1 0xc0a80301 0xc0a804fa ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
+  [ range neq reg 1 0xc0a80001 0xc0a800fa ]
 
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -373,10 +373,10 @@ netdev test-netdev ingress
 # ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+	element c0a80501	element c0a80502	element c0a80503
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -384,207 +384,207 @@ netdev test-netdev ingress
 # ip daddr 192.168.1.2-192.168.1.55
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range eq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
+  [ range neq reg 1 0xc0a80102 0xc0a80137 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range eq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
+  [ range neq reg 1 0xc0a80103 0xc0a82137 ]
 
 # ip daddr 192.168.0.1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
 
 # ip daddr 192.168.0.1 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
+  [ cmp eq reg 1 0xc0a80001 ]
   [ immediate reg 0 drop ]
 
 # ip saddr & 0xff == 1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
-  [ cmp lt reg 1 0x7f000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp lt reg 1 0x0000007f ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000ffff ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0xffff0000 ]
 
 # ip version 4 ip hdrlength 5
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000040 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x40 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000005 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x05 ]
 
 # ip hdrlength 0
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # ip hdrlength 15
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000f ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x0f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-netdev f size 4
 __map%d test-netdev 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
+	element 00 : drop	element 05 : accept	element 06 : continue	element 07 flags 1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0f ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
 # ip ttl 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
+  [ cmp eq reg 1 0xe9 ]
 
 # ip protocol tcp
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # ip protocol != tcp
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
+  [ cmp neq reg 1 0x06 ]
 
 # ip saddr != 1.1.1.1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x01010101 ]
 
 # ip daddr 192.168.0.2
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0200a8c0 ]
+  [ cmp eq reg 1 0xc0a80002 ]
 
 # ip dscp cs1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0x20 ]
 
 # ip dscp != cs1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x20 ]
 
 # ip dscp 0x38
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x000000e0 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp eq reg 1 0xe0 ]
 
 # ip dscp != 0x20
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000080 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
+  [ cmp neq reg 1 0x80 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000000  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000060  : 0 [end]	element 00000080  : 0 [end]	element 000000a0  : 0 [end]	element 000000c0  : 0 [end]	element 000000e0  : 0 [end]	element 00000028  : 0 [end]	element 00000030  : 0 [end]	element 00000038  : 0 [end]	element 00000048  : 0 [end]	element 00000050  : 0 [end]	element 00000058  : 0 [end]	element 00000068  : 0 [end]	element 00000070  : 0 [end]	element 00000078  : 0 [end]	element 00000088  : 0 [end]	element 00000090  : 0 [end]	element 00000098  : 0 [end]	element 000000b8  : 0 [end]
+	element 00	element 20	element 40	element 60	element 80	element a0	element c0	element e0	element 28	element 30	element 38	element 48	element 50	element 58	element 68	element 70	element 78	element 88	element 90	element 98	element b8
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00000000  : 0 [end]	element 00000060  : 0 [end]
+	element 00	element 60
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-netdev b size 2
 __map%d test-netdev 0
-	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
+	element 20 : continue	element 80 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -593,8 +593,8 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ immediate reg 1 0x0100007f ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x7f000001 ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip checksum set 0
@@ -602,8 +602,8 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ immediate reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip id set 0
@@ -611,8 +611,8 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ immediate reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set 1
@@ -620,9 +620,9 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -630,9 +630,9 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffc ) ^ 0x0003 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
@@ -640,9 +640,9 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0058 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -650,9 +650,9 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff03 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -660,9 +660,9 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ff ) ^ 0x1700 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -670,18 +670,18 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff00 ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
 __set%d test-netdev 87 size 1
 __set%d test-netdev 0
-        element 010200c0 0100000a  - 010200c0 0200000a  : 0 [end]
+	element c0000201 . 0a000001 - c0000201 . 0a000002
 netdev
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
@@ -689,10 +689,10 @@ netdev
 # ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
 __map%d test-netdev 8f size 1
 __map%d test-netdev 0
-        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+	element c0a80501 . c0a80601 - c0a80580 . c0a80680 : accept
 netdev
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -700,116 +700,116 @@ netdev
 # ip saddr 1.2.3.4 ip daddr 3.4.5.6
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
+  [ cmp eq reg 1 0x01020304 ]
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x06050403 ]
+  [ cmp eq reg 1 0x03040506 ]
 
 # ip dscp 1/6
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0x3f ) ^ 0x00 ]
+  [ cmp eq reg 1 0x01 ]
 
 # ip ecn set ip ecn | ect0
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0002 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn | ect1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0001 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect0
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffe ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip ecn set ip ecn & ect1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffd ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp | lephb
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffb ) ^ 0x0004 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & lephb
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff07 ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip dscp set ip dscp & 0x1f
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff7f ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version | 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0xefff ) ^ 0x1000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip version set ip version & 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x1fff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength | 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfeff ) ^ 0x0100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # ip hdrlength set ip hdrlength & 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf1ff ) ^ 0x0000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip_tcp.t.payload b/tests/py/ip/ip_tcp.t.payload
index f6f640d43865b..cefbcafb392ce 100644
--- a/tests/py/ip/ip_tcp.t.payload
+++ b/tests/py/ip/ip_tcp.t.payload
@@ -1,16 +1,15 @@
 # ip protocol tcp tcp dport 22
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip protocol tcp meta mark set 1 tcp dport 22
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ immediate reg 1 0x00000001 ]
   [ meta set mark with reg 1 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
+  [ cmp eq reg 1 0x0016 ]
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index c4957fd74f8f3..7ac7f8150079c 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -1,98 +1,98 @@
 # udp dport 53 masquerade
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq ]
 
 # udp dport 53 masquerade random
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x4 ]
 
 # udp dport 53 masquerade random,persistent
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0xc ]
 
 # udp dport 53 masquerade random,persistent,fully-random
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # udp dport 53 masquerade random,fully-random
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x14 ]
 
 # udp dport 53 masquerade random,fully-random,persistent
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # udp dport 53 masquerade persistent
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x8 ]
 
 # udp dport 53 masquerade persistent,random
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0xc ]
 
 # udp dport 53 masquerade persistent,random,fully-random
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # udp dport 53 masquerade persistent,fully-random
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x18 ]
 
 # udp dport 53 masquerade persistent,fully-random,random
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
+	element 0001	element 0002	element 0003	element 0004	element 0005	element 0006	element 0007	element 0008	element 0065	element 00ca	element 012f	element 03e9	element 07d2	element 0bbb
 ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ masq ]
@@ -100,26 +100,26 @@ ip test-ip4 postrouting
 # ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter masquerade
 ip test-ip4 postrouting
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0000000a 0x0403020a ]
+  [ range eq reg 1 0x0a000000 0x0a020304 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ counter pkts 0 bytes 0 ]
   [ masq ]
 
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } masquerade
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
+	element 0016 : drop	element 00de : drop
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ masq ]
@@ -127,15 +127,14 @@ ip test-ip4 postrouting
 # ip protocol 6 masquerade to :1024
 ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x0400 ]
   [ masq proto_min reg 1 flags 0x2 ]
 
 # ip protocol 6 masquerade to :1024-2048
 ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000004 ]
-  [ immediate reg 2 0x00000008 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x0400 ]
+  [ immediate reg 2 0x0800 ]
   [ masq proto_min reg 1 proto_max reg 2 flags 0x2 ]
-
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index 880ac5d6c707a..bfdac5b3e4349 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -1,37 +1,37 @@
 # icmp type echo-request
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # meta l4proto icmp icmp type echo-request
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # meta l4proto ipv6-icmp icmpv6 type nd-router-advert
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000086 ]
+  [ cmp eq reg 1 0x86 ]
 
 # meta l4proto 58 icmpv6 type nd-router-advert
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000086 ]
+  [ cmp eq reg 1 0x86 ]
 
 # icmpv6 type nd-router-advert
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000086 ]
+  [ cmp eq reg 1 0x86 ]
 
 # meta sdif "lo" accept
 ip6 test-ip4 input
@@ -42,27 +42,27 @@ ip6 test-ip4 input
 # meta sdifname != "vrf1" accept
 ip6 test-ip4 input
   [ meta load sdifname => reg 1 ]
-  [ cmp neq reg 1 0x31667276 0x00000000 0x00000000 0x00000000 ]
+  [ cmp neq reg 1 0x76726631 0x00000000 0x00000000 0x00000000 ]
   [ immediate reg 0 accept ]
 
 # meta protocol ip udp dport 67
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00004300 ]
+  [ cmp eq reg 1 0x0043 ]
 
 # meta mark set ip dscp
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ meta set mark with reg 1 ]
 
 # meta mark set ip dscp << 2 | 0x10
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
@@ -71,7 +71,7 @@ ip test-ip4 input
 # meta mark set ip dscp << 26 | 0x10
 ip
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfc ) ^ 0x00 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
index b4eadf857d13d..f405790e8f0de 100644
--- a/tests/py/ip/numgen.t.payload
+++ b/tests/py/ip/numgen.t.payload
@@ -6,7 +6,7 @@ ip test-ip4 pre
 # dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }
 __map%d x b
 __map%d x 0
-        element 00000000  : 640aa8c0 0 [end]    element 00000001  : c814a8c0 0 [end]
+	element 00000000 : c0a80a64	element 00000001 : c0a814c8
 ip test-ip4 pre 
   [ numgen reg 1 = inc mod 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -15,7 +15,7 @@ ip test-ip4 pre
 # dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200}
 __map%d test-ip4 f
 __map%d test-ip4 0
-        element 00000000  : 640aa8c0 0 [end]    element 06000000  : c814a8c0 0 [end]    element 0a000000  : 1 [end]
+	element 00000000 : c0a80a64	element 00000006 : c0a814c8	element 0000000a flags 1
 ip test-ip4 pre
   [ numgen reg 1 = inc mod 10 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
index 3da4b28512b6f..b0b71818d5483 100644
--- a/tests/py/ip/objects.t.payload
+++ b/tests/py/ip/objects.t.payload
@@ -1,32 +1,32 @@
 # ip saddr 192.168.1.3 counter name "cnt2"
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0301a8c0 ]
+  [ cmp eq reg 1 0xc0a80103 ]
   [ objref type 1 name cnt2 ]
 
 # counter name tcp dport map {443 : "cnt1", 80 : "cnt2", 22 : "cnt1"}
 __objmap%d test-ip4 43
 __objmap%d test-ip4 0
-	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
+	element 01bb : cnt1	element 0050 : cnt2	element 0016 : cnt1
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
 # ip saddr 192.168.1.3 quota name "qt1"
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0301a8c0 ]
+  [ cmp eq reg 1 0xc0a80103 ]
   [ objref type 2 name qt1 ]
 
 # quota name tcp dport map {443 : "qt1", 80 : "qt2", 22 : "qt1"}
 __objmap%d test-ip4 43
 __objmap%d test-ip4 0
-	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
+	element 01bb : qt1	element 0050 : qt2	element 0016 : qt1
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
@@ -37,26 +37,26 @@ ip test-ip4 input
 # ct helper set tcp dport map {21 : "cthelp1", 2121 : "cthelp1" }
 __objmap%d test-ip4 43
 __objmap%d test-ip4 0
-        element 00001500  : 0 [end]     element 00004908  : 0 [end]
+	element 0015 : cthelp1	element 0849 : cthelp1
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
 # ip saddr 192.168.1.3 limit name "lim1"
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0301a8c0 ]
+  [ cmp eq reg 1 0xc0a80103 ]
   [ objref type 4 name lim1 ]
 
 # limit name tcp dport map {443 : "lim1", 80 : "lim2", 22 : "lim1"}
 __objmap%d test-ip4 43 size 3
 __objmap%d test-ip4 0
-        element 0000bb01  : 0 [end]     element 00005000  : 0 [end]     element 00001600  : 0 [end]
+	element 01bb : lim1	element 0050 : lim2	element 0016 : lim1
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
@@ -71,9 +71,9 @@ ip test-ip4 input
 # synproxy name tcp dport map {443 : "synproxy1", 80 : "synproxy2"}
 __objmap%d test-ip4 43 size 2
 __objmap%d test-ip4 0
-	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]
+	element 01bb : synproxy1	element 0050 : synproxy2
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index 8a543057e76a0..3b3f0fa275818 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -1,180 +1,180 @@
 # udp dport 53 redirect
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir ]
 
 # udp dport 53 redirect random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x4 ]
 
 # udp dport 53 redirect random,persistent
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0xc ]
 
 # udp dport 53 redirect random,persistent,fully-random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # udp dport 53 redirect random,fully-random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x14 ]
 
 # udp dport 53 redirect random,fully-random,persistent
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x8 ]
 
 # udp dport 53 redirect persistent,random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0xc ]
 
 # udp dport 53 redirect persistent,random,fully-random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent,fully-random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x18 ]
 
 # udp dport 53 redirect persistent,fully-random,random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # tcp dport 22 redirect to :22
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ immediate reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
+  [ immediate reg 1 0x0016 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # udp dport 1234 redirect to :4321
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000d204 ]
-  [ immediate reg 1 0x0000e110 ]
+  [ cmp eq reg 1 0x04d2 ]
+  [ immediate reg 1 0x10e1 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # ip daddr 172.16.0.1 udp dport 9998 redirect to :6515
 ip test-ip4 output
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x010010ac ]
+  [ cmp eq reg 1 0xac100001 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000e27 ]
-  [ immediate reg 1 0x00007319 ]
+  [ cmp eq reg 1 0x270e ]
+  [ immediate reg 1 0x1973 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # tcp dport 39128 redirect to :993
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000d898 ]
-  [ immediate reg 1 0x0000e103 ]
+  [ cmp eq reg 1 0x98d8 ]
+  [ immediate reg 1 0x03e1 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # ip protocol tcp redirect to :100-200
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00006400 ]
-  [ immediate reg 2 0x0000c800 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x0064 ]
+  [ immediate reg 2 0x00c8 ]
   [ redir proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
 # tcp dport 9128 redirect to :993 random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000a823 ]
-  [ immediate reg 1 0x0000e103 ]
+  [ cmp eq reg 1 0x23a8 ]
+  [ immediate reg 1 0x03e1 ]
   [ redir proto_min reg 1 flags 0x6 ]
 
 # tcp dport 9128 redirect to :993 fully-random
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000a823 ]
-  [ immediate reg 1 0x0000e103 ]
+  [ cmp eq reg 1 0x23a8 ]
+  [ immediate reg 1 0x03e1 ]
   [ redir proto_min reg 1 flags 0x12 ]
 
 # tcp dport 9128 redirect to :123 persistent
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000a823 ]
-  [ immediate reg 1 0x00007b00 ]
+  [ cmp eq reg 1 0x23a8 ]
+  [ immediate reg 1 0x007b ]
   [ redir proto_min reg 1 flags 0xa ]
 
 # tcp dport 9128 redirect to :123 random,persistent
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000a823 ]
-  [ immediate reg 1 0x00007b00 ]
+  [ cmp eq reg 1 0x23a8 ]
+  [ immediate reg 1 0x007b ]
   [ redir proto_min reg 1 flags 0xe ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
+	element 0001	element 0002	element 0003	element 0004	element 0005	element 0006	element 0007	element 0008	element 0065	element 00ca	element 012f	element 03e9	element 07d2	element 0bbb
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ redir ]
@@ -182,26 +182,26 @@ ip test-ip4 output
 # ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter redirect
 ip test-ip4 output
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ range eq reg 1 0x0000000a 0x0403020a ]
+  [ range eq reg 1 0x0a000000 0x0a020304 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ counter pkts 0 bytes 0 ]
   [ redir ]
 
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } redirect
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
+	element 0016 : drop	element 00de : drop
 ip test-ip4 output
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
@@ -209,11 +209,10 @@ ip test-ip4 output
 # redirect to :tcp dport map { 22 : 8000, 80 : 8080}
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 00001600  : 0000401f 0 [end]    element 00005000  : 0000901f 0 [end]
+	element 0016 : 1f40	element 0050 : 1f90
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ redir proto_min reg 1 flags 0x2 ]
-
diff --git a/tests/py/ip/reject.t.payload b/tests/py/ip/reject.t.payload
index 5829065a154f6..c5419d096cf37 100644
--- a/tests/py/ip/reject.t.payload
+++ b/tests/py/ip/reject.t.payload
@@ -37,8 +37,7 @@ ip test-ip4 output
 # mark 0x80000000 reject with tcp reset
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ meta load mark => reg 1 ]
   [ cmp eq reg 1 0x80000000 ]
   [ reject type 1 code 0 ]
-
diff --git a/tests/py/ip/rt.t.payload b/tests/py/ip/rt.t.payload
index 93eef4a77bb72..97c0ad30f2449 100644
--- a/tests/py/ip/rt.t.payload
+++ b/tests/py/ip/rt.t.payload
@@ -1,5 +1,4 @@
 # rt nexthop 192.168.0.1
 ip test-ip4 output
   [ rt load nexthop4 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
-
+  [ cmp eq reg 1 0xc0a80001 ]
diff --git a/tests/py/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
index cc04b43d64bff..de8182e00c014 100644
--- a/tests/py/ip/sets.t.payload.inet
+++ b/tests/py/ip/sets.t.payload.inet
@@ -1,7 +1,7 @@
 # ip saddr @set1 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
@@ -9,7 +9,7 @@ inet test-inet input
 # ip saddr != @set1 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 0x1 ]
   [ immediate reg 0 drop ]
@@ -17,7 +17,7 @@ inet test-inet input
 # ip saddr @set2 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
@@ -25,7 +25,7 @@ inet test-inet input
 # ip saddr != @set2 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 drop ]
@@ -33,7 +33,7 @@ inet test-inet input
 # ip saddr . ip daddr @set5 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set set5 ]
@@ -42,7 +42,7 @@ inet test-inet input
 # add @set5 { ip saddr . ip daddr }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ dynset add reg_key 1 set set5 ]
@@ -50,27 +50,27 @@ inet test-inet input
 # ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 }
 __set%d t 3
 __set%d t 0
-	element 00010101  : 0 [end]	element 00030303  : 0 [end]	element 00020202  : 0 [end]
+	element 01010100	element 03030300	element 02020200
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 }
 __set%d t 7
 __set%d t 0
-	element 00000000  : 1 [end]	element 00010101  : 0 [end]	element 00020101  : 1 [end]	element 00020202  : 0 [end]	element 00030202  : 1 [end]	element 00030303  : 0 [end]	element 00040303  : 1 [end]
+	element 00000000 flags 1	element 01010100	element 01010200 flags 1	element 02020200	element 02020300 flags 1	element 03030300	element 03030400 flags 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip saddr @set6 drop
 inet
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set6 ]
   [ immediate reg 0 drop ]
@@ -78,7 +78,7 @@ inet
 # add @map1 { ip saddr . ip daddr : meta mark }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ meta load mark => reg 10 ]
@@ -87,20 +87,20 @@ inet test-inet input
 # ip saddr vmap { 1.1.1.1 : drop, * : accept }
 __map%d test-inet b
 __map%d test-inet 0
-        element 01010101  : drop 0 [end]        element  : accept 2 [end]
+	element 01010101 : drop	element  : accept flags 2
 inet
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 }
 __map%d test-inet b
 __map%d test-inet 0
-        element 01010101  : 00000001 0 [end]    element  : 00000002 2 [end]
+	element 01010101 : 00000001	element  : 00000002 flags 2
 inet
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
@@ -108,10 +108,10 @@ inet
 # add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 2b @ transport header + 2 => reg 10 ]
-  [ immediate reg 11 0x0100000a ]
-  [ immediate reg 2 0x00005000 ]
+  [ immediate reg 11 0x0a000001 ]
+  [ immediate reg 2 0x0050 ]
   [ dynset add reg_key 1 set map2 sreg_data 11 ]
diff --git a/tests/py/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
index f9ee1f98203bf..957133707c62a 100644
--- a/tests/py/ip/sets.t.payload.ip
+++ b/tests/py/ip/sets.t.payload.ip
@@ -38,7 +38,7 @@ ip test-ip4 input
 # ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00010101  : 0 [end]	element 00030303  : 0 [end]	element 00020202  : 0 [end]
+	element 01010100	element 03030300	element 02020200
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -46,7 +46,7 @@ ip test-ip4 input
 # ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 }
 __set%d test-ip4 7
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00010101  : 0 [end]	element 00020101  : 1 [end]	element 00020202  : 0 [end]	element 00030202  : 1 [end]	element 00030303  : 0 [end]	element 00040303  : 1 [end]
+	element 00000000 flags 1	element 01010100	element 01010200 flags 1	element 02020200	element 02020300 flags 1	element 03030300	element 03030400 flags 1
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -60,7 +60,7 @@ ip
 # ip saddr vmap { 1.1.1.1 : drop, * : accept }
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 01010101  : drop 0 [end]        element  : accept 2 [end]
+	element 01010101 : drop	element  : accept flags 2
 ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -68,7 +68,7 @@ ip
 # meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 }
 __map%d test-ip4 b
 __map%d test-ip4 0
-        element 01010101  : 00000001 0 [end]    element  : 00000002 2 [end]
+	element 01010101 : 00000001	element  : 00000002 flags 2
 ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -86,6 +86,6 @@ ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 2b @ transport header + 2 => reg 10 ]
-  [ immediate reg 11 0x0100000a ]
-  [ immediate reg 2 0x00005000 ]
+  [ immediate reg 11 0x0a000001 ]
+  [ immediate reg 2 0x0050 ]
   [ dynset add reg_key 1 set map2 sreg_data 11 ]
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
index 3d0dc79acfd91..66e20fa980221 100644
--- a/tests/py/ip/sets.t.payload.netdev
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -1,7 +1,7 @@
 # ip saddr @set1 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
@@ -9,7 +9,7 @@ netdev test-netdev ingress
 # ip saddr != @set1 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 0x1 ]
   [ immediate reg 0 drop ]
@@ -17,7 +17,7 @@ netdev test-netdev ingress
 # ip saddr @set2 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
@@ -25,7 +25,7 @@ netdev test-netdev ingress
 # ip saddr != @set2 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 drop ]
@@ -33,7 +33,7 @@ netdev test-netdev ingress
 # ip saddr . ip daddr @set5 drop
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set set5 ]
@@ -42,7 +42,7 @@ netdev test-netdev ingress
 # add @set5 { ip saddr . ip daddr }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ dynset add reg_key 1 set set5 ]
@@ -50,27 +50,27 @@ netdev test-netdev ingress
 # ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 }
 __set%d test-netdev 3
 __set%d test-netdev 0
-	element 00010101  : 0 [end]	element 00030303  : 0 [end]	element 00020202  : 0 [end]
+	element 01010100	element 03030300	element 02020200
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 }
 __set%d test-netdev 7
 __set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00010101  : 0 [end]	element 00020101  : 1 [end]	element 00020202  : 0 [end]	element 00030202  : 1 [end]	element 00030303  : 0 [end]	element 00040303  : 1 [end]
+	element 00000000 flags 1	element 01010100	element 01010200 flags 1	element 02020200	element 02020300 flags 1	element 03030300	element 03030400 flags 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip saddr @set6 drop
 netdev
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set6 ]
   [ immediate reg 0 drop ]
@@ -78,20 +78,20 @@ netdev
 # ip saddr vmap { 1.1.1.1 : drop, * : accept }
 __map%d test-netdev b
 __map%d test-netdev 0
-        element 01010101  : drop 0 [end]        element  : accept 2 [end]
+	element 01010101 : drop	element  : accept flags 2
 netdev
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 }
 __map%d test-netdev b
 __map%d test-netdev 0
-        element 01010101  : 00000001 0 [end]    element  : 00000002 2 [end]
+	element 01010101 : 00000001	element  : 00000002 flags 2
 netdev
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
@@ -99,7 +99,7 @@ netdev
 # add @map1 { ip saddr . ip daddr : meta mark }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ meta load mark => reg 10 ]
@@ -108,10 +108,10 @@ netdev test-netdev ingress
 # add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 2b @ transport header + 2 => reg 10 ]
-  [ immediate reg 11 0x0100000a ]
-  [ immediate reg 2 0x00005000 ]
+  [ immediate reg 11 0x0a000001 ]
+  [ immediate reg 2 0x0050 ]
   [ dynset add reg_key 1 set map2 sreg_data 11 ]
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index ef45489959704..0801a3befd873 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -1,95 +1,95 @@
 # iifname "eth0" tcp dport 80-90 snat to 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 80-90 snat to 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ range neq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport {80, 90, 23} snat to 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
+	element 0050	element 005a	element 0017
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
+	element 0050	element 005a	element 0017
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002200 ]
-  [ immediate reg 1 0x0203a8c0 ]
+  [ range neq reg 1 0x0017 0x0022 ]
+  [ immediate reg 1 0xc0a80302 ]
   [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 80-90 snat to 192.168.3.0-192.168.3.255
 ip
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x0003a8c0 ]
-  [ immediate reg 2 0xff03a8c0 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0xc0a80300 ]
+  [ immediate reg 2 0xc0a803ff ]
   [ nat snat ip addr_min reg 1 addr_max reg 2 ]
 
 # iifname "eth0" tcp dport 80-90 snat to 192.168.3.15-192.168.3.240
 ip
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x0f03a8c0 ]
-  [ immediate reg 2 0xf003a8c0 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0xc0a8030f ]
+  [ immediate reg 2 0xc0a803f0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 2 ]
 
 # meta l4proto 17 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-	element 040b8d0a  : 0302a8c0 00005000 0 [end]
+	element 0a8d0b04 : c0a80203 . 0050
 ip
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat snat ip addr_min reg 1 proto_min reg 9 ]
@@ -97,7 +97,7 @@ ip
 # snat ip to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-	element 040b8d0a  : 0202a8c0 0402a8c0 0 [end]
+	element 0a8d0b04 : c0a80202 . c0a80204
 ip 
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -106,7 +106,7 @@ ip
 # snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
 __map%d test-ip4 f size 3
 __map%d test-ip4 0
-	element 00000000  : 1 [end]	element 000b8d0a  : 0002a8c0 ff02a8c0 0 [end]	element 000c8d0a  : 1 [end]
+	element 00000000 flags 1	element 0a8d0b00 : c0a80200 . c0a802ff	element 0a8d0c00 flags 1
 ip 
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -115,7 +115,7 @@ ip
 # snat ip to ip saddr map { 10.141.12.14 : 192.168.2.0/24 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-        element 0e0c8d0a  : 0002a8c0 ff02a8c0 0 [end]
+	element 0a8d0c0e : c0a80200 . c0a802ff
 ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -124,10 +124,10 @@ ip
 # meta l4proto { 6, 17} snat ip to ip saddr . th dport map { 10.141.11.4 . 20 : 192.168.2.3 . 80}
 __set%d test-ip4 3 size 2
 __set%d test-ip4 0
-        element 00000006  : 0 [end]     element 00000011  : 0 [end]
+	element 06	element 11
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
-        element 040b8d0a 00001400  : 0302a8c0 00005000 0 [end]
+	element 0a8d0b04 . 0014 : c0a80203 . 0050
 ip
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d ]
diff --git a/tests/py/ip/tcp.t.payload b/tests/py/ip/tcp.t.payload
index 58956d984b1b7..cb464b17d0e8a 100644
--- a/tests/py/ip/tcp.t.payload
+++ b/tests/py/ip/tcp.t.payload
@@ -1,18 +1,17 @@
 # ip protocol tcp tcp dport ssh accept
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ immediate reg 0 accept ]
 
 # ip protocol ne tcp udp dport ssh accept
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
+  [ cmp neq reg 1 0x06 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ immediate reg 0 accept ]
-
diff --git a/tests/py/ip/tproxy.t.payload b/tests/py/ip/tproxy.t.payload
index dfe830ec37152..2f2ff0e2f5bec 100644
--- a/tests/py/ip/tproxy.t.payload
+++ b/tests/py/ip/tproxy.t.payload
@@ -1,44 +1,43 @@
 # meta l4proto 17 tproxy to 192.0.2.1
 ip x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x010200c0 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0xc0000201 ]
   [ tproxy ip addr reg 1 ]
 
 # meta l4proto 6 tproxy to 192.0.2.1:50080
 ip x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x010200c0 ]
-  [ immediate reg 2 0x0000a0c3 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0xc0000201 ]
+  [ immediate reg 2 0xc3a0 ]
   [ tproxy ip addr reg 1 port reg 2 ]
 
 # ip protocol 6 tproxy to :50080
 ip x y 
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x0000a0c3 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0xc3a0 ]
   [ tproxy ip port reg 1 ]
 
 # meta l4proto 17 tproxy ip to 192.0.2.1
 ip x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x010200c0 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0xc0000201 ]
   [ tproxy ip addr reg 1 ]
 
 # meta l4proto 6 tproxy ip to 192.0.2.1:50080
 ip x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x010200c0 ]
-  [ immediate reg 2 0x0000a0c3 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0xc0000201 ]
+  [ immediate reg 2 0xc3a0 ]
   [ tproxy ip addr reg 1 port reg 2 ]
 
 # ip protocol 6 tproxy ip to :50080
 ip x y 
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x0000a0c3 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0xc3a0 ]
   [ tproxy ip port reg 1 ]
-
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
index a7a56d4be80bf..35f64e646f1cd 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -1,7 +1,7 @@
 # ct mark set ip6 dscp << 2 | 0x10
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
@@ -11,7 +11,7 @@ ip6 test-ip6 output
 # ct mark set ip6 dscp << 26 | 0x10
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
@@ -21,7 +21,7 @@ ip6 test-ip6 output
 # ct mark set ip6 dscp | 0x04
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
@@ -30,7 +30,7 @@ ip6 test-ip6 output
 # ct mark set ip6 dscp | 0xff000000
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x00ffffff ) ^ 0xff000000 ]
@@ -39,7 +39,7 @@ ip6 test-ip6 output
 # ct mark set ip6 dscp & 0x0f << 2
 ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
@@ -49,7 +49,7 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ ct load mark => reg 1 ]
   [ payload load 2b @ network header + 0 => reg 2 ]
-  [ bitwise reg 2 = ( reg 2 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 2 = ntoh(reg 2, 2, 2) ]
   [ bitwise reg 2 = ( reg 2 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index fe6e0422f074b..26f0f603b531c 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -1,44 +1,44 @@
 # tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
 ip6 test-ip6 prerouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
-  [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
-  [ immediate reg 3 0x00005000 ]
-  [ immediate reg 4 0x00006400 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0x20010838 0x035f0001 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x20010838 0x035f0002 0x00000000 0x00000000 ]
+  [ immediate reg 3 0x0050 ]
+  [ immediate reg 4 0x0064 ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 flags 0x2 ]
 
 # tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 prerouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
-  [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
-  [ immediate reg 3 0x00006400 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0x20010838 0x035f0001 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x20010838 0x035f0002 0x00000000 0x00000000 ]
+  [ immediate reg 3 0x0064 ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 flags 0x2 ]
 
 # tcp dport 80-90 dnat to [2001:838:35f:1::]:80
 ip6 test-ip6 prerouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
-  [ immediate reg 2 0x00005000 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0x20010838 0x035f0001 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x0050 ]
   [ nat dnat ip6 addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # dnat to [2001:838:35f:1::]/64
 ip6 test-ip6 prerouting
-  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
-  [ immediate reg 2 0x38080120 0x01005f03 0xffffffff 0xffffffff ]
+  [ immediate reg 1 0x20010838 0x035f0001 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x20010838 0x035f0001 0xffffffff 0xffffffff ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 2 ]
 
 # dnat to 2001:838:35f:1::-2001:838:35f:1:ffff:ffff:ffff:ffff
 ip6 test-ip6 prerouting
-  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
-  [ immediate reg 2 0x38080120 0x01005f03 0xffffffff 0xffffffff ]
+  [ immediate reg 1 0x20010838 0x035f0001 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x20010838 0x035f0001 0xffffffff 0xffffffff ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 2 ]
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index eb7a87d577a31..47eea7f85a7d7 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -1,119 +1,119 @@
 # dst nexthdr 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # dst nexthdr != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # dst nexthdr 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # dst nexthdr != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # dst nexthdr { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # dst nexthdr != icmp
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # dst hdrlength 22
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # dst hdrlength != 233
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # dst hdrlength 33-45
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # dst hdrlength != 33-45
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # dst hdrlength { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index ac1fc8b39a2b7..f4fc9aed36671 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -1,27 +1,27 @@
 # dst nexthdr 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # dst nexthdr != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # dst nexthdr 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # dst nexthdr != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # dst nexthdr { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -29,7 +29,7 @@ ip6 test-ip6 input
 # dst nexthdr != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -37,7 +37,7 @@ ip6 test-ip6 input
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -45,7 +45,7 @@ ip6 test-ip6 input
 # dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -53,37 +53,37 @@ ip6 test-ip6 input
 # dst nexthdr icmp
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # dst nexthdr != icmp
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # dst hdrlength 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # dst hdrlength != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # dst hdrlength 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # dst hdrlength != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # dst hdrlength { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
diff --git a/tests/py/ip6/dup.t.payload b/tests/py/ip6/dup.t.payload
index c441d4be981bf..55bb3747d9608 100644
--- a/tests/py/ip6/dup.t.payload
+++ b/tests/py/ip6/dup.t.payload
@@ -1,21 +1,20 @@
 # dup to abcd::1
 ip6 test test 
-  [ immediate reg 1 0x0000cdab 0x00000000 0x00000000 0x01000000 ]
+  [ immediate reg 1 0xabcd0000 0x00000000 0x00000000 0x00000001 ]
   [ dup sreg_addr 1 ]
 
 # dup to abcd::1 device "lo"
 ip6 test test 
-  [ immediate reg 1 0x0000cdab 0x00000000 0x00000000 0x01000000 ]
+  [ immediate reg 1 0xabcd0000 0x00000000 0x00000000 0x00000001 ]
   [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
 # dup to ip6 saddr map { abcd::1 : cafe::cafe } device "lo"
 __map%d test-ip6 b
 __map%d test-ip6 0
-        element 0000cdab 00000000 00000000 01000000  : 0000feca 00000000 00000000 feca0000 0 [end]
+	element abcd0000 00000000 00000000 00000001 : cafe0000 00000000 00000000 0000cafe
 ip6 test-ip6 input 
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
-
diff --git a/tests/py/ip6/ether.t.payload b/tests/py/ip6/ether.t.payload
index 592b4ea0e0bcc..b26ad647a19c2 100644
--- a/tests/py/ip6/ether.t.payload
+++ b/tests/py/ip6/ether.t.payload
@@ -1,49 +1,49 @@
 # tcp dport 22 iiftype ether ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:4 accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 0x00000000 0x00000000 0x02000000 ]
+  [ cmp eq reg 1 0x00010000 0x00000000 0x00000000 0x00000002 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 0x00000000 0x00000000 0x02000000 ]
+  [ cmp eq reg 1 0x00010000 0x00000000 0x00000000 0x00000002 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip6 daddr 1::2
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 0x00000000 0x00000000 0x02000000 ]
+  [ cmp eq reg 1 0x00010000 0x00000000 0x00000000 0x00000002 ]
 
 # ether saddr 00:0f:54:0c:11:04 ip6 daddr 1::2 accept
 ip6 test-ip6 input
   [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ cmp eq reg 1 0x000f540c 0x1104 ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 0x00000000 0x00000000 0x02000000 ]
+  [ cmp eq reg 1 0x00010000 0x00000000 0x00000000 0x00000002 ]
   [ immediate reg 0 accept ]
diff --git a/tests/py/ip6/exthdr.t.payload.ip6 b/tests/py/ip6/exthdr.t.payload.ip6
index be10d61ef6ccc..230a51375c797 100644
--- a/tests/py/ip6/exthdr.t.payload.ip6
+++ b/tests/py/ip6/exthdr.t.payload.ip6
@@ -1,60 +1,59 @@
 # exthdr hbh exists
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # exthdr rt exists
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # exthdr frag exists
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 44 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # exthdr dst exists
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # exthdr mh exists
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # exthdr hbh missing
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # exthdr hbh == exists
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # exthdr hbh == missing
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # exthdr hbh != exists
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # exthdr hbh != missing
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp neq reg 1 0x00000000 ]
+  [ cmp neq reg 1 0x00 ]
 
 # exthdr hbh 1
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # exthdr hbh 0
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
+  [ cmp eq reg 1 0x00 ]
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 1100896eb61c0..c2c8f2eb84e98 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -1,229 +1,228 @@
 # frag nexthdr tcp
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # frag nexthdr != icmp
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag nexthdr esp
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
 
 # frag nexthdr ah
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
 
 # frag reserved 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # frag reserved != 233
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # frag reserved 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # frag reserved != 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # frag reserved { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag reserved != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag frag-off 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000b000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x00b0 ]
 
 # frag frag-off != 233
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00004807 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0748 ]
 
 # frag frag-off 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ range eq reg 1 0x00000801 0x00006801 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ range eq reg 1 0x0108 0x0168 ]
 
 # frag frag-off != 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ range neq reg 1 0x00000801 0x00006801 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ range neq reg 1 0x0108 0x0168 ]
 
 # frag frag-off { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+	element 0108	element 01b8	element 0218	element 02c0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
 
 # frag frag-off != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+	element 0108	element 01b8	element 0218	element 02c0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag id 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # frag id 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # frag id != 33
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp neq reg 1 0x21000000 ]
+  [ cmp neq reg 1 0x00000021 ]
 
 # frag id 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # frag id != 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # frag id { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag id != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag reserved2 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x06 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x02 ]
 
 # frag more-fragments 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x01 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # frag more-fragments 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
-
+  [ bitwise reg 1 = ( reg 1 & 0x01 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x01 ]
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index 0556395a87ca4..f3d2dd14d2391 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -1,17 +1,17 @@
 # frag nexthdr tcp
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # frag nexthdr != icmp
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -19,7 +19,7 @@ ip6 test-ip6 output
 # frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -27,37 +27,37 @@ ip6 test-ip6 output
 # frag nexthdr esp
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
 
 # frag nexthdr ah
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
 
 # frag reserved 22
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # frag reserved != 233
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # frag reserved 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # frag reserved != 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # frag reserved { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -65,7 +65,7 @@ ip6 test-ip6 output
 # frag reserved != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -73,74 +73,74 @@ ip6 test-ip6 output
 # frag frag-off 22
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000b000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x00b0 ]
 
 # frag frag-off != 233
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00004807 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0748 ]
 
 # frag frag-off 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ range eq reg 1 0x00000801 0x00006801 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ range eq reg 1 0x0108 0x0168 ]
 
 # frag frag-off != 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ range neq reg 1 0x00000801 0x00006801 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ range neq reg 1 0x0108 0x0168 ]
 
 # frag frag-off { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+	element 0108	element 01b8	element 0218	element 02c0
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
 
 # frag frag-off != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+	element 0108	element 01b8	element 0218	element 02c0
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag id 1
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # frag id 22
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # frag id != 33
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp neq reg 1 0x21000000 ]
+  [ cmp neq reg 1 0x00000021 ]
 
 # frag id 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # frag id != 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # frag id { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -148,7 +148,7 @@ ip6 test-ip6 output
 # frag id != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -156,18 +156,17 @@ ip6 test-ip6 output
 # frag reserved2 1
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x06 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x02 ]
 
 # frag more-fragments 0
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x01 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # frag more-fragments 1
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
-
+  [ bitwise reg 1 = ( reg 1 & 0x01 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x01 ]
diff --git a/tests/py/ip6/frag.t.payload.netdev b/tests/py/ip6/frag.t.payload.netdev
index 68257f5bcefe3..e78400f9ae91e 100644
--- a/tests/py/ip6/frag.t.payload.netdev
+++ b/tests/py/ip6/frag.t.payload.netdev
@@ -1,229 +1,228 @@
 # frag nexthdr tcp
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
 
 # frag nexthdr != icmp
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
 __set%d test-netdev 3 size 8
 __set%d test-netdev 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
 __set%d test-netdev 3 size 8
 __set%d test-netdev 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag nexthdr esp
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
 
 # frag nexthdr ah
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
+  [ cmp eq reg 1 0x33 ]
 
 # frag reserved 22
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # frag reserved != 233
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # frag reserved 33-45
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # frag reserved != 33-45
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # frag reserved { 33, 55, 67, 88}
 __set%d test-netdev 3 size 4
 __set%d test-netdev 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag reserved != { 33, 55, 67, 88}
 __set%d test-netdev 3 size 4
 __set%d test-netdev 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag frag-off 22
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000b000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x00b0 ]
 
 # frag frag-off != 233
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00004807 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0748 ]
 
 # frag frag-off 33-45
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ range eq reg 1 0x00000801 0x00006801 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ range eq reg 1 0x0108 0x0168 ]
 
 # frag frag-off != 33-45
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ range neq reg 1 0x00000801 0x00006801 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
+  [ range neq reg 1 0x0108 0x0168 ]
 
 # frag frag-off { 33, 55, 67, 88}
 __set%d test-netdev 3 size 4
 __set%d test-netdev 0
-	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+	element 0108	element 01b8	element 0218	element 02c0
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
 
 # frag frag-off != { 33, 55, 67, 88}
 __set%d test-netdev 3 size 4
 __set%d test-netdev 0
-	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+	element 0108	element 01b8	element 0218	element 02c0
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfff8 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag reserved2 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x06 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x02 ]
 
 # frag more-fragments 0
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x01 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x00 ]
 
 # frag more-fragments 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0x01 ) ^ 0x00 ]
+  [ cmp eq reg 1 0x01 ]
 
 # frag id 1
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
+  [ cmp eq reg 1 0x00000001 ]
 
 # frag id 22
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # frag id != 33
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp neq reg 1 0x21000000 ]
+  [ cmp neq reg 1 0x00000021 ]
 
 # frag id 33-45
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # frag id != 33-45
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # frag id { 33, 55, 67, 88}
 __set%d test-netdev 3 size 4
 __set%d test-netdev 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag id != { 33, 55, 67, 88}
 __set%d test-netdev 3 size 4
 __set%d test-netdev 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index 10f010aa57f59..40d6e5966c1fa 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -1,130 +1,129 @@
 # hbh hdrlength 22
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # hbh hdrlength != 233
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # hbh hdrlength 33-45
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # hbh hdrlength != 33-45
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # hbh hdrlength {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh hdrlength != {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr 22
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # hbh nexthdr != 233
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # hbh nexthdr 33-45
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # hbh nexthdr != 33-45
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # hbh nexthdr {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr ip
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # hbh nexthdr != ip
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000000 ]
-
+  [ cmp neq reg 1 0x00 ]
diff --git a/tests/py/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
index a6bc7ae65475d..96c3ee2443f5e 100644
--- a/tests/py/ip6/hbh.t.payload.ip6
+++ b/tests/py/ip6/hbh.t.payload.ip6
@@ -1,27 +1,27 @@
 # hbh hdrlength 22
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # hbh hdrlength != 233
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # hbh hdrlength 33-45
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # hbh hdrlength != 33-45
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # hbh hdrlength {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -29,7 +29,7 @@ ip6 test-ip6 filter-input
 # hbh hdrlength != {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -37,7 +37,7 @@ ip6 test-ip6 filter-input
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -45,7 +45,7 @@ ip6 test-ip6 filter-input
 # hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -53,27 +53,27 @@ ip6 test-ip6 filter-input
 # hbh nexthdr 22
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # hbh nexthdr != 233
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # hbh nexthdr 33-45
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # hbh nexthdr != 33-45
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # hbh nexthdr {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -81,7 +81,7 @@ ip6 test-ip6 filter-input
 # hbh nexthdr != {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -89,10 +89,9 @@ ip6 test-ip6 filter-input
 # hbh nexthdr ip
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # hbh nexthdr != ip
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000000 ]
-
+  [ cmp neq reg 1 0x00 ]
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 8a637afae7fb8..96cad4e4005a9 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -1,162 +1,162 @@
 # icmpv6 type destination-unreachable accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type packet-too-big accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type time-exceeded accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
+  [ cmp eq reg 1 0x03 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type echo-request accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000080 ]
+  [ cmp eq reg 1 0x80 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type echo-reply accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x81 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type mld-listener-query accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
+  [ cmp eq reg 1 0x82 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type mld-listener-report accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000083 ]
+  [ cmp eq reg 1 0x83 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type mld-listener-done accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type mld-listener-reduction accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
+  [ cmp eq reg 1 0x84 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type nd-router-solicit accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000085 ]
+  [ cmp eq reg 1 0x85 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type nd-router-advert accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000086 ]
+  [ cmp eq reg 1 0x86 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type nd-neighbor-solicit accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000087 ]
+  [ cmp eq reg 1 0x87 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type nd-neighbor-advert accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type nd-redirect accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000089 ]
+  [ cmp eq reg 1 0x89 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type parameter-problem accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type router-renumbering accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000008a ]
+  [ cmp eq reg 1 0x8a ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type ind-neighbor-solicit accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000008d ]
+  [ cmp eq reg 1 0x8d ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type ind-neighbor-advert accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000008e ]
+  [ cmp eq reg 1 0x8e ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type mld2-listener-report accept
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000008f ]
+  [ cmp eq reg 1 0x8f ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type {destination-unreachable, time-exceeded, nd-router-solicit} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000001  : 0 [end]	element 00000003  : 0 [end]	element 00000085  : 0 [end]
+	element 01	element 03	element 85
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -164,10 +164,10 @@ ip6 test-ip6 input
 # icmpv6 type {router-renumbering, mld-listener-done, time-exceeded, nd-router-solicit} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 0000008a  : 0 [end]	element 00000084  : 0 [end]	element 00000003  : 0 [end]	element 00000085  : 0 [end]
+	element 8a	element 84	element 03	element 85
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -175,10 +175,10 @@ ip6 test-ip6 input
 # icmpv6 type {mld-listener-query, time-exceeded, nd-router-advert} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000082  : 0 [end]	element 00000003  : 0 [end]	element 00000086  : 0 [end]
+	element 82	element 03	element 86
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -186,10 +186,10 @@ ip6 test-ip6 input
 # icmpv6 type != {mld-listener-query, time-exceeded, nd-router-advert} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000082  : 0 [end]	element 00000003  : 0 [end]	element 00000086  : 0 [end]
+	element 82	element 03	element 86
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -197,24 +197,24 @@ ip6 test-ip6 input
 # icmpv6 code 4
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
 
 # icmpv6 code 3-66
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range eq reg 1 0x00000003 0x00000042 ]
+  [ range eq reg 1 0x03 0x42 ]
 
 # icmpv6 code {5, 6, 7} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]
+	element 05	element 06	element 07
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
@@ -222,10 +222,10 @@ ip6 test-ip6 input
 # icmpv6 code != {policy-fail, reject-route, 7} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]
+	element 05	element 06	element 07
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
@@ -233,156 +233,156 @@ ip6 test-ip6 input
 # icmpv6 checksum 2222 log
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000ae08 ]
+  [ cmp eq reg 1 0x08ae ]
   [ log ]
 
 # icmpv6 checksum != 2222 log
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000ae08 ]
+  [ cmp neq reg 1 0x08ae ]
   [ log ]
 
 # icmpv6 checksum 222-226
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x0000de00 0x0000e200 ]
+  [ range eq reg 1 0x00de 0x00e2 ]
 
 # icmpv6 checksum != 222-226
 ip6
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x0000de00 0x0000e200 ]
+  [ range neq reg 1 0x00de 0x00e2 ]
 
 # icmpv6 checksum { 222, 226}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 0000de00  : 0 [end]	element 0000e200  : 0 [end]
+	element 00de	element 00e2
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmpv6 checksum != { 222, 226}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 0000de00  : 0 [end]	element 0000e200  : 0 [end]
+	element 00de	element 00e2
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 mtu 22
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
+  [ cmp eq reg 1 0x00000016 ]
 
 # icmpv6 mtu != 233
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
+  [ cmp neq reg 1 0x000000e9 ]
 
 # icmpv6 mtu 33-45
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x21000000 0x2d000000 ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # icmpv6 mtu != 33-45
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # icmpv6 mtu {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmpv6 mtu != {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+	element 00000021	element 00000037	element 00000043	element 00000058
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 type packet-too-big icmpv6 mtu 1280
 ip6 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x02 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00050000 ]
+  [ cmp eq reg 1 0x00000500 ]
 
 # icmpv6 id 33-45
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # icmpv6 id != 33-45
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # icmpv6 id {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
@@ -391,13 +391,13 @@ ip6 test-ip6 input
 # icmpv6 id != {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
@@ -406,46 +406,46 @@ ip6 test-ip6 input
 # icmpv6 id 1
 __set%d test-ip6 3 size 2
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 ip6
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
 
 # icmpv6 type echo-reply icmpv6 id 65534
 ip6
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000081 ]
+  [ cmp eq reg 1 0x81 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x0000feff ]
+  [ cmp eq reg 1 0xfffe ]
 
 # icmpv6 sequence 2
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
+  [ cmp eq reg 1 0x0002 ]
 
 # icmpv6 sequence {3, 4, 5, 6, 7} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]
+	element 0003	element 0004	element 0005	element 0006	element 0007
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
@@ -455,13 +455,13 @@ ip6 test-ip6 input
 # icmpv6 sequence {2, 4}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000200  : 0 [end]	element 00000400  : 0 [end]
+	element 0002	element 0004
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
@@ -470,13 +470,13 @@ ip6 test-ip6 input
 # icmpv6 sequence != {2, 4}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000200  : 0 [end]	element 00000400  : 0 [end]
+	element 0002	element 0004
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
@@ -485,153 +485,153 @@ ip6 test-ip6 input
 # icmpv6 sequence 2-4
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range eq reg 1 0x00000200 0x00000400 ]
+  [ range eq reg 1 0x0002 0x0004 ]
 
 # icmpv6 sequence != 2-4
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+	element 80	element 81
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00000200 0x00000400 ]
+  [ range neq reg 1 0x0002 0x0004 ]
 
 # icmpv6 max-delay 33-45
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
+  [ cmp eq reg 1 0x82 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # icmpv6 max-delay != 33-45
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
+  [ cmp eq reg 1 0x82 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # icmpv6 max-delay {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
+  [ cmp eq reg 1 0x82 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmpv6 max-delay != {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
+  [ cmp eq reg 1 0x82 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 type parameter-problem icmpv6 code 0
 ip6 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x0400 ]
 
 # icmpv6 type mld-listener-query icmpv6 taddr 2001:db8::133
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
+  [ cmp eq reg 1 0x82 ]
   [ payload load 16b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
 
 # icmpv6 type nd-neighbor-solicit icmpv6 taddr 2001:db8::133
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000087 ]
+  [ cmp eq reg 1 0x87 ]
   [ payload load 16b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
 
 # icmpv6 type nd-neighbor-advert icmpv6 taddr 2001:db8::133
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
+  [ cmp eq reg 1 0x88 ]
   [ payload load 16b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
 
 # icmpv6 taddr 2001:db8::133
 __set%d test-ip6 3 size 6
 __set%d test-ip6 0
-	element 00000082  : 0 [end]	element 00000083  : 0 [end]	element 00000084  : 0 [end]	element 00000087  : 0 [end]	element 00000088  : 0 [end]	element 00000089  : 0 [end]
+	element 82	element 83	element 84	element 87	element 88	element 89
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 16b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
 
 # icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133
 __set%d test-ip6 3 size 6
 __set%d test-ip6 0
-	element 00000082  : 0 [end]	element 00000083  : 0 [end]	element 00000084  : 0 [end]	element 00000087  : 0 [end]	element 00000088  : 0 [end]	element 00000089  : 0 [end]
+	element 82	element 83	element 84	element 87	element 88	element 89
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 16b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
 
 # icmpv6 type { nd-neighbor-solicit, nd-neighbor-advert } icmpv6 taddr 2001:db8::133
 __set%d test-ip6 3 size 2
 __set%d test-ip6 0
-	element 00000087  : 0 [end]	element 00000088  : 0 [end]
+	element 87	element 88
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 16b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
 
 # icmpv6 daddr 2001:db8::133
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000089 ]
+  [ cmp eq reg 1 0x89 ]
   [ payload load 16b @ transport header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
 
 # icmpv6 type nd-redirect icmpv6 daddr 2001:db8::133
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000089 ]
+  [ cmp eq reg 1 0x89 ]
   [ payload load 16b @ transport header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+  [ cmp eq reg 1 0x20010db8 0x00000000 0x00000000 0x00000133 ]
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index f0c1843d4b3e1..99b4c3afe0fac 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -1,64 +1,64 @@
 # ip6 dscp cs1
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0200 ]
 
 # ip6 dscp != cs1
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0200 ]
 
 # ip6 dscp 0x38
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000e ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0e00 ]
 
 # ip6 dscp != 0x20
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000008 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0800 ]
 
 # ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000000  : 0 [end]     element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]    element 00000008  : 0 [end]      element 0000000a  : 0 [end]     element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
+	element 0000	element 0200	element 0400	element 0600	element 0800	element 0a00	element 0c00	element 0e00	element 0280	element 0300	element 0380	element 0480	element 0500	element 0580	element 0680	element 0700	element 0780	element 0880	element 0900	element 0980	element 0b80
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
 __map%d test-inet b size 2
 __map%d test-inet 0
-	element 00000001  : accept 0 [end]	element 0000c00f  : continue 0 [end]
+	element 0100 : accept	element 0fc0 : continue
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
 # meta mark set ip6 dscp map @map1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ lookup reg 1 set map1 dreg 1 ]
@@ -67,9 +67,9 @@ inet test-inet input
 # meta mark set ip6 dscp . ip6 daddr map @map2
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ payload load 16b @ network header + 24 => reg 9 ]
@@ -79,9 +79,9 @@ inet test-inet input
 # ip6 dscp @map3
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ lookup reg 1 set map3 ]
@@ -89,9 +89,9 @@ inet test-inet input
 # ip6 dscp . ip6 daddr @map4
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ payload load 16b @ network header + 24 => reg 9 ]
@@ -100,505 +100,505 @@ inet test-inet input
 # ip6 flowlabel 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00160000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
+  [ cmp eq reg 1 0x000016 ]
 
 # ip6 flowlabel != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00e90000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
+  [ cmp neq reg 1 0x0000e9 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
+	element 000021	element 000037	element 000043	element 000058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
+	element 000021	element 000037	element 000043	element 000058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-inet b size 2
 __map%d test-inet 0
-	element 00000000  : accept 0 [end]	element 00020000  : continue 0 [end]
+	element 000000 : accept	element 000002 : continue
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 length 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip6 length != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip6 length 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip6 length != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip6 length { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 length != {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 11	element 33	element 6c	element 88	element 06	element 21	element 84
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 nexthdr esp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
 
 # ip6 nexthdr != esp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000032 ]
+  [ cmp neq reg 1 0x32 ]
 
 # ip6 nexthdr 33-44
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002c ]
+  [ range eq reg 1 0x21 0x2c ]
 
 # ip6 nexthdr != 33-44
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002c ]
+  [ range neq reg 1 0x21 0x2c ]
 
 # ip6 hoplimit 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # ip6 hoplimit != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # ip6 hoplimit 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # ip6 hoplimit != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # ip6 hoplimit {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 hoplimit != {33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr ::1234:1234:1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00001234 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:0:1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:0:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234::1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00003412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12340000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234:0:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234::
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x00003412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x12340000 ]
 
 # ip6 saddr ::1234:1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234::1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234::1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00003412 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12340000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234::
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x00000000 ]
 
 # ip6 saddr ::1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234::1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234::
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00003412 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12340000 0x00000000 ]
 
 # ip6 saddr ::1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234::
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234::
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234::1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234::
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234::
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00000000 0x00000000 ]
 
 # ip6 saddr ::/64
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 8b @ network header + 8 => reg 1 ]
   [ cmp eq reg 1 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1 ip6 daddr ::2
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000001 ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000002 ]
 
 # ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 34120000 34123412 34123412 34123412  : 0 [end]	element 34123412 34120000 34123412 34123412  : 0 [end]
+	element 00001234 12341234 12341234 12341234	element 12341234 00001234 12341234 12341234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ range neq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ range neq reg 1 0x00001234 0x12341234 0x12341234 0x12341234 0x12341234 0x00001234 0x12341234 0x12341234 ]
 
 # iif "lo" ip6 daddr set ::1
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0x0a ]
+  [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x00000001 ]
   [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # iif "lo" ip6 hoplimit set 1
@@ -606,8 +606,8 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ immediate reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x0a ]
+  [ immediate reg 1 0x01 ]
   [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set af42
@@ -615,9 +615,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000009 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf03f ) ^ 0x0900 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set 63
@@ -625,9 +625,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x0000c00f ]
+  [ bitwise reg 1 = ( reg 1 & 0xf03f ) ^ 0x0fc0 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ect0
@@ -635,9 +635,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xcf ) ^ 0x20 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ce
@@ -645,9 +645,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000030 ]
+  [ bitwise reg 1 = ( reg 1 & 0xcf ) ^ 0x30 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0
@@ -655,9 +655,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf00000 ) ^ 0x000000 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 12345
@@ -665,9 +665,9 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00393000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf00000 ) ^ 0x003039 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0xfffff
@@ -675,8 +675,7 @@ inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00ffff0f ]
+  [ bitwise reg 1 = ( reg 1 & 0xf00000 ) ^ 0x0fffff ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
-
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 5118d4f22be56..1fb8147ffe20c 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -1,50 +1,50 @@
 # ip6 dscp cs1
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0200 ]
 
 # ip6 dscp != cs1
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0200 ]
 
 # ip6 dscp 0x38
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000e ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp eq reg 1 0x0e00 ]
 
 # ip6 dscp != 0x20
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000008 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
+  [ cmp neq reg 1 0x0800 ]
 
 # ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-ip6 3
 __set%d test-ip6 0
-        element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]     element 00000008  : 0 [end]    element 0000000a  : 0 [end]      element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00000000  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
+	element 0000	element 0200	element 0400	element 0600	element 0800	element 0a00	element 0c00	element 0e00	element 0280	element 0300	element 0380	element 0480	element 0500	element 0580	element 0680	element 0700	element 0780	element 0880	element 0900	element 0980	element 0b80
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
 __map%d test-ip6 b size 2
 __map%d test-ip6 0
-	element 00000001  : accept 0 [end]	element 0000c00f  : continue 0 [end]
+	element 0100 : accept	element 0fc0 : continue
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
 # meta mark set ip6 dscp map @map1
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ lookup reg 1 set map1 dreg 1 ]
@@ -53,7 +53,7 @@ ip6 test-ip6 input
 # meta mark set ip6 dscp . ip6 daddr map @map2
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ payload load 16b @ network header + 24 => reg 9 ]
@@ -63,7 +63,7 @@ ip6 test-ip6 input
 # ip6 dscp @map3
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ lookup reg 1 set map3 ]
@@ -71,7 +71,7 @@ ip6 test-ip6 input
 # ip6 dscp . ip6 daddr @map4
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ payload load 16b @ network header + 24 => reg 9 ]
@@ -80,66 +80,66 @@ ip6 test-ip6 input
 # ip6 flowlabel 22
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00160000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
+  [ cmp eq reg 1 0x000016 ]
 
 # ip6 flowlabel != 233
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00e90000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
+  [ cmp neq reg 1 0x0000e9 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
+	element 000021	element 000037	element 000043	element 000058
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
+	element 000021	element 000037	element 000043	element 000058
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-ip6 b size 2
 __map%d test-ip6 0
-	element 00000000  : accept 0 [end]	element 00020000  : continue 0 [end]
+	element 000000 : accept	element 000002 : continue
 ip6 test-ip6 input 
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fffff ) ^ 0x000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 length 22
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # ip6 length != 233
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # ip6 length 33-45
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # ip6 length != 33-45
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # ip6 length { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -147,7 +147,7 @@ ip6 test-ip6 input
 # ip6 length != {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -155,7 +155,7 @@ ip6 test-ip6 input
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+	element 11	element 33	element 6c	element 88	element 06	element 21	element 84
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -163,7 +163,7 @@ ip6 test-ip6 input
 # ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -171,7 +171,7 @@ ip6 test-ip6 input
 # ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+	element 32	element 33	element 6c	element 11	element 88	element 06	element 21	element 84	element 3a
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -179,47 +179,47 @@ ip6 test-ip6 input
 # ip6 nexthdr esp
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
+  [ cmp eq reg 1 0x32 ]
 
 # ip6 nexthdr != esp
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000032 ]
+  [ cmp neq reg 1 0x32 ]
 
 # ip6 nexthdr 33-44
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002c ]
+  [ range eq reg 1 0x21 0x2c ]
 
 # ip6 nexthdr != 33-44
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002c ]
+  [ range neq reg 1 0x21 0x2c ]
 
 # ip6 hoplimit 1
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # ip6 hoplimit != 233
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # ip6 hoplimit 33-45
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # ip6 hoplimit != 33-45
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # ip6 hoplimit {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -227,7 +227,7 @@ ip6 test-ip6 input
 # ip6 hoplimit != {33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -235,187 +235,187 @@ ip6 test-ip6 input
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr ::1234:1234:1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00001234 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:0:1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:0:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234::1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00003412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12340000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234:0:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234::
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x00003412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x12340000 ]
 
 # ip6 saddr ::1234:1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x34123412 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x12341234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234::1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234::1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00003412 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12340000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234::
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x34123412 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12341234 0x00000000 ]
 
 # ip6 saddr ::1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x34120000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00001234 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234:1234::1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234:1234::
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00003412 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x12340000 0x00000000 ]
 
 # ip6 saddr ::1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x34123412 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x12341234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234:1234::1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234:1234::
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x34123412 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12341234 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x34120000 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00001234 0x12341234 ]
 
 # ip6 saddr 1234::1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234:1234::1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234:1234::
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00003412 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x12340000 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x34123412 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x12341234 ]
 
 # ip6 saddr 1234::1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234:1234::
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x34123412 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12341234 0x00000000 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x34120000 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00001234 ]
 
 # ip6 saddr 1234::
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00003412 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x12340000 0x00000000 0x00000000 0x00000000 ]
 
 # ip6 saddr ::/64
 ip6 test-ip6 input
@@ -425,14 +425,14 @@ ip6 test-ip6 input
 # ip6 saddr ::1 ip6 daddr ::2
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000001 ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000002 ]
 
 # ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 }
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 34120000 34123412 34123412 34123412  : 0 [end]	element 34123412 34120000 34123412 34123412  : 0 [end]
+	element 00001234 12341234 12341234 12341234	element 12341234 00001234 12341234 12341234
 ip6 test-ip6 input 
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -440,20 +440,20 @@ ip6 test-ip6 input
 # ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ range neq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ range neq reg 1 0x00001234 0x12341234 0x12341234 0x12341234 0x12341234 0x00001234 0x12341234 0x12341234 ]
 
 # iif "lo" ip6 daddr set ::1
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x00000001 ]
   [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # iif "lo" ip6 hoplimit set 1
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ immediate reg 1 0x00000001 ]
+  [ immediate reg 1 0x01 ]
   [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set af42
@@ -461,7 +461,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000009 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf03f ) ^ 0x0900 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set 63
@@ -469,7 +469,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x0000c00f ]
+  [ bitwise reg 1 = ( reg 1 & 0xf03f ) ^ 0x0fc0 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ect0
@@ -477,7 +477,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0xcf ) ^ 0x20 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ce
@@ -485,7 +485,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000030 ]
+  [ bitwise reg 1 = ( reg 1 & 0xcf ) ^ 0x30 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0
@@ -493,7 +493,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf00000 ) ^ 0x000000 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 12345
@@ -501,7 +501,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00393000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xf00000 ) ^ 0x003039 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0xfffff
@@ -509,6 +509,5 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00ffff0f ]
+  [ bitwise reg 1 = ( reg 1 & 0xf00000 ) ^ 0x0fffff ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
-
diff --git a/tests/py/ip6/map.t.payload b/tests/py/ip6/map.t.payload
index 8e900c18c5e3d..ea39a81e83ff0 100644
--- a/tests/py/ip6/map.t.payload
+++ b/tests/py/ip6/map.t.payload
@@ -1,10 +1,9 @@
 # mark set ip6 saddr and ::ffff map { ::2 : 0x0000002a, ::ffff : 0x00000017}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 02000000  : 0000002a 0 [end]	element 00000000 00000000 00000000 ffff0000  : 00000017 0 [end]
+	element 00000000 00000000 00000000 00000002 : 0000002a	element 00000000 00000000 00000000 0000ffff : 00000017
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000000 0x00000000 0x00000000 0xffff0000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000000 0x00000000 0x00000000 0x0000ffff ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
-
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index 086a6dda82746..89940900c8369 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -1,98 +1,98 @@
 # udp dport 53 masquerade
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq ]
 
 # udp dport 53 masquerade random
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x4 ]
 
 # udp dport 53 masquerade random,persistent
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0xc ]
 
 # udp dport 53 masquerade random,persistent,fully-random
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # udp dport 53 masquerade random,fully-random
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x14 ]
 
 # udp dport 53 masquerade random,fully-random,persistent
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # udp dport 53 masquerade persistent
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x8 ]
 
 # udp dport 53 masquerade persistent,random
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0xc ]
 
 # udp dport 53 masquerade persistent,random,fully-random
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # udp dport 53 masquerade persistent,fully-random
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x18 ]
 
 # udp dport 53 masquerade persistent,fully-random,random
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ masq flags 0x1c ]
 
 # tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
+	element 0001	element 0002	element 0003	element 0004	element 0005	element 0006	element 0007	element 0008	element 0065	element 00ca	element 012f	element 03e9	element 07d2	element 0bbb
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ masq ]
@@ -100,26 +100,26 @@ ip6 test-ip6 postrouting
 # ip6 daddr fe00::1-fe00::200 udp dport 53 counter masquerade
 ip6 test-ip6 postrouting
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ range eq reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 0x000000fe 0x00000000 0x00000000 0x00020000 ]
+  [ range eq reg 1 0xfe000000 0x00000000 0x00000000 0x00000001 0xfe000000 0x00000000 0x00000000 0x00000200 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ counter pkts 0 bytes 0 ]
   [ masq ]
 
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } masquerade
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
+	element 0016 : drop	element 00de : drop
 ip6 test-ip6 postrouting
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ masq ]
@@ -127,15 +127,14 @@ ip6 test-ip6 postrouting
 # meta l4proto 6 masquerade to :1024
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x0400 ]
   [ masq proto_min reg 1 flags 0x2 ]
 
 # meta l4proto 6 masquerade to :1024-2048
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000004 ]
-  [ immediate reg 2 0x00000008 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x0400 ]
+  [ immediate reg 2 0x0800 ]
   [ masq proto_min reg 1 proto_max reg 2 flags 0x2 ]
-
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index 6a37f1dee7edf..c36707421ba01 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -1,37 +1,37 @@
 # icmpv6 type nd-router-advert
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000086 ]
+  [ cmp eq reg 1 0x86 ]
 
 # meta l4proto ipv6-icmp icmpv6 type nd-router-advert
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
+  [ cmp eq reg 1 0x3a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000086 ]
+  [ cmp eq reg 1 0x86 ]
 
 # meta l4proto icmp icmp type echo-request
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # meta l4proto 1 icmp type echo-request
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # icmp type echo-request
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x08 ]
 
 # meta sdif "lo" accept
 ip6 test-ip6 input
@@ -42,29 +42,29 @@ ip6 test-ip6 input
 # meta sdifname != "vrf1" accept
 ip6 test-ip6 input
   [ meta load sdifname => reg 1 ]
-  [ cmp neq reg 1 0x31667276 0x00000000 0x00000000 0x00000000 ]
+  [ cmp neq reg 1 0x76726631 0x00000000 0x00000000 0x00000000 ]
   [ immediate reg 0 accept ]
 
 # meta protocol ip udp dport 67
 ip6 test-ip6 input
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00004300 ]
+  [ cmp eq reg 1 0x0043 ]
 
 # meta protocol ip6 udp dport 67
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00004300 ]
+  [ cmp eq reg 1 0x0043 ]
 
 # meta mark set ip6 dscp << 2 | 0x10
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
@@ -74,7 +74,7 @@ ip6 test-ip6 input
 # meta mark set ip6 dscp << 26 | 0x10
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0fc0 ) ^ 0x0000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 7ab9b75cedec7..1164c770077b6 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -1,263 +1,263 @@
 # mh nexthdr 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # mh nexthdr != 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # mh nexthdr != icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # mh nexthdr 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # mh nexthdr != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # mh nexthdr 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # mh nexthdr != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { 33, 55, 67, 88 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # mh hdrlength != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # mh hdrlength 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # mh hdrlength != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh hdrlength != { 33, 55, 67, 88 }
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000000  : 0 [end]	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]	element 00000008  : 0 [end]	element 00000009  : 0 [end]	element 0000000a  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]
+	element 00	element 01	element 02	element 03	element 04	element 05	element 06	element 07	element 08	element 09	element 0a	element 0b	element 0c
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh type home-agent-switch-message
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000000c ]
+  [ cmp eq reg 1 0x0c ]
 
 # mh type != home-agent-switch-message
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000000c ]
+  [ cmp neq reg 1 0x0c ]
 
 # mh reserved 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # mh reserved != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # mh reserved 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # mh reserved != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # mh reserved { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh reserved != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh checksum 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # mh checksum != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # mh checksum 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # mh checksum != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # mh checksum { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh checksum != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
index 7edde6e8a8ee6..a191fd0060a36 100644
--- a/tests/py/ip6/mh.t.payload.ip6
+++ b/tests/py/ip6/mh.t.payload.ip6
@@ -1,17 +1,17 @@
 # mh nexthdr 1
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # mh nexthdr != 1
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -19,7 +19,7 @@ ip6 test-ip6 input
 # mh nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -27,37 +27,37 @@ ip6 test-ip6 input
 # mh nexthdr icmp
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # mh nexthdr != icmp
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # mh nexthdr 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # mh nexthdr != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # mh nexthdr 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # mh nexthdr != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -65,7 +65,7 @@ ip6 test-ip6 input
 # mh nexthdr != { 33, 55, 67, 88 }
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -73,27 +73,27 @@ ip6 test-ip6 input
 # mh hdrlength 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # mh hdrlength != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # mh hdrlength 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # mh hdrlength != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -101,7 +101,7 @@ ip6 test-ip6 input
 # mh hdrlength != { 33, 55, 67, 88 }
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -109,7 +109,7 @@ ip6 test-ip6 input
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]	element 00000008  : 0 [end]	element 00000009  : 0 [end]	element 0000000a  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]
+	element 00	element 01	element 02	element 03	element 04	element 05	element 06	element 07	element 08	element 09	element 0a	element 0b	element 0c
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -117,37 +117,37 @@ ip6 test-ip6 input
 # mh type home-agent-switch-message
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000000c ]
+  [ cmp eq reg 1 0x0c ]
 
 # mh type != home-agent-switch-message
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000000c ]
+  [ cmp neq reg 1 0x0c ]
 
 # mh reserved 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # mh reserved != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # mh reserved 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # mh reserved != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # mh reserved { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -155,7 +155,7 @@ ip6 test-ip6 input
 # mh reserved != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -163,27 +163,27 @@ ip6 test-ip6 input
 # mh checksum 22
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
+  [ cmp eq reg 1 0x0016 ]
 
 # mh checksum != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
+  [ cmp neq reg 1 0x00e9 ]
 
 # mh checksum 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ range eq reg 1 0x00002100 0x00002d00 ]
+  [ range eq reg 1 0x0021 0x002d ]
 
 # mh checksum != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
+  [ range neq reg 1 0x0021 0x002d ]
 
 # mh checksum { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -191,7 +191,7 @@ ip6 test-ip6 input
 # mh checksum != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 0021	element 0037	element 0043	element 0058
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index 832c51da47a48..ac69fd5ecd00c 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -5,160 +5,160 @@ ip6 test-ip6 output
 # udp dport 954 redirect
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000ba03 ]
+  [ cmp eq reg 1 0x03ba ]
   [ redir ]
 
 # ip6 saddr fe00::cafe counter redirect
 ip6 test-ip6 output
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe 0x00000000 0x00000000 0xfeca0000 ]
+  [ cmp eq reg 1 0xfe000000 0x00000000 0x00000000 0x0000cafe ]
   [ counter pkts 0 bytes 0 ]
   [ redir ]
 
 # udp dport 53 redirect random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x4 ]
 
 # udp dport 53 redirect random,persistent
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0xc ]
 
 # udp dport 53 redirect random,persistent,fully-random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # udp dport 53 redirect random,fully-random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x14 ]
 
 # udp dport 53 redirect random,fully-random,persistent
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x8 ]
 
 # udp dport 53 redirect persistent,random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0xc ]
 
 # udp dport 53 redirect persistent,random,fully-random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent,fully-random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x18 ]
 
 # udp dport 53 redirect persistent,fully-random,random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ redir flags 0x1c ]
 
 # udp dport 1234 redirect to :1234
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000d204 ]
-  [ immediate reg 1 0x0000d204 ]
+  [ cmp eq reg 1 0x04d2 ]
+  [ immediate reg 1 0x04d2 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # ip6 daddr fe00::cafe udp dport 9998 redirect to :6515
 ip6 test-ip6 output
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe 0x00000000 0x00000000 0xfeca0000 ]
+  [ cmp eq reg 1 0xfe000000 0x00000000 0x00000000 0x0000cafe ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000e27 ]
-  [ immediate reg 1 0x00007319 ]
+  [ cmp eq reg 1 0x270e ]
+  [ immediate reg 1 0x1973 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # ip6 nexthdr tcp redirect to :100-200
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00006400 ]
-  [ immediate reg 2 0x0000c800 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x0064 ]
+  [ immediate reg 2 0x00c8 ]
   [ redir proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
 # tcp dport 39128 redirect to :993
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000d898 ]
-  [ immediate reg 1 0x0000e103 ]
+  [ cmp eq reg 1 0x98d8 ]
+  [ immediate reg 1 0x03e1 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
 # tcp dport 9128 redirect to :993 random
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000a823 ]
-  [ immediate reg 1 0x0000e103 ]
+  [ cmp eq reg 1 0x23a8 ]
+  [ immediate reg 1 0x03e1 ]
   [ redir proto_min reg 1 flags 0x6 ]
 
 # tcp dport 9128 redirect to :993 fully-random,persistent
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x0000a823 ]
-  [ immediate reg 1 0x0000e103 ]
+  [ cmp eq reg 1 0x23a8 ]
+  [ immediate reg 1 0x03e1 ]
   [ redir proto_min reg 1 flags 0x1a ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
+	element 0001	element 0002	element 0003	element 0004	element 0005	element 0006	element 0007	element 0008	element 0065	element 00ca	element 012f	element 03e9	element 07d2	element 0bbb
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ redir ]
@@ -166,26 +166,26 @@ ip6 test-ip6 output
 # ip6 daddr fe00::1-fe00::200 udp dport 53 counter redirect
 ip6 test-ip6 output
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ range eq reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 0x000000fe 0x00000000 0x00000000 0x00020000 ]
+  [ range eq reg 1 0xfe000000 0x00000000 0x00000000 0x00000001 0xfe000000 0x00000000 0x00000000 0x00000200 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
+  [ cmp eq reg 1 0x11 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003500 ]
+  [ cmp eq reg 1 0x0035 ]
   [ counter pkts 0 bytes 0 ]
   [ redir ]
 
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } redirect
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
+	element 0016 : drop	element 00de : drop
 ip6 test-ip6 output
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x65746830 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
@@ -193,11 +193,10 @@ ip6 test-ip6 output
 # redirect to :tcp dport map { 22 : 8000, 80 : 8080}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00001600  : 0000401f 0 [end]	element 00005000  : 0000901f 0 [end]
+	element 0016 : 1f40	element 0050 : 1f90
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ redir proto_min reg 1 flags 0x2 ]
-
diff --git a/tests/py/ip6/reject.t.payload.ip6 b/tests/py/ip6/reject.t.payload.ip6
index 3d4321b098c20..6b1282693a9a9 100644
--- a/tests/py/ip6/reject.t.payload.ip6
+++ b/tests/py/ip6/reject.t.payload.ip6
@@ -33,8 +33,7 @@ ip6 test-ip6 output
 # mark 0x80000000 reject with tcp reset
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ meta load mark => reg 1 ]
   [ cmp eq reg 1 0x80000000 ]
   [ reject type 1 code 0 ]
-
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index 6549ab786a438..459e38b2b32bd 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -1,240 +1,239 @@
 # rt nexthdr 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # rt nexthdr != 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # rt nexthdr != icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # rt nexthdr 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt nexthdr != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt nexthdr 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt nexthdr != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt nexthdr { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt hdrlength != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt hdrlength 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt hdrlength != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt hdrlength { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt hdrlength != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt type 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt type != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt type 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt type != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt type { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt type != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt seg-left 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt seg-left != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt seg-left 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt seg-left != 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt seg-left { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt seg-left != { 33, 55, 67, 88}
 __set%d test-inet 3
 __set%d test-inet 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
index 2b40159b749f9..8a592565c8b36 100644
--- a/tests/py/ip6/rt.t.payload.ip6
+++ b/tests/py/ip6/rt.t.payload.ip6
@@ -1,17 +1,17 @@
 # rt nexthdr 1
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # rt nexthdr != 1
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -19,7 +19,7 @@ ip6 test-ip6 input
 # rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+	element 88	element 6c	element 11	element 33	element 84	element 32	element 21	element 06	element 3a
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -27,37 +27,37 @@ ip6 test-ip6 input
 # rt nexthdr icmp
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # rt nexthdr != icmp
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
+  [ cmp neq reg 1 0x01 ]
 
 # rt nexthdr 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt nexthdr != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt nexthdr 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt nexthdr != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt nexthdr { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -65,7 +65,7 @@ ip6 test-ip6 input
 # rt nexthdr != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -73,27 +73,27 @@ ip6 test-ip6 input
 # rt hdrlength 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt hdrlength != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt hdrlength 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt hdrlength != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt hdrlength { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -101,7 +101,7 @@ ip6 test-ip6 input
 # rt hdrlength != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -109,27 +109,27 @@ ip6 test-ip6 input
 # rt type 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt type != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt type 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt type != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt type { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -137,7 +137,7 @@ ip6 test-ip6 input
 # rt type != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -145,27 +145,27 @@ ip6 test-ip6 input
 # rt seg-left 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x16 ]
 
 # rt seg-left != 233
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0xe9 ]
 
 # rt seg-left 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ range eq reg 1 0x00000021 0x0000002d ]
+  [ range eq reg 1 0x21 0x2d ]
 
 # rt seg-left != 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ range neq reg 1 0x00000021 0x0000002d ]
+  [ range neq reg 1 0x21 0x2d ]
 
 # rt seg-left { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -173,8 +173,7 @@ ip6 test-ip6 input
 # rt seg-left != { 33, 55, 67, 88}
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 21	element 37	element 43	element 58
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip6/rt0.t.payload b/tests/py/ip6/rt0.t.payload
index 464b7f212fc5c..7b4d6d7b48e96 100644
--- a/tests/py/ip6/rt0.t.payload
+++ b/tests/py/ip6/rt0.t.payload
@@ -1,5 +1,4 @@
 # rt nexthop fd00::1
 ip6 test-ip6 output
   [ rt load nexthop6 => reg 1 ]
-  [ cmp eq reg 1 0x000000fd 0x00000000 0x00000000 0x01000000 ]
-
+  [ cmp eq reg 1 0xfd000000 0x00000000 0x00000000 0x00000001 ]
diff --git a/tests/py/ip6/sets.t.payload.inet b/tests/py/ip6/sets.t.payload.inet
index 2dbb818a8aa1b..f694209f23b5b 100644
--- a/tests/py/ip6/sets.t.payload.inet
+++ b/tests/py/ip6/sets.t.payload.inet
@@ -1,7 +1,7 @@
 # ip6 saddr @set2 drop
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
@@ -9,7 +9,7 @@ inet test-inet input
 # ip6 saddr != @set2 drop
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 drop ]
@@ -17,7 +17,7 @@ inet test-inet input
 # ip6 saddr . ip6 daddr @set5 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ lookup reg 1 set set5 ]
@@ -26,7 +26,7 @@ inet test-inet input
 # add @set5 { ip6 saddr . ip6 daddr }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset add reg_key 1 set set5 ]
@@ -34,7 +34,7 @@ inet test-inet input
 # add @map1 { ip6 saddr . ip6 daddr : meta mark }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ meta load mark => reg 3 ]
@@ -43,7 +43,7 @@ inet test-inet input
 # delete @set5 { ip6 saddr . ip6 daddr }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset delete reg_key 1 set set5 ]
@@ -51,10 +51,10 @@ inet test-inet input
 # add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ payload load 2b @ transport header + 2 => reg 3 ]
-  [ immediate reg 17 0x00003412 0x00000000 0x00000000 0x01000000 ]
-  [ immediate reg 21 0x00005000 ]
+  [ immediate reg 17 0x12340000 0x00000000 0x00000000 0x00000001 ]
+  [ immediate reg 21 0x0050 ]
   [ dynset add reg_key 1 set map2 sreg_data 17 ]
diff --git a/tests/py/ip6/sets.t.payload.ip6 b/tests/py/ip6/sets.t.payload.ip6
index 7234b989a57db..8b7379a252fdc 100644
--- a/tests/py/ip6/sets.t.payload.ip6
+++ b/tests/py/ip6/sets.t.payload.ip6
@@ -41,6 +41,6 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ payload load 2b @ transport header + 2 => reg 3 ]
-  [ immediate reg 17 0x00003412 0x00000000 0x00000000 0x01000000 ]
-  [ immediate reg 21 0x00005000 ]
+  [ immediate reg 17 0x12340000 0x00000000 0x00000000 0x00000001 ]
+  [ immediate reg 21 0x0050 ]
   [ dynset add reg_key 1 set map2 sreg_data 17 ]
diff --git a/tests/py/ip6/sets.t.payload.netdev b/tests/py/ip6/sets.t.payload.netdev
index 2ad0f434b3dc2..2441a44c8ca01 100644
--- a/tests/py/ip6/sets.t.payload.netdev
+++ b/tests/py/ip6/sets.t.payload.netdev
@@ -1,7 +1,7 @@
 # ip6 saddr @set2 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
@@ -9,7 +9,7 @@ netdev test-netdev ingress
 # ip6 saddr != @set2 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 drop ]
@@ -17,7 +17,7 @@ netdev test-netdev ingress
 # ip6 saddr . ip6 daddr @set5 drop
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ lookup reg 1 set set5 ]
@@ -26,7 +26,7 @@ netdev test-netdev ingress
 # add @set5 { ip6 saddr . ip6 daddr }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset add reg_key 1 set set5 ]
@@ -34,7 +34,7 @@ netdev test-netdev ingress
 # delete @set5 { ip6 saddr . ip6 daddr }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset delete reg_key 1 set set5 ]
@@ -42,7 +42,7 @@ netdev test-netdev ingress
 # add @map1 { ip6 saddr . ip6 daddr : meta mark }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ meta load mark => reg 3 ]
@@ -51,10 +51,10 @@ netdev test-netdev ingress
 # add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ payload load 2b @ transport header + 2 => reg 3 ]
-  [ immediate reg 17 0x00003412 0x00000000 0x00000000 0x01000000 ]
-  [ immediate reg 21 0x00005000 ]
+  [ immediate reg 17 0x12340000 0x00000000 0x00000000 0x00000001 ]
+  [ immediate reg 21 0x0050 ]
   [ dynset add reg_key 1 set map2 sreg_data 17 ]
diff --git a/tests/py/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
index 96a9ba0a3111d..01abb1ca3e677 100644
--- a/tests/py/ip6/snat.t.payload.ip6
+++ b/tests/py/ip6/snat.t.payload.ip6
@@ -1,23 +1,22 @@
 # tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
-  [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
-  [ immediate reg 3 0x00005000 ]
-  [ immediate reg 4 0x00006400 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0x20010838 0x035f0001 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x20010838 0x035f0002 0x00000000 0x00000000 ]
+  [ immediate reg 3 0x0050 ]
+  [ immediate reg 4 0x0064 ]
   [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 flags 0x2 ]
 
 # tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range eq reg 1 0x00005000 0x00005a00 ]
-  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
-  [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
-  [ immediate reg 3 0x00006400 ]
+  [ range eq reg 1 0x0050 0x005a ]
+  [ immediate reg 1 0x20010838 0x035f0001 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x20010838 0x035f0002 0x00000000 0x00000000 ]
+  [ immediate reg 3 0x0064 ]
   [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 flags 0x2 ]
-
diff --git a/tests/py/ip6/srh.t.payload b/tests/py/ip6/srh.t.payload
index 364940a95ee63..5c3031f3bdd23 100644
--- a/tests/py/ip6/srh.t.payload
+++ b/tests/py/ip6/srh.t.payload
@@ -1,17 +1,17 @@
 # srh last-entry 0
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # srh last-entry 127
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x0000007f ]
+  [ cmp eq reg 1 0x7f ]
 
 # srh last-entry { 0, 4-127, 255 }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
+	element 00	element 01 flags 1	element 04	element 80 flags 1	element ff  userdata = { \x01\x04\x00\x00\x00\x01 }
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -19,17 +19,17 @@ ip6 test-ip6 input
 # srh flags 0
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # srh flags 127
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
-  [ cmp eq reg 1 0x0000007f ]
+  [ cmp eq reg 1 0x7f ]
 
 # srh flags { 0, 4-127, 255 }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
+	element 00	element 01 flags 1	element 04	element 80 flags 1	element ff  userdata = { \x01\x04\x00\x00\x00\x01 }
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -37,17 +37,17 @@ ip6 test-ip6 input
 # srh tag 0
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x0000 ]
 
 # srh tag 127
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00007f00 ]
+  [ cmp eq reg 1 0x007f ]
 
 # srh tag { 0, 4-127, 0xffff }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000100  : 1 [end]	element 00000400  : 0 [end]	element 00008000  : 1 [end]	element 0000ffff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
+	element 0000	element 0001 flags 1	element 0004	element 0080 flags 1	element ffff  userdata = { \x01\x04\x00\x00\x00\x01 }
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -55,10 +55,9 @@ ip6 test-ip6 input
 # srh sid[1] dead::beef
 ip6 test-ip6 input
   [ exthdr load ipv6 16b @ 43 + 8 => reg 1 ]
-  [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
+  [ cmp eq reg 1 0xdead0000 0x00000000 0x00000000 0x0000beef ]
 
 # srh sid[2] dead::beef
 ip6 test-ip6 input
   [ exthdr load ipv6 16b @ 43 + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
-
+  [ cmp eq reg 1 0xdead0000 0x00000000 0x00000000 0x0000beef ]
diff --git a/tests/py/ip6/tproxy.t.payload b/tests/py/ip6/tproxy.t.payload
index 9f28e80b4142c..109b697ff9ff3 100644
--- a/tests/py/ip6/tproxy.t.payload
+++ b/tests/py/ip6/tproxy.t.payload
@@ -1,44 +1,43 @@
 # meta l4proto 6 tproxy to [2001:db8::1]
 ip6 x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0xb80d0120 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x20010db8 0x00000000 0x00000000 0x00000001 ]
   [ tproxy ip6 addr reg 1 ]
 
 # meta l4proto 17 tproxy to [2001:db8::1]:50080
 ip6 x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0xb80d0120 0x00000000 0x00000000 0x01000000 ]
-  [ immediate reg 2 0x0000a0c3 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0x20010db8 0x00000000 0x00000000 0x00000001 ]
+  [ immediate reg 2 0xc3a0 ]
   [ tproxy ip6 addr reg 1 port reg 2 ]
 
 # meta l4proto 6 tproxy to :50080
 ip6 x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x0000a0c3 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0xc3a0 ]
   [ tproxy ip6 port reg 1 ]
 
 # meta l4proto 6 tproxy ip6 to [2001:db8::1]
 ip6 x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0xb80d0120 0x00000000 0x00000000 0x01000000 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0x20010db8 0x00000000 0x00000000 0x00000001 ]
   [ tproxy ip6 addr reg 1 ]
 
 # meta l4proto 17 tproxy ip6 to [2001:db8::1]:50080
 ip6 x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0xb80d0120 0x00000000 0x00000000 0x01000000 ]
-  [ immediate reg 2 0x0000a0c3 ]
+  [ cmp eq reg 1 0x11 ]
+  [ immediate reg 1 0x20010db8 0x00000000 0x00000000 0x00000001 ]
+  [ immediate reg 2 0xc3a0 ]
   [ tproxy ip6 addr reg 1 port reg 2 ]
 
 # meta l4proto 6 tproxy ip6 to :50080
 ip6 x y 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x0000a0c3 ]
+  [ cmp eq reg 1 0x06 ]
+  [ immediate reg 1 0xc3a0 ]
   [ tproxy ip6 port reg 1 ]
-
diff --git a/tests/py/ip6/vmap.t.payload.inet b/tests/py/ip6/vmap.t.payload.inet
index 26bca5e26f279..4ac4797cb4db1 100644
--- a/tests/py/ip6/vmap.t.payload.inet
+++ b/tests/py/ip6/vmap.t.payload.inet
@@ -1,420 +1,419 @@
 # ip6 saddr vmap { abcd::3 : accept }
 __map%d test-inet b
 __map%d test-inet 0
-	element 0000cdab 00000000 00000000 03000000  : accept 0 [end]
+	element abcd0000 00000000 00000000 00000003 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 34123412  : accept 0 [end]
+	element 12341234 12341234 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34120000 34123412 34123412 34123412  : accept 0 [end]
+	element 00001234 12341234 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 34123412 34123412 34123412  : accept 0 [end]
+	element 12340000 12341234 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34120000 34123412 34123412  : accept 0 [end]
+	element 12341234 00001234 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 34123412 34123412  : accept 0 [end]
+	element 12341234 12340000 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34120000 34123412  : accept 0 [end]
+	element 12341234 12341234 00001234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00003412 34123412  : accept 0 [end]
+	element 12341234 12341234 12340000 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 34120000  : accept 0 [end]
+	element 12341234 12341234 12341234 00001234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 00003412  : accept 0 [end]
+	element 12341234 12341234 12341234 12340000 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 34123412 34123412 34123412  : accept 0 [end]
+	element 00000000 12341234 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 34120000 34123412 34123412  : accept 0 [end]
+	element 12340000 00001234 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 34123412 34123412  : accept 0 [end]
+	element 12341234 00000000 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 34120000 34123412  : accept 0 [end]
+	element 12341234 12340000 00001234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00000000 34123412  : accept 0 [end]
+	element 12341234 12341234 00000000 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00003412 34120000  : accept 0 [end]
+	element 12341234 12341234 12340000 00001234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 00000000  : accept 0 [end]
+	element 12341234 12341234 12341234 00000000 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 34120000 34123412 34123412  : accept 0 [end]
+	element 00000000 00001234 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 34123412 34123412  : accept 0 [end]
+	element 12340000 00000000 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 34120000 34123412  : accept 0 [end]
+	element 12341234 00000000 00001234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 00000000 34123412  : accept 0 [end]
+	element 12341234 12340000 00000000 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00000000 34120000  : accept 0 [end]
+	element 12341234 12341234 00000000 00001234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00003412 00000000  : accept 0 [end]
+	element 12341234 12341234 12340000 00000000 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 34123412 34123412  : accept 0 [end]
+	element 00000000 00000000 12341234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 34120000 34123412  : accept 0 [end]
+	element 12340000 00000000 00001234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 00000000 34123412  : accept 0 [end]
+	element 12341234 00000000 00000000 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 00000000 34120000  : accept 0 [end]
+	element 12341234 12340000 00000000 00001234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00000000 00000000  : accept 0 [end]
+	element 12341234 12341234 00000000 00000000 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 34120000 34123412  : accept 0 [end]
+	element 00000000 00000000 00001234 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 00000000 34123412  : accept 0 [end]
+	element 12340000 00000000 00000000 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 00000000 34120000  : accept 0 [end]
+	element 12341234 00000000 00000000 00001234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 00000000 00000000  : accept 0 [end]
+	element 12341234 12340000 00000000 00000000 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 00000000 34123412  : accept 0 [end]
+	element 00000000 00000000 00000000 12341234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 00000000 34120000  : accept 0 [end]
+	element 12340000 00000000 00000000 00001234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 00000000 00000000  : accept 0 [end]
+	element 12341234 00000000 00000000 00000000 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 00000000 34120000  : accept 0 [end]
+	element 00000000 00000000 00000000 00001234 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 00000000 00000000  : accept 0 [end]
+	element 12340000 00000000 00000000 00000000 : accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-inet f
 __map%d test-inet 0
-	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
+	element 00000000 00000000 00000000 00000000 : accept	element 00000000 00000001 00000000 00000000 flags 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 aaaa0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000aaaa : drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 bbbb0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000bbbb : drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 cccc0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000cccc : drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 dddd0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000dddd : drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
-
diff --git a/tests/py/ip6/vmap.t.payload.ip6 b/tests/py/ip6/vmap.t.payload.ip6
index 2aaa0e48f4b10..2f950e2693457 100644
--- a/tests/py/ip6/vmap.t.payload.ip6
+++ b/tests/py/ip6/vmap.t.payload.ip6
@@ -1,7 +1,7 @@
 # ip6 saddr vmap { abcd::3 : accept }
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 0000cdab 00000000 00000000 03000000  : accept 0 [end]
+	element abcd0000 00000000 00000000 00000003 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -9,7 +9,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 34123412  : accept 0 [end]
+	element 12341234 12341234 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -17,7 +17,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34120000 34123412 34123412 34123412  : accept 0 [end]
+	element 00001234 12341234 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -25,7 +25,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 34123412 34123412 34123412  : accept 0 [end]
+	element 12340000 12341234 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -33,7 +33,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34120000 34123412 34123412  : accept 0 [end]
+	element 12341234 00001234 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -41,7 +41,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 34123412 34123412  : accept 0 [end]
+	element 12341234 12340000 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -49,7 +49,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34120000 34123412  : accept 0 [end]
+	element 12341234 12341234 00001234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -57,7 +57,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00003412 34123412  : accept 0 [end]
+	element 12341234 12341234 12340000 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -65,7 +65,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 34120000  : accept 0 [end]
+	element 12341234 12341234 12341234 00001234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -73,7 +73,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 00003412  : accept 0 [end]
+	element 12341234 12341234 12341234 12340000 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -81,7 +81,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 34123412 34123412 34123412  : accept 0 [end]
+	element 00000000 12341234 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -89,7 +89,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 34120000 34123412 34123412  : accept 0 [end]
+	element 12340000 00001234 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -97,7 +97,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 34123412 34123412  : accept 0 [end]
+	element 12341234 00000000 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -105,7 +105,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 34120000 34123412  : accept 0 [end]
+	element 12341234 12340000 00001234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -113,7 +113,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00000000 34123412  : accept 0 [end]
+	element 12341234 12341234 00000000 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -121,7 +121,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00003412 34120000  : accept 0 [end]
+	element 12341234 12341234 12340000 00001234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -129,7 +129,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 00000000  : accept 0 [end]
+	element 12341234 12341234 12341234 00000000 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -137,7 +137,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 34120000 34123412 34123412  : accept 0 [end]
+	element 00000000 00001234 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -145,7 +145,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 34123412 34123412  : accept 0 [end]
+	element 12340000 00000000 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -153,7 +153,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 34120000 34123412  : accept 0 [end]
+	element 12341234 00000000 00001234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -161,7 +161,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 00000000 34123412  : accept 0 [end]
+	element 12341234 12340000 00000000 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -169,7 +169,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00000000 34120000  : accept 0 [end]
+	element 12341234 12341234 00000000 00001234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -177,7 +177,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00003412 00000000  : accept 0 [end]
+	element 12341234 12341234 12340000 00000000 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -185,7 +185,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 34123412 34123412  : accept 0 [end]
+	element 00000000 00000000 12341234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -193,7 +193,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 34120000 34123412  : accept 0 [end]
+	element 12340000 00000000 00001234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -201,7 +201,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 00000000 34123412  : accept 0 [end]
+	element 12341234 00000000 00000000 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -209,7 +209,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 00000000 34120000  : accept 0 [end]
+	element 12341234 12340000 00000000 00001234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -217,7 +217,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00000000 00000000  : accept 0 [end]
+	element 12341234 12341234 00000000 00000000 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -225,7 +225,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 34120000 34123412  : accept 0 [end]
+	element 00000000 00000000 00001234 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -233,7 +233,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 00000000 34123412  : accept 0 [end]
+	element 12340000 00000000 00000000 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -241,7 +241,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 00000000 34120000  : accept 0 [end]
+	element 12341234 00000000 00000000 00001234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -249,7 +249,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 00000000 00000000  : accept 0 [end]
+	element 12341234 12340000 00000000 00000000 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -257,7 +257,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 34123412  : accept 0 [end]
+	element 00000000 00000000 00000000 12341234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -265,7 +265,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 00000000 34120000  : accept 0 [end]
+	element 12340000 00000000 00000000 00001234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -273,7 +273,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 00000000 00000000  : accept 0 [end]
+	element 12341234 00000000 00000000 00000000 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -281,7 +281,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 34120000  : accept 0 [end]
+	element 00000000 00000000 00000000 00001234 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -289,7 +289,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 00000000 00000000  : accept 0 [end]
+	element 12340000 00000000 00000000 00000000 : accept
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -297,7 +297,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-ip6 f
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
+	element 00000000 00000000 00000000 00000000 : accept	element 00000000 00000001 00000000 00000000 flags 1
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -305,7 +305,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 aaaa0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000aaaa : drop
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -313,7 +313,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 bbbb0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000bbbb : drop
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -321,7 +321,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 cccc0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000cccc : drop
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -329,8 +329,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 dddd0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000dddd : drop
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
-
diff --git a/tests/py/ip6/vmap.t.payload.netdev b/tests/py/ip6/vmap.t.payload.netdev
index 4d81309b9e6eb..ad3de5343af02 100644
--- a/tests/py/ip6/vmap.t.payload.netdev
+++ b/tests/py/ip6/vmap.t.payload.netdev
@@ -1,420 +1,419 @@
 # ip6 saddr vmap { abcd::3 : accept }
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 0000cdab 00000000 00000000 03000000  : accept 0 [end]
+	element abcd0000 00000000 00000000 00000003 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 34123412  : accept 0 [end]
+	element 12341234 12341234 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34120000 34123412 34123412 34123412  : accept 0 [end]
+	element 00001234 12341234 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 34123412 34123412 34123412  : accept 0 [end]
+	element 12340000 12341234 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34120000 34123412 34123412  : accept 0 [end]
+	element 12341234 00001234 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 34123412 34123412  : accept 0 [end]
+	element 12341234 12340000 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34120000 34123412  : accept 0 [end]
+	element 12341234 12341234 00001234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00003412 34123412  : accept 0 [end]
+	element 12341234 12341234 12340000 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 34120000  : accept 0 [end]
+	element 12341234 12341234 12341234 00001234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 00003412  : accept 0 [end]
+	element 12341234 12341234 12341234 12340000 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 34123412 34123412 34123412  : accept 0 [end]
+	element 00000000 12341234 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 34120000 34123412 34123412  : accept 0 [end]
+	element 12340000 00001234 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 34123412 34123412  : accept 0 [end]
+	element 12341234 00000000 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 34120000 34123412  : accept 0 [end]
+	element 12341234 12340000 00001234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00000000 34123412  : accept 0 [end]
+	element 12341234 12341234 00000000 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00003412 34120000  : accept 0 [end]
+	element 12341234 12341234 12340000 00001234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 00000000  : accept 0 [end]
+	element 12341234 12341234 12341234 00000000 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 34120000 34123412 34123412  : accept 0 [end]
+	element 00000000 00001234 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 34123412 34123412  : accept 0 [end]
+	element 12340000 00000000 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 34120000 34123412  : accept 0 [end]
+	element 12341234 00000000 00001234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 00000000 34123412  : accept 0 [end]
+	element 12341234 12340000 00000000 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00000000 34120000  : accept 0 [end]
+	element 12341234 12341234 00000000 00001234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00003412 00000000  : accept 0 [end]
+	element 12341234 12341234 12340000 00000000 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 34123412 34123412  : accept 0 [end]
+	element 00000000 00000000 12341234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 34120000 34123412  : accept 0 [end]
+	element 12340000 00000000 00001234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 00000000 34123412  : accept 0 [end]
+	element 12341234 00000000 00000000 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 00000000 34120000  : accept 0 [end]
+	element 12341234 12340000 00000000 00001234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00000000 00000000  : accept 0 [end]
+	element 12341234 12341234 00000000 00000000 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 34120000 34123412  : accept 0 [end]
+	element 00000000 00000000 00001234 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 00000000 34123412  : accept 0 [end]
+	element 12340000 00000000 00000000 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 00000000 34120000  : accept 0 [end]
+	element 12341234 00000000 00000000 00001234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 00000000 00000000  : accept 0 [end]
+	element 12341234 12340000 00000000 00000000 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 00000000 34123412  : accept 0 [end]
+	element 00000000 00000000 00000000 12341234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 00000000 34120000  : accept 0 [end]
+	element 12340000 00000000 00000000 00001234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 00000000 00000000  : accept 0 [end]
+	element 12341234 00000000 00000000 00000000 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 00000000 34120000  : accept 0 [end]
+	element 00000000 00000000 00000000 00001234 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 00000000 00000000  : accept 0 [end]
+	element 12340000 00000000 00000000 00000000 : accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-netdev f
 __map%d test-netdev 0
-	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
+	element 00000000 00000000 00000000 00000000 : accept	element 00000000 00000001 00000000 00000000 flags 1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 aaaa0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000aaaa : drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 bbbb0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000bbbb : drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 cccc0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000cccc : drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 dddd0000  : drop 0 [end]
+	element 12341234 12341234 12341234 aaaa0000 : accept	element 00000000 00000000 00000000 0000dddd : drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
-
diff --git a/tests/py/netdev/dup.t.payload b/tests/py/netdev/dup.t.payload
index 51ff782c0525f..971dd1bbf5c5d 100644
--- a/tests/py/netdev/dup.t.payload
+++ b/tests/py/netdev/dup.t.payload
@@ -6,9 +6,8 @@ netdev test-netdev ingress
 # dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
+	element 00000001 : 00000001	element 00000002 : 00000001
 netdev test-netdev ingress 
   [ meta load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ dup sreg_dev 1 ]
-
diff --git a/tests/py/netdev/fwd.t.payload b/tests/py/netdev/fwd.t.payload
index f03077a60e2d1..3453c38f1a5f8 100644
--- a/tests/py/netdev/fwd.t.payload
+++ b/tests/py/netdev/fwd.t.payload
@@ -6,7 +6,7 @@ netdev test-netdev ingress
 # fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
+	element 00000001 : 00000001	element 00000002 : 00000001
 netdev test-netdev ingress 
   [ meta load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
@@ -15,6 +15,5 @@ netdev test-netdev ingress
 # fwd ip to 192.168.2.200 device "lo"
 netdev test-netdev ingress 
   [ immediate reg 1 0x00000001 ]
-  [ immediate reg 2 0xc802a8c0 ]
+  [ immediate reg 2 0xc0a802c8 ]
   [ fwd sreg_dev 1 sreg_addr 2 nfproto 2 ]
-
diff --git a/tests/py/netdev/reject.t.payload b/tests/py/netdev/reject.t.payload
index d014adab0d52b..42c4d2bf651a9 100644
--- a/tests/py/netdev/reject.t.payload
+++ b/tests/py/netdev/reject.t.payload
@@ -1,85 +1,85 @@
 # reject with icmp host-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 1 ]
 
 # reject with icmp net-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 0 ]
 
 # reject with icmp prot-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 2 ]
 
 # reject with icmp port-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 3 ]
 
 # reject with icmp net-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 9 ]
 
 # reject with icmp host-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 10 ]
 
 # reject with icmp admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 13 ]
 
 # reject with icmpv6 no-route
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 0 ]
 
 # reject with icmpv6 admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 1 ]
 
 # reject with icmpv6 addr-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 3 ]
 
 # reject with icmpv6 port-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 4 ]
 
 # reject with icmpv6 policy-fail
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 5 ]
 
 # reject with icmpv6 reject-route
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 6 ]
 
 # mark 12345 reject with tcp reset
 netdev 
   [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ meta load mark => reg 1 ]
   [ cmp eq reg 1 0x00003039 ]
   [ reject type 1 code 0 ]
@@ -91,13 +91,13 @@ netdev
 # meta protocol ip reject
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 3 ]
 
 # meta protocol ip6 reject
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 4 ]
 
 # reject with icmpx host-unreachable
@@ -119,24 +119,23 @@ netdev
 # meta protocol ip reject with icmp host-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 0 code 1 ]
 
 # meta protocol ip6 reject with icmpv6 no-route
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 0 code 0 ]
 
 # meta protocol ip reject with icmpx admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
+  [ cmp eq reg 1 0x0800 ]
   [ reject type 2 code 3 ]
 
 # meta protocol ip6 reject with icmpx admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
+  [ cmp eq reg 1 0x86dd ]
   [ reject type 2 code 3 ]
-
diff --git a/tests/py/netdev/tunnel.t.payload b/tests/py/netdev/tunnel.t.payload
index 9148d0e5b6cb0..8692c92c5e5c0 100644
--- a/tests/py/netdev/tunnel.t.payload
+++ b/tests/py/netdev/tunnel.t.payload
@@ -1,15 +1,14 @@
 # tunnel path exists
 netdev test-netdev tunnelchain
   [ tunnel load path => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
+  [ cmp eq reg 1 0x01 ]
 
 # tunnel path missing
 netdev test-netdev tunnelchain
   [ tunnel load path => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
+  [ cmp eq reg 1 0x00 ]
 
 # tunnel id 10
 netdev test-netdev tunnelchain
   [ tunnel load id => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-
-- 
2.51.0

