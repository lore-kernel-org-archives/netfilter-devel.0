From: ana@soleta.eu
Subject: [nft 1/2] src: Add the accounter support
Date: Mon, 12 Jan 2015 11:55:53 +0100
Message-ID: <a553f6c679331f3203d180305c34e8aef0a3dada.1421059192.git.ana@soleta.eu>
References: <cover.1421059192.git.ana@soleta.eu>
Cc: Ana Rey <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:46822 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbALLED (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:04:03 -0500
In-Reply-To: <cover.1421059192.git.ana@soleta.eu>
In-Reply-To: <cover.1421059192.git.ana@soleta.eu>
References: <cover.1421059192.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey <ana@soleta.eu>

This adds userspace support to accounting objects and expresion.

Example of use in nft:
 # nft add acct ip filter http-traffic
 # nft add acct ip filter https-traffic
 # nft add rule ip filter output tcp dport 80 acct http-traffic
 # nft add rule ip filter output tcp dport 443 acct https-traffic
 # nft delete acct ip filter https-traffic

Generate Some traffic:

 # nft list table ip test

    table ip filter {
            acct http-traffic { pkts 779 bytes 99495}
            acct https-traffic { pkts 189 bytes 37824}

            chain output {
                     type filter hook output priority 0;
                     tcp dport http acct http-traffic
                     tcp dport https acct https-traffic
            }
    }

The kernel support is addedin the commit:
"netfilter: acct: add support to accounters in nftables"

The libnftnl support is add in the commit:
"src: Add accounters support"

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 include/linux/netfilter/nf_tables.h |   41 +++++++
 include/mnl.h                       |    8 ++
 include/netlink.h                   |   18 +++
 include/rule.h                      |   46 +++++++
 include/statement.h                 |    9 ++
 src/evaluate.c                      |   14 ++-
 src/mnl.c                           |  117 ++++++++++++++++++
 src/netlink.c                       |  231 +++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |   14 +++
 src/netlink_linearize.c             |   16 +++
 src/parser_bison.y                  |   72 ++++++++++-
 src/rule.c                          |  137 +++++++++++++++++++++
 src/scanner.l                       |    2 +
 src/statement.c                     |   16 +++
 14 files changed, 737 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 832bc46..5278e0a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -53,6 +53,10 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_NEWACCT: create a new account (enum nft_acct_attributes)
+ * @NFT_MSG_GETACCT: get a account (enum nft_acct_attributes)
+ * @NFT_MSG_GETACCT_ZERO: get a reset accounter (enum nft_acct_attributes)
+ * @NFT_MSG_DELACCT: delete a account (enum nft_acct_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -72,6 +76,10 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_NEWACCT,
+	NFT_MSG_GETACCT,
+	NFT_MSG_GETACCT_ZERO,
+	NFT_MSG_DELACCT,
 	NFT_MSG_MAX,
 };
 
@@ -867,4 +875,37 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/**
+ * enum nft_acct_attributes - nf_tables acct netlink attributes
+ *
+ * @NFTA_ACCT_NAME: name of the accounter (NLA_STRING)
+ * @NFTA_ACCT_TABLE: table name (NLA_STRING)
+ * @NFTA_ACCT_BYTES: number of bytes (NLA_U64)
+ * @NFTA_ACCT_PACKETS: number of packets (NLA_U64)
+ * @NFTA_ACCT_USE: number of rule in this accts (NLA_U32)
+ * @NFTA_ACCT_ID: uniquely identifies a acct in a transaction (NLA_U32)
+ */
+enum nft_acct_attributes {
+	NFTA_ACCT_UNSPEC,
+	NFTA_ACCT_NAME,
+	NFTA_ACCT_TABLE,
+	NFTA_ACCT_BYTES,
+	NFTA_ACCT_PACKETS,
+	NFTA_ACCT_USE,
+	NFTA_ACCT_ID,
+	__NFTA_ACCT_MAX
+};
+#define NFTA_ACCT_MAX		(__NFTA_ACCT_MAX - 1)
+
+enum nft_acct_expr_attr {
+	NFTA_ACCT_EXPR_UNSPEC,
+	NFTA_ACCT_EXPR_NAME,
+	__NFTA_ACCT_EXPR_MAX
+};
+#define NFTA_ACCT_EXPR_MAX        (__NFTA_ACCT_EXPR_MAX - 1)
+
+#ifndef NFTA_ACCT_NAME_MAX
+#define NFTA_ACCT_NAME_MAX	32
+#endif
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/include/mnl.h b/include/mnl.h
index a0dfa1b..c01e520 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -34,6 +34,14 @@ int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *r,
 struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 					int family);
 
