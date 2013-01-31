From: pablo@netfilter.org
Subject: [nftables 6/9] netfilter: nf_tables: add protocol and flags for xtables over nf_tables
Date: Thu, 31 Jan 2013 01:04:02 +0100
Message-ID: <1359590645-4703-6-git-send-email-pablo@netfilter.org>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:41637 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3AaAEa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:30 -0500
In-Reply-To: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds the missing protocol and flags information in order
to pass it to xt_check_target / xt_check_match.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |   14 +++++++++++
 include/net/netfilter/nf_tables.h   |    2 ++
 net/netfilter/nf_tables_api.c       |   15 +++++++-----
 net/netfilter/nft_compat.c          |   44 +++++++++++++++++++++++++++++++----
 4 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ccd2c30..76b215f 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -100,10 +100,24 @@ enum nft_rule_attributes {
 	NFTA_RULE_HANDLE,
 	NFTA_RULE_EXPRESSIONS,
 	NFTA_RULE_FLAGS,
+	NFTA_RULE_COMPAT,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
 
+enum nft_rule_compat_flags {
+	NFT_RULE_COMPAT_F_INV	= (1 << 1),
+	NFT_RULE_COMPAT_F_MASK	= NFT_RULE_COMPAT_F_INV,
+};
+
+enum nft_rule_compat_attributes {
+	NFTA_RULE_COMPAT_UNSPEC,
+	NFTA_RULE_COMPAT_PROTO,
+	NFTA_RULE_COMPAT_FLAGS,
+	__NFTA_RULE_COMPAT_MAX
+};
+#define NFTA_RULE_COMPAT_MAX	(__NFTA_RULE_COMPAT_MAX - 1)
+
 /**
  * enum nft_set_flags - nf_tables set flags
  *
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a9df310..d172b66 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -74,6 +74,7 @@ static inline void nft_data_debug(const struct nft_data *data)
  * 	@afi: address family info
  * 	@table: the table the chain is contained in
  * 	@chain: the chain the rule is contained in
+ *	@nla: netlink attributes
  */
 struct nft_ctx {
 	struct net			*net;
@@ -82,6 +83,7 @@ struct nft_ctx {
 	const struct nft_af_info	*afi;
 	const struct nft_table		*table;
 	const struct nft_chain		*chain;
+	const struct nlattr * const 	*nla;
 };
 
 struct nft_data_desc {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 141e33e..6eda6cc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1037,7 +1037,8 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 			 const struct nlmsghdr *nlh,
 			 const struct nft_af_info *afi,
 			 const struct nft_table *table,
-			 const struct nft_chain *chain)
+			 const struct nft_chain *chain,
+			 const struct nlattr * const *nla)
 {
 	ctx->net   = sock_net(skb->sk);
 	ctx->skb   = skb;
@@ -1045,6 +1046,7 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->afi   = afi;
 	ctx->table = table;
 	ctx->chain = chain;
+	ctx->nla   = nla;
 }
 
 /*
@@ -1252,6 +1254,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 };
 
 static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
@@ -1555,7 +1558,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		handle = nf_tables_alloc_handle(table);
 	}
 
-	nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 
 	n = 0;
 	size = 0;
@@ -1676,7 +1679,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
-	nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 
 	if (nla[NFTA_RULE_FLAGS]) {
 		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
@@ -1885,7 +1888,7 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	nft_ctx_init(ctx, skb, nlh, afi, table, NULL);
+	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
 	return 0;
 }
 
@@ -2168,7 +2171,7 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
 
 	set = nf_tables_set_lookup(table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set)) {
@@ -2353,7 +2356,7 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	nft_ctx_init(ctx, skb, nlh, afi, table, NULL);
+	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
 	return 0;
 }
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index dc156f6..f7dd3db 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -107,6 +107,34 @@ static inline int nft_compat_target_offset(struct xt_target *target)
 #endif
 }
 
+static const struct nla_policy nft_rule_compat_policy[NFTA_RULE_COMPAT_MAX + 1] = {
+	[NFTA_RULE_COMPAT_PROTO]	= { .type = NLA_U32 },
+	[NFTA_RULE_COMPAT_FLAGS]	= { .type = NLA_U32 },
+};
+
+static u8 nft_parse_compat(const struct nlattr *attr, bool *inv)
+{
+	struct nlattr *tb[NFTA_RULE_COMPAT_MAX+1];
+	u32 flags;
+	int err;
+
+	err = nla_parse_nested(tb, NFTA_RULE_COMPAT_MAX, attr,
+			       nft_rule_compat_policy);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_RULE_COMPAT_PROTO] || !tb[NFTA_RULE_COMPAT_FLAGS])
+		return -EINVAL;
+
+	flags = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_FLAGS]));
+	if (flags & ~NFT_RULE_COMPAT_F_MASK)
+		return -EINVAL;
+	if (flags & NFT_RULE_COMPAT_F_INV)
+		*inv = true;
+
+	return ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
+}
+
 static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
@@ -115,14 +143,18 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct xt_target *target = expr->ops->data;
 	struct xt_tgchk_param par;
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
+	u8 proto = 0;
+	bool inv = false;
 	int ret;
 
 	target_compat_from_user(target, nla_data(tb[NFTA_TARGET_INFO]), info);
 
 	nft_target_set_tgchk_param(&par, ctx, target, info);
 
-	/* FIXME: not checking protocol and inversion */
-	ret = xt_check_target(&par, size, 0, false);
+	if (ctx->nla[NFTA_RULE_COMPAT])
+		proto = nft_parse_compat(ctx->nla[NFTA_RULE_COMPAT], &inv);
+
+	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0)
 		goto err;
 
@@ -289,14 +321,18 @@ nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct xt_match *match = expr->ops->data;
 	struct xt_mtchk_param par;
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_MATCH_INFO]));
+	u8 proto = 0;
+	bool inv = false;
 	int ret;
 
 	match_compat_from_user(match, nla_data(tb[NFTA_MATCH_INFO]), info);
 
 	nft_match_set_mtchk_param(&par, ctx, match, info);
 
-	/* FIXME: not checking protocol and inversion, do this in userspace */
-	ret = xt_check_match(&par, size, 0, false);
+	if (ctx->nla[NFTA_RULE_COMPAT])
+		proto = nft_parse_compat(ctx->nla[NFTA_RULE_COMPAT], &inv);
+
+	ret = xt_check_match(&par, size, proto, inv);
 	if (ret < 0)
 		goto err;
 
-- 
1.7.10.4

