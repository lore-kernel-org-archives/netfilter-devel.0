From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft 4/6] set_elem: parse expressions attached to set elements
Date: Fri,  6 Nov 2015 18:34:21 +0000
Message-ID: <1446834863-18610-5-git-send-email-kaber@trash.net>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47974 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095AbbKFSe3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:34:29 -0500
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to parse and print expressions attached to set elements. This
is required for the flow statement, where expressions are dynamically
instantiated and attached to set elements.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/netlink.h                   |  3 +++
 src/expression.c                    |  6 ++++++
 src/netlink.c                       |  2 ++
 src/netlink_delinearize.c           | 12 ++++++++++++
 6 files changed, 26 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 010cb95..e7f11eb 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -237,6 +237,7 @@ struct expr {
 			uint64_t		timeout;
 			uint64_t		expiration;
 			const char		*comment;
+			struct stmt		*stmt;
 		};
 		struct {
 			/* EXPR_UNARY */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 5ebe3d8..38ad174 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -321,6 +321,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
+ * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -330,6 +331,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_TIMEOUT,
 	NFTA_SET_ELEM_EXPIRATION,
 	NFTA_SET_ELEM_USERDATA,
+	NFTA_SET_ELEM_EXPR,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/include/netlink.h b/include/netlink.h
index c1def09..018a573 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -149,6 +149,9 @@ extern int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle
 extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc, struct set *set);
 
+extern struct stmt *netlink_parse_set_expr(struct set *set,
+					   struct nftnl_expr *nle);
+
 extern void netlink_dump_table(struct nftnl_table *nlt);
 extern void netlink_dump_chain(struct nftnl_chain *nlc);
 extern void netlink_dump_rule(struct nftnl_rule *nlr);
diff --git a/src/expression.c b/src/expression.c
index ab195e5..2c1ea6a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -16,6 +16,7 @@
 #include <limits.h>
 
 #include <expression.h>
+#include <statement.h>
 #include <datatype.h>
 #include <rule.h>
 #include <gmputil.h>
@@ -899,6 +900,11 @@ static void set_elem_expr_print(const struct expr *expr)
 	}
 	if (expr->comment)
 		printf(" comment \"%s\"", expr->comment);
+
+	if (expr->stmt) {
+		printf(" : ");
+		stmt_print(expr->stmt);
+	}
 }
 
 static void set_elem_expr_destroy(struct expr *expr)
diff --git a/src/netlink.c b/src/netlink.c
index ad86084..3bef5f4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1472,6 +1472,8 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		expr->comment = xmalloc(len);
 		memcpy((char *)expr->comment, data, len);
 	}
+	if (nftnl_set_elem_is_set(nlse, NFT_SET_ELEM_ATTR_EXPR))
+		expr->stmt = netlink_parse_set_expr(set, (void *)nftnl_set_elem_get(nlse, NFT_SET_ELEM_ATTR_EXPR, NULL));
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 97ac3ec..adeaccb 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -924,6 +924,18 @@ static int netlink_parse_rule_expr(struct nftnl_expr *nle, void *arg)
 	return 0;
 }
 
+struct stmt *netlink_parse_set_expr(struct set *set, struct nftnl_expr *nle)
+{
+	struct netlink_parse_ctx ctx, *pctx = &ctx;
+
+	pctx->table = table_lookup(&set->handle);
+	assert(pctx->table != NULL);
+
+	if (netlink_parse_expr(nle, pctx) < 0)
+		return NULL;
+	return pctx->stmt;
+}
+
 struct rule_pp_ctx {
 	struct proto_ctx	pctx;
 	enum proto_bases	pbase;
-- 
2.4.3

