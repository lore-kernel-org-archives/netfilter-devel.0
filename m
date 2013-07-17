From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 2/2] nft: Fix code style issues
Date: Wed, 17 Jul 2013 10:34:15 +0300
Message-ID: <1374046455-19234-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13723 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab3GQHeY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:34:24 -0400
In-Reply-To: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 88 +++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 32 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f33faa5..1004ec8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -485,7 +485,8 @@ static void nft_chain_print_debug(struct nft_chain *c, struct nlmsghdr *nlh)
 
 	nft_chain_snprintf(tmp, sizeof(tmp), c, 0, 0);
 	printf("DEBUG: chain: %s", tmp);
-	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
+	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len,
+						sizeof(struct nfgenmsg));
 #endif
 }
 
@@ -560,7 +561,8 @@ static int __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
 {
 	void *info;
 
-	nft_rule_expr_set(e, NFT_EXPR_MT_NAME, m->u.user.name, strlen(m->u.user.name));
+	nft_rule_expr_set(e, NFT_EXPR_MT_NAME, m->u.user.name,
+						strlen(m->u.user.name));
 	nft_rule_expr_set_u32(e, NFT_EXPR_MT_REV, m->u.user.revision);
 
 	info = calloc(1, m->u.match_size);
@@ -568,7 +570,8 @@ static int __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
 		return -ENOMEM;
 
 	memcpy(info, m->data, m->u.match_size);
-	nft_rule_expr_set(e, NFT_EXPR_MT_INFO, info, m->u.match_size - sizeof(*m));
+	nft_rule_expr_set(e, NFT_EXPR_MT_INFO,
+					info, m->u.match_size - sizeof(*m));
 
 	return 0;
 }
@@ -604,7 +607,8 @@ static int __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
 		memcpy(info, t->data, t->u.target_size);
 	}
 
-	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info, t->u.target_size - sizeof(*t));
+	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info,
+						t->u.target_size - sizeof(*t));
 
 	return 0;
 }
@@ -662,7 +666,8 @@ static void nft_rule_print_debug(struct nft_rule *r, struct nlmsghdr *nlh)
 
 	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
 	printf("DEBUG: rule: %s", tmp);
-	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
+	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len,
+					sizeof(struct nfgenmsg));
 #endif
 }
 
@@ -996,7 +1001,8 @@ nft_print_counters(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 }
 
 void
-nft_rule_print_save(struct nft_rule *r, enum nft_rule_print type, bool counters)
+nft_rule_print_save(struct nft_rule *r, enum nft_rule_print type,
+		    bool counters)
 {
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
@@ -1115,8 +1121,8 @@ static void nft_chain_print_save(struct nft_chain *c, bool basechain)
 		if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_POLICY))
 			pol = nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
 
-		printf(":%s %s [%"PRIu64":%"PRIu64"]\n", chain, policy_name[pol],
-					     pkts, bytes);
+		printf(":%s %s [%"PRIu64":%"PRIu64"]\n",
+					chain, policy_name[pol], pkts, bytes);
 	} else
 		printf(":%s - [%"PRIu64":%"PRIu64"]\n", chain, pkts, bytes);
 }
@@ -1316,7 +1322,8 @@ err:
 	return ret == 0 ? 1 : 0;
 }
 
-int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table)
+int nft_chain_user_add(struct nft_handle *h,
+		       const char *chain, const char *table)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -1368,7 +1375,8 @@ static int __nft_chain_del(struct nft_handle *h, struct nft_chain *c)
 	return ret;
 }
 
