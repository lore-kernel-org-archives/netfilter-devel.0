Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D5AC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243277AbiCNRYk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243331AbiCNRYf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:24:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F6EC33E0C
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:23:25 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2FA0E625F9
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 18:21:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 12/14] netfilter: nft_tunnel: track register operations
Date:   Mon, 14 Mar 2022 18:23:11 +0100
Message-Id: <20220314172313.63348-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220314172313.63348-1-pablo@netfilter.org>
References: <20220314172313.63348-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
tunnel expression performs. This allows to skip this redundant operation.
If the destination contains a different selector, update the register
tracking information. This patch does not perform bitwise tracking.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nft_tunnel.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3b27926d5382..d0f9b1d51b0e 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -17,6 +17,7 @@ struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
 	u8			dreg;
 	enum nft_tunnel_mode	mode:8;
+	u8			len;
 };
 
 static void nft_tunnel_get_eval(const struct nft_expr *expr,
@@ -101,6 +102,7 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 		priv->mode = NFT_TUNNEL_MODE_NONE;
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_TUNNEL_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -122,6 +124,31 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
+				  const struct nft_expr *expr)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+	const struct nft_tunnel *tunnel;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	tunnel = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != tunnel->key ||
+	    priv->dreg != tunnel->dreg ||
+	    priv->mode != tunnel->mode) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return false;
+}
+
 static struct nft_expr_type nft_tunnel_type;
 static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.type		= &nft_tunnel_type,
@@ -129,6 +156,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.eval		= nft_tunnel_get_eval,
 	.init		= nft_tunnel_get_init,
 	.dump		= nft_tunnel_get_dump,
+	.reduce		= nft_tunnel_get_reduce,
 };
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
-- 
2.30.2

