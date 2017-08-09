From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v4 1/3] netlink: Pass nlmsg flags from rule.c
Date: Wed,  9 Aug 2017 13:16:41 +0200
Message-ID: <20170809111643.18906-2-phil@nwl.cc>
References: <20170809111643.18906-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60479 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752396AbdHILRP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2017 07:17:15 -0400
In-Reply-To: <20170809111643.18906-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is no point in checking value of excl in each called function.
Just do it in a single spot and pass resulting flags.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Fix for 'insert rule' command.
---
 include/netlink.h | 10 ++++-----
 src/netlink.c     | 64 +++++++++++++++++++++++++------------------------------
 src/rule.c        | 26 +++++++++++-----------
 3 files changed, 48 insertions(+), 52 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 7865186b62767..ffbc51d352fa0 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -124,7 +124,7 @@ extern int netlink_replace_rule_batch(struct netlink_ctx *ctx,
 
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
-			     const struct chain *chain, bool excl);
+			     const struct chain *chain, uint32_t flags);
 extern int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc, const char *name);
 extern int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
@@ -140,7 +140,7 @@ extern int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 
 extern int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
-			     const struct table *table, bool excl);
+			     const struct table *table, uint32_t flags);
 extern int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc);
 extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
@@ -153,7 +153,7 @@ extern int netlink_flush_table(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
 
 extern int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
-			   struct set *set, bool excl);
+			   struct set *set, uint32_t flags);
 extern int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 			      const struct location *loc);
 extern int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
@@ -165,7 +165,7 @@ extern struct stmt *netlink_parse_set_expr(const struct set *set,
 					   const struct nftnl_expr *nle);
 
 extern int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-				const struct expr *expr, bool excl);
+				const struct expr *expr, uint32_t flags);
 extern int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				   const struct expr *expr);
 extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
@@ -179,7 +179,7 @@ extern int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 			      const struct location *loc, uint32_t type,
 			      bool dump);
 extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
-			   struct obj *obj, bool excl);
+			   struct obj *obj, uint32_t flags);
 extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 			      struct location *loc, uint32_t type);
 
diff --git a/src/netlink.c b/src/netlink.c
index ffdadfb19a4a3..26032f956aba6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -597,7 +597,7 @@ void netlink_dump_chain(const struct nftnl_chain *nlc)
 static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 				    const struct handle *h,
 				    const struct location *loc,
-				    const struct chain *chain, bool excl)
+				    const struct chain *chain, uint32_t flags)
 {
 	struct nftnl_chain *nlc;
 	int err;
@@ -618,7 +618,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 	}
 
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(ctx->nf_sock, nlc, excl ? NLM_F_EXCL : 0);
+	err = mnl_nft_chain_add(ctx->nf_sock, nlc, flags);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -630,7 +630,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 				   const struct handle *h,
 				   const struct location *loc,
-				   const struct chain *chain, bool excl)
+				   const struct chain *chain, uint32_t flags)
 {
 	struct nftnl_chain *nlc;
 	int err;
@@ -654,8 +654,7 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 	}
 
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_add(nlc, ctx->batch, excl ? NLM_F_EXCL : 0,
-				      ctx->seqnum);
+	err = mnl_nft_chain_batch_add(nlc, ctx->batch, flags, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -666,12 +665,12 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 
 int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc, const struct chain *chain,
-		      bool excl)
+		      uint32_t flags)
 {
 	if (ctx->batch_supported)
-		return netlink_add_chain_batch(ctx, h, loc, chain, excl);
+		return netlink_add_chain_batch(ctx, h, loc, chain, flags);
 	else
-		return netlink_add_chain_compat(ctx, h, loc, chain, excl);
+		return netlink_add_chain_compat(ctx, h, loc, chain, flags);
 }
 
 static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
