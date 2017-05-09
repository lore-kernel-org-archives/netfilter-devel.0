From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 10/10] tests: fix up meta l4proto change for ip family
Date: Tue,  9 May 2017 17:51:22 +0200
Message-ID: <20170509155122.26356-11-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44570 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755743AbdEIPvj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:39 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can delete some of the payload files now as ip/ip6/inet produce
same implicit meta l4proto dep.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/bridge/icmpX.t.payload                    |   4 +-
 tests/py/bridge/vlan.t.payload                     |   4 +-
 tests/py/bridge/vlan.t.payload.netdev              |   4 +-
 tests/py/inet/{ah.t.payload.inet => ah.t.payload}  |   0
 tests/py/inet/ah.t.payload.ip                      | 262 --------
 tests/py/inet/ah.t.payload.ip6                     | 262 --------
 tests/py/inet/ah.t.payload.netdev                  | 262 --------
 .../inet/{comp.t.payload.inet => comp.t.payload}   |   0
 tests/py/inet/comp.t.payload.ip                    | 145 -----
 tests/py/inet/comp.t.payload.ip6                   | 145 -----
 tests/py/inet/comp.t.payload.netdev                | 145 -----
 .../inet/{dccp.t.payload.inet => dccp.t.payload}   |   0
 tests/py/inet/dccp.t.payload.ip                    | 169 ------
 tests/py/inet/dccp.t.payload.ip6                   | 169 ------
 tests/py/inet/dccp.t.payload.netdev                | 169 ------
 .../py/inet/{esp.t.payload.inet => esp.t.payload}  |   0
 tests/py/inet/esp.t.payload.ip                     | 131 ----
 tests/py/inet/esp.t.payload.ip6                    | 131 ----
 tests/py/inet/esp.t.payload.netdev                 | 131 ----
 tests/py/inet/ether.t.payload.ip                   |   6 +-
 tests/py/inet/ether.t.payload.ip6                  |  55 --
 tests/py/inet/icmpX.t.payload                      |   4 +-
 tests/py/inet/{ip.t.payload.ip => ip.t.payload}    |   6 +-
 tests/py/inet/ip.t.payload.inet                    |   1 +
 .../py/inet/{map.t.payload.inet => map.t.payload}  |   0
 tests/py/inet/map.t.payload.ip                     |  12 +-
 tests/py/inet/map.t.payload.netdev                 |   2 +-
 .../inet/{sctp.t.payload.inet => sctp.t.payload}   |   0
 tests/py/inet/sctp.t.payload.ip                    | 276 ---------
 tests/py/inet/sctp.t.payload.ip6                   | 276 ---------
 tests/py/inet/sctp.t.payload.netdev                | 276 ---------
 .../py/inet/{tcp.t.payload.inet => tcp.t.payload}  |   0
 tests/py/inet/tcp.t.payload.ip                     | 661 --------------------
 tests/py/inet/tcp.t.payload.ip6                    | 661 --------------------
 tests/py/inet/tcp.t.payload.netdev                 | 669 ---------------------
 .../{tcpopt.t.payload.inet => tcpopt.t.payload}    |   0
 .../py/inet/{udp.t.payload.inet => udp.t.payload}  |   0
 tests/py/inet/udp.t.payload.ip                     | 330 ----------
 tests/py/inet/udp.t.payload.ip6                    | 330 ----------
 tests/py/inet/udp.t.payload.netdev                 | 331 ----------
 .../{udplite.t.payload.inet => udplite.t.payload}  |   0
 tests/py/inet/udplite.t.payload.ip                 | 240 --------
 tests/py/inet/udplite.t.payload.ip6                | 240 --------
 tests/py/inet/udplite.t.payload.netdev             | 240 --------
 tests/py/ip/dnat.t.payload.ip                      |  12 +-
 tests/py/ip/ether.t.payload                        |   6 +-
 tests/py/ip/icmp.t.payload.ip                      | 146 ++---
 tests/py/ip/masquerade.t.payload                   |  28 +-
 tests/py/ip/objects.t.payload                      |   6 +-
 tests/py/ip/redirect.t.payload                     |  44 +-
 tests/py/ip/reject.t.payload                       |   2 +-
 tests/py/ip/snat.t.payload                         |  10 +-
 tests/py/ip/tcp.t.payload                          |   2 +-
 tests/py/ip/tcpopt.t.payload                       |  52 +-
 54 files changed, 174 insertions(+), 6883 deletions(-)
 rename tests/py/inet/{ah.t.payload.inet => ah.t.payload} (100%)
 delete mode 100644 tests/py/inet/ah.t.payload.ip
 delete mode 100644 tests/py/inet/ah.t.payload.ip6
 delete mode 100644 tests/py/inet/ah.t.payload.netdev
 rename tests/py/inet/{comp.t.payload.inet => comp.t.payload} (100%)
 delete mode 100644 tests/py/inet/comp.t.payload.ip
 delete mode 100644 tests/py/inet/comp.t.payload.ip6
 delete mode 100644 tests/py/inet/comp.t.payload.netdev
 rename tests/py/inet/{dccp.t.payload.inet => dccp.t.payload} (100%)
 delete mode 100644 tests/py/inet/dccp.t.payload.ip
 delete mode 100644 tests/py/inet/dccp.t.payload.ip6
 delete mode 100644 tests/py/inet/dccp.t.payload.netdev
 rename tests/py/inet/{esp.t.payload.inet => esp.t.payload} (100%)
 delete mode 100644 tests/py/inet/esp.t.payload.ip
 delete mode 100644 tests/py/inet/esp.t.payload.ip6
 delete mode 100644 tests/py/inet/esp.t.payload.netdev
 delete mode 100644 tests/py/inet/ether.t.payload.ip6
 rename tests/py/inet/{ip.t.payload.ip => ip.t.payload} (86%)
 rename tests/py/inet/{map.t.payload.inet => map.t.payload} (100%)
 rename tests/py/inet/{sctp.t.payload.inet => sctp.t.payload} (100%)
 delete mode 100644 tests/py/inet/sctp.t.payload.ip
 delete mode 100644 tests/py/inet/sctp.t.payload.ip6
 delete mode 100644 tests/py/inet/sctp.t.payload.netdev
 rename tests/py/inet/{tcp.t.payload.inet => tcp.t.payload} (100%)
 delete mode 100644 tests/py/inet/tcp.t.payload.ip
 delete mode 100644 tests/py/inet/tcp.t.payload.ip6
 delete mode 100644 tests/py/inet/tcp.t.payload.netdev
 rename tests/py/inet/{tcpopt.t.payload.inet => tcpopt.t.payload} (100%)
 rename tests/py/inet/{udp.t.payload.inet => udp.t.payload} (100%)
 delete mode 100644 tests/py/inet/udp.t.payload.ip
 delete mode 100644 tests/py/inet/udp.t.payload.ip6
 delete mode 100644 tests/py/inet/udp.t.payload.netdev
 rename tests/py/inet/{udplite.t.payload.inet => udplite.t.payload} (100%)
 delete mode 100644 tests/py/inet/udplite.t.payload.ip
 delete mode 100644 tests/py/inet/udplite.t.payload.ip6
 delete mode 100644 tests/py/inet/udplite.t.payload.netdev

