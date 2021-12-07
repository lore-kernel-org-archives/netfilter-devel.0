Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E301FC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Dec 2021 15:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhLGPUt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 10:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhLGPUt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 10:20:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7539C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Dec 2021 07:17:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mucDV-0001l8-8g; Tue, 07 Dec 2021 16:17:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] netlink_delinearize: and/shift postprocessing
Date:   Tue,  7 Dec 2021 16:16:58 +0100
Message-Id: <20211207151659.5507-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207151659.5507-1-fw@strlen.de>
References: <20211207151659.5507-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before this patch:
in:  frag frag-off @s4
in:  ip version @s8

out: (@nh,0,8 & 0xf0) >> 4 == @s8
out: (frag unknown & 0xfff8 [invalid type]) >> 3 == @s4

after:
out: frag frag-off >> 0 == @s4
out: ip version >> 0 == @s8

Next patch adds support for zero-shift removal.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1f820e68e9f1..e37a34f37ba2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2414,6 +2414,13 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 		 * templates.
 		 */
 		binop_postprocess(ctx, expr, &expr->left);
+	} else if (binop->op == OP_RSHIFT && binop->left->op == OP_AND &&
+		   binop->right->etype == EXPR_VALUE && binop->left->right->etype == EXPR_VALUE) {
+		/* Handle 'ip version @s4' and similar, i.e. set lookups where the lhs needs
+		 * fixups to mask out unwanted bits AND a shift.
+		 */
+
+		binop_postprocess(ctx, binop, &binop->left);
 	}
 }
 
-- 
2.32.0

