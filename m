From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 4/5] src: netlink: Remove unused functions.
Date: Wed, 16 Aug 2017 19:48:16 +0530
Message-ID: <20170816141817.20179-5-rvarsha016@gmail.com>
References: <20170816141817.20179-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36391 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdHPOTQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 10:19:16 -0400
Received: by mail-pf0-f193.google.com with SMTP id t83so1495290pfj.3
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2017 07:19:16 -0700 (PDT)
In-Reply-To: <20170816141817.20179-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove netlink_add_rule_list(), netlink_dump_table(),
netlink_get_chain(), netlink_get_set(), netlink_get_table(),
netlink_list_chain() functions definitions as they are not 
called anywhere in source code.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/netlink.h |  11 ------
 src/netlink.c     | 104 ------------------------------------------------------
 2 files changed, 115 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 0e1d26b..4bed0e0 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -111,8 +111,6 @@ extern int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct rule *rule, uint32_t flags);
 extern int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
-extern int netlink_add_rule_list(struct netlink_ctx *ctx, const struct handle *h,
-				 const struct list_head *rule_list);
 extern int netlink_add_rule_batch(struct netlink_ctx *ctx,
 				  const struct handle *h,
 				  const struct rule *rule, uint32_t flags);
@@ -133,10 +131,6 @@ extern int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc);
 extern int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
-extern int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
-			     const struct location *loc);
-extern int netlink_list_chain(struct netlink_ctx *ctx, const struct handle *h,
-			      const struct location *loc);
 extern int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
 
@@ -147,8 +141,6 @@ extern int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc);
 extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
-extern int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
-			     const struct location *loc, struct table *table);
 extern int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h,
 			      const struct location *loc);
 extern int netlink_flush_table(struct netlink_ctx *ctx, const struct handle *h,
@@ -160,8 +152,6 @@ extern int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 			      const struct location *loc);
 extern int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc);
-extern int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
-			   const struct location *loc);
 
 extern struct stmt *netlink_parse_set_expr(const struct set *set,
 					   const struct nft_cache *cache,
@@ -186,7 +176,6 @@ extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 			      struct location *loc, uint32_t type);
 
-extern void netlink_dump_table(const struct nftnl_table *nlt);
 extern void netlink_dump_chain(const struct nftnl_chain *nlc);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr);
 extern void netlink_dump_expr(const struct nftnl_expr *nle);
diff --git a/src/netlink.c b/src/netlink.c
index 7311149..f6eb08f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -486,19 +486,6 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_add_rule_list(struct netlink_ctx *ctx, const struct handle *h,
-			  const struct list_head *rule_list)
-{
-	struct rule *rule;
-
-	list_for_each_entry(rule, rule_list, list) {
-		if (netlink_add_rule_batch(ctx, &rule->handle, rule,
-					   NLM_F_APPEND) < 0)
-			return -1;
-	}
-	return 0;
-}
-
 int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct location *loc)
 {
@@ -871,35 +858,6 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 				strerror(ENOENT));
 }
 
-int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc)
-{
-	struct nftnl_chain *nlc;
-	struct chain *chain;
-	int err;
-
-	nlc = alloc_nftnl_chain(h);
-	err = mnl_nft_chain_get(ctx->nf_sock, nlc, 0, ctx->seqnum);
-	if (err < 0) {
-		netlink_io_error(ctx, loc,
-				 "Could not receive chain from kernel: %s",
-				 strerror(errno));
-		goto out;
-	}
-
-	chain = netlink_delinearize_chain(ctx, nlc);
-	list_add_tail(&chain->list, &ctx->list);
-out:
-	nftnl_chain_free(nlc);
-	return err;
-}
-
-int netlink_list_chain(struct netlink_ctx *ctx, const struct handle *h,
-		       const struct location *loc)
-{
-	return netlink_list_rules(ctx, h, loc);
-}
-
 int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc)
 {
@@ -1000,19 +958,6 @@ int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 		return netlink_del_table_compat(ctx, h, loc);
 }
 
-void netlink_dump_table(const struct nftnl_table *nlt)
-{
-#ifdef DEBUG
-	char buf[4096];
-
-	if (!(debug_level & DEBUG_NETLINK))
-		return;
-
-	nftnl_table_snprintf(buf, sizeof(buf), nlt, 0, 0);
-	fprintf(stdout, "%s\n", buf);
-#endif
-}
-
 static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					       const struct nftnl_table *nlt)
 {
@@ -1055,30 +1000,6 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
-int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc, struct table *table)
-{
-	struct nftnl_table *nlt;
-	struct table *ntable;
-	int err;
-
-	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_get(ctx->nf_sock, nlt, 0, ctx->seqnum);
-	if (err < 0) {
-		netlink_io_error(ctx, loc,
-				 "Could not receive table from kernel: %s",
-				 strerror(errno));
-		goto out;
-	}
-
-	ntable = netlink_delinearize_table(ctx, nlt);
-	table->flags = ntable->flags;
-	table_free(ntable);
-out:
-	nftnl_table_free(nlt);
-	return err;
-}
-
 int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h,
 		       const struct location *loc)
 {
@@ -1418,31 +1339,6 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
-		    const struct location *loc)
-{
-	struct nftnl_set *nls;
-	struct set *set;
-	int err;
-
-	nls = alloc_nftnl_set(h);
-	err = mnl_nft_set_get(ctx->nf_sock, nls, ctx->seqnum);
-	if (err < 0) {
-		nftnl_set_free(nls);
-		return netlink_io_error(ctx, loc,
-					"Could not receive set from kernel: %s",
-					strerror(errno));
-	}
-
-	set = netlink_delinearize_set(ctx, nls);
-	nftnl_set_free(nls);
-	if (set == NULL)
-		return -1;
-	list_add_tail(&set->list, &ctx->list);
-
-	return err;
-}
-
 static void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 {
 	struct nftnl_set_elem *nlse;
-- 
2.13.5

