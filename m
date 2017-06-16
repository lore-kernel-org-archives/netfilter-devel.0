From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/4] tests: restrict ct saddr test to inet family
Date: Fri, 16 Jun 2017 22:34:08 +0200
Message-ID: <20170616203411.16408-2-fw@strlen.de>
References: <20170616203411.16408-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39946 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751923AbdFPUd4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 16:33:56 -0400
In-Reply-To: <20170616203411.16408-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

any/ct.t: ERROR: line 94: src/nft add rule --debug=netlink ip6
test-ip6 output meta nfproto ipv4 ct original saddr 1.2.3.4: This rule should not have failed.

Actually, this failure is "ok; we can't find upper layer protocol
in this case, but even if we'd "fix" this it is still non-sensical,
meta nfproto ipv4, but family is ipv6 --> rule would never match.

First move this to an inet-specific test.
A followup patch will reject meta nfproto for all families except inet.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/ct.t          |  1 -
 tests/py/any/ct.t.payload  |  7 -------
 tests/py/inet/ct.t         | 10 ++++++++++
 tests/py/inet/ct.t.payload | 13 +++++++++++++
 4 files changed, 23 insertions(+), 8 deletions(-)
 create mode 100644 tests/py/inet/ct.t
 create mode 100644 tests/py/inet/ct.t.payload

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 20f047a2963b..3a58162d2846 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -91,7 +91,6 @@ ct bytes original reply;fail
 # missing direction
 ct saddr 1.2.3.4;fail
 
-meta nfproto ipv4 ct original saddr 1.2.3.4;ok
 # wrong base (ip6 but ipv4 address given)
 meta nfproto ipv6 ct original saddr 1.2.3.4;fail
 
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 80513c803557..20acbb9b63d1 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -373,13 +373,6 @@ ip test-ip4 output
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
   [ cmp lt reg 1 0x00000000 0xf4010000 ]
 
-# meta nfproto ipv4 ct original saddr 1.2.3.4
-ip test-ip4 output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ ct load src => reg 1 , dir original ]
-  [ cmp eq reg 1 0x04030201 ]
-
 # ct status expected,seen-reply,assured,confirmed,snat,dnat,dying
 ip test-ip4 output
   [ ct load status => reg 1 ]
diff --git a/tests/py/inet/ct.t b/tests/py/inet/ct.t
new file mode 100644
index 000000000000..c56c3bc86151
--- /dev/null
+++ b/tests/py/inet/ct.t
@@ -0,0 +1,10 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*inet;test-inet;input
+
+meta nfproto ipv4 ct original saddr 1.2.3.4;ok
+meta nfproto ipv6 ct original saddr ::1;ok
+
+# missing protocol context
+ct original saddr ::1;fail
diff --git a/tests/py/inet/ct.t.payload b/tests/py/inet/ct.t.payload
new file mode 100644
index 000000000000..21c74581de3a
--- /dev/null
+++ b/tests/py/inet/ct.t.payload
@@ -0,0 +1,13 @@
+# meta nfproto ipv4 ct original saddr 1.2.3.4
+ip test-ip4 output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ ct load src => reg 1 , dir original ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# meta nfproto ipv6 ct original saddr ::1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ ct load src => reg 1 , dir original ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
-- 
2.13.0

