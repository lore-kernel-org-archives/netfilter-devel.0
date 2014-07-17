From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [PATCH] nftables: Add a flags attribute for lookup operator
Date: Thu, 17 Jul 2014 23:17:28 +0800
Message-ID: <1405610250-6631-2-git-send-email-yshuiv7@gmail.com>
References: <1405610250-6631-1-git-send-email-yshuiv7@gmail.com>
Cc: pablo@netfilter.org, tomasz.bursztyka@linux.intel.com,
	Yuxuan Shui <yshuiv7@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50301 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGQPRy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:17:54 -0400
Received: by mail-pd0-f179.google.com with SMTP id ft15so3317218pdb.38
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2014 08:17:53 -0700 (PDT)
In-Reply-To: <1405610250-6631-1-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So that we could modify the behaviour of the lookup operator using
flags.

The only flag available now is a negation flag which negates the result
of lookup operation.

v2: Rename the flags, reorder members in struct nft_lookup, check
for invaild flags.

v3: Fix checking for invaild flags.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++++++++
 net/netfilter/nft_lookup.c               | 22 +++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d41880f..9e6617e 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -479,6 +479,15 @@ enum nft_cmp_attributes {
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
 /**
+ * enum nft_lookup_flags - flags for nft_lookup operator
+ *
+ * @NFT_LOOKUP_FLAG_NEGATE: negate the result
+ */
+enum nft_lookup_flags {
+	NFT_LOOKUP_F_NEG = 1,
+};
+
+/**
  * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
  *
  * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
@@ -490,6 +499,7 @@ enum nft_lookup_attributes {
 	NFTA_LOOKUP_SET,
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
+	NFTA_LOOKUP_FLAG,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 7fd2bea..0702f73 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -22,6 +22,8 @@ struct nft_lookup {
 	struct nft_set			*set;
 	enum nft_registers		sreg:8;
 	enum nft_registers		dreg:8;
+	s8				match_verdict;
+	s8				no_match_verdict;
 	struct nft_set_binding		binding;
 };
 
@@ -32,15 +34,18 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
 
-	if (set->ops->lookup(set, &data[priv->sreg], &data[priv->dreg]))
+	if (set->ops->lookup(set, &data[priv->sreg], &data[priv->dreg])) {
+		data[NFT_REG_VERDICT].verdict = priv->match_verdict;
 		return;
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	}
+	data[NFT_REG_VERDICT].verdict = priv->no_match_verdict;
 }
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
 	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING },
 	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
+	[NFTA_LOOKUP_FLAG]	= { .type = NLA_U32 },
 };
 
 static int nft_lookup_init(const struct nft_ctx *ctx,
@@ -49,12 +54,23 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 	struct nft_set *set;
-	int err;
+	int err, flags;
 
 	if (tb[NFTA_LOOKUP_SET] == NULL ||
 	    tb[NFTA_LOOKUP_SREG] == NULL)
 		return -EINVAL;
 
+	priv->match_verdict = NFT_CONTINUE;
+	priv->no_match_verdict = NFT_BREAK;
+
+	flags = ntohl(nla_get_be32(tb[NFTA_LOOKUP_FLAG]));
+	if (flags & ~NFT_LOOKUP_F_NEG)
+		return -EINVAL;
+	if (flags & NFT_LOOKUP_F_NEG) {
+		priv->match_verdict = NFT_BREAK;
+		priv->no_match_verdict = NFT_CONTINUE;
+	}
+
 	set = nf_tables_set_lookup(ctx->table, tb[NFTA_LOOKUP_SET]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-- 
2.0.1

