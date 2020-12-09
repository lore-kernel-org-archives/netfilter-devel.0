Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54993C4167B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DA08225AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgLIRu5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgLIRu4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:50:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A21C0617A7
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:49:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3b8-0004RH-7d; Wed, 09 Dec 2020 18:49:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 06/10] tests: fix exepcted payload of icmpv6 expressions
Date:   Wed,  9 Dec 2020 18:49:20 +0100
Message-Id: <20201209174924.27720-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft will now auto-insert a icmpv6 type match.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip6/icmpv6.t.payload.ip6 | 107 +++++++++++++++++++++++++++---
 1 file changed, 97 insertions(+), 10 deletions(-)

diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 51d71f4149b5..406bdd6dab93 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -327,6 +327,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
@@ -334,6 +336,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0xe9000000 ]
 
@@ -341,6 +345,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
   [ cmp lte reg 1 0x2d000000 ]
@@ -349,6 +355,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
 
@@ -359,6 +367,8 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -369,6 +379,8 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -379,6 +391,8 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -389,145 +403,206 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 id 33-45
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
 # icmpv6 id != 33-45
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmpv6 id {33, 55, 67, 88}
 __set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+__set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmpv6 id != {33, 55, 67, 88}
 __set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+__set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 id {33-55}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmpv6 id != {33-55}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 sequence 2
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000200 ]
 
 # icmpv6 sequence {3, 4, 5, 6, 7} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
-	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# icmpv6 sequence != {3, 4, 5, 6, 7} accept
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
+  [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
 # icmpv6 sequence {2, 4}
 __set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+__set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000200  : 0 [end]	element 00000400  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmpv6 sequence != {2, 4}
 __set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
+__set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000200  : 0 [end]	element 00000400  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 sequence 2-4
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00000200 ]
   [ cmp lte reg 1 0x00000400 ]
 
 # icmpv6 sequence != 2-4
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00000200 0x00000400 ]
 
 # icmpv6 sequence { 2-4}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmpv6 sequence != { 2-4}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000080  : 0 [end]	element 00000081  : 0 [end]
 __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -535,6 +610,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000082 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
@@ -543,6 +620,8 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000082 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
@@ -553,6 +632,8 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000082 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -563,6 +644,8 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000082 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -573,6 +656,8 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000082 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -583,6 +668,8 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000082 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-- 
2.26.2

