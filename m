Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A8CC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbiDIOAv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiDIOAv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:00:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51637E0AA
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:58:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBbt-0008K4-Ny; Sat, 09 Apr 2022 15:58:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 1/9] evaluate: make byteorder conversion on string base type a no-op
Date:   Sat,  9 Apr 2022 15:58:24 +0200
Message-Id: <20220409135832.17401-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prerequisite for support of interface names in interval sets:
 table inet filter {
	set s {
		type ifname
		flags interval
		elements = { "foo" }
	}
	chain input {
		type filter hook input priority filter; policy accept;
		iifname @s counter
	}
 }

Will yield: "Byteorder mismatch: meta expected big endian, got host endian".
This is because of:

 /* Data for range lookups needs to be in big endian order */
 if (right->set->flags & NFT_SET_INTERVAL &&
   byteorder_conversion(ctx, &rel->left, BYTEORDER_BIG_ENDIAN) < 0)

It doesn't make sense to me to add checks to all callers of
byteorder_conversion(), so treat this similar to EXPR_CONCAT and turn
TYPE_STRING byteorder change into a no-op.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 6b3b63662411..d5ae071add1f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -138,6 +138,7 @@ static enum ops byteorder_conversion_op(struct expr *expr,
 static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 				enum byteorder byteorder)
 {
+	enum datatypes basetype;
 	enum ops op;
 
 	assert(!expr_is_constant(*expr) || expr_is_singleton(*expr));
@@ -149,11 +150,19 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	if ((*expr)->etype == EXPR_CONCAT)
 		return 0;
 
-	if (expr_basetype(*expr)->type != TYPE_INTEGER)
+	basetype = expr_basetype(*expr)->type;
+	switch (basetype) {
+	case TYPE_INTEGER:
+		break;
+	case TYPE_STRING:
+		return 0;
+	default:
 		return expr_error(ctx->msgs, *expr,
-			 	  "Byteorder mismatch: expected %s, got %s",
+				  "Byteorder mismatch: %s expected %s, %s got %s",
 				  byteorder_names[byteorder],
+				  expr_name(*expr),
 				  byteorder_names[(*expr)->byteorder]);
+	}
 
 	if (expr_is_constant(*expr) || (*expr)->len / BITS_PER_BYTE < 2)
 		(*expr)->byteorder = byteorder;
-- 
2.35.1

