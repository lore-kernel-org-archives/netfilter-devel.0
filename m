From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 nf-next 4/7] nftables: add conntrack dependencies for nat/masq/redir expressions
Date: Tue, 15 Nov 2016 21:36:42 +0100
Message-ID: <1479242205-21675-5-git-send-email-fw@strlen.de>
References: <1479242205-21675-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45088 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932333AbcKOUgl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 15:36:41 -0500
In-Reply-To: <1479242205-21675-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

so that conntrack core will add the needed hooks in this namespace.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v3.

 net/ipv4/netfilter/nft_masq_ipv4.c  |  7 +++++++
 net/ipv4/netfilter/nft_redir_ipv4.c |  7 +++++++
 net/ipv6/netfilter/nft_masq_ipv6.c  |  7 +++++++
 net/ipv6/netfilter/nft_redir_ipv6.c |  7 +++++++
 net/netfilter/nft_masq.c            |  2 +-
 net/netfilter/nft_nat.c             | 11 ++++++++++-
 net/netfilter/nft_redir.c           |  2 +-
 7 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index 4f697e431811..914da9188820 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -35,12 +35,19 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 						    &range, nft_out(pkt));
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
index 16df0493c5ce..94238fe3bccc 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -38,12 +38,19 @@ static void nft_redir_ipv4_eval(const struct nft_expr *expr,
 	regs->verdict.code = nf_nat_redirect_ipv4(pkt->skb, &mr, nft_hook(pkt));
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
index a2aff1277b40..c79dcb87f4a3 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -36,12 +36,19 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 						    nft_out(pkt));
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
index bfcd5af6bc15..88dd1d94ed25 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -39,12 +39,19 @@ static void nft_redir_ipv6_eval(const struct nft_expr *expr,
 		nf_nat_redirect_ipv6(pkt->skb, &range, nft_hook(pkt));
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
index 81b5ad6165ac..f90e49c990f9 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -77,7 +77,7 @@ int nft_masq_init(const struct nft_ctx *ctx,
 		}
 	}
 
-	return 0;
+	return nf_ct_netns_get(ctx->net, ctx->afi->family);
 }
 EXPORT_SYMBOL_GPL(nft_masq_init);
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ee2d71753746..19a7bf3236f9 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -209,7 +209,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return -EINVAL;
 	}
 
-	return 0;
+	return nf_ct_netns_get(ctx->net, family);
 }
 
 static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -257,12 +257,21 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
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
index 03f7bf40ae75..f8227ec44419 100644
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
2.7.3

