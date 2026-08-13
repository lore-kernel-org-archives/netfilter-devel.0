Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C15A466B77
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786621571; cv=none; b=tj98Ye2oh3pktFly76kMnZLc7ueEgOn4NVakGoLiCWA1S9eIZP3IUyw5H0VPIh0eaeFYxM36M+dKwTwnR5aPM7oZn69R410ttO+UporjkG5egxpEoHrr5XvlI6LqrPhzyObikhbBpgtD6nnb2KlBd5QJ8l7ATLDTnLNttLxdzvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786621571; c=relaxed/simple;
	bh=fQSUKln5VMDHRSG7rzZMgoV+lAOyx5MLFwi1fayG9oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSFM5nbt5fiDD0eJogmbVInBZ+/hZn60GngpQomrtjGTrjXSK8Vgyl26l8JATb5mKTon9guz4GiIdxaF7U7eEwImGbjCgj8UxRkEsrmOHWhWr6ndWYLzGMWFU8S70OmQ7Z1Ve9FZwyc/oJ1095U3lp5AYkR4cyeQJRVOSa98MPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KKGeRrRY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KKGeRrRY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8riASVBGLDAYlFAEncU+fZwJ6LjQnY33F9kVnDs4hGc=; b=KKGeRrRYrpNl7VCjULmS5YCtmZ
	ACjcMhx/xMFYl0fPF+JMFE1+uSE8KogagWx1ODWtDCcWrd0Ib7IWbL9zkW8DOgohZY5lvXJzP3EN4
	LUO3GhmEHv3SNMccm7+V8T64qPkS+JJ5W681MT+Qdbz0iqEAQou8288LEekuWcush42DBDUlmjjU7
	qLla4znV01XBRhhZD09/hebk0hRfXFtmAa2z7c+75QQbLwSOe6QLanoWDUiBGDLJe8peO3N/IE5vI
	MllxVgPkhUO7mvOUhovZWFIAdwys2uaEitcruT+/60UL7Ns7o0qeQsLCt6fXarqXsBRyDYnQDM8PA
	eou6Q0nw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wuTso-000000002HH-2eHg;
	Thu, 13 Aug 2026 13:46:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: [nft PATCH 2/2] tests: shell: Convert dumps to numeric protocols
Date: Thu, 13 Aug 2026 13:45:56 +0200
Message-ID: <20260813114556.2685869-3-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813114556.2685869-1-phil@nwl.cc>
References: <20260813114556.2685869-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These changes were caused by a test run with DUMPGEN=y.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../cache/dumps/0003_cache_update_0.json-nft  |  4 +-
 .../cache/dumps/0003_cache_update_0.nft       |  4 +-
 .../chains/dumps/0041chain_binding_0.nft      |  4 +-
 .../maps/dumps/0010concat_map_0.json-nft      |  2 +-
 .../testcases/maps/dumps/0010concat_map_0.nft |  2 +-
 .../testcases/maps/dumps/0013map_0.json-nft   |  2 +-
 .../shell/testcases/maps/dumps/0013map_0.nft  |  2 +-
 .../maps/dumps/anon_objmap_concat.json-nft    |  4 +-
 .../maps/dumps/anon_objmap_concat.nft         |  2 +-
 .../maps/dumps/named_limits.json-nft          | 14 ++---
 .../testcases/maps/dumps/named_limits.nft     | 14 ++---
 .../maps/dumps/nat_addr_port.json-nft         | 16 +++---
 .../testcases/maps/dumps/nat_addr_port.nft    | 16 +++---
 .../maps/dumps/typeof_maps_0.json-nft         |  6 +--
 .../testcases/maps/dumps/typeof_maps_0.nft    |  4 +-
 .../dumps/typeof_maps_add_delete.json-nft     |  2 +-
 .../maps/dumps/typeof_maps_add_delete.nft     |  2 +-
 .../dumps/0012different_defines_0.json-nft    |  4 +-
 .../nft-f/dumps/0012different_defines_0.nft   |  2 +-
 .../dumps/named_set_as_protocol_dep.json-nft  |  4 +-
 .../nft-f/dumps/named_set_as_protocol_dep.nft |  2 +-
 .../testcases/nft-f/dumps/sample-ruleset.nft  |  4 +-
 .../optimizations/dumps/merge_reject.json-nft | 12 ++---
 .../optimizations/dumps/merge_reject.nft      |  4 +-
 .../dumps/merge_stmts_concat.json-nft         |  4 +-
 .../dumps/merge_stmts_concat.nft              |  2 +-
 .../dumps/merge_vmap_raw.json-nft             | 10 ++--
 .../optimizations/dumps/merge_vmap_raw.nft    | 10 ++--
 .../optimizations/dumps/merge_vmaps.json-nft  |  4 +-
 .../optimizations/dumps/merge_vmaps.nft       |  2 +-
 .../dumps/exclusive_start_cond.json-nft       | 52 +++++++++----------
 .../parsing/dumps/exclusive_start_cond.nft    | 42 +++++++--------
 .../parsing/dumps/large_rule_pipe.json-nft    | 24 ++++-----
 .../parsing/dumps/large_rule_pipe.nft         | 12 ++---
 .../0037_set_with_inet_service_0.json-nft     | 10 ++--
 .../dumps/0037_set_with_inet_service_0.nft    | 10 ++--
 .../shell/testcases/sets/dumps/0047nat_0.nft  |  2 +-
 .../sets/dumps/0067nat_concat_interval_0.nft  |  6 +--
 .../sets/dumps/0067nat_interval_0.nft         |  2 +-
 .../testcases/sets/dumps/set_eval_0.json-nft  |  4 +-
 .../shell/testcases/sets/dumps/set_eval_0.nft |  2 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |  4 +-
 .../sets/dumps/sets_with_ifnames.nft          |  4 +-
 .../transactions/dumps/0049huge_0.json-nft    | 16 +++---
 .../transactions/dumps/0049huge_0.nft         |  8 +--
 45 files changed, 181 insertions(+), 181 deletions(-)

