From: Manuel Johannes Messner <manuel.johannes.messner@hs-furtwangen.de>
Subject: [PATCH 2/3] tests: py: any: Make tests more generic by using other interfaces
Date: Mon,  5 Sep 2016 20:20:13 +0200
Message-ID: <20160905182014.8762-3-manuel.johannes.messner@hs-furtwangen.de>
References: <20160905182014.8762-1-manuel.johannes.messner@hs-furtwangen.de>
Cc: fw@strlen.de, messnera@hs-furtwangen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx.rz.hs-furtwangen.de ([141.28.2.11]:39111 "HELO
        mx.rz.hs-furtwangen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754689AbcIES1d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 14:27:33 -0400
In-Reply-To: <20160905182014.8762-1-manuel.johannes.messner@hs-furtwangen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some tests use hard coded interface names and iterface indexes.
This commit removes these cases by exchanging "eth0" with "dummy0" and
"lo" (depending on the test) in all ifname tests and by using "lo"
instead of "eth0" in all interface index tests (because we can assume
"lo" ifindex is 1).

Signed-off-by: Manuel Johannes Messner <manuel.johannes.messner@hs-furtwangen.de>
---
 tests/py/any/meta.t         | 46 +++++++++++-----------
 tests/py/any/meta.t.payload | 96 ++++++++++++++++++++++-----------------------
 2 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index ceeac48..852ef82 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -65,17 +65,17 @@ meta mark or 0x03 != 0x01;ok;mark | 0x00000003 != 0x00000001
 meta mark xor 0x03 == 0x01;ok;mark 0x00000002
 meta mark xor 0x03 != 0x01;ok;mark != 0x00000002
 
-meta iif "eth0" accept;ok;iif "eth0" accept
-meta iif "eth0" accept;ok;iif "eth0" accept
-meta iif != "eth0" accept;ok;iif != "eth0" accept
-meta iif != "eth0" accept;ok;iif != "eth0" accept
-
-meta iifname "eth0";ok;iifname "eth0"
-meta iifname != "eth0";ok;iifname != "eth0"
-meta iifname {"eth0", "lo"};ok
-- meta iifname != {"eth0", "lo"};ok
-meta iifname "eth*";ok;iifname "eth*"
-meta iifname "eth\*";ok;iifname "eth\*"
+meta iif "lo" accept;ok;iif "lo" accept
+meta iif "lo" accept;ok;iif "lo" accept
+meta iif != "lo" accept;ok;iif != "lo" accept
+meta iif != "lo" accept;ok;iif != "lo" accept
+
+meta iifname "dummy0";ok;iifname "dummy0"
+meta iifname != "dummy0";ok;iifname != "dummy0"
+meta iifname {"dummy0", "lo"};ok
+- meta iifname != {"dummy0", "lo"};ok
+meta iifname "dummy*";ok;iifname "dummy*"
+meta iifname "dummy\*";ok;iifname "dummy\*"
 
 meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
@@ -86,15 +86,15 @@ meta iiftype ppp;ok;iiftype ppp
 
 meta oif "lo" accept;ok;oif "lo" accept
 meta oif != "lo" accept;ok;oif != "lo" accept
-meta oif {"eth0", "lo"} accept;ok
-- meta oif != {"eth0", "lo"} accept;ok
+meta oif {"lo"} accept;ok
+- meta oif != {"lo"} accept;ok
 
-meta oifname "eth0";ok;oifname "eth0"
-meta oifname != "eth0";ok;oifname != "eth0"
-meta oifname { "eth0", "lo"};ok
-- meta iifname != {"eth0", "lo"};ok
-meta oifname "eth*";ok;oifname "eth*"
-meta oifname "eth\*";ok;oifname "eth\*"
+meta oifname "dummy0";ok;oifname "dummy0"
+meta oifname != "dummy0";ok;oifname != "dummy0"
+meta oifname { "dummy0", "lo"};ok
+- meta iifname != {"dummy0", "lo"};ok
+meta oifname "dummy*";ok;oifname "dummy*"
+meta oifname "dummy\*";ok;oifname "dummy\*"
 
 meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
@@ -146,7 +146,7 @@ meta mark set 0xfffe xor 0x16;ok;mark set 0x0000ffe8
 
 meta iif "lo";ok;iif "lo"
 meta oif "lo";ok;oif "lo"
-meta oifname "eth2" accept;ok;oifname "eth2" accept
+meta oifname "dummy2" accept;ok;oifname "dummy2" accept
 meta skuid 3000;ok;skuid 3000
 meta skgid 3000;ok;skgid 3000
 # BUG:  meta nftrace 1;ok
@@ -201,9 +201,9 @@ meta cgroup != 1048577-1048578;ok;cgroup != 1048577-1048578
 meta cgroup {1048577-1048578};ok;cgroup { 1048577-1048578}
 # meta cgroup != { 1048577-1048578};ok;cgroup != { 1048577-1048578}
 
-meta iif . meta oif { "lo" . "eth0" };ok
-meta iif . meta oif . meta mark { "lo" . "eth0" . 0x0000000a };ok
-meta iif . meta oif vmap { "lo" . "eth0" : drop };ok
+meta iif . meta oif { "lo" . "lo" };ok
+meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a };ok
+meta iif . meta oif vmap { "lo" . "lo" : drop };ok
 
 meta random eq 1;ok;meta random 1
 meta random gt 1000000;ok;meta random > 1000000
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 19bb17c..19cc6ac 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -193,57 +193,57 @@ ip test-ip4 input
   [ meta load mark => reg 1 ]
   [ cmp neq reg 1 0x00000002 ]
 
