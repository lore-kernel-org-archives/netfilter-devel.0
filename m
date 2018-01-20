From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] Revert ("src: Remove xt_stmt_() functions").
Date: Sat, 20 Jan 2018 13:40:39 +0100
Message-ID: <20180120124039.6397-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55408 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbeATMkr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jan 2018 07:40:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 408C9DE387
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 13:40:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 311B7DA7E0
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 13:40:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08D6CDA7E0
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 13:40:43 +0100 (CET)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E31BF4265A2F
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 13:40:42 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Revert commit bce55916b51ec1a4c23322781e3b0c698ecc9561, we need this
code in place to properly make translation when iptables-compat loads
rules.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h |  2 ++
 include/xt.h        |  7 +++++
 src/statement.c     | 23 ++++++++++++++++
 src/xt.c            | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 23a551b67f2b..379d99e4c4a0 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -203,6 +203,8 @@ struct xt_stmt {
 	void				*entry;
 };
 
+extern struct stmt *xt_stmt_alloc(const struct location *loc);
+
 /**
  * enum stmt_types - statement types
  *
diff --git a/include/xt.h b/include/xt.h
index dfdf9ee0d599..753511e63508 100644
--- a/include/xt.h
+++ b/include/xt.h
@@ -8,6 +8,9 @@ struct rule_pp_ctx;
 struct rule;
 
 #ifdef HAVE_LIBXTABLES
+void xt_stmt_xlate(const struct stmt *stmt);
+void xt_stmt_release(const struct stmt *stmt);
+
 void netlink_parse_target(struct netlink_parse_ctx *ctx,
 			  const struct location *loc,
 			  const struct nftnl_expr *nle);
@@ -17,6 +20,9 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 void stmt_xt_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt,
 			 struct rule *rule);
 #else
+static inline void xt_stmt_xlate(const struct stmt *stmt) {}
+static inline void xt_stmt_release(const struct stmt *stmt) {}
+
 #include <erec.h>
 
 static inline void netlink_parse_target(struct netlink_parse_ctx *ctx,
@@ -29,4 +35,5 @@ static inline void stmt_xt_postprocess(struct rule_pp_ctx *rctx,
 				       struct stmt *stmt, struct rule *rule) {}
 
 #endif
+
 #endif /* _NFT_XT_H_ */
diff --git a/src/statement.c b/src/statement.c
index 1f93260bd3d5..701337d7713b 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -694,3 +694,26 @@ struct stmt *fwd_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &fwd_stmt_ops);
 }
 
+static void xt_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+{
+	xt_stmt_xlate(stmt);
+}
+
+static void xt_stmt_destroy(struct stmt *stmt)
+{
+	xfree(stmt->xt.name);
+	xfree(stmt->xt.opts);
+	xt_stmt_release(stmt);
+}
+
+static const struct stmt_ops xt_stmt_ops = {
+	.type		= STMT_XT,
+	.name		= "xt",
+	.print		= xt_stmt_print,
+	.destroy	= xt_stmt_destroy,
+};
+
+struct stmt *xt_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &xt_stmt_ops);
+}
diff --git a/src/xt.c b/src/xt.c
index 9aff4143aa19..9680f8ec4b03 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -26,6 +26,78 @@
 #include <linux/netfilter_arp/arp_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 
+void xt_stmt_xlate(const struct stmt *stmt)
+{
+	struct xt_xlate *xl = xt_xlate_alloc(10240);
+
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		if (stmt->xt.match == NULL && stmt->xt.opts) {
+			printf("%s", stmt->xt.opts);
+		} else if (stmt->xt.match->xlate) {
+			struct xt_xlate_mt_params params = {
+				.ip		= stmt->xt.entry,
+				.match		= stmt->xt.match->m,
+				.numeric        = 0,
+			};
+
+			stmt->xt.match->xlate(xl, &params);
+			printf("%s", xt_xlate_get(xl));
+		} else if (stmt->xt.match->print) {
+			printf("#");
+			stmt->xt.match->print(&stmt->xt.entry,
+					      stmt->xt.match->m, 0);
+		}
+		break;
+	case NFT_XT_WATCHER:
+	case NFT_XT_TARGET:
+		if (stmt->xt.target == NULL && stmt->xt.opts) {
+			printf("%s", stmt->xt.opts);
+		} else if (stmt->xt.target->xlate) {
+			struct xt_xlate_tg_params params = {
+				.ip		= stmt->xt.entry,
+				.target		= stmt->xt.target->t,
+				.numeric        = 0,
+			};
+
+			stmt->xt.target->xlate(xl, &params);
+			printf("%s", xt_xlate_get(xl));
+		} else if (stmt->xt.target->print) {
+			printf("#");
+			stmt->xt.target->print(NULL, stmt->xt.target->t, 0);
+		}
+		break;
+	default:
+		break;
+	}
+
+	xt_xlate_free(xl);
+}
+
+void xt_stmt_release(const struct stmt *stmt)
+{
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		if (!stmt->xt.match)
+			break;
+		if (stmt->xt.match->m)
+			xfree(stmt->xt.match->m);
+		xfree(stmt->xt.match);
+		break;
+	case NFT_XT_WATCHER:
+	case NFT_XT_TARGET:
+		if (!stmt->xt.target)
+			break;
+		if (stmt->xt.target->t)
+			xfree(stmt->xt.target->t);
+		xfree(stmt->xt.target);
+		break;
+	default:
+		break;
+	}
+	xfree(stmt->xt.entry);
+}
+
 static void *xt_entry_alloc(struct xt_stmt *xt, uint32_t af)
 {
 	union nft_entry {
@@ -143,7 +215,7 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
 	m->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_MT_REV);
 
-	stmt = stmt_alloc(loc, NULL);
+	stmt = xt_stmt_alloc(loc);
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_MATCH;
 	stmt->xt.match = xt_match_clone(mt);
@@ -180,7 +252,7 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
 	t->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_TG_REV);
 	strcpy(t->u.user.name, tg->name);
 
-	stmt = stmt_alloc(loc, NULL);
+	stmt = xt_stmt_alloc(loc);
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_TARGET;
 	stmt->xt.target = xt_target_clone(tg);
-- 
2.11.0

