From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/4] tests: remove two non-sensical rules
Date: Fri, 16 Jun 2017 22:34:09 +0200
Message-ID: <20170616203411.16408-3-fw@strlen.de>
References: <20170616203411.16408-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39950 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751923AbdFPUd7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 16:33:59 -0400
In-Reply-To: <20170616203411.16408-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

meta nfproto returns the hook family that the current packet
is being evaluted in, e.g.
NFPROTO_NETDEV in case we're called from the netdev context.

This makes no sense, if we add a rule to netdev, bridge, ip, ...
table then thats where it will be evaluated, no runtime test needed.

Only exception: inet family, in this case, nfproto will be either
ipv4 or ipv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/ether.t         |  2 --
 tests/py/inet/ether.t.payload | 23 -----------------------
 2 files changed, 25 deletions(-)

diff --git a/tests/py/inet/ether.t b/tests/py/inet/ether.t
index 0a88aef1609b..afdf8b89ca65 100644
--- a/tests/py/inet/ether.t
+++ b/tests/py/inet/ether.t
@@ -7,9 +7,7 @@
 *bridge;test-bridge;input
 *netdev;test-netdev;ingress
 
-tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4 accept
 tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept;ok
 
 ether saddr 00:0f:54:0c:11:04 accept;ok
-ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4;ok
diff --git a/tests/py/inet/ether.t.payload b/tests/py/inet/ether.t.payload
index 86f30c37f6bd..53648413d588 100644
--- a/tests/py/inet/ether.t.payload
+++ b/tests/py/inet/ether.t.payload
@@ -1,17 +1,3 @@
-# tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ immediate reg 0 accept ]
-
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -44,12 +30,3 @@ inet test-inet input
   [ cmp eq reg 1 0x0c540f00 0x00000411 ]
   [ immediate reg 0 accept ]
 
-# ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4
-inet test-inet input
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-
-- 
2.13.0

