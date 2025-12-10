Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D87329C55
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2025 21:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765403404; cv=none; b=NAZwHBKbDlM1ZP3ZzWX8FUUeRUjVd+2CDRbwXV4sWZgLZAkZCCj93b3CLz704u3DOiO+GsjAYN0ss0uPvZndl6s/sjyFH1XxizBJjee0tBIqqiM/DHmbFp5n5R/di2o+DP86hLxcY7mivyZQoQC9nGKC/NIoc/MYwy8G+6cK3l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765403404; c=relaxed/simple;
	bh=RHAX6Ie/GLYhxXmA497Txc8qAzEHl280ZTe/9XP99Es=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tE4ITz0iQLs/IVDVPJEzUoE0WXnxkAbtGr1BXDbOFlHW7YfoaEeyzn9EH+X8lrng7mQxTt3TgSrG5+vUahjeYB92f/cH4sY5Jck85XwT7njO1C8Yf68j5SgMMarJKnnqUXg1d72uGHZZbyt1S1jYMP6Ukqze05gvqqtuOKbGdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DHkeKPbT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DHkeKPbT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Qsy4WU3LZuOjwNt4RIPnEUGyQ/9/5brOP0Ynk17bW6w=; b=DHkeKPbTTkSkwwlwo8V31N50nW
	Ar00OsyjAFQmrQPVTRHswnKSZ6DPuE6VpTjik+/WUpNuJipI9//DDgDcdMW5YIFWVuz4i6L3/AKLb
	jK6h8SvCx3ckaVFgZUrByA8nmp2oLUQ942H+XpA89J361w5cbFjHg/dbXVCX+euQ9hZ5moGi/0hu5
	jypc/gWFFEw3sdrjacbFidk5rddxq/9pDS4SRREZN+Fmblt4x/XU+FL9mCCmiH6iElePDUqyVO2i+
	EahKl8/JWBAtRQkjgroikpYEUW3Ztn0yf+haFcqDrOB5Z5K5RnJgE0HnmXz3inyWR+o/fnI9AJTuC
	n/bvHSWQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vTS4F-000000002sa-0ojZ;
	Wed, 10 Dec 2025 22:49:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH] datatype: Accept IPv4 addresses for ip6addr_type
Date: Wed, 10 Dec 2025 22:49:45 +0100
Message-ID: <20251210214945.31389-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complement on-demand ip {s,d}addr expression conversion to IPv4-mapped
IPv6 by accepting IPv4 addresses in places where an IPv6 one is
expected. This way users don't have to use IPv4-mapped notation when
populating sets.

In order to avoid chaos and breakage, prevent host names (temporarily)
resolving to IPv4 addresses only from being accepted as IPv6 address.
Map IPv4 addresses only if users explicitly specified them.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/datatype.c                      | 10 +++-
 tests/py/inet/dnat.t                |  6 +--
 tests/py/inet/dnat.t.json           | 72 +++++++++++++++++++++++++++++
 tests/py/inet/dnat.t.payload        | 24 ++++++++++
 tests/py/inet/sets.t                |  2 +-
 tests/py/inet/sets.t.json           | 19 ++++++++
 tests/py/inet/sets.t.payload.bridge |  9 ++++
 tests/py/inet/sets.t.payload.inet   |  9 ++++
 tests/py/inet/sets.t.payload.netdev |  9 ++++
 tests/py/inet/snat.t                |  2 +-
 tests/py/inet/snat.t.json           |  9 ++++
 tests/py/inet/snat.t.json.output    |  9 ++++
 tests/py/inet/snat.t.payload        |  5 ++
 tests/py/ip/ip.t                    |  2 +-
 tests/py/ip6/ip6.t                  |  2 +
 tests/py/ip6/ip6.t.json             | 16 +++++++
 tests/py/ip6/ip6.t.json.output      | 15 ++++++
 tests/py/ip6/ip6.t.payload.inet     |  7 +++
 tests/py/ip6/ip6.t.payload.ip6      |  5 ++
 tests/py/ip6/rt0.t                  |  2 +-
 tests/py/ip6/rt0.t.json             | 15 ++++++
 tests/py/ip6/rt0.t.payload          |  5 ++
 tests/py/ip6/sets.t                 |  4 +-
 23 files changed, 248 insertions(+), 10 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index fac4eb9cdcecd..613ad4582022b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -701,10 +701,18 @@ static struct error_record *ip6addr_type_parse(struct parse_ctx *ctx,
 			return error(&sym->location, "Invalid IPv6 address");
 	} else {
 		struct addrinfo *ai, hints = { .ai_family = AF_INET6,
-					       .ai_socktype = SOCK_DGRAM};
+					       .ai_socktype = SOCK_DGRAM,
+					       .ai_flags = AI_V4MAPPED |
+							   AI_NUMERICHOST};
 		int err;
 