+int mnl_nft_acct_batch_add(struct nft_acct *nlc,
+			   unsigned int flags, uint32_t seq);
+int mnl_nft_acct_batch_del(struct nft_acct *nlc,
+			   unsigned int flags, uint32_t seq);
+int mnl_nft_acct_get(struct mnl_socket *nf_sock, struct nft_acct *nlc);
+struct nft_acct_list *mnl_nft_acct_dump(struct mnl_socket *nf_sock,
+					int family, const char *table);
+
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 		      unsigned int flags);
 int mnl_nft_chain_batch_add(struct nft_chain *nlc,
diff --git a/include/netlink.h b/include/netlink.h
index 4f79470..7da9cf4 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -21,6 +21,7 @@ extern const struct location netlink_location;
  * @msgs:	message queue
  * @list:	list of parsed rules/chains/tables
  * @set:	current set
+ * @acct:	current acct
  * @data:	pointer to pass data to callback
  * @seqnum:	sequence number
  */
@@ -28,6 +29,7 @@ struct netlink_ctx {
 	struct list_head	*msgs;
 	struct list_head	list;
 	struct set		*set;
+	struct acct		*acct;
 	const void		*data;
 	uint32_t		seqnum;
 	bool			batch_supported;
@@ -38,6 +40,7 @@ extern struct nft_chain *alloc_nft_chain(const struct handle *h);
 extern struct nft_rule *alloc_nft_rule(const struct handle *h);
 extern struct nft_rule_expr *alloc_nft_expr(const char *name);
 extern struct nft_set *alloc_nft_set(const struct handle *h);
+extern struct nft_acct *alloc_nft_acct(const struct handle *h);
 
 struct nft_data_linearize {
 	uint32_t	len;
@@ -84,6 +87,20 @@ extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
 				  const struct handle *h,
 				  const struct location *loc);
 
+extern int netlink_add_acct(struct netlink_ctx *ctx, const struct handle *h,
+			    struct acct *acct);
+extern int netlink_rename_acct(struct netlink_ctx *ctx, const struct handle *h,
+			       const struct location *loc, const char *name);
+extern int netlink_delete_acct(struct netlink_ctx *ctx, const struct handle *h,
+			       const struct location *loc);
+extern int netlink_list_accts(struct netlink_ctx *ctx, const struct handle *h,
+			      const struct location *loc);
+extern int netlink_get_acct(struct netlink_ctx *ctx, const struct handle *h,
+			    const struct location *loc);
+extern int netlink_flush_acct(struct netlink_ctx *ctx, const struct handle *h,
+			      const struct location *loc);
+
+
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
 			     const struct chain *chain, bool excl);
@@ -135,6 +152,7 @@ extern void netlink_dump_chain(struct nft_chain *nlc);
 extern void netlink_dump_rule(struct nft_rule *nlr);
 extern void netlink_dump_expr(struct nft_rule_expr *nle);
 extern void netlink_dump_set(struct nft_set *nls);
+extern void netlink_dump_acct(struct nft_acct *nla);
 
 extern int netlink_batch_send(struct list_head *err_list);
 
diff --git a/include/rule.h b/include/rule.h
index 491411e..8a9e4fb 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -12,6 +12,7 @@
  * @table:	table name
  * @chain:	chain name (chains and rules only)
  * @set:	set name (sets only)
+ * @acct:	acct name (accts only)
  * @handle:	rule handle (rules only)
  * @position:	rule position (rules only)
  * @set_id:	set ID (sets only)
@@ -22,6 +23,7 @@ struct handle {
 	const char		*table;
 	const char		*chain;
 	const char		*set;
+	const char		*acct;
 	uint64_t		handle;
 	uint64_t		position;
 	uint32_t		set_id;
@@ -71,6 +73,7 @@ extern struct symbol *symbol_lookup(const struct scope *scope,
  * @location:	location the table was defined at
  * @chains:	chains contained in the table
  * @sets:	sets contained in the table
+ * @accts:	accts contained in the table
  */
 struct table {
 	struct list_head	list;
@@ -79,6 +82,7 @@ struct table {
 	struct scope		scope;
 	struct list_head	chains;
 	struct list_head	sets;
+	struct list_head	accts;
 };
 
 extern struct table *table_alloc(void);
@@ -211,6 +215,40 @@ extern void set_print(const struct set *set);
 extern void set_print_plain(const struct set *s);
 
 /**
+ * struct acct - nftables acct
+ *
+ * @list:	table acct list node
+ * @handle:	acct handle
+ * @location:	location the acct was defined/declared at
+ * @refcnt:	reference count
+ * @flags:	bitmask of acct flags
+ * @bytes:	Total bytes
+ * @packets:	Total packets
+
+ */
+struct acct {
+	struct list_head	list;
+	struct handle		handle;
+	struct location		location;
+	unsigned int		refcnt;
+	uint32_t		flags;
+	uint64_t		bytes;
+	uint64_t		packets;
+};
+
+extern struct acct *acct_alloc(const struct location *loc);
+extern struct acct *acct_get(struct acct *acct);
+extern void acct_free(struct acct *acct);
+extern struct acct *acct_clone(const struct acct *acct);
+extern void acct_add_hash(struct acct *acct, struct table *table);
+extern struct acct *acct_lookup(const struct table *table, const char *name);
+extern struct acct *acct_lookup_global(uint32_t family, const char *table,
+				       const char *name);
+extern void acct_print(const struct acct *acct);
+
+
+
+/**
  * enum cmd_ops - command operations
  *
  * @CMD_INVALID:	invalid
@@ -253,6 +291,8 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_ACCT:	acct
+ * @CMD_OBJ_ACCTS:	accts
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -266,6 +306,8 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_ACCT,
+	CMD_OBJ_ACCTS,
 };
 
 struct export {
@@ -282,6 +324,7 @@ enum {
 	CMD_MONITOR_OBJ_RULES,
 	CMD_MONITOR_OBJ_SETS,
 	CMD_MONITOR_OBJ_ELEMS,
+	CMD_MONITOR_OBJ_ACCTS,
 	CMD_MONITOR_OBJ_MAX
 };
 
@@ -320,6 +363,7 @@ struct cmd {
 		void		*data;
 		struct expr	*expr;
 		struct set	*set;
+		struct acct	*acct;
 		struct rule	*rule;
 		struct chain	*chain;
 		struct table	*table;
@@ -345,6 +389,7 @@ extern void cmd_free(struct cmd *cmd);
  * @table:	current table
  * @rule:	current rule
  * @set:	current set
+ * @acct:	current acct
  * @stmt:	current statement
  * @ectx:	expression context
  * @pctx:	payload context
@@ -355,6 +400,7 @@ struct eval_ctx {
 	struct table		*table;
 	struct rule		*rule;
 	struct set		*set;
+	struct acct		*acct;
 	struct stmt		*stmt;
 	struct expr_ctx		ectx;
 	struct proto_ctx	pctx;
diff --git a/include/statement.h b/include/statement.h
index d143121..53c8394 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -10,6 +10,12 @@ extern struct stmt *expr_stmt_alloc(const struct location *loc,
 extern struct stmt *verdict_stmt_alloc(const struct location *loc,
 				       struct expr *expr);
 
+struct acct_stmt {
+	const char		*name;
+};
+
+extern struct stmt *acct_stmt_alloc(const struct location *loc);
+
 struct counter_stmt {
 	uint64_t		packets;
 	uint64_t		bytes;
@@ -110,6 +116,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
  * @STMT_INVALID:	uninitialised
  * @STMT_EXPRESSION:	expression statement (relational)
  * @STMT_VERDICT:	verdict statement
+ * @STMT_ACCT:		accts
  * @STMT_COUNTER:	counters
  * @STMT_META:		meta statement
  * @STMT_LIMIT:		limit statement
@@ -125,6 +132,7 @@ enum stmt_types {
 	STMT_INVALID,
 	STMT_EXPRESSION,
 	STMT_VERDICT,
+	STMT_ACCT,
 	STMT_COUNTER,
 	STMT_META,
 	STMT_LIMIT,
@@ -174,6 +182,7 @@ struct stmt {
 
 	union {
 		struct expr		*expr;
+		struct acct_stmt	acct;
 		struct counter_stmt	counter;
 		struct meta_stmt	meta;
 		struct log_stmt		log;
diff --git a/src/evaluate.c b/src/evaluate.c
index d24d4cc..75f007a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1650,6 +1650,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 #endif
 
 	switch (stmt->ops->type) {
+	case STMT_ACCT:
 	case STMT_COUNTER:
 	case STMT_LIMIT:
 		return 0;
@@ -1824,6 +1825,7 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 		if (set_evaluate(ctx, set) < 0)
 			return -1;
 	}
+
 	list_for_each_entry(chain, &table->chains, list) {
 		handle_merge(&chain->handle, &table->handle);
 		if (chain_evaluate(ctx, chain) < 0)
@@ -1844,6 +1846,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
+	case CMD_OBJ_ACCT:
+		return 0;
 	case CMD_OBJ_CHAIN:
 		if (cmd->data == NULL)
 			return 0;
@@ -1863,6 +1867,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SETELEM:
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
+	case CMD_OBJ_ACCT:
 	case CMD_OBJ_RULE:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
@@ -1892,13 +1897,16 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_DELSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_NEWSETELEM) |
 						  (1 << NFT_MSG_DELSETELEM),
+		[CMD_MONITOR_OBJ_ACCTS]	= (1 << NFT_MSG_NEWACCT) |
+						  (1 << NFT_MSG_DELACCT),
 	},
 	[CMD_MONITOR_EVENT_NEW] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_NEWTABLE) |
 						  (1 << NFT_MSG_NEWCHAIN) |
 						  (1 << NFT_MSG_NEWRULE)  |
 						  (1 << NFT_MSG_NEWSET)   |
-						  (1 << NFT_MSG_NEWSETELEM),
+						  (1 << NFT_MSG_NEWSETELEM)|
+						  (1 << NFT_MSG_NEWACCT),
 		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_NEWTABLE),
 		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_NEWCHAIN),
 		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_NEWRULE),
@@ -1910,12 +1918,14 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_DELCHAIN) |
 						  (1 << NFT_MSG_DELRULE)  |
 						  (1 << NFT_MSG_DELSET)   |
-						  (1 << NFT_MSG_DELSETELEM),
+						  (1 << NFT_MSG_DELSETELEM)|
+						  (1 << NFT_MSG_DELACCT),
 		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_DELTABLE),
 		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_DELCHAIN),
 		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_DELRULE),
 		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_DELSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_DELSETELEM),
+		[CMD_MONITOR_OBJ_ACCTS]	= (1 << NFT_MSG_DELACCT),
 	},
 };
 
diff --git a/src/mnl.c b/src/mnl.c
index f48ead5..fc8ef41 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -16,6 +16,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/acct.h>
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -711,6 +712,122 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 }
 
 /*
+ * Acct
+ */
+int mnl_nft_acct_batch_add(struct nft_acct *nls, unsigned int flags,
+			  uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_acct_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+			NFT_MSG_NEWACCT,
+			nft_acct_attr_get_u32(nls, NFT_ACCT_ATTR_FAMILY),
+			NLM_F_CREATE | flags, seqnum);
+	nft_acct_nlmsg_build_payload(nlh, nls);
+	nft_batch_continue();
+
+	return 0;
+}
+
+int mnl_nft_acct_batch_del(struct nft_acct *nls, unsigned int flags,
+			  uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_acct_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+			NFT_MSG_DELACCT,
+			nft_acct_attr_get_u32(nls, NFT_ACCT_ATTR_FAMILY),
+			flags, seqnum);
+	nft_acct_nlmsg_build_payload(nlh, nls);
+	nft_batch_continue();
+
+	return 0;
+}
+
+static int acct_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_acct_list *nla_list = data;
+	struct nft_acct *acct;
+
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
+	acct = nft_acct_alloc();
+	if (acct == NULL)
+		memory_allocation_error();
+
+	if (nft_acct_nlmsg_parse(nlh, acct) < 0)
+		goto err_free;
+	nft_acct_list_add_tail(acct, nla_list);
+
+	return MNL_CB_OK;
+
+err_free:
+	nft_acct_free(acct);
+	return MNL_CB_OK;
+}
+
+static int acct_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_acct *a = data;
+
+	nft_acct_nlmsg_parse(nlh, a);
+
+	return MNL_CB_OK;
+}
+
+int mnl_nft_acct_get(struct mnl_socket *nf_sock, struct nft_acct *acct)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_acct_nlmsg_build_hdr(buf, NFT_MSG_GETACCT,
+			nft_acct_attr_get_u32(acct, NFT_ACCT_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_acct_nlmsg_build_payload(nlh, acct);
+
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, acct_get_cb, acct);
+}
+
+struct nft_acct_list *mnl_nft_acct_dump(struct mnl_socket *nf_sock, int family,
+					const char *table)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_acct *acct;
+	struct nft_acct_list *nla_list;
+	int ret;
+
+	acct = nft_acct_alloc();
+	if (acct == NULL)
+		memory_allocation_error();
+
+	nlh = nft_acct_nlmsg_build_hdr(buf, NFT_MSG_GETACCT, family,
+				       NLM_F_DUMP|NLM_F_ACK, seq);
+	if (table != NULL)
+		nft_acct_attr_set_str(acct, NFT_ACCT_ATTR_TABLE, table);
+	nft_acct_nlmsg_build_payload(nlh, acct);
+	nft_acct_free(acct);
+
+	nla_list = nft_acct_list_alloc();
+	if (nla_list == NULL)
+		memory_allocation_error();
+
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, acct_cb, nla_list);
+
+	if (ret < 0)
+		goto err;
+
+	return nla_list;
+err:
+	printf("Error en mnl_nft_acct_dump\n");
+	nft_acct_list_free(nla_list);
+
+	return NULL;
+}
+
+
+/*
  * Set
  */
 static int set_add_cb(const struct nlmsghdr *nlh, void *data)
