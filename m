From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2] set_expr: Allow passing the parent set to set_expr_alloc()
Date: Wed, 12 Jul 2017 14:14:16 +0200
Message-ID: <20170712121416.22871-1-phil@nwl.cc>
References: <20170712120315.GR16375@orbyte.nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59021 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbdGLMO3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:14:29 -0400
In-Reply-To: <20170712120315.GR16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Usually one wants to at least initialize set_flags from the parent, so
make allocation of a set's set expression more convenient.

The idea to do this came when fixing an issue with output formatting of
larger anonymous sets in nft monitor: Since
netlink_events_cache_addset() didn't initialize set_flags,
calculate_delim() didn't detect it's an anonymous set and therefore
added newlines to the output.

Reported-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
Fixes: a9dc3ceabc10f ("expression: print sets and maps in pretty format")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Changed set_expr_alloc() to return early if struct set pointer is
  NULL.
- Removed the unrelated extra chunk.
---
 include/expression.h |  3 ++-
 src/evaluate.c       |  2 +-
 src/expression.c     | 12 ++++++++++--
 src/netlink.c        |  8 +++-----
 src/parser_bison.y   |  4 ++--
 src/rule.c           |  2 +-
 6 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 3e67938a63906..68a36e8af792a 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -409,7 +409,8 @@ extern struct expr *concat_expr_alloc(const struct location *loc);
 
 extern struct expr *list_expr_alloc(const struct location *loc);
 
-extern struct expr *set_expr_alloc(const struct location *loc);
+extern struct expr *set_expr_alloc(const struct location *loc,
+				   const struct set *set);
 extern int set_to_intervals(struct list_head *msgs, struct set *set,
 			    struct expr *init, bool add);
 extern void interval_map_decompose(struct expr *set);
diff --git a/src/evaluate.c b/src/evaluate.c
index ca8b63b74fdcc..87ea64550bb44 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1956,7 +1956,7 @@ static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
 
 	/* Declare an empty set */
 	key = stmt->flow.key;
-	set = set_expr_alloc(&key->location);
+	set = set_expr_alloc(&key->location, NULL);
 	set->set_flags |= NFT_SET_EVAL;
 	if (key->timeout)
 		set->set_flags |= NFT_SET_TIMEOUT;
diff --git a/src/expression.c b/src/expression.c
index f90ca6035bd3a..d41ada39cc0ff 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -824,9 +824,17 @@ static const struct expr_ops set_expr_ops = {
 	.destroy	= compound_expr_destroy,
 };
 
-struct expr *set_expr_alloc(const struct location *loc)
+struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 {
-	return compound_expr_alloc(loc, &set_expr_ops);
+	struct expr *set_expr = compound_expr_alloc(loc, &set_expr_ops);
+
+	if (!set)
+		return set_expr;
+
+	set_expr->set_flags = set->flags;
+	set_expr->dtype = set->keytype;
+
+	return set_expr;
 }
 
 static void mapping_expr_print(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/netlink.c b/src/netlink.c
index 880502cde20c6..2e30622de4bb1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1732,10 +1732,8 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	}
 
 	ctx->set = set;
-	set->init = set_expr_alloc(loc);
+	set->init = set_expr_alloc(loc, set);
 	nftnl_set_elem_foreach(nls, list_setelem_cb, ctx);
-	set->init->set_flags = set->flags;
-	set->init->dtype = set->keytype;
 
 	if (!(set->flags & NFT_SET_INTERVAL))
 		list_expr_sort(&ctx->set->init->expressions);
@@ -2232,7 +2230,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		dummyset = set_alloc(monh->loc);
 		dummyset->keytype = set->keytype;
 		dummyset->datatype = set->datatype;
-		dummyset->init = set_expr_alloc(monh->loc);
+		dummyset->init = set_expr_alloc(monh->loc, set);
 
 		nlsei = nftnl_set_elems_iter_create(nls);
 		if (nlsei == NULL)
@@ -2430,7 +2428,7 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 	s = netlink_delinearize_set(&set_tmpctx, nls);
 	if (s == NULL)
 		goto out;
-	s->init = set_expr_alloc(monh->loc);
+	s->init = set_expr_alloc(monh->loc, s);
 
 	t = table_lookup(&s->handle);
 	if (t == NULL) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a8448e14ef1f5..099057a674091 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1787,7 +1787,7 @@ verdict_map_expr	:	'{'	verdict_map_list_expr	'}'
 
 verdict_map_list_expr	:	verdict_map_list_member_expr
 			{
-				$$ = set_expr_alloc(&@$);
+				$$ = set_expr_alloc(&@$, NULL);
 				compound_expr_add($$, $1);
 			}
 			|	verdict_map_list_expr	COMMA	verdict_map_list_member_expr
@@ -2572,7 +2572,7 @@ set_expr		:	'{'	set_list_expr		'}'
 
 set_list_expr		:	set_list_member_expr
 			{
-				$$ = set_expr_alloc(&@$);
+				$$ = set_expr_alloc(&@$, NULL);
 				compound_expr_add($$, $1);
 			}
 			|	set_list_expr		COMMA	set_list_member_expr
diff --git a/src/rule.c b/src/rule.c
index f65674c0e2d4b..7f799f1b9043a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1624,7 +1624,7 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		list_for_each_entry(t, &table_list, list) {
 			list_for_each_entry(s, &t->sets, list)
-				s->init = set_expr_alloc(&cmd->location);
+				s->init = set_expr_alloc(&cmd->location, s);
 
 			if (!(cmd->monitor->flags & (1 << NFT_MSG_TRACE)))
 				continue;
-- 
2.13.1

