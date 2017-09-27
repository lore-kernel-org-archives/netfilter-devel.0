From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 09/10] tests: rt: fix test cases
Date: Wed, 27 Sep 2017 20:16:53 +0200
Message-ID: <20170927181654.3129-10-fw@strlen.de>
References: <20170927181654.3129-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37778 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SRG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:17:06 -0400
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfproto meta dependency is no longer needed, keep one test
since we still support this syntax.

When meta is not provided, no need to add a dependency because
nft_rt already checks pf number before checking skb->dst.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/rt.t         | 10 ++++++++--
 tests/py/inet/rt.t.payload |  4 +---
 tests/py/ip/rt.t           |  3 ++-
 tests/py/ip6/rt0.t         |  2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/tests/py/inet/rt.t b/tests/py/inet/rt.t
index 9543738b786c..23608ab2c2f9 100644
--- a/tests/py/inet/rt.t
+++ b/tests/py/inet/rt.t
@@ -4,7 +4,13 @@
 
 rt nexthop 192.168.0.1;fail
 rt nexthop fd00::1;fail
-meta nfproto ipv4 rt nexthop 192.168.0.1;ok
-meta nfproto ipv6 rt nexthop fd00::1;ok
+
+meta nfproto ipv4 rt nexthop 192.168.0.1;ok;meta nfproto ipv4 rt ip nexthop 192.168.0.1
+rt ip6 nexthop fd00::1;ok
+
+# missing context
+rt nexthop fd00::1;fail
+# wrong context
+rt ip nexthop fd00::1;fail
 
 tcp option maxseg size set rt mtu;ok
diff --git a/tests/py/inet/rt.t.payload b/tests/py/inet/rt.t.payload
index 928e0095faf5..84dea12caad5 100644
--- a/tests/py/inet/rt.t.payload
+++ b/tests/py/inet/rt.t.payload
@@ -5,10 +5,8 @@ inet test-inet output
   [ rt load nexthop4 => reg 1 ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# meta nfproto ipv6 rt nexthop fd00::1
+# rt ip6 nexthop fd00::1
 inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
   [ rt load nexthop6 => reg 1 ]
   [ cmp eq reg 1 0x000000fd 0x00000000 0x00000000 0x01000000 ]
 
diff --git a/tests/py/ip/rt.t b/tests/py/ip/rt.t
index 99750c5d76aa..986bf3417179 100644
--- a/tests/py/ip/rt.t
+++ b/tests/py/ip/rt.t
@@ -2,5 +2,6 @@
 
 *ip;test-ip4;output
 
-rt nexthop 192.168.0.1;ok
+rt nexthop 192.168.0.1;ok;rt ip nexthop 192.168.0.1
 rt nexthop fd00::1;fail
+rt ip6 nexthop fd00::1;fail
diff --git a/tests/py/ip6/rt0.t b/tests/py/ip6/rt0.t
index 92614de3936f..1d50a89cf2f7 100644
--- a/tests/py/ip6/rt0.t
+++ b/tests/py/ip6/rt0.t
@@ -3,4 +3,4 @@
 *ip6;test-ip6;output
 
 rt nexthop 192.168.0.1;fail
-rt nexthop fd00::1;ok
+rt nexthop fd00::1;ok;rt ip6 nexthop fd00::1
-- 
2.13.5