diff --git a/src/netlink.c b/src/netlink.c
index 84d9d27..33184c0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -21,6 +21,7 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/acct.h>
 #include <libnftnl/common.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -1434,6 +1435,174 @@ out:
 	return err;
 }
 
+static struct acct *netlink_delinearize_acct(struct netlink_ctx *ctx,
+					     struct nft_acct *nla)
+{
+	struct acct *acct;
+
+	acct = acct_alloc(&netlink_location);
+
+	if (acct == NULL)
+		return NULL;
+
+	acct->handle.family	=
+		 nft_acct_attr_get_u32(nla, NFT_ACCT_ATTR_FAMILY);
+	acct->handle.acct	=
+		 xstrdup(nft_acct_attr_get_str(nla, NFT_ACCT_ATTR_NAME));
+	acct->handle.table	=
+		 xstrdup(nft_acct_attr_get_str(nla, NFT_ACCT_ATTR_TABLE));
+	acct->flags	= nft_acct_attr_get_u32(nla, NFT_ACCT_ATTR_FLAGS);
+	acct->packets	= nft_acct_attr_get_u64(nla, NFT_ACCT_ATTR_PKTS);
+	acct->bytes	= nft_acct_attr_get_u64(nla, NFT_ACCT_ATTR_BYTES);
+
+	return acct;
+}
+
+static int list_acct_cb(struct nft_acct *nla, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+	struct acct *acct;
+
+	netlink_dump_acct(nla);
+	acct = netlink_delinearize_acct(ctx, nla);
+
+	if (acct == NULL)
+		return -1;
+
+	list_add_tail(&acct->list, &ctx->list);
+
+	return 0;
+}
+
+int netlink_list_accts(struct netlink_ctx *ctx, const struct handle *h,
+		       const struct location *loc)
+{
+	struct nft_acct_list *acct_cache;
+	int err;
+
+	acct_cache = mnl_nft_acct_dump(nf_sock, h->family, h->table);
+	if (acct_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
+		return netlink_io_error(ctx, loc,
+					"Could not receive accts from kernel: %s",
+					strerror(errno));
+	}
+
+	err = nft_acct_list_foreach(acct_cache, list_acct_cb, ctx);
+
+	nft_acct_list_free(acct_cache);
+
+	return err;
+}
+
+int netlink_get_acct(struct netlink_ctx *ctx, const struct handle *h,
+		     const struct location *loc)
+{
+	struct nft_acct *nla;
+	struct acct *acct;
+	int err;
+
+	nla = alloc_nft_acct(h);
+	netlink_dump_acct(nla);
+	err = mnl_nft_acct_get(nf_sock, nla);
+	if (err < 0) {
+		nft_acct_free(nla);
+		return netlink_io_error(ctx, loc,
+					"Could not receive acct from kernel: %s",
+					strerror(errno));
+	}
+
+	acct = netlink_delinearize_acct(ctx, nla);
+	if (acct == NULL) {
+		nft_acct_free(nla);
+		return -1;
+	}
+
+	list_add_tail(&acct->list, &ctx->list);
+
+	return err;
+}
+
+void netlink_dump_acct(struct nft_acct *nla)
+{
+#ifdef DEBUG
+	char buf[4096];
+
+	if (!(debug_level & DEBUG_NETLINK))
+		return;
+
+	nft_acct_snprintf(buf, sizeof(buf), nla, 0, 0);
+	fprintf(stdout, "%s\n", buf);
+#endif
+}
+
+struct nft_acct *alloc_nft_acct(const struct handle *h)
+{
+	struct nft_acct *nla;
+
+	nla = nft_acct_alloc();
+	if (nla == NULL)
+		memory_allocation_error();
+
+	nft_acct_attr_set_u32(nla, NFT_ACCT_ATTR_FAMILY, h->family);
+	nft_acct_attr_set_str(nla, NFT_ACCT_ATTR_TABLE, h->table);
+	if (h->acct != NULL)
+		nft_acct_attr_set_str(nla, NFT_ACCT_ATTR_NAME, h->acct);
+
+	return nla;
+}
+
+static int netlink_add_acct_batch(struct netlink_ctx *ctx,
+				  const struct handle *h, struct acct *acct)
+{
+	struct nft_acct *nla;
+	int err;
+
+	nla = alloc_nft_acct(h);
+
+	netlink_dump_acct(nla);
+
+	err = mnl_nft_acct_batch_add(nla, NLM_F_EXCL, ctx->seqnum);
+	if (err < 0) {
+		netlink_io_error(ctx, &acct->location, "Could not add acct: %s",
+				 strerror(errno));
+	}
+	nft_acct_free(nla);
+
+	return err;
+}
+
+int netlink_add_acct(struct netlink_ctx *ctx, const struct handle *h,
+		     struct acct *acct)
+{
+	return netlink_add_acct_batch(ctx, h, acct);
+}
+
+static int netlink_del_acct_batch(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct location *loc)
+{
+	struct nft_acct *nla;
+	int err;
+
+	nla = alloc_nft_acct(h);
+	err = mnl_nft_acct_batch_del(nla, 0, ctx->seqnum);
+	nft_acct_free(nla);
+
+	if (err < 0)
+		netlink_io_error(ctx, loc, "Could not delete acct: %s",
+				 strerror(errno));
+	return err;
+}
+
+int netlink_delete_acct(struct netlink_ctx *ctx, const struct handle *h,
+			const struct location *loc)
+{
+	return netlink_del_acct_batch(ctx, h, loc);
+}
+
 int netlink_batch_send(struct list_head *err_list)
 {
 	return mnl_batch_talk(nf_sock, err_list);
@@ -1515,6 +1684,19 @@ static struct nft_set *netlink_set_alloc(const struct nlmsghdr *nlh)
 	return nls;
 }
 
