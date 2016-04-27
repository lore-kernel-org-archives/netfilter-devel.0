From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 4/7] tests: update for changed set name
Date: Wed, 27 Apr 2016 12:29:47 +0100
Message-ID: <1461756590-22880-5-git-send-email-kaber@trash.net>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33532 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbcD0LaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:30:04 -0400
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 tests/py/any/ct.t.payload              |  66 ++++-----
 tests/py/any/dup.t.payload             |   6 +-
 tests/py/any/fwd.t.payload             |   6 +-
 tests/py/any/meta.t.payload            | 168 +++++++++++-----------
 tests/py/arp/arp.t.payload             |  42 +++---
 tests/py/arp/arp.t.payload.netdev      |  42 +++---
 tests/py/bridge/vlan.t.payload         |   6 +-
 tests/py/bridge/vlan.t.payload.netdev  |   6 +-
 tests/py/inet/ah.t.payload.inet        |  48 +++----
 tests/py/inet/ah.t.payload.ip          |  48 +++----
 tests/py/inet/ah.t.payload.ip6         |  48 +++----
 tests/py/inet/ah.t.payload.netdev      |  48 +++----
 tests/py/inet/comp.t.payload.inet      |  24 ++--
 tests/py/inet/comp.t.payload.ip        |  24 ++--
 tests/py/inet/comp.t.payload.ip6       |  24 ++--
 tests/py/inet/comp.t.payload.netdev    |  24 ++--
 tests/py/inet/dccp.t.payload.inet      |  36 ++---
 tests/py/inet/dccp.t.payload.ip        |  36 ++---
 tests/py/inet/dccp.t.payload.ip6       |  36 ++---
 tests/py/inet/dccp.t.payload.netdev    |  36 ++---
 tests/py/inet/esp.t.payload.inet       |  24 ++--
 tests/py/inet/esp.t.payload.ip         |  24 ++--
 tests/py/inet/esp.t.payload.ip6        |  24 ++--
 tests/py/inet/esp.t.payload.netdev     |  24 ++--
 tests/py/inet/ip.t.payload.bridge      |   6 +-
 tests/py/inet/ip.t.payload.inet        |   6 +-
 tests/py/inet/ip.t.payload.ip          |   6 +-
 tests/py/inet/ip.t.payload.netdev      |   6 +-
 tests/py/inet/map.t.payload.inet       |  12 +-
 tests/py/inet/map.t.payload.ip         |  12 +-
 tests/py/inet/map.t.payload.netdev     |  12 +-
 tests/py/inet/sctp.t.payload.inet      |  48 +++----
 tests/py/inet/sctp.t.payload.ip        |  48 +++----
 tests/py/inet/sctp.t.payload.ip6       |  48 +++----
 tests/py/inet/sctp.t.payload.netdev    |  48 +++----
 tests/py/inet/tcp.t.payload.inet       | 126 ++++++++---------
 tests/py/inet/tcp.t.payload.ip         | 126 ++++++++---------
 tests/py/inet/tcp.t.payload.ip6        | 126 ++++++++---------
 tests/py/inet/tcp.t.payload.netdev     | 126 ++++++++---------
 tests/py/inet/udp.t.payload.inet       |  48 +++----
 tests/py/inet/udp.t.payload.ip         |  48 +++----
 tests/py/inet/udp.t.payload.ip6        |  48 +++----
 tests/py/inet/udp.t.payload.netdev     |  48 +++----
 tests/py/inet/udplite.t.payload.inet   |  36 ++---
 tests/py/inet/udplite.t.payload.ip     |  36 ++---
 tests/py/inet/udplite.t.payload.ip6    |  36 ++---
 tests/py/inet/udplite.t.payload.netdev |  36 ++---
 tests/py/ip/dnat.t.payload.ip          |  18 +--
 tests/py/ip/dup.t.payload              |   6 +-
 tests/py/ip/icmp.t.payload.ip          |  90 ++++++------
 tests/py/ip/ip.t.payload               |  84 +++++------
 tests/py/ip/ip.t.payload.inet          |  84 +++++------
 tests/py/ip/ip.t.payload.netdev        |  78 +++++-----
 tests/py/ip/masquerade.t.payload       |  12 +-
 tests/py/ip/redirect.t.payload         |  18 +--
 tests/py/ip/snat.t.payload             |   6 +-
 tests/py/ip6/dst.t.payload.inet        |  30 ++--
 tests/py/ip6/dst.t.payload.ip6         |  30 ++--
 tests/py/ip6/dup.t.payload             |   6 +-
 tests/py/ip6/frag.t.payload.inet       |  42 +++---
 tests/py/ip6/frag.t.payload.ip6        |  42 +++---
 tests/py/ip6/hbh.t.payload.inet        |  30 ++--
 tests/py/ip6/hbh.t.payload.ip6         |  30 ++--
 tests/py/ip6/icmpv6.t.payload.ip6      |  96 ++++++-------
 tests/py/ip6/ip6.t.payload.inet        |  48 +++----
 tests/py/ip6/ip6.t.payload.ip6         |  48 +++----
 tests/py/ip6/map.t.payload             |   6 +-
 tests/py/ip6/masquerade.t.payload.ip6  |  12 +-
 tests/py/ip6/mh.t.payload.inet         |  60 ++++----
 tests/py/ip6/mh.t.payload.ip6          |  60 ++++----
 tests/py/ip6/redirect.t.payload.ip6    |  18 +--
 tests/py/ip6/rt.t.payload.inet         |  54 +++----
 tests/py/ip6/rt.t.payload.ip6          |  54 +++----
 tests/py/ip6/vmap.t.payload.inet       | 252 ++++++++++++++++-----------------
 tests/py/ip6/vmap.t.payload.ip6        | 252 ++++++++++++++++-----------------
 tests/py/ip6/vmap.t.payload.netdev     | 252 ++++++++++++++++-----------------
 76 files changed, 1890 insertions(+), 1890 deletions(-)

diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 62e9259..448c101 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -10,12 +10,12 @@ ip test-ip4 output
   [ cmp neq reg 1 0x00000004 ]
 
 # ct state {new,established, related, untracked}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000008  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000040  : 0 [end]
 ip test-ip4 output
   [ ct load state => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct state invalid drop
 ip test-ip4 output
@@ -58,12 +58,12 @@ ip test-ip4 output
   [ cmp neq reg 1 0x00000001 ]
 
 # ct direction {reply, original}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 output
   [ ct load direction => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct status expected
 ip test-ip4 output
@@ -88,12 +88,12 @@ ip test-ip4 output
   [ cmp neq reg 1 0x00000002 ]
 
 # ct status {expected, seen-reply, assured, confirmed, dying}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000200  : 0 [end]
 ip test-ip4 output
   [ ct load status => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct mark 0
 ip test-ip4 output
@@ -159,12 +159,12 @@ ip test-ip4 output
   [ cmp gt reg 1 0x45000000 ]
 
 # ct mark {0x32, 0x2222, 0x42de3}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000032  : 0 [end]	element 00002222  : 0 [end]	element 00042de3  : 0 [end]
 ip test-ip4 output
   [ ct load mark => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct mark set 0x11 xor 0x1331
 ip test-ip4 output
@@ -216,21 +216,21 @@ ip test-ip4 output
   [ cmp gt reg 1 0x2d000000 ]
 
 # ct expiration {33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct expiration {33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct helper "ftp"
 ip test-ip4 output
@@ -238,40 +238,40 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00707466 0x00000000 0x00000000 0x00000000 ]
 
 # ct state . ct mark { new . 0x12345678}
-set%d test 3
-set%d test 0
+__set%d test 3
+__set%d test 0
 	element 00000008 12345678  : 0 [end]
 ip test-ip4 output
   [ ct load state => reg 1 ]
   [ ct load mark => reg 9 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000008 12345678  : 0 [end]	element 00000008 34127856  : 0 [end]	element 00000002 12785634  : 0 [end]
 ip test-ip4 output
   [ ct load state => reg 1 ]
   [ ct load mark => reg 9 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct direction . ct mark { original . 0x12345678}
-set%d test 3
-set%d test 0
+__set%d test 3
+__set%d test 0
 	element 00000000 12345678  : 0 [end]
 ip test-ip4 output
   [ ct load direction => reg 1 ]
   [ ct load mark => reg 9 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ct state . ct mark vmap { new . 0x12345678 : drop}
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00000008 12345678  : 0 [end]
 ip test-ip4 output
   [ ct load state => reg 1 ]
   [ ct load mark => reg 9 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ct mark set mark
 ip test-ip4 output
@@ -279,12 +279,12 @@ ip test-ip4 output
   [ ct set mark with reg 1 ]
 
 # ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 }
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
         element 00000001  : 0000000a 0 [end]    element 00000002  : 00000014 0 [end]    element 00000003  : 0000001e 0 [end]
 ip test-ip4 output
   [ meta load mark => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ ct set mark with reg 1 ]
 
 # ct original bytes \> 100000
diff --git a/tests/py/any/dup.t.payload b/tests/py/any/dup.t.payload
index 206a9ec..b1d6d16 100644
--- a/tests/py/any/dup.t.payload
+++ b/tests/py/any/dup.t.payload
@@ -4,11 +4,11 @@ netdev test-netdev ingress
   [ dup sreg_dev 1 ]
 
 # dup to mark map { 0x00000001 : lo, 0x00000002 : lo}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
 netdev test-netdev ingress 
   [ meta load mark => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ dup sreg_dev 1 ]
 
diff --git a/tests/py/any/fwd.t.payload b/tests/py/any/fwd.t.payload
index e7ecc7c..0402b7a 100644
--- a/tests/py/any/fwd.t.payload
+++ b/tests/py/any/fwd.t.payload
@@ -4,11 +4,11 @@ netdev test-netdev ingress
   [ fwd sreg_dev 1 ]
 
 # fwd to mark map { 0x00000001 : lo, 0x00000002 : lo}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
 netdev test-netdev ingress 
   [ meta load mark => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ fwd sreg_dev 1 ]
 
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 9f7a6d9..fbcabfd 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -28,29 +28,29 @@ ip test-ip4 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # meta length { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip test-ip4 input
   [ meta load len => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta length { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta protocol { ip, arp, ip6, vlan }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000008  : 0 [end]	element 00000608  : 0 [end]	element 0000dd86  : 0 [end]	element 00000081  : 0 [end]
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta protocol ip
 ip test-ip4 input
@@ -73,12 +73,12 @@ ip test-ip4 input
   [ cmp eq reg 1 0x0000000a ]
 
 # meta nfproto {ipv4, ipv6}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
 ip test-ip4 input
   [ meta load nfproto => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta l4proto 22
 ip test-ip4 input
@@ -105,21 +105,21 @@ ip test-ip4 input
   [ cmp gt reg 1 0x0000002d ]
 
 # meta l4proto { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta l4proto { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 2, 1) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta mark 0x4
 ip test-ip4 input
@@ -210,12 +210,12 @@ ip test-ip4 input
   [ cmp neq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
 
 # meta iifname {"eth0", "lo"}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 30687465 00000000 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta iifname "eth*"
 ip test-ip4 input
@@ -228,12 +228,12 @@ ip test-ip4 input
   [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]
 
 # meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta iiftype != ether
 ip test-ip4 input
@@ -268,12 +268,12 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # meta oif {eth0, lo} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000002  : 0 [end]	element 00000001  : 0 [end]
 ip test-ip4 input
   [ meta load oif => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # meta oifname "eth0"
@@ -287,12 +287,12 @@ ip test-ip4 input
   [ cmp neq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
 
 # meta oifname { "eth0", "lo"}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 30687465 00000000 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta oifname "eth*"
 ip test-ip4 input
@@ -305,12 +305,12 @@ ip test-ip4 input
   [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]
 
 # meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
 ip test-ip4 input
   [ meta load oiftype => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta oiftype != ether
 ip test-ip4 input
@@ -323,12 +323,12 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
 
 # meta skuid {bin, root, daemon} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # meta skuid root
@@ -378,22 +378,22 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # meta skuid { 2001-2005} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # meta skgid {bin, root, daemon} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # meta skgid root
@@ -443,13 +443,13 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # meta skgid { 2001-2005} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # meta mark set 0xffffffc8 xor 0x16
@@ -554,12 +554,12 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000002 ]
 
 # meta pkttype { broadcast, multicast} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000002  : 0 [end]
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # meta cpu 1
@@ -587,12 +587,12 @@ ip test-ip4 input
   [ cmp gt reg 1 0x02000000 ]
 
 # meta cpu { 2,3}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000002  : 0 [end]	element 00000003  : 0 [end]
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta iifgroup 0
 ip test-ip4 input
@@ -615,29 +615,29 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000000 ]
 
 # meta iifgroup {default}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta iifgroup { 11,33}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta iifgroup {11-33}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta oifgroup 0
 ip test-ip4 input
@@ -660,29 +660,29 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000000 ]
 
 # meta oifgroup {default}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta oifgroup { 11,33}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta oifgroup {11-33}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta cgroup 1048577
 ip test-ip4 input
@@ -695,12 +695,12 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00100001 ]
 
 # meta cgroup { 1048577, 1048578 }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00100001  : 0 [end]	element 00100002  : 0 [end]
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta cgroup 1048577-1048578
 ip test-ip4 input
@@ -717,40 +717,40 @@ ip test-ip4 input
   [ cmp gt reg 1 0x02001000 ]
 
 # meta cgroup {1048577-1048578}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 
 # meta iif . meta oif { lo . eth0 }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001 00000002  : 0 [end]
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta iif . meta oif . meta mark { lo . eth0 . 0x0000000a }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001 00000002 0000000a  : 0 [end]
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
   [ meta load mark => reg 10 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # meta iif . meta oif vmap { lo . eth0 : drop }
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00000001 00000002  : 0 [end]
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index bfa37cd..31c3024 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -31,20 +31,20 @@ arp test-arp input
   [ cmp gt reg 1 0x00002d00 ]
 
 # arp htype { 33, 55, 67, 88}
-set%d test-arp 3
-set%d test-arp 0
+__set%d test-arp 3
+__set%d test-arp 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp htype { 33-55}
-set%d test-arp 7
-set%d test-arp 0
+__set%d test-arp 7
+__set%d test-arp 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp ptype 0x0800
 arp test-arp input
@@ -74,20 +74,20 @@ arp test-arp input
   [ cmp gt reg 1 0x0000002d ]
 
 # arp hlen { 33, 55, 67, 88}
-set%d test-arp 3
-set%d test-arp 0
+__set%d test-arp 3
+__set%d test-arp 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp hlen { 33-55}
-set%d test-arp 7
-set%d test-arp 0
+__set%d test-arp 7
+__set%d test-arp 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp plen 22
 arp test-arp input
@@ -112,28 +112,28 @@ arp test-arp input
   [ cmp gt reg 1 0x0000002d ]
 
 # arp plen { 33, 55, 67, 88}
-set%d test-arp 3
-set%d test-arp 0
+__set%d test-arp 3
+__set%d test-arp 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp plen { 33-55}
-set%d test-arp 7
-set%d test-arp 0
+__set%d test-arp 7
+__set%d test-arp 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
-set%d test-arp 3
-set%d test-arp 0
+__set%d test-arp 3
+__set%d test-arp 0
 	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp operation request
 arp test-arp input
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index 2085dde..a64ebea 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -43,24 +43,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x00002d00 ]
 
 # arp htype { 33, 55, 67, 88}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp htype { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp ptype 0x0800
 netdev test-netdev ingress 
@@ -100,24 +100,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x0000002d ]
 
 # arp hlen { 33, 55, 67, 88}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp hlen { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp plen 22
 netdev test-netdev ingress 
@@ -150,34 +150,34 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x0000002d ]
 
 # arp plen { 33, 55, 67, 88}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp plen { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # arp operation request
 netdev test-netdev ingress 
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 78ee7ef..5fce9c1 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -185,15 +185,15 @@ bridge test-bridge input
   [ cmp eq reg 1 0x00000060 ]
 
 # vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
-set%d test-bridge 3
-set%d test-bridge 0
+__set%d test-bridge 3
+__set%d test-bridge 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000400  : 0 [end]	element 00006400  : 0 [end]	element 0000ff0f  : 0 [end]
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000020 ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index f60587f..45ea225 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -217,8 +217,8 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000060 ]
 
 # vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000400  : 0 [end]	element 00006400  : 0 [end]	element 0000ff0f  : 0 [end]
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
@@ -227,7 +227,7 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000020 ]
diff --git a/tests/py/inet/ah.t.payload.inet b/tests/py/inet/ah.t.payload.inet
index d875598..739386a 100644
--- a/tests/py/inet/ah.t.payload.inet
+++ b/tests/py/inet/ah.t.payload.inet
@@ -15,24 +15,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00000017 ]
 
 # ah hdrlength { 11-23}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah hdrlength {11, 23, 44 }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved 22
 inet test-inet input
@@ -65,24 +65,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ah reserved {23, 100}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00006400  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi 111
 inet test-inet input
@@ -115,24 +115,24 @@ inet test-inet input
   [ cmp gt reg 1 0xde000000 ]
 
 # ah spi {111, 122}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi { 111-122}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 123
 inet test-inet input
@@ -149,24 +149,24 @@ inet test-inet input
   [ cmp neq reg 1 0x7b000000 ]
 
 # ah sequence {23, 25, 33}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence { 23-33}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 23-33
 inet test-inet input
diff --git a/tests/py/inet/ah.t.payload.ip b/tests/py/inet/ah.t.payload.ip
index 6a58bb1..b989948 100644
--- a/tests/py/inet/ah.t.payload.ip
+++ b/tests/py/inet/ah.t.payload.ip
@@ -15,24 +15,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00000017 ]
 
 # ah hdrlength { 11-23}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah hdrlength {11, 23, 44 }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved 22
 ip test-ip4 input
@@ -65,24 +65,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ah reserved {23, 100}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00006400  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi 111
 ip test-ip4 input
@@ -115,24 +115,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0xde000000 ]
 
 # ah spi {111, 122}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi { 111-122}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 123
 ip test-ip4 input
@@ -149,24 +149,24 @@ ip test-ip4 input
   [ cmp neq reg 1 0x7b000000 ]
 
 # ah sequence {23, 25, 33}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence { 23-33}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 23-33
 ip test-ip4 input
diff --git a/tests/py/inet/ah.t.payload.ip6 b/tests/py/inet/ah.t.payload.ip6
index ce89754..95eae66 100644
--- a/tests/py/inet/ah.t.payload.ip6
+++ b/tests/py/inet/ah.t.payload.ip6
@@ -15,24 +15,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00000017 ]
 
 # ah hdrlength { 11-23}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah hdrlength {11, 23, 44 }
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved 22
 ip6 test-ip6 input
@@ -65,24 +65,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ah reserved {23, 100}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00006400  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi 111
 ip6 test-ip6 input
@@ -115,24 +115,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0xde000000 ]
 
 # ah spi {111, 122}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi { 111-122}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 123
 ip6 test-ip6 input
@@ -149,24 +149,24 @@ ip6 test-ip6 input
   [ cmp neq reg 1 0x7b000000 ]
 
 # ah sequence {23, 25, 33}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence { 23-33}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 23-33
 ip6 test-ip6 input
diff --git a/tests/py/inet/ah.t.payload.netdev b/tests/py/inet/ah.t.payload.netdev
index 85c3528..55eea13 100644
--- a/tests/py/inet/ah.t.payload.netdev
+++ b/tests/py/inet/ah.t.payload.netdev
@@ -15,24 +15,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x00000017 ]
 
 # ah hdrlength { 11-23}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah hdrlength {11, 23, 44 }
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved 22
 netdev test-netdev ingress 