-# meta iif "eth0" accept
+# meta iif "lo" accept
 ip test-ip4 input
   [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
-# meta iif "eth0" accept
+# meta iif "lo" accept
 ip test-ip4 input
   [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+  [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
-# meta iif != "eth0" accept
+# meta iif != "lo" accept
 ip test-ip4 input
   [ meta load iif => reg 1 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ cmp neq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
-# meta iif != "eth0" accept
+# meta iif != "lo" accept
 ip test-ip4 input
   [ meta load iif => reg 1 ]
-  [ cmp neq reg 1 0x00000002 ]
+  [ cmp neq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
-# meta iifname "eth0"
+# meta iifname "dummy0"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
 
-# meta iifname != "eth0"
+# meta iifname != "dummy0"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp neq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp neq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
 
-# meta iifname {"eth0", "lo"}
+# meta iifname {"dummy0", "lo"}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 30687465 00000000 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
+	element 6d6d7564 00003079 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# meta iifname "eth*"
+# meta iifname "dummy*"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x00687465 ]
+  [ cmp eq reg 1 0x6d6d7564 0x00000079 ]
 
-# meta iifname "eth\*"
+# meta iifname "dummy\*"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
-  [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x6d6d7564 0x00002a79 0x00000000 0x00000000 ]
 
 # meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 __set%d test-ip4 3
@@ -285,42 +285,42 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
-# meta oif {"eth0", "lo"} accept
+# meta oif {"lo"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000002  : 0 [end]	element 00000001  : 0 [end]
+	element 00000001  : 0 [end]
 ip test-ip4 input
   [ meta load oif => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
-# meta oifname "eth0"
+# meta oifname "dummy0"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
 
-# meta oifname != "eth0"
+# meta oifname != "dummy0"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp neq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp neq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
 
-# meta oifname { "eth0", "lo"}
+# meta oifname { "dummy0", "lo"}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 30687465 00000000 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
+	element 6d6d7564 00003079 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# meta oifname "eth*"
+# meta oifname "dummy*"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x00687465 ]
+  [ cmp eq reg 1 0x6d6d7564 0x00000079 ]
 
-# meta oifname "eth\*"
+# meta oifname "dummy\*"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x6d6d7564 0x00002a79 0x00000000 0x00000000 ]
 
 # meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
 __set%d test-ip4 3
@@ -520,10 +520,10 @@ ip test-ip4 input
   [ meta load oif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# meta oifname "eth2" accept
+# meta oifname "dummy2" accept
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
-  [ cmp eq reg 1 0x32687465 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0x6d6d7564 0x00003279 0x00000000 0x00000000 ]
   [ immediate reg 0 accept ]
 
 # meta skuid 3000
@@ -753,29 +753,29 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
 
 
-# meta iif . meta oif { "lo" . "eth0" }
+# meta iif . meta oif { "lo" . "lo" }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001 00000002  : 0 [end]
+	element 00000001 00000001  : 0 [end]
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
   [ lookup reg 1 set __set%d ]
 
-# meta iif . meta oif . meta mark { "lo" . "eth0" . 0x0000000a }
+# meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a }
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000001 00000002 0000000a  : 0 [end]
+	element 00000001 00000001 0000000a  : 0 [end]
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
   [ meta load mark => reg 10 ]
   [ lookup reg 1 set __set%d ]
 
-# meta iif . meta oif vmap { "lo" . "eth0" : drop }
+# meta iif . meta oif vmap { "lo" . "lo" : drop }
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000001 00000002  : 0 [end]
+	element 00000001 00000001  : 0 [end]
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
@@ -792,12 +792,12 @@ ip test-ip4 input
   [ cmp gt reg 1 0x40420f00 ]
 
 # meta priority root
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp eq reg 1 0xffffffff ]
 
 # meta priority none
-netdev test-netdev ingress 
+netdev test-netdev ingress
   [ meta load priority => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
@@ -807,34 +807,34 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00011234 ]
 
 # meta priority bcad:dadc
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp eq reg 1 0xbcaddadc ]
 
 # meta priority aabb:0
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp eq reg 1 0xaabb0000 ]
 
 # meta priority != bcad:dadc
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp neq reg 1 0xbcaddadc ]
 
 # meta priority != aabb:0
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp neq reg 1 0xaabb0000 ]
 
 # meta priority bcad:dada-bcad:dadc
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ cmp gte reg 1 0xdadaadbc ]
   [ cmp lte reg 1 0xdcdaadbc ]
 
 # meta priority != bcad:dada-bcad:dadc
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ cmp lt reg 1 0xdadaadbc ]
@@ -844,12 +844,12 @@ ip test-ip4 input
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element bcaddada  : 0 [end]	element bcaddadc  : 0 [end]	element aaaabbbb  : 0 [end]
-ip test-ip4 input 
+ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # meta priority set cafe:beef
-ip test-ip4 input 
+ip test-ip4 input
   [ immediate reg 1 0xcafebeef ]
   [ meta set priority with reg 1 ]
 
-- 
2.9.3