+static struct nft_acct *netlink_acct_alloc(const struct nlmsghdr *nlh)
+{
+	struct nft_acct *nla = nft_acct_alloc();
+
+	if (nla == NULL)
+		memory_allocation_error();
+
+	if (nft_acct_nlmsg_parse(nlh, nla) < 0)
+		netlink_abi_error();
+
+	return nla;
+}
+
 static struct nft_set *netlink_setelem_alloc(const struct nlmsghdr *nlh)
 {
 	struct nft_set *nls;
@@ -1549,12 +1731,14 @@ static uint32_t netlink_msg2nftnl_of(uint32_t msg)
 	case NFT_MSG_NEWSET:
 	case NFT_MSG_NEWSETELEM:
 	case NFT_MSG_NEWRULE:
+	case NFT_MSG_NEWACCT:
 		return NFT_OF_EVENT_NEW;
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DELSET:
 	case NFT_MSG_DELSETELEM:
 	case NFT_MSG_DELRULE:
+	case NFT_MSG_DELACCT:
 		return NFT_OF_EVENT_DEL;
 	}
 
@@ -1806,6 +1990,49 @@ out:
 	return MNL_CB_OK;
 }
 
+static int netlink_events_acct_cb(const struct nlmsghdr *nlh, int type,
+				  struct netlink_mon_handler *monh)
+{
+	struct acct *acct;
+	uint32_t family;
+	struct nft_acct *nla = netlink_acct_alloc(nlh);
+
+	switch (monh->format) {
+	case NFT_OUTPUT_DEFAULT:
+		switch (type) {
+		case NFT_MSG_NEWACCT:
+			printf("add ");
+			acct = netlink_delinearize_acct(monh->ctx, nla);
+			if (acct == NULL)
+				return MNL_CB_ERROR;
+			acct_print(acct);
+			acct_free(acct);
+			printf("\n");
+			break;
+		case NFT_MSG_DELACCT:
+			family = nft_acct_attr_get_u32(nla,
+						       NFT_ACCT_ATTR_FAMILY);
+			printf("delete acct %s %s %s\n",
+			       family2str(family),
+			       nft_acct_attr_get_str(nla, NFT_ACCT_ATTR_TABLE),
+			       nft_acct_attr_get_str(nla, NFT_ACCT_ATTR_NAME));
+			break;
+		}
+		break;
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		nft_acct_fprintf(stdout, nla, monh->format,
+				 netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+		break;
+	}
+
+	nft_acct_free(nla);
+
+	return MNL_CB_OK;
+
+}
+
 static void rule_map_decompose_cb(struct set *s, void *data)
 {
 	if (s->flags & NFT_SET_INTERVAL)
@@ -2038,6 +2265,10 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELSETELEM:	/* nft {add|delete} element */
 		ret = netlink_events_setelem_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWACCT:
+	case NFT_MSG_DELACCT:		/* nft {add|delete} acct */
+		ret = netlink_events_acct_cb(nlh, type, monh);
+		break;
 	case NFT_MSG_NEWRULE:
 	case NFT_MSG_DELRULE:
 		ret = netlink_events_rule_cb(nlh, type, monh);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 387bb67..c6d6b82 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -445,6 +445,19 @@ static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
 		netlink_parse_ct_stmt(ctx, loc, nle);
 }
 
+static void netlink_parse_acct(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = acct_stmt_alloc(loc);
+	stmt->acct.name =
+		nft_rule_expr_get_str(nle, NFT_EXPR_ACCT_NAME);
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
@@ -709,6 +722,7 @@ static const struct {
 	{ .name = "exthdr",	.parse = netlink_parse_exthdr },
 	{ .name = "meta",	.parse = netlink_parse_meta },
 	{ .name = "ct",		.parse = netlink_parse_ct },
+	{ .name = "acct",	.parse = netlink_parse_acct },
 	{ .name = "counter",	.parse = netlink_parse_counter },
 	{ .name = "log",	.parse = netlink_parse_log },
 	{ .name = "limit",	.parse = netlink_parse_limit },
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9bef67b..d18e780 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -539,6 +539,20 @@ static void netlink_gen_verdict_stmt(struct netlink_linearize_ctx *ctx,
 	return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 }
 
+static void netlink_gen_acct_stmt(struct netlink_linearize_ctx *ctx,
+				 const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("acct");
+	if (stmt->acct.name) {
+		nft_rule_expr_set_str(nle, NFT_EXPR_ACCT_NAME,
+				      stmt->acct.name);
+	}
+
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 				     const struct stmt *stmt)
 {
@@ -806,6 +820,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 	case STMT_VERDICT:
 		return netlink_gen_verdict_stmt(ctx, stmt);
+	case STMT_ACCT:
+		return netlink_gen_acct_stmt(ctx, stmt);
 	case STMT_COUNTER:
 		return netlink_gen_counter_stmt(ctx, stmt);
 	case STMT_META:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..415264d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -133,6 +133,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct expr		*expr;
 	struct set		*set;
 	const struct datatype	*datatype;
+	struct acct		*acct;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -177,6 +178,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token MAP			"map"
 %token HANDLE			"handle"
 %token RULESET			"ruleset"
+%token ACCT			"acct"
 
 %token INET			"inet"
 
@@ -405,8 +407,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
-%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
-%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
+%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec acct_spec acct_identifier
+%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec acct_spec acct_identifier
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			handle_spec family_spec family_spec_explicit position_spec
@@ -428,10 +430,15 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
 
+%type <acct>			acct_block_alloc
+%destructor { acct_free($$); }	acct_block_alloc
+
 %type <list>			stmt_list
 %destructor { stmt_list_free($$); xfree($$); } stmt_list
 %type <stmt>			stmt match_stmt verdict_stmt
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt
+%type <stmt>			acct_stmt acct_stmt_alloc
+%destructor { stmt_free($$); }	acct_stmt acct_stmt_alloc
 %type <stmt>			counter_stmt counter_stmt_alloc
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc
 %type <stmt>			ct_stmt
@@ -680,6 +687,10 @@ add_cmd			:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SET, &$2, &@$, $5);
 			}
+			|	ACCT		acct_spec
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_ACCT, &$2, &@$, NULL);
+			}
 			|	MAP		set_spec	map_block_alloc
 						'{'	map_block	'}'
 			{
@@ -740,6 +751,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	ACCT		acct_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_ACCT, &$2, &@$, NULL);
+			}
 			|	MAP		set_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