diff --git a/tests/py/bridge/icmpX.t.payload b/tests/py/bridge/icmpX.t.payload
index b351f7b008b7..77e6a4fbf217 100644
--- a/tests/py/bridge/icmpX.t.payload
+++ b/tests/py/bridge/icmpX.t.payload
@@ -9,9 +9,7 @@ bridge test-bridge input
 
 # icmp type echo-request
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 5fce9c16cd9d..cb0e812f8ec3 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -134,7 +134,7 @@ bridge test-bridge input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -151,7 +151,7 @@ bridge test-bridge input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 45ea2251c934..c57955ec7394 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -160,7 +160,7 @@ netdev test-netdev ingress
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -179,7 +179,7 @@ netdev test-netdev ingress
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
diff --git a/tests/py/inet/ah.t.payload.inet b/tests/py/inet/ah.t.payload
similarity index 100%
rename from tests/py/inet/ah.t.payload.inet
rename to tests/py/inet/ah.t.payload
diff --git a/tests/py/inet/ah.t.payload.ip b/tests/py/inet/ah.t.payload.ip
deleted file mode 100644
index 594c949ff927..000000000000
diff --git a/tests/py/inet/ah.t.payload.ip6 b/tests/py/inet/ah.t.payload.ip6
deleted file mode 100644
index 4d5df6368da4..000000000000
diff --git a/tests/py/inet/ah.t.payload.netdev b/tests/py/inet/ah.t.payload.netdev
deleted file mode 100644
index af150969ad87..000000000000
diff --git a/tests/py/inet/comp.t.payload.inet b/tests/py/inet/comp.t.payload
similarity index 100%
rename from tests/py/inet/comp.t.payload.inet
rename to tests/py/inet/comp.t.payload
diff --git a/tests/py/inet/comp.t.payload.ip b/tests/py/inet/comp.t.payload.ip
deleted file mode 100644
index 9a6194e3bee6..000000000000
diff --git a/tests/py/inet/comp.t.payload.ip6 b/tests/py/inet/comp.t.payload.ip6
deleted file mode 100644
index 3048d822d3f7..000000000000
diff --git a/tests/py/inet/comp.t.payload.netdev b/tests/py/inet/comp.t.payload.netdev
deleted file mode 100644
index dec38aea6c5a..000000000000
diff --git a/tests/py/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload
similarity index 100%
rename from tests/py/inet/dccp.t.payload.inet
rename to tests/py/inet/dccp.t.payload
diff --git a/tests/py/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
deleted file mode 100644
index b8844c573904..000000000000
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
deleted file mode 100644
index 0fa441043a7a..000000000000
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
deleted file mode 100644
index 313693163dca..000000000000
diff --git a/tests/py/inet/esp.t.payload.inet b/tests/py/inet/esp.t.payload
similarity index 100%
rename from tests/py/inet/esp.t.payload.inet
rename to tests/py/inet/esp.t.payload
diff --git a/tests/py/inet/esp.t.payload.ip b/tests/py/inet/esp.t.payload.ip
deleted file mode 100644
index f8ef9ec830f6..000000000000
diff --git a/tests/py/inet/esp.t.payload.ip6 b/tests/py/inet/esp.t.payload.ip6
deleted file mode 100644
index a9ed233c8f5d..000000000000
diff --git a/tests/py/inet/esp.t.payload.netdev b/tests/py/inet/esp.t.payload.netdev
deleted file mode 100644
index ad68530be19a..000000000000
diff --git a/tests/py/inet/ether.t.payload.ip b/tests/py/inet/ether.t.payload.ip
index 2d33f0cecbe9..196930fd8ff5 100644
--- a/tests/py/inet/ether.t.payload.ip
+++ b/tests/py/inet/ether.t.payload.ip
@@ -1,6 +1,6 @@
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -14,7 +14,7 @@ ip test-ip4 input
 
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -26,7 +26,7 @@ ip test-ip4 input
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
diff --git a/tests/py/inet/ether.t.payload.ip6 b/tests/py/inet/ether.t.payload.ip6
deleted file mode 100644
index a3a8905e6372..000000000000
diff --git a/tests/py/inet/icmpX.t.payload b/tests/py/inet/icmpX.t.payload
index 4df15d7fb28c..e951066aa0d6 100644
--- a/tests/py/inet/icmpX.t.payload
+++ b/tests/py/inet/icmpX.t.payload
@@ -9,9 +9,7 @@ inet test-inet input
 
 # icmp type echo-request
 inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/inet/ip.t.payload.ip b/tests/py/inet/ip.t.payload