@@ -65,24 +65,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x00002d00 ]
 
 # ah reserved {23, 100}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00001700  : 0 [end]	element 00006400  : 0 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah reserved { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi 111
 netdev test-netdev ingress 
@@ -115,24 +115,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0xde000000 ]
 
 # ah spi {111, 122}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah spi { 111-122}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 123
 netdev test-netdev ingress 
@@ -149,24 +149,24 @@ netdev test-netdev ingress
   [ cmp neq reg 1 0x7b000000 ]
 
 # ah sequence {23, 25, 33}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence { 23-33}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ah sequence 23-33
 netdev test-netdev ingress 
diff --git a/tests/py/inet/comp.t.payload.inet b/tests/py/inet/comp.t.payload.inet
index c00bcc7..eff32b7 100644
--- a/tests/py/inet/comp.t.payload.inet
+++ b/tests/py/inet/comp.t.payload.inet
@@ -36,24 +36,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp flags { 0x33-0x55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi 22
 inet test-inet input
@@ -86,22 +86,22 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/comp.t.payload.ip b/tests/py/inet/comp.t.payload.ip
index e226c9a..b2a8ab4 100644
--- a/tests/py/inet/comp.t.payload.ip
+++ b/tests/py/inet/comp.t.payload.ip
@@ -36,24 +36,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp flags { 0x33-0x55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi 22
 ip test-ip4 input
@@ -86,22 +86,22 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/comp.t.payload.ip6 b/tests/py/inet/comp.t.payload.ip6
index 135e5a2..f179998 100644
--- a/tests/py/inet/comp.t.payload.ip6
+++ b/tests/py/inet/comp.t.payload.ip6
@@ -36,24 +36,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp flags { 0x33-0x55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi 22
 ip6 test-ip6 input
@@ -86,22 +86,22 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/comp.t.payload.netdev b/tests/py/inet/comp.t.payload.netdev
index c00bcc7..eff32b7 100644
--- a/tests/py/inet/comp.t.payload.netdev
+++ b/tests/py/inet/comp.t.payload.netdev
@@ -36,24 +36,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp flags { 0x33-0x55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi 22
 inet test-inet input
@@ -86,22 +86,22 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # comp cpi { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload.inet
index 11f5aaf..e02d0f0 100644
--- a/tests/py/inet/dccp.t.payload.inet
+++ b/tests/py/inet/dccp.t.payload.inet
@@ -15,24 +15,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002300 ]
 
 # dccp sport {23, 24, 25}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport { 20-50 }
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport ftp-data - re-mail-ck
 inet test-inet input
@@ -51,45 +51,45 @@ inet test-inet input
   [ cmp lte reg 1 0x00003200 ]
 
 # dccp sport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport {23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type request
 inet test-inet input
diff --git a/tests/py/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
index fbf441a..04f5c14 100644
--- a/tests/py/inet/dccp.t.payload.ip
+++ b/tests/py/inet/dccp.t.payload.ip
@@ -15,24 +15,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002300 ]
 
 # dccp sport {23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport { 20-50 }
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport ftp-data - re-mail-ck
 ip test-ip4 input
@@ -51,45 +51,45 @@ ip test-ip4 input
   [ cmp lte reg 1 0x00003200 ]
 
 # dccp sport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport {23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type request
 ip test-ip4 input
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
index b323c06..f775fd1 100644
--- a/tests/py/inet/dccp.t.payload.ip6
+++ b/tests/py/inet/dccp.t.payload.ip6
@@ -15,24 +15,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002300 ]
 
 # dccp sport {23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport { 20-50 }
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport ftp-data - re-mail-ck
 ip6 test-ip6 input
@@ -51,45 +51,45 @@ ip6 test-ip6 input
   [ cmp lte reg 1 0x00003200 ]
 
 # dccp sport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport {23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
         element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type request
 ip6 test-ip6 input
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
index 5a8c873..071b612 100644
--- a/tests/py/inet/dccp.t.payload.netdev
+++ b/tests/py/inet/dccp.t.payload.netdev
@@ -15,24 +15,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002300 ]
 
 # dccp sport {23, 24, 25}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport { 20-50 }
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp sport ftp-data - re-mail-ck
 inet test-inet input
@@ -51,45 +51,45 @@ inet test-inet input
   [ cmp lte reg 1 0x00003200 ]
 
 # dccp sport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport {23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp dport { 20-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dccp type request
 netdev test-netdev ingress
diff --git a/tests/py/inet/esp.t.payload.inet b/tests/py/inet/esp.t.payload.inet
index 4ba9ea8..5f3a0da 100644
--- a/tests/py/inet/esp.t.payload.inet
+++ b/tests/py/inet/esp.t.payload.inet
@@ -29,24 +29,24 @@ inet test-inet input
   [ cmp gt reg 1 0xde000000 ]
 
 # esp spi { 100, 102}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 64000000  : 0 [end]	element 66000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp spi { 100-102}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence 22
 inet test-inet input
@@ -72,22 +72,22 @@ inet test-inet input
   [ cmp gt reg 1 0x18000000 ]
 
 # esp sequence { 22, 24}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 16000000  : 0 [end]	element 18000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence { 22-25}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/esp.t.payload.ip b/tests/py/inet/esp.t.payload.ip
index 5a66b04..cf52678 100644
--- a/tests/py/inet/esp.t.payload.ip
+++ b/tests/py/inet/esp.t.payload.ip
@@ -29,24 +29,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0xde000000 ]
 
 # esp spi { 100, 102}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 64000000  : 0 [end]	element 66000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp spi { 100-102}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence 22
 ip test-ip4 input
@@ -72,22 +72,22 @@ ip test-ip4 input
   [ cmp gt reg 1 0x18000000 ]
 
 # esp sequence { 22, 24}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 16000000  : 0 [end]	element 18000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence { 22-25}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/esp.t.payload.ip6 b/tests/py/inet/esp.t.payload.ip6
index 7c78426..982412d 100644
--- a/tests/py/inet/esp.t.payload.ip6
+++ b/tests/py/inet/esp.t.payload.ip6
@@ -29,24 +29,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0xde000000 ]
 
 # esp spi { 100, 102}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 64000000  : 0 [end]	element 66000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp spi { 100-102}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence 22
 ip6 test-ip6 input