@@ -770,6 +785,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	ACCT		acct_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_ACCT, &$2, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
@@ -788,6 +807,10 @@ flush_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	ACCT		acct_spec
+			{
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_ACCT, &$2, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_RULESET, &$2, &@$, NULL);
@@ -877,6 +900,16 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->sets);
 				$$ = $1;
 			}
+			|	table_block	ACCT		acct_identifier
+					acct_block_alloc
+					stmt_seperator
+			{
+				$4->location = @3;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->accts);
+				$$ = $1;
+			}
 			|	table_block	MAP		set_identifier
 					map_block_alloc		'{'	map_block	'}'
 					stmt_seperator
@@ -907,6 +940,12 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			}
 			;
 
+acct_block_alloc	:	/* empty */
+			{
+				$$ = acct_alloc(NULL);
+			}
+			;
+
 set_block_alloc		:	/* empty */
 			{
 				$$ = set_alloc(NULL);
@@ -1112,6 +1151,13 @@ set_spec		:	table_spec	identifier
 			}
 			;
 
+acct_spec		:	table_spec	identifier
+			{
+				$$		= $1;
+				$$.acct	= $2;
+			}
+			;
+
 set_identifier		:	identifier
 			{
 				memset(&$$, 0, sizeof($$));
@@ -1119,6 +1165,13 @@ set_identifier		:	identifier
 			}
 			;
 
