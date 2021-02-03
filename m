Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C8AC433E6
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 16:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DEE364F7C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 16:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhBCQ64 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 11:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhBCQ6G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 11:58:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B038C061786
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 08:57:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l7LT2-0005La-In; Wed, 03 Feb 2021 17:57:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] evaluate: pick data element byte order, not dtype one
Date:   Wed,  3 Feb 2021 17:57:06 +0100
Message-Id: <20210203165707.21781-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210203165707.21781-1-fw@strlen.de>
References: <20210203165707.21781-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some expressions have integer base type, not a specific one, e.g. 'ct zone'.
In that case nft used the wrong byte order.

Without this, nft adds
elements = { "eth0" : 256, "eth1" : 512, "veth4" : 256 }
instead of 1, 2, 3.

This is not a 'display bug', the added elements have wrong byte order.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1d5db4dacd82..123fc7ab1a28 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1596,7 +1596,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 		else
 			datalen = set->data->len;
 
-		expr_set_context(&ctx->ectx, set->data->dtype, datalen);
+		__expr_set_context(&ctx->ectx, set->data->dtype, set->data->byteorder, datalen, 0);
 	} else {
 		assert((set->flags & NFT_SET_MAP) == 0);
 	}
-- 
2.26.2

