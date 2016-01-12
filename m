From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3 nft] tests/py: don't test log statement from protocol match
Date: Tue, 12 Jan 2016 23:40:36 +0100
Message-ID: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55855 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbcALWlC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 17:41:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0D6A92791A3
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:40:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E5F81DA7E0
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:40:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 11F7BDA7E0
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:40:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/tcp.t              |  1 -
 tests/py/inet/tcp.t.payload.inet |  9 ---------
 tests/py/inet/tcp.t.payload.ip   |  9 ---------
 tests/py/inet/tcp.t.payload.ip6  |  9 ---------
 tests/py/ip/ip.t                 | 12 ++++++------
 tests/py/ip/ip.t.payload         | 18 ++++++------------
 tests/py/ip/ip.t.payload.inet    | 18 ++++++------------
 tests/py/ip6/ip6.t               |  4 ++--
 tests/py/ip6/ip6.t.payload.inet  |  6 ++----
 tests/py/ip6/ip6.t.payload.ip6   |  6 ++----
 10 files changed, 24 insertions(+), 68 deletions(-)

diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index cc19ed4..4a147bc 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -83,7 +83,6 @@ tcp window { 33, 55, 67, 88};ok
 tcp window { 33-55};ok
 - tcp window != { 33-55};ok
 
-tcp checksum 23456 log drop;ok
 tcp checksum 22;ok
 tcp checksum != 233;ok
 tcp checksum 33-45;ok
diff --git a/tests/py/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload.inet
index 21b21ab..5d54f87 100644
--- a/tests/py/inet/tcp.t.payload.inet
+++ b/tests/py/inet/tcp.t.payload.inet
@@ -381,15 +381,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-# tcp checksum 23456 log drop
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000a05b ]
-  [ log prefix (null) ]
-  [ immediate reg 0 drop ]
-
 # tcp checksum 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
index 34c9714..fb5316f 100644
--- a/tests/py/inet/tcp.t.payload.ip
+++ b/tests/py/inet/tcp.t.payload.ip
@@ -381,15 +381,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-# tcp checksum 23456 log drop
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000a05b ]
-  [ log prefix (null) ]
-  [ immediate reg 0 drop ]
-
 # tcp checksum 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
index 44decab..1d9dd1f 100644
--- a/tests/py/inet/tcp.t.payload.ip6
+++ b/tests/py/inet/tcp.t.payload.ip6
@@ -381,15 +381,6 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-# tcp checksum 23456 log drop
-ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000a05b ]
-  [ log prefix (null) ]
-  [ immediate reg 0 drop ]
-
 # tcp checksum 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 152323b..bb4198a 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -57,7 +57,7 @@ ip frag-off { 33-55};ok
 - ip frag-off != { 33-55};ok
 
 ip ttl 0 drop;ok
-ip ttl 233 log;ok
+ip ttl 233;ok
 ip ttl 33-55;ok
 ip ttl != 45-50;ok
 ip ttl {43, 53, 45 };ok
@@ -68,8 +68,8 @@ ip ttl {43, 53, 45 };ok
 ip ttl { 33-55};ok
 - ip ttl != { 33-55};ok
 
-ip protocol tcp log;ok;ip protocol 6 log
-ip protocol != tcp log;ok;ip protocol != 6 log
+ip protocol tcp;ok;ip protocol 6
+ip protocol != tcp;ok;ip protocol != 6
 ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok;ip protocol { 33, 136, 17, 51, 50, 6, 132, 1, 108} accept
 - ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok
 
@@ -86,8 +86,8 @@ ip checksum { 33-55};ok
 ip saddr 192.168.2.0/24;ok
 ip saddr != 192.168.2.0/24;ok
 ip saddr 192.168.3.1 ip daddr 192.168.3.100;ok
-ip saddr != 1.1.1.1 log prefix giuseppe;ok;ip saddr != 1.1.1.1 log prefix "giuseppe"
-ip saddr 1.1.1.1 log prefix example group 1;ok;ip saddr 1.1.1.1 log prefix "example" group 1
+ip saddr != 1.1.1.1;ok;ip saddr != 1.1.1.1
+ip saddr 1.1.1.1;ok;ip saddr 1.1.1.1
 ip daddr 192.168.0.1-192.168.0.250;ok
 ip daddr 10.0.0.0-10.255.255.255;ok
 ip daddr 172.16.0.0-172.31.255.255;ok
@@ -105,7 +105,7 @@ ip saddr != 192.168.1.3-192.168.33.55;ok
 
 ip daddr 192.168.0.1;ok
 ip daddr 192.168.0.1 drop;ok
-ip daddr 192.168.0.2 log;ok
+ip daddr 192.168.0.2;ok
 
 ip saddr \& 0xff == 1;ok;ip saddr & 0.0.0.255 == 0.0.0.1
 ip saddr \& 0.0.0.255 \< 0.0.0.127;ok;ip saddr & 0.0.0.255 < 0.0.0.127
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index da2dc21..aa3bfe9 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -119,11 +119,10 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000000 ]
   [ immediate reg 0 drop ]
 
-# ip ttl 233 log
+# ip ttl 233
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ cmp eq reg 1 0x000000e9 ]
-  [ log prefix (null) ]
 
 # ip ttl 33-55
 ip test-ip4 input
