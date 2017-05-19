From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 7/7] tests: fix up meta l4proto change for ip family
Date: Fri, 19 May 2017 22:11:11 +0200
Message-ID: <20170519201111.7402-8-fw@strlen.de>
References: <20170519201111.7402-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34056 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755022AbdESULT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 16:11:19 -0400
In-Reply-To: <20170519201111.7402-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can delete some of the payload files now as ip/ip6/inet produce
same implicit meta l4proto dep.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 changes since v2: keep icmp ipv4 dependencies in the
 inet/bridge/netdev families.

 tests/py/bridge/icmpX.t                            |   2 +-
 tests/py/bridge/icmpX.t.payload                    |   2 +-
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
 tests/py/inet/icmpX.t                              |   2 +-
 tests/py/inet/icmpX.t.payload                      |   2 +-
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
 56 files changed, 176 insertions(+), 6881 deletions(-)
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

diff --git a/tests/py/bridge/icmpX.t b/tests/py/bridge/icmpX.t
index 5c76c0f70bd0..0a1019c3a309 100644
--- a/tests/py/bridge/icmpX.t
+++ b/tests/py/bridge/icmpX.t
@@ -3,6 +3,6 @@
 *bridge;test-bridge;input
 
 ip protocol icmp icmp type echo-request;ok;icmp type echo-request
-icmp type echo-request;ok
+icmp type echo-request;ok;ether type ip meta l4proto 1 icmp type echo-request
 ip6 nexthdr icmpv6 icmpv6 type echo-request;ok;icmpv6 type echo-request
 icmpv6 type echo-request;ok;ether type ip6 meta l4proto 58 icmpv6 type echo-request
