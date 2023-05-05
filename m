Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF9AC77B7F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjEEPcJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjEEPcJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCBB6A27C
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 09/12] netfilter: nf_tables: cancel tracking when register differs from expression
Date:   Fri,  5 May 2023 17:31:27 +0200
Message-Id: <20230505153130.2385-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not update register tracking data resulting from evaluating runtime
expressions, such evaluation depends on the packet data. Instead, cancel
the register tracking information if the register content differs.
Upcoming patch adds the prefetch infrastructure which inconditionally
preloads on the registers the most used expressions to allow to recycle
register data.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 --
 net/netfilter/nf_tables_api.c     | 5 ++---
 net/netfilter/nft_ct.c            | 2 +-
 net/netfilter/nft_exthdr.c        | 2 +-
 net/netfilter/nft_fib.c           | 2 +-
 net/netfilter/nft_hash.c          | 2 +-
 net/netfilter/nft_meta.c          | 2 +-
 net/netfilter/nft_osf.c           | 2 +-
 net/netfilter/nft_payload.c       | 2 +-
 net/netfilter/nft_socket.c        | 2 +-
 net/netfilter/nft_tunnel.c        | 2 +-
 net/netfilter/nft_xfrm.c          | 2 +-
 12 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e9e1d108806e..f7132f136b47 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1830,8 +1830,6 @@ static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
 	return expr->ops->reduce == NFT_REDUCE_READONLY;
 }
 
-void nft_reg_track_update(struct nft_regs_track *track,
-			  const struct nft_expr *expr, u8 dreg, u8 len);
 void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);
 void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7879da8608bb..a0e3b73c72a3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -646,8 +646,8 @@ static void __nft_reg_track_update(struct nft_regs_track *track,
 	track->regs[dreg].num_reg = num_reg;
 }
 
-void nft_reg_track_update(struct nft_regs_track *track,
-			  const struct nft_expr *expr, u8 dreg, u8 len)
+static void nft_reg_track_update(struct nft_regs_track *track,
+				 const struct nft_expr *expr, u8 dreg, u8 len)
 {
 	unsigned int regcount;
 	int i;
@@ -658,7 +658,6 @@ void nft_reg_track_update(struct nft_regs_track *track,
 	for (i = 0; i < regcount; i++, dreg++)
 		__nft_reg_track_update(track, expr, dreg, i);
 }
-EXPORT_SYMBOL_GPL(nft_reg_track_update);
 
 void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len)
 {
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 4bbb0ae8404e..746416d894e0 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -721,7 +721,7 @@ static bool nft_ct_get_reduce(struct nft_regs_track *track,
 	const struct nft_ct *priv = nft_expr_priv(expr);
 
 	if (!nft_ct_expr_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index e73f76407fc0..43d53e4342c5 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -636,7 +636,7 @@ static bool nft_exthdr_reduce(struct nft_regs_track *track,
 	const struct nft_exthdr *priv = nft_expr_priv(expr);
 
 	if (!nft_exthdr_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 13f54b56673d..8a1aad66ce91 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -213,7 +213,7 @@ bool nft_fib_reduce(struct nft_regs_track *track,
 	}
 
 	if (!nft_fib_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, len);
+		nft_reg_track_cancel(track, priv->dreg, len);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 928d2a6ce17c..8d93d9d4ecd9 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -226,7 +226,7 @@ static bool nft_symhash_reduce(struct nft_regs_track *track,
 	struct nft_symhash *priv = nft_expr_priv(expr);
 
 	if (!nft_symhash_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
+		nft_reg_track_cancel(track, priv->dreg, sizeof(u32));
 		return false;
 	}
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 40e2707d24a1..db13a4771261 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -796,7 +796,7 @@ bool nft_meta_get_reduce(struct nft_regs_track *track,
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
 	if (!nft_meta_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index efbe2c625f29..ce01e3970579 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -157,7 +157,7 @@ static bool nft_osf_reduce(struct nft_regs_track *track,
 	struct nft_osf *priv = nft_expr_priv(expr);
 
 	if (!nft_osf_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
+		nft_reg_track_cancel(track, priv->dreg, NFT_OSF_MAXGENRELEN);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index fe515f5b4373..056a8adf8726 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -276,7 +276,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 	const struct nft_payload *priv = nft_expr_priv(expr);
 
 	if (!nft_payload_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index a733404a51f7..8bc1df325ab9 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -241,7 +241,7 @@ static bool nft_socket_reduce(struct nft_regs_track *track,
 	const struct nft_socket *priv = nft_expr_priv(expr);
 
 	if (!nft_socket_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 648a2d2e26e6..2a831a40d7c2 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -148,7 +148,7 @@ static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
 	const struct nft_tunnel *priv = nft_expr_priv(expr);
 
 	if (!nft_tunnel_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index cc6839782334..7f65f5b3bbbf 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -282,7 +282,7 @@ static bool nft_xfrm_reduce(struct nft_regs_track *track,
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 
 	if (!nft_xfrm_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
-- 
2.30.2

