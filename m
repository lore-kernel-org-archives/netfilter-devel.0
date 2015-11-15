From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft] rule: move comment out of handle
Date: Sun, 15 Nov 2015 16:13:05 +0000
Message-ID: <1447603985-25854-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:53380 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbbKOQNM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2015 11:13:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The comment does not belong to the handle, it belongs to the rule.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/rule.h            |  4 ++--
 src/netlink.c             |  3 ---
 src/netlink_delinearize.c | 16 ++++++++--------
 src/netlink_linearize.c   |  4 ++++
 src/parser_bison.y        |  2 +-
 src/rule.c                |  8 +++-----
 6 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index a86f600..c848f0f 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -15,7 +15,6 @@
  * @handle:	rule handle (rules only)
  * @position:	rule position (rules only)
  * @set_id:	set ID (sets only)
- * @comment:	human-readable comment (rules only)
  */
 struct handle {
 	uint32_t		family;
@@ -25,7 +24,6 @@ struct handle {
 	uint64_t		handle;
 	uint64_t		position;
 	uint32_t		set_id;
-	const char		*comment;
 };
 
 extern void handle_merge(struct handle *dst, const struct handle *src);
@@ -157,6 +155,7 @@ extern void chain_print_plain(const struct chain *chain);
  * @location:	location the rule was defined at
  * @stmt:	list of statements
  * @num_stmts:	number of statements in stmts list
+ * @comment:	comment
  */
 struct rule {
 	struct list_head	list;
@@ -164,6 +163,7 @@ struct rule {
 	struct location		location;
 	struct list_head	stmts;
 	unsigned int		num_stmts;
+	const char		*comment;
 };
 
 extern struct rule *rule_alloc(const struct location *loc,
diff --git a/src/netlink.c b/src/netlink.c
index ad86084..974afb1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -167,9 +167,6 @@ struct nftnl_rule *alloc_nftnl_rule(const struct handle *h)
 		nftnl_rule_set_u64(nlr, NFTNL_RULE_HANDLE, h->handle);
 	if (h->position)
 		nftnl_rule_set_u64(nlr, NFTNL_RULE_POSITION, h->position);
-	if (h->comment)
-		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
-				       h->comment, strlen(h->comment) + 1);
 
 	return nlr;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3584de7..3499d74 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1609,19 +1609,19 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	if (nftnl_rule_is_set(nlr, NFTNL_RULE_POSITION))
 		h.position = nftnl_rule_get_u64(nlr, NFTNL_RULE_POSITION);
 
+	pctx->rule = rule_alloc(&netlink_location, &h);
+	pctx->table = table_lookup(&h);
+	assert(pctx->table != NULL);
+
 	if (nftnl_rule_is_set(nlr, NFTNL_RULE_USERDATA)) {
-		uint32_t len;
 		const void *data;
+		uint32_t len;
 
-		data = nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA,
-					      &len);
-		h.comment = xmalloc(len);
-		memcpy((char *)h.comment, data, len);
+		data = nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
+		pctx->rule->comment = xmalloc(len);
+		memcpy((char *)pctx->rule->comment, data, len);
 	}
 
-	pctx->rule = rule_alloc(&netlink_location, &h);
-	pctx->table = table_lookup(&h);
-	assert(pctx->table != NULL);
 	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pctx);
 
 	rule_parse_postprocess(pctx, pctx->rule);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c9af036..7c6ef16 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1030,5 +1030,9 @@ void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
 	list_for_each_entry(stmt, &rule->stmts, list)
 		netlink_gen_stmt(&lctx, stmt);
 
+	if (rule->comment)
+		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
+				    rule->comment, strlen(rule->comment) + 1);
+
 	netlink_dump_rule(nlr);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ab4524b..ec1e742 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1288,7 +1288,7 @@ rule			:	stmt_list	comment_spec
 				struct stmt *i;
 
 				$$ = rule_alloc(&@$, NULL);
-				$$->handle.comment = $2;
+				$$->comment = $2;
 				list_for_each_entry(i, $1, list)
 					$$->num_stmts++;
 				list_splice_tail($1, &$$->stmts);
diff --git a/src/rule.c b/src/rule.c
index df4d1fb..5d3cd84 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -32,7 +32,6 @@ void handle_free(struct handle *h)
 	xfree(h->table);
 	xfree(h->chain);
 	xfree(h->set);
-	xfree(h->comment);
 }
 
 void handle_merge(struct handle *dst, const struct handle *src)
@@ -49,8 +48,6 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->handle = src->handle;
 	if (dst->position == 0)
 		dst->position = src->position;
-	if (dst->comment == NULL && src->comment != NULL)
-		dst->comment = xstrdup(src->comment);
 }
 
 static LIST_HEAD(table_list);
@@ -378,6 +375,7 @@ void rule_free(struct rule *rule)
 {
 	stmt_list_free(&rule->stmts);
 	handle_free(&rule->handle);
+	xfree(rule->comment);
 	xfree(rule);
 }
 
@@ -390,8 +388,8 @@ void rule_print(const struct rule *rule)
 		printf(" ");
 	}
 
-	if (rule->handle.comment)
-		printf("comment \"%s\" ", rule->handle.comment);
+	if (rule->comment)
+		printf("comment \"%s\" ", rule->comment);
 
 	if (handle_output > 0)
 		printf("# handle %" PRIu64, rule->handle.handle);
-- 
2.5.0