similarity index 86%
rename from tests/py/inet/ip.t.payload.ip
rename to tests/py/inet/ip.t.payload
index f0ef38bcfc33..589a5cd35a80 100644
--- a/tests/py/inet/ip.t.payload.ip
+++ b/tests/py/inet/ip.t.payload
@@ -1,8 +1,8 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
-__set%d test-ip4 3
-__set%d test-ip4 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
-ip test-ip4 input
+inet test-ip input
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
diff --git a/tests/py/inet/ip.t.payload.inet b/tests/py/inet/ip.t.payload.inet
index e926d03a8e7a..8df41defea0a 100644
--- a/tests/py/inet/ip.t.payload.inet
+++ b/tests/py/inet/ip.t.payload.inet
@@ -11,3 +11,4 @@ inet test-inet input
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
   [ lookup reg 1 set __set%d ]
+
diff --git a/tests/py/inet/map.t.payload.inet b/tests/py/inet/map.t.payload
similarity index 100%
rename from tests/py/inet/map.t.payload.inet
rename to tests/py/inet/map.t.payload
diff --git a/tests/py/inet/map.t.payload.ip b/tests/py/inet/map.t.payload.ip
index dfd571d5ec45..595757496d9f 100644
--- a/tests/py/inet/map.t.payload.ip
+++ b/tests/py/inet/map.t.payload.ip
@@ -1,8 +1,8 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
-__map%d test-ip b
-__map%d test-ip 0
-	element 0103020a  : 00000017 0 [end]	element 0203020a  : 0000002a 0 [end]
-ip test-ip input
+__map%d test-ip4 b
+__map%d test-ip4 0
+	element 0203020a  : 0000002a 0 [end]	element 0103020a  : 00000017 0 [end]
+ip test-ip4 input 
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
@@ -10,8 +10,8 @@ ip test-ip input
 # mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000004  : 00000001 0 [end]	element 00000005  : 00000017 0 [end]
