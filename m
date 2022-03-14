Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58578C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbiCNRYg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243240AbiCNRYc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:24:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB54C2DD58
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:23:22 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 66D2860868
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 18:21:06 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 06/14] netfilter: nft_numgen: cancel register tracking
Date:   Mon, 14 Mar 2022 18:23:05 +0100
Message-Id: <20220314172313.63348-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220314172313.63348-1-pablo@netfilter.org>
References: <20220314172313.63348-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Random and increment are stateful, each invocation results in fresh output.
Cancel register tracking for these two expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nft_numgen.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 1d378efd8823..81b40c663d86 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -85,6 +85,16 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 	return err;
 }
 
+static bool nft_ng_inc_reduce(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	const struct nft_ng_inc *priv = nft_expr_priv(expr);
+
+	nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
+
+	return false;
+}
+
 static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
 		       u32 modulus, enum nft_ng_types type, u32 offset)
 {
@@ -172,6 +182,16 @@ static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
 			   priv->offset);
 }
 
+static bool nft_ng_random_reduce(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	const struct nft_ng_random *priv = nft_expr_priv(expr);
+
+	nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
+
+	return false;
+}
+
 static struct nft_expr_type nft_ng_type;
 static const struct nft_expr_ops nft_ng_inc_ops = {
 	.type		= &nft_ng_type,
@@ -180,6 +200,7 @@ static const struct nft_expr_ops nft_ng_inc_ops = {
 	.init		= nft_ng_inc_init,
 	.destroy	= nft_ng_inc_destroy,
 	.dump		= nft_ng_inc_dump,
+	.reduce		= nft_ng_inc_reduce,
 };
 
 static const struct nft_expr_ops nft_ng_random_ops = {
@@ -188,6 +209,7 @@ static const struct nft_expr_ops nft_ng_random_ops = {
 	.eval		= nft_ng_random_eval,
 	.init		= nft_ng_random_init,
 	.dump		= nft_ng_random_dump,
+	.reduce		= nft_ng_random_reduce,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

