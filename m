Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B0EC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244576AbiDDMad (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344882AbiDDMac (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:32 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CD8F68
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xdhobuAkBcPjvN5yQ+RDMWI4Q4DUF3OjdW60K8j2AcE=; b=DD9I279YKPBT82ZyWLANA+Vq1/
        YQUGpOS12Kc8ICJmtB4I1qegwb8KaaeO/vuRB3L3VbE0p3pcfvDDNzvhI4IREb99YSUf3R+XkBXLf
        aGnL+l/kytIr1m453tYvZfgaUFw6pMBWigqoxA/irWZ5oxbM2Az0D0vu6hq3RBRN+XMjZt9Sidhf/
        o7ENcWEMEASlI5zJ5PyowZMKuEYJYQTGfWp73b9tDgy4qEhotNN5JKxwYbsI9u4XZqtGzmXPnc6g4
        shx4XLxd9knz3HjV5Ta3pzsdJaXf5dHcjFKmMndIO59PJchzbz1uC2+z2RBj6oUz59hTbqUtKD0V0
        TSTcScbw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-Dw; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 20/32] evaluate: prevent nested byte-order conversions
Date:   Mon,  4 Apr 2022 13:13:58 +0100
Message-Id: <20220404121410.188509-21-jeremy@azazel.net>
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

There is a an assertion in `expr_evaluate_unary` that checks that the
operand of the unary operation is not itself a unary expression.  Add a
check to `byteorder_conversion` to ensure that this is the case by
removing an existing unary operation, rather than adding a second one.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1b252076e124..3f697eb1dd43 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -144,6 +144,14 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	if ((*expr)->etype == EXPR_CONCAT)
 		return 0;
 
+	/* Remove existing conversion */
+	if ((*expr)->etype == EXPR_UNARY) {
+		struct expr *unary = *expr;
+		*expr = expr_get((*expr)->arg);
+		expr_free(unary);
+		return 0;
+	}
+
 	if (expr_basetype(*expr)->type != TYPE_INTEGER)
 		return expr_error(ctx->msgs, *expr,
 			 	  "Byteorder mismatch: expected %s, got %s",
-- 
2.35.1

