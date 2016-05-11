From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 10/12] tests/py: add missing netdev ip dscp payload tests
Date: Wed, 11 May 2016 23:05:14 +0200
Message-ID: <1463000716-11885-10-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40465 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbcEKVFa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 01D3F1BD5B9
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E6AADFF6F5
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E67722687C4
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:26 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/ip.t.payload.netdev | 43 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 90d6cc8..fcc466a 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -598,3 +598,46 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp neq reg 1 0x00000006 ]
 
+# ip dscp cs1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000020 ]
+
+# ip dscp != cs1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000020 ]
+
+# ip dscp 0x38
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x000000e0 ]
+
+# ip dscp != 0x20
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000080 ]
+
+# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00000000  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000060  : 0 [end]	element 00000080  : 0 [end]	element 000000a0  : 0 [end]	element 000000c0  : 0 [end]	element 000000e0  : 0 [end]	element 00000028  : 0 [end]	element 00000030  : 0 [end]	element 00000038  : 0 [end]	element 00000048  : 0 [end]	element 00000050  : 0 [end]	element 00000058  : 0 [end]	element 00000068  : 0 [end]	element 00000070  : 0 [end]	element 00000078  : 0 [end]	element 00000088  : 0 [end]	element 00000090  : 0 [end]	element 00000098  : 0 [end]	element 000000b8  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
-- 
2.1.4

