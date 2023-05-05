Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C70C7EE24
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjEEPcF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjEEPcE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:04 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C73FE79
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 06/12] netfilter: nf_tables: add struct nft_reg_track and use it
Date:   Fri,  5 May 2023 17:31:24 +0200
Message-Id: <20230505153130.2385-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new structure to encapsulate register tracking information. Update
nft_reg_track_cmp() to take struct nft_reg_track as parameter. This
patch comes in preparation for the revamp of the register track and
reduce infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 22 ++++++++++++----------
 net/netfilter/nft_ct.c            |  2 +-
 net/netfilter/nft_exthdr.c        |  2 +-
 net/netfilter/nft_fib.c           |  2 +-
 net/netfilter/nft_hash.c          |  2 +-
 net/netfilter/nft_meta.c          |  2 +-
 net/netfilter/nft_osf.c           |  2 +-
 net/netfilter/nft_payload.c       |  2 +-
 net/netfilter/nft_socket.c        |  2 +-
 net/netfilter/nft_tunnel.c        |  2 +-
 net/netfilter/nft_xfrm.c          |  2 +-
 11 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b1f0aa6c02d6..2a0de5f18e0a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -124,12 +124,14 @@ struct nft_regs {
 	};
 };
 
+struct nft_reg_track {
+	const struct nft_expr		*selector;
+	const struct nft_expr		*bitwise;
+	u8				num_reg;
+};
+
 struct nft_regs_track {
-	struct {
-		const struct nft_expr		*selector;
-		const struct nft_expr		*bitwise;
-		u8				num_reg;
-	} regs[NFT_REG32_NUM];
+	struct nft_reg_track			regs[NFT_REG32_NUM];
 
 	const struct nft_expr			*cur;
 	const struct nft_expr			*last;
@@ -1834,12 +1836,12 @@ void nft_reg_track_update(struct nft_regs_track *track,
 void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);
 void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg);
 
-static inline bool nft_reg_track_cmp(struct nft_regs_track *track,
-				     const struct nft_expr *expr, u8 dreg)
+static inline bool nft_reg_track_cmp(const struct nft_reg_track *reg,
+				     const struct nft_expr *expr)
 {
-	return track->regs[dreg].selector &&
-	       track->regs[dreg].selector->ops == expr->ops &&
-	       track->regs[dreg].num_reg == 0;
+	return reg->selector &&
+	       reg->selector->ops == expr->ops &&
+	       reg->num_reg == 0;
 }
 
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 12f45c38905e..43490188956c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -705,7 +705,7 @@ static bool nft_ct_get_reduce(struct nft_regs_track *track,
 	const struct nft_ct *priv = nft_expr_priv(expr);
 	const struct nft_ct *ct;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 0eade4035e0a..dfd35bc19197 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -616,7 +616,7 @@ static bool nft_exthdr_reduce(struct nft_regs_track *track,
 	const struct nft_exthdr *priv = nft_expr_priv(expr);
 	const struct nft_exthdr *exthdr;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 17480514cdb0..2cc2b770db6d 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -196,7 +196,7 @@ bool nft_fib_reduce(struct nft_regs_track *track,
 		break;
 	}
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, len);
 		return false;
 	}
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index cca6a620214c..b4621f096008 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -209,7 +209,7 @@ static bool nft_symhash_reduce(struct nft_regs_track *track,
 	struct nft_symhash *priv = nft_expr_priv(expr);
 	struct nft_symhash *symhash;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
 		return false;
 	}
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 5ec80b7a0289..b16d8c92a302 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -779,7 +779,7 @@ bool nft_meta_get_reduce(struct nft_regs_track *track,
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct nft_meta *meta;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 0f50d36eec18..42da69866588 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -140,7 +140,7 @@ static bool nft_osf_reduce(struct nft_regs_track *track,
 	struct nft_osf *priv = nft_expr_priv(expr);
 	struct nft_osf *osf;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
 		return false;
 	}
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 20a6079667eb..356c82a2d0c8 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -258,7 +258,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct nft_payload *payload;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index cdea11597cf1..5b6c357cf8f2 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -222,7 +222,7 @@ static bool nft_socket_reduce(struct nft_regs_track *track,
 	const struct nft_socket *priv = nft_expr_priv(expr);
 	const struct nft_socket *socket;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 7b84585e3795..3ccfd2ae4c93 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -130,7 +130,7 @@ static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
 	const struct nft_tunnel *priv = nft_expr_priv(expr);
 	const struct nft_tunnel *tunnel;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 2bb6463c26dc..4a481ce9a4a8 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -263,7 +263,7 @@ static bool nft_xfrm_reduce(struct nft_regs_track *track,
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 	const struct nft_xfrm *xfrm;
 
-	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
-- 
2.30.2

