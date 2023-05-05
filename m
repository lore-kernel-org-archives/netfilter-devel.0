Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDA7C7EE24
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjEEPcL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjEEPcJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A7171491F
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 07/12] netfilter: nf_tables: split expression comparison and reduction
Date:   Fri,  5 May 2023 17:31:25 +0200
Message-Id: <20230505153130.2385-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extract the code to compare the register content with expressions, this
is required by the new track and reduce infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c      | 25 +++++++++++++++++--------
 net/netfilter/nft_exthdr.c  | 23 ++++++++++++++++-------
 net/netfilter/nft_fib.c     | 27 ++++++++++++++++++---------
 net/netfilter/nft_hash.c    | 23 ++++++++++++++++-------
 net/netfilter/nft_meta.c    | 21 +++++++++++++++------
 net/netfilter/nft_osf.c     | 23 ++++++++++++++++-------
 net/netfilter/nft_payload.c | 23 ++++++++++++++++-------
 net/netfilter/nft_socket.c  | 22 ++++++++++++++++------
 net/netfilter/nft_tunnel.c  | 23 ++++++++++++++++-------
 net/netfilter/nft_xfrm.c    | 23 ++++++++++++++++-------
 10 files changed, 162 insertions(+), 71 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 43490188956c..49ad6f2f4311 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -699,19 +699,28 @@ static int nft_ct_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_ct_get_reduce(struct nft_regs_track *track,
-			      const struct nft_expr *expr)
+static bool nft_ct_expr_cmp(const struct nft_reg_track *reg,
+			    const struct nft_expr *expr)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
-	const struct nft_ct *ct;
+	struct nft_ct *ct;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	ct = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->key != ct->key) {
+	ct = nft_expr_priv(reg->selector);
+	if (priv->key != ct->key)
+		return false;
+
+	return true;
+}
+
+static bool nft_ct_get_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+
+	if (!nft_ct_expr_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index dfd35bc19197..26e7098cb4e6 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -610,23 +610,32 @@ static int nft_exthdr_dump_strip(struct sk_buff *skb,
 	return nft_exthdr_dump_common(skb, priv);
 }
 
-static bool nft_exthdr_reduce(struct nft_regs_track *track,
-			       const struct nft_expr *expr)
+static bool nft_exthdr_cmp(const struct nft_reg_track *reg,
+			   const struct nft_expr *expr)
 {
 	const struct nft_exthdr *priv = nft_expr_priv(expr);
 	const struct nft_exthdr *exthdr;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	exthdr = nft_expr_priv(track->regs[priv->dreg].selector);
+	exthdr = nft_expr_priv(reg->selector);
 	if (priv->type != exthdr->type ||
 	    priv->op != exthdr->op ||
 	    priv->flags != exthdr->flags ||
 	    priv->offset != exthdr->offset ||
-	    priv->len != exthdr->len) {
+	    priv->len != exthdr->len)
+		return false;
+
+	return true;
+}
+
+static bool nft_exthdr_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_exthdr *priv = nft_expr_priv(expr);
+
+	if (!nft_exthdr_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 2cc2b770db6d..1bba85eecde3 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -173,12 +173,28 @@ void nft_fib_store_result(struct nft_regs *regs, const struct nft_fib *priv,
 }
 EXPORT_SYMBOL_GPL(nft_fib_store_result);
 
+static bool nft_fib_cmp(const struct nft_reg_track *reg,
+			const struct nft_expr *expr)
+{
+	const struct nft_fib *priv = nft_expr_priv(expr);
+	const struct nft_fib *fib;
+
+	if (!nft_reg_track_cmp(reg, expr))
+		return false;
+
+	fib = nft_expr_priv(reg->selector);
+	if (priv->result != fib->result ||
+	    priv->flags != fib->flags)
+		return false;
+
+	return true;
+}
+
 bool nft_fib_reduce(struct nft_regs_track *track,
 		    const struct nft_expr *expr)
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	unsigned int len = NFT_REG32_SIZE;
-	const struct nft_fib *fib;
 
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
@@ -196,14 +212,7 @@ bool nft_fib_reduce(struct nft_regs_track *track,
 		break;
 	}
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, len);
-		return false;
-	}
-
-	fib = nft_expr_priv(track->regs[priv->dreg].selector);
-	if (priv->result != fib->result ||
-	    priv->flags != fib->flags) {
+	if (!nft_fib_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, len);
 		return false;
 	}
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index b4621f096008..4dfd06e59b08 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -203,20 +203,29 @@ static int nft_symhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_symhash_reduce(struct nft_regs_track *track,
-			       const struct nft_expr *expr)
+static bool nft_symhash_cmp(const struct nft_reg_track *reg,
+			    const struct nft_expr *expr)
 {
 	struct nft_symhash *priv = nft_expr_priv(expr);
 	struct nft_symhash *symhash;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
+	if (!nft_reg_track_cmp(reg,expr))
 		return false;
-	}
 