+acct_identifier		:	identifier
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.acct		= $1;
+			}
+			;
+
 handle_spec		:	/* empty */
 			{
 				$$ = 0;
@@ -1198,6 +1251,7 @@ stmt_list		:	stmt
 stmt			:	verdict_stmt
 			|	match_stmt
 			|	counter_stmt
+			|	acct_stmt
 			|	meta_stmt
 			|	log_stmt
 			|	limit_stmt
@@ -1258,6 +1312,20 @@ verdict_map_list_member_expr:	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_ne
 			}
 			;
 
+acct_stmt		:	acct_stmt_alloc	acct_arg
+
+acct_stmt_alloc		:	ACCT
+			{
+				$$ = acct_stmt_alloc(&@$);
+			}
+			;
+
+acct_arg		:	STRING
+			{
+				$<stmt>0->acct.name = $1;
+			}
+			;
+
 
 counter_stmt		:	counter_stmt_alloc
 			|	counter_stmt_alloc	counter_args
diff --git a/src/rule.c b/src/rule.c
index feafe26..b2981d4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -32,6 +32,7 @@ void handle_free(struct handle *h)
 	xfree(h->table);
 	xfree(h->chain);
 	xfree(h->set);
+	xfree(h->acct);
 	xfree(h->comment);
 }
 
