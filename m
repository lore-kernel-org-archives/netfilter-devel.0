From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 07/10] tests: add ip reject with tcp and check for mark too
Date: Tue,  9 May 2017 17:51:19 +0200
Message-ID: <20170509155122.26356-8-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44564 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754783AbdEIPvd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:33 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... to avoid resetting e.g. the ssh session to the vm that runs
nft-test.py.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/bridge/reject.t            | 2 +-
 tests/py/bridge/reject.t.payload    | 4 +++-
 tests/py/inet/reject.t              | 2 +-
 tests/py/inet/reject.t.payload.inet | 4 +++-
 tests/py/ip/reject.t                | 1 +
 tests/py/ip/reject.t.payload        | 8 ++++++++
 tests/py/ip6/reject.t               | 2 +-
 tests/py/ip6/reject.t.payload.ip6   | 4 +++-
 8 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/tests/py/bridge/reject.t b/tests/py/bridge/reject.t
index 4fa6ac0b3278..67deac8d3b5e 100644
--- a/tests/py/bridge/reject.t
+++ b/tests/py/bridge/reject.t
@@ -16,7 +16,7 @@ reject with icmpv6 type admin-prohibited;ok;ether type ip6 reject with icmpv6 ty
 reject with icmpv6 type addr-unreachable;ok;ether type ip6 reject with icmpv6 type addr-unreachable
 reject with icmpv6 type port-unreachable;ok;ether type ip6 reject
 
-ip protocol tcp reject with tcp reset;ok;ip protocol 6 reject with tcp reset
+mark 12345 ip protocol tcp reject with tcp reset;ok;mark 0x00003039 ip protocol 6 reject with tcp reset
 
 reject;ok
 ether type ip reject;ok
diff --git a/tests/py/bridge/reject.t.payload b/tests/py/bridge/reject.t.payload
index f5a0e6a82963..b984f6f8de4d 100644
--- a/tests/py/bridge/reject.t.payload
+++ b/tests/py/bridge/reject.t.payload
@@ -64,8 +64,10 @@ bridge test-bridge input
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 4 ]
 
-# ip protocol tcp reject with tcp reset
+# mark 12345 ip protocol tcp reject with tcp reset
 bridge test-bridge input
+  [ meta load mark => reg 1 ]
+  [ cmp eq reg 1 0x00003039 ]
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
diff --git a/tests/py/inet/reject.t b/tests/py/inet/reject.t
index 638f329cf4d5..7679407e6f8d 100644
--- a/tests/py/inet/reject.t
+++ b/tests/py/inet/reject.t
@@ -16,7 +16,7 @@ reject with icmpv6 type admin-prohibited;ok;meta nfproto ipv6 reject with icmpv6
 reject with icmpv6 type addr-unreachable;ok;meta nfproto ipv6 reject with icmpv6 type addr-unreachable
 reject with icmpv6 type port-unreachable;ok;meta nfproto ipv6 reject
 
-reject with tcp reset;ok;meta l4proto 6 reject with tcp reset
+mark 12345 reject with tcp reset;ok;meta l4proto 6 mark 0x00003039 reject with tcp reset
 
 reject;ok
 meta nfproto ipv4 reject;ok
diff --git a/tests/py/inet/reject.t.payload.inet b/tests/py/inet/reject.t.payload.inet
index 5770330d9072..7a6468e81f9e 100644
--- a/tests/py/inet/reject.t.payload.inet
+++ b/tests/py/inet/reject.t.payload.inet
@@ -64,10 +64,12 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 0 code 4 ]
 
-# reject with tcp reset
+# mark 12345 reject with tcp reset
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
+  [ meta load mark => reg 1 ]
+  [ cmp eq reg 1 0x00003039 ]
   [ reject type 1 code 0 ]
 
 # reject
diff --git a/tests/py/ip/reject.t b/tests/py/ip/reject.t
index 6006f0541cb8..7befe697fa23 100644
--- a/tests/py/ip/reject.t
+++ b/tests/py/ip/reject.t
@@ -10,6 +10,7 @@ reject with icmp type port-unreachable;ok;reject
 reject with icmp type net-prohibited;ok
 reject with icmp type host-prohibited;ok
 reject with icmp type admin-prohibited;ok
+mark 0x80000000 reject with tcp reset;ok
 
 reject with icmp type no-route;fail
 reject with icmpv6 type no-route;fail
diff --git a/tests/py/ip/reject.t.payload b/tests/py/ip/reject.t.payload
index d5e87665ebc5..ec94b4c1a1c5 100644
--- a/tests/py/ip/reject.t.payload
+++ b/tests/py/ip/reject.t.payload
@@ -30,3 +30,11 @@ ip test-ip4 output
 ip test-ip4 output
   [ reject type 0 code 13 ]
 
+# mark 0x80000000 reject with tcp reset
+ip test-ip4 output
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ meta load mark => reg 1 ]
+  [ cmp eq reg 1 0x80000000 ]
+  [ reject type 1 code 0 ]
+
diff --git a/tests/py/ip6/reject.t b/tests/py/ip6/reject.t
index de09fd978418..a95f2e3fe14a 100644
--- a/tests/py/ip6/reject.t
+++ b/tests/py/ip6/reject.t
@@ -9,7 +9,7 @@ reject with icmpv6 type addr-unreachable;ok
 reject with icmpv6 type port-unreachable;ok;reject
 reject with icmpv6 type policy-fail;ok
 reject with icmpv6 type reject-route;ok
-reject with tcp reset;ok
+mark 0x80000000 reject with tcp reset;ok
 
 reject with icmpv6 type host-unreachable;fail
 reject with icmp type host-unreachable;fail
diff --git a/tests/py/ip6/reject.t.payload.ip6 b/tests/py/ip6/reject.t.payload.ip6
index 0ba5f7ee5bfd..dd4491ae47a8 100644
--- a/tests/py/ip6/reject.t.payload.ip6
+++ b/tests/py/ip6/reject.t.payload.ip6
@@ -26,9 +26,11 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ reject type 0 code 6 ]
 
-# reject with tcp reset
+# mark 0x80000000 reject with tcp reset
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
+  [ meta load mark => reg 1 ]
+  [ cmp eq reg 1 0x80000000 ]
   [ reject type 1 code 0 ]
 
-- 
2.10.2

