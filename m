From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 08/12] nftables: add conntrack dependencies for nat/masq/redir expressions
Date: Thu,  3 Dec 2015 10:49:41 +0100
Message-ID: <1449136185-4165-9-git-send-email-fw@strlen.de>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52608 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759429AbbLCJuW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:50:22 -0500
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

so that conntrack core will add the needed hooks in this namespace.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v2.

 net/ipv4/netfilter/nft_masq_ipv4.c  |  7 +++++++
 net/ipv4/netfilter/nft_redir_ipv4.c |  7 +++++++
 net/ipv6/netfilter/nft_masq_ipv6.c  |  7 +++++++
 net/ipv6/netfilter/nft_redir_ipv6.c |  7 +++++++
 net/netfilter/nft_masq.c            |  5 +++--
 net/netfilter/nft_nat.c             | 11 ++++++++++-
 net/netfilter/nft_redir.c           |  2 +-
 7 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index b72ffc5..ee5bb98 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -30,12 +30,19 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 						    &range, pkt->out);
 }
 
+static void
+nft_masq_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
+}
+
 static struct nft_expr_type nft_masq_ipv4_type;
 static const struct nft_expr_ops nft_masq_ipv4_ops = {
 	.type		= &nft_masq_ipv4_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
 	.eval		= nft_masq_ipv4_eval,
 	.init		= nft_masq_init,
+	.destroy	= nft_masq_ipv4_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
 };
diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
index c09d438..862eb5a 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -39,12 +39,19 @@ static void nft_redir_ipv4_eval(const struct nft_expr *expr,
 						  pkt->hook);
 }
 
+static void
+nft_redir_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
+}
+
 static struct nft_expr_type nft_redir_ipv4_type;
 static const struct nft_expr_ops nft_redir_ipv4_ops = {
 	.type		= &nft_redir_ipv4_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
 	.eval		= nft_redir_ipv4_eval,
 	.init		= nft_redir_init,
+	.destroy	= nft_redir_ipv4_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
 };
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index cd1ac16..a8b3626 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -30,12 +30,19 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 	regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range, pkt->out);
 }
 
+static void
+nft_masq_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
+}
+
 static struct nft_expr_type nft_masq_ipv6_type;
 static const struct nft_expr_ops nft_masq_ipv6_ops = {
 	.type		= &nft_masq_ipv6_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
 	.eval		= nft_masq_ipv6_eval,
 	.init		= nft_masq_init,
+	.destroy	= nft_masq_ipv6_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
 };
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
index aca44e8..ef673cd 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -38,12 +38,19 @@ static void nft_redir_ipv6_eval(const struct nft_expr *expr,
 	regs->verdict.code = nf_nat_redirect_ipv6(pkt->skb, &range, pkt->hook);
 }
 
+static void
+nft_redir_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
+}
+
 static struct nft_expr_type nft_redir_ipv6_type;
 static const struct nft_expr_ops nft_redir_ipv6_ops = {
 	.type		= &nft_redir_ipv6_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
 	.eval		= nft_redir_ipv6_eval,
 	.init		= nft_redir_init,
+	.destroy	= nft_redir_ipv6_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
 };
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 9aea747..c7269c3 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -48,13 +48,14 @@ int nft_masq_init(const struct nft_ctx *ctx,
 		return err;
 
 	if (tb[NFTA_MASQ_FLAGS] == NULL)
-		return 0;
+		goto out;
 
 	priv->flags = ntohl(nla_get_be32(tb[NFTA_MASQ_FLAGS]));
 	if (priv->flags & ~NF_NAT_RANGE_MASK)
 		return -EINVAL;
+ out:
+	return nf_ct_netns_get(ctx->net, ctx->afi->family);
 
-	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_masq_init);
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ee2d717..19a7bf3 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -209,7 +209,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return -EINVAL;
 	}
 
-	return 0;
+	return nf_ct_netns_get(ctx->net, family);
 }
 
 static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -257,12 +257,21 @@ nla_put_failure:
 	return -1;
 }
 
+static void
+nft_nat_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	const struct nft_nat *priv = nft_expr_priv(expr);
+
+	nf_ct_netns_put(ctx->net, priv->family);
+}
+
 static struct nft_expr_type nft_nat_type;
 static const struct nft_expr_ops nft_nat_ops = {
 	.type           = &nft_nat_type,
 	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
 	.eval           = nft_nat_eval,
 	.init           = nft_nat_init,
+	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
 	.validate	= nft_nat_validate,
 };
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 03f7bf4..f8227ec 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -79,7 +79,7 @@ int nft_redir_init(const struct nft_ctx *ctx,
 			return -EINVAL;
 	}
 
-	return 0;
+	return nf_ct_netns_get(ctx->net, ctx->afi->family);
 }
 EXPORT_SYMBOL_GPL(nft_redir_init);
 
-- 
2.4.10

