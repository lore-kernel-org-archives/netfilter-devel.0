From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH 1/2] netfilter: add nf_nat_netns_get infrasstructure
Date: Thu, 29 Jun 2017 14:28:55 +0200
Message-ID: <20170629122856.28231-2-fw@strlen.de>
References: <20170629122856.28231-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39752 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752601AbdF2M2m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 08:28:42 -0400
In-Reply-To: <20170629122856.28231-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds nf_nat_netns_get and put helpers, and uses them in the nft
expressions and xtables targets that deal with nat setup.

The new helpers are just aliases for nf_ct_netns_get/put, this is done
to keep the actual change -- per netns register of nat rewrite hooks --
separate.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_nat.h      |  4 ++++
 net/ipv4/netfilter/ipt_MASQUERADE.c |  4 ++--
 net/ipv4/netfilter/nft_masq_ipv4.c  |  2 +-
 net/ipv4/netfilter/nft_redir_ipv4.c |  2 +-
 net/ipv6/netfilter/nft_masq_ipv6.c  |  2 +-
 net/ipv6/netfilter/nft_redir_ipv6.c |  2 +-
 net/netfilter/nf_nat_core.c         | 24 ++++++++++++++++++++++++
 net/netfilter/nft_masq.c            |  2 +-
 net/netfilter/nft_nat.c             |  4 ++--
 net/netfilter/nft_redir.c           |  2 +-
 net/netfilter/xt_NETMAP.c           |  6 +++---
 net/netfilter/xt_REDIRECT.c         |  6 +++---
 net/netfilter/xt_nat.c              |  6 +++---
 13 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 05c82a1a4267..5f67507dc381 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -47,6 +47,10 @@ extern unsigned int nf_nat_alloc_null_binding(struct nf_conn *ct,
 
 struct nf_conn_nat *nf_ct_nat_ext_add(struct nf_conn *ct);
 
+/* net namespace needs NAT hooks */
+int nf_nat_netns_get(struct net *net, u8 nfproto);
+void nf_nat_netns_put(struct net *net, u8 nfproto);
+
 /* Is this tuple already taken? (not by us)*/
 int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conn *ignored_conntrack);
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index a03e4e7ef5f9..a4d2515c835b 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -41,7 +41,7 @@ static int masquerade_tg_check(const struct xt_tgchk_param *par)
 		pr_debug("bad rangesize %u\n", mr->rangesize);
 		return -EINVAL;
 	}
-	return nf_ct_netns_get(par->net, par->family);
+	return nf_nat_netns_get(par->net, par->family);
 }
 
 static unsigned int
@@ -61,7 +61,7 @@ masquerade_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 static void masquerade_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_netns_put(par->net, par->family);
+	nf_nat_netns_put(par->net, par->family);
 }
 
 static struct xt_target masquerade_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index f18677277119..165107887039 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -38,7 +38,7 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 static void
 nft_masq_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
+	nf_nat_netns_put(ctx->net, NFPROTO_IPV4);
 }
 
 static struct nft_expr_type nft_masq_ipv4_type;
diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
index 5120be1d3118..a2220ef2158e 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -41,7 +41,7 @@ static void nft_redir_ipv4_eval(const struct nft_expr *expr,
 static void
 nft_redir_ipv4_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV4);
+	nf_nat_netns_put(ctx->net, NFPROTO_IPV4);
 }
 
 static struct nft_expr_type nft_redir_ipv4_type;
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index 4146536e9c15..d2cdbdcfd6d7 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -39,7 +39,7 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 static void
 nft_masq_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
+	nf_nat_netns_put(ctx->net, NFPROTO_IPV6);
 }
 
 static struct nft_expr_type nft_masq_ipv6_type;
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
index a27e424f690d..56c2c5501623 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -42,7 +42,7 @@ static void nft_redir_ipv6_eval(const struct nft_expr *expr,
 static void
 nft_redir_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
-	nf_ct_netns_put(ctx->net, NFPROTO_IPV6);
+	nf_nat_netns_put(ctx->net, NFPROTO_IPV6);
 }
 
 static struct nft_expr_type nft_redir_ipv6_type;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d26cc2f864e6..cb81a561e9d0 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -818,6 +818,30 @@ static struct nf_ct_helper_expectfn follow_master_nat = {
 	.expectfn	= nf_nat_follow_master,
 };
 
