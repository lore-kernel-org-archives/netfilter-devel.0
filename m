From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 7/7] tests: add tcp option set support / tcp mss mangling test cases
Date: Sun, 20 Aug 2017 01:14:13 +0200
Message-ID: <20170819231413.15164-8-fw@strlen.de>
References: <20170819231413.15164-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39314 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752393AbdHSXOS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:14:18 -0400
In-Reply-To: <20170819231413.15164-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/rt.t             |  4 +++-
 tests/py/inet/rt.t.payload     |  5 +++++
 tests/py/inet/tcpopt.t         |  3 +++
 tests/py/inet/tcpopt.t.payload | 15 +++++++++++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/tests/py/inet/rt.t b/tests/py/inet/rt.t
index f2dcbdc41da9..64c36579d8f4 100644
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
+tcp option mss set rt mss;ok
diff --git a/tests/py/inet/rt.t.payload b/tests/py/inet/rt.t.payload
index d94973e03ffa..54429492e278 100644
--- a/tests/py/inet/rt.t.payload
+++ b/tests/py/inet/rt.t.payload
@@ -12,3 +12,8 @@ inet test-inet output
   [ rt load nexthop6 => reg 1 ]
   [ cmp eq reg 1 0x000000fd 0x00000000 0x00000000 0x01000000 ]
 
+# tcp option mss set rt mss
+inet test-inet output
+  [ rt load tcpmss => reg 1 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
+
diff --git a/tests/py/inet/tcpopt.t b/tests/py/inet/tcpopt.t
index a42ecd250a9c..94ad3fc4c645 100644
--- a/tests/py/inet/tcpopt.t
+++ b/tests/py/inet/tcpopt.t
@@ -38,3 +38,6 @@ tcp option sack window 1;fail
 
 tcp option window exists;ok
 tcp option window missing;ok
+
+tcp option maxseg size set 1360;ok;tcp option mss set 1360
+tcp option mss set 1360;ok
diff --git a/tests/py/inet/tcpopt.t.payload b/tests/py/inet/tcpopt.t.payload
index 10cf0c00f402..29a955b74ad1 100644
--- a/tests/py/inet/tcpopt.t.payload
+++ b/tests/py/inet/tcpopt.t.payload
@@ -193,3 +193,18 @@ inet test-inet input
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
+
+# tcp option maxseg size set 1360
+inet test-inet input
+  [ immediate reg 1 0x00005005 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
+
+# tcp option maxseg size set 1360
+inet test-inet input
+  [ immediate reg 1 0x00005005 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
+
+# tcp option mss set 1360
+inet test-inet input
+  [ immediate reg 1 0x00005005 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
-- 
2.13.0

