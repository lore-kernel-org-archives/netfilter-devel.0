From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: nf_tables: enforce NLA_NUL_STRING in strings
Date: Mon, 31 Mar 2014 13:51:31 +0200
Message-ID: <1396266691-3538-3-git-send-email-pablo@netfilter.org>
References: <1396266691-3538-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55736 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbaCaLvs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:51:48 -0400
In-Reply-To: <1396266691-3538-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nla_strcmp compares the string length plus one, so it's implicitly
including the nul-termination in the comparison.

 int nla_strcmp(const struct nlattr *nla, const char *str)
 {
        int len = strlen(str) + 1;
        ...
		d = memcmp(nla_data(nla), str, len);

However, if NLA_STRING is used, userspace can send us a string without
the null-termination. This is a problem since the nf_tables lookup
functions won't find any matching as the last byte may mismatch.
So we have to enforce that strings are nul-termination to avoid
mismatches.

The userspace library libnftnl always appends the nul-termination
to all strings that are sent to the kernel, that's why this bug didn't
manifest in userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   26 +++++++++++++-------------
 net/netfilter/nf_tables_api.c            |   22 +++++++++++-----------
 net/netfilter/nft_log.c                  |    2 +-
 net/netfilter/nft_lookup.c               |    2 +-
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c88ccbf..564a5ac 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -109,7 +109,7 @@ enum nft_table_flags {
 /**
  * enum nft_table_attributes - nf_tables table netlink attributes
  *
- * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
+ * @NFTA_TABLE_NAME: name of the table (NLA_NUL_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
  */
@@ -125,9 +125,9 @@ enum nft_table_attributes {
 /**
  * enum nft_chain_attributes - nf_tables chain netlink attributes
  *
- * @NFTA_CHAIN_TABLE: name of the table containing the chain (NLA_STRING)
+ * @NFTA_CHAIN_TABLE: name of the table containing the chain (NLA_NUL_STRING)
  * @NFTA_CHAIN_HANDLE: numeric handle of the chain (NLA_U64)
- * @NFTA_CHAIN_NAME: name of the chain (NLA_STRING)
+ * @NFTA_CHAIN_NAME: name of the chain (NLA_NUL_STRING)
  * @NFTA_CHAIN_HOOK: hook specification for basechains (NLA_NESTED: nft_hook_attributes)
  * @NFTA_CHAIN_POLICY: numeric policy of the chain (NLA_U32)
  * @NFTA_CHAIN_USE: number of references to this chain (NLA_U32)
@@ -151,8 +151,8 @@ enum nft_chain_attributes {
 /**
  * enum nft_rule_attributes - nf_tables rule netlink attributes
  *
- * @NFTA_RULE_TABLE: name of the table containing the rule (NLA_STRING)
- * @NFTA_RULE_CHAIN: name of the chain containing the rule (NLA_STRING)
+ * @NFTA_RULE_TABLE: name of the table containing the rule (NLA_NUL_STRING)
+ * @NFTA_RULE_CHAIN: name of the chain containing the rule (NLA_NUL_STRING)
  * @NFTA_RULE_HANDLE: numeric handle of the rule (NLA_U64)
  * @NFTA_RULE_EXPRESSIONS: list of expressions (NLA_NESTED: nft_expr_attributes)
  * @NFTA_RULE_COMPAT: compatibility specifications of the rule (NLA_NESTED: nft_rule_compat_attributes)
@@ -214,8 +214,8 @@ enum nft_set_flags {
 /**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
- * @NFTA_SET_TABLE: table name (NLA_STRING)
- * @NFTA_SET_NAME: set name (NLA_STRING)
+ * @NFTA_SET_TABLE: table name (NLA_NUL_STRING)
+ * @NFTA_SET_NAME: set name (NLA_NUL_STRING)
  * @NFTA_SET_FLAGS: bitmask of enum nft_set_flags (NLA_U32)
  * @NFTA_SET_KEY_TYPE: key data type, informational purpose only (NLA_U32)
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
@@ -263,8 +263,8 @@ enum nft_set_elem_attributes {
 /**
  * enum nft_set_elem_list_attributes - nf_tables set element list netlink attributes
  *
- * @NFTA_SET_ELEM_LIST_TABLE: table of the set to be changed (NLA_STRING)
- * @NFTA_SET_ELEM_LIST_SET: name of the set to be changed (NLA_STRING)
+ * @NFTA_SET_ELEM_LIST_TABLE: table of the set to be changed (NLA_NUL_STRING)
+ * @NFTA_SET_ELEM_LIST_SET: name of the set to be changed (NLA_NUL_STRING)
  * @NFTA_SET_ELEM_LIST_ELEMENTS: list of set elements (NLA_NESTED: nft_set_elem_attributes)
  */
 enum nft_set_elem_list_attributes {
@@ -315,7 +315,7 @@ enum nft_data_attributes {
  * enum nft_verdict_attributes - nf_tables verdict netlink attributes
  *
  * @NFTA_VERDICT_CODE: nf_tables verdict (NLA_U32: enum nft_verdicts)
- * @NFTA_VERDICT_CHAIN: jump target chain name (NLA_STRING)
+ * @NFTA_VERDICT_CHAIN: jump target chain name (NLA_NUL_STRING)
  */
 enum nft_verdict_attributes {
 	NFTA_VERDICT_UNSPEC,
@@ -328,7 +328,7 @@ enum nft_verdict_attributes {
 /**
  * enum nft_expr_attributes - nf_tables expression netlink attributes
  *
- * @NFTA_EXPR_NAME: name of the expression type (NLA_STRING)
+ * @NFTA_EXPR_NAME: name of the expression type (NLA_NUL_STRING)
  * @NFTA_EXPR_DATA: type specific data (NLA_NESTED)
  */
 enum nft_expr_attributes {
@@ -454,7 +454,7 @@ enum nft_cmp_attributes {
 /**
  * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
  *
- * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
+ * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_NUL_STRING)
  * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
  */
@@ -657,7 +657,7 @@ enum nft_counter_attributes {
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
  * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
- * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
+ * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_NUL_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
  * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
  */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3fd159d..8228622 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -164,7 +164,7 @@ nf_tables_chain_type_lookup(const struct nft_af_info *afi,
 }
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
-	[NFTA_TABLE_NAME]	= { .type = NLA_STRING },
+	[NFTA_TABLE_NAME]	= { .type = NLA_NUL_STRING },
 	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
 };
 
@@ -535,9 +535,9 @@ static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
 }
 
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
-	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING },
+	[NFTA_CHAIN_TABLE]	= { .type = NLA_NUL_STRING },
 	[NFTA_CHAIN_HANDLE]	= { .type = NLA_U64 },
-	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING,
+	[NFTA_CHAIN_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
@@ -1159,7 +1159,7 @@ static const struct nft_expr_type *nft_expr_type_get(u8 family,
 }
 
 static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
-	[NFTA_EXPR_NAME]	= { .type = NLA_STRING },
+	[NFTA_EXPR_NAME]	= { .type = NLA_NUL_STRING },
 	[NFTA_EXPR_DATA]	= { .type = NLA_NESTED },
 };
 
@@ -1289,8 +1289,8 @@ static struct nft_rule *nf_tables_rule_lookup(const struct nft_chain *chain,
 }
 
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
-	[NFTA_RULE_TABLE]	= { .type = NLA_STRING },
-	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
+	[NFTA_RULE_TABLE]	= { .type = NLA_NUL_STRING },
+	[NFTA_RULE_CHAIN]	= { .type = NLA_NUL_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
@@ -1945,8 +1945,8 @@ static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const
 }
 
 static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
-	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
-	[NFTA_SET_NAME]			= { .type = NLA_STRING,
+	[NFTA_SET_TABLE]		= { .type = NLA_NUL_STRING },
+	[NFTA_SET_NAME]			= { .type = NLA_NUL_STRING,
 					    .len = IFNAMSIZ - 1 },
 	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
@@ -2549,8 +2549,8 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
-	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING },
-	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_NUL_STRING },
+	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_NUL_STRING },
 	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
 };
 
@@ -3167,7 +3167,7 @@ EXPORT_SYMBOL_GPL(nft_validate_data_load);
 
 static const struct nla_policy nft_verdict_policy[NFTA_VERDICT_MAX + 1] = {
 	[NFTA_VERDICT_CODE]	= { .type = NLA_U32 },
-	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING,
+	[NFTA_VERDICT_CHAIN]	= { .type = NLA_NUL_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 };
 
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 10cfb15..047a1b0 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -38,7 +38,7 @@ static void nft_log_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_GROUP]	= { .type = NLA_U16 },
-	[NFTA_LOG_PREFIX]	= { .type = NLA_STRING },
+	[NFTA_LOG_PREFIX]	= { .type = NLA_NUL_STRING },
 	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U32 },
 	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U16 },
 };
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 7fd2bea..37f09cc 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -38,7 +38,7 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
-	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING },
+	[NFTA_LOOKUP_SET]	= { .type = NLA_NUL_STRING },
 	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
 };
-- 
1.7.10.4