@@ -901,13 +900,13 @@ int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 static int netlink_add_table_compat(struct netlink_ctx *ctx,
 				    const struct handle *h,
 				    const struct location *loc,
-				    const struct table *table, bool excl)
+				    const struct table *table, uint32_t flags)
 {
 	struct nftnl_table *nlt;
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_add(ctx->nf_sock, nlt, excl ? NLM_F_EXCL : 0);
+	err = mnl_nft_table_add(ctx->nf_sock, nlt, flags);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -919,7 +918,7 @@ static int netlink_add_table_compat(struct netlink_ctx *ctx,
 static int netlink_add_table_batch(struct netlink_ctx *ctx,
 				   const struct handle *h,
 				   const struct location *loc,
-				   const struct table *table, bool excl)
+				   const struct table *table, uint32_t flags)
 {
 	struct nftnl_table *nlt;
 	int err;
@@ -930,8 +929,7 @@ static int netlink_add_table_batch(struct netlink_ctx *ctx,
 	else
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, 0);
 
-	err = mnl_nft_table_batch_add(nlt, ctx->batch, excl ? NLM_F_EXCL : 0,
-				      ctx->seqnum);
+	err = mnl_nft_table_batch_add(nlt, ctx->batch, flags, ctx->seqnum);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -942,12 +940,12 @@ static int netlink_add_table_batch(struct netlink_ctx *ctx,
 
 int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc,
-		      const struct table *table, bool excl)
+		      const struct table *table, uint32_t flags)
 {
 	if (ctx->batch_supported)
-		return netlink_add_table_batch(ctx, h, loc, table, excl);
+		return netlink_add_table_batch(ctx, h, loc, table, flags);
 	else
-		return netlink_add_table_compat(ctx, h, loc, table, excl);
+		return netlink_add_table_compat(ctx, h, loc, table, flags);
 }
 
 static int netlink_del_table_compat(struct netlink_ctx *ctx,
@@ -1228,9 +1226,8 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 static int netlink_add_set_compat(struct netlink_ctx *ctx,
 				  const struct handle *h, struct set *set,
-				  bool excl)
+				  uint32_t flags)
 {
-	unsigned int flags = excl ? NLM_F_EXCL : 0;
 	struct nftnl_set *nls;
 	int err;
 
@@ -1261,7 +1258,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 
 static int netlink_add_set_batch(struct netlink_ctx *ctx,
 				 const struct handle *h, struct set *set,
-				 bool excl)
+				 uint32_t flags)
 {
 	struct nftnl_udata_buf *udbuf;
 	struct nftnl_set *nls;
@@ -1318,8 +1315,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 
 	netlink_dump_set(nls);
 
-	err = mnl_nft_set_batch_add(nls, ctx->batch, excl ? NLM_F_EXCL : 0,
-				    ctx->seqnum);
+	err = mnl_nft_set_batch_add(nls, ctx->batch, flags, ctx->seqnum);
 	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1329,12 +1325,12 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 }
 
 int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
-		    struct set *set, bool excl)
+		    struct set *set, uint32_t flags)
 {
 	if (ctx->batch_supported)
-		return netlink_add_set_batch(ctx, h, set, excl);
+		return netlink_add_set_batch(ctx, h, set, flags);
 	else
-		return netlink_add_set_compat(ctx, h, set, excl);
+		return netlink_add_set_compat(ctx, h, set, flags);
 }
 
 static int netlink_del_set_compat(struct netlink_ctx *ctx,
@@ -1449,7 +1445,7 @@ static void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 
 static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 				      const struct handle *h,
-				      const struct expr *expr, bool excl)
+				      const struct expr *expr, uint32_t flags)
 {
 	struct nftnl_set *nls;
 	int err;
@@ -1458,8 +1454,7 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_batch_add(nls, ctx->batch, excl ? NLM_F_EXCL : 0,
-					ctx->seqnum);
+	err = mnl_nft_setelem_batch_add(nls, ctx->batch, flags, ctx->seqnum);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1470,7 +1465,7 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 
 static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 				       const struct handle *h,
-				       const struct expr *expr, bool excl)
+				       const struct expr *expr, uint32_t flags)
 {
 	struct nftnl_set *nls;
 	int err;
@@ -1479,7 +1474,7 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_add(ctx->nf_sock, nls, excl ? NLM_F_EXCL : 0);
+	err = mnl_nft_setelem_add(ctx->nf_sock, nls, flags);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1489,12 +1484,12 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 }
 
 int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct expr *expr, bool excl)