-ip test-ip4 input
+	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
+ip test-ip4 input 
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
diff --git a/tests/py/inet/map.t.payload.netdev b/tests/py/inet/map.t.payload.netdev
index 1457c5daa574..501fb8eec478 100644
--- a/tests/py/inet/map.t.payload.netdev
+++ b/tests/py/inet/map.t.payload.netdev
@@ -1,7 +1,7 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 0103020a  : 00000017 0 [end]	element 0203020a  : 0000002a 0 [end]
+	element 0203020a  : 0000002a 0 [end]	element 0103020a  : 00000017 0 [end]
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/inet/sctp.t.payload.inet b/tests/py/inet/sctp.t.payload
similarity index 100%
rename from tests/py/inet/sctp.t.payload.inet
rename to tests/py/inet/sctp.t.payload
diff --git a/tests/py/inet/sctp.t.payload.ip b/tests/py/inet/sctp.t.payload.ip
deleted file mode 100644
index 4d8a7246fb04..000000000000
diff --git a/tests/py/inet/sctp.t.payload.ip6 b/tests/py/inet/sctp.t.payload.ip6
deleted file mode 100644
index 9775804d55ef..000000000000
diff --git a/tests/py/inet/sctp.t.payload.netdev b/tests/py/inet/sctp.t.payload.netdev
deleted file mode 100644
index ecfcc7252a06..000000000000
diff --git a/tests/py/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload
similarity index 100%
rename from tests/py/inet/tcp.t.payload.inet
rename to tests/py/inet/tcp.t.payload
diff --git a/tests/py/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
deleted file mode 100644
index 79fd500aef37..000000000000
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
deleted file mode 100644
index a335f594cbc2..000000000000
diff --git a/tests/py/inet/tcp.t.payload.netdev b/tests/py/inet/tcp.t.payload.netdev
deleted file mode 100644
index dbf4b131ea45..000000000000
diff --git a/tests/py/inet/tcpopt.t.payload.inet b/tests/py/inet/tcpopt.t.payload
similarity index 100%
rename from tests/py/inet/tcpopt.t.payload.inet
rename to tests/py/inet/tcpopt.t.payload
diff --git a/tests/py/inet/udp.t.payload.inet b/tests/py/inet/udp.t.payload
similarity index 100%
rename from tests/py/inet/udp.t.payload.inet
rename to tests/py/inet/udp.t.payload
diff --git a/tests/py/inet/udp.t.payload.ip b/tests/py/inet/udp.t.payload.ip
deleted file mode 100644
index d49fc513ab66..000000000000
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
deleted file mode 100644
index 8edcff4faa29..000000000000
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
deleted file mode 100644
index ab0f51a499d8..000000000000
diff --git a/tests/py/inet/udplite.t.payload.inet b/tests/py/inet/udplite.t.payload
similarity index 100%
rename from tests/py/inet/udplite.t.payload.inet
rename to tests/py/inet/udplite.t.payload
diff --git a/tests/py/inet/udplite.t.payload.ip b/tests/py/inet/udplite.t.payload.ip
deleted file mode 100644
index c1ecc9d57e7a..000000000000
diff --git a/tests/py/inet/udplite.t.payload.ip6 b/tests/py/inet/udplite.t.payload.ip6
deleted file mode 100644
index d2f032e905e0..000000000000
diff --git a/tests/py/inet/udplite.t.payload.netdev b/tests/py/inet/udplite.t.payload.netdev
deleted file mode 100644
index 565935a27e90..000000000000
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 7a7f5a82dd5a..1b869d0a002e 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -2,7 +2,7 @@
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00005000 ]
@@ -14,7 +14,7 @@ ip test-ip4 prerouting
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00005000 0x00005a00 ]
@@ -28,7 +28,7 @@ __set%d test-ip4 0
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -42,7 +42,7 @@ __set%d test-ip4 0
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -53,7 +53,7 @@ ip test-ip4 prerouting
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00001700 0x00002200 ]
@@ -64,7 +64,7 @@ ip test-ip4 prerouting
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00005100 ]
diff --git a/tests/py/ip/ether.t.payload b/tests/py/ip/ether.t.payload
index 0d234dab1a5b..bd7c8f150632 100644
--- a/tests/py/ip/ether.t.payload
+++ b/tests/py/ip/ether.t.payload
@@ -1,6 +1,6 @@
 # tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -14,7 +14,7 @@ ip test-ip input
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -27,7 +27,7 @@ ip test-ip input
 
 # tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 1130b9841b31..f959cf338295 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -1,6 +1,6 @@
 # icmp type echo-reply accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
