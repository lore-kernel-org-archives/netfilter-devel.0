From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] meta: fix pkttype name and add 'other' symbol
Date: Thu, 27 Oct 2016 18:33:14 +0200
Message-ID: <1477585994-15432-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:32872 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932909AbcJ0RRv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 13:17:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'unicast' doesn't check for unicast packets; it checks for PACKET_HOST,
i.e. a packet coming in for this host.

A unicast address to some other machine (e.g. because nic is
in promisc mode) will have PACKET_OTHER.

So at best this is misleading, so this patch changes it
to 'host'.  The unicast entry is retained for compat purpose.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c                  | 4 +++-
 tests/py/any/meta.t         | 4 ++--
 tests/py/any/meta.t.payload | 4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 63ec452e7900..fb38a21bfd1b 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -327,9 +327,11 @@ static const struct datatype gid_type = {
 
 static const struct symbol_table pkttype_type_tbl = {
 	.symbols	= {
-		SYMBOL("unicast", PACKET_HOST),
+		SYMBOL("host", PACKET_HOST),
+		SYMBOL("unicast", PACKET_HOST), /* backwards compat */
 		SYMBOL("broadcast", PACKET_BROADCAST),
 		SYMBOL("multicast", PACKET_MULTICAST),
+		SYMBOL("other", PACKET_OTHERHOST),
 		SYMBOL_LIST_END,
 	},
 };
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index a1249e8b23e8..76ce06be1e36 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -152,10 +152,10 @@ meta skgid 3000;ok;skgid 3000
 meta rtclassid "cosmos";ok;rtclassid "cosmos"
 
 meta pkttype broadcast;ok;pkttype broadcast
-meta pkttype unicast;ok;pkttype unicast
+meta pkttype host;ok;pkttype host
 meta pkttype multicast;ok;pkttype multicast
 meta pkttype != broadcast;ok;pkttype != broadcast
-meta pkttype != unicast;ok;pkttype != unicast
+meta pkttype != host;ok;pkttype != host
 meta pkttype != multicast;ok;pkttype != multicast
 meta pkttype broadcastttt;fail
 meta pkttype { broadcast, multicast} accept;ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 65d1cd42ec8c..f000bc8018f1 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -530,7 +530,7 @@ ip test-ip4 input
   [ meta load pkttype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# meta pkttype unicast
+# meta pkttype host
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
@@ -545,7 +545,7 @@ ip test-ip4 input
   [ meta load pkttype => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
-# meta pkttype != unicast
+# meta pkttype != host
 ip test-ip4 input
   [ meta load pkttype => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
-- 
2.7.3

