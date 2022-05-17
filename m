Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80D6C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 17:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351405AbiEQRVO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 13:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351383AbiEQRVM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 13:21:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FC2255AB
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 10:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mfRY2jBoDQQ2Q68SheBYIit2q5mfQP6YhB1Kw4XlMYw=; b=J6W7vEG5axkEErti7mEDWQF7Du
        e0QjiRAuv6r+zrEczXP63AJ3zljV9jhgUtsDjIv5pnotTpzcXb5NoeXVyzEmSdAqfm3TpzpJGjOz9
        tx1YmNKr6i11bDdji+9XI28lgoj62FWJuxhq97nu/RuEdggRtfCUJQYEmuw3YNXyc5fOpyRU1Evgt
        Bh+a5Z85xYqgr12LTWy4hSzb/Ik2Gh1nFzCOyNMuYGfpupJJG+pMkTLjy21EvjP9ECgmyTFvivHZL
        FwTQjNqp7ZIeTFJ62oqs6ZF3oLzP46CZSy1GqQqBI25SbF7Q6xDAISx7NWUNCfEUHE+a6wQIbtJQu
        8k4IcrMA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nr0sf-0005o5-Qs; Tue, 17 May 2022 19:21:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH v4 1/4] netfilter: nf_tables: Store net size in nft_expr_ops::size
Date:   Tue, 17 May 2022 19:20:47 +0200
Message-Id: <20220517172050.32653-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517172050.32653-1-phil@nwl.cc>
References: <20220517172050.32653-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prepare for expressions of different size in ruleset blob by storing
only the per-expression payload in struct nft_expr_ops' size field
instead of a value depending on size of struct nft_expr.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Adjust nft_setelem_expr_foreach() and nft_expr_next() accordingly.
---
 include/net/netfilter/nf_tables.h |  8 +++++---
 net/netfilter/nf_tables_api.c     | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 20af9d3557b9d..3efdc68497148 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -335,7 +335,8 @@ struct nft_set_estimate {
 };
 
 #define NFT_EXPR_MAXATTR		16
-#define NFT_EXPR_SIZE(size)		(sizeof(struct nft_expr) + \
+#define NFT_EXPR_SIZE(size)		size
+#define NFT_EXPR_FULL_SIZE(size)	(sizeof(struct nft_expr) + \
 					 ALIGN(size, __alignof__(struct nft_expr)))
 
 /**
@@ -464,7 +465,8 @@ struct nft_set_elem_expr {
 #define nft_setelem_expr_foreach(__expr, __elem_expr, __size)		\
 	for (__expr = nft_setelem_expr_at(__elem_expr, 0), __size = 0;	\
 	     __size < (__elem_expr)->size;				\
-	     __size += (__expr)->ops->size, __expr = ((void *)(__expr)) + (__expr)->ops->size)
+	     __size += NFT_EXPR_FULL_SIZE((__expr)->ops->size),		\
+	     __expr = ((void *)(__expr)) + NFT_EXPR_FULL_SIZE((__expr)->ops->size))
 
 #define NFT_SET_EXPR_MAX	2
 
@@ -940,7 +942,7 @@ static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
 
 static inline struct nft_expr *nft_expr_next(const struct nft_expr *expr)
 {
-	return ((void *)expr) + expr->ops->size;
+	return ((void *)expr) + NFT_EXPR_FULL_SIZE(expr->ops->size);
 }
 
 static inline struct nft_expr *nft_expr_last(const struct nft_rule *rule)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3ad02a399f8a..609fc9137ac01 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2876,7 +2876,8 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 		goto err1;
 
 	err = -ENOMEM;
-	expr = kzalloc(expr_info.ops->size, GFP_KERNEL_ACCOUNT);
+	expr = kzalloc(NFT_EXPR_FULL_SIZE(expr_info.ops->size),
+		       GFP_KERNEL_ACCOUNT);
 	if (expr == NULL)
 		goto err2;
 
@@ -2907,7 +2908,7 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 		if (err < 0)
 			return err;
 	} else {
-		memcpy(dst, src, src->ops->size);
+		memcpy(dst, src, NFT_EXPR_FULL_SIZE(src->ops->size));
 	}
 
 	__module_get(src->ops->type->owner);
@@ -3468,7 +3469,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 				NL_SET_BAD_ATTR(extack, tmp);
 				goto err_release_expr;
 			}
-			size += expr_info[n].ops->size;
+			size += NFT_EXPR_FULL_SIZE(expr_info[n].ops->size);
 			n++;
 		}
 	}
@@ -5526,7 +5527,8 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 	int err, i, k;
 
 	for (i = 0; i < set->num_exprs; i++) {
-		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL_ACCOUNT);
+		expr = kzalloc(NFT_EXPR_FULL_SIZE(set->exprs[i]->ops->size),
+			       GFP_KERNEL_ACCOUNT);
 		if (!expr)
 			goto err_expr;
 
@@ -5562,7 +5564,7 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 		if (err < 0)
 			goto err_elem_expr_setup;
 
-		elem_expr->size += expr_array[i]->ops->size;
+		elem_expr->size += NFT_EXPR_FULL_SIZE(expr_array[i]->ops->size);
 		nft_expr_destroy(ctx, expr_array[i]);
 		expr_array[i] = NULL;
 	}
@@ -5929,7 +5931,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	if (num_exprs) {
 		for (i = 0; i < num_exprs; i++)
-			size += expr_array[i]->ops->size;
+			size += NFT_EXPR_FULL_SIZE(expr_array[i]->ops->size);
 
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
 				       sizeof(struct nft_set_elem_expr) +
@@ -8356,9 +8358,9 @@ static bool nft_expr_reduce(struct nft_regs_track *track,
 
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
+	unsigned int size, expr_size, data_size;
 	const struct nft_expr *expr, *last;
 	struct nft_regs_track track = {};
-	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
@@ -8404,11 +8406,12 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 				continue;
 			}
 
-			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
+			expr_size = NFT_EXPR_FULL_SIZE(expr->ops->size);
+			if (WARN_ON_ONCE(data + expr_size > data_boundary))
 				return -ENOMEM;
 
-			memcpy(data + size, expr, expr->ops->size);
-			size += expr->ops->size;
+			memcpy(data + size, expr, expr_size);
+			size += expr_size;
 		}
 		if (WARN_ON_ONCE(size >= 1 << 12))
 			return -ENOMEM;
-- 
2.34.1