@@ -8,7 +8,7 @@ ip test-ip4 input
 
 # icmp type destination-unreachable accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000003 ]
@@ -16,7 +16,7 @@ ip test-ip4 input
 
 # icmp type source-quench accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000004 ]
@@ -24,7 +24,7 @@ ip test-ip4 input
 
 # icmp type redirect accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000005 ]
@@ -32,7 +32,7 @@ ip test-ip4 input
 
 # icmp type echo-request accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -40,7 +40,7 @@ ip test-ip4 input
 
 # icmp type time-exceeded accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000000b ]
@@ -48,7 +48,7 @@ ip test-ip4 input
 
 # icmp type parameter-problem accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000000c ]
@@ -56,7 +56,7 @@ ip test-ip4 input
 
 # icmp type timestamp-request accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000000d ]
@@ -64,7 +64,7 @@ ip test-ip4 input
 
 # icmp type timestamp-reply accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000000e ]
@@ -72,7 +72,7 @@ ip test-ip4 input
 
 # icmp type info-request accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000000f ]
@@ -80,7 +80,7 @@ ip test-ip4 input
 
 # icmp type info-reply accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000010 ]
@@ -88,7 +88,7 @@ ip test-ip4 input
 
 # icmp type address-mask-request accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
@@ -96,7 +96,7 @@ ip test-ip4 input
 
 # icmp type address-mask-reply accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000012 ]
@@ -107,7 +107,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000000  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000008  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]	element 0000000d  : 0 [end]	element 0000000e  : 0 [end]	element 0000000f  : 0 [end]	element 00000010  : 0 [end]	element 00000011  : 0 [end]	element 00000012  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -118,14 +118,14 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000000  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp code 111 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp eq reg 1 0x0000006f ]
@@ -133,7 +133,7 @@ ip test-ip4 input
 
 # icmp code != 111 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp neq reg 1 0x0000006f ]
@@ -141,7 +141,7 @@ ip test-ip4 input
 
 # icmp code 33-55
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
@@ -149,7 +149,7 @@ ip test-ip4 input
 
 # icmp code != 33-55
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x00000037 ]
@@ -159,7 +159,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -169,7 +169,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -179,7 +179,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000036  : 0 [end]	element 00000021  : 0 [end]	element 00000038  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -189,14 +189,14 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000036  : 0 [end]	element 00000021  : 0 [end]	element 00000038  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp checksum 12343 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003730 ]
@@ -204,7 +204,7 @@ ip test-ip4 input
 
 # icmp checksum != 12343 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x00003730 ]
