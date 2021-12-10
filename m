Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC40C4167D
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Dec 2021 00:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhLJAcl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 19:32:41 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44422 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbhLJAck (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 19:32:40 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4137E605C6
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Dec 2021 01:26:40 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 09/11] netfilter: nft_payload: track register operations
Date:   Fri, 10 Dec 2021 01:28:52 +0100
Message-Id: <20211210002854.144328-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211210002854.144328-1-pablo@netfilter.org>
References: <20211210002854.144328-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
payload store expression performs. This allows to skip this redundant
operation. If the destination contains a different selector, update
the register tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 39 +++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index f2e65df32a06..ad58822601bb 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -210,6 +210,43 @@ static int nft_payload_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_payload_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+	const struct nft_expr *last = track->last;
+	const struct nft_payload *payload;
+	const struct nft_expr *next;
+
+	if (!track->regs[priv->dreg].selector ||
+	    track->regs[priv->dreg].selector->ops != expr->ops) {
+		track->regs[priv->dreg].selector = expr;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	payload = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->base != payload->base ||
+	    priv->offset != payload->offset ||
+	    priv->len != payload->len) {
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
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 				     u32 priv_len, u32 field_len)
 {
@@ -513,6 +550,7 @@ static const struct nft_expr_ops nft_payload_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.reduce		= nft_payload_reduce,
 	.offload	= nft_payload_offload,
 };
 
@@ -522,6 +560,7 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.reduce		= nft_payload_reduce,
 	.offload	= nft_payload_offload,
 };
 
-- 
2.30.2

