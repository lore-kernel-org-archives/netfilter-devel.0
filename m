Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C74FC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJEWhs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJEWhr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:37:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BA2263F0E
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:37:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 4/6] netfilter: nft_inner: add percpu inner context
Date:   Thu,  6 Oct 2022 00:37:38 +0200
Message-Id: <20221005223740.22991-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221005223740.22991-1-pablo@netfilter.org>
References: <20221005223740.22991-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add NFT_PKTINFO_INNER_FULL flag to annotate that inner offsets are
available. Store nft_inner_tun_ctx object in percpu area to cache
existing inner offsets for this skbuff.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  1 +
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/nft_inner.c              | 27 ++++++++++++++++++++++----
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c5827f8a0010..e2296ab5c83e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -24,6 +24,7 @@ struct module;
 enum {
 	NFT_PKTINFO_L4PROTO	= (1 << 0),
 	NFT_PKTINFO_INNER	= (1 << 1),
+	NFT_PKTINFO_INNER_FULL	= (1 << 2),
 };
 
 struct nft_pktinfo {
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index d80ec9a371a9..c05b690eb348 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -148,6 +148,7 @@ enum {
 };
 
 struct nft_inner_tun_ctx {
+	u8	type;
 	u8	inner_tunoff;
 	u8	inner_lloff;
 	u8	inner_nhoff;
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 53a9c07299e0..0e1c1d7dd823 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -21,6 +21,8 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 
+static DEFINE_PER_CPU(struct nft_inner_tun_ctx, nft_pcpu_tun_ctx);
+
 struct __nft_expr {
 	const struct nft_expr_ops	*ops;
 	union {
@@ -169,7 +171,7 @@ static int nft_inner_parse_tunhdr(const struct nft_inner *priv,
 }
 
 static int nft_inner_parse(const struct nft_inner *priv,
-			   const struct nft_pktinfo *pkt,
+			   struct nft_pktinfo *pkt,
 			   struct nft_inner_tun_ctx *ctx)
 {
 	u32 off = pkt->inneroff;
@@ -186,24 +188,41 @@ static int nft_inner_parse(const struct nft_inner *priv,
 		ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 	}
 
+	ctx->type = priv->type;
+	pkt->flags |= NFT_PKTINFO_INNER_FULL;
+
 	return 0;
 }
 
+static bool nft_inner_parse_needed(const struct nft_inner *priv,
+				   const struct nft_pktinfo *pkt,
+				   const struct nft_inner_tun_ctx *tun_ctx)
+{
+	if (!(pkt->flags & NFT_PKTINFO_INNER_FULL))
+		return true;
+
+	if (priv->type != tun_ctx->type)
+		return true;
+
+	return false;
+}
+
 static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			   const struct nft_pktinfo *pkt)
 {
+	struct nft_inner_tun_ctx *tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
 	const struct nft_inner *priv = nft_expr_priv(expr);
-	struct nft_inner_tun_ctx tun_ctx = {};
 
 	if (nft_payload_inner_offset(pkt) < 0)
 		goto err;
 
-	if (nft_inner_parse(priv, pkt, &tun_ctx) < 0)
+	if (nft_inner_parse_needed(priv, pkt, tun_ctx) &&
+	    nft_inner_parse(priv, (struct nft_pktinfo *)pkt, tun_ctx) < 0)
 		goto err;
 
 	switch (priv->expr_type) {
 	case NFT_INNER_EXPR_PAYLOAD:
-		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
+		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, tun_ctx);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.30.2

