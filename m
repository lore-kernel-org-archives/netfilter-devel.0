From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 12/17] tests: update inet/bridge icmp test case
Date: Wed, 28 Jun 2017 12:14:05 +0200
Message-ID: <20170628101410.29134-2-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
 <20170628101410.29134-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33442 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751559AbdF1KOB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:14:01 -0400
In-Reply-To: <20170628101410.29134-1-fw@strlen.de>
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
2.13.0