-int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table)
+int nft_chain_user_del(struct nft_handle *h,
+		       const char *chain, const char *table)
 {
 	struct nft_chain_list *list;
 	struct nft_chain_list_iter *iter;
@@ -1594,7 +1602,9 @@ err:
 }
 
 int nft_for_each_table(struct nft_handle *h,
-		       int (*func)(struct nft_handle *h, const char *tablename, bool counters),
+		       int (*func)(struct nft_handle *h,
+			           const char *tablename,
+				   bool counters),
 		       bool counters)
 {
 	int ret = 1;
@@ -1641,9 +1651,8 @@ int nft_table_purge_chains(struct nft_handle *h, const char *this_table,
 
 	chain_obj = nft_chain_list_iter_next(iter);
 	while (chain_obj != NULL) {
-		const char *table =
-			nft_chain_attr_get_str(chain_obj, NFT_CHAIN_ATTR_TABLE);
-
+		const char *table = nft_chain_attr_get_str(chain_obj,
+							NFT_CHAIN_ATTR_TABLE);
 		if (strcmp(this_table, table) != 0)
 			goto next;
 
@@ -1819,7 +1828,8 @@ __find_match(struct nft_rule_expr *expr, struct xtables_rule_match *matches)
 			continue;
 		}
 
-		if (memcmp(data, m->data, m->u.user.match_size - sizeof(*m)) != 0) {
+		if (memcmp(data, m->data,
+				m->u.user.match_size - sizeof(*m)) != 0) {
 			DEBUGP("mismatch match data\n");
 			continue;
 		}
@@ -1830,7 +1840,8 @@ __find_match(struct nft_rule_expr *expr, struct xtables_rule_match *matches)
 	return found;
 }
 
-static bool find_matches(struct xtables_rule_match *matches, struct nft_rule *r)
+static bool
+find_matches(struct xtables_rule_match *matches, struct nft_rule *r)
 {
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
@@ -1862,7 +1873,8 @@ static bool find_matches(struct xtables_rule_match *matches, struct nft_rule *r)
 	return true;
 }
 
-static bool __find_target(struct nft_rule_expr *expr, struct xt_entry_target *t)
+static bool
+__find_target(struct nft_rule_expr *expr, struct xt_entry_target *t)
 {
 	size_t len;
 	const char *tgname = nft_rule_expr_get_str(expr, NFT_EXPR_TG_NAME);
@@ -1944,7 +1956,8 @@ find_immediate(struct nft_rule *r, const char *jumpto)
 			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
 
 		if (strcmp(name, "immediate") == 0) {
-			int verdict = nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_VERDICT);
+			int verdict = nft_rule_expr_get_u32(expr,
+							NFT_EXPR_IMM_VERDICT);
 			const char *verdict_name = NULL;
 
 			/* No target specified but immediate shows up, this
@@ -2189,8 +2202,8 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 						 NFT_RULE_F_COMMIT);
 		}
 		ret = nft_rule_add(h, chain, table, cs, true,
-				   nft_rule_attr_get_u64(r, NFT_RULE_ATTR_HANDLE),
-				   verbose);
+				nft_rule_attr_get_u64(r, NFT_RULE_ATTR_HANDLE),
+				verbose);
 	} else
 		errno = ENOENT;
 
@@ -2473,8 +2486,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		uint32_t refs =
 			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_USE);
 		struct xt_counters ctrs = {
-			.pcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
-			.bcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES),
+			.pcnt = nft_chain_attr_get_u64(c,
+						NFT_CHAIN_ATTR_PACKETS),
+			.bcnt = nft_chain_attr_get_u64(c,
+						NFT_CHAIN_ATTR_BYTES),
 		};
 		bool basechain = false;
 
@@ -2547,8 +2562,10 @@ nft_rule_list_chain_save(struct nft_handle *h, const char *table,
 
 			if (counters) {
 				printf(" -c %"PRIu64" %"PRIu64"\n",
-					nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
-					nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES));
+					nft_chain_attr_get_u64(c,
+						NFT_CHAIN_ATTR_PACKETS),
+					nft_chain_attr_get_u64(c,
+						NFT_CHAIN_ATTR_BYTES));
 			} else
 				printf("\n");
 		} else {
@@ -2796,11 +2813,13 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 			if (errno == EEXIST) {
 				xtables_config_perror(flags,
 					"table `%s' already exists, skipping\n",
-					(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME));
+					(char *)nft_table_attr_get(table,
+							NFT_TABLE_ATTR_NAME));
 			} else {
 				xtables_config_perror(flags,
 					"table `%s' cannot be create, reason `%s'. Exitting\n",
-					(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME),
+					(char *)nft_table_attr_get(table,
+							NFT_TABLE_ATTR_NAME),
 					strerror(errno));
 				nft_table_list_iter_destroy(titer);
 				nft_table_list_free(table_list);
@@ -2809,7 +2828,8 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 			continue;
 		}
 		xtables_config_perror(flags, "table `%s' has been created\n",
-			(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME));
+			(char *)nft_table_attr_get(table,
+							NFT_TABLE_ATTR_NAME));
 	}
 	nft_table_list_iter_destroy(titer);
 	nft_table_list_free(table_list);
@@ -2821,12 +2841,15 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 			if (errno == EEXIST) {
 				xtables_config_perror(flags,
 					"chain `%s' already exists in table `%s', skipping\n",
-					(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_NAME),
-					(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_TABLE));
+					(char *)nft_chain_attr_get(chain,
+							NFT_CHAIN_ATTR_NAME),
+					(char *)nft_chain_attr_get(chain,
+							NFT_CHAIN_ATTR_TABLE));
 			} else {
 				xtables_config_perror(flags,
 					"chain `%s' cannot be create, reason `%s'. Exitting\n",
-					(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_NAME),
+					(char *)nft_chain_attr_get(chain,
+							NFT_CHAIN_ATTR_NAME),
 					strerror(errno));
 				nft_chain_list_iter_destroy(citer);
 				nft_chain_list_free(chain_list);
@@ -2838,7 +2861,8 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 		xtables_config_perror(flags,
 			"chain `%s' in table `%s' has been created\n",
 			(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_NAME),
-			(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_TABLE));
+			(char *)nft_chain_attr_get(chain,
+							NFT_CHAIN_ATTR_TABLE));
 	}
 	nft_chain_list_iter_destroy(citer);
 	nft_chain_list_free(chain_list);
@@ -2846,7 +2870,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	return 0;
 }
 
-int nft_chain_zero_counters(struct nft_handle *h, const char *chain, 
+int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 			    const char *table)
 {
 	struct nft_chain_list *list;
-- 
1.8.2.1