@@ -45,6 +46,8 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->chain = xstrdup(src->chain);
 	if (dst->set == NULL && src->set != NULL)
 		dst->set = xstrdup(src->set);
+	if (dst->acct == NULL && src->acct != NULL)
+		dst->acct = xstrdup(src->acct);
 	if (dst->handle == 0)
 		dst->handle = src->handle;
 	if (dst->position == 0)
@@ -212,6 +215,69 @@ void set_print_plain(const struct set *s)
 	do_set_print(s, &opts);
 }
 
+struct acct *acct_alloc(const struct location *loc)
+{
+	struct acct *acct;
+
+	acct = xzalloc(sizeof(*acct));
+	acct->refcnt = 1;
+
+	if (loc != NULL)
+		acct->location = *loc;
+
+	return acct;
+}
+
+struct acct *acct_get(struct acct *acct)
+{
+	acct->refcnt++;
+
+	return acct;
+}
+
+void acct_free(struct acct *acct)
+{
+	if (--acct->refcnt > 0)
+		return;
+	handle_free(&acct->handle);
+	xfree(acct);
+}
+
+struct acct *acct_lookup(const struct table *table, const char *name)
+{
+	struct acct *acct;
+
+	list_for_each_entry(acct, &table->accts, list) {
+		if (!strcmp(acct->handle.acct, name))
+			return acct;
+	}
+
+	return NULL;
+}
+
+struct acct *acct_lookup_global(uint32_t family, const char *table,
+			      const char *name)
+{
+	struct handle h;
+	struct table *t;
+
+	h.family = family;
+	h.table = table;
+
+	t = table_lookup(&h);
+	if (t == NULL)
+		return NULL;
+
+	return acct_lookup(t, name);
+}
+
+void acct_print(const struct acct *acct)
+{
+	printf("\tacct %s { ", acct->handle.acct);
+	printf("pkts %"PRIu64" bytes %"PRIu64"", acct->packets, acct->bytes);
+	printf("}\n");
+}
+
 struct rule *rule_alloc(const struct location *loc, const struct handle *h)
 {
 	struct rule *rule;
@@ -467,6 +533,7 @@ struct table *table_alloc(void)
 	table = xzalloc(sizeof(*table));
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
+	init_list_head(&table->accts);
 	init_list_head(&table->scope.symbols);
 	return table;
 }
@@ -504,6 +571,7 @@ struct table *table_lookup(const struct handle *h)
 static void table_print(const struct table *table)
 {
 	struct chain *chain;
+	struct acct *acct;
 	struct set *set;
 	const char *delim = "";
 	const char *family = family2str(table->handle.family);
@@ -516,11 +584,21 @@ static void table_print(const struct table *table)
 		set_print(set);
 		delim = "\n";
 	}
