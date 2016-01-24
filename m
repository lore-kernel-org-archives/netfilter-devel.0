From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] tests: add two map test cases
Date: Sun, 24 Jan 2016 18:58:26 +0100
Message-ID: <1453658307-7177-2-git-send-email-fw@strlen.de>
References: <1453658307-7177-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57952 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbcAXSGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jan 2016 13:06:11 -0500
In-Reply-To: <1453658307-7177-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

One normal map lookup, one with an explicit binop.
The latter is supposed to also work with the followup patch applied.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/map.t                |  8 ++++++++
 tests/py/inet/map.t.payload.inet   | 11 +++++++++++
 tests/py/inet/map.t.payload.ip     |  9 +++++++++
 tests/py/inet/map.t.payload.netdev | 11 +++++++++++
 tests/py/ip6/map.t                 |  5 +++++
 tests/py/ip6/map.t.payload         | 10 ++++++++++
 6 files changed, 54 insertions(+)
 create mode 100644 tests/py/inet/map.t
 create mode 100644 tests/py/inet/map.t.payload.inet
 create mode 100644 tests/py/inet/map.t.payload.ip
 create mode 100644 tests/py/inet/map.t.payload.netdev
 create mode 100644 tests/py/ip6/map.t
 create mode 100644 tests/py/ip6/map.t.payload

diff --git a/tests/py/inet/map.t b/tests/py/inet/map.t
new file mode 100644
index 0000000..f48afcd
--- /dev/null
+++ b/tests/py/inet/map.t
@@ -0,0 +1,8 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*ip;test-ip4;input
+*inet;test-inet;input
+*netdev;test-netdev;ingress
+
+mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017};ok;mark set ip saddr map { 10.2.3.1 : 0x00000017, 10.2.3.2 : 0x0000002a}
diff --git a/tests/py/inet/map.t.payload.inet b/tests/py/inet/map.t.payload.inet
new file mode 100644
index 0000000..73e68b6
--- /dev/null
+++ b/tests/py/inet/map.t.payload.inet
@@ -0,0 +1,11 @@
+# mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
+map%d test-inet b
+map%d test-inet 0
+	element 0203020a  : 0000002a 0 [end]	element 0103020a  : 00000017 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
diff --git a/tests/py/inet/map.t.payload.ip b/tests/py/inet/map.t.payload.ip
new file mode 100644
index 0000000..54b9583
--- /dev/null
+++ b/tests/py/inet/map.t.payload.ip
@@ -0,0 +1,9 @@
+# mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
+map%d test-ip b
+map%d test-ip 0
+	element 0103020a  : 00000017 0 [end]	element 0203020a  : 0000002a 0 [end]
+ip test-ip input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
diff --git a/tests/py/inet/map.t.payload.netdev b/tests/py/inet/map.t.payload.netdev
new file mode 100644
index 0000000..27a3ca8
--- /dev/null
+++ b/tests/py/inet/map.t.payload.netdev
@@ -0,0 +1,11 @@
+# mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017}
+map%d test-netdev b
+map%d test-netdev 0
+	element 0103020a  : 00000017 0 [end]	element 0203020a  : 0000002a 0 [end]
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
diff --git a/tests/py/ip6/map.t b/tests/py/ip6/map.t
new file mode 100644
index 0000000..3377f8d
--- /dev/null
+++ b/tests/py/ip6/map.t
@@ -0,0 +1,5 @@
+:input;type filter hook input priority 0
+*ip6;test-ip6;input
+
+mark set ip6 saddr and ::ffff map { ::2 : 0x0000002a, ::ffff : 0x00000017};ok;mark set ip6 saddr & ::ffff map { ::2 : 0x0000002a, ::ffff : 0x00000017}
+
diff --git a/tests/py/ip6/map.t.payload b/tests/py/ip6/map.t.payload
new file mode 100644
index 0000000..db7df27
--- /dev/null
+++ b/tests/py/ip6/map.t.payload
@@ -0,0 +1,10 @@
+# mark set ip6 saddr and ::ffff map { ::2 : 0x0000002a, ::ffff : 0x00000017}
+map%d test-ip6 b
+map%d test-ip6 0
+	element 00000000 00000000 00000000 02000000  : 0000002a 0 [end]	element 00000000 00000000 00000000 ffff0000  : 00000017 0 [end]
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000000 0x00000000 0x00000000 0xffff0000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
-- 
2.4.10