-	symhash = nft_expr_priv(track->regs[priv->dreg].selector);
+	symhash = nft_expr_priv(reg->selector);
 	if (priv->offset != symhash->offset ||
-	    priv->modulus != symhash->modulus) {
+	    priv->modulus != symhash->modulus)
+		return false;
+
+	return true;
+}
+
+static bool nft_symhash_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	struct nft_symhash *priv = nft_expr_priv(expr);
+
+	if (!nft_symhash_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, sizeof(u32));
 		return false;
 	}
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index b16d8c92a302..0b56d8a3805b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -773,20 +773,29 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
-bool nft_meta_get_reduce(struct nft_regs_track *track,
+static bool nft_meta_cmp(const struct nft_reg_track *reg,
 			 const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct nft_meta *meta;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	meta = nft_expr_priv(track->regs[priv->dreg].selector);
+	meta = nft_expr_priv(reg->selector);
 	if (priv->key != meta->key ||
-	    priv->dreg != meta->dreg) {
+	    priv->dreg != meta->dreg)
+		return false;
+
+	return true;
+}
+
+bool nft_meta_get_reduce(struct nft_regs_track *track,
+			 const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	if (!nft_meta_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 42da69866588..77d3dbf5bfb0 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -134,20 +134,29 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
-static bool nft_osf_reduce(struct nft_regs_track *track,
-			   const struct nft_expr *expr)
+static bool nft_osf_cmp(const struct nft_reg_track *reg,
+			const struct nft_expr *expr)
 {
 	struct nft_osf *priv = nft_expr_priv(expr);
 	struct nft_osf *osf;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	osf = nft_expr_priv(track->regs[priv->dreg].selector);
+	osf = nft_expr_priv(reg->selector);
 	if (priv->flags != osf->flags ||
-	    priv->ttl != osf->ttl) {
+	    priv->ttl != osf->ttl)
+		return false;
+
+	return true;
+}
+
+static bool nft_osf_reduce(struct nft_regs_track *track,
+			   const struct nft_expr *expr)
+{
+	struct nft_osf *priv = nft_expr_priv(expr);
+
+	if (!nft_osf_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
 		return false;
 	}
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 356c82a2d0c8..16a5a2c1e86b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -252,21 +252,30 @@ static int nft_payload_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_payload_reduce(struct nft_regs_track *track,
-			       const struct nft_expr *expr)
+static bool nft_payload_cmp(const struct nft_reg_track *reg,
+			    const struct nft_expr *expr)
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct nft_payload *payload;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	payload = nft_expr_priv(track->regs[priv->dreg].selector);
+	payload = nft_expr_priv(reg->selector);
 	if (priv->base != payload->base ||
 	    priv->offset != payload->offset ||
-	    priv->len != payload->len) {
+	    priv->len != payload->len)
+		return false;
+
+	return true;
+}
+
+static bool nft_payload_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+
+	if (!nft_payload_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 5b6c357cf8f2..b8519e509746 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -216,21 +216,31 @@ static int nft_socket_dump(struct sk_buff *skb,
 	return 0;
 }
 
-static bool nft_socket_reduce(struct nft_regs_track *track,
-			      const struct nft_expr *expr)
+static bool nft_socket_cmp(const struct nft_reg_track *reg,
+			   const struct nft_expr *expr)
 {
 	const struct nft_socket *priv = nft_expr_priv(expr);
 	const struct nft_socket *socket;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	socket = nft_expr_priv(track->regs[priv->dreg].selector);
+	socket = nft_expr_priv(reg->selector);
 	if (priv->key != socket->key ||
 	    priv->dreg != socket->dreg ||
 	    priv->level != socket->level) {
+		return false;
+	}
+
+	return true;
+}
+
+static bool nft_socket_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_socket *priv = nft_expr_priv(expr);
+
+	if (!nft_socket_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3ccfd2ae4c93..220318940dd8 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -124,21 +124,30 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
-				  const struct nft_expr *expr)
+static bool nft_tunnel_cmp(const struct nft_reg_track *reg,
+			   const struct nft_expr *expr)
 {
 	const struct nft_tunnel *priv = nft_expr_priv(expr);
 	const struct nft_tunnel *tunnel;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	tunnel = nft_expr_priv(track->regs[priv->dreg].selector);
+	tunnel = nft_expr_priv(reg->selector);
 	if (priv->key != tunnel->key ||
 	    priv->dreg != tunnel->dreg ||
-	    priv->mode != tunnel->mode) {
+	    priv->mode != tunnel->mode)
+		return false;
+
+	return true;
+}
+
+static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
+				  const struct nft_expr *expr)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+
+	if (!nft_tunnel_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 4a481ce9a4a8..8dcb69e39b04 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -257,22 +257,31 @@ static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *e
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
-static bool nft_xfrm_reduce(struct nft_regs_track *track,
-			    const struct nft_expr *expr)
+static bool nft_xfrm_cmp(const struct nft_reg_track *reg,
+			 const struct nft_expr *expr)
 {
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 	const struct nft_xfrm *xfrm;
 
-	if (!nft_reg_track_cmp(&track->regs[priv->dreg], expr)) {
-		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+	if (!nft_reg_track_cmp(reg, expr))
 		return false;
-	}
 
-	xfrm = nft_expr_priv(track->regs[priv->dreg].selector);
+	xfrm = nft_expr_priv(reg->selector);
 	if (priv->key != xfrm->key ||
 	    priv->dreg != xfrm->dreg ||
 	    priv->dir != xfrm->dir ||
-	    priv->spnum != xfrm->spnum) {
+	    priv->spnum != xfrm->spnum)
+		return false;
+
+	return true;
+}
+
+static bool nft_xfrm_reduce(struct nft_regs_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_xfrm *priv = nft_expr_priv(expr);
+
+	if (!nft_xfrm_cmp(&track->regs[priv->dreg], expr)) {
 		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
-- 
2.30.2