diff --git a/tests/shell/testcases/cache/dumps/0003_cache_update_0.json-nft b/tests/shell/testcases/cache/dumps/0003_cache_update_0.json-nft
index e09a694c2df7b..c6be696c50cda 100644
--- a/tests/shell/testcases/cache/dumps/0003_cache_update_0.json-nft
+++ b/tests/shell/testcases/cache/dumps/0003_cache_update_0.json-nft
@@ -74,7 +74,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "icmp"
+              "right": 1
             }
           },
           {
@@ -111,7 +111,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "igmp"
+              "right": 2
             }
           },
           {
diff --git a/tests/shell/testcases/cache/dumps/0003_cache_update_0.nft b/tests/shell/testcases/cache/dumps/0003_cache_update_0.nft
index 43898d336d02a..da9076f2ee835 100644
--- a/tests/shell/testcases/cache/dumps/0003_cache_update_0.nft
+++ b/tests/shell/testcases/cache/dumps/0003_cache_update_0.nft
@@ -10,9 +10,9 @@ table ip t3 {
 }
 table ip t4 {
 	chain c {
-		meta l4proto icmp accept
+		meta l4proto 1 accept
 		drop
-		meta l4proto igmp accept
+		meta l4proto 2 accept
 		drop
 	}
 }
diff --git a/tests/shell/testcases/chains/dumps/0041chain_binding_0.nft b/tests/shell/testcases/chains/dumps/0041chain_binding_0.nft
index 520203d89ca15..28be854f91887 100644
--- a/tests/shell/testcases/chains/dumps/0041chain_binding_0.nft
+++ b/tests/shell/testcases/chains/dumps/0041chain_binding_0.nft
@@ -1,11 +1,11 @@
 table inet x {
 	chain y {
 		type filter hook input priority filter; policy accept;
-		meta l4proto { tcp, udp } th dport 53 jump {
+		meta l4proto { 6, 17 } th dport 53 jump {
 			ip saddr { 127.0.0.0/8, 172.23.0.0/16, 192.168.13.0/24 } counter packets 0 bytes 0 accept
 			ip6 saddr ::1 counter packets 0 bytes 0 accept
 		}
-		meta l4proto ipv6-icmp jump {
+		meta l4proto 58 jump {
 			counter packets 0 bytes 0 accept
 		}
 	}
diff --git a/tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft b/tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft
index fcc23bb8095fa..0ac62525d3654 100644
--- a/tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft
@@ -46,7 +46,7 @@
             {
               "concat": [
                 "1.1.1.1",
-                "tcp",
+                6,
                 20
               ]
             },
diff --git a/tests/shell/testcases/maps/dumps/0010concat_map_0.nft b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
index 2f796b51d46b7..c21b3ea0c1a2f 100644
--- a/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
@@ -1,7 +1,7 @@
 table inet x {
 	map z {
 		type ipv4_addr . inet_proto . inet_service : ipv4_addr . inet_service
-		elements = { 1.1.1.1 . tcp . 20 : 2.2.2.2 . 30 }
+		elements = { 1.1.1.1 . 6 . 20 : 2.2.2.2 . 30 }
 	}
 
 	chain y {
diff --git a/tests/shell/testcases/maps/dumps/0013map_0.json-nft b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
index e91a269d8e6e6..81371962558e9 100644
--- a/tests/shell/testcases/maps/dumps/0013map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
@@ -48,7 +48,7 @@
                 "val": {
                   "concat": [
                     "10.133.89.138",
-                    "tcp",
+                    6,
                     8081
                   ]
                 },
diff --git a/tests/shell/testcases/maps/dumps/0013map_0.nft b/tests/shell/testcases/maps/dumps/0013map_0.nft
index 1455877df1bff..ad09ed64fd3f1 100644
--- a/tests/shell/testcases/maps/dumps/0013map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0013map_0.nft
@@ -3,7 +3,7 @@ table ip filter {
 		type ipv4_addr . inet_proto . inet_service : verdict
 		flags interval
 		counter
-		elements = { 10.133.89.138 . tcp . 8081 counter packets 0 bytes 0 : accept }
+		elements = { 10.133.89.138 . 6 . 8081 counter packets 0 bytes 0 : accept }
 	}
 
 	chain FORWARD {
diff --git a/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft b/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft
index 642098427e6f9..dc90419a701d1 100644
--- a/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft
+++ b/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft
@@ -79,7 +79,7 @@
                     [
                       {
                         "concat": [
-                          "udp",
+                          17,
                           {
                             "range": [
                               10000,
@@ -93,7 +93,7 @@
                     [
                       {
                         "concat": [
-                          "tcp",
+                          6,
                           {
                             "range": [
                               10000,
diff --git a/tests/shell/testcases/maps/dumps/anon_objmap_concat.nft b/tests/shell/testcases/maps/dumps/anon_objmap_concat.nft
index 23aca0a2d9886..eef4e9f04ad91 100644
--- a/tests/shell/testcases/maps/dumps/anon_objmap_concat.nft
+++ b/tests/shell/testcases/maps/dumps/anon_objmap_concat.nft
@@ -11,6 +11,6 @@ table inet filter {
 
 	chain input {
 		type filter hook input priority filter; policy accept;
-		ct helper set ip protocol . th dport map { udp . 10000-20000 : "sip-5060u", tcp . 10000-20000 : "sip-5060t" }
+		ct helper set ip protocol . th dport map { 17 . 10000-20000 : "sip-5060u", 6 . 10000-20000 : "sip-5060t" }
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/named_limits.json-nft b/tests/shell/testcases/maps/dumps/named_limits.json-nft
index 3c6845ac43b42..ffbeee1289487 100644
--- a/tests/shell/testcases/maps/dumps/named_limits.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_limits.json-nft
@@ -151,7 +151,7 @@
           [
             {
               "concat": [
-                "tcp",
+                6,
                 {
                   "prefix": {
                     "addr": "192.168.0.0",
@@ -171,7 +171,7 @@
           [
             {
               "concat": [
-                "udp",
+                17,
                 {
                   "prefix": {
                     "addr": "192.168.0.0",
@@ -191,7 +191,7 @@
           [
             {
               "concat": [
-                "tcp",
+                6,
                 {
                   "range": [
                     "127.0.0.1",
@@ -211,7 +211,7 @@
           [
             {
               "concat": [
-                "tcp",
+                6,
                 {
                   "range": [
                     "10.0.0.1",
@@ -226,7 +226,7 @@
           [
             {
               "concat": [
-                "tcp",
+                6,
                 {
                   "range": [
                     "10.0.0.1",
@@ -241,7 +241,7 @@
           [
             {
               "concat": [
-                "tcp",
+                6,
                 {
                   "prefix": {
                     "addr": "10.0.1.0",
@@ -261,7 +261,7 @@
           [
             {
               "concat": [
-                "tcp",
+                6,
                 "10.0.2.1",
                 22
               ]
diff --git a/tests/shell/testcases/maps/dumps/named_limits.nft b/tests/shell/testcases/maps/dumps/named_limits.nft
index 214df204b770a..29f9dc69f921b 100644
--- a/tests/shell/testcases/maps/dumps/named_limits.nft
+++ b/tests/shell/testcases/maps/dumps/named_limits.nft
@@ -32,13 +32,13 @@ table inet filter {
 	map addr4limit {
 		typeof meta l4proto . ip saddr . tcp sport : limit
 		flags interval
-		elements = { tcp . 192.168.0.0/16 . 1-65535 : "tarpit-bps",
-			     udp . 192.168.0.0/16 . 1-65535 : "tarpit-pps",
-			     tcp . 127.0.0.1-127.1.2.3 . 1-1024 : "tarpit-pps",
-			     tcp . 10.0.0.1-10.0.0.255 . 80 : "http-bulk-rl-1m",
-			     tcp . 10.0.0.1-10.0.0.255 . 443 : "http-bulk-rl-1m",
-			     tcp . 10.0.1.0/24 . 1024-65535 : "http-bulk-rl-10m",
-			     tcp . 10.0.2.1 . 22 : "http-bulk-rl-10m" }
+		elements = { 6 . 192.168.0.0/16 . 1-65535 : "tarpit-bps",
+			     17 . 192.168.0.0/16 . 1-65535 : "tarpit-pps",
+			     6 . 127.0.0.1-127.1.2.3 . 1-1024 : "tarpit-pps",
+			     6 . 10.0.0.1-10.0.0.255 . 80 : "http-bulk-rl-1m",
+			     6 . 10.0.0.1-10.0.0.255 . 443 : "http-bulk-rl-1m",
+			     6 . 10.0.1.0/24 . 1024-65535 : "http-bulk-rl-10m",
+			     6 . 10.0.2.1 . 22 : "http-bulk-rl-10m" }
 	}
 
 	map saddr6limit {
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft b/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
index 38b01e694180d..1a3e71d72e022 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
@@ -262,7 +262,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -361,7 +361,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -612,7 +612,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -711,7 +711,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -1059,7 +1059,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -1159,7 +1159,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -1292,7 +1292,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -1392,7 +1392,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index c8493b3adbf26..b8b22c717e676 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -27,10 +27,10 @@ table ip ipfoo {
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat ip to ip saddr map @y
+		meta l4proto 6 dnat ip to ip saddr map @y
 		dnat ip to ip saddr . tcp dport map @z
 		dnat to numgen inc mod 2 map @t1
-		meta l4proto tcp dnat ip to numgen inc mod 2 map @t2
+		meta l4proto 6 dnat ip to numgen inc mod 2 map @t2
 	}
 }
 table ip6 ip6foo {
@@ -60,10 +60,10 @@ table ip6 ip6foo {
 		dnat to ip6 daddr map @x
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat ip6 to ip6 saddr map @y
+		meta l4proto 6 dnat ip6 to ip6 saddr map @y
 		dnat ip6 to ip6 saddr . tcp dport map @z
 		dnat to numgen inc mod 2 map @t1
-		meta l4proto tcp dnat ip6 to numgen inc mod 2 map @t2
+		meta l4proto 6 dnat ip6 to numgen inc mod 2 map @t2
 	}
 }
 table inet inetfoo {
@@ -114,16 +114,16 @@ table inet inetfoo {
 		dnat ip to ip daddr map @x4
 		ip saddr 10.1.1.1 dnat ip to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat ip to 10.2.3.4:4242
-		meta l4proto tcp dnat ip to ip saddr map @y4
+		meta l4proto 6 dnat ip to ip saddr map @y4
 		dnat ip to ip saddr . tcp dport map @z4
 		dnat ip to numgen inc mod 2 map @t1v4
-		meta l4proto tcp dnat ip to numgen inc mod 2 map @t2v4
+		meta l4proto 6 dnat ip to numgen inc mod 2 map @t2v4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat ip6 to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat ip6 to [c0::1a]:4242
-		meta l4proto tcp dnat ip6 to ip6 saddr map @y6
+		meta l4proto 6 dnat ip6 to ip6 saddr map @y6
 		dnat ip6 to ip6 saddr . tcp dport map @z6
 		dnat ip6 to numgen inc mod 2 map @t1v6
-		meta l4proto tcp dnat ip6 to numgen inc mod 2 map @t2v6
+		meta l4proto 6 dnat ip6 to numgen inc mod 2 map @t2v6
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_0.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_0.json-nft
index bef3b3d12037a..b7b20e392ca76 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_0.json-nft
@@ -153,7 +153,7 @@
             {
               "concat": [
                 "eth0",
-                "tcp",
+                6,
                 22
               ]
             },
@@ -375,7 +375,7 @@
                     {
                       "concat": [
                         "eth0",
-                        "tcp",
+                        6,
                         22
                       ]
                     },
@@ -387,7 +387,7 @@
                     {
                       "concat": [
                         "eth1",
-                        "udp",
+                        17,
                         67
                       ]
                     },
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
index e0efabab3b550..b6435f9bb5cf8 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
@@ -18,7 +18,7 @@ table inet t {
 
 	map m4 {
 		typeof iifname . ip protocol . th dport : verdict
-		elements = { "eth0" . tcp . 22 : accept }
+		elements = { "eth0" . 6 . 22 : accept }
 	}
 
 	map m5 {
@@ -31,7 +31,7 @@ table inet t {
 		meta mark set vlan id map @m2
 		meta mark set ip saddr . ip daddr map @m3
 		iifname . ip protocol . th dport vmap @m4
-		iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop }
+		iifname . ip protocol . th dport vmap { "eth0" . 6 . 22 : accept, "eth1" . 17 . 67 : drop }
 		ipsec in reqid . iifname vmap @m5
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
index effe02dcf8364..08c10819f1b9c 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
@@ -263,7 +263,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "icmp"
+              "right": 1
             }
           },
           {
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
index e80366b8bf2a4..3f3ef17dd5493 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
@@ -17,6 +17,6 @@ table ip dynset {
 	chain input {
 		type filter hook input priority filter; policy accept;
 		add @dynmark { 10.2.3.4 timeout 2s : 0x00000002 } comment "also check timeout-gc"
-		meta l4proto icmp ip daddr 127.0.0.42 jump test_ping
+		meta l4proto 1 ip daddr 127.0.0.42 jump test_ping
 	}
 }
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
index e266bf4c8a698..ea102f2073e1a 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
@@ -362,13 +362,13 @@
                   {
                     "concat": [
                       "fe0::1",
-                      "udp"
+                      17
                     ]
                   },
                   {
                     "concat": [
                       "fe0::2",
-                      "tcp"
+                      6
                     ]
                   }
                 ]
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
index a6e16e7dd0336..d9c3834afce18 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
@@ -8,7 +8,7 @@ table inet t {
 		ip6 daddr fe0::1 ip6 saddr fe0::2
 		ip saddr vmap { 10.0.0.0 : drop, 10.0.0.2 : accept }
 		ip6 daddr vmap { fe0::1 : drop, fe0::2 : accept }
-		ip6 saddr . ip6 nexthdr { fe0::1 . udp, fe0::2 . tcp }
+		ip6 saddr . ip6 nexthdr { fe0::1 . 17, fe0::2 . 6 }
 		ip daddr . iif vmap { 10.0.0.0 . "lo" : accept }
 		tcp dport 100-222
 		udp dport vmap { 100-222 : accept }
diff --git a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
index 4bc24aa319aba..c17b8b2168175 100644
--- a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
@@ -40,8 +40,8 @@
         },
         "handle": 0,
         "elem": [
-          "tcp",
-          "udp"
+          6,
+          17
         ]
       }
     },
diff --git a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
index 2bc0c2adb38c8..c0ad40110d980 100644
--- a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
+++ b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
@@ -1,7 +1,7 @@
 table inet test {
 	set protos {
 		typeof meta l4proto
-		elements = { tcp, udp }
+		elements = { 6, 17 }
 	}
 
 	chain prerouting {
diff --git a/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft b/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft
index 1a9f4e7a4afa4..7bcd6d4c9223a 100644
--- a/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft
+++ b/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft
@@ -49,7 +49,7 @@ table inet filter {
 
 	chain PREROUTING_RAW {
 		type filter hook prerouting priority raw; policy accept;
-		meta l4proto != { icmp, tcp, udp, ipv6-icmp } counter packets 0 bytes 0 drop
+		meta l4proto != { 1, 6, 17, 58 } counter packets 0 bytes 0 drop
 		tcp flags syn jump {
 			tcp option maxseg size 1-500 counter packets 0 bytes 0 drop
 			tcp sport 0 counter packets 0 bytes 0 drop
@@ -119,7 +119,7 @@ table inet filter {
 		icmp type echo-request accept
 		icmpv6 type echo-request accept
 		tcp dport 22 iifname "eth1" accept
-		meta l4proto { tcp, udp } th dport 53 jump {
+		meta l4proto { 6, 17 } th dport 53 jump {
 			ip6 saddr != { fd00::/8, fe80::/64 } counter packets 0 bytes 0 reject with icmpv6 port-unreachable
 			accept
 		}
diff --git a/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft b/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft
index 8f468e019657c..cdda63085eb32 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft
@@ -100,21 +100,21 @@
                 "set": [
                   {
                     "concat": [
-                      "tcp",
+                      6,
                       "172.30.33.71",
                       3306
                     ]
                   },
                   {
                     "concat": [
-                      "tcp",
+                      6,
                       "172.30.238.117",
                       8080
                     ]
                   },
                   {
                     "concat": [
-                      "tcp",
+                      6,
                       "172.30.254.251",
                       3306
                     ]
@@ -233,21 +233,21 @@
                 "set": [
                   {
                     "concat": [
-                      "tcp",
+                      6,
                       "aaaa::2",
                       3306
                     ]
                   },
                   {
                     "concat": [
-                      "tcp",
+                      6,
                       "aaaa::3",
                       8080
                     ]
                   },
                   {
                     "concat": [
-                      "tcp",
+                      6,
                       "aaaa::4",
                       3306
                     ]
diff --git a/tests/shell/testcases/optimizations/dumps/merge_reject.nft b/tests/shell/testcases/optimizations/dumps/merge_reject.nft
index 1727d024866d7..1091f3739bd70 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_reject.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_reject.nft
@@ -1,13 +1,13 @@
 table ip x {
 	chain y {
 		ip daddr 172.30.33.70 tcp dport 3306 counter packets 0 bytes 0 drop
-		meta l4proto . ip daddr . tcp dport { tcp . 172.30.33.71 . 3306, tcp . 172.30.238.117 . 8080, tcp . 172.30.254.251 . 3306 } counter packets 0 bytes 0 reject
+		meta l4proto . ip daddr . tcp dport { 6 . 172.30.33.71 . 3306, 6 . 172.30.238.117 . 8080, 6 . 172.30.254.251 . 3306 } counter packets 0 bytes 0 reject
 		ip daddr 172.30.254.252 tcp dport 3306 counter packets 0 bytes 0 reject with tcp reset
 	}
 }
 table ip6 x {
 	chain y {
-		meta l4proto . ip6 daddr . tcp dport { tcp . aaaa::2 . 3306, tcp . aaaa::3 . 8080, tcp . aaaa::4 . 3306 } counter packets 0 bytes 0 reject
+		meta l4proto . ip6 daddr . tcp dport { 6 . aaaa::2 . 3306, 6 . aaaa::3 . 8080, 6 . aaaa::4 . 3306 } counter packets 0 bytes 0 reject
 		ip6 daddr aaaa::5 tcp dport 3306 counter packets 0 bytes 0 reject with tcp reset
 	}
 }
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
index b70ee97b35ebd..61274b40300f5 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
@@ -164,13 +164,13 @@
                 "set": [
                   {
                     "concat": [
-                      "tcp",
+                      6,
                       22
                     ]
                   },
                   {
                     "concat": [
-                      "udp",
+                      17,
                       67
                     ]
                   }
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
index 6150258512061..64fab14572d0d 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
@@ -1,7 +1,7 @@
 table ip x {
 	chain y {
 		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth1" . 1.1.1.2 . 2.2.3.0/24, "eth1" . 1.1.1.2 . 2.2.4.0-2.2.4.10, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
-		ip protocol . th dport { tcp . 22, udp . 67 }
+		ip protocol . th dport { 6 . 22, 17 . 67 }
 		udp dport . ct state { 137 . new, 137 . untracked, 138 . new, 138 . untracked } accept
 	}
 
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.json-nft b/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.json-nft
index b8ad126cd2961..5b385ffd2e101 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.json-nft
@@ -77,7 +77,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "udp"
+              "right": 17
             }
           },
           {
@@ -116,7 +116,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "udp"
+              "right": 17
             }
           },
           {
@@ -166,7 +166,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "udp"
+              "right": 17
             }
           },
           {
@@ -218,7 +218,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "udp"
+              "right": 17
             }
           },
           {
@@ -270,7 +270,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "udp"
+              "right": 17
             }
           },
           {
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft b/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft
index 18847116eb503..5b9799ae9cb7f 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft
@@ -1,26 +1,26 @@
 table inet x {
 	chain nat_dns_dnstc {
-		meta l4proto udp redirect to :5300
+		meta l4proto 17 redirect to :5300
 		drop
 	}
 
 	chain nat_dns_this_5301 {
-		meta l4proto udp redirect to :5301
+		meta l4proto 17 redirect to :5301
 		drop
 	}
 
 	chain nat_dns_saturn_5301 {
-		meta nfproto ipv4 meta l4proto udp dnat ip to 240.0.1.2:5301
+		meta nfproto ipv4 meta l4proto 17 dnat ip to 240.0.1.2:5301
 		drop
 	}
 
 	chain nat_dns_saturn_5302 {
-		meta nfproto ipv4 meta l4proto udp dnat ip to 240.0.1.2:5302
+		meta nfproto ipv4 meta l4proto 17 dnat ip to 240.0.1.2:5302
 		drop
 	}
 
 	chain nat_dns_saturn_5303 {
-		meta nfproto ipv4 meta l4proto udp dnat ip to 240.0.1.2:5303
+		meta nfproto ipv4 meta l4proto 17 dnat ip to 240.0.1.2:5303
 		drop
 	}
 
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
index e87f1c4c082eb..acba97cca3cbd 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
@@ -166,7 +166,7 @@
               "data": {
                 "set": [
                   [
-                    "tcp",
+                    6,
                     {
                       "goto": {
                         "target": "filter_in_tcp"
@@ -174,7 +174,7 @@
                     }
                   ],
                   [
-                    "udp",
+                    17,
                     {
                       "goto": {
                         "target": "filter_in_udp"
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft b/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
index c981acf0a77ce..b0c384e857016 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
@@ -14,7 +14,7 @@ table ip x {
 	chain y {
 		update @s { ip saddr limit rate 12/minute burst 30 packets } accept
 		tcp dport vmap { 80 : accept, 81 : accept, 443 : accept, 8000-8100 : accept, 24000-25000 : accept }
-		meta l4proto vmap { tcp : goto filter_in_tcp, udp : goto filter_in_udp }
+		meta l4proto vmap { 6 : goto filter_in_tcp, 17 : goto filter_in_udp }
 		log
 	}
 }
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
index a1fbaafd1aa13..46ea3dcf24dd3 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
@@ -2018,7 +2018,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2051,7 +2051,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "udp"
+              "right": 17
             }
           },
           {
@@ -2092,7 +2092,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "udp"
+              "right": 17
             }
           },
           {
@@ -2148,7 +2148,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2188,7 +2188,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2207,7 +2207,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 0
             }
           }
         ]
@@ -2228,7 +2228,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2247,7 +2247,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 0
             }
           }
         ]
@@ -2268,7 +2268,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2308,7 +2308,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2348,7 +2348,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2388,7 +2388,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2407,7 +2407,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 0
             }
           }
         ]
@@ -2428,7 +2428,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2447,7 +2447,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 0
             }
           }
         ]
@@ -2468,7 +2468,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2487,7 +2487,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 0
             }
           }
         ]
@@ -2508,7 +2508,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2562,7 +2562,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2617,7 +2617,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2656,7 +2656,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2695,7 +2695,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2734,7 +2734,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2788,7 +2788,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2821,7 +2821,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
@@ -2854,7 +2854,7 @@
                   "key": "l4proto"
                 }
               },
-              "right": "tcp"
+              "right": 6
             }
           },
           {
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
index 2b94feaa77d8e..7a7ce2141e057 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
@@ -83,9 +83,9 @@ table ip t {
 		limit rate 1/second burst 5 packets fib daddr . iif check exists
 		limit rate 1/second burst 5 packets osf name "foo"
 		limit rate 1/second burst 5 packets ipsec in spi 0
-		meta l4proto tcp limit rate 1/second burst 5 packets tproxy to 0.0.0.1
-		meta l4proto udp limit rate 1/second burst 5 packets vxlan vni 0
-		meta l4proto udp limit rate 1/second burst 5 packets geneve vni 0
+		meta l4proto 6 limit rate 1/second burst 5 packets tproxy to 0.0.0.1
+		meta l4proto 17 limit rate 1/second burst 5 packets vxlan vni 0
+		meta l4proto 17 limit rate 1/second burst 5 packets geneve vni 0
 	}
 
 	chain c2 {
@@ -93,35 +93,35 @@ table ip t {
 }
 table ip6 t {
 	chain c {
-		meta l4proto tcp limit rate 1/second burst 5 packets ip6 saddr ::
-		meta l4proto tcp limit rate 1/second burst 5 packets hbh nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets rt nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets srh last-entry 0
-		meta l4proto tcp limit rate 1/second burst 5 packets srh sid[1] ::
-		meta l4proto tcp limit rate 1/second burst 5 packets srh tag 0
-		meta l4proto tcp limit rate 1/second burst 5 packets frag nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets dst nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets mh nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets exthdr hbh missing
+		meta l4proto 6 limit rate 1/second burst 5 packets ip6 saddr ::
+		meta l4proto 6 limit rate 1/second burst 5 packets hbh nexthdr 0
+		meta l4proto 6 limit rate 1/second burst 5 packets rt nexthdr 0
+		meta l4proto 6 limit rate 1/second burst 5 packets srh last-entry 0
+		meta l4proto 6 limit rate 1/second burst 5 packets srh sid[1] ::
+		meta l4proto 6 limit rate 1/second burst 5 packets srh tag 0
+		meta l4proto 6 limit rate 1/second burst 5 packets frag nexthdr 0
+		meta l4proto 6 limit rate 1/second burst 5 packets dst nexthdr 0
+		meta l4proto 6 limit rate 1/second burst 5 packets mh nexthdr 0
+		meta l4proto 6 limit rate 1/second burst 5 packets exthdr hbh missing
 	}
 }
 table arp t {
 	chain c {
-		meta l4proto tcp limit rate 1/second burst 5 packets arp htype 0
+		meta l4proto 6 limit rate 1/second burst 5 packets arp htype 0
 	}
 }
 table bridge t {
 	chain c {
-		meta l4proto tcp limit rate 1/second burst 5 packets meta ibrname "foo"
-		meta l4proto tcp limit rate 1/second burst 5 packets meta ibrname "foo"
-		meta l4proto tcp limit rate 1/second burst 5 packets meta obrname "foo"
-		meta l4proto tcp limit rate 1/second burst 5 packets meta obrname "foo"
+		meta l4proto 6 limit rate 1/second burst 5 packets meta ibrname "foo"
+		meta l4proto 6 limit rate 1/second burst 5 packets meta ibrname "foo"
+		meta l4proto 6 limit rate 1/second burst 5 packets meta obrname "foo"
+		meta l4proto 6 limit rate 1/second burst 5 packets meta obrname "foo"
 	}
 }
 table netdev t {
 	chain c {
-		meta l4proto tcp limit rate 1/second burst 5 packets dup to "lo"
-		meta l4proto tcp limit rate 1/second burst 5 packets fwd to "lo"
-		meta l4proto tcp limit rate 1/second burst 5 packets tunnel id 0
+		meta l4proto 6 limit rate 1/second burst 5 packets dup to "lo"
+		meta l4proto 6 limit rate 1/second burst 5 packets fwd to "lo"
+		meta l4proto 6 limit rate 1/second burst 5 packets tunnel id 0
 	}
 }
diff --git a/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft b/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
index bf5dc65fe1ddd..1310be6b5a3b0 100644
--- a/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
+++ b/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
@@ -2669,8 +2669,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -2838,8 +2838,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -3080,8 +3080,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -3595,8 +3595,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -3804,8 +3804,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -3973,8 +3973,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
diff --git a/tests/shell/testcases/parsing/dumps/large_rule_pipe.nft b/tests/shell/testcases/parsing/dumps/large_rule_pipe.nft
index c85a636a854e8..fd49e99bf701b 100644
--- a/tests/shell/testcases/parsing/dumps/large_rule_pipe.nft
+++ b/tests/shell/testcases/parsing/dumps/large_rule_pipe.nft
@@ -332,7 +332,7 @@ table inet firewalld {
 		jump filter_IN_public_log
 		jump filter_IN_public_deny
 		jump filter_IN_public_allow
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_IN_public_log {
@@ -350,7 +350,7 @@ table inet firewalld {
 		jump filter_FWDI_public_log
 		jump filter_FWDI_public_deny
 		jump filter_FWDI_public_allow
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_FWDI_public_log {
@@ -412,7 +412,7 @@ table inet firewalld {
 		jump filter_IN_home_log
 		jump filter_IN_home_deny
 		jump filter_IN_home_allow
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_IN_home_log {
@@ -438,7 +438,7 @@ table inet firewalld {
 		jump filter_FWDI_home_log
 		jump filter_FWDI_home_deny
 		jump filter_FWDI_home_allow
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_FWDI_home_log {
@@ -499,7 +499,7 @@ table inet firewalld {
 		jump filter_IN_work_log
 		jump filter_IN_work_deny
 		jump filter_IN_work_allow
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_IN_work_log {
@@ -517,7 +517,7 @@ table inet firewalld {
 		jump filter_FWDI_work_log
 		jump filter_FWDI_work_deny
 		jump filter_FWDI_work_allow
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_FWDI_work_log {
diff --git a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
index cf1c1cc9d479e..ad1bf5d573ee7 100644
--- a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
@@ -41,35 +41,35 @@
           {
             "concat": [
               "192.168.0.12",
-              "tcp",
+              6,
               53
             ]
           },
           {
             "concat": [
               "192.168.0.12",
-              "tcp",
+              6,
               80
             ]
           },
           {
             "concat": [
               "192.168.0.12",
-              "udp",
+              17,
               53
             ]
           },
           {
             "concat": [
               "192.168.0.13",
-              "tcp",
+              6,
               80
             ]
           },
           {
             "concat": [
               "192.168.0.113",
-              "tcp",
+              6,
               22
             ]
           }
diff --git a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
index 0e85f7c20eba0..d3bec3fe4ccf8 100644
--- a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
+++ b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
@@ -1,11 +1,11 @@
 table inet filter {
 	set myset {
 		type ipv4_addr . inet_proto . inet_service
-		elements = { 192.168.0.12 . tcp . 53,
-			     192.168.0.12 . tcp . 80,
-			     192.168.0.12 . udp . 53,
-			     192.168.0.13 . tcp . 80,
-			     192.168.0.113 . tcp . 22 }
+		elements = { 192.168.0.12 . 6 . 53,
+			     192.168.0.12 . 6 . 80,
+			     192.168.0.12 . 17 . 53,
+			     192.168.0.13 . 6 . 80,
+			     192.168.0.113 . 6 . 22 }
 	}
 
 	chain forward {
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index 86dbb70880ff0..dd0bd7a6ab3de 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -9,7 +9,7 @@ table ip x {
 
 	chain x {
 		type nat hook prerouting priority dstnat; policy accept;
-		meta l4proto tcp dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+		meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
 		dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
 	}
 
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index 9ac3774a7222c..e67906f2b613b 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -27,9 +27,9 @@ table ip nat {
 
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
-		ip protocol tcp dnat ip to ip saddr . ip daddr map @ipportmap2
-		meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th
+		ip protocol 6 dnat ip to ip saddr . ip daddr map @ipportmap2
+		meta l4proto { 6, 17 } dnat ip to ip daddr . th dport map @fwdtoip_th
 		dnat ip to iifname . ip saddr map @ipportmap4
-		meta l4proto tcp dnat ip to iifname . ip saddr map @ipportmap5
+		meta l4proto 6 dnat ip to iifname . ip saddr map @ipportmap5
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0067nat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_interval_0.nft
index 3e1584a8c5dc8..315d68eb5e992 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_interval_0.nft
@@ -8,6 +8,6 @@ table ip nat {
 
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
-		ip protocol tcp dnat ip to ip saddr map @ipportmap
+		ip protocol 6 dnat ip to ip saddr map @ipportmap
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
index 6f692381b6f7c..133e52bfaeb80 100644
--- a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
@@ -55,8 +55,8 @@
               },
               "right": {
                 "set": [
-                  "tcp",
-                  "udp"
+                  6,
+                  17
                 ]
               }
             }
diff --git a/tests/shell/testcases/sets/dumps/set_eval_0.nft b/tests/shell/testcases/sets/dumps/set_eval_0.nft
index a45462b8adbfc..93413f013fb5a 100644
--- a/tests/shell/testcases/sets/dumps/set_eval_0.nft
+++ b/tests/shell/testcases/sets/dumps/set_eval_0.nft
@@ -6,6 +6,6 @@ table ip nat {
 
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
-		meta l4proto { tcp, udp } th dport 443 dnat to 10.0.0.1
+		meta l4proto { 6, 17 } th dport 443 dnat to 10.0.0.1
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
index 7b4849e0530d3..48293fb2e60e3 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
@@ -509,7 +509,7 @@
                   "field": "protocol"
                 }
               },
-              "right": "icmp"
+              "right": 1
             }
           },
           {
@@ -536,7 +536,7 @@
                   "field": "protocol"
                 }
               },
-              "right": "icmp"
+              "right": 1
             }
           },
           {
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
index 8abca03a080ec..1536aaf6a0eab 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
@@ -53,8 +53,8 @@ table inet testifsets {
 
 	chain input {
 		type filter hook input priority filter; policy accept;
-		ip protocol icmp jump v4icmp
-		ip protocol icmp goto v4icmpc
+		ip protocol 1 jump v4icmp
+		ip protocol 1 goto v4icmpc
 	}
 
 	chain do_nothing {
diff --git a/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft b/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
index 456ada9401709..496a2c2afd15a 100644
--- a/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
@@ -1908,8 +1908,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -2111,8 +2111,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -2854,8 +2854,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
@@ -3132,8 +3132,8 @@
               },
               "right": {
                 "set": [
-                  "icmp",
-                  "ipv6-icmp"
+                  1,
+                  58
                 ]
               }
             }
diff --git a/tests/shell/testcases/transactions/dumps/0049huge_0.nft b/tests/shell/testcases/transactions/dumps/0049huge_0.nft
index e42ad3e19a73b..80c10d57ab790 100644
--- a/tests/shell/testcases/transactions/dumps/0049huge_0.nft
+++ b/tests/shell/testcases/transactions/dumps/0049huge_0.nft
@@ -98,7 +98,7 @@ table inet firewalld {
 		jump filter_IN_public_deny
 		jump filter_IN_public_allow
 		jump filter_IN_public_post
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_IN_public_pre {
@@ -124,7 +124,7 @@ table inet firewalld {
 		jump filter_FWDI_public_deny
 		jump filter_FWDI_public_allow
 		jump filter_FWDI_public_post
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_FWDI_public_pre {
@@ -335,7 +335,7 @@ table inet firewalld {
 		jump filter_IN_work_deny
 		jump filter_IN_work_allow
 		jump filter_IN_work_post
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_IN_work_pre {
@@ -384,7 +384,7 @@ table inet firewalld {
 		jump filter_FWDI_work_deny
 		jump filter_FWDI_work_allow
 		jump filter_FWDI_work_post
-		meta l4proto { icmp, ipv6-icmp } accept
+		meta l4proto { 1, 58 } accept
 	}
 
 	chain filter_FWDI_work_pre {
-- 
2.54.0