+		/* first try: regular IPv6 addresses or IPv4-mapped */
 		err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
+		if (err != 0) {
+			/* second try: hostnames, but ignore A records */
+			hints.ai_flags = 0;
+			err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
+		}
 		if (err != 0)
 			return error(&sym->location, "Could not resolve hostname: %s",
 				     gai_strerror(err));
diff --git a/tests/py/inet/dnat.t b/tests/py/inet/dnat.t
index e4e169f2bc3ec..e4a332598fe55 100644
--- a/tests/py/inet/dnat.t
+++ b/tests/py/inet/dnat.t
@@ -11,10 +11,10 @@ meta l4proto tcp dnat to :80;ok;meta l4proto 6 dnat to :80
 dnat ip to ct mark map { 0x00000014 : 1.2.3.4};ok
 dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
 
-dnat ip6 to 1.2.3.4;fail
+dnat ip6 to 1.2.3.4;ok;dnat ip6 to ::ffff:1.2.3.4
 dnat to 1.2.3.4;fail
-dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};fail
-ip6 daddr dead::beef dnat to 10.1.2.3;fail
+dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok;dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : ::ffff:1.2.3.4}
+ip6 daddr dead::beef dnat to 10.1.2.3;ok;ip6 daddr dead::beef dnat ip6 to ::ffff:10.1.2.3
 
 meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80;ok;meta l4proto { 6, 17} dnat ip to 1.1.1.1:80
 ip protocol { tcp, udp } dnat ip to 1.1.1.1:80;ok;ip protocol { 6, 17} dnat ip to 1.1.1.1:80
diff --git a/tests/py/inet/dnat.t.json b/tests/py/inet/dnat.t.json
index c341a0455fea1..18b81d3fa2479 100644
--- a/tests/py/inet/dnat.t.json
+++ b/tests/py/inet/dnat.t.json
@@ -164,6 +164,78 @@
     }
 ]
 
+# dnat ip6 to 1.2.3.4
+[
+    {
+        "dnat": {
+            "addr": "1.2.3.4",
+            "family": "ip6"
+        }
+    }
+]
+
+# dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
+[
+    {
+        "dnat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        20,
+                                        "1.1.1.1"
+                                    ]
+                                },
+                                "1.2.3.4"
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "daddr",
+                                    "protocol": "ip"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip6"
+        }
+    }
+]
+
+# ip6 daddr dead::beef dnat to 10.1.2.3
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip6"
+                }
+            },
+            "op": "==",
+            "right": "dead::beef"
+        }
+    },
+    {
+        "dnat": {
+            "addr": "10.1.2.3"
+        }
+    }
+]
+
 # meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80
 [
     {
diff --git a/tests/py/inet/dnat.t.payload b/tests/py/inet/dnat.t.payload
index ce1601ab5c9e8..30e4c5d2a317e 100644
--- a/tests/py/inet/dnat.t.payload
+++ b/tests/py/inet/dnat.t.payload
@@ -53,6 +53,30 @@ inet test-inet prerouting
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 ]
 
+# dnat ip6 to 1.2.3.4
+inet test-inet prerouting
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 0x04030201 ]
+  [ nat dnat ip6 addr_min reg 1 ]
+
+# dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
+	element 00000014 01010101  : 00000000 00000000 ffff0000 04030201 0 [end]
+inet test-inet prerouting
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ ct load mark => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip6 addr_min reg 1 ]
+
+# ip6 daddr dead::beef dnat to 10.1.2.3
+inet test-inet prerouting
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 24 => reg 1 ]
+  [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 0x0302010a ]
+  [ nat dnat ip6 addr_min reg 1 ]
+
 # meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80
 __set%d test-inet 3
 __set%d test-inet 0
diff --git a/tests/py/inet/sets.t b/tests/py/inet/sets.t
index 5b22e1fea80da..1eb0aa8e3dad5 100644
--- a/tests/py/inet/sets.t
+++ b/tests/py/inet/sets.t
@@ -13,7 +13,7 @@
 ?set2 dead::beef timeout 5s;ok
 
 ip saddr @set1 drop;ok
-ip saddr != @set2 drop;fail
+ip saddr != @set2 drop;ok
 
 ip6 daddr != @set2 accept;ok
 ip6 daddr @set1 drop;fail
diff --git a/tests/py/inet/sets.t.json b/tests/py/inet/sets.t.json
index b44ffc20d70d6..a631a7eb7e948 100644
--- a/tests/py/inet/sets.t.json
+++ b/tests/py/inet/sets.t.json
@@ -17,6 +17,25 @@
     }
 ]
 
