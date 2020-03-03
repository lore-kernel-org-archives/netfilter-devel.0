Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E04EC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF09214DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MJ/l22/1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgCCKOZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 05:14:25 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41910 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgCCKOZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 05:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d3DE9n7HukkhlGkga5/z10hP5uDrQRKAur534w1xi64=; b=MJ/l22/123k+yhhL8W+72Xhh1F
        LV9D159DHVFIvlyQqRFTJu38UvenQG4CJbWrv07Nqz0e56r0Rezx+3IEAKF8Kb/+LYXivbRROQLrG
        7TIpykozZf+eg5UWmx+92cCglm8EiB0pRhZVQ4JiMFdqHEiSbwgcPI3dLVr9PAK9/pcXa+EP4E46/
        p3syqzngbHoxUIKwnw3wKd8UqjkqDLocgg8XRjrG8S4LKozPb0SZUYG0BW/7tbZEfUoOCofhGpLbs
        YOu7Aigx12Okwoeug199ZEfzR+h8Z62hKvjF6bkWVDYjeibrrPAh6nlwEH5FaKx/+jUXG6oNjen/1
        yeND+Ssg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AR-00081M-80; Tue, 03 Mar 2020 09:48:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 15/18] netlink_delinearize: add postprocessing for payload binops.
Date:   Tue,  3 Mar 2020 09:48:41 +0000
Message-Id: <20200303094844.26694-16-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a user uses a variable payload expression in a payload statement, we
need to undo any munging during delinearization.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 571cab1d932b..73faa93c862e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2125,6 +2125,30 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 	}
 }
 
+static bool payload_binop_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	if (expr->op != OP_RSHIFT)
+		return false;
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
+	binop_postprocess(ctx, expr);
+	*exprp = expr_get(expr->left);
+	expr_free(expr);
+
+	return true;
+}
+
 static struct expr *string_wildcard_expr_alloc(struct location *loc,
 					       const struct expr *mask,
 					       const struct expr *expr)
@@ -2258,6 +2282,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
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
2.25.1

