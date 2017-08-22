From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] tests: add tcp option set support / tcp mss mangling test cases
Date: Tue, 22 Aug 2017 15:51:41 +0200
Message-ID: <20170822135141.10785-4-fw@strlen.de>
References: <20170822135141.10785-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51062 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932922AbdHVNvd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 09:51:33 -0400
In-Reply-To: <20170822135141.10785-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: adjust for new syntax

 tests/py/inet/rt.t             | 4 +++-
 tests/py/inet/rt.t.payload     | 5 +++++
 tests/py/inet/tcpopt.t         | 2 ++
 tests/py/inet/tcpopt.t.payload | 5 +++++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/tests/py/inet/rt.t b/tests/py/inet/rt.t
index f2dcbdc41da9..9543738b786c 100644
--- a/tests/py/inet/rt.t
+++ b/tests/py/inet/rt.t
@@ -1,4 +1,4 @@
-:output;type filter hook input priority 0
+:output;type filter hook output priority 0
 
 *inet;test-inet;output
 
@@ -6,3 +6,5 @@ rt nexthop 192.168.0.1;fail
 rt nexthop fd00::1;fail
 meta nfproto ipv4 rt nexthop 192.168.0.1;ok
 meta nfproto ipv6 rt nexthop fd00::1;ok
+
+tcp option maxseg size set rt mtu;ok
diff --git a/tests/py/inet/rt.t.payload b/tests/py/inet/rt.t.payload
index d94973e03ffa..2f6265ed640a 100644
--- a/tests/py/inet/rt.t.payload
+++ b/tests/py/inet/rt.t.payload
@@ -12,3 +12,8 @@ inet test-inet output
   [ rt load nexthop6 => reg 1 ]
   [ cmp eq reg 1 0x000000fd 0x00000000 0x00000000 0x01000000 ]
 
+# tcp option maxseg size set rt mtu
+inet test-inet output
+  [ rt load tcpmss => reg 1 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
+
diff --git a/tests/py/inet/tcpopt.t b/tests/py/inet/tcpopt.t
index a42ecd250a9c..b457691f7f27 100644
--- a/tests/py/inet/tcpopt.t
+++ b/tests/py/inet/tcpopt.t
@@ -38,3 +38,5 @@ tcp option sack window 1;fail
 
 tcp option window exists;ok
 tcp option window missing;ok
+
+tcp option maxseg size set 1360;ok
diff --git a/tests/py/inet/tcpopt.t.payload b/tests/py/inet/tcpopt.t.payload
index 10cf0c00f402..7e254ed3f605 100644
--- a/tests/py/inet/tcpopt.t.payload
+++ b/tests/py/inet/tcpopt.t.payload
@@ -193,3 +193,8 @@ inet test-inet input
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
+
+# tcp option maxseg size set 1360
+inet test-inet input
+  [ immediate reg 1 0x00005005 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
-- 
2.13.0

