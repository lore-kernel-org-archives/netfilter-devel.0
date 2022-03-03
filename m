Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED567C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 14:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiCCOld (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 09:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiCCOld (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 09:41:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95BA51786A7
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 06:40:47 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id ED4BB6019D
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 15:39:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2] netfilter: nft_ct: track register operations
Date:   Thu,  3 Mar 2022 15:40:43 +0100
Message-Id: <20220303144043.702865-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
ct store expression performs. This allows to skip this redundant
operation. If the destination contains a different selector, update
the register tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: missing EXPORT_SYMBOL for nft_expr_reduce_bitwise break nft_ct.c as module

 net/netfilter/nft_bitwise.c |  1 +
 net/netfilter/nft_ct.c      | 47 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 7b727d3ebf9d..8bc22b2012cb 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -522,3 +522,4 @@ bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
 
 	return false;
 }
+EXPORT_SYMBOL_GPL(nft_expr_reduce_bitwise);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5adf8bb628a8..66ee49045d8e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -677,6 +677,32 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_ct_get_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+	const struct nft_ct *ct;
+
+	if (!track->regs[priv->dreg].selector ||
+	    track->regs[priv->dreg].selector->ops != expr->ops) {
+		track->regs[priv->dreg].selector = expr;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	ct = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != ct->key) {
+		track->regs[priv->dreg].selector = expr;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return nft_expr_reduce_bitwise(track, expr);
+}
+
 static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
@@ -710,8 +736,28 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.reduce		= nft_ct_get_reduce,
 };
 
+static bool nft_ct_set_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	int i;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		if (track->regs[i].selector->ops != &nft_ct_get_ops)
+			continue;
+
+		track->regs[i].selector = NULL;
+		track->regs[i].bitwise = NULL;
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_ct_set_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
@@ -719,6 +765,7 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.reduce		= nft_ct_set_reduce,
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-- 
2.30.2

