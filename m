Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7BFC4167B
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Dec 2021 00:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhLJAcl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 19:32:41 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44412 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbhLJAcj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 19:32:39 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CBD61607C3
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Dec 2021 01:26:40 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 10/11] netfilter: nft_meta: track register operations
Date:   Fri, 10 Dec 2021 01:28:53 +0100
Message-Id: <20211210002854.144328-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211210002854.144328-1-pablo@netfilter.org>
References: <20211210002854.144328-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
meta store expression performs. This allows to skip this redundant
operation. If the destination contains a different selector, update
the register tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fe91ff5f8fbe..a078427d0c40 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -750,12 +750,49 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_meta_get_reduce(struct nft_regs_track *track,
+				const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+	const struct nft_expr *last = track->last;
+	const struct nft_meta *meta;
+	const struct nft_expr *next;
+
+	if (!track->regs[priv->dreg].selector ||
+	    track->regs[priv->dreg].selector->ops != expr->ops) {
+		track->regs[priv->dreg].selector = expr;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	meta = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != meta->key ||
+	    priv->dreg != meta->dreg) {
+		track->regs[priv->dreg].selector = expr;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	next = nft_expr_next(expr);
+	if (next == last || !next->ops->reduce)
+		return true;
+
+	if (next->ops->reduce(track, next))
+		return true;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_get_eval,
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
+	.reduce		= nft_meta_get_reduce,
 	.validate	= nft_meta_get_validate,
 	.offload	= nft_meta_get_offload,
 };
-- 
2.30.2

