From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: nft removes required payload protocol expressions
Date: Thu, 23 Mar 2017 09:11:56 +0100
Message-ID: <20170323081156.17727-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59114 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751868AbdCWILj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2017 04:11:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This test fails with
'ip protocol tcp tcp dport 22' mismatches 'tcp dport 22'

ip protocol tcp tcp dport 22 is *ONLY* identical to
'tcp dport 22' in the ip family.

For netdev/inet/bridge, the dependency is required because
we only want to match ipv4 packets.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Ran out of time, sorry.

 I'll need to delay both this and the change of ipv6
 nexthdr to meta dependencies until after netdev 2.1.

 tests/py/inet/ip_tcp.t         | 9 +++++++++
 tests/py/inet/ip_tcp.t.payload | 8 ++++++++
 tests/py/ip/ip_tcp.t           | 7 +++++++
 tests/py/ip/ip_tcp.t.payload   | 6 ++++++
 4 files changed, 30 insertions(+)
 create mode 100644 tests/py/inet/ip_tcp.t
 create mode 100644 tests/py/inet/ip_tcp.t.payload
 create mode 100644 tests/py/ip/ip_tcp.t
 create mode 100644 tests/py/ip/ip_tcp.t.payload

diff --git a/tests/py/inet/ip_tcp.t b/tests/py/inet/ip_tcp.t
new file mode 100644
index 000000000000..b69edc38137b
--- /dev/null
+++ b/tests/py/inet/ip_tcp.t
@@ -0,0 +1,9 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*inet;test-inet;input
+*bridge;test-bridge;input
+*netdev;test-netdev;ingress
+
+# must not remove ip dependency -- ONLY ipv4 packets should be matched
+ip protocol tcp tcp dport 22;ok;ip protocol 6 tcp dport 22
diff --git a/tests/py/inet/ip_tcp.t.payload b/tests/py/inet/ip_tcp.t.payload
new file mode 100644
index 000000000000..b13988bc8d5e
--- /dev/null
+++ b/tests/py/inet/ip_tcp.t.payload
@@ -0,0 +1,8 @@
+# ip protocol tcp tcp dport 22
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
diff --git a/tests/py/ip/ip_tcp.t b/tests/py/ip/ip_tcp.t
new file mode 100644
index 000000000000..30759c8f619b
--- /dev/null
+++ b/tests/py/ip/ip_tcp.t
@@ -0,0 +1,7 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*ip;test-inet;input
+
+# can remove ip dependency -- its redundant in ip family
+ip protocol tcp tcp dport 22;ok;tcp dport 22
diff --git a/tests/py/ip/ip_tcp.t.payload b/tests/py/ip/ip_tcp.t.payload
new file mode 100644
index 000000000000..e4141394af7e
--- /dev/null
+++ b/tests/py/ip/ip_tcp.t.payload
@@ -0,0 +1,6 @@
+# ip protocol tcp tcp dport 22
+ip test-inet input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
-- 
2.10.2

