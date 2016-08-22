From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables v2 1/2] xtables-compat: check if nft ruleset is compatible
Date: Mon, 22 Aug 2016 17:11:18 +0200
Message-ID: <20160822151119.16165-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36734 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752142AbcHVPMp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 11:12:45 -0400
Received: by mail-wm0-f65.google.com with SMTP id i138so13898226wmf.3
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 08:11:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a verification of the compatibility between the nft
ruleset and iptables. Nft tables, chains and rules are checked to be
compatible with iptables. If something is not compatible, the execution
stops and an error message is displayed to the user.

This checking is triggered by xtables-compat -L and xtables-compat-save
commands.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/nft.c          | 192 ++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft.h          |   2 +
 iptables/xtables-save.c |   5 ++
 iptables/xtables.c      |   5 ++
 4 files changed, 204 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 247a60a..8a06283 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2698,3 +2698,195 @@ uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag)
 
 	return NFT_CMP_EQ;
 }
+
+#define NFT_COMPAT_EXPR_MAX     8
+
+static const char *supported_exprs[NFT_COMPAT_EXPR_MAX] = {
+	"match",
+	"target",
+	"payload",
+	"meta",
+	"cmp",
+	"bitwise",
+	"counter",
+	"immediate"
+};
+
+
+static int nft_is_expr_compatible(const char *name)
+{
+	int i;
+
+	for (i = 0; i < NFT_COMPAT_EXPR_MAX; i++) {
+		if (strcmp(supported_exprs[i], name) == 0)
+			return 0;
+	}
+
+	return 1;
+}
+
+static int nft_is_rule_compatible(struct nftnl_rule *rule)
+{
+	struct nftnl_expr_iter *iter;
+	struct nftnl_expr *expr;
+
+	iter = nftnl_expr_iter_create(rule);
+	if (iter == NULL)
+		return -1;
+
+	expr = nftnl_expr_iter_next(iter);
+	while (expr != NULL) {
+		const char *name = nftnl_expr_get_str(expr, NFTNL_EXPR_NAME);
+
+		if (nft_is_expr_compatible(name) == 0) {
+			expr = nftnl_expr_iter_next(iter);
+		} else {
+			nftnl_expr_iter_destroy(iter);
+			return 1;
+		}
+	}
+
+	nftnl_expr_iter_destroy(iter);
+	return 0;
+}
+
+static int nft_is_chain_compatible(const char *table, const char *chain)
+{
+	const char *cur_table;
+	struct builtin_chain *chains;
+	int i, j;
+
+	for (i = 0; i < TABLES_MAX; i++) {
+		cur_table = xtables_ipv4[i].name;
+		chains = xtables_ipv4[i].chains;
+		if (strcmp(table, cur_table) == 0) {
+			for (j = 0; j < NF_INET_NUMHOOKS && chains[j].name; j++) {
+				if (strcmp(chain, chains[j].name) == 0)
+					return 0;
+			}
+		}
+	}
+
+	return 1;
+}
+
+static int nft_are_chains_compatible(struct nft_handle *h)
+{
+	struct nftnl_chain_list *list;
+	struct nftnl_chain_list_iter *iter;
+	struct nftnl_chain *chain;
+
+	list = nftnl_chain_list_get(h);
+	if (list == NULL)
+		return -1;
+
+	iter = nftnl_chain_list_iter_create(list);
+	if (iter == NULL)
+		return -1;
+
+	chain = nftnl_chain_list_iter_next(iter);
+	while (chain != NULL) {
+		if (nft_chain_builtin(chain)) {
+			const char *table = nftnl_chain_get(chain,
+							    NFTNL_CHAIN_TABLE);
+			const char *name = nftnl_chain_get(chain,
+							   NFTNL_CHAIN_NAME);
+
+			if (nft_is_chain_compatible(table, name) == 1) {
+				nftnl_chain_list_iter_destroy(iter);
+				nftnl_chain_list_free(list);
+				return 1;
+			}
+		}
+
+		chain = nftnl_chain_list_iter_next(iter);
+	}
+
+	nftnl_chain_list_iter_destroy(iter);
+	nftnl_chain_list_free(list);
+	return 0;
+}
+
+static int nft_is_table_compatible(const char *name)
+{
+	int i;
+
+	for (i = 0; i < TABLES_MAX; i++) {
+		if (strcmp(xtables_ipv4[i].name, name) == 0)
+			return 0;
+	}
+
+	return 1;
+}
+
+static int nft_are_tables_compatible(struct nft_handle *h)
+{
+	struct nftnl_table_list *list;
+	struct nftnl_table_list_iter *iter;
+	struct nftnl_table *table;
+
+	list = nftnl_table_list_get(h);
+	if (list == NULL)
+		return -1;
+
+	iter = nftnl_table_list_iter_create(list);
+	if (iter == NULL)
+		return -1;
+
+	table = nftnl_table_list_iter_next(iter);
+	while (table != NULL) {
+		const char *name = nftnl_table_get(table, NFTNL_TABLE_NAME);
+
+		if (nft_is_table_compatible(name) == 0) {
+			table = nftnl_table_list_iter_next(iter);
+		} else {
+			nftnl_table_list_iter_destroy(iter);
+			nftnl_table_list_free(list);
+			return 1;
+		}
+
+	}
+
+	nftnl_table_list_iter_destroy(iter);
+	nftnl_table_list_free(list);
+	return 0;
+}
+
+int nft_is_ruleset_compatible(struct nft_handle *h)
+{
+
+	struct nftnl_rule_list *list;
+	struct nftnl_rule_list_iter *iter;
+	struct nftnl_rule *rule;
+	int ret;
+
+	ret = nft_are_tables_compatible(h);
+	if (ret != 0)
+		return ret;
+
+	ret = nft_are_chains_compatible(h);
+	if (ret != 0)
+		return ret;
+
+	list = nft_rule_list_get(h);
+	if (list == NULL)
+		return -1;
+
+	iter = nftnl_rule_list_iter_create(list);
+	if (iter == NULL)
+		return -1;
+
+	rule = nftnl_rule_list_iter_next(iter);
+	while (rule != NULL) {
+		ret = nft_is_rule_compatible(rule);
+		if (ret != 0) {
+			nftnl_rule_list_iter_destroy(iter);
+			return ret;
+		}
+
+		rule = nftnl_rule_list_iter_next(iter);
+	}
+
+	nftnl_rule_list_iter_destroy(iter);
+	return 0;
+}
diff --git a/iptables/nft.h b/iptables/nft.h
index bcabf42..f5449db 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -181,4 +181,6 @@ int nft_arp_rule_insert(struct nft_handle *h, const char *chain,
 
 void nft_rule_to_arpt_entry(struct nftnl_rule *r, struct arpt_entry *fw);
 
+int nft_is_ruleset_compatible(struct nft_handle *h);
+
 #endif
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 50b5b5a..e617794 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -138,6 +138,11 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 
+	if (nft_is_ruleset_compatible(&h) == 1) {
+		printf("ERROR: You're using features from nft that we cannot map to iptables, please keep using nft.\n\n");
+		exit(EXIT_FAILURE);
+	}
+
 	if (dump) {
 		do_output(&h, tablename, show_counters);
 		exit(0);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 48b9c51..098beb9 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1253,6 +1253,11 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 	case CMD_LIST|CMD_ZERO_NUM:
+		if (nft_is_ruleset_compatible(h) == 1) {
+			printf("ERROR: You're using features from nft that we cannot map to iptables, please keep using nft.\n\n");
+			exit(EXIT_FAILURE);
+		}
+
 		ret = list_entries(h, p.chain, p.table, p.rulenum,
 				   cs.options & OPT_VERBOSE,
 				   cs.options & OPT_NUMERIC,
-- 
2.9.3

