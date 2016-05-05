From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] libnftnl: allow any set name length
Date: Thu,  5 May 2016 14:14:19 +0200
Message-ID: <1462450459-14916-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37905 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbcEEMOb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 08:14:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F183A114826
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 14:14:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E0A75179E47
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 14:14:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C1BBA179E47
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 14:14:23 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Unfortunately libnftnl restricts the set names in the lookup and dynset
expressions to 16 bytes. Remove this restriction so this can work with
the upcoming 4.7 Linux kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/dynset.c | 20 ++++++++++++--------
 src/expr/lookup.c | 20 ++++++++++++--------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index ec8f2d3..e82b10b 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -22,17 +22,13 @@
 #include "expr_ops.h"
 #include <buffer.h>
 
-#ifndef IFNAMSIZ
-#define IFNAMSIZ	16
-#endif
-
 struct nftnl_expr_dynset {
 	enum nft_registers	sreg_key;
 	enum nft_registers	sreg_data;
 	enum nft_dynset_ops	op;
 	uint64_t		timeout;
 	struct nftnl_expr	*expr;
-	char			set_name[IFNAMSIZ];
+	char			*set_name;
 	uint32_t		set_id;
 };
 
@@ -56,8 +52,7 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
 		dynset->timeout = *((uint64_t *)data);
 		break;
 	case NFTNL_EXPR_DYNSET_SET_NAME:
-		snprintf(dynset->set_name, sizeof(dynset->set_name), "%s",
-			 (const char *)data);
+		dynset->set_name = strdup((const char *)data);
 		break;
 	case NFTNL_EXPR_DYNSET_SET_ID:
 		dynset->set_id = *((uint32_t *)data);
@@ -186,7 +181,8 @@ nftnl_expr_dynset_parse(struct nftnl_expr *e, struct nlattr *attr)
 		e->flags |= (1 << NFTNL_EXPR_DYNSET_TIMEOUT);
 	}
 	if (tb[NFTA_DYNSET_SET_NAME]) {
-		strcpy(dynset->set_name, mnl_attr_get_str(tb[NFTA_DYNSET_SET_NAME]));
+		dynset->set_name =
+			strdup(mnl_attr_get_str(tb[NFTA_DYNSET_SET_NAME]));
 		e->flags |= (1 << NFTNL_EXPR_DYNSET_SET_NAME);
 	}
 	if (tb[NFTA_DYNSET_SET_ID]) {
@@ -361,10 +357,18 @@ nftnl_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
 	return -1;
 }
 
+static void nftnl_expr_dynset_free(struct nftnl_expr *e)
+{
+	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
+
+	xfree(dynset->set_name);
+}
+
 struct expr_ops expr_ops_dynset = {
 	.name		= "dynset",
 	.alloc_len	= sizeof(struct nftnl_expr_dynset),
 	.max_attr	= NFTA_DYNSET_MAX,
+	.free		= nftnl_expr_dynset_free,
 	.set		= nftnl_expr_dynset_set,
 	.get		= nftnl_expr_dynset_get,
 	.parse		= nftnl_expr_dynset_parse,
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index d911cb6..b26d9e5 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -21,14 +21,10 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-#ifndef IFNAMSIZ
-#define IFNAMSIZ	16
-#endif
-
 struct nftnl_expr_lookup {
 	enum nft_registers	sreg;
 	enum nft_registers	dreg;
-	char			set_name[IFNAMSIZ];
+	char			*set_name;
 	uint32_t		set_id;
 };
 
@@ -46,8 +42,7 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t type,
 		lookup->dreg = *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_LOOKUP_SET:
-		snprintf(lookup->set_name, sizeof(lookup->set_name), "%s",
-			 (const char *)data);
+		lookup->set_name = strdup((const char *)data);
 		break;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
 		lookup->set_id = *((uint32_t *)data);
@@ -140,7 +135,8 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 		e->flags |= (1 << NFTNL_EXPR_LOOKUP_DREG);
 	}
 	if (tb[NFTA_LOOKUP_SET]) {
-		strcpy(lookup->set_name, mnl_attr_get_str(tb[NFTA_LOOKUP_SET]));
+		lookup->set_name =
+			strdup(mnl_attr_get_str(tb[NFTA_LOOKUP_SET]));
 		e->flags |= (1 << NFTNL_EXPR_LOOKUP_SET);
 	}
 	if (tb[NFTA_LOOKUP_SET_ID]) {
@@ -258,10 +254,18 @@ nftnl_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
 	return -1;
 }
 
+static void nftnl_expr_lookup_free(struct nftnl_expr *e)
+{
+	struct nftnl_expr_lookup *lookup = nftnl_expr_data(e);
+
+	xfree(lookup->set_name);
+}
+
 struct expr_ops expr_ops_lookup = {
 	.name		= "lookup",
 	.alloc_len	= sizeof(struct nftnl_expr_lookup),
 	.max_attr	= NFTA_LOOKUP_MAX,
+	.free		= nftnl_expr_lookup_free,
 	.set		= nftnl_expr_lookup_set,
 	.get		= nftnl_expr_lookup_get,
 	.parse		= nftnl_expr_lookup_parse,
-- 
2.1.4

