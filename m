From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 1/5] src: Remove xt_stmt_() functions.
Date: Wed, 16 Aug 2017 19:48:13 +0530
Message-ID: <20170816141817.20179-2-rvarsha016@gmail.com>
References: <20170816141817.20179-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37177 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdHPOTC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 10:19:02 -0400
Received: by mail-pg0-f65.google.com with SMTP id 83so5374245pgb.4
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2017 07:19:01 -0700 (PDT)
In-Reply-To: <20170816141817.20179-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove functions xt_stmt_alloc(), xt_stmt_release(), xt_stmt_xlate(),
xt_stmt_print(), xt_stmt_destroy() as they are not used. Similarly,
remove structure xt_stmt_ops.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/statement.h |  2 --
 include/xt.h        |  7 -----
 src/statement.c     | 23 -----------------
 src/xt.c            | 74 -----------------------------------------------------
 4 files changed, 106 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 49fb109..61b5027 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -195,8 +195,6 @@ struct xt_stmt {
 	void				*entry;
 };
 
-extern struct stmt *xt_stmt_alloc(const struct location *loc);
-
 /**
  * enum stmt_types - statement types
  *
diff --git a/include/xt.h b/include/xt.h
index 753511e..dfdf9ee 100644
--- a/include/xt.h
+++ b/include/xt.h
@@ -8,9 +8,6 @@ struct rule_pp_ctx;
 struct rule;
 
 #ifdef HAVE_LIBXTABLES
-void xt_stmt_xlate(const struct stmt *stmt);
-void xt_stmt_release(const struct stmt *stmt);
-
 void netlink_parse_target(struct netlink_parse_ctx *ctx,
 			  const struct location *loc,
 			  const struct nftnl_expr *nle);
@@ -20,9 +17,6 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 void stmt_xt_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt,
 			 struct rule *rule);
 #else
-static inline void xt_stmt_xlate(const struct stmt *stmt) {}
-static inline void xt_stmt_release(const struct stmt *stmt) {}
-
 #include <erec.h>
 
 static inline void netlink_parse_target(struct netlink_parse_ctx *ctx,
@@ -35,5 +29,4 @@ static inline void stmt_xt_postprocess(struct rule_pp_ctx *rctx,
 				       struct stmt *stmt, struct rule *rule) {}
 
 #endif
-
 #endif /* _NFT_XT_H_ */
diff --git a/src/statement.c b/src/statement.c
index 0ce875e..58f8aaf 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -689,26 +689,3 @@ struct stmt *fwd_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &fwd_stmt_ops);
 }
 
-static void xt_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
-{
-	xt_stmt_xlate(stmt);
-}
-
-static void xt_stmt_destroy(struct stmt *stmt)
-{
-	xfree(stmt->xt.name);
-	xfree(stmt->xt.opts);
-	xt_stmt_release(stmt);
-}
-
-static const struct stmt_ops xt_stmt_ops = {
-	.type		= STMT_XT,
-	.name		= "xt",
-	.print		= xt_stmt_print,
-	.destroy	= xt_stmt_destroy,
-};
-
-struct stmt *xt_stmt_alloc(const struct location *loc)
-{
-	return stmt_alloc(loc, &xt_stmt_ops);
-}
diff --git a/src/xt.c b/src/xt.c
index 9680f8e..3bc38ee 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -26,78 +26,6 @@
 #include <linux/netfilter_arp/arp_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 
-void xt_stmt_xlate(const struct stmt *stmt)
-{
-	struct xt_xlate *xl = xt_xlate_alloc(10240);
-
-	switch (stmt->xt.type) {
-	case NFT_XT_MATCH:
-		if (stmt->xt.match == NULL && stmt->xt.opts) {
-			printf("%s", stmt->xt.opts);
-		} else if (stmt->xt.match->xlate) {
-			struct xt_xlate_mt_params params = {
-				.ip		= stmt->xt.entry,
-				.match		= stmt->xt.match->m,
-				.numeric        = 0,
-			};
-
-			stmt->xt.match->xlate(xl, &params);
-			printf("%s", xt_xlate_get(xl));
-		} else if (stmt->xt.match->print) {
-			printf("#");
-			stmt->xt.match->print(&stmt->xt.entry,
-					      stmt->xt.match->m, 0);
-		}
-		break;
-	case NFT_XT_WATCHER:
-	case NFT_XT_TARGET:
-		if (stmt->xt.target == NULL && stmt->xt.opts) {
-			printf("%s", stmt->xt.opts);
-		} else if (stmt->xt.target->xlate) {
-			struct xt_xlate_tg_params params = {
-				.ip		= stmt->xt.entry,
-				.target		= stmt->xt.target->t,
-				.numeric        = 0,
-			};
-
-			stmt->xt.target->xlate(xl, &params);
-			printf("%s", xt_xlate_get(xl));
-		} else if (stmt->xt.target->print) {
-			printf("#");
-			stmt->xt.target->print(NULL, stmt->xt.target->t, 0);
-		}
-		break;
-	default:
-		break;
-	}
-
-	xt_xlate_free(xl);
-}
-
-void xt_stmt_release(const struct stmt *stmt)
-{
-	switch (stmt->xt.type) {
-	case NFT_XT_MATCH:
-		if (!stmt->xt.match)
-			break;
-		if (stmt->xt.match->m)
-			xfree(stmt->xt.match->m);
-		xfree(stmt->xt.match);
-		break;
-	case NFT_XT_WATCHER:
-	case NFT_XT_TARGET:
-		if (!stmt->xt.target)
-			break;
-		if (stmt->xt.target->t)
-			xfree(stmt->xt.target->t);
-		xfree(stmt->xt.target);
-		break;
-	default:
-		break;
-	}
-	xfree(stmt->xt.entry);
-}
-
 static void *xt_entry_alloc(struct xt_stmt *xt, uint32_t af)
 {
 	union nft_entry {
@@ -215,7 +143,6 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
 	m->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_MT_REV);
 
-	stmt = xt_stmt_alloc(loc);
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_MATCH;
 	stmt->xt.match = xt_match_clone(mt);
@@ -252,7 +179,6 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
 	t->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_TG_REV);
 	strcpy(t->u.user.name, tg->name);
 
-	stmt = xt_stmt_alloc(loc);
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_TARGET;
 	stmt->xt.target = xt_target_clone(tg);
-- 
2.13.5

