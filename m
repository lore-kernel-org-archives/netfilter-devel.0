From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] xml: expr: fix public interface for parsing XML
Date: Fri, 26 Jul 2013 14:00:31 +0200
Message-ID: <20130726120031.4081.51723.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35059 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752425Ab3GZMAl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:00:41 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 3553C51EE9B
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 12:00:39 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BIsVcCSb9c1s for <netfilter-devel@vger.kernel.org>;
	Fri, 26 Jul 2013 14:00:34 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id E3FC051EEAA
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 14:00:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a public interface for parsing expr XML.
Before this patch, that operation was not possible.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftables/expr.h |    3 +++
 src/expr.c                 |   41 +++++++++++++++++++++++++++++++++++++++++
 src/libnftables.map        |    1 +
 3 files changed, 45 insertions(+)

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 02f38d0..31946b3 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -8,6 +8,8 @@
 extern "C" {
 #endif
 
+#include <libnftables/rule.h>
+
 struct nft_rule_expr;
 
 enum {
@@ -35,6 +37,7 @@ struct nlmsghdr;
 
 void nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr);
 
+int nft_rule_expr_parse(struct nft_rule_expr *expr, enum nft_rule_parse_type type, const char *data);
 int nft_rule_expr_snprintf(char *buf, size_t buflen, struct nft_rule_expr *expr, uint32_t type, uint32_t flags);
 
 enum {
diff --git a/src/expr.c b/src/expr.c
index 84fd64b..5c5af62 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -195,6 +195,47 @@ nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr)
 }
 EXPORT_SYMBOL(nft_rule_expr_build_payload);
 
+static int nft_rule_expr_parse_xml(struct nft_rule_expr *expr, const char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree;
+
+	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree == NULL)
+		goto einval;
+
+	if (strcmp(tree->value.opaque, "expr") != 0) {
+		mxmlDelete(tree);
+		goto einval;
+	}
+
+	expr = nft_mxml_expr_parse(tree);
+	if (expr == NULL)
+		return -1;
+
+	return 0;
+
+einval:
+	errno = EINVAL;
+	return -1;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_rule_expr_parse(struct nft_rule_expr *expr, enum nft_rule_parse_type type, const char *data)
+{
+	switch (type) {
+	case NFT_RULE_PARSE_XML:
+		return nft_rule_expr_parse_xml(expr, data);
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+}
+EXPORT_SYMBOL(nft_rule_expr_parse);
+
 int nft_rule_expr_snprintf(char *buf, size_t size, struct nft_rule_expr *expr,
 			   uint32_t type, uint32_t flags)
 {
diff --git a/src/libnftables.map b/src/libnftables.map
index 614c705..16d8c05 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -93,6 +93,7 @@ global:
   nft_rule_expr_get_u64;
   nft_rule_expr_get_str;
   nft_rule_expr_build_payload;
+  nft_rule_expr_parse;
   nft_rule_expr_snprintf;
   nft_rule_expr_free;
 

