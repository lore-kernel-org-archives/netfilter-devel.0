Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9255CC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 00:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiCNAzm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Mar 2022 20:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235746AbiCNAzf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Mar 2022 20:55:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DFB533E93
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2022 17:54:27 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 002C46301A
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 01:52:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 08/12,v2] netfilter: nft_hash: track register operations
Date:   Mon, 14 Mar 2022 01:54:13 +0100
Message-Id: <20220314005417.315832-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220314005417.315832-1-pablo@netfilter.org>
References: <20220314005417.315832-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
osf expression performs. Always cancel register tracking for jhash since
this requires tracking multiple source registers in case of
concatenations. Perform register tracking (without bitwise) for symhash
since input does not come from source register.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use nft_reg_track_cmp()

 net/netfilter/nft_hash.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index f829f5289e16..e5631e88b285 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -165,6 +165,16 @@ static int nft_jhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static bool nft_jhash_reduce(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_jhash *priv = nft_expr_priv(expr);
+
+	nft_reg_track_cancel(track, priv->dreg, sizeof(u32));
+
+	return false;
+}
+
 static int nft_symhash_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr)
 {
@@ -185,6 +195,30 @@ static int nft_symhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static bool nft_symhash_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	struct nft_symhash *priv = nft_expr_priv(expr);
+	struct nft_symhash *symhash;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
+		return false;
+	}
+
+	symhash = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->offset != symhash->offset ||
+	    priv->modulus != symhash->modulus) {
+		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return false;
+}
+
 static struct nft_expr_type nft_hash_type;
 static const struct nft_expr_ops nft_jhash_ops = {
 	.type		= &nft_hash_type,
@@ -192,6 +226,7 @@ static const struct nft_expr_ops nft_jhash_ops = {
 	.eval		= nft_jhash_eval,
 	.init		= nft_jhash_init,
 	.dump		= nft_jhash_dump,
+	.reduce		= nft_jhash_reduce,
 };
 
 static const struct nft_expr_ops nft_symhash_ops = {
@@ -200,6 +235,7 @@ static const struct nft_expr_ops nft_symhash_ops = {
 	.eval		= nft_symhash_eval,
 	.init		= nft_symhash_init,
 	.dump		= nft_symhash_dump,
+	.reduce		= nft_symhash_reduce,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

