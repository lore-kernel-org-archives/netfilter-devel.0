Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB061C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 15:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B757239EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 15:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbhAUPUR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730981AbhAUPDe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 10:03:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B69C06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 07:02:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2bU5-0004Oo-0v; Thu, 21 Jan 2021 16:02:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] exthdr: remove tcp dependency for tcp option matching
Date:   Thu, 21 Jan 2021 16:02:47 +0100
Message-Id: <20210121150247.19565-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel won't search for tcp options in non-tcp packets.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                |  4 +--
 tests/py/any/tcpopt.t.payload | 60 -----------------------------------
 2 files changed, 1 insertion(+), 63 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c830dcdbd965..ee5655064cb8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -580,9 +580,7 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT:
-		dependency = &proto_tcp;
-		pb = PROTO_BASE_TRANSPORT_HDR;
-		break;
+		return __expr_evaluate_exthdr(ctx, exprp);
 	case NFT_EXTHDR_OP_IPV4:
 		dependency = &proto_ip;
 		break;
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 56473798f8fd..1005df32ab33 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -1,210 +1,150 @@
 # tcp option eol kind 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option nop kind 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg kind 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg length 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg size 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
 
 # tcp option window kind 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window length 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window count 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack-perm kind 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack-perm length 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack kind 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack length 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack left 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack0 left 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack1 left 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack2 left 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack3 left 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack right 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack0 right 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack1 right 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack2 right 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack3 right 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option timestamp kind 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp length 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp tsval 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option timestamp tsecr 1
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option 255 missing
 inet
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 255 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # tcp option @255,8,8 255
 inet
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 255 + 1 => reg 1 ]
   [ cmp eq reg 1 0x000000ff ]
 
 # tcp option window exists
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window missing
 inet 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-- 
2.26.2

