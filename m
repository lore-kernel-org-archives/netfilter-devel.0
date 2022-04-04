Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A80C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbiDDMQe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242228AbiDDMQa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B141D13E1A
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=D/gQayupct7m/WsP+v7KGZGrFUC6u+ydwTf1BxJLdbc=; b=sUdmGSWnLEy3qOumrfhCYF4i5g
        UrS+QYUWd/v6QxsBq6etI/aMF77fk8JGU04ijgvOxI/7Y4r4PSz9ZmfhRBUBlSLQDPXGKrDAr/CYO
        FLbzoEZl/t//itqD07canflJnHlYPYNhlbPiYLYjRvU+E2uso4vBLP/iTVv1GzOFpc+DmSBNjUki/
        RDM3Alw/DTgNk4iMHyA5Vhye9zrUvGZ4OAVKtkVXMNMj0ugXfyuznIrBC5Xnua/AIwg41NE5m1AEJ
        p1T9EbD++CndZHNTzKVnR0IgXFExr/Tnh5IJtCkNYR+F1xVigNR71iHS/mdoVGK2Mrxja8p1qIoyh
        zlMezj4g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-7K; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 09/32] netlink_delinearize: add postprocessing for payload binops
Date:   Mon,  4 Apr 2022 13:13:47 +0100
Message-Id: <20220404121410.188509-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a user uses a payload expression as a statement argument:

  nft add rule t c meta mark set ip dscp lshift 2 or 0x10

we may need to undo munging during delinearization.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 733977bc526d..12624db4c3a5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2454,6 +2454,42 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
+static bool payload_binop_postprocess(struct rule_pp_ctx *ctx,
+				      struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	if (expr->op != OP_RSHIFT)
+		return false;
+
+	if (expr->left->etype == EXPR_UNARY) {
+		/*
+		 * If the payload value was originally in a different byte-order
+		 * from the payload expression, there will be a byte-order
+		 * conversion to remove.
+		 */
+		struct expr *left = expr_get(expr->left->arg);
+		expr_free(expr->left);
+		expr->left = left;
+	}
+
+	if (expr->left->etype != EXPR_BINOP || expr->left->op != OP_AND)
+		return false;
+
+	if (expr->left->left->etype != EXPR_PAYLOAD)
+		return false;
+
+	expr_set_type(expr->right, &integer_type,
+		      BYTEORDER_HOST_ENDIAN);
+	expr_postprocess(ctx, &expr->right);
+
+	binop_postprocess(ctx, expr, &expr->left);
+	*exprp = expr_get(expr->left);
+	expr_free(expr);
+
+	return true;
+}
+
 static struct expr *string_wildcard_expr_alloc(struct location *loc,
 					       const struct expr *mask,
 					       const struct expr *expr)
@@ -2566,6 +2602,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_set_type(expr, expr->arg->dtype, !expr->arg->byteorder);
 		break;
 	case EXPR_BINOP:
+		if (payload_binop_postprocess(ctx, exprp))
+			break;
+
 		expr_postprocess(ctx, &expr->left);
 		switch (expr->op) {
 		case OP_LSHIFT:
-- 
2.35.1

