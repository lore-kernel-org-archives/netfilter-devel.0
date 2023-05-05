Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A92AC7EE22
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjEEPcK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjEEPcJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E8F21492A
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 08/12] netfilter: nf_tables: remove bitwise register tracking
Date:   Fri,  5 May 2023 17:31:26 +0200
Message-Id: <20230505153130.2385-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While it is possible to track and reduce bitwise operation, remove it
by now to simplify the initial track and reduce register infrastructure.

Cancel register tracking information on the destination register for
the bitwise expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c     |  2 -
 net/netfilter/nft_bitwise.c       | 85 +------------------------------
 net/netfilter/nft_ct.c            |  5 +-
 net/netfilter/nft_exthdr.c        |  5 +-
 net/netfilter/nft_fib.c           |  5 +-
 net/netfilter/nft_hash.c          |  5 +-
 net/netfilter/nft_meta.c          |  5 +-
 net/netfilter/nft_osf.c           |  5 +-
 net/netfilter/nft_payload.c       |  5 +-
 net/netfilter/nft_socket.c        |  5 +-
 net/netfilter/nft_tunnel.c        |  5 +-
 net/netfilter/nft_xfrm.c          |  5 +-
 13 files changed, 12 insertions(+), 126 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2a0de5f18e0a..e9e1d108806e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -126,7 +126,6 @@ struct nft_regs {
 
 struct nft_reg_track {
 	const struct nft_expr		*selector;
-	const struct nft_expr		*bitwise;
 	u8				num_reg;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bbdf22646745..7879da8608bb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -643,7 +643,6 @@ static void __nft_reg_track_update(struct nft_regs_track *track,
 				   u8 dreg, u8 num_reg)
 {
 	track->regs[dreg].selector = expr;
-	track->regs[dreg].bitwise = NULL;
 	track->regs[dreg].num_reg = num_reg;
 }
 
@@ -677,7 +676,6 @@ EXPORT_SYMBOL_GPL(nft_reg_track_cancel);
 void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg)
 {
 	track->regs[dreg].selector = NULL;
-	track->regs[dreg].bitwise = NULL;
 	track->regs[dreg].num_reg = 0;
 }
 EXPORT_SYMBOL_GPL(__nft_reg_track_cancel);
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 66a73df4b484..583e11f0f4c9 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -294,45 +294,8 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 			       const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
-	const struct nft_bitwise *bitwise;
-	unsigned int regcount;
-	u8 dreg;
-	int i;
-
-	if (!track->regs[priv->sreg].selector)
-		return false;
-
-	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
-	    track->regs[priv->sreg].num_reg == 0 &&
-	    track->regs[priv->dreg].bitwise &&
-	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
-	    priv->sreg == bitwise->sreg &&
-	    priv->dreg == bitwise->dreg &&
-	    priv->op == bitwise->op &&
-	    priv->len == bitwise->len &&
-	    !memcmp(&priv->mask, &bitwise->mask, sizeof(priv->mask)) &&
-	    !memcmp(&priv->xor, &bitwise->xor, sizeof(priv->xor)) &&
-	    !memcmp(&priv->data, &bitwise->data, sizeof(priv->data))) {
-		track->cur = expr;
-		return true;
-	}
-
-	if (track->regs[priv->sreg].bitwise ||
-	    track->regs[priv->sreg].num_reg != 0) {
-		nft_reg_track_cancel(track, priv->dreg, priv->len);
-		return false;
-	}
-
-	if (priv->sreg != priv->dreg) {
-		nft_reg_track_update(track, track->regs[priv->sreg].selector,
-				     priv->dreg, priv->len);
-	}
 
-	dreg = priv->dreg;
-	regcount = DIV_ROUND_UP(priv->len, NFT_REG32_SIZE);
-	for (i = 0; i < regcount; i++, dreg++)
-		track->regs[priv->dreg].bitwise = expr;
+	nft_reg_track_cancel(track, priv->dreg, priv->len);
 
 	return false;
 }
@@ -449,33 +412,8 @@ static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
 				    const struct nft_expr *expr)
 {
 	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
-	const struct nft_bitwise_fast_expr *bitwise;
-
-	if (!track->regs[priv->sreg].selector)
-		return false;
-
-	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
-	    track->regs[priv->dreg].bitwise &&
-	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
-	    priv->sreg == bitwise->sreg &&
-	    priv->dreg == bitwise->dreg &&
-	    priv->mask == bitwise->mask &&
-	    priv->xor == bitwise->xor) {
-		track->cur = expr;
-		return true;
-	}
-
-	if (track->regs[priv->sreg].bitwise) {
-		nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
-		return false;
-	}
 
-	if (priv->sreg != priv->dreg) {
-		track->regs[priv->dreg].selector =
-			track->regs[priv->sreg].selector;
-	}
-	track->regs[priv->dreg].bitwise = expr;
+	nft_reg_track_cancel(track, priv->dreg, sizeof(u32));
 
 	return false;
 }
@@ -523,22 +461,3 @@ struct nft_expr_type nft_bitwise_type __read_mostly = {
 	.maxattr	= NFTA_BITWISE_MAX,
 	.owner		= THIS_MODULE,
 };
-
-bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
-			     const struct nft_expr *expr)
-{
-	const struct nft_expr *last = track->last;
-	const struct nft_expr *next;
-
-	if (expr == last)
-		return false;
-
-	next = nft_expr_next(expr);
-	if (next->ops == &nft_bitwise_ops)
-		return nft_bitwise_reduce(track, next);
-	else if (next->ops == &nft_bitwise_fast_ops)
-		return nft_bitwise_fast_reduce(track, next);
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(nft_expr_reduce_bitwise);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 49ad6f2f4311..4bbb0ae8404e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -725,10 +725,7 @@ static bool nft_ct_get_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
+	return true;
 }
 
 static int nft_ct_set_dump(struct sk_buff *skb,
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 26e7098cb4e6..e73f76407fc0 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -640,10 +640,7 @@ static bool nft_exthdr_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
+	return true;
 }
 
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 1bba85eecde3..13f54b56673d 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -217,10 +217,7 @@ bool nft_fib_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
+	return true;
 }
 EXPORT_SYMBOL_GPL(nft_fib_reduce);
 
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 4dfd06e59b08..928d2a6ce17c 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -230,10 +230,7 @@ static bool nft_symhash_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
+	return true;
 }
 
 static struct nft_expr_type nft_hash_type;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 0b56d8a3805b..40e2707d24a1 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -800,10 +800,7 @@ bool nft_meta_get_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
+	return true;
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_reduce);
 
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 77d3dbf5bfb0..efbe2c625f29 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -161,10 +161,7 @@ static bool nft_osf_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
+	return true;
 }
 
 static struct nft_expr_type nft_osf_type;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 16a5a2c1e86b..fe515f5b4373 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -280,10 +280,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
+	return true;
 }
 
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index b8519e509746..a733404a51f7 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -245,10 +245,7 @@ static bool nft_socket_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
+	return true;
 }
 
 static int nft_socket_validate(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 220318940dd8..648a2d2e26e6 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -152,10 +152,7 @@ static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return false;
+	return true;
 }
 
 static struct nft_expr_type nft_tunnel_type;
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 8dcb69e39b04..cc6839782334 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -286,10 +286,7 @@ static bool nft_xfrm_reduce(struct nft_regs_track *track,
 		return false;
 	}
 
-	if (!track->regs[priv->dreg].bitwise)
-		return true;
-
-	return nft_expr_reduce_bitwise(track, expr);
+	return true;
 }
 
 static struct nft_expr_type nft_xfrm_type;
-- 
2.30.2

