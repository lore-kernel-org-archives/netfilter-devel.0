From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3 nft] tests/py: add more interval tests for anonymous sets
Date: Wed, 27 Apr 2016 15:07:13 +0200
Message-ID: <1461762435-12411-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60976 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbcD0NH3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 09:07:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 77D5C4B9E4
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6A758A91F
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2AE0C6448C
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:23 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/any/ct.t           |  1 +
 tests/py/any/ct.t.payload   |  9 +++++++++
 tests/py/any/meta.t         |  3 +++
 tests/py/any/meta.t.payload | 27 +++++++++++++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 095e86c..4d13213 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -44,6 +44,7 @@ ct mark != 0x00000032;ok
 ct mark 0x00000032-0x00000045;ok
 ct mark != 0x00000032-0x00000045;ok
 ct mark {0x32, 0x2222, 0x42de3};ok;ct mark { 0x00042de3, 0x00002222, 0x00000032}
+ct mark {0x32-0x2222, 0x4444-0x42de3};ok;ct mark { 0x00000032-0x00002222, 0x00004444-0x00042de3}
 - ct mark != {0x32, 0x2222, 0x42de3};ok
 
 # ct mark != {0x32, 0x2222, 0x42de3};ok
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 62e9259..a7f664b 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -166,6 +166,15 @@ ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# ct mark {0x32-0x2222, 0x4444-0x42de3}
+set%d test-ip4 7
+set%d test-ip4 0
+        element 00000000  : 1 [end]     element 32000000  : 0 [end]     element 23220000  : 1 [end]     element 44440000  : 0 [end]     element e42d0400  : 1 [end]
+ip test-ip4 output
+  [ ct load mark => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set set%d ]
+
 # ct mark set 0x11 xor 0x1331
 ip test-ip4 output
   [ immediate reg 1 0x00001320 ]
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index c10297a..424cb18 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -14,6 +14,8 @@ meta length != 233;ok
 meta length 33-45;ok
 meta length != 33-45;ok
 meta length { 33, 55, 67, 88};ok
+meta length { 33-55, 67-88};ok
+meta length { 33-55, 55-88, 100-120};ok;meta length { 33-88, 100-120}
 - meta length != { 33, 55, 67, 88};ok
 meta length { 33-55};ok
 - meta length != { 33-55};ok
@@ -162,6 +164,7 @@ meta cpu != 1;ok;cpu != 1
 meta cpu 1-3;ok;cpu 1-3
 meta cpu != 1-2;ok;cpu != 1-2
 meta cpu { 2,3};ok;cpu { 2,3}
+meta cpu { 2-3, 5-7};ok
 -meta cpu != { 2,3};ok; cpu != { 2,3}
 
 meta iifgroup 0;ok;iifgroup default
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 9f7a6d9..14a8948 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -44,6 +44,24 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set set%d ]
 
+# meta length { 33-55, 67-88}
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]	element 43000000  : 0 [end]	element 59000000  : 1 [end]
+ip test-ip4 input
+  [ meta load len => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set set%d ]
+
+# meta length { 33-55, 55-88, 100-120}
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 59000000  : 1 [end]	element 64000000  : 0 [end]	element 79000000  : 1 [end]
+ip test-ip4 input
+  [ meta load len => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set set%d ]
+
 # meta protocol { ip, arp, ip6, vlan }
 set%d test-ip4 3
 set%d test-ip4 0
@@ -594,6 +612,15 @@ ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# meta cpu { 2-3, 5-7}
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 02000000  : 0 [end]	element 04000000  : 1 [end]	element 05000000  : 0 [end]	element 08000000  : 1 [end]
+ip test-ip4 input
+  [ meta load cpu => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set set%d ]
+
 # meta iifgroup 0
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
-- 
2.1.4

