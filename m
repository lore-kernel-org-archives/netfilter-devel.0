From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 11/12] tests/py: fix fragment-offset field
Date: Wed, 11 May 2016 23:05:15 +0200
Message-ID: <1463000716-11885-11-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40456 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbcEKVFa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 86CF71BD5AA
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 761F152D92
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C7E852D92
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:27 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set elements were miscalculated.

After this patch:

element 00000801  : 0 [end]
            ^^^^

Which looks correct according to my calculations:

>>> print hex(socket.htons(33 << 3))
0x801
^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip6/frag.t.payload.inet | 4 ++--
 tests/py/ip6/frag.t.payload.ip6  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 52eaaff..a766f15 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -123,7 +123,7 @@ inet test-inet output
 # frag frag-off { 33, 55, 67, 88}
 set%d test-inet 3
 set%d test-inet 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -134,7 +134,7 @@ inet test-inet output
 # frag frag-off { 33-55}
 set%d test-inet 7
 set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index a2adaae..d7a2e9f 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -93,7 +93,7 @@ ip6 test-ip6 output
 # frag frag-off { 33, 55, 67, 88}
 set%d test-ip6 3
 set%d test-ip6 0
-	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
 ip6 test-ip6 output
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
@@ -102,7 +102,7 @@ ip6 test-ip6 output
 # frag frag-off { 33-55}
 set%d test-ip6 7
 set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
 ip6 test-ip6 output 
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
-- 
2.1.4

