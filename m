From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] expr: seperate expression parsing and building functions
Date: Sun, 12 Apr 2015 20:35:08 +0100
Message-ID: <1428867310-18327-2-git-send-email-kaber@trash.net>
References: <1428867310-18327-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61766 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbDLTfS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 15:35:18 -0400
In-Reply-To: <1428867310-18327-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The expression build function currently assumes to be only used from
rule context and actually builds rule attributes. Fix that and only
build the expression. Also it seems to have been exported by accident,
undo that.

Additionally, move the expression parsing function from rule parsing
and also remove any assumptions about being used in rule context.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expr.h          |  6 ++++++
 include/libnftnl/expr.h |  4 ----
 src/expr.c              | 56 ++++++++++++++++++++++++++++++++++++++++++------
 src/libnftnl.map        |  1 -
 src/rule.c              | 57 ++++++++-----------------------------------------
 5 files changed, 65 insertions(+), 59 deletions(-)

diff --git a/include/expr.h b/include/expr.h
index ed41105..a4333c6 100644
--- a/include/expr.h
+++ b/include/expr.h
@@ -10,4 +10,10 @@ struct nft_rule_expr {
 	uint8_t			data[];
 };
 
+struct nlmsghdr;
+
+void nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr);
+struct nft_rule_expr *nft_rule_expr_parse(struct nlattr *attr);
+
+
 #endif
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 7bc0273..14daa83 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -36,10 +36,6 @@ uint32_t nft_rule_expr_get_u32(const struct nft_rule_expr *expr, uint16_t type);
 uint64_t nft_rule_expr_get_u64(const struct nft_rule_expr *expr, uint16_t type);
 const char *nft_rule_expr_get_str(const struct nft_rule_expr *expr, uint16_t type);
 
-struct nlmsghdr;
-
-void nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr);
-
 int nft_rule_expr_snprintf(char *buf, size_t buflen, struct nft_rule_expr *expr, uint32_t type, uint32_t flags);
 
 enum {
diff --git a/src/expr.c b/src/expr.c
index 79782fa..4109495 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -15,6 +15,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 #include <netinet/in.h>
 
 #include <libmnl/libmnl.h>
@@ -205,18 +206,61 @@ EXPORT_SYMBOL(nft_rule_expr_get_str);
 void
 nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr)
 {
-	struct nlattr *nest1, *nest2;
+	struct nlattr *nest;
 
-	nest1 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
 	mnl_attr_put_strz(nlh, NFTA_EXPR_NAME, expr->ops->name);
 
-	nest2 = mnl_attr_nest_start(nlh, NFTA_EXPR_DATA);
+	nest = mnl_attr_nest_start(nlh, NFTA_EXPR_DATA);
 	expr->ops->build(nlh, expr);
-	mnl_attr_nest_end(nlh, nest2);
+	mnl_attr_nest_end(nlh, nest);
+}
+
+static int nft_rule_parse_expr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_EXPR_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_EXPR_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	case NFTA_EXPR_DATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
 
-	mnl_attr_nest_end(nlh, nest1);
+struct nft_rule_expr *nft_rule_expr_parse(struct nlattr *attr)
+{
+	struct nlattr *tb[NFTA_EXPR_MAX+1] = {};
+	struct nft_rule_expr *expr;
+
+	if (mnl_attr_parse_nested(attr, nft_rule_parse_expr_cb, tb) < 0)
+		goto err1;
+
+	expr = nft_rule_expr_alloc(mnl_attr_get_str(tb[NFTA_EXPR_NAME]));
+	if (expr == NULL)
+		goto err1;
+
+	if (tb[NFTA_EXPR_DATA] &&
+	    expr->ops->parse(expr, tb[NFTA_EXPR_DATA]) < 0)
+		goto err2;
+
+	return expr;
+
+err2:
+	xfree(expr);
+err1:
+	return NULL;
 }
-EXPORT_SYMBOL(nft_rule_expr_build_payload);
 
 int nft_rule_expr_snprintf(char *buf, size_t size, struct nft_rule_expr *expr,
 			   uint32_t type, uint32_t flags)
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 01eba13..c2b9431 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -102,7 +102,6 @@ global:
   nft_rule_expr_get_u32;
   nft_rule_expr_get_u64;
   nft_rule_expr_get_str;
-  nft_rule_expr_build_payload;
   nft_rule_expr_snprintf;
   nft_rule_expr_free;
 
diff --git a/src/rule.c b/src/rule.c
index 3feb337..04088ed 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -277,7 +277,7 @@ EXPORT_SYMBOL(nft_rule_attr_get_u8);
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 {
 	struct nft_rule_expr *expr;
-	struct nlattr *nest;
+	struct nlattr *nest, *nest2;
 
 	if (r->flags & (1 << NFT_RULE_ATTR_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, r->table);
@@ -295,7 +295,9 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 	if (!list_empty(&r->expr_list)) {
 		nest = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
 		list_for_each_entry(expr, &r->expr_list, head) {
+			nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
 			nft_rule_expr_build_payload(nlh, expr);
+			mnl_attr_nest_end(nlh, nest2);
 		}
 		mnl_attr_nest_end(nlh, nest);
 	}
@@ -355,61 +357,20 @@ static int nft_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int nft_rule_parse_expr_cb(const struct nlattr *attr, void *data)
-{
-	const struct nlattr **tb = data;
-	int type = mnl_attr_get_type(attr);
-
-	if (mnl_attr_type_valid(attr, NFTA_EXPR_MAX) < 0)
-		return MNL_CB_OK;
-
-	switch(type) {
-	case NFTA_EXPR_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
-			abi_breakage();
-		break;
-	case NFTA_EXPR_DATA:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
-			abi_breakage();
-		break;
-	}
-
-	tb[type] = attr;
-	return MNL_CB_OK;
-}
-
-static int nft_rule_parse_expr2(struct nlattr *attr, struct nft_rule *r)
-{
-	struct nlattr *tb[NFTA_EXPR_MAX+1] = {};
-	struct nft_rule_expr *expr;
-
-	if (mnl_attr_parse_nested(attr, nft_rule_parse_expr_cb, tb) < 0)
-		return -1;
-
-	expr = nft_rule_expr_alloc(mnl_attr_get_str(tb[NFTA_EXPR_NAME]));
-	if (expr == NULL)
-		return -1;
-
-	if (tb[NFTA_EXPR_DATA]) {
-		if (expr->ops->parse(expr, tb[NFTA_EXPR_DATA]) < 0) {
-			xfree(expr);
-			return -1;
-		}
-	}
-	list_add_tail(&expr->head, &r->expr_list);
-
-	return 0;
-}
-
 static int nft_rule_parse_expr(struct nlattr *nest, struct nft_rule *r)
 {
+	struct nft_rule_expr *expr;
 	struct nlattr *attr;
 
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) != NFTA_LIST_ELEM)
 			return -1;
 
-		nft_rule_parse_expr2(attr, r);
+		expr = nft_rule_expr_parse(attr);
+		if (expr == NULL)
+			return -1;
+
+		list_add_tail(&expr->head, &r->expr_list);
 	}
 	return 0;
 }
-- 
2.1.0

