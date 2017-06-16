From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/4] tests: restrict meta nfproto test cases to inet family
Date: Fri, 16 Jun 2017 22:34:10 +0200
Message-ID: <20170616203411.16408-4-fw@strlen.de>
References: <20170616203411.16408-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39954 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751923AbdFPUeD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 16:34:03 -0400
In-Reply-To: <20170616203411.16408-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Followup patch will reject meta nfproto for non-inet families.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/meta.t                      |  5 -----
 tests/py/any/meta.t.payload              | 26 --------------------------
 tests/py/inet/meta.t                     | 10 ++++++++++
 tests/py/inet/meta.t.payload             | 25 +++++++++++++++++++++++++
 tests/shell/testcases/listing/0011sets_0 |  2 +-
 5 files changed, 36 insertions(+), 32 deletions(-)
 create mode 100644 tests/py/inet/meta.t
 create mode 100644 tests/py/inet/meta.t.payload

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 2ff942ff039d..80a0f29bce48 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -25,11 +25,6 @@ meta protocol != {ip, arp, ip6, vlan};ok
 meta protocol ip;ok
 meta protocol != ip;ok
 
-meta nfproto ipv4;ok
-meta nfproto ipv6;ok
-meta nfproto {ipv4, ipv6};ok
-meta nfproto != {ipv4, ipv6};ok
-
 meta l4proto 22;ok
 meta l4proto != 233;ok
 meta l4proto 33-45;ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 871f1ada5abe..b2065f3d920b 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -104,32 +104,6 @@ ip test-ip4 input
   [ meta load protocol => reg 1 ]
   [ cmp neq reg 1 0x00000008 ]
 
-# meta nfproto ipv4
-ip test-ip4 input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-
-# meta nfproto ipv6
-ip test-ip4 input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-
-# meta nfproto {ipv4, ipv6}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
-ip test-ip4 input
-  [ meta load nfproto => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# meta nfproto != {ipv4, ipv6}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
-ip test-ip4 input
-  [ meta load nfproto => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta l4proto 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
new file mode 100644
index 000000000000..723dd46cc6ba
--- /dev/null
+++ b/tests/py/inet/meta.t
@@ -0,0 +1,10 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*inet;test-inet;input
+
+meta nfproto ipv4;ok
+meta nfproto ipv6;ok
+meta nfproto {ipv4, ipv6};ok
+meta nfproto != {ipv4, ipv6};ok
+
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
new file mode 100644
index 000000000000..8b6759a11c36
--- /dev/null
+++ b/tests/py/inet/meta.t.payload
@@ -0,0 +1,25 @@
+# meta nfproto ipv4
+ip test-ip4 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# meta nfproto ipv6
+ip test-ip4 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+
+# meta nfproto {ipv4, ipv6}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
+ip test-ip4 input
+  [ meta load nfproto => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# meta nfproto != {ipv4, ipv6}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
+ip test-ip4 input
+  [ meta load nfproto => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/shell/testcases/listing/0011sets_0 b/tests/shell/testcases/listing/0011sets_0
index 75f2895ff7e5..f021962a3881 100755
--- a/tests/shell/testcases/listing/0011sets_0
+++ b/tests/shell/testcases/listing/0011sets_0
@@ -25,7 +25,7 @@ $NFT add rule ip6 test test udp sport {123}
 
 $NFT add table arp test_arp
 $NFT add chain arp test_arp test
-$NFT add rule arp test_arp test meta nfproto {ipv4}
+$NFT add rule arp test_arp test meta mark {123}
 
 $NFT add table bridge test_bridge
 $NFT add chain bridge test_bridge test
-- 
2.13.0

