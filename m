Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCD8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 16:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356678AbiELQr5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 12:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356680AbiELQry (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 12:47:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B84250E83
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 09:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mAyNNM5Lg6e2ETC36csWAGTJm+BFG1+7bvCeqX5IqI8=; b=cQmXknJq4sTcFotGEx/Y4M0skr
        tgqbHggW1LctaQXLxRbf8uPXrAE8GttjhhdEugFV1rDMkclgyCCLITSTgOtc2EcV1nkRxEBURhnwr
        QvK8qtJMtrxPNYtsmXKzdxKNxFfer/T6Q2B+HrSEvPSjygmJ2kGAbdpEdv1MrFCZC4bAJcFG1sfzN
        UOOMoXVxC/+LG9m23ktT5AbeYyMJN4f5f4gceQSiK8LSEwx8/P+JQxtdzZX0qMH4R4oSXQy567gvK
        FL4N24Gdkq0ICwIjHGN9ojukEWdtvbXeE0dC5y4MU+9NwhH4xaqg3j1EM6QuP/j/btvORNNpKPiHb
        BWlKCd1Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1npByf-0004Q3-Uu; Thu, 12 May 2022 18:47:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 1/4] netfilter: nf_tables: Store net size in nft_expr_ops::size
Date:   Thu, 12 May 2022 18:47:38 +0200
Message-Id: <20220512164741.31440-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220512164741.31440-1-phil@nwl.cc>
References: <20220512164741.31440-1-phil@nwl.cc>
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
 include/net/netfilter/nf_tables.h |  3 ++-
 net/netfilter/nf_tables_api.c     | 23 +++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 20af9d3557b9d..4308e38df8e7a 100644
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