+# ip saddr != @set2 drop
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "!=",
+            "right": "@set2"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
 # ip6 daddr != @set2 accept
 [
     {
diff --git a/tests/py/inet/sets.t.payload.bridge b/tests/py/inet/sets.t.payload.bridge
index 3dd9d57bc0ce8..ace007e8666a2 100644
--- a/tests/py/inet/sets.t.payload.bridge
+++ b/tests/py/inet/sets.t.payload.bridge
@@ -6,6 +6,15 @@ bridge test-inet input
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set2 drop
+bridge test-inet input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
 # ip6 daddr != @set2 accept
 bridge test-inet input
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/inet/sets.t.payload.inet b/tests/py/inet/sets.t.payload.inet
index 53c6b1821af7c..8a214298712ae 100644
--- a/tests/py/inet/sets.t.payload.inet
+++ b/tests/py/inet/sets.t.payload.inet
@@ -6,6 +6,15 @@ inet test-inet input
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set2 drop
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
 # ip6 daddr != @set2 accept
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/inet/sets.t.payload.netdev b/tests/py/inet/sets.t.payload.netdev
index e31aeb9274e66..0c755fadb9e69 100644
--- a/tests/py/inet/sets.t.payload.netdev
+++ b/tests/py/inet/sets.t.payload.netdev
@@ -6,6 +6,15 @@ netdev test-netdev ingress
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set2 drop
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
 # ip6 daddr != @set2 accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/inet/snat.t b/tests/py/inet/snat.t
index cf23b5cff1bbe..eb235063332dc 100644
--- a/tests/py/inet/snat.t
+++ b/tests/py/inet/snat.t
@@ -13,7 +13,7 @@ iifname "foo" masquerade random;ok
 
 
 snat to 192.168.3.2;fail
-snat ip6 to 192.168.3.2;fail
+snat ip6 to 192.168.3.2;ok;snat ip6 to ::ffff:192.168.3.2
 snat to dead::beef;fail
 snat ip to dead::beef;fail
 snat ip daddr 1.2.3.4 to dead::beef;fail
diff --git a/tests/py/inet/snat.t.json b/tests/py/inet/snat.t.json
index 4671625dc06d9..66efe661799a3 100644
--- a/tests/py/inet/snat.t.json
+++ b/tests/py/inet/snat.t.json
@@ -129,3 +129,12 @@
     }
 ]
 
+# snat ip6 to 192.168.3.2
+[
+    {
+        "snat": {
+            "addr": "192.168.3.2",
+            "family": "ip6"
+        }
+    }
+]
diff --git a/tests/py/inet/snat.t.json.output b/tests/py/inet/snat.t.json.output
index 5b9588606c5c3..92cb428f6c414 100644
--- a/tests/py/inet/snat.t.json.output
+++ b/tests/py/inet/snat.t.json.output
@@ -20,3 +20,12 @@
     }
 ]
 
+# snat ip6 to 192.168.3.2
+[
+    {
+        "snat": {
+            "addr": "::ffff:192.168.3.2",
+            "family": "ip6"
+        }
+    }
+]
diff --git a/tests/py/inet/snat.t.payload b/tests/py/inet/snat.t.payload
index 50519c6b6bb6f..8c96dcaf93da4 100644
--- a/tests/py/inet/snat.t.payload
+++ b/tests/py/inet/snat.t.payload
@@ -40,3 +40,8 @@ inet test-inet postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
   [ masq flags 0x4 ]
+
+# snat ip6 to 192.168.3.2
+inet test-inet postrouting
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 0x0203a8c0 ]
+  [ nat snat ip6 addr_min reg 1 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 2b218015afdc0..2822ff7ec18aa 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -8,7 +8,7 @@
 *netdev;test-netdev;ingress,egress
 
 !ip6addrset type ipv6_addr;ok
-?ip6addrset feed::c0:ffee, ::ffff:1.2.3.4;ok
+?ip6addrset feed::c0:ffee, ::ffff:1.2.3.4, 192.168.1.1;ok
 !v4v6set type ipv4_addr . ipv6_addr;ok
 ?v4v6set 1.2.3.4 . ::ffff:5.6.7.8;ok
 !v6v4set type ipv6_addr . ipv4_addr;ok
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 430dd5715f97e..4296e56008238 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -145,6 +145,8 @@ ip6 saddr ::1 ip6 daddr ::2;ok
 ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 };ok;ip6 daddr != {0:1234:1234:1234:1234:1234:1234:1234, 1234:1234:0:1234:1234:1234:1234:1234}
 ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234;ok;ip6 daddr != 0:1234:1234:1234:1234:1234:1234:1234-1234:1234:0:1234:1234:1234:1234:1234
 
