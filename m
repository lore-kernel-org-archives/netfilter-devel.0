From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/4] tests: frag: enable more tests
Date: Wed,  9 Mar 2016 00:09:45 +0100
Message-ID: <1457478588-12592-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39524 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbcCHXQ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 18:16:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip6/frag.t              |  8 ++++----
 tests/py/ip6/frag.t.payload.inet | 38 ++++++++++++++++++++++++++++++++++++++
 tests/py/ip6/frag.t.payload.ip6  | 30 ++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/tests/py/ip6/frag.t b/tests/py/ip6/frag.t
index 56801ed..1551044 100644
--- a/tests/py/ip6/frag.t
+++ b/tests/py/ip6/frag.t
@@ -23,13 +23,13 @@ frag reserved { 33-55};ok
 # BUG: frag frag-off 22 and frag frag-off { 33-55}
 # This breaks table listing: "netlink: Error: Relational expression size mismatch"
 
-- frag frag-off 22;ok
-- frag frag-off != 233;ok
+frag frag-off 22;ok
+frag frag-off != 233;ok
 - frag frag-off 33-45;ok
 - frag frag-off != 33-45;ok
-- frag frag-off { 33, 55, 67, 88};ok
+frag frag-off { 33, 55, 67, 88};ok
 - frag frag-off != { 33, 55, 67, 88};ok
-- frag frag-off { 33-55};ok
+frag frag-off { 33-55};ok
 - frag frag-off != { 33-55};ok
 
 # BUG  frag reserved2 33 and frag reserved2 1
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 7cedaf3..e04d128 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -86,6 +86,44 @@ inet test-inet output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# frag frag-off 22
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
+# frag frag-off { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
 # frag id 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index f2d04b6..b3da6fe 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -64,6 +64,36 @@ ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# frag frag-off 22
+ip6 test-ip6 output
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+ip6 test-ip6 output
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off { 33, 55, 67, 88}
+set%d test-ip6 3
+set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
+# frag frag-off { 33-55}
+set%d test-ip6 7
+set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 output 
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
 # frag id 1
 ip6 test-ip6 output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
-- 
2.4.10