+
+	if (!list_empty(&table->sets))
+		printf("\n");
+	list_for_each_entry(acct, &table->accts, list) {
+		acct_print(acct);
+	}
+	if (!list_empty(&table->chains))
+		printf("\n");
+
 	list_for_each_entry(chain, &table->chains, list) {
 		printf("%s", delim);
 		chain_print(chain);
 		delim = "\n";
 	}
+
 	printf("}\n");
 }
 
@@ -602,6 +680,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
+		case CMD_OBJ_ACCT:
+			acct_free(cmd->acct);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -625,6 +706,15 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
+static int do_add_acct(struct netlink_ctx *ctx, const struct handle *h,
+		       struct acct *acct)
+{
+	if (netlink_add_acct(ctx, h, acct) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct expr *expr)
 {
@@ -654,6 +744,7 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct chain *chain;
 	struct set *set;
+	struct acct *acct;
 
 	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
 		return -1;
@@ -663,6 +754,11 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 			if (do_add_set(ctx, &set->handle, set) < 0)
 				return -1;
 		}
+		list_for_each_entry(acct, &table->accts, list) {
+			handle_merge(&acct->handle, &table->handle);
+			if (do_add_acct(ctx, &acct->handle, acct) < 0)
+				return -1;
+		}
 		list_for_each_entry(chain, &table->chains, list) {
 			if (do_add_chain(ctx, &chain->handle, &chain->location,
 					 chain, excl) < 0)
@@ -688,6 +784,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return do_add_set(ctx, &cmd->handle, cmd->set);
 	case CMD_OBJ_SETELEM:
 		return do_add_setelems(ctx, &cmd->handle, cmd->expr);
+	case CMD_OBJ_ACCT:
+		return do_add_acct(ctx, &cmd->handle, cmd->acct);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -720,6 +818,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
 		return netlink_delete_setelems(ctx, &cmd->handle, cmd->expr);
+	case CMD_OBJ_ACCT:
+		return netlink_delete_acct(ctx, &cmd->handle, &cmd->location);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -741,6 +841,21 @@ static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
 	return 0;
 }
 
+static int do_list_accts(struct netlink_ctx *ctx, const struct location *loc,
+			 struct table *table)
+{
+	struct acct *acct, *nacct;
+
+	if (netlink_list_accts(ctx, &table->handle, loc) < 0)
+		return -1;
+
+	list_for_each_entry_safe(acct, nacct, &ctx->list, list) {
+		list_move_tail(&acct->list, &table->accts);
+	}
+
+	return 0;
+}
+
 static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nft_ruleset *rs = netlink_dump_ruleset(ctx, &cmd->handle,
@@ -760,6 +875,7 @@ static void table_cleanup(struct table *table)
 {
 	struct chain *chain, *nchain;
 	struct set *set, *nset;
+	struct acct *acct, *nacct;
 
 	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
 		list_del(&chain->list);
@@ -770,6 +886,10 @@ static void table_cleanup(struct table *table)
 		list_del(&set->list);
 		set_free(set);
 	}
+	list_for_each_entry_safe(acct, nacct, &table->accts, list) {
+		list_del(&acct->list);
+		acct_free(acct);
+	}
 }
 
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
@@ -780,6 +900,8 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
 		goto err;
+	if (do_list_accts(ctx, &cmd->location, table) < 0)
+		goto err;
 	if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
 		goto err;
 	list_splice_tail_init(&ctx->list, &table->chains);
@@ -835,6 +957,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
 	struct set *set;
+	struct acct *acct;
 
 	/* No need to allocate the table object when listing all tables */
 	if (cmd->handle.table != NULL) {
@@ -887,6 +1010,20 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			set_print(set);
 		}
 		return 0;
+	case CMD_OBJ_ACCTS:
+		if (netlink_list_accts(ctx, &cmd->handle, &cmd->location) < 0)
+			goto err;
+		list_for_each_entry(acct, &ctx->list, list) {
+			acct_print(acct);
+		}
+		return 0;
+	case CMD_OBJ_ACCT:
+		if (netlink_get_acct(ctx, &cmd->handle, &cmd->location) < 0)
+			goto err;
+		list_for_each_entry(acct, &ctx->list, list) {
+			acct_print(acct);
+		}
+		return 0;
 	case CMD_OBJ_RULESET:
 		return do_list_ruleset(ctx, cmd);
 	default:
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..eb69eb0 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -276,6 +276,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "performance"		{ return PERFORMANCE; }
 "memory"		{ return MEMORY; }
 
+"acct"			{ return ACCT; }
+
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
diff --git a/src/statement.c b/src/statement.c
index d72c6e9..35d44c9 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -120,6 +120,22 @@ struct stmt *counter_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &counter_stmt_ops);
 }
 
+static void acct_stmt_print(const struct stmt *stmt)
+{
+	printf("acct %s", stmt->acct.name);
+}
+
+static const struct stmt_ops acct_stmt_ops = {
+	.type		= STMT_ACCT,
+	.name		= "acct",
+	.print		= acct_stmt_print,
+};
+
+struct stmt *acct_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &acct_stmt_ops);
+}
+
 static const char *syslog_level[LOG_DEBUG + 1] = {
 	[LOG_EMERG]	= "emerg",
 	[LOG_ALERT]	= "alert",
-- 
1.7.10.4

