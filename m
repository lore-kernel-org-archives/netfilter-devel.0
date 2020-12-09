Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E962C2BB48
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F860225AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgLIRu3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgLIRu1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:50:27 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEB1C06179C
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:49:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3az-0004R3-QC; Wed, 09 Dec 2020 18:49:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 04/10] tests: fix exepcted payload of icmp expressions
Date:   Wed,  9 Dec 2020 18:49:18 +0100
Message-Id: <20201209174924.27720-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

after previous change nft will insert explicit icmp type match.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/icmp.t.payload.ip | 131 +++++++++++++++++++++++++++++++++-
 1 file changed, 130 insertions(+), 1 deletion(-)

diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 2185feb81021..6ed4dff86d10 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -272,148 +272,233 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # icmp id 1245 log
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x0000dd04 ]
   [ log ]
 
 # icmp id 22
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # icmp id != 233
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # icmp id 33-45
+__set%d test-ip4 3
+__set%d  test-ip4 input
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
 # icmp id != 33-45
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmp id { 33-55}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmp id != { 33-55}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp id { 22, 34, 333}
 __set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+__set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmp id != { 22, 34, 333}
 __set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+__set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp sequence 22
-ip test-ip4 input
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+ip 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # icmp sequence != 233
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # icmp sequence 33-45
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
 # icmp sequence != 33-45
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmp sequence { 33, 55, 67, 88}
 __set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+__set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmp sequence != { 33, 55, 67, 88}
 __set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
+__set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmp sequence { 33-55}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # icmp sequence != { 33-55}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
 __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -421,6 +506,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00002100 ]
 
@@ -428,6 +515,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00001600 ]
   [ cmp lte reg 1 0x00002100 ]
@@ -439,6 +528,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -449,6 +540,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -456,6 +549,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
@@ -463,6 +558,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
@@ -470,6 +567,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
@@ -478,6 +577,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
@@ -488,6 +589,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -498,6 +601,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -508,6 +613,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -518,6 +625,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -525,6 +634,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
@@ -532,6 +643,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0xe9000000 ]
 
@@ -539,6 +652,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
   [ cmp lte reg 1 0x2d000000 ]
@@ -547,6 +662,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
 
@@ -557,6 +674,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -567,6 +686,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -577,6 +698,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
@@ -587,6 +710,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -594,6 +719,8 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0x22000000 ]
 
@@ -604,6 +731,8 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-- 
2.26.2