diff --git a/tests/py/bridge/icmpX.t.payload b/tests/py/bridge/icmpX.t.payload
index 548cdaa56d82..0fab1abf61ea 100644
--- a/tests/py/bridge/icmpX.t.payload
+++ b/tests/py/bridge/icmpX.t.payload
@@ -11,7 +11,7 @@ bridge test-bridge input
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
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
--- a/tests/py/inet/ah.t.payload.ip
+++ /dev/null
@@ -1,262 +0,0 @@
-# ah hdrlength 11-23
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x0000000b ]
-  [ cmp lte reg 1 0x00000017 ]
-
-# ah hdrlength != 11-23
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x0000000b 0x00000017 ]
-
-# ah hdrlength { 11-23}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah hdrlength != { 11-23}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah hdrlength {11, 23, 44 }
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah hdrlength != {11, 23, 44 }
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah reserved 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ah reserved != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# ah reserved 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# ah reserved != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# ah reserved {23, 100}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah reserved != {23, 100}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah reserved { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah reserved != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah spi 111
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x6f000000 ]
-
-# ah spi != 111
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x6f000000 ]
-
-# ah spi 111-222
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
-
-# ah spi != 111-222
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
-
-# ah spi {111, 122}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah spi != {111, 122}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah spi { 111-122}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah spi != { 111-122}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence 123
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x7b000000 ]
-
-# ah sequence != 123
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x7b000000 ]
-
-# ah sequence {23, 25, 33}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah sequence != {23, 25, 33}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence { 23-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah sequence != { 23-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence 23-33
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x17000000 ]
-  [ cmp lte reg 1 0x21000000 ]
-
-# ah sequence != 23-33
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x17000000 0x21000000 ]
-
diff --git a/tests/py/inet/ah.t.payload.ip6 b/tests/py/inet/ah.t.payload.ip6
deleted file mode 100644
index 4d5df6368da4..000000000000
--- a/tests/py/inet/ah.t.payload.ip6
+++ /dev/null
@@ -1,262 +0,0 @@
-# ah hdrlength 11-23
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x0000000b ]
-  [ cmp lte reg 1 0x00000017 ]
-
-# ah hdrlength != 11-23
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x0000000b 0x00000017 ]
-
-# ah hdrlength { 11-23}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah hdrlength != { 11-23}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah hdrlength {11, 23, 44 }
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah hdrlength != {11, 23, 44 }
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah reserved 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ah reserved != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# ah reserved 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# ah reserved != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# ah reserved {23, 100}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah reserved != {23, 100}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah reserved { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah reserved != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah spi 111
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x6f000000 ]
-
-# ah spi != 111
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x6f000000 ]
-
-# ah spi 111-222
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
-
-# ah spi != 111-222
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
-
-# ah spi {111, 122}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah spi != {111, 122}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah spi { 111-122}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah spi != { 111-122}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence 123
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x7b000000 ]
-
-# ah sequence != 123
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x7b000000 ]
-
-# ah sequence {23, 25, 33}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah sequence != {23, 25, 33}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence { 23-33}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah sequence != { 23-33}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence 23-33
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x17000000 ]
-  [ cmp lte reg 1 0x21000000 ]
-
-# ah sequence != 23-33
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x17000000 0x21000000 ]
-
diff --git a/tests/py/inet/ah.t.payload.netdev b/tests/py/inet/ah.t.payload.netdev
deleted file mode 100644
index af150969ad87..000000000000
--- a/tests/py/inet/ah.t.payload.netdev
+++ /dev/null
@@ -1,262 +0,0 @@
-# ah hdrlength 11-23
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x0000000b ]
-  [ cmp lte reg 1 0x00000017 ]
-
-# ah hdrlength != 11-23
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x0000000b 0x00000017 ]
-
-# ah hdrlength { 11-23}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah hdrlength != { 11-23}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah hdrlength {11, 23, 44 }
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah hdrlength != {11, 23, 44 }
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah reserved 22
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ah reserved != 233
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# ah reserved 33-45
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# ah reserved != 33-45
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# ah reserved {23, 100}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah reserved != {23, 100}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 00001700  : 0 [end]	element 00006400  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah reserved { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah reserved != { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah spi 111
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x6f000000 ]
-
-# ah spi != 111
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x6f000000 ]
-
-# ah spi 111-222
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
-
-# ah spi != 111-222
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
-
-# ah spi {111, 122}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah spi != {111, 122}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah spi { 111-122}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah spi != { 111-122}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence 123
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x7b000000 ]
-
-# ah sequence != 123
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x7b000000 ]
-
-# ah sequence {23, 25, 33}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah sequence != {23, 25, 33}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence { 23-33}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah sequence != { 23-33}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# ah sequence 23-33
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x17000000 ]
-  [ cmp lte reg 1 0x21000000 ]
-
-# ah sequence != 23-33
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x17000000 0x21000000 ]
-
diff --git a/tests/py/inet/comp.t.payload.inet b/tests/py/inet/comp.t.payload
similarity index 100%
rename from tests/py/inet/comp.t.payload.inet
rename to tests/py/inet/comp.t.payload
diff --git a/tests/py/inet/comp.t.payload.ip b/tests/py/inet/comp.t.payload.ip
deleted file mode 100644
index 9a6194e3bee6..000000000000
--- a/tests/py/inet/comp.t.payload.ip
+++ /dev/null
@@ -1,145 +0,0 @@
-# comp nexthdr != esp
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000032 ]
-
-# comp flags 0x0
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# comp flags != 0x23
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp neq reg 1 0x00000023 ]
-
-# comp flags 0x33-0x45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000033 ]
-  [ cmp lte reg 1 0x00000045 ]
-
-# comp flags != 0x33-0x45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x00000033 0x00000045 ]
-
-# comp flags {0x33, 0x55, 0x67, 0x88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp flags != {0x33, 0x55, 0x67, 0x88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp flags { 0x33-0x55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp flags != { 0x33-0x55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp cpi 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# comp cpi != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# comp cpi 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# comp cpi != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# comp cpi {33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp cpi != {33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp cpi { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp cpi != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/comp.t.payload.ip6 b/tests/py/inet/comp.t.payload.ip6
deleted file mode 100644
index 3048d822d3f7..000000000000
--- a/tests/py/inet/comp.t.payload.ip6
+++ /dev/null
@@ -1,145 +0,0 @@
-# comp nexthdr != esp
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000032 ]
-
-# comp flags 0x0
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# comp flags != 0x23
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp neq reg 1 0x00000023 ]
-
-# comp flags 0x33-0x45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000033 ]
-  [ cmp lte reg 1 0x00000045 ]
-
-# comp flags != 0x33-0x45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x00000033 0x00000045 ]
-
-# comp flags {0x33, 0x55, 0x67, 0x88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp flags != {0x33, 0x55, 0x67, 0x88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp flags { 0x33-0x55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp flags != { 0x33-0x55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp cpi 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# comp cpi != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# comp cpi 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# comp cpi != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# comp cpi {33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp cpi != {33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp cpi { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp cpi != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/comp.t.payload.netdev b/tests/py/inet/comp.t.payload.netdev
deleted file mode 100644
index dec38aea6c5a..000000000000
--- a/tests/py/inet/comp.t.payload.netdev
+++ /dev/null
@@ -1,145 +0,0 @@
-# comp nexthdr != esp
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000032 ]
-
-# comp flags 0x0
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# comp flags != 0x23
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp neq reg 1 0x00000023 ]
-
-# comp flags 0x33-0x45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000033 ]
-  [ cmp lte reg 1 0x00000045 ]
-
-# comp flags != 0x33-0x45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ range neq reg 1 0x00000033 0x00000045 ]
-
-# comp flags {0x33, 0x55, 0x67, 0x88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp flags != {0x33, 0x55, 0x67, 0x88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp flags { 0x33-0x55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp flags != { 0x33-0x55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp cpi 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# comp cpi != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# comp cpi 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# comp cpi != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# comp cpi {33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp cpi != {33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# comp cpi { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp cpi != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload
similarity index 100%
rename from tests/py/inet/dccp.t.payload.inet
rename to tests/py/inet/dccp.t.payload
diff --git a/tests/py/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
deleted file mode 100644
index b8844c573904..000000000000
--- a/tests/py/inet/dccp.t.payload.ip
+++ /dev/null
@@ -1,169 +0,0 @@
-# dccp sport 21-35
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001500 ]
-  [ cmp lte reg 1 0x00002300 ]
-
-# dccp sport != 21-35
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001500 0x00002300 ]
-
-# dccp sport {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp sport { 20-50 }
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != { 20-50 }
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp sport ftp-data - re-mail-ck
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
-
-# dccp sport 20-50
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
-
-# dccp sport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp dport {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp dport != {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp dport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp dport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp type request
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# dccp type != request
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
-
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
deleted file mode 100644
index 0fa441043a7a..000000000000
--- a/tests/py/inet/dccp.t.payload.ip6
+++ /dev/null
@@ -1,169 +0,0 @@
-# dccp sport 21-35
-ip test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001500 ]
-  [ cmp lte reg 1 0x00002300 ]
-
-# dccp sport != 21-35
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001500 0x00002300 ]
-
-# dccp sport {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp sport { 20-50 }
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != { 20-50 }
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp sport ftp-data - re-mail-ck
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
-
-# dccp sport 20-50
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
-
-# dccp sport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp dport {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp dport != {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp dport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp dport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp type request
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# dccp type != request
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
-
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
deleted file mode 100644
index 313693163dca..000000000000
--- a/tests/py/inet/dccp.t.payload.netdev
+++ /dev/null
@@ -1,169 +0,0 @@
-# dccp sport 21-35
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001500 ]
-  [ cmp lte reg 1 0x00002300 ]
-
-# dccp sport != 21-35
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001500 0x00002300 ]
-
-# dccp sport {23, 24, 25}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != {23, 24, 25}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp sport { 20-50 }
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != { 20-50 }
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp sport ftp-data - re-mail-ck
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
-
-# dccp sport 20-50
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
-
-# dccp sport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp dport {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp dport != {23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp dport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp dport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
-netdev test-netdev ingress
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
-netdev test-netdev ingress
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# dccp type request
-netdev test-netdev ingress
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# dccp type != request
-netdev test-netdev ingress
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
-
diff --git a/tests/py/inet/esp.t.payload.inet b/tests/py/inet/esp.t.payload
similarity index 100%
rename from tests/py/inet/esp.t.payload.inet
rename to tests/py/inet/esp.t.payload
diff --git a/tests/py/inet/esp.t.payload.ip b/tests/py/inet/esp.t.payload.ip
deleted file mode 100644
index f8ef9ec830f6..000000000000
--- a/tests/py/inet/esp.t.payload.ip
+++ /dev/null
@@ -1,131 +0,0 @@
-# esp spi 100
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x64000000 ]
-
-# esp spi != 100
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x64000000 ]
-
-# esp spi 111-222
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
-
-# esp spi != 111-222
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
-
-# esp spi { 100, 102}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp spi != { 100, 102}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp spi { 100-102}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp spi != { 100-102}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp sequence 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# esp sequence 22-24
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x16000000 ]
-  [ cmp lte reg 1 0x18000000 ]
-
-# esp sequence != 22-24
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x16000000 0x18000000 ]
-
-# esp sequence { 22, 24}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp sequence != { 22, 24}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp sequence { 22-25}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp sequence != { 22-25}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/esp.t.payload.ip6 b/tests/py/inet/esp.t.payload.ip6
deleted file mode 100644
index a9ed233c8f5d..000000000000
--- a/tests/py/inet/esp.t.payload.ip6
+++ /dev/null
@@ -1,131 +0,0 @@
-# esp spi 100
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x64000000 ]
-
-# esp spi != 100
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x64000000 ]
-
-# esp spi 111-222
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
-
-# esp spi != 111-222
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
-
-# esp spi { 100, 102}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp spi != { 100, 102}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp spi { 100-102}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp spi != { 100-102}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp sequence 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# esp sequence 22-24
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x16000000 ]
-  [ cmp lte reg 1 0x18000000 ]
-
-# esp sequence != 22-24
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x16000000 0x18000000 ]
-
-# esp sequence { 22, 24}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp sequence != { 22, 24}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp sequence { 22-25}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp sequence != { 22-25}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/esp.t.payload.netdev b/tests/py/inet/esp.t.payload.netdev
deleted file mode 100644
index ad68530be19a..000000000000
--- a/tests/py/inet/esp.t.payload.netdev
+++ /dev/null
@@ -1,131 +0,0 @@
-# esp spi 100
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x64000000 ]
-
-# esp spi != 100
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x64000000 ]
-
-# esp spi 111-222
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
-
-# esp spi != 111-222
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x6f000000 0xde000000 ]
-
-# esp spi { 100, 102}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp spi != { 100, 102}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 64000000  : 0 [end]	element 66000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp spi { 100-102}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp spi != { 100-102}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp sequence 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# esp sequence 22-24
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x16000000 ]
-  [ cmp lte reg 1 0x18000000 ]
-
-# esp sequence != 22-24
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x16000000 0x18000000 ]
-
-# esp sequence { 22, 24}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp sequence != { 22, 24}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 16000000  : 0 [end]	element 18000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# esp sequence { 22-25}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp sequence != { 22-25}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
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
--- a/tests/py/inet/ether.t.payload.ip6
+++ /dev/null
@@ -1,55 +0,0 @@
-# tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ immediate reg 0 accept ]
-
-# tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ immediate reg 0 accept ]
-
-# tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ immediate reg 0 accept ]
-
-# ether saddr 00:0f:54:0c:11:04 accept
-ip6 test-ip6 input
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ immediate reg 0 accept ]
-
-# ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4
-ip6 test-ip6 input
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-
diff --git a/tests/py/inet/icmpX.t b/tests/py/inet/icmpX.t
index b95f58c499eb..7617e701a6d7 100644
--- a/tests/py/inet/icmpX.t
+++ b/tests/py/inet/icmpX.t
@@ -3,6 +3,6 @@
 *inet;test-inet;input
 
 ip protocol icmp icmp type echo-request;ok;icmp type echo-request