@@ -153,17 +152,15 @@ ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-# ip protocol tcp log
+# ip protocol tcp
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-  [ log prefix (null) ]
 
-# ip protocol != tcp log
+# ip protocol != tcp
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp neq reg 1 0x00000006 ]
-  [ log prefix (null) ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 set%d test-ip4 3
@@ -235,17 +232,15 @@ ip test-ip4 input
   [ payload load 8b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0103a8c0 0x6403a8c0 ]
 
-# ip saddr != 1.1.1.1 log prefix giuseppe
+# ip saddr != 1.1.1.1
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x01010101 ]
-  [ log prefix giuseppe ]
 
-# ip saddr 1.1.1.1 log prefix example group 1
+# ip saddr 1.1.1.1
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x01010101 ]
-  [ log prefix example group 1 snaplen 0 qthreshold 0]
 
 # ip daddr 192.168.0.1-192.168.0.250
 ip test-ip4 input
@@ -329,11 +324,10 @@ ip test-ip4 input
   [ cmp eq reg 1 0x0100a8c0 ]
   [ immediate reg 0 drop ]
 
-# ip daddr 192.168.0.2 log
+# ip daddr 192.168.0.2
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x0200a8c0 ]
-  [ log prefix (null) ]
 
 # ip saddr \& 0xff == 1
 ip test-ip4 input
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 35f73ff..4d4d485 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -157,13 +157,12 @@ inet test-inet input
   [ cmp eq reg 1 0x00000000 ]
   [ immediate reg 0 drop ]
 
-# ip ttl 233 log
+# ip ttl 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ cmp eq reg 1 0x000000e9 ]
-  [ log prefix (null) ]
 
 # ip ttl 33-55
 inet test-inet input
@@ -201,21 +200,19 @@ inet test-inet input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-# ip protocol tcp log
+# ip protocol tcp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-  [ log prefix (null) ]
 
-# ip protocol != tcp log
+# ip protocol != tcp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp neq reg 1 0x00000006 ]
-  [ log prefix (null) ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 set%d test-inet 3
@@ -309,21 +306,19 @@ inet test-inet input
   [ payload load 8b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0103a8c0 0x6403a8c0 ]
 
-# ip saddr != 1.1.1.1 log prefix giuseppe
+# ip saddr != 1.1.1.1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x01010101 ]
-  [ log prefix giuseppe ]
 
-# ip saddr 1.1.1.1 log prefix example group 1
+# ip saddr 1.1.1.1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x01010101 ]
-  [ log prefix example group 1 snaplen 0 qthreshold 0]
 
 # ip daddr 192.168.0.1-192.168.0.250
 inet test-inet input
@@ -433,13 +428,12 @@ inet test-inet input
   [ cmp eq reg 1 0x0100a8c0 ]
   [ immediate reg 0 drop ]
 
-# ip daddr 192.168.0.2 log
+# ip daddr 192.168.0.2
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x0200a8c0 ]
-  [ log prefix (null) ]
 
 # ip saddr \& 0xff == 1
 inet test-inet input
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index ceb2a82..9636672 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -37,7 +37,7 @@ ip6 length != 33-45;ok
 ip6 length { 33-55};ok
 - ip6 length != { 33-55};ok
 
-ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp} log;ok;ip6 nexthdr { 132, 51, 108, 136, 17, 33, 6} log
+ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp};ok;ip6 nexthdr { 132, 51, 108, 136, 17, 33, 6}
 ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;ip6 nexthdr { 6, 136, 108, 33, 50, 17, 132, 58, 51}
 - ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
 ip6 nexthdr esp;ok;ip6 nexthdr 50
@@ -47,7 +47,7 @@ ip6 nexthdr { 33-44};ok
 ip6 nexthdr 33-44;ok
 ip6 nexthdr != 33-44;ok
 
-ip6 hoplimit 1 log;ok
+ip6 hoplimit 1;ok
 ip6 hoplimit != 233;ok
 ip6 hoplimit 33-45;ok
 ip6 hoplimit != 33-45;ok
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index b4fd277..4bafb26 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -72,7 +72,7 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-# ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp} log
+# ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 set%d test-inet 3
 set%d test-inet 0
 	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
@@ -81,7 +81,6 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set set%d ]
-  [ log prefix (null) ]
 
 # ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 set%d test-inet 3
@@ -133,13 +132,12 @@ inet test-inet input
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002c ]
 
-# ip6 hoplimit 1 log
+# ip6 hoplimit 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ log prefix (null) ]
 
 # ip6 hoplimit != 233
 inet test-inet input
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index d355ada..c6e856c 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -54,14 +54,13 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-# ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp} log
+# ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 set%d test-ip6 3
 set%d test-ip6 0
 	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set set%d ]
-  [ log prefix (null) ]
 
 # ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 set%d test-ip6 3
@@ -101,11 +100,10 @@ ip6 test-ip6 input
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002c ]
 
-# ip6 hoplimit 1 log
+# ip6 hoplimit 1
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ log prefix (null) ]
 
 # ip6 hoplimit != 233
 ip6 test-ip6 input
-- 
2.1.4