@@ -72,22 +72,22 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x18000000 ]
 
 # esp sequence { 22, 24}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 16000000  : 0 [end]	element 18000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence { 22-25}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/esp.t.payload.netdev b/tests/py/inet/esp.t.payload.netdev
index 4ba9ea8..5f3a0da 100644
--- a/tests/py/inet/esp.t.payload.netdev
+++ b/tests/py/inet/esp.t.payload.netdev
@@ -29,24 +29,24 @@ inet test-inet input
   [ cmp gt reg 1 0xde000000 ]
 
 # esp spi { 100, 102}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 64000000  : 0 [end]	element 66000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp spi { 100-102}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence 22
 inet test-inet input
@@ -72,22 +72,22 @@ inet test-inet input
   [ cmp gt reg 1 0x18000000 ]
 
 # esp sequence { 22, 24}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 16000000  : 0 [end]	element 18000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # esp sequence { 22-25}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/ip.t.payload.bridge b/tests/py/inet/ip.t.payload.bridge
index 606e3b3..a422ed7 100644
--- a/tests/py/inet/ip.t.payload.bridge
+++ b/tests/py/inet/ip.t.payload.bridge
@@ -1,6 +1,6 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
-set%d test-bridge 3
-set%d test-bridge 0
+__set%d test-bridge 3
+__set%d test-bridge 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
@@ -8,4 +8,4 @@ bridge test-bridge input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/py/inet/ip.t.payload.inet b/tests/py/inet/ip.t.payload.inet
index c8e9b05..e926d03 100644
--- a/tests/py/inet/ip.t.payload.inet
+++ b/tests/py/inet/ip.t.payload.inet
@@ -1,6 +1,6 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -10,4 +10,4 @@ inet test-inet input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/py/inet/ip.t.payload.ip b/tests/py/inet/ip.t.payload.ip
index 66f1468..f0ef38b 100644
--- a/tests/py/inet/ip.t.payload.ip
+++ b/tests/py/inet/ip.t.payload.ip
@@ -1,6 +1,6 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
@@ -8,4 +8,4 @@ ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
index f278f5b..95be919 100644
--- a/tests/py/inet/ip.t.payload.netdev
+++ b/tests/py/inet/ip.t.payload.netdev
@@ -1,6 +1,6 @@
 # ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -10,5 +10,5 @@ netdev test-netdev ingress
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 6b @ link header + 6 => reg 10 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/map.t.payload.inet b/tests/py/inet/map.t.payload.inet
index a0ff003..16225cb 100644
--- a/tests/py/inet/map.t.payload.inet
+++ b/tests/py/inet/map.t.payload.inet
@@ -1,23 +1,23 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 0203020a  : 0000002a 0 [end]	element 0103020a  : 00000017 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
 # mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/inet/map.t.payload.ip b/tests/py/inet/map.t.payload.ip
index 465a55a..dfd571d 100644
--- a/tests/py/inet/map.t.payload.ip
+++ b/tests/py/inet/map.t.payload.ip
@@ -1,19 +1,19 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
-map%d test-ip b
-map%d test-ip 0
+__map%d test-ip b
+__map%d test-ip 0
 	element 0103020a  : 00000017 0 [end]	element 0203020a  : 0000002a 0 [end]
 ip test-ip input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
 # mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00000004  : 00000001 0 [end]	element 00000005  : 00000017 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/inet/map.t.payload.netdev b/tests/py/inet/map.t.payload.netdev
index fb9260c..1457c5d 100644
--- a/tests/py/inet/map.t.payload.netdev
+++ b/tests/py/inet/map.t.payload.netdev
@@ -1,23 +1,23 @@
 # mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 0103020a  : 00000017 0 [end]	element 0203020a  : 0000002a 0 [end]
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
 # mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/inet/sctp.t.payload.inet b/tests/py/inet/sctp.t.payload.inet
index dd6e275..9c68a8c 100644
--- a/tests/py/inet/sctp.t.payload.inet
+++ b/tests/py/inet/sctp.t.payload.inet
@@ -29,24 +29,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp sport { 23-44}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport 23
 inet test-inet input
@@ -79,24 +79,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport { 23-44}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum 1111
 inet test-inet input