+int nf_nat_netns_get(struct net *net, u8 nfproto)
+{
+	int ret;
+
+	if (WARN_ON(nfproto >= ARRAY_SIZE(nat_net->users)))
+		return -EINVAL;
+
+	ret = nf_ct_netns_get(net, nfproto);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_netns_get);
+
+void nf_nat_netns_put(struct net *net, u8 nfproto)
+{
+	if (WARN_ON(nfproto >= ARRAY_SIZE(nat_net->users)))
+		goto out;
+out:
+	nf_ct_netns_put(net, nfproto);
+}
+EXPORT_SYMBOL_GPL(nf_nat_netns_put);
+
 static int __init nf_nat_init(void)
 {
 	int ret;
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 6ac03d4266c9..849103923ca2 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -73,7 +73,7 @@ int nft_masq_init(const struct nft_ctx *ctx,
 		}
 	}
 
-	return nf_ct_netns_get(ctx->net, ctx->afi->family);
+	return nf_nat_netns_get(ctx->net, ctx->afi->family);
 }
 EXPORT_SYMBOL_GPL(nft_masq_init);
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ed548d06b6dd..19cc0a9cc624 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -205,7 +205,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			return -EINVAL;
 	}
 
-	return nf_ct_netns_get(ctx->net, family);
+	return nf_nat_netns_get(ctx->net, family);
 }
 
 static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -258,7 +258,7 @@ nft_nat_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
-	nf_ct_netns_put(ctx->net, priv->family);
+	nf_nat_netns_put(ctx->net, priv->family);
 }
 
 static struct nft_expr_type nft_nat_type;
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 1e66538bf0ff..06db5f027fc4 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -75,7 +75,7 @@ int nft_redir_init(const struct nft_ctx *ctx,
 			return -EINVAL;
 	}
 
-	return nf_ct_netns_get(ctx->net, ctx->afi->family);
+	return nf_nat_netns_get(ctx->net, ctx->afi->family);
 }
 EXPORT_SYMBOL_GPL(nft_redir_init);
 
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index e45a01255e70..b5dc9dcad34f 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -60,12 +60,12 @@ static int netmap_tg6_checkentry(const struct xt_tgchk_param *par)
 
 	if (!(range->flags & NF_NAT_RANGE_MAP_IPS))
 		return -EINVAL;
-	return nf_ct_netns_get(par->net, par->family);
+	return nf_nat_netns_get(par->net, par->family);
 }
 
 static void netmap_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_netns_put(par->net, par->family);
+	nf_nat_netns_put(par->net, par->family);
 }
 
 static unsigned int
@@ -116,7 +116,7 @@ static int netmap_tg4_check(const struct xt_tgchk_param *par)
 		pr_debug("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
-	return nf_ct_netns_get(par->net, par->family);
+	return nf_nat_netns_get(par->net, par->family);
 }
 
 static struct xt_target netmap_tg_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_REDIRECT.c b/net/netfilter/xt_REDIRECT.c
index 98a4c6d4f1cb..b5a7afd8d9fd 100644
--- a/net/netfilter/xt_REDIRECT.c
+++ b/net/netfilter/xt_REDIRECT.c
@@ -41,12 +41,12 @@ static int redirect_tg6_checkentry(const struct xt_tgchk_param *par)
 	if (range->flags & NF_NAT_RANGE_MAP_IPS)
 		return -EINVAL;
 
-	return nf_ct_netns_get(par->net, par->family);
+	return nf_nat_netns_get(par->net, par->family);
 }
 
 static void redirect_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_netns_put(par->net, par->family);
+	nf_nat_netns_put(par->net, par->family);
 }
 
 /* FIXME: Take multiple ranges --RR */
@@ -62,7 +62,7 @@ static int redirect_tg4_check(const struct xt_tgchk_param *par)
 		pr_debug("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
-	return nf_ct_netns_get(par->net, par->family);
+	return nf_nat_netns_get(par->net, par->family);
 }
 
 static unsigned int
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index 8107b3eb865f..379a31aa1aae 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -23,17 +23,17 @@ static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 			par->target->name);
 		return -EINVAL;
 	}
-	return nf_ct_netns_get(par->net, par->family);
+	return nf_nat_netns_get(par->net, par->family);
 }
 
 static int xt_nat_checkentry(const struct xt_tgchk_param *par)
 {
-	return nf_ct_netns_get(par->net, par->family);
+	return nf_nat_netns_get(par->net, par->family);
 }
 
 static void xt_nat_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_netns_put(par->net, par->family);
+	nf_nat_netns_put(par->net, par->family);
 }
 
 static void xt_nat_convert_range(struct nf_nat_range *dst,
-- 
2.13.0

