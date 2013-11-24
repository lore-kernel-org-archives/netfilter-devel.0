From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables 1/2] include: fix possible clash in ifdef namespace
Date: Mon, 25 Nov 2013 00:01:58 +0100
Message-ID: <1385334119-3857-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42155 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab3KXXCK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:02:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use _LIBNFTABLES_ prefix to avoid possible clash with headers that
are defined in other libraries that may be used by third party
applications.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftables/chain.h   |    6 +++---
 include/libnftables/common.h  |    4 ++--
 include/libnftables/expr.h    |    6 +++---
 include/libnftables/rule.h    |    6 +++---
 include/libnftables/ruleset.h |    6 +++---
 include/libnftables/set.h     |    6 +++---
 include/libnftables/table.h   |    6 +++---
 7 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 7dee88a..fff47d3 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -1,5 +1,5 @@
-#ifndef _CHAIN_H_
-#define _CHAIN_H_
+#ifndef _LIBNFTABLES_CHAIN_H_
+#define _LIBNFTABLES_CHAIN_H_
 
 #include <stdio.h>
 #include <stdint.h>
@@ -79,4 +79,4 @@ void nft_chain_list_iter_destroy(struct nft_chain_list_iter *iter);
 } /* extern "C" */
 #endif
 
-#endif /* _CHAIN_H_ */
+#endif /* _LIBNFTABLES_CHAIN_H_ */
diff --git a/include/libnftables/common.h b/include/libnftables/common.h
index d19a84b..2283d72 100644
--- a/include/libnftables/common.h
+++ b/include/libnftables/common.h
@@ -1,5 +1,5 @@
-#ifndef _COMMON_H_
-#define _COMMON_H_
+#ifndef _LIBNFTABLES_COMMON_H_
+#define _LIBNFTABLES_COMMON_H_
 
 enum nft_output_type {
 	NFT_OUTPUT_DEFAULT	= 0,
diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 81e224c..54de186 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -1,5 +1,5 @@
-#ifndef _RULE_EXPR_H_
-#define _RULE_EXPR_H_
+#ifndef _LIBNFTABLES_RULE_EXPR_H_
+#define _LIBNFTABLES_RULE_EXPR_H_
 
 #include <stdint.h>
 #include <stdbool.h>
@@ -147,4 +147,4 @@ enum {
 } /* extern "C" */
 #endif
 
-#endif
+#endif /* _LIBNFTABLES_RULE_EXPR_H_ */
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 4957a2a..d1d75e1 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -1,5 +1,5 @@
-#ifndef _RULE_H_
-#define _RULE_H_
+#ifndef _LIBNFTABLES_RULE_H_
+#define _LIBNFTABLES_RULE_H_
 
 #include <stdio.h>
 #include <stdint.h>
@@ -85,4 +85,4 @@ void nft_rule_list_iter_destroy(struct nft_rule_list_iter *iter);
 } /* extern "C" */
 #endif
 
-#endif /* _RULE_H_ */
+#endif /* _LIBNFTABLES_RULE_H_ */
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index 71ef3b1..1ec3059 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -1,5 +1,5 @@
-#ifndef _RULESET_H_
-#define _RULESET_H_
+#ifndef _LIBNFTABLES_RULESET_H_
+#define _LIBNFTABLES_RULESET_H_
 
 #include <stdio.h>
 
@@ -38,4 +38,4 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, u
 } /* extern "C" */
 #endif
 
-#endif /* _RULESET_H_ */
+#endif /* _LIBNFTABLES_RULESET_H_ */
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index d378049..d91bd42 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -1,5 +1,5 @@
-#ifndef _NFT_SET_H_
-#define _NFT_SET_H_
+#ifndef _LIBNFTABLES_SET_H_
+#define _LIBNFTABLES_SET_H_
 
 #include <stdio.h>
 #include <stdint.h>
@@ -110,4 +110,4 @@ struct nft_set_elem *nft_set_elems_iter_cur(struct nft_set_elems_iter *iter);
 struct nft_set_elem *nft_set_elems_iter_next(struct nft_set_elems_iter *iter);
 void nft_set_elems_iter_destroy(struct nft_set_elems_iter *iter);
 
-#endif
+#endif /* _LIBNFTABLES_SET_H_ */
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 9228cec..87481e4 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -1,5 +1,5 @@
-#ifndef _TABLE_H_
-#define _TABLE_H_
+#ifndef _LIBNFTABLES_TABLE_H_
+#define _LIBNFTABLES_TABLE_H_
 
 #include <stdio.h>
 #include <stdint.h>
@@ -67,4 +67,4 @@ void nft_table_list_iter_destroy(struct nft_table_list_iter *iter);
 } /* extern "C" */
 #endif
 
-#endif /* _TABLE_H_ */
+#endif /* _LIBNFTABLES_TABLE_H_ */
-- 
1.7.10.4