@@ -129,24 +129,24 @@ inet test-inet input
   [ cmp gt reg 1 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum { 22-44}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag 22
 inet test-inet input
@@ -179,22 +179,22 @@ inet test-inet input
   [ cmp gt reg 1 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/sctp.t.payload.ip b/tests/py/inet/sctp.t.payload.ip
index 053d319..6e07a4c 100644
--- a/tests/py/inet/sctp.t.payload.ip
+++ b/tests/py/inet/sctp.t.payload.ip
@@ -29,24 +29,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp sport { 23-44}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport 23
 ip test-ip4 input
@@ -79,24 +79,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport { 23-44}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum 1111
 ip test-ip4 input
@@ -129,24 +129,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum { 22-44}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag 22
 ip test-ip4 input
@@ -179,22 +179,22 @@ ip test-ip4 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/sctp.t.payload.ip6 b/tests/py/inet/sctp.t.payload.ip6
index eae6fa9..579609b 100644
--- a/tests/py/inet/sctp.t.payload.ip6
+++ b/tests/py/inet/sctp.t.payload.ip6
@@ -29,24 +29,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp sport { 23-44}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport 23
 ip6 test-ip6 input
@@ -79,24 +79,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport { 23-44}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum 1111
 ip6 test-ip6 input
@@ -129,24 +129,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum { 22-44}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag 22
 ip6 test-ip6 input
@@ -179,22 +179,22 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/sctp.t.payload.netdev b/tests/py/inet/sctp.t.payload.netdev
index dd6e275..9c68a8c 100644
--- a/tests/py/inet/sctp.t.payload.netdev
+++ b/tests/py/inet/sctp.t.payload.netdev
@@ -29,24 +29,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp sport { 23-44}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport 23
 inet test-inet input
@@ -79,24 +79,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp dport { 23-44}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum 1111
 inet test-inet input
@@ -129,24 +129,24 @@ inet test-inet input
   [ cmp gt reg 1 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp checksum { 22-44}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag 22
 inet test-inet input
@@ -179,22 +179,22 @@ inet test-inet input
   [ cmp gt reg 1 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # sctp vtag { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload.inet
index 5d54f87..9c3fbbf 100644
--- a/tests/py/inet/tcp.t.payload.inet
+++ b/tests/py/inet/tcp.t.payload.inet
@@ -29,65 +29,65 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport {telnet, http, https} accept
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # tcp dport vmap { 22 : accept, 23 : drop }
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00001600  : 0 [end]	element 00001700  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport vmap { 25:accept, 28:drop }
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport { 22, 53, 80, 110 }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport 22
 inet test-inet input
@@ -120,34 +120,34 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport vmap { 25:accept, 28:drop }
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp sport 8080 drop
 inet test-inet input
@@ -179,14 +179,14 @@ inet test-inet input
   [ cmp eq reg 1 0x16000004 0x00000000 ]
 
 # tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 6b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 0x00000000 ]
 
@@ -221,24 +221,24 @@ inet test-inet input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sequence { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq 42949672 drop
 inet test-inet input
@@ -279,34 +279,34 @@ inet test-inet input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # tcp flags cwr
@@ -362,24 +362,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp window { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum 22
 inet test-inet input
@@ -412,24 +412,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr 1234 accept
 inet test-inet input
@@ -470,24 +470,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp doff 8
 inet test-inet input
diff --git a/tests/py/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
index fb5316f..75cbe70 100644
--- a/tests/py/inet/tcp.t.payload.ip
+++ b/tests/py/inet/tcp.t.payload.ip
@@ -29,65 +29,65 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport {telnet, http, https} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # tcp dport vmap { 22 : accept, 23 : drop }
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00001600  : 0 [end]	element 00001700  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport vmap { 25:accept, 28:drop }
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport { 22, 53, 80, 110 }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport 22
 ip test-ip4 input
@@ -120,34 +120,34 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport vmap { 25:accept, 28:drop }
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp sport 8080 drop
 ip test-ip4 input
@@ -179,14 +179,14 @@ ip test-ip4 input
   [ cmp eq reg 1 0x16000004 0x00000000 ]
 
 # tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 6b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 0x00000000 ]
 
@@ -221,24 +221,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sequence { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq 42949672 drop
 ip test-ip4 input
@@ -279,34 +279,34 @@ ip test-ip4 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # tcp flags cwr
@@ -362,24 +362,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp window { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum 22
 ip test-ip4 input
@@ -412,24 +412,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr 1234 accept
 ip test-ip4 input
@@ -470,24 +470,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp doff 8
 ip test-ip4 input
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
index 1d9dd1f..f65f9b8 100644
--- a/tests/py/inet/tcp.t.payload.ip6
+++ b/tests/py/inet/tcp.t.payload.ip6
@@ -29,65 +29,65 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport {telnet, http, https} accept
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # tcp dport vmap { 22 : accept, 23 : drop }
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00001600  : 0 [end]	element 00001700  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport vmap { 25:accept, 28:drop }
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport { 22, 53, 80, 110 }
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport 22
 ip6 test-ip6 input
@@ -120,34 +120,34 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport vmap { 25:accept, 28:drop }
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp sport 8080 drop
 ip6 test-ip6 input
@@ -179,14 +179,14 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x16000004 0x00000000 ]
 
 # tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 6b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 0x00000000 ]
 
@@ -221,24 +221,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sequence { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq 42949672 drop
 ip6 test-ip6 input
@@ -279,34 +279,34 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # tcp flags cwr
@@ -362,24 +362,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp window { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum 22
 ip6 test-ip6 input
@@ -412,24 +412,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr 1234 accept
 ip6 test-ip6 input
@@ -470,24 +470,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp doff 8
 ip6 test-ip6 input
diff --git a/tests/py/inet/tcp.t.payload.netdev b/tests/py/inet/tcp.t.payload.netdev
index 6a319df..a554d07 100644
--- a/tests/py/inet/tcp.t.payload.netdev
+++ b/tests/py/inet/tcp.t.payload.netdev
@@ -29,65 +29,65 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp dport {telnet, http, https} accept
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # tcp dport vmap { 22 : accept, 23 : drop }
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00001600  : 0 [end]	element 00001700  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport vmap { 25:accept, 28:drop }
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp dport { 22, 53, 80, 110 }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport 22
 inet test-inet input
@@ -120,34 +120,34 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sport vmap { 25:accept, 28:drop }
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp sport 8080 drop
 inet test-inet input
@@ -179,14 +179,14 @@ inet test-inet input
   [ cmp eq reg 1 0x16000004 0x00000000 ]
 
 # tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 6b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 0x00000000 ]
 
@@ -221,24 +221,24 @@ inet test-inet input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp sequence { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq 42949672 drop
 inet test-inet input
@@ -279,34 +279,34 @@ inet test-inet input
   [ cmp gt reg 1 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp ackseq { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # tcp flags cwr
@@ -362,24 +362,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp window { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum 23456 drop
 inet test-inet input
@@ -420,24 +420,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp checksum { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr 1234 accept
 inet test-inet input
@@ -478,24 +478,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp urgptr { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # tcp doff 8
 inet test-inet input
diff --git a/tests/py/inet/udp.t.payload.inet b/tests/py/inet/udp.t.payload.inet
index 918aca6..4ca9904 100644
--- a/tests/py/inet/udp.t.payload.inet
+++ b/tests/py/inet/udp.t.payload.inet
@@ -33,25 +33,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp sport { 12-40}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp dport 80 accept
 inet test-inet input 
@@ -88,25 +88,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp dport { 70-75} accept
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length 6666
@@ -142,25 +142,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00003200  : 0 [end]	element 00004100  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length { 35-50}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum 6666 drop
 inet test-inet input 
@@ -201,22 +201,22 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/udp.t.payload.ip b/tests/py/inet/udp.t.payload.ip
index b3ec24b..56b6051 100644
--- a/tests/py/inet/udp.t.payload.ip
+++ b/tests/py/inet/udp.t.payload.ip
@@ -33,25 +33,25 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp sport { 12-40}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp dport 80 accept
 ip test-ip4 input
@@ -88,25 +88,25 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp dport { 70-75} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length 6666
@@ -142,25 +142,25 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003200  : 0 [end]	element 00004100  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length { 35-50}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum 6666 drop
 ip test-ip4 input
@@ -201,22 +201,22 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
index 39d8bac..1f1df66 100644
--- a/tests/py/inet/udp.t.payload.ip6
+++ b/tests/py/inet/udp.t.payload.ip6
@@ -33,25 +33,25 @@ ip6 test-ip6 input
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp sport { 12-40}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp dport 80 accept
 ip6 test-ip6 input 
@@ -88,25 +88,25 @@ ip6 test-ip6 input
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp dport { 70-75} accept
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length 6666
@@ -142,25 +142,25 @@ ip6 test-ip6 input
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00003200  : 0 [end]	element 00004100  : 0 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length { 35-50}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum 6666 drop
 ip6 test-ip6 input 
@@ -201,22 +201,22 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
index 918aca6..4ca9904 100644
--- a/tests/py/inet/udp.t.payload.netdev
+++ b/tests/py/inet/udp.t.payload.netdev
@@ -33,25 +33,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp sport { 12-40}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp dport 80 accept
 inet test-inet input 
@@ -88,25 +88,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udp dport { 70-75} accept
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length 6666
@@ -142,25 +142,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00003200  : 0 [end]	element 00004100  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udp length { 35-50}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum 6666 drop
 inet test-inet input 
@@ -201,22 +201,22 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udp checksum { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/udplite.t.payload.inet b/tests/py/inet/udplite.t.payload.inet
index 4c57239..034c62d 100644
--- a/tests/py/inet/udplite.t.payload.inet
+++ b/tests/py/inet/udplite.t.payload.inet
@@ -33,25 +33,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite sport { 12-40}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite dport 80 accept
 inet test-inet input
@@ -88,25 +88,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite dport { 70-75} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udplite checksum 6666 drop
@@ -148,22 +148,22 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite checksum { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/udplite.t.payload.ip b/tests/py/inet/udplite.t.payload.ip
index e870c70..3da9e53 100644
--- a/tests/py/inet/udplite.t.payload.ip
+++ b/tests/py/inet/udplite.t.payload.ip
@@ -33,25 +33,25 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite sport { 12-40}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite dport 80 accept
 ip test-ip4 input
@@ -88,25 +88,25 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite dport { 70-75} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udplite checksum 6666 drop
@@ -148,22 +148,22 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite checksum { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/udplite.t.payload.ip6 b/tests/py/inet/udplite.t.payload.ip6
index 2d31885..205ea21 100644
--- a/tests/py/inet/udplite.t.payload.ip6
+++ b/tests/py/inet/udplite.t.payload.ip6
@@ -33,25 +33,25 @@ ip6 test-ip6 input
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite sport { 12-40}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite dport 80 accept
 ip6 test-ip6 input
@@ -88,25 +88,25 @@ ip6 test-ip6 input
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite dport { 70-75} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udplite checksum 6666 drop
@@ -148,22 +148,22 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite checksum { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/inet/udplite.t.payload.netdev b/tests/py/inet/udplite.t.payload.netdev
index 4c57239..034c62d 100644
--- a/tests/py/inet/udplite.t.payload.netdev
+++ b/tests/py/inet/udplite.t.payload.netdev
@@ -33,25 +33,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite sport { 12-40}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite dport 80 accept
 inet test-inet input
@@ -88,25 +88,25 @@ inet test-inet input
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
 # udplite dport { 70-75} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # udplite checksum 6666 drop
@@ -148,22 +148,22 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # udplite checksum { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 026e871..bf972c6 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -23,8 +23,8 @@ ip test-ip4 prerouting
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
 # iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
@@ -32,7 +32,7 @@ ip test-ip4 prerouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
@@ -49,21 +49,21 @@ ip test-ip4 prerouting
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
 # dnat ct mark map { 0x00000014 : 1.2.3.4}
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00000014  : 04030201 0 [end]
 ip test-ip4 prerouting
   [ ct load mark => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
 # dnat ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00000014 01010101  : 04030201 0 [end]
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
diff --git a/tests/py/ip/dup.t.payload b/tests/py/ip/dup.t.payload
index 7928d5d..1799b3d 100644
--- a/tests/py/ip/dup.t.payload
+++ b/tests/py/ip/dup.t.payload
@@ -10,12 +10,12 @@ ip test-ip4 test
   [ dup sreg_addr 1 sreg_dev 2 ]
 
 # dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device eth0
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
         element 7802a8c0  : 0102a8c0 0 [end]
 ip test-ip4 test 
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ immediate reg 2 0x00000002 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 85369b9..32f2685 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -103,14 +103,14 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000000  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000008  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]	element 0000000d  : 0 [end]	element 0000000e  : 0 [end]	element 0000000f  : 0 [end]	element 00000010  : 0 [end]	element 00000011  : 0 [end]	element 00000012  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmp code 111 accept
@@ -146,24 +146,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00000037 ]
 
 # icmp code { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp code { 2, 4, 54, 33, 56}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000036  : 0 [end]	element 00000021  : 0 [end]	element 00000038  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp checksum 12343 accept
 ip test-ip4 input
@@ -200,25 +200,25 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # icmp checksum { 11-343} accept
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmp checksum { 1111, 222, 343} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmp id 1245 log
@@ -260,24 +260,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # icmp id { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp id { 22, 34, 333}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp sequence 22
 ip test-ip4 input
@@ -310,24 +310,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # icmp sequence { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp sequence { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp mtu 33
 ip test-ip4 input
@@ -345,14 +345,14 @@ ip test-ip4 input
   [ cmp lte reg 1 0x00002100 ]
 
 # icmp mtu { 22-33}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001600  : 0 [end]	element 00002200  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp mtu 22
 ip test-ip4 input
@@ -385,24 +385,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # icmp mtu { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp mtu { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp gateway 22
 ip test-ip4 input
@@ -435,24 +435,24 @@ ip test-ip4 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # icmp gateway { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp gateway { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmp gateway != 34
 ip test-ip4 input
@@ -478,13 +478,13 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply, router-advertisement, router-solicitation} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000000  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000008  : 0 [end]     element 0000000b  : 0 [end]     element 0000000c  : 0 [end]     element 0000000d  : 0 [end]     element 0000000e  : 0 [end]     element 0000000f  : 0 [end]     element 00000010  : 0 [end]     element 00000011  : 0 [end]     element 00000012  : 0 [end]     element 00000009  : 0 [end]     element 0000000a  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index aa3bfe9..1abd965 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -21,20 +21,20 @@ ip test-ip4 input
   [ cmp gt reg 1 0x0000c501 ]
 
 # ip length { 333, 553, 673, 838}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip length { 333-535}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip id 22
 ip test-ip4 input
@@ -59,20 +59,20 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip id { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip id { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip frag-off 222 accept
 ip test-ip4 input
@@ -98,20 +98,20 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip frag-off { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip frag-off { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip ttl 0 drop
 ip test-ip4 input
@@ -137,20 +137,20 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00000032 ]
 
 # ip ttl {43, 53, 45 }
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip ttl { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip protocol tcp
 ip test-ip4 input
@@ -163,12 +163,12 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000006 ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # ip checksum 13172 drop
@@ -200,20 +200,20 @@ ip test-ip4 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip checksum { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip checksum { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip saddr 192.168.2.0/24
 ip test-ip4 input
@@ -273,20 +273,20 @@ ip test-ip4 input
   [ cmp gt reg 1 0xfa00a8c0 ]
 
 # ip daddr { 192.168.0.1-192.168.0.250}
-set%d test-ip4 7
-set%d test-ip4 0
+__set%d test-ip4 7
+__set%d test-ip4 0
 	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # ip daddr 192.168.1.2-192.168.1.55
@@ -348,14 +348,14 @@ ip test-ip4 input
   [ cmp eq reg 1 0x0000ffff ]
 
 # ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
-set%d test-ip 3
-set%d test-ip 0
+__set%d test-ip 3
+__set%d test-ip 0
 	element 01010101 02020202 00000006  : 0 [end]   element 01010101 03030303 00000011  : 0 [end]
 ip test-ip input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 1b @ network header + 9 => reg 10 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip version 4 ip hdrlength 5
 ip test-ip4 input
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 4d4d485..17aacd4 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -29,24 +29,24 @@ inet test-inet input
   [ cmp gt reg 1 0x0000c501 ]
 
 # ip length { 333, 553, 673, 838}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip length { 333-535}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip id 22
 inet test-inet input
@@ -79,24 +79,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip id { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip id { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip frag-off 222 accept
 inet test-inet input
@@ -130,24 +130,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip frag-off { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip frag-off { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip ttl 0 drop
 inet test-inet input
@@ -181,24 +181,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00000032 ]
 
 # ip ttl {43, 53, 45 }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip ttl { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip protocol tcp
 inet test-inet input
@@ -215,14 +215,14 @@ inet test-inet input
   [ cmp neq reg 1 0x00000006 ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # ip checksum 13172 drop
@@ -264,24 +264,24 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip checksum { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip checksum { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip saddr 192.168.2.0/24
 inet test-inet input
@@ -361,24 +361,24 @@ inet test-inet input
   [ cmp gt reg 1 0xfa00a8c0 ]
 
 # ip daddr { 192.168.0.1-192.168.0.250}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # ip daddr 192.168.1.2-192.168.1.55
@@ -460,8 +460,8 @@ inet test-inet input
   [ cmp eq reg 1 0x0000ffff ]
 
 # ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
-set%d test-ip 3
-set%d test-ip 0
+__set%d test-ip 3
+__set%d test-ip 0
         element 01010101 02020202 00000006  : 0 [end]   element 01010101 03030303 00000011  : 0 [end]
 inet test-ip input
   [ meta load nfproto => reg 1 ]
@@ -469,7 +469,7 @@ inet test-ip input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ payload load 1b @ network header + 9 => reg 10 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip version 4 ip hdrlength 5
 inet test-inet input
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 90d6cc8..af0f316 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -29,24 +29,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x0000c501 ]
 
 # ip length { 333, 553, 673, 838}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip length { 333-535}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip id 22
 netdev test-netdev ingress 
@@ -79,24 +79,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip id { 33, 55, 67, 88}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip id { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip frag-off 222 accept
 netdev test-netdev ingress 
@@ -130,24 +130,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip frag-off { 33, 55, 67, 88}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip frag-off { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip ttl 0 drop
 netdev test-netdev ingress 
@@ -174,34 +174,34 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x00000032 ]
 
 # ip ttl {43, 53, 45 }
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip ttl { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # ip checksum 13172 drop
@@ -243,24 +243,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip checksum { 33, 55, 67, 88}
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip checksum { 33-55}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip saddr 192.168.2.0/24
 netdev test-netdev ingress 
@@ -333,24 +333,24 @@ netdev test-netdev ingress
   [ cmp gt reg 1 0xfa00a8c0 ]
 
 # ip daddr { 192.168.0.1-192.168.0.250}
-set%d test-netdev 7
-set%d test-netdev 0
+__set%d test-netdev 7
+__set%d test-netdev 0
 	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
-set%d test-netdev 3
-set%d test-netdev 0
+__set%d test-netdev 3
+__set%d test-netdev 0
 	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # ip daddr 192.168.1.2-192.168.1.55
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index 2479c8c..f4bbe99 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -87,14 +87,14 @@ ip test-ip4 postrouting
   [ masq flags 0x1c ]
 
 # tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ masq ]
 
 # ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade
@@ -110,8 +110,8 @@ ip test-ip4 postrouting
   [ masq ]
 
 # iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
@@ -122,7 +122,7 @@ ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
   [ masq ]
 
 # ip protocol 6 masquerade to :1024
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index da603e7..e02a26d 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -169,14 +169,14 @@ ip test-ip4 output
   [ redir proto_min reg 1 flags 0xc ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ redir ]
 
 # ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect
@@ -192,8 +192,8 @@ ip test-ip4 output
   [ redir ]
 
 # iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
 	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
 ip test-ip4 output
   [ meta load iifname => reg 1 ]
@@ -204,17 +204,17 @@ ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
 
 # ip protocol 6 redirect to tcp dport map { 22 : 8000, 80 : 8080}
-map%d test-ip4 b
-map%d test-ip4 0
+__map%d test-ip4 b
+__map%d test-ip4 0
         element 00001600  : 0000401f 0 [end]    element 00005000  : 0000901f 0 [end]
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ redir proto_min reg 1 ]
 
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 32ba4fa..cbea641 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -23,8 +23,8 @@ ip test-ip4 postrouting
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
 # iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2
-set%d test-ip4 3
-set%d test-ip4 0
+__set%d test-ip4 3
+__set%d test-ip4 0
 	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
@@ -32,7 +32,7 @@ ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index 348506d..15914d9 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -29,34 +29,34 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # dst nexthdr { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst nexthdr { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst nexthdr icmp
 inet test-inet input
@@ -103,22 +103,22 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # dst hdrlength { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst hdrlength { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index 3c778f9..3f6c8e1 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -21,28 +21,28 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # dst nexthdr { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst nexthdr { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst nexthdr icmp
 ip6 test-ip6 input
@@ -77,19 +77,19 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # dst hdrlength { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # dst hdrlength { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 
diff --git a/tests/py/ip6/dup.t.payload b/tests/py/ip6/dup.t.payload
index 1df414c..be50778 100644
--- a/tests/py/ip6/dup.t.payload
+++ b/tests/py/ip6/dup.t.payload
@@ -10,12 +10,12 @@ ip6 test test
   [ dup sreg_addr 1 sreg_dev 2 ]
 
 # dup to ip6 saddr map { abcd::1 : cafe::cafe } device eth0
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
         element 0000cdab 00000000 00000000 01000000  : 0000feca 00000000 00000000 feca0000 0 [end]
 ip6 test-ip6 input 
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ immediate reg 2 0x00000002 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 52eaaff..e2dc172 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -13,14 +13,14 @@ inet test-inet output
   [ cmp neq reg 1 0x00000001 ]
 
 # frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 44 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag nexthdr esp
 inet test-inet output
@@ -67,24 +67,24 @@ inet test-inet output
   [ cmp gt reg 1 0x0000002d ]
 
 # frag reserved { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag reserved { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag frag-off 22
 inet test-inet output
@@ -121,26 +121,26 @@ inet test-inet output
   [ cmp gt reg 1 0x00006801 ]
 
 # frag frag-off { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag frag-off { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag more-fragments 1
 inet test-inet output
@@ -188,22 +188,22 @@ inet test-inet output
   [ cmp gt reg 1 0x2d000000 ]
 
 # frag id { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag id { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index a2adaae..bb5a90b 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -9,12 +9,12 @@ ip6 test-ip6 output
   [ cmp neq reg 1 0x00000001 ]
 
 # frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag nexthdr esp
 ip6 test-ip6 output
@@ -49,20 +49,20 @@ ip6 test-ip6 output
   [ cmp gt reg 1 0x0000002d ]
 
 # frag reserved { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag reserved { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag frag-off 22
 ip6 test-ip6 output
@@ -91,22 +91,22 @@ ip6 test-ip6 output
   [ cmp gt reg 1 0x00006801 ]
 
 # frag frag-off { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 output
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag frag-off { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 output 
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag more-fragments 1
 ip6 test-ip6 output
@@ -142,18 +142,18 @@ ip6 test-ip6 output
   [ cmp gt reg 1 0x2d000000 ]
 
 # frag id { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # frag id { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index e9a583f..5fcd2fd 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -29,34 +29,34 @@ inet test-inet filter-input
   [ cmp gt reg 1 0x0000002d ]
 
 # hbh hdrlength {33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh hdrlength { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr 22
 inet test-inet filter-input
@@ -89,24 +89,24 @@ inet test-inet filter-input
   [ cmp gt reg 1 0x0000002d ]
 
 # hbh nexthdr {33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr ip
 inet test-inet filter-input
diff --git a/tests/py/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
index a201ef5..a2b4633 100644
--- a/tests/py/ip6/hbh.t.payload.ip6
+++ b/tests/py/ip6/hbh.t.payload.ip6
@@ -21,28 +21,28 @@ ip6 test-ip6 filter-input
   [ cmp gt reg 1 0x0000002d ]
 
 # hbh hdrlength {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh hdrlength { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr 22
 ip6 test-ip6 filter-input
@@ -67,20 +67,20 @@ ip6 test-ip6 filter-input
   [ cmp gt reg 1 0x0000002d ]
 
 # hbh nexthdr {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr ip
 ip6 test-ip6 filter-input
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index d13b799..4b6f541 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -119,36 +119,36 @@ ip6 test-ip6 input
   [ immediate reg 0 accept ]
 
 # icmpv6 type {destination-unreachable, time-exceeded, nd-router-solicit} accept
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000001  : 0 [end]	element 00000003  : 0 [end]	element 00000085  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type {router-renumbering, mld-listener-reduction, time-exceeded, nd-router-solicit} accept
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 0000008a  : 0 [end]	element 00000084  : 0 [end]	element 00000003  : 0 [end]	element 00000085  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmpv6 type {mld-listener-query, time-exceeded, nd-router-advert} accept
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000082  : 0 [end]	element 00000003  : 0 [end]	element 00000086  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmpv6 code 4
@@ -167,25 +167,25 @@ ip6 test-ip6 input
   [ cmp lte reg 1 0x00000042 ]
 
 # icmpv6 code {5, 6, 7} accept
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmpv6 code { 3-66}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000003  : 0 [end]	element 00000043  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 checksum 2222 log
 ip6 test-ip6 input
@@ -220,24 +220,24 @@ ip6 test-ip6 input
   [ log prefix (null) ]
 
 # icmpv6 checksum { 222, 226}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 0000de00  : 0 [end]	element 0000e200  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 checksum { 222-226}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 0000de00  : 0 [end]	element 0000e300  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 mtu 22
 ip6 test-ip6 input
@@ -270,24 +270,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x2d000000 ]
 
 # icmpv6 mtu {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 mtu {33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 id 33-45
 ip6 test-ip6 input
@@ -306,24 +306,24 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # icmpv6 id {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 id {33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 sequence 2
 ip6 test-ip6 input
@@ -333,25 +333,25 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000200 ]
 
 # icmpv6 sequence {3, 4, 5, 6, 7} accept
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmpv6 sequence {2, 4}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000200  : 0 [end]	element 00000400  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 sequence 2-4
 ip6 test-ip6 input
@@ -370,14 +370,14 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00000400 ]
 
 # icmpv6 sequence { 2-4}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 max-delay 33-45
 ip6 test-ip6 input
@@ -396,22 +396,22 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # icmpv6 max-delay {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # icmpv6 max-delay {33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 4d2ea35..345e1b0 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -13,24 +13,24 @@ inet test-inet input
   [ cmp neq reg 1 0x00e90000 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 length 22
 inet test-inet input
@@ -63,34 +63,34 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip6 length { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr esp
 inet test-inet input
@@ -107,14 +107,14 @@ inet test-inet input
   [ cmp neq reg 1 0x00000032 ]
 
 # ip6 nexthdr { 33-44}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr 33-44
 inet test-inet input
@@ -163,24 +163,24 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # ip6 hoplimit {33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 hoplimit {33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 inet test-inet input
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index db59bfb..ed3e41e 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -9,20 +9,20 @@ ip6 test-ip6 input
   [ cmp neq reg 1 0x00e90000 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 length 22
 ip6 test-ip6 input
@@ -47,28 +47,28 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # ip6 length { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr esp
 ip6 test-ip6 input
@@ -81,12 +81,12 @@ ip6 test-ip6 input
   [ cmp neq reg 1 0x00000032 ]
 
 # ip6 nexthdr { 33-44}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 nexthdr 33-44
 ip6 test-ip6 input
@@ -123,20 +123,20 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # ip6 hoplimit {33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 hoplimit {33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 ip6 test-ip6 input
diff --git a/tests/py/ip6/map.t.payload b/tests/py/ip6/map.t.payload
index db7df27..9b393a6 100644
--- a/tests/py/ip6/map.t.payload
+++ b/tests/py/ip6/map.t.payload
@@ -1,10 +1,10 @@
 # mark set ip6 saddr and ::ffff map { ::2 : 0x0000002a, ::ffff : 0x00000017}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00000000 00000000 00000000 02000000  : 0000002a 0 [end]	element 00000000 00000000 00000000 ffff0000  : 00000017 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000000 0x00000000 0x00000000 0xffff0000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index 778e709..ded74c0 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -87,14 +87,14 @@ ip6 test-ip6 postrouting
   [ masq flags 0x1c ]
 
 # tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip6 test-ip6 postrouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ masq ]
 
 # ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade
@@ -110,8 +110,8 @@ ip6 test-ip6 postrouting
   [ masq ]
 
 # iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
 ip6 test-ip6 postrouting
   [ meta load iifname => reg 1 ]
@@ -122,7 +122,7 @@ ip6 test-ip6 postrouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
   [ masq ]
 
 # meta l4proto 6 masquerade to :1024
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 8be80e2..5d06566 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -13,14 +13,14 @@ inet test-inet input
   [ cmp neq reg 1 0x00000001 ]
 
 # mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh nexthdr icmp
 inet test-inet input
@@ -67,24 +67,24 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh nexthdr { 33-55 }
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh hdrlength 22
 inet test-inet input
@@ -117,34 +117,34 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh hdrlength { 33-55 }
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000000  : 0 [end]	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]	element 00000008  : 0 [end]	element 00000009  : 0 [end]	element 0000000a  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh type home-agent-switch-message
 inet test-inet input
@@ -191,24 +191,24 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # mh reserved { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh reserved { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh checksum 22
 inet test-inet input
@@ -241,22 +241,22 @@ inet test-inet input
   [ cmp gt reg 1 0x00002d00 ]
 
 # mh checksum { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh checksum { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
index e903b74..d5366a5 100644
--- a/tests/py/ip6/mh.t.payload.ip6
+++ b/tests/py/ip6/mh.t.payload.ip6
@@ -9,12 +9,12 @@ ip6 test-ip6 input
   [ cmp neq reg 1 0x00000001 ]
 
 # mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh nexthdr icmp
 ip6 test-ip6 input
@@ -49,20 +49,20 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh nexthdr { 33-55 }
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh hdrlength 22
 ip6 test-ip6 input
@@ -87,28 +87,28 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh hdrlength { 33-55 }
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000000  : 0 [end]	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]	element 00000008  : 0 [end]	element 00000009  : 0 [end]	element 0000000a  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh type home-agent-switch-message
 ip6 test-ip6 input
@@ -143,20 +143,20 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # mh reserved { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh reserved { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh checksum 22
 ip6 test-ip6 input
@@ -181,18 +181,18 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x00002d00 ]
 
 # mh checksum { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # mh checksum { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index 4e78a24..80250ca 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -153,14 +153,14 @@ ip6 test-ip6 output
   [ redir proto_min reg 1 flags 0x18 ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
   [ redir ]
 
 # ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect
@@ -176,8 +176,8 @@ ip6 test-ip6 output
   [ redir ]
 
 # iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
 ip6 test-ip6 output
   [ meta load iifname => reg 1 ]
@@ -188,17 +188,17 @@ ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
 
 # ip6 nexthdr 6 redirect to tcp dport map { 22 : 8000, 80 : 8080}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00001600  : 0000401f 0 [end]	element 00005000  : 0000901f 0 [end]
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
   [ redir proto_min reg 1 ]
 
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index e7a7123..7d644fb 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -13,14 +13,14 @@ inet test-inet input
   [ cmp neq reg 1 0x00000001 ]
 
 # rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt nexthdr icmp
 inet test-inet input
@@ -67,24 +67,24 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt nexthdr { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt nexthdr { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt hdrlength 22
 inet test-inet input
@@ -117,24 +117,24 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt hdrlength { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt hdrlength { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt type 22
 inet test-inet input
@@ -167,24 +167,24 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt type { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt type { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt seg-left 22
 inet test-inet input
@@ -217,22 +217,22 @@ inet test-inet input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt seg-left { 33, 55, 67, 88}
-set%d test-inet 3
-set%d test-inet 0
+__set%d test-inet 3
+__set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt seg-left { 33-55}
-set%d test-inet 7
-set%d test-inet 0
+__set%d test-inet 7
+__set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
index f766ec0..3245725 100644
--- a/tests/py/ip6/rt.t.payload.ip6
+++ b/tests/py/ip6/rt.t.payload.ip6
@@ -9,12 +9,12 @@ ip6 test-ip6 input
   [ cmp neq reg 1 0x00000001 ]
 
 # rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt nexthdr icmp
 ip6 test-ip6 input
@@ -49,20 +49,20 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt nexthdr { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt nexthdr { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt hdrlength 22
 ip6 test-ip6 input
@@ -87,20 +87,20 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt hdrlength { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt hdrlength { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt type 22
 ip6 test-ip6 input
@@ -125,20 +125,20 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt type { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt type { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt seg-left 22
 ip6 test-ip6 input
@@ -163,18 +163,18 @@ ip6 test-ip6 input
   [ cmp gt reg 1 0x0000002d ]
 
 # rt seg-left { 33, 55, 67, 88}
-set%d test-ip6 3
-set%d test-ip6 0
+__set%d test-ip6 3
+__set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
 # rt seg-left { 33-55}
-set%d test-ip6 7
-set%d test-ip6 0
+__set%d test-ip6 7
+__set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set set%d ]
+  [ lookup reg 1 set __set%d ]
 
diff --git a/tests/py/ip6/vmap.t.payload.inet b/tests/py/ip6/vmap.t.payload.inet
index f0312bf..53f19eb 100644
--- a/tests/py/ip6/vmap.t.payload.inet
+++ b/tests/py/ip6/vmap.t.payload.inet
@@ -1,420 +1,420 @@
 # ip6 saddr vmap { abcd::3 : accept }
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 0000cdab 00000000 00000000 03000000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34120000 34123412 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00003412 34123412 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34120000 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00003412 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34120000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 00003412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 34120000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 00003412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00000000 34123412 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00003412 34120000 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00000000 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00003412 34120000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 00000000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 00003412 34120000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 00000000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00000000 34120000 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00003412 00000000 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00000000 34120000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00003412 00000000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 00000000 34120000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 00003412 00000000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00000000 00000000 34123412 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00003412 00000000 34120000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00000000 00000000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00003412 00000000 34120000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 00000000 00000000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00000000 00000000 34120000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00003412 00000000 00000000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00000000 00000000 34120000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00003412 00000000 00000000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00000000 00000000 00000000 34123412  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00003412 00000000 00000000 34120000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:: : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 00000000 00000000 00000000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234 : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00000000 00000000 00000000 34120000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:: : accept}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 00003412 00000000 00000000 00000000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::/64 : accept}
-map%d test-inet f
-map%d test-inet 0
+__map%d test-inet f
+__map%d test-inet 0
 	element 00000000 00000000 00000000 00000000  : 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 aaaa0000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 bbbb0000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 cccc0000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
-map%d test-inet b
-map%d test-inet 0
+__map%d test-inet b
+__map%d test-inet 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 dddd0000  : 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
diff --git a/tests/py/ip6/vmap.t.payload.ip6 b/tests/py/ip6/vmap.t.payload.ip6
index 0701b9b..620979f 100644
--- a/tests/py/ip6/vmap.t.payload.ip6
+++ b/tests/py/ip6/vmap.t.payload.ip6
@@ -1,336 +1,336 @@
 # ip6 saddr vmap { abcd::3 : accept }
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 0000cdab 00000000 00000000 03000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34120000 34123412 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00003412 34123412 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34120000 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00003412 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34120000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 00003412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 34120000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 00003412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00000000 34123412 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00003412 34120000 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00000000 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00003412 34120000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 00000000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 00003412 34120000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 00000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00000000 34120000 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00003412 00000000 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00000000 34120000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00003412 00000000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 00000000 34120000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 00003412 00000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00000000 00000000 34123412 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00003412 00000000 34120000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00000000 00000000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00003412 00000000 34120000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 00000000 00000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00000000 00000000 34120000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00003412 00000000 00000000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00000000 00000000 34120000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00003412 00000000 00000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00000000 00000000 00000000 34123412  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00003412 00000000 00000000 34120000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:: : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 00000000 00000000 00000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234 : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00000000 00000000 00000000 34120000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:: : accept}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 00003412 00000000 00000000 00000000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::/64 : accept}
-map%d test-ip6 f
-map%d test-ip6 0
+__map%d test-ip6 f
+__map%d test-ip6 0
 	element 00000000 00000000 00000000 00000000  : 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 aaaa0000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 bbbb0000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 cccc0000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
-map%d test-ip6 b
-map%d test-ip6 0
+__map%d test-ip6 b
+__map%d test-ip6 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 dddd0000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
diff --git a/tests/py/ip6/vmap.t.payload.netdev b/tests/py/ip6/vmap.t.payload.netdev
index 3bacb88..0ae5d5b 100644
--- a/tests/py/ip6/vmap.t.payload.netdev
+++ b/tests/py/ip6/vmap.t.payload.netdev
@@ -1,420 +1,420 @@
 # ip6 saddr vmap { abcd::3 : accept }
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 0000cdab 00000000 00000000 03000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34120000 34123412 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00003412 34123412 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34120000 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00003412 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34120000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 00003412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 34120000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 00003412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000000 34123412 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00003412 34120000 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00000000 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00003412 34120000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 00000000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 00003412 34120000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 00000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000000 34120000 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00003412 00000000 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00000000 34120000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00003412 00000000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 00000000 34120000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 00003412 00000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000000 00000000 34123412 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00003412 00000000 34120000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00000000 00000000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00003412 00000000 34120000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 00000000 00000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000000 00000000 34120000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00003412 00000000 00000000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234::1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00000000 00000000 34120000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00003412 00000000 00000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234:1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000000 00000000 00000000 34123412  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234::1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00003412 00000000 00000000 34120000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:1234:: : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 00000000 00000000 00000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::1234 : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00000000 00000000 00000000 34120000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { 1234:: : accept}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 00003412 00000000 00000000 00000000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap { ::/64 : accept}
-map%d test-netdev f
-map%d test-netdev 0
+__map%d test-netdev f
+__map%d test-netdev 0
 	element 00000000 00000000 00000000 00000000  : 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 aaaa0000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 bbbb0000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 cccc0000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
-map%d test-netdev b
-map%d test-netdev 0
+__map%d test-netdev b
+__map%d test-netdev 0
 	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 dddd0000  : 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set map%d dreg 0 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
 
-- 
2.5.5

