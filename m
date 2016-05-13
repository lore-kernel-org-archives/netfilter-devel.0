From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests/py: add tests for frag more-fragments and frag reserved2
Date: Fri, 13 May 2016 22:02:41 +0200
Message-ID: <1463169761-5945-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46447 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbcEMUC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 16:02:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1CCC8212389
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 22:02:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F8E92687C2
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 22:02:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 31B0C2687C2
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 22:02:49 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While at it, get rid of bug comments on ip6/frag.t, since they are not
valid anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip6/frag.t              | 23 ++---------------------
 tests/py/ip6/frag.t.payload.inet | 24 ++++++++++++++++++++++++
 tests/py/ip6/frag.t.payload.ip6  | 18 ++++++++++++++++++
 3 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/tests/py/ip6/frag.t b/tests/py/ip6/frag.t
index d68fd06..0e632bc 100644
--- a/tests/py/ip6/frag.t
+++ b/tests/py/ip6/frag.t
@@ -20,9 +20,6 @@ frag reserved { 33, 55, 67, 88};ok
 frag reserved { 33-55};ok
 - frag reserved != { 33-55};ok
 
-# BUG: frag frag-off 22 and frag frag-off { 33-55}
-# This breaks table listing: "netlink: Error: Relational expression size mismatch"
-
 frag frag-off 22;ok
 frag frag-off != 233;ok
 frag frag-off 33-45;ok
@@ -32,25 +29,9 @@ frag frag-off { 33, 55, 67, 88};ok
 frag frag-off { 33-55};ok
 - frag frag-off != { 33-55};ok
 
-# BUG  frag reserved2 33 and frag reserved2 1
-# $ sudo nft add rule ip test input frag reserved2 33
-# <cmdline>:1:39-40: Error: Value 33 exceeds valid range 0-3
-# add rule ip test input frag reserved2 33
-#                                      ^^
-# sudo nft add rule ip test input frag reserved2 1
-# <cmdline>:1:1-39: Error: Could not process rule: Invalid argument
-# add rule ip test input frag reserved2 1
-# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-
-# BUG more-fragments 1 and frag more-fragments 4
+frag reserved2 1;ok
+frag more-fragments 0;ok
 frag more-fragments 1;ok
-# <cmdline>:1:1-44: Error: Could not process rule: Invalid argument
-# add rule ip test input frag more-fragments 1
-# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-# $ sudo nft add rule ip test input frag more-fragments 4
-# <cmdline>:1:44-44: Error: Value 4 exceeds valid range 0-1
-# add rule ip test input frag more-fragments 4
-#                                           ^
 
 frag id 1;ok
 frag id 22;ok
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 5916c86..387dbd6 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -207,3 +207,27 @@ inet test-inet output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag reserved2 1
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index ec37be4..1f27975 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -157,3 +157,21 @@ ip6 test-ip6 output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag reserved2 1
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
-- 
2.1.4

