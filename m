From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 05/10] tests: update inet/bridge icmp test case
Date: Wed, 27 Sep 2017 20:16:49 +0200
Message-ID: <20170927181654.3129-6-fw@strlen.de>
References: <20170927181654.3129-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37760 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SQw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:16:52 -0400
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

after previous change nft now culls the dependency chain:
'icmpv6 type echo-request' is shown as-is, and not
'meta nfproto ipv6 meta l4proto 58 icmpv6 type echo-request' anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/bridge/icmpX.t | 4 ++--
 tests/py/inet/icmpX.t   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/py/bridge/icmpX.t b/tests/py/bridge/icmpX.t
index 0a1019c3a309..8c0a59799871 100644
--- a/tests/py/bridge/icmpX.t
+++ b/tests/py/bridge/icmpX.t
@@ -3,6 +3,6 @@
 *bridge;test-bridge;input
 
 ip protocol icmp icmp type echo-request;ok;icmp type echo-request
-icmp type echo-request;ok;ether type ip meta l4proto 1 icmp type echo-request
+icmp type echo-request;ok
 ip6 nexthdr icmpv6 icmpv6 type echo-request;ok;icmpv6 type echo-request
-icmpv6 type echo-request;ok;ether type ip6 meta l4proto 58 icmpv6 type echo-request
+icmpv6 type echo-request;ok
diff --git a/tests/py/inet/icmpX.t b/tests/py/inet/icmpX.t
index 7617e701a6d7..1b467a18e764 100644
--- a/tests/py/inet/icmpX.t
+++ b/tests/py/inet/icmpX.t
@@ -3,6 +3,6 @@
 *inet;test-inet;input
 
 ip protocol icmp icmp type echo-request;ok;icmp type echo-request
-icmp type echo-request;ok;meta nfproto ipv4 meta l4proto 1 icmp type echo-request
+icmp type echo-request;ok
 ip6 nexthdr icmpv6 icmpv6 type echo-request;ok;icmpv6 type echo-request
-icmpv6 type echo-request;ok;meta nfproto ipv6 meta l4proto 58 icmpv6 type echo-request
+icmpv6 type echo-request;ok
-- 
2.13.5