@@ -212,7 +212,7 @@ ip test-ip4 input
 
 # icmp checksum 11-343 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00000b00 ]
@@ -221,7 +221,7 @@ ip test-ip4 input
 
 # icmp checksum != 11-343 accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00000b00 0x00005701 ]
@@ -232,7 +232,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -243,7 +243,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -254,7 +254,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -265,7 +265,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -273,7 +273,7 @@ ip test-ip4 input
 
 # icmp id 1245 log
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x0000dd04 ]
@@ -281,21 +281,21 @@ ip test-ip4 input
 
 # icmp id 22
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # icmp id != 233
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # icmp id 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -303,7 +303,7 @@ ip test-ip4 input
 
 # icmp id != 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -313,7 +313,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -323,7 +323,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -333,7 +333,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -343,28 +343,28 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp sequence 22
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # icmp sequence != 233
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # icmp sequence 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -372,7 +372,7 @@ ip test-ip4 input
 
 # icmp sequence != 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -382,7 +382,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -392,7 +392,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -402,7 +402,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -412,21 +412,21 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp mtu 33
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00002100 ]
 
 # icmp mtu 22-33
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00001600 ]
@@ -437,7 +437,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001600  : 0 [end]	element 00002200  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -447,28 +447,28 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001600  : 0 [end]	element 00002200  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp mtu 22
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # icmp mtu != 233
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # icmp mtu 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -476,7 +476,7 @@ ip test-ip4 input
 
 # icmp mtu != 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -486,7 +486,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -496,7 +496,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -506,7 +506,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -516,28 +516,28 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp gateway 22
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # icmp gateway != 233
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0xe9000000 ]
 
 # icmp gateway 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
@@ -545,7 +545,7 @@ ip test-ip4 input
 
 # icmp gateway != 33-45
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
@@ -555,7 +555,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -565,7 +565,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -575,7 +575,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -585,14 +585,14 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp gateway != 34
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0x22000000 ]
@@ -602,14 +602,14 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 4d010000  : 0 [end]	element 4e010000  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp type router-advertisement accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000009 ]
@@ -617,7 +617,7 @@ ip test-ip4 input
 
 # icmp type router-solicitation accept
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -628,7 +628,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000000  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000008  : 0 [end]     element 0000000b  : 0 [end]     element 0000000c  : 0 [end]     element 0000000d  : 0 [end]     element 0000000e  : 0 [end]     element 0000000f  : 0 [end]     element 00000010  : 0 [end]     element 00000011  : 0 [end]     element 00000012  : 0 [end]     element 00000009  : 0 [end]     element 0000000a  : 0 [end]
 ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index ad0ea518ed53..43ac7f70648a 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -1,6 +1,6 @@
 # udp dport 53 masquerade
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -8,7 +8,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade random
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -16,7 +16,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade random,persistent
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -24,7 +24,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade random,persistent,fully-random
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -32,7 +32,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade random,fully-random
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -40,7 +40,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade random,fully-random,persistent
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -48,7 +48,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade persistent
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -56,7 +56,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade persistent,random
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -64,7 +64,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade persistent,random,fully-random
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -72,7 +72,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade persistent,fully-random
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -80,7 +80,7 @@ ip test-ip4 postrouting
 
 # udp dport 53 masquerade persistent,fully-random,random
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -91,7 +91,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip test-ip4 postrouting
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -102,7 +102,7 @@ ip test-ip4 postrouting
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0000000a ]
   [ cmp lte reg 1 0x0403020a ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -119,7 +119,7 @@ ip test-ip4 postrouting
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
index 6499d36348fe..7f16c5ac599e 100644
--- a/tests/py/ip/objects.t.payload
+++ b/tests/py/ip/objects.t.payload
@@ -9,7 +9,7 @@ __objmap%d test-ip4 43
 __objmap%d test-ip4 0
 	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
 ip test-ip4 output 
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d id 1 ]
@@ -25,7 +25,7 @@ __objmap%d test-ip4 43
 __objmap%d test-ip4 0
 	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
 ip test-ip4 output 
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d id 1 ]
@@ -39,7 +39,7 @@ __objmap%d test-ip4 43
 __objmap%d test-ip4 0
         element 00001500  : 0 [end]     element 00004908  : 0 [end]
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d id 1 ]
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index 1f050bfe186e..a5d0f0dc111f 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -1,6 +1,6 @@
 # udp dport 53 redirect
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -8,7 +8,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -16,7 +16,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect random,persistent
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -24,7 +24,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect random,persistent,fully-random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -32,7 +32,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect random,fully-random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -40,7 +40,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect random,fully-random,persistent
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -48,7 +48,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect persistent
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -56,7 +56,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect persistent,random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -64,7 +64,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect persistent,random,fully-random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -72,7 +72,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect persistent,fully-random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -80,7 +80,7 @@ ip test-ip4 output
 
 # udp dport 53 redirect persistent,fully-random,random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -88,7 +88,7 @@ ip test-ip4 output
 
 # tcp dport 22 redirect to :22
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -97,7 +97,7 @@ ip test-ip4 output
 
 # udp dport 1234 redirect to :4321
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d204 ]
@@ -108,7 +108,7 @@ ip test-ip4 output
 ip test-ip4 output
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x010010ac ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000e27 ]
@@ -117,7 +117,7 @@ ip test-ip4 output
 
 # tcp dport 39128 redirect to :993
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d898 ]
@@ -134,7 +134,7 @@ ip test-ip4 output
 
 # tcp dport 9128 redirect to :993 random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
