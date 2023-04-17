Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BC0C77B72
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Apr 2023 10:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjDQKYE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Apr 2023 06:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDQKYD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Apr 2023 06:24:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9E21138
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Apr 2023 03:23:11 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: validate catch-all set elements
Date:   Mon, 17 Apr 2023 12:21:16 +0200
Message-Id: <20230417102116.26219-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

catch-all set element might jump/goto to chain that uses expressions
that require validation.

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++
 net/netfilter/nf_tables_api.c     | 62 ++++++++++++++++++++++++++++---
 net/netfilter/nft_lookup.c        | 36 ++----------------
 3 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9430128aae99..1b8e305bb54a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1085,6 +1085,10 @@ struct nft_chain {
 };
 
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem);
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cd52109e674a..22a162057426 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3447,6 +3447,62 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	return 0;
 }
 
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
+	const struct nft_data *data;
+	int err;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
+	data = nft_set_ext_data(ext);
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		pctx->level++;
+		err = nft_chain_validate(ctx, data->verdict.chain);
+		if (err < 0)
+			return err;
+		pctx->level--;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+struct nft_set_elem_catchall {
+	struct list_head	list;
+	struct rcu_head		rcu;
+	void			*elem;
+};
+
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		ret = nft_setelem_validate(ctx, set, NULL, catchall->elem);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
@@ -4759,12 +4815,6 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-struct nft_set_elem_catchall {
-	struct list_head	list;
-	struct rcu_head		rcu;
-	void			*elem;
-};
-
 static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 				     struct nft_set *set)
 {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index cae5a6724163..cecf8ab90e58 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -199,37 +199,6 @@ static int nft_lookup_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static int nft_lookup_validate_setelem(const struct nft_ctx *ctx,
-				       struct nft_set *set,
-				       const struct nft_set_iter *iter,
-				       struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
-	const struct nft_data *data;
-	int err;
-
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
-	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
-		return 0;
-
-	data = nft_set_ext_data(ext);
-	switch (data->verdict.code) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		pctx->level++;
-		err = nft_chain_validate(ctx, data->verdict.chain);
-		if (err < 0)
-			return err;
-		pctx->level--;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **d)
@@ -245,9 +214,12 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
-	iter.fn		= nft_lookup_validate_setelem;
+	iter.fn		= nft_setelem_validate;
 
 	priv->set->ops->walk(ctx, priv->set, &iter);
+	if (!iter.err)
+		iter.err = nft_set_catchall_validate(ctx, priv->set);
+
 	if (iter.err < 0)
 		return iter.err;
 
-- 
2.30.2

