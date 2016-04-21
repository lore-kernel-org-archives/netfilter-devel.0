From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 1/4] netfilter: nft_ct: rename struct nft_ct to nft_ct_reg
Date: Thu, 21 Apr 2016 16:34:41 +0200
Message-ID: <1461249284-12114-2-git-send-email-fw@strlen.de>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54969 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbcDUOe3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2016 10:34:29 -0400
In-Reply-To: <1461249284-12114-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo suggested to have upcoming set support that takes value from an
immediate attribute use distinct struct:

Quoting Pablo:
  'I'd suggest "struct nft_ct_reg" and "struct nft_ct_imm"'.

Make it so.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_ct.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 25998fa..4f66cb9 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -22,7 +22,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 
-struct nft_ct {
+struct nft_ct_reg {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
 	union {
@@ -47,7 +47,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
 {
-	const struct nft_ct *priv = nft_expr_priv(expr);
+	const struct nft_ct_reg *priv = nft_expr_priv(expr);
 	u32 *dest = &regs->data[priv->dreg];
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
@@ -177,7 +177,7 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
 {
-	const struct nft_ct *priv = nft_expr_priv(expr);
+	const struct nft_ct_reg *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	u32 value = regs->data[priv->sreg];
@@ -247,7 +247,7 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
 {
-	struct nft_ct *priv = nft_expr_priv(expr);
+	struct nft_ct_reg *priv = nft_expr_priv(expr);
 	unsigned int len;
 	int err;
 
@@ -354,7 +354,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
 {
-	struct nft_ct *priv = nft_expr_priv(expr);
+	struct nft_ct_reg *priv = nft_expr_priv(expr);
 	unsigned int len;
 	int err;
 
@@ -381,15 +381,15 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_ct_destroy(const struct nft_ctx *ctx,
-			   const struct nft_expr *expr)
+static void nft_ct_reg_destroy(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
 {
 	nft_ct_l3proto_module_put(ctx->afi->family);
 }
 
 static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_ct *priv = nft_expr_priv(expr);
+	const struct nft_ct_reg *priv = nft_expr_priv(expr);
 
 	if (nft_dump_register(skb, NFTA_CT_DREG, priv->dreg))
 		goto nla_put_failure;
@@ -424,7 +424,7 @@ nla_put_failure:
 
 static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_ct *priv = nft_expr_priv(expr);
+	const struct nft_ct_reg *priv = nft_expr_priv(expr);
 
 	if (nft_dump_register(skb, NFTA_CT_SREG, priv->sreg))
 		goto nla_put_failure;
@@ -439,19 +439,19 @@ nla_put_failure:
 static struct nft_expr_type nft_ct_type;
 static const struct nft_expr_ops nft_ct_get_ops = {
 	.type		= &nft_ct_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct_reg)),
 	.eval		= nft_ct_get_eval,
 	.init		= nft_ct_get_init,
-	.destroy	= nft_ct_destroy,
+	.destroy	= nft_ct_reg_destroy,
 	.dump		= nft_ct_get_dump,
 };
 
 static const struct nft_expr_ops nft_ct_set_ops = {
 	.type		= &nft_ct_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct_reg)),
 	.eval		= nft_ct_set_eval,
 	.init		= nft_ct_set_init,
-	.destroy	= nft_ct_destroy,
+	.destroy	= nft_ct_reg_destroy,
 	.dump		= nft_ct_set_dump,
 };
 
-- 
2.7.3