@@ -143,7 +143,7 @@ ip test-ip4 output
 
 # tcp dport 9128 redirect to :993 fully-random
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
@@ -152,7 +152,7 @@ ip test-ip4 output
 
 # tcp dport 9128 redirect to :123 persistent
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
@@ -161,7 +161,7 @@ ip test-ip4 output
 
 # tcp dport 9128 redirect to :123 random,persistent
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
@@ -173,7 +173,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -184,7 +184,7 @@ ip test-ip4 output
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0000000a ]
   [ cmp lte reg 1 0x0403020a ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -201,7 +201,7 @@ ip test-ip4 output
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/ip/reject.t.payload b/tests/py/ip/reject.t.payload
index ec94b4c1a1c5..07e4cc8d71a0 100644
--- a/tests/py/ip/reject.t.payload
+++ b/tests/py/ip/reject.t.payload
@@ -32,7 +32,7 @@ ip test-ip4 output
 
 # mark 0x80000000 reject with tcp reset
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ meta load mark => reg 1 ]
   [ cmp eq reg 1 0x80000000 ]
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 25a505c2112a..789933ffd650 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -2,7 +2,7 @@
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00005000 ]
@@ -14,7 +14,7 @@ ip test-ip4 postrouting
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00005000 0x00005a00 ]
@@ -28,7 +28,7 @@ __set%d test-ip4 0
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -42,7 +42,7 @@ __set%d test-ip4 0
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -53,7 +53,7 @@ ip test-ip4 postrouting
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00001700 0x00002200 ]
diff --git a/tests/py/ip/tcp.t.payload b/tests/py/ip/tcp.t.payload
index ed0dcc8481ee..58956d984b1b 100644
--- a/tests/py/ip/tcp.t.payload
+++ b/tests/py/ip/tcp.t.payload
@@ -10,7 +10,7 @@ ip test-ip input
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp neq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
diff --git a/tests/py/ip/tcpopt.t.payload b/tests/py/ip/tcpopt.t.payload
index 3e1d4ad1fcef..b2e5bdb29d1c 100644
--- a/tests/py/ip/tcpopt.t.payload
+++ b/tests/py/ip/tcpopt.t.payload
@@ -1,181 +1,181 @@
 # tcp option eol kind 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option noop kind 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg kind 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg length 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg size 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
 
 # tcp option window kind 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window length 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window count 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack-permitted kind 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack-permitted length 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack kind 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack length 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack left 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack0 left 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack1 left 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack2 left 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack3 left 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack right 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack0 right 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack1 right 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack2 right 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack3 right 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option timestamp kind 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp length 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp tsval 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option timestamp tsecr 1
 ip test-ip input
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
-- 
2.10.2