+			 const struct expr *expr, uint32_t flags)
 {
 	if (ctx->batch_supported)
-		return netlink_add_setelems_batch(ctx, h, expr, excl);
+		return netlink_add_setelems_batch(ctx, h, expr, flags);
 	else
-		return netlink_add_setelems_compat(ctx, h, expr, excl);
+		return netlink_add_setelems_compat(ctx, h, expr, flags);
 }
 
 static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
@@ -1770,7 +1765,7 @@ void netlink_dump_obj(struct nftnl_obj *nln)
 }
 
 int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
-		    struct obj *obj, bool excl)
+		    struct obj *obj, uint32_t flags)
 {
 	struct nftnl_obj *nlo;
 	int err;
@@ -1778,8 +1773,7 @@ int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 	nlo = alloc_nftnl_obj(h, obj);
 	netlink_dump_obj(nlo);
 
-	err = mnl_nft_obj_batch_add(nlo, ctx->batch, excl ? NLM_F_EXCL : 0,
-				    ctx->seqnum);
+	err = mnl_nft_obj_batch_add(nlo, ctx->batch, flags, ctx->seqnum);
 	if (err < 0)
 		netlink_io_error(ctx, &obj->location, "Could not add %s: %s",
 				 obj_type_name(obj->type), strerror(errno));
diff --git a/src/rule.c b/src/rule.c
index 12714ed3ccc70..6b9dbb623b313 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -972,17 +972,17 @@ void cmd_free(struct cmd *cmd)
 #include <netlink.h>
 
 static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			     struct set *set, struct expr *expr, bool excl)
+			     struct set *set, struct expr *expr, uint32_t flags)
 {
 	expr->set_flags |= set->flags;
-	if (netlink_add_setelems(ctx, h, expr, excl) < 0)
+	if (netlink_add_setelems(ctx, h, expr, flags) < 0)
 		return -1;
 
 	return 0;
 }
 
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			   struct expr *init, bool excl)
+			   struct expr *init, uint32_t flags)
 {
 	struct table *table;
 	struct set *set;
@@ -994,18 +994,18 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	    set_to_intervals(ctx->msgs, set, init, true) < 0)
 		return -1;
 
-	return __do_add_setelems(ctx, h, set, init, excl);
+	return __do_add_setelems(ctx, h, set, init, flags);
 }
 
 static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
-		      struct set *set, bool excl)
+		      struct set *set, uint32_t flags)
 {
 	if (set->init != NULL) {
 		if (set->flags & NFT_SET_INTERVAL &&
 		    set_to_intervals(ctx->msgs, set, set->init, true) < 0)
 			return -1;
 	}
-	if (netlink_add_set(ctx, h, set, excl) < 0)
+	if (netlink_add_set(ctx, h, set, flags) < 0)
 		return -1;
 	if (set->init != NULL) {
 		return __do_add_setelems(ctx, &set->handle, set, set->init,
@@ -1016,24 +1016,26 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 
 static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 {
+	uint32_t flags = excl ? NLM_F_EXCL : 0;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		return netlink_add_table(ctx, &cmd->handle, &cmd->location,
-					 cmd->table, excl);
+					 cmd->table, flags);
 	case CMD_OBJ_CHAIN:
 		return netlink_add_chain(ctx, &cmd->handle, &cmd->location,
-					 cmd->chain, excl);
+					 cmd->chain, flags);
 	case CMD_OBJ_RULE:
 		return netlink_add_rule_batch(ctx, &cmd->handle,
-					      cmd->rule, NLM_F_APPEND);
+					      cmd->rule, flags | NLM_F_APPEND);
 	case CMD_OBJ_SET:
-		return do_add_set(ctx, &cmd->handle, cmd->set, excl);
+		return do_add_set(ctx, &cmd->handle, cmd->set, flags);
 	case CMD_OBJ_SETELEM:
-		return do_add_setelems(ctx, &cmd->handle, cmd->expr, excl);
+		return do_add_setelems(ctx, &cmd->handle, cmd->expr, flags);
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
-		return netlink_add_obj(ctx, &cmd->handle, cmd->object, excl);
+		return netlink_add_obj(ctx, &cmd->handle, cmd->object, flags);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.13.1

