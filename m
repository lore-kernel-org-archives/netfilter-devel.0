Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38F8C10F1B
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Dec 2022 19:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiLST3S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 14:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiLST2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 14:28:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B93F915A30
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2022 11:28:49 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf,v2 2/4] netfilter: nf_tables: add function to create set stateful expressions
Date:   Mon, 19 Dec 2022 20:28:42 +0100
Message-Id: <20221219192844.212253-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221219192844.212253-1-pablo@netfilter.org>
References: <20221219192844.212253-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a helper function to allocate and initialize the stateful expressions
that are defined in a set.

This patch allows to reuse this code from the set update path, to check
that type of the update matches the existing set in the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

 net/netfilter/nf_tables_api.c | 107 ++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1deecc1a6c00..67ce89695afb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4388,6 +4388,60 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 	return err;
 }
 
+static int nft_set_expr_alloc(struct nft_ctx *ctx, struct nft_set *set,
+			      const struct nlattr * const *nla,
+			      struct nft_expr **exprs, int *num_exprs,
+			      u32 flags)
+{
+	struct nft_expr *expr;
+	int err, i;
+
+	if (nla[NFTA_SET_EXPR]) {
+		expr = nft_set_elem_expr_alloc(ctx, set, nla[NFTA_SET_EXPR]);
+		if (IS_ERR(expr)) {
+			err = PTR_ERR(expr);
+			goto err_set_expr_alloc;
+		}
+		exprs[0] = expr;
+		(*num_exprs)++;
+	} else if (nla[NFTA_SET_EXPRESSIONS]) {
+		struct nft_expr *expr;
+		struct nlattr *tmp;
+		int left;
+
+		if (!(flags & NFT_SET_EXPR)) {
+			err = -EINVAL;
+			goto err_set_expr_alloc;
+		}
+		i = 0;
+		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
+			if (i == NFT_SET_EXPR_MAX) {
+				err = -E2BIG;
+				goto err_set_expr_alloc;
+			}
+			if (nla_type(tmp) != NFTA_LIST_ELEM) {
+				err = -EINVAL;
+				goto err_set_expr_alloc;
+			}
+			expr = nft_set_elem_expr_alloc(ctx, set, tmp);
+			if (IS_ERR(expr)) {
+				err = PTR_ERR(expr);
+				goto err_set_expr_alloc;
+			}
+			exprs[i++] = expr;
+			(*num_exprs)++;
+		}
+	}
+
+	return 0;
+
+err_set_expr_alloc:
+	for (i = 0; i < *num_exprs; i++)
+		nft_expr_destroy(ctx, exprs[i]);
+
+	return err;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
@@ -4395,7 +4449,6 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_set_ops *ops;
-	struct nft_expr *expr = NULL;
 	struct net *net = info->net;
 	struct nft_set_desc desc;
 	struct nft_table *table;
@@ -4403,6 +4456,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	size_t alloc_size;
+	int num_exprs = 0;
 	char *name;
 	int err, i;
 	u16 udlen;
@@ -4529,6 +4583,8 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			return PTR_ERR(set);
 		}
 	} else {
+		struct nft_expr *exprs[NFT_SET_EXPR_MAX] = {};
+
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
 			return -EEXIST;
@@ -4536,6 +4592,13 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		err = nft_set_expr_alloc(&ctx, set, nla, exprs, &num_exprs, flags);
+		if (err < 0)
+			return err;
+
+		for (i = 0; i < num_exprs; i++)
+			nft_expr_destroy(&ctx, exprs[i]);
+
 		return 0;
 	}
 
@@ -4603,43 +4666,11 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_set_init;
 
-	if (nla[NFTA_SET_EXPR]) {
-		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
-		if (IS_ERR(expr)) {
-			err = PTR_ERR(expr);
-			goto err_set_expr_alloc;
-		}
-		set->exprs[0] = expr;
-		set->num_exprs++;
-	} else if (nla[NFTA_SET_EXPRESSIONS]) {
-		struct nft_expr *expr;
-		struct nlattr *tmp;
-		int left;
-
-		if (!(flags & NFT_SET_EXPR)) {
-			err = -EINVAL;
-			goto err_set_expr_alloc;
-		}
-		i = 0;
-		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
-			if (i == NFT_SET_EXPR_MAX) {
-				err = -E2BIG;
-				goto err_set_expr_alloc;
-			}
-			if (nla_type(tmp) != NFTA_LIST_ELEM) {
-				err = -EINVAL;
-				goto err_set_expr_alloc;
-			}
-			expr = nft_set_elem_expr_alloc(&ctx, set, tmp);
-			if (IS_ERR(expr)) {
-				err = PTR_ERR(expr);
-				goto err_set_expr_alloc;
-			}
-			set->exprs[i++] = expr;
-			set->num_exprs++;
-		}
-	}
+	err = nft_set_expr_alloc(&ctx, set, nla, set->exprs, &num_exprs, flags);
+	if (err < 0)
+		goto err_set_destroy;
 
+	set->num_exprs = num_exprs;
 	set->handle = nf_tables_alloc_handle(table);
 
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
@@ -4653,7 +4684,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 err_set_expr_alloc:
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(&ctx, set->exprs[i]);
-
+err_set_destroy:
 	ops->destroy(set);
 err_set_init:
 	kfree(set->name);
-- 
2.30.2

