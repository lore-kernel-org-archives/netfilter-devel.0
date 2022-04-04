Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43149C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344222AbiDDMbQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbiDDMbP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:15 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE28725284
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Tg+7WgOj/uwJRt8ZHOSQ+L3AZ15AkKLVsv5kl94W8xo=; b=jYpGlMhPssR1y7SRSWpim1YtMS
        hoDL9iGGq+CYEgbOk84XxJ1zIVlq2/SEDQTcTM/RQ9uP74uLtyvWJTJ8j5PL51ItkTnt1bMxeCHaS
        dCNIBL4L3tv5dhMFW9Izm5WNZrQ1lCTI4tMzKyPrfSYbWPGZwzygVd/x+nKDjB/zjLjQlTr68meXF
        ufb+XibzV1MjY31UbB/wT70nqHtWlDNG5X51f/wyxIzk6DJxkMye3TWsDJnMCMs+S6quIHVtMAe5e
        uvnnIy59drBU/aVsoV2jVRm0iqUeKMoXMp2n07NhExQCQonAOYdKMe6SfTuiLOlmKV/+/DYh/rSP3
        7SbL+rUw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-Ap; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 10/32] netlink_delinearize: correct type and byte-order of shifts
Date:   Mon,  4 Apr 2022 13:13:48 +0100
Message-Id: <20220404121410.188509-11-jeremy@azazel.net>
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

Shifts are of integer type and in HBO.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 12624db4c3a5..8b010fe4d168 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2618,8 +2618,17 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		}
 		expr_postprocess(ctx, &expr->right);
 
-		expr_set_type(expr, expr->left->dtype,
-			      expr->left->byteorder);
+		switch (expr->op) {
+		case OP_LSHIFT:
+		case OP_RSHIFT:
+			expr_set_type(expr, &integer_type,
+				      BYTEORDER_HOST_ENDIAN);
+			break;
+		default:
+			expr_set_type(expr, expr->left->dtype,
+				      expr->left->byteorder);
+		}
+
 		break;
 	case EXPR_RELATIONAL:
 		switch (expr->left->etype) {
-- 
2.35.1