-icmp type echo-request;ok
+icmp type echo-request;ok;meta nfproto ipv4 meta l4proto 1 icmp type echo-request
 ip6 nexthdr icmpv6 icmpv6 type echo-request;ok;icmpv6 type echo-request
 icmpv6 type echo-request;ok;meta nfproto ipv6 meta l4proto 58 icmpv6 type echo-request
diff --git a/tests/py/inet/icmpX.t.payload b/tests/py/inet/icmpX.t.payload
index 2ff5b0ec36d6..7c5f6f011d11 100644
--- a/tests/py/inet/icmpX.t.payload
+++ b/tests/py/inet/icmpX.t.payload
@@ -11,7 +11,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
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
--- a/tests/py/inet/sctp.t.payload.ip
+++ /dev/null
@@ -1,276 +0,0 @@
-# sctp sport 23
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
-
-# sctp sport != 23
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
-
-# sctp sport 23-44
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
-
-# sctp sport != 23-44
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
-
-# sctp sport { 23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp sport != { 23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp sport { 23-44}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp sport != { 23-44}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp dport 23
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
-
-# sctp dport != 23
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
-
-# sctp dport 23-44
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
-
-# sctp dport != 23-44
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
-
-# sctp dport { 23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp dport != { 23, 24, 25}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp dport { 23-44}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp dport != { 23-44}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp checksum 1111
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x57040000 ]
-
-# sctp checksum != 11
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x0b000000 ]
-
-# sctp checksum 21-333
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x15000000 ]
-  [ cmp lte reg 1 0x4d010000 ]
-
-# sctp checksum != 32-111
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x20000000 0x6f000000 ]
-
-# sctp checksum { 22, 33, 44}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp checksum != { 22, 33, 44}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp checksum { 22-44}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp checksum != { 22-44}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp vtag 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# sctp vtag != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# sctp vtag 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# sctp vtag != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# sctp vtag {33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp vtag != {33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp vtag { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp vtag != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/sctp.t.payload.ip6 b/tests/py/inet/sctp.t.payload.ip6
deleted file mode 100644
index 9775804d55ef..000000000000
--- a/tests/py/inet/sctp.t.payload.ip6
+++ /dev/null
@@ -1,276 +0,0 @@
-# sctp sport 23
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
-
-# sctp sport != 23
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
-
-# sctp sport 23-44
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
-
-# sctp sport != 23-44
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
-
-# sctp sport { 23, 24, 25}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp sport != { 23, 24, 25}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp sport { 23-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp sport != { 23-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp dport 23
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
-
-# sctp dport != 23
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
-
-# sctp dport 23-44
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
-
-# sctp dport != 23-44
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
-
-# sctp dport { 23, 24, 25}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp dport != { 23, 24, 25}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp dport { 23-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp dport != { 23-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp checksum 1111
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x57040000 ]
-
-# sctp checksum != 11
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x0b000000 ]
-
-# sctp checksum 21-333
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x15000000 ]
-  [ cmp lte reg 1 0x4d010000 ]
-
-# sctp checksum != 32-111
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x20000000 0x6f000000 ]
-
-# sctp checksum { 22, 33, 44}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp checksum != { 22, 33, 44}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp checksum { 22-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp checksum != { 22-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp vtag 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# sctp vtag != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# sctp vtag 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# sctp vtag != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# sctp vtag {33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp vtag != {33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp vtag { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp vtag != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/sctp.t.payload.netdev b/tests/py/inet/sctp.t.payload.netdev
deleted file mode 100644
index ecfcc7252a06..000000000000
--- a/tests/py/inet/sctp.t.payload.netdev
+++ /dev/null
@@ -1,276 +0,0 @@
-# sctp sport 23
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
-
-# sctp sport != 23
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
-
-# sctp sport 23-44
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
-
-# sctp sport != 23-44
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
-
-# sctp sport { 23, 24, 25}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp sport != { 23, 24, 25}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp sport { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp sport != { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp dport 23
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001700 ]
-
-# sctp dport != 23
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00001700 ]
-
-# sctp dport 23-44
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
-
-# sctp dport != 23-44
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00001700 0x00002c00 ]
-
-# sctp dport { 23, 24, 25}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp dport != { 23, 24, 25}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp dport { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp dport != { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp checksum 1111
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x57040000 ]
-
-# sctp checksum != 11
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0x0b000000 ]
-
-# sctp checksum 21-333
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x15000000 ]
-  [ cmp lte reg 1 0x4d010000 ]
-
-# sctp checksum != 32-111
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x20000000 0x6f000000 ]
-
-# sctp checksum { 22, 33, 44}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp checksum != { 22, 33, 44}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp checksum { 22-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp checksum != { 22-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp vtag 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# sctp vtag != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# sctp vtag 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# sctp vtag != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# sctp vtag {33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp vtag != {33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# sctp vtag { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp vtag != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload
similarity index 100%
rename from tests/py/inet/tcp.t.payload.inet
rename to tests/py/inet/tcp.t.payload
diff --git a/tests/py/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
deleted file mode 100644
index 79fd500aef37..000000000000
--- a/tests/py/inet/tcp.t.payload.ip
+++ /dev/null
@@ -1,661 +0,0 @@
-# tcp dport 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp dport != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp dport 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp dport != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp dport { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp dport { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp dport {telnet, http, https} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# tcp dport vmap { 22 : accept, 23 : drop }
-__map%d test-ip4 b
-__map%d test-ip4 0
-	element 00001600  : 0 [end]	element 00001700  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp dport vmap { 25:accept, 28:drop }
-__map%d test-ip4 b
-__map%d test-ip4 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp dport { 22, 53, 80, 110 }
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 22, 53, 80, 110 }
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp sport != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp sport 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp sport != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp sport { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sport != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sport != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport vmap { 25:accept, 28:drop }
-__map%d test-ip4 b
-__map%d test-ip4 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp sport 8080 drop
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000901f ]
-  [ immediate reg 0 drop ]
-
-# tcp sport 1024 tcp dport 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 ]
-
-# tcp sport 1024 tcp dport 22 tcp sequence 0
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 8b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 0x00000000 ]
-
-# tcp sequence 0 tcp sport 1024 tcp dport 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 8b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 0x00000000 ]
-
-# tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 6b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 0x00000000 ]
-
-# tcp sequence 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# tcp sequence != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# tcp sequence 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# tcp sequence != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# tcp sequence { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sequence != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sequence { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sequence != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp ackseq 42949672 drop
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x285c8f02 ]
-  [ immediate reg 0 drop ]
-
-# tcp ackseq 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# tcp ackseq != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# tcp ackseq 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# tcp ackseq != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# tcp ackseq { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp ackseq != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp ackseq { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp ackseq != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# tcp flags != { fin, urg, ecn, cwr} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 drop ]
-
-# tcp flags cwr
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
-
-# tcp flags != cwr
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ cmp neq reg 1 0x00000080 ]
-
-# tcp 'flags & (syn|fin) == (syn|fin)'
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000003 ]
-
-# tcp window 22222
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0000ce56 ]
-
-# tcp window 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp window != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp window 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp window != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp window { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp window != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp window { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp window != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp checksum 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp checksum != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp checksum 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp checksum != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp checksum { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp checksum != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp checksum { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp checksum != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp urgptr 1234 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000d204 ]
-  [ immediate reg 0 accept ]
-
-# tcp urgptr 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp urgptr != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp urgptr 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp urgptr != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp urgptr { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp urgptr != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp urgptr { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp urgptr != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp doff 8
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000080 ]
-
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
deleted file mode 100644
index a335f594cbc2..000000000000
--- a/tests/py/inet/tcp.t.payload.ip6
+++ /dev/null
@@ -1,661 +0,0 @@
-# tcp dport 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp dport != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp dport 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp dport != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp dport { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp dport { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp dport {telnet, http, https} accept
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# tcp dport vmap { 22 : accept, 23 : drop }
-__map%d test-ip6 b
-__map%d test-ip6 0
-	element 00001600  : 0 [end]	element 00001700  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp dport vmap { 25:accept, 28:drop }
-__map%d test-ip6 b
-__map%d test-ip6 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp dport { 22, 53, 80, 110 }
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 22, 53, 80, 110 }
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp sport != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp sport 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp sport != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp sport { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sport != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sport != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport vmap { 25:accept, 28:drop }
-__map%d test-ip6 b
-__map%d test-ip6 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp sport 8080 drop
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000901f ]
-  [ immediate reg 0 drop ]
-
-# tcp sport 1024 tcp dport 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 ]
-
-# tcp sport 1024 tcp dport 22 tcp sequence 0
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 8b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 0x00000000 ]
-
-# tcp sequence 0 tcp sport 1024 tcp dport 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 8b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 0x00000000 ]
-
-# tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 6b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 0x00000000 ]
-
-# tcp sequence 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# tcp sequence != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# tcp sequence 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# tcp sequence != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# tcp sequence { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sequence != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sequence { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sequence != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp ackseq 42949672 drop
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x285c8f02 ]
-  [ immediate reg 0 drop ]
-
-# tcp ackseq 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# tcp ackseq != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# tcp ackseq 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# tcp ackseq != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# tcp ackseq { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp ackseq != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp ackseq { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp ackseq != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# tcp flags != { fin, urg, ecn, cwr} drop
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 drop ]
-
-# tcp flags cwr
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
-
-# tcp flags != cwr
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ cmp neq reg 1 0x00000080 ]
-
-# tcp 'flags & (syn|fin) == (syn|fin)'
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000003 ]
-
-# tcp window 22222
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0000ce56 ]
-
-# tcp window 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp window != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp window 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp window != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp window { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp window != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp window { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp window != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp checksum 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp checksum != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp checksum 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp checksum != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp checksum { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp checksum != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp checksum { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp checksum != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp urgptr 1234 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000d204 ]
-  [ immediate reg 0 accept ]
-
-# tcp urgptr 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp urgptr != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp urgptr 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp urgptr != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp urgptr { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp urgptr != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp urgptr { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp urgptr != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp doff 8
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000080 ]
-
diff --git a/tests/py/inet/tcp.t.payload.netdev b/tests/py/inet/tcp.t.payload.netdev
deleted file mode 100644
index dbf4b131ea45..000000000000
--- a/tests/py/inet/tcp.t.payload.netdev
+++ /dev/null
@@ -1,669 +0,0 @@
-# tcp dport 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp dport != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp dport 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp dport != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp dport { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp dport { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp dport {telnet, http, https} accept
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# tcp dport vmap { 22 : accept, 23 : drop }
-__map%d test-inet b
-__map%d test-inet 0
-	element 00001600  : 0 [end]	element 00001700  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp dport vmap { 25:accept, 28:drop }
-__map%d test-inet b
-__map%d test-inet 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp dport { 22, 53, 80, 110 }
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 22, 53, 80, 110 }
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp sport != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp sport 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp sport != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp sport { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sport != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sport != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sport vmap { 25:accept, 28:drop }
-__map%d test-inet b
-__map%d test-inet 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
-# tcp sport 8080 drop
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000901f ]
-  [ immediate reg 0 drop ]
-
-# tcp sport 1024 tcp dport 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 ]
-
-# tcp sport 1024 tcp dport 22 tcp sequence 0
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 8b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 0x00000000 ]
-
-# tcp sequence 0 tcp sport 1024 tcp dport 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 8b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x16000004 0x00000000 ]
-
-# tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 6b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 0x00000000 ]
-
-# tcp sequence 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# tcp sequence != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# tcp sequence 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# tcp sequence != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# tcp sequence { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sequence != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp sequence { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sequence != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp ackseq 42949672 drop
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x285c8f02 ]
-  [ immediate reg 0 drop ]
-
-# tcp ackseq 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# tcp ackseq != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp neq reg 1 0xe9000000 ]
-
-# tcp ackseq 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# tcp ackseq != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ range neq reg 1 0x21000000 0x2d000000 ]
-
-# tcp ackseq { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp ackseq != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp ackseq { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp ackseq != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# tcp flags != { fin, urg, ecn, cwr} drop
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 drop ]
-
-# tcp flags cwr
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
-  [ cmp neq reg 1 0x00000000 ]
-
-# tcp flags != cwr
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ cmp neq reg 1 0x00000080 ]
-
-# tcp 'flags & (syn|fin) == (syn|fin)'
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000003 ]
-
-# tcp window 22222
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x0000ce56 ]
-
-# tcp window 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp window != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp window 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp window != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp window { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp window != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp window { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp window != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp checksum 23456 drop
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000a05b ]
-  [ immediate reg 0 drop ]
-
-# tcp checksum 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp checksum != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp checksum 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp checksum != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp checksum { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp checksum != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp checksum { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp checksum != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp urgptr 1234 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000d204 ]
-  [ immediate reg 0 accept ]
-
-# tcp urgptr 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# tcp urgptr != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# tcp urgptr 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# tcp urgptr != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# tcp urgptr { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp urgptr != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp urgptr { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp urgptr != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# tcp doff 8
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000080 ]
-
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
--- a/tests/py/inet/udp.t.payload.ip
+++ /dev/null
@@ -1,330 +0,0 @@
-# udp sport 80 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udp sport != 60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp sport 50-70 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
-  [ immediate reg 0 accept ]
-
-# udp sport != 50-60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp sport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udp sport != { 50, 60} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp sport { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp sport != { 13-24}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp dport 80 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udp dport != 60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport 70-75 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport != 50-60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udp dport != { 50, 60} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp dport { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udp dport != { 50-60} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp length 6666
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-
-# udp length != 6666
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x00000a1a ]
-
-# udp length 50-65 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004100 ]
-  [ immediate reg 0 accept ]
-
-# udp length != 50-65 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00004100 ]
-  [ immediate reg 0 accept ]
-
-# udp length { 50, 65} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udp length != { 50, 65} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp length { 35-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp length != { 35-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp checksum 6666 drop
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-  [ immediate reg 0 drop ]
-
-# udp checksum != { 444, 555} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp checksum 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# udp checksum != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# udp checksum 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# udp checksum != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# udp checksum { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp checksum != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp checksum { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp checksum != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# iif "lo" udp checksum set 0
-ip test-ip4 input
-  [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
-
-# iif "lo" udp dport set 65535
-ip test-ip4 input
-  [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
deleted file mode 100644
index 8edcff4faa29..000000000000
--- a/tests/py/inet/udp.t.payload.ip6
+++ /dev/null
@@ -1,330 +0,0 @@
-# udp sport 80 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udp sport != 60 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp sport 50-70 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
-  [ immediate reg 0 accept ]
-
-# udp sport != 50-60 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp sport { 49, 50} drop
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udp sport != { 50, 60} accept
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp sport { 12-40}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp sport != { 13-24}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp dport 80 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udp dport != 60 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport 70-75 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport != 50-60 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport { 49, 50} drop
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udp dport != { 50, 60} accept
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp dport { 70-75} accept
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udp dport != { 50-60} accept
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp length 6666
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-
-# udp length != 6666
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x00000a1a ]
-
-# udp length 50-65 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004100 ]
-  [ immediate reg 0 accept ]
-
-# udp length != 50-65 accept
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00004100 ]
-  [ immediate reg 0 accept ]
-
-# udp length { 50, 65} accept
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udp length != { 50, 65} accept
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp length { 35-50}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp length != { 35-50}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp checksum 6666 drop
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-  [ immediate reg 0 drop ]
-
-# udp checksum != { 444, 555} accept
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp checksum 22
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# udp checksum != 233
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# udp checksum 33-45
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# udp checksum != 33-45
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# udp checksum { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp checksum != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp checksum { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp checksum != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# iif "lo" udp checksum set 0
-ip6 test-ip6 input
-  [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
-
-# iif "lo" udp dport set 65535
-ip test-ip4 input
-  [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
deleted file mode 100644
index ab0f51a499d8..000000000000
--- a/tests/py/inet/udp.t.payload.netdev
+++ /dev/null
@@ -1,331 +0,0 @@
-# udp sport 80 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udp sport != 60 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp sport 50-70 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
-  [ immediate reg 0 accept ]
-
-# udp sport != 50-60 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp sport { 49, 50} drop
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udp sport != { 50, 60} accept
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp sport { 12-40}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp sport != { 13-24}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp dport 80 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udp dport != 60 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport 70-75 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport != 50-60 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udp dport { 49, 50} drop
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udp dport != { 50, 60} accept
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp dport { 70-75} accept
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udp dport != { 50-60} accept
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp length 6666
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-
-# udp length != 6666
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp neq reg 1 0x00000a1a ]
-
-# udp length 50-65 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004100 ]
-  [ immediate reg 0 accept ]
-
-# udp length != 50-65 accept
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00004100 ]
-  [ immediate reg 0 accept ]
-
-# udp length { 50, 65} accept
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udp length != { 50, 65} accept
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00003200  : 0 [end]	element 00004100  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp length { 35-50}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp length != { 35-50}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp checksum 6666 drop
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-  [ immediate reg 0 drop ]
-
-# udp checksum != { 444, 555} accept
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udp checksum 22
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# udp checksum != 233
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# udp checksum 33-45
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# udp checksum != 33-45
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# udp checksum { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp checksum != { 33, 55, 67, 88}
-__set%d test-inet 3
-__set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udp checksum { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp checksum != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# iif "lo" udp checksum set 0
-netdev test-netdev ingress
-  [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
-
-# iif "lo" udp dport set 65535
-netdev test-netdev ingress
-  [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
-
diff --git a/tests/py/inet/udplite.t.payload.inet b/tests/py/inet/udplite.t.payload
similarity index 100%
rename from tests/py/inet/udplite.t.payload.inet
rename to tests/py/inet/udplite.t.payload
diff --git a/tests/py/inet/udplite.t.payload.ip b/tests/py/inet/udplite.t.payload.ip
deleted file mode 100644
index c1ecc9d57e7a..000000000000
--- a/tests/py/inet/udplite.t.payload.ip
+++ /dev/null
@@ -1,240 +0,0 @@
-# udplite sport 80 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport != 60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport 50-70 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport != 50-60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udplite sport != { 49, 50} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite sport != { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udplite dport 80 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != 60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport 70-75 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != 50-60 accept
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udplite dport != { 49, 50} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite checksum 6666 drop
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-  [ immediate reg 0 drop ]
-
-# udplite checksum != { 444, 555} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
-ip test-ip4 input 
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite checksum 22
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# udplite checksum != 233
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# udplite checksum 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# udplite checksum != 33-45
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# udplite checksum { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite checksum != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udplite checksum { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite checksum != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/udplite.t.payload.ip6 b/tests/py/inet/udplite.t.payload.ip6
deleted file mode 100644
index d2f032e905e0..000000000000
--- a/tests/py/inet/udplite.t.payload.ip6
+++ /dev/null
@@ -1,240 +0,0 @@
-# udplite sport 80 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport != 60 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport 50-70 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport != 50-60 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udplite sport != { 49, 50} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite sport != { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udplite dport 80 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != 60 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport 70-75 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != 50-60 accept
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udplite dport != { 49, 50} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite checksum 6666 drop
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-  [ immediate reg 0 drop ]
-
-# udplite checksum != { 444, 555} accept
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
-ip6 test-ip6 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite checksum 22
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# udplite checksum != 233
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# udplite checksum 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# udplite checksum != 33-45
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# udplite checksum { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite checksum != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udplite checksum { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite checksum != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/udplite.t.payload.netdev b/tests/py/inet/udplite.t.payload.netdev
deleted file mode 100644
index 565935a27e90..000000000000
--- a/tests/py/inet/udplite.t.payload.netdev
+++ /dev/null
@@ -1,240 +0,0 @@
-# udplite sport 80 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport != 60 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport 50-70 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport != 50-60 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udplite sport != { 49, 50} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite sport { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite sport != { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udplite dport 80 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00005000 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != 60 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport 70-75 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != 50-60 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00003200 0x00003c00 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport { 49, 50} drop
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 drop ]
-
-# udplite dport != { 49, 50} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00003100  : 0 [end]	element 00003200  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite dport { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite checksum 6666 drop
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000a1a ]
-  [ immediate reg 0 drop ]
-
-# udplite checksum != { 444, 555} accept
-__set%d test-netdev 3
-__set%d test-netdev 0
-	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# udplite checksum 22
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# udplite checksum != 233
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x0000e900 ]
-
-# udplite checksum 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
-
-# udplite checksum != 33-45
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ range neq reg 1 0x00002100 0x00002d00 ]
-
-# udplite checksum { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite checksum != { 33, 55, 67, 88}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# udplite checksum { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite checksum != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
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
2.13.0