+ip6 saddr 192.168.1.1;ok;ip6 saddr ::ffff:192.168.1.1
+
 # limit impact to lo
 iif "lo" ip6 daddr set ::1;ok
 iif "lo" ip6 hoplimit set 1;ok
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index 72d91cc74688d..80724e2bf8879 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -1401,6 +1401,22 @@
     }
 ]
 
+# ip6 saddr 192.168.1.1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip6"
+                }
+            },
+            "op": "==",
+            "right": "192.168.1.1"
+        }
+    }
+]
+
 # iif "lo" ip6 daddr set ::1
 [
     {
diff --git a/tests/py/ip6/ip6.t.json.output b/tests/py/ip6/ip6.t.json.output
index 6c20939f72717..216a8d64b8383 100644
--- a/tests/py/ip6/ip6.t.json.output
+++ b/tests/py/ip6/ip6.t.json.output
@@ -372,3 +372,18 @@
     }
 ]
 
+# ip6 saddr 192.168.1.1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip6"
+                }
+            },
+            "op": "==",
+            "right": "::ffff:192.168.1.1"
+        }
+    }
+]
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index f0c1843d4b3e1..64505a30017a1 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -592,6 +592,13 @@ inet test-inet input
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ range neq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 0x34123412 0x34120000 0x34123412 0x34123412 ]
 
+# ip6 saddr 192.168.1.1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0xffff0000 0x0101a8c0 ]
+
 # iif "lo" ip6 daddr set ::1
 inet test-inet input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 5118d4f22be56..5d29c6170b70f 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -442,6 +442,11 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ range neq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 0x34123412 0x34120000 0x34123412 0x34123412 ]
 
+# ip6 saddr 192.168.1.1
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0xffff0000 0x0101a8c0 ]
+
 # iif "lo" ip6 daddr set ::1
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip6/rt0.t b/tests/py/ip6/rt0.t
index 1d50a89cf2f77..9a42099fb052d 100644
--- a/tests/py/ip6/rt0.t
+++ b/tests/py/ip6/rt0.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;output
 
-rt nexthop 192.168.0.1;fail
+rt nexthop 192.168.0.1;ok;rt ip6 nexthop ::ffff:192.168.0.1
 rt nexthop fd00::1;ok;rt ip6 nexthop fd00::1
diff --git a/tests/py/ip6/rt0.t.json b/tests/py/ip6/rt0.t.json
index 75ff9231a2b45..05f2778c10204 100644
--- a/tests/py/ip6/rt0.t.json
+++ b/tests/py/ip6/rt0.t.json
@@ -1,3 +1,18 @@
+# rt nexthop 192.168.0.1
+[
+    {
+        "match": {
+            "left": {
+                "rt": {
+                    "key": "nexthop"
+                }
+            },
+            "op": "==",
+            "right": "192.168.0.1"
+        }
+    }
+]
+
 # rt nexthop fd00::1
 [
     {
diff --git a/tests/py/ip6/rt0.t.payload b/tests/py/ip6/rt0.t.payload
index 464b7f212fc5c..a3066f34b6c88 100644
--- a/tests/py/ip6/rt0.t.payload
+++ b/tests/py/ip6/rt0.t.payload
@@ -1,3 +1,8 @@
+# rt nexthop 192.168.0.1
+ip6 test-ip6 output
+  [ rt load nexthop6 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0xffff0000 0x0100a8c0 ]
+
 # rt nexthop fd00::1
 ip6 test-ip6 output
   [ rt load nexthop6 => reg 1 ]
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index cc26bd227847d..afd2e7f1d1c35 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -17,7 +17,7 @@
 ?set2 1234:1234::1234:1234:1234:1234:1234;ok
 ?set2 1234::1234:1234:1234;ok
 ?set2 1234:1234:1234:1234:1234::1234:1234, 1234:1234::123;ok
-?set2 192.168.3.8, 192.168.3.9;fail
+?set2 192.168.3.8, 192.168.3.9;ok
 ?set2 1234:1234::1234:1234:1234:1234;ok
 ?set2 1234:1234::1234:1234:1234:1234;ok
 ?set2 1234:1234:1234::1234;ok
@@ -48,4 +48,4 @@ add @map1 { ip6 saddr . ip6 daddr : meta mark };ok
 delete @set5 { ip6 saddr . ip6 daddr };ok
 
 !map2 type ipv6_addr . ipv6_addr . inet_service : ipv6_addr . inet_service;ok
-add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 };ok
\ No newline at end of file
+add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 };ok
-- 
2.51.0

