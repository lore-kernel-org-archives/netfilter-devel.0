From: Ana Rey Botello <ana@soleta.eu>
Subject: [v5 nft] src: Add named counters support
Date: Thu,  5 Feb 2015 13:48:19 +0100
Message-ID: <95cfc4cd9ea8982d65fdbf6c2cbd9c978ee65b7a.1423139423.git.ana@soleta.eu>
Cc: Ana Rey <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:50858 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbbBEMrl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Feb 2015 07:47:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey <ana@soleta.eu>

This adds userspace support to named counter objects and counter expression.

Examples of use in nft of this new feature:

* Add a new counter:
nft add counter ip filter http-traffic

* Add a new counter with a specific values:
nft add counter ip filter https-traffic { packets 100 bytes 2000}

* Delete the counter:
nft delete counter ip filter https-traffic

* Set the counter to a rule:
nft add rule ip filter output tcp dport 80 counter name http-traffic
nft add rule ip filter output tcp dport 443 counter name https-traffic

* Reset the number of bytes and packets of the counter:
nft reset counter ip filter http-traffic

* Reset the number of bytes and packets of all counters:
nft reset counters

* List all counter:
nft list counters

* List information about the counter.
nft list counter ip test https-traffic

Example of the table with some counters:

 # nft list table ip test

table ip filter {
        counter http-traffic { pkts 779 bytes 99495}
        counter https-traffic { pkts 189 bytes 37824}

        chain output {
                 type filter hook output priority 0;
                 tcp dport http counter name http-traffic
                 tcp dport https counter name https-traffic
        }
}

The kernel support is added in the commit:
"netfilter: add named counters support"

The libnftnl support is added in the commit:
"src: Add named counters support"

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---

[Changes in v5]
* Fixed a problem with creation of counter without initial values

 include/linux/netfilter/nf_tables.h |   30 ++++
 include/mnl.h                       |   11 ++
 include/netlink.h                   |   27 +++
 include/rule.h                      |   47 ++++++
 include/statement.h                 |    1 +
 src/evaluate.c                      |   14 +-
 src/mnl.c                           |  135 +++++++++++++++
 src/netlink.c                       |  307 +++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |    3 +
 src/netlink_linearize.c             |    4 +
 src/parser_bison.y                  |  105 +++++++++++-
 src/rule.c                          |  153 +++++++++++++++++
 src/scanner.l                       |    2 +
 src/statement.c                     |    8 +-
 14 files changed, 839 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 832bc46..cac526e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -53,6 +53,10 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_NEWCOUNTER: create a new counter (enum nft_named_ctr_attributes)
+ * @NFT_MSG_GETCOUNTER: get a counter (enum nft_named_ctr_attributes)
+ * @NFT_MSG_GETCOUNTER_ZERO: get a reset counter (enum nft_named_ctr_attributes)
+ * @NFT_MSG_DELCOUNTER: delete a counter (enum nft_named_ctr_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -72,6 +76,10 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_NEWCOUNTER,
+	NFT_MSG_GETCOUNTER,
+	NFT_MSG_GETCOUNTER_ZERO,
+	NFT_MSG_DELCOUNTER,
 	NFT_MSG_MAX,
 };
 
@@ -695,16 +703,38 @@ enum nft_limit_attributes {
  *
  * @NFTA_COUNTER_BYTES: number of bytes (NLA_U64)
  * @NFTA_COUNTER_PACKETS: number of packets (NLA_U64)
+ * @NFTA_COUNTER_NAME: name of the counter (NLA_STRING)
  */
 enum nft_counter_attributes {
 	NFTA_COUNTER_UNSPEC,
 	NFTA_COUNTER_BYTES,
 	NFTA_COUNTER_PACKETS,
+	NFTA_COUNTER_NAME,
 	__NFTA_COUNTER_MAX
 };
 #define NFTA_COUNTER_MAX	(__NFTA_COUNTER_MAX - 1)
 
 /**
+ * enum nft_named_counter_attributes - nf_tables named counter netlink attributes
+ *
+ * @NFTA_NAMED_CTR_NAME: named counter name (NLA_STRING)
+ * @NFTA_NAMED_CTR_TABLE: table name (NLA_STRING)
+ * @NFTA_NAMED_CTR_USE: number of references to this named counter (NLA_U32)
+ * @NFTA_NAMED_CTR_BYTES: number of bytes (NLA_U64)
+ * @NFTA_NAMED_CTR_PACKETS: number of packets (NLA_U64)
+ */
+enum nft_named_counter_attributes {
+	NFTA_NAMED_CTR_UNSPEC,
+	NFTA_NAMED_CTR_NAME,
+	NFTA_NAMED_CTR_TABLE,
+	NFTA_NAMED_CTR_USE,
+	NFTA_NAMED_CTR_BYTES,
+	NFTA_NAMED_CTR_PACKETS,
+	__NFTA_NAMED_CTR_MAX
+};
+#define NFTA_NAMED_CTR_MAX	(__NFTA_NAMED_CTR_MAX - 1)
+
+/**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
  * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
diff --git a/include/mnl.h b/include/mnl.h
index a0dfa1b..e1df7c9 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -34,6 +34,17 @@ int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *r,
 struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 					int family);
 
+int mnl_nft_counter_batch_add(struct nft_counter *nlc,
+			      unsigned int flags, uint32_t seq);
+int mnl_nft_counter_batch_reset(struct nft_counter *nlc,
+				unsigned int flags, uint32_t seq);
+int mnl_nft_counter_batch_del(struct nft_counter *nlc,
+			      unsigned int flags, uint32_t seq);
+int mnl_nft_counter_get(struct mnl_socket *nf_sock, struct nft_counter *nlc);
+int mnl_nft_counter_reset(struct mnl_socket *nf_sock, struct nft_counter *nlc);
+struct nft_counter_list *mnl_nft_counter_dump(struct mnl_socket *nf_sock,
+					      int family, const char *table);
+
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 		      unsigned int flags);
 int mnl_nft_chain_batch_add(struct nft_chain *nlc,
diff --git a/include/netlink.h b/include/netlink.h
index 4f79470..0ab9486 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -21,6 +21,7 @@ extern const struct location netlink_location;
  * @msgs:	message queue
  * @list:	list of parsed rules/chains/tables
  * @set:	current set
+ * @counter:	current counter
  * @data:	pointer to pass data to callback
  * @seqnum:	sequence number
  */
@@ -28,6 +29,7 @@ struct netlink_ctx {
 	struct list_head	*msgs;
 	struct list_head	list;
 	struct set		*set;
+	struct counter		*counter;
 	const void		*data;
 	uint32_t		seqnum;
 	bool			batch_supported;
@@ -38,6 +40,7 @@ extern struct nft_chain *alloc_nft_chain(const struct handle *h);
 extern struct nft_rule *alloc_nft_rule(const struct handle *h);
 extern struct nft_rule_expr *alloc_nft_expr(const char *name);
 extern struct nft_set *alloc_nft_set(const struct handle *h);
+extern struct nft_counter *alloc_nft_counter(const struct handle *h);
 
 struct nft_data_linearize {
 	uint32_t	len;
@@ -84,6 +87,29 @@ extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
 				  const struct handle *h,
 				  const struct location *loc);
 
+extern int netlink_add_counter(struct netlink_ctx *ctx, const struct handle *h,
+			       struct counter *counter);
+extern int netlink_reset_counter(struct netlink_ctx *ctx,
+				 const struct handle *h,
+				 const struct location *loc);
+extern int netlink_reset_counters(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct location *loc);
+extern int netlink_rename_counter(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct location *loc, const char *name);
+extern int netlink_delete_counter(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct location *loc);
+extern int netlink_list_counters(struct netlink_ctx *ctx,
+				 const struct handle *h,
+				 const struct location *loc);
+extern int netlink_get_counter(struct netlink_ctx *ctx, const struct handle *h,
+			       const struct location *loc);
+extern int netlink_flush_counter(struct netlink_ctx *ctx,
+				 const struct handle *h,
+				 const struct location *loc);
+
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
 			     const struct chain *chain, bool excl);
@@ -135,6 +161,7 @@ extern void netlink_dump_chain(struct nft_chain *nlc);
 extern void netlink_dump_rule(struct nft_rule *nlr);
 extern void netlink_dump_expr(struct nft_rule_expr *nle);
 extern void netlink_dump_set(struct nft_set *nls);
+extern void netlink_dump_counter(struct nft_counter *nlc);
 
 extern int netlink_batch_send(struct list_head *err_list);
 
diff --git a/include/rule.h b/include/rule.h
index 491411e..1be0a83 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -12,6 +12,7 @@
  * @table:	table name
  * @chain:	chain name (chains and rules only)
  * @set:	set name (sets only)
+ * @counter:	counter name (counters only)
  * @handle:	rule handle (rules only)
  * @position:	rule position (rules only)
  * @set_id:	set ID (sets only)
@@ -22,6 +23,7 @@ struct handle {
 	const char		*table;
 	const char		*chain;
 	const char		*set;
+	const char		*counter;
 	uint64_t		handle;
 	uint64_t		position;
 	uint32_t		set_id;
@@ -71,6 +73,7 @@ extern struct symbol *symbol_lookup(const struct scope *scope,
  * @location:	location the table was defined at
  * @chains:	chains contained in the table
  * @sets:	sets contained in the table
+ * @counters:	counters contained in the table
  */
 struct table {
 	struct list_head	list;
@@ -79,6 +82,7 @@ struct table {
 	struct scope		scope;
 	struct list_head	chains;
 	struct list_head	sets;
+	struct list_head	counters;
 };
 
 extern struct table *table_alloc(void);
@@ -211,6 +215,39 @@ extern void set_print(const struct set *set);
 extern void set_print_plain(const struct set *s);
 
 /**
+ * struct counter - nftables counter
+ *
+ * @list:	table counter list node
+ * @handle:	counter handle
+ * @location:	location the counter was defined/declared at
+ * @refcnt:	reference count
+ * @flags:	bitmask of counter flags
+ * @bytes:	Total bytes
+ * @packets:	Total packets
+
+ */
+struct counter {
+	struct list_head	list;
+	struct handle		handle;
+	struct location		location;
+	unsigned int		refcnt;
+	uint32_t		flags;
+	uint64_t		bytes;
+	uint64_t		packets;
+};
+
+extern struct counter *counter_alloc(const struct location *loc);
+extern struct counter *counter_get(struct counter *counter);
+extern void counter_free(struct counter *counter);
+extern struct counter *counter_clone(const struct counter *counter);
+extern void counter_add_hash(struct counter *counter, struct table *table);
+extern struct counter *counter_lookup(const struct table *table,
+				      const char *name);
+extern struct counter *counter_lookup_global(uint32_t family, const char *table,
+					     const char *name);
+extern void counter_print(const struct counter *counter);
+
+/**
  * enum cmd_ops - command operations
  *
  * @CMD_INVALID:	invalid
@@ -224,6 +261,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
+ * @CMD_RESET:		reset object
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -237,6 +275,7 @@ enum cmd_ops {
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
+	CMD_RESET,
 };
 
 /**
@@ -253,6 +292,8 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_COUNTER:	counter
+ * @CMD_OBJ_COUNTERS:	counters
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -266,6 +307,8 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_COUNTER,
+	CMD_OBJ_COUNTERS,
 };
 
 struct export {
@@ -282,6 +325,7 @@ enum {
 	CMD_MONITOR_OBJ_RULES,
 	CMD_MONITOR_OBJ_SETS,
 	CMD_MONITOR_OBJ_ELEMS,
+	CMD_MONITOR_OBJ_COUNTERS,
 	CMD_MONITOR_OBJ_MAX
 };
 
@@ -320,6 +364,7 @@ struct cmd {
 		void		*data;
 		struct expr	*expr;
 		struct set	*set;
+		struct counter	*counter;
 		struct rule	*rule;
 		struct chain	*chain;
 		struct table	*table;
@@ -345,6 +390,7 @@ extern void cmd_free(struct cmd *cmd);
  * @table:	current table
  * @rule:	current rule
  * @set:	current set
+ * @counter:	current counter
  * @stmt:	current statement
  * @ectx:	expression context
  * @pctx:	payload context
@@ -355,6 +401,7 @@ struct eval_ctx {
 	struct table		*table;
 	struct rule		*rule;
 	struct set		*set;
+	struct counter		*counter;
 	struct stmt		*stmt;
 	struct expr_ctx		ectx;
 	struct proto_ctx	pctx;
diff --git a/include/statement.h b/include/statement.h
index d143121..5c65633 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -13,6 +13,7 @@ extern struct stmt *verdict_stmt_alloc(const struct location *loc,
 struct counter_stmt {
 	uint64_t		packets;
 	uint64_t		bytes;
+	const char		*name;
 };
 
 extern struct stmt *counter_stmt_alloc(const struct location *loc);
diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..db9e03a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1851,6 +1851,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
+	case CMD_OBJ_COUNTER:
+		return 0;
 	case CMD_OBJ_CHAIN:
 		if (cmd->data == NULL)
 			return 0;
@@ -1870,6 +1872,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SETELEM:
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
+	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_RULE:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
@@ -1899,30 +1902,36 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 						  (1 << NFT_MSG_DELSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_NEWSETELEM) |
 						  (1 << NFT_MSG_DELSETELEM),
+		[CMD_MONITOR_OBJ_COUNTERS]	= (1 << NFT_MSG_NEWCOUNTER) |
+						  (1 << NFT_MSG_DELCOUNTER),
 	},
 	[CMD_MONITOR_EVENT_NEW] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_NEWTABLE) |
 						  (1 << NFT_MSG_NEWCHAIN) |
 						  (1 << NFT_MSG_NEWRULE)  |
 						  (1 << NFT_MSG_NEWSET)   |
-						  (1 << NFT_MSG_NEWSETELEM),
+						  (1 << NFT_MSG_NEWSETELEM)|
+						  (1 << NFT_MSG_NEWCOUNTER),
 		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_NEWTABLE),
 		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_NEWCHAIN),
 		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_NEWRULE),
 		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_NEWSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_NEWSETELEM),
+		[CMD_MONITOR_OBJ_COUNTERS]	= (1 << NFT_MSG_NEWCOUNTER),
 	},
 	[CMD_MONITOR_EVENT_DEL] = {
 		[CMD_MONITOR_OBJ_ANY]		= (1 << NFT_MSG_DELTABLE) |
 						  (1 << NFT_MSG_DELCHAIN) |
 						  (1 << NFT_MSG_DELRULE)  |
 						  (1 << NFT_MSG_DELSET)   |
-						  (1 << NFT_MSG_DELSETELEM),
+						  (1 << NFT_MSG_DELSETELEM)|
+						  (1 << NFT_MSG_DELCOUNTER),
 		[CMD_MONITOR_OBJ_TABLES]	= (1 << NFT_MSG_DELTABLE),
 		[CMD_MONITOR_OBJ_CHAINS]	= (1 << NFT_MSG_DELCHAIN),
 		[CMD_MONITOR_OBJ_RULES]		= (1 << NFT_MSG_DELRULE),
 		[CMD_MONITOR_OBJ_SETS]		= (1 << NFT_MSG_DELSET),
 		[CMD_MONITOR_OBJ_ELEMS]		= (1 << NFT_MSG_DELSETELEM),
+		[CMD_MONITOR_OBJ_COUNTERS]	= (1 << NFT_MSG_DELCOUNTER),
 	},
 };
 
@@ -1968,6 +1977,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_RENAME:
 	case CMD_EXPORT:
 	case CMD_DESCRIBE:
+	case CMD_RESET:
 		return 0;
 	case CMD_MONITOR:
 		return cmd_evaluate_monitor(ctx, cmd);
diff --git a/src/mnl.c b/src/mnl.c
index f48ead5..4a4ec4e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -16,6 +16,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/counter.h>
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -1093,3 +1094,137 @@ err:
 	mnl_nlmsg_batch_stop(b);
 	return ret;
 }
+
+/*
+ * Named counter
+ */
+int mnl_nft_counter_batch_add(struct nft_counter *nls, unsigned int flags,
+			      uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_counter_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+			NFT_MSG_NEWCOUNTER,
+			nft_counter_attr_get_u32(nls, NFT_COUNTER_ATTR_FAMILY),
+			NLM_F_CREATE | flags, seqnum);
+	nft_counter_nlmsg_build_payload(nlh, nls);
+	nft_batch_continue();
+
+	return 0;
+}
+
+int mnl_nft_counter_batch_del(struct nft_counter *nls, unsigned int flags,
+			      uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_counter_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+			NFT_MSG_DELCOUNTER,
+			nft_counter_attr_get_u32(nls, NFT_COUNTER_ATTR_FAMILY),
+			flags, seqnum);
+	nft_counter_nlmsg_build_payload(nlh, nls);
+	nft_batch_continue();
+
+	return 0;
+}
+
+static int counter_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_counter_list *ctr_list = data;
+	struct nft_counter *c;
+
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
+	c = nft_counter_alloc();
+	if (c == NULL)
+		memory_allocation_error();
+
+	if (nft_counter_nlmsg_parse(nlh, c) < 0)
+		goto err_free;
+
+	nft_counter_list_add_tail(c, ctr_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_counter_free(c);
+	return MNL_CB_OK;
+}
+
+static int counter_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_counter *a = data;
+
+	nft_counter_nlmsg_parse(nlh, a);
+
+	return MNL_CB_OK;
+}
+
+int mnl_nft_counter_get(struct mnl_socket *nf_sock, struct nft_counter *counter)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_counter_nlmsg_build_hdr(buf, NFT_MSG_GETCOUNTER,
+			nft_counter_attr_get_u32(counter,
+						 NFT_COUNTER_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_counter_nlmsg_build_payload(nlh, counter);
+
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, counter_get_cb,
+			    counter);
+}
+
+int mnl_nft_counter_reset(struct mnl_socket *nf_sock,
+			  struct nft_counter *counter)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_counter_nlmsg_build_hdr(buf, NFT_MSG_GETCOUNTER_ZERO,
+			nft_counter_attr_get_u32(counter,
+						 NFT_COUNTER_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+
+	nft_counter_nlmsg_build_payload(nlh, counter);
+
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, counter_get_cb,
+			    counter);
+}
+
+struct nft_counter_list *mnl_nft_counter_dump(struct mnl_socket *nf_sock,
+					      int family,
+					      const char *table)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_counter *counter;
+	struct nft_counter_list *ctr_list;
+	int ret;
+
+	counter = nft_counter_alloc();
+	if (counter == NULL)
+		memory_allocation_error();
+
+	nlh = nft_counter_nlmsg_build_hdr(buf, NFT_MSG_GETCOUNTER, family,
+					  NLM_F_DUMP|NLM_F_ACK, seq);
+	if (table != NULL)
+		nft_counter_attr_set_str(counter, NFT_COUNTER_ATTR_TABLE,
+					 table);
+	nft_counter_nlmsg_build_payload(nlh, counter);
+	nft_counter_free(counter);
+
+	ctr_list = nft_counter_list_alloc();
+	if (ctr_list == NULL)
+		memory_allocation_error();
+
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, counter_cb, ctr_list);
+
+	if (ret < 0)
+		goto err;
+
+	return ctr_list;
+err:
+	nft_counter_list_free(ctr_list);
+	return NULL;
+}
diff --git a/src/netlink.c b/src/netlink.c
index 84d9d27..befe1c5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -21,6 +21,7 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/counter.h>
 #include <libnftnl/common.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -1434,6 +1435,248 @@ out:
 	return err;
 }
 
+static struct counter *netlink_delinearize_counter(struct netlink_ctx *ctx,
+						   struct nft_counter *nla)
+{
+	struct counter *counter;
+
+	counter = counter_alloc(&netlink_location);
+
+	if (counter == NULL)
+		return NULL;
+
+	counter->handle.family =
+		 nft_counter_attr_get_u32(nla, NFT_COUNTER_ATTR_FAMILY);
+	counter->handle.counter =
+		 xstrdup(nft_counter_attr_get_str(nla, NFT_COUNTER_ATTR_NAME));
+	counter->handle.table =
+		 xstrdup(nft_counter_attr_get_str(nla, NFT_COUNTER_ATTR_TABLE));
+	counter->packets = nft_counter_attr_get_u64(nla, NFT_COUNTER_ATTR_PKTS);
+	counter->bytes	= nft_counter_attr_get_u64(nla, NFT_COUNTER_ATTR_BYTES);
+
+	return counter;
+}
+
+static int list_counter_cb(struct nft_counter *c, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+	struct counter *counter;
+
+	netlink_dump_counter(c);
+	counter = netlink_delinearize_counter(ctx, c);
+	if (counter == NULL)
+		return -1;
+
+	list_add_tail(&counter->list, &ctx->list);
+
+	return 0;
+}
+
+int netlink_list_counters(struct netlink_ctx *ctx, const struct handle *h,
+			  const struct location *loc)
+{
+	struct nft_counter_list *ctr_list;
+	int err;
+
+	ctr_list = mnl_nft_counter_dump(nf_sock, h->family, h->table);
+	if (ctr_list == NULL) {
+		if (errno == EINTR)
+			return -1;
+
+		return netlink_io_error(ctx, loc,
+					"Could not receive counters from kernel: %s",
+					strerror(errno));
+	}
+
+	err = nft_counter_list_foreach(ctr_list, list_counter_cb, ctx);
+	nft_counter_list_free(ctr_list);
+
+	return err;
+}
+
+int netlink_get_counter(struct netlink_ctx *ctx, const struct handle *h,
+			const struct location *loc)
+{
+	struct nft_counter *nla;
+	struct counter *counter;
+	int err;
+
+	nla = alloc_nft_counter(h);
+	netlink_dump_counter(nla);
+	err = mnl_nft_counter_get(nf_sock, nla);
+	if (err < 0) {
+		nft_counter_free(nla);
+		return netlink_io_error(ctx, loc,
+					"Could not receive counter from kernel: %s",
+					strerror(errno));
+	}
+
+	counter = netlink_delinearize_counter(ctx, nla);
+	if (!counter) {
+		nft_counter_free(nla);
+		return -1;
+	}
+
+	list_add_tail(&counter->list, &ctx->list);
+
+	return err;
+}
+
+static int netlink_reset_one_counter(struct netlink_ctx *ctx,
+				     const struct location *loc,
+				     struct nft_counter *nlc)
+{
+	struct counter *counter;
+	int err;
+
+	netlink_dump_counter(nlc);
+	err = mnl_nft_counter_reset(nf_sock, nlc);
+
+	if (err < 0) {
+		nft_counter_free(nlc);
+		return netlink_io_error(ctx, loc,
+					"Could not receive counter from kernel: %s",
+					strerror(errno));
+	}
+
+	counter = netlink_delinearize_counter(ctx, nlc);
+	if (!counter) {
+		nft_counter_free(nlc);
+		return -1;
+	}
+
+	list_add_tail(&counter->list, &ctx->list);
+
+	return 0;
+}
+
+int netlink_reset_counter(struct netlink_ctx *ctx, const struct handle *h,
+			  const struct location *loc)
+{
+	struct nft_counter *nlc;
+
+	nlc = alloc_nft_counter(h);
+
+	return netlink_reset_one_counter(ctx, loc, nlc);
+}
+
+int netlink_reset_counters(struct netlink_ctx *ctx, const struct handle *h,
+			   const struct location *loc)
+{
+	struct nft_counter_list *ctr_list;
+	struct nft_counter_list_iter *ctr_iter;
+	struct nft_counter *counter;
+	int err;
+
+	ctr_list = mnl_nft_counter_dump(nf_sock, h->family, h->table);
+	if (ctr_list == NULL) {
+		if (errno == EINTR)
+			return -1;
+
+		return netlink_io_error(ctx, loc,
+					"Could not receive counters from kernel: %s",
+					strerror(errno));
+	}
+
+	ctr_iter = nft_counter_list_iter_create(ctr_list);
+	if (!ctr_iter) {
+		nft_counter_list_free(ctr_list);
+		return -1;
+	}
+
+	counter = nft_counter_list_iter_next(ctr_iter);
+	if (!counter)
+		err = -1;
+
+	while (counter) {
+		err =  netlink_reset_one_counter(ctx, loc, counter);
+		if (err < 0)
+			break;
+
+		counter = nft_counter_list_iter_next(ctr_iter);
+	}
+
+	nft_counter_list_iter_destroy(ctr_iter);
+	nft_counter_list_free(ctr_list);
+
+	return err;
+}
+
+void netlink_dump_counter(struct nft_counter *nla)
+{
+#ifdef DEBUG
+	char buf[4096];
+
+	if (!(debug_level & DEBUG_NETLINK))
+		return;
+
+	nft_counter_snprintf(buf, sizeof(buf), nla, 0, 0);
+	fprintf(stdout, "%s\n", buf);
+#endif
+}
+
+struct nft_counter *alloc_nft_counter(const struct handle *h)
+{
+	struct nft_counter *nla;
+
+	nla = nft_counter_alloc();
+	if (nla == NULL)
+		memory_allocation_error();
+
+	nft_counter_attr_set_u32(nla, NFT_COUNTER_ATTR_FAMILY, h->family);
+	nft_counter_attr_set_str(nla, NFT_COUNTER_ATTR_TABLE, h->table);
+
+	if (h->counter != NULL) {
+		nft_counter_attr_set_str(nla,
+					 NFT_COUNTER_ATTR_NAME, h->counter);
+	}
+
+	return nla;
+}
+
+int netlink_add_counter(struct netlink_ctx *ctx, const struct handle *h,
+			struct counter *counter)
+{
+	struct nft_counter *nla;
+	int err;
+
+	nla = alloc_nft_counter(h);
+	netlink_dump_counter(nla);
+
+	if (counter) {
+		nft_counter_attr_set_u64(nla, NFT_COUNTER_ATTR_PKTS,
+					 counter->packets);
+		nft_counter_attr_set_u64(nla, NFT_COUNTER_ATTR_BYTES,
+					 counter->bytes);
+	}
+
+	err = mnl_nft_counter_batch_add(nla, NLM_F_EXCL, ctx->seqnum);
+	if (err < 0) {
+		netlink_io_error(ctx, &counter->location,
+				 "Could not add counter: %s",
+				 strerror(errno));
+	}
+	nft_counter_free(nla);
+
+	return err;
+}
+
+int netlink_delete_counter(struct netlink_ctx *ctx, const struct handle *h,
+			   const struct location *loc)
+{
+	struct nft_counter *nla;
+	int err;
+
+	nla = alloc_nft_counter(h);
+	err = mnl_nft_counter_batch_del(nla, 0, ctx->seqnum);
+	nft_counter_free(nla);
+
+	if (err < 0)
+		netlink_io_error(ctx, loc, "Could not delete counter: %s",
+				 strerror(errno));
+	return err;
+}
+
 int netlink_batch_send(struct list_head *err_list)
 {
 	return mnl_batch_talk(nf_sock, err_list);
@@ -1515,6 +1758,19 @@ static struct nft_set *netlink_set_alloc(const struct nlmsghdr *nlh)
 	return nls;
 }
 
+static struct nft_counter *netlink_counter_alloc(const struct nlmsghdr *nlh)
+{
+	struct nft_counter *nla = nft_counter_alloc();
+
+	if (nla == NULL)
+		memory_allocation_error();
+
+	if (nft_counter_nlmsg_parse(nlh, nla) < 0)
+		netlink_abi_error();
+
+	return nla;
+}
+
 static struct nft_set *netlink_setelem_alloc(const struct nlmsghdr *nlh)
 {
 	struct nft_set *nls;
@@ -1549,12 +1805,14 @@ static uint32_t netlink_msg2nftnl_of(uint32_t msg)
 	case NFT_MSG_NEWSET:
 	case NFT_MSG_NEWSETELEM:
 	case NFT_MSG_NEWRULE:
+	case NFT_MSG_NEWCOUNTER:
 		return NFT_OF_EVENT_NEW;
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DELSET:
 	case NFT_MSG_DELSETELEM:
 	case NFT_MSG_DELRULE:
+	case NFT_MSG_DELCOUNTER:
 		return NFT_OF_EVENT_DEL;
 	}
 
@@ -1806,6 +2064,51 @@ out:
 	return MNL_CB_OK;
 }
 
+static int netlink_events_counter_cb(const struct nlmsghdr *nlh, int type,
+				     struct netlink_mon_handler *monh)
+{
+	struct counter *counter;
+	uint32_t family;
+	struct nft_counter *nla = netlink_counter_alloc(nlh);
+
+	switch (monh->format) {
+	case NFT_OUTPUT_DEFAULT:
+		switch (type) {
+		case NFT_MSG_NEWCOUNTER:
+			printf("add ");
+			counter = netlink_delinearize_counter(monh->ctx, nla);
+			if (counter == NULL)
+				return MNL_CB_ERROR;
+			counter_print(counter);
+			counter_free(counter);
+			printf("\n");
+			break;
+		case NFT_MSG_DELCOUNTER:
+			family = nft_counter_attr_get_u32(nla,
+							  NFT_COUNTER_ATTR_FAMILY);
+			printf("delete counter %s %s %s\n",
+			       family2str(family),
+			       nft_counter_attr_get_str(nla,
+							NFT_COUNTER_ATTR_TABLE),
+			       nft_counter_attr_get_str(nla,
+							NFT_COUNTER_ATTR_NAME));
+			break;
+		}
+		break;
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		nft_counter_fprintf(stdout, nla, monh->format,
+				    netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+		break;
+	}
+
+	nft_counter_free(nla);
+
+	return MNL_CB_OK;
+
+}
+
 static void rule_map_decompose_cb(struct set *s, void *data)
 {
 	if (s->flags & NFT_SET_INTERVAL)
@@ -2038,6 +2341,10 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELSETELEM:	/* nft {add|delete} element */
 		ret = netlink_events_setelem_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWCOUNTER:
+	case NFT_MSG_DELCOUNTER:	/* nft {add|delete} counter */
+		ret = netlink_events_counter_cb(nlh, type, monh);
+		break;
 	case NFT_MSG_NEWRULE:
 	case NFT_MSG_DELRULE:
 		ret = netlink_events_rule_cb(nlh, type, monh);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 387bb67..5ccfa30 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -445,6 +445,7 @@ static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
 		netlink_parse_ct_stmt(ctx, loc, nle);
 }
 
+
 static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
@@ -456,6 +457,8 @@ static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 		nft_rule_expr_get_u64(nle, NFT_EXPR_CTR_PACKETS);
 	stmt->counter.bytes   =
 		nft_rule_expr_get_u64(nle, NFT_EXPR_CTR_BYTES);
+	stmt->counter.name =
+		nft_rule_expr_get_str(nle, NFT_EXPR_CTR_NAME);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9bef67b..3a098eb 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -553,6 +553,10 @@ static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 		nft_rule_expr_set_u64(nle, NFT_EXPR_CTR_BYTES,
 				      stmt->counter.bytes);
 	}
+	if (stmt->counter.name) {
+		nft_rule_expr_set_str(nle, NFT_EXPR_CTR_NAME,
+				      stmt->counter.name);
+	}
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..e979d6b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -133,6 +133,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct expr		*expr;
 	struct set		*set;
 	const struct datatype	*datatype;
+	struct counter		*counter;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -177,6 +178,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token MAP			"map"
 %token HANDLE			"handle"
 %token RULESET			"ruleset"
+%token COUNTERS			"counters"
 
 %token INET			"inet"
 
@@ -341,6 +343,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token COUNTER			"counter"
 %token PACKETS			"packets"
 %token BYTES			"bytes"
+%token NAME			"name"
 
 %token LOG			"log"
 %token PREFIX			"prefix"
@@ -402,11 +405,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd reset_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd reset_cmd
 
-%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
-%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
+%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec counter_spec counter_identifier
+%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec counter_spec counter_identifier
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			handle_spec family_spec family_spec_explicit position_spec
@@ -428,6 +431,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
 
+%type <counter>				counter_block_alloc counter_block
+%destructor { counter_free($$); }	counter_block_alloc
+
 %type <list>			stmt_list
 %destructor { stmt_list_free($$); xfree($$); } stmt_list
 %type <stmt>			stmt match_stmt verdict_stmt
@@ -640,6 +646,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
+			|	RESET		reset_cmd	{ $$ = $2; }
 			;
 
 add_cmd			:	TABLE		table_spec
@@ -680,6 +687,17 @@ add_cmd			:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SET, &$2, &@$, $5);
 			}
+			|	COUNTER		counter_spec
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
+			|	COUNTER		counter_spec	counter_block_alloc
+						'{'	counter_block	'}'
+			{
+				$5->location = @5;
+				handle_merge(&$3->handle, &$2);
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $5);
+			}
 			|	MAP		set_spec	map_block_alloc
 						'{'	map_block	'}'
 			{
@@ -740,6 +758,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	COUNTER		counter_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
 			|	MAP		set_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
@@ -774,6 +796,14 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
 			}
+			|	COUNTER		counter_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
+			|	COUNTERS	tables_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
@@ -788,6 +818,10 @@ flush_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	COUNTER		counter_spec
+			{
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_RULESET, &$2, &@$, NULL);
@@ -828,6 +862,7 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 			| 	SETS		{ $$ = CMD_MONITOR_OBJ_SETS; }
 			|	RULES		{ $$ = CMD_MONITOR_OBJ_RULES; }
 			|	ELEMENTS	{ $$ = CMD_MONITOR_OBJ_ELEMS; }
+			| 	COUNTERS	{ $$ = CMD_MONITOR_OBJ_COUNTERS; }
 			;
 
 monitor_format		:	/* empty */	{ $$ = NFT_OUTPUT_DEFAULT; }
@@ -846,6 +881,16 @@ describe_cmd		:	primary_expr
 			}
 			;
 
+reset_cmd		:	COUNTER		counter_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
+			|	COUNTERS	tables_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
+			}
+			;
+
 table_block_alloc	:	/* empty */
 			{
 				$$ = table_alloc();
@@ -877,6 +922,16 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->sets);
 				$$ = $1;
 			}
+			|	table_block	COUNTER		counter_identifier
+					counter_block_alloc
+					stmt_seperator
+			{
+				$4->location = @3;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->counters);
+				$$ = $1;
+			}
 			|	table_block	MAP		set_identifier
 					map_block_alloc		'{'	map_block	'}'
 					stmt_seperator
@@ -907,6 +962,12 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			}
 			;
 
+counter_block_alloc	:	/* empty */
+			{
+				$$ = counter_alloc(NULL);
+			}
+			;
+
 set_block_alloc		:	/* empty */
 			{
 				$$ = set_alloc(NULL);
@@ -934,6 +995,24 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	set_mechanism	stmt_seperator
 			;
 
+counter_block		:	/* empty */	{ $$ = $<counter>-1; }
+			|	counter_block	common_block
+			{
+				$1->bytes = 0;
+				$1->packets = 0;
+				$$ = $1;
+			}
+			|	counter_block	BYTES	NUM
+			{
+				$1->bytes = $3;
+				$$ = $1;
+			}
+			|	counter_block	PACKETS	NUM
+			{
+				$1->packets = $3;
+				$$ = $1;
+			}
+
 set_flag_list		:	set_flag_list	COMMA		set_flag
 			{
 				$$ = $1 | $3;
@@ -1112,6 +1191,13 @@ set_spec		:	table_spec	identifier
 			}
 			;
 
+counter_spec		:	table_spec	identifier
+			{
+				$$		= $1;
+				$$.counter	= $2;
+			}
+			;
+
 set_identifier		:	identifier
 			{
 				memset(&$$, 0, sizeof($$));
@@ -1119,6 +1205,13 @@ set_identifier		:	identifier
 			}
 			;
 
+counter_identifier	:	identifier
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.counter	= $1;
+			}
+			;
+
 handle_spec		:	/* empty */
 			{
 				$$ = 0;
@@ -1283,6 +1376,10 @@ counter_arg		:	PACKETS			NUM
 			{
 				$<stmt>0->counter.bytes	 = $2;
 			}
+			|	NAME			STRING
+			{
+				$<stmt>0->counter.name = $2;
+			}
 			;
 
 log_stmt		:	log_stmt_alloc
diff --git a/src/rule.c b/src/rule.c
index feafe26..8d264ea 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -32,6 +32,7 @@ void handle_free(struct handle *h)
 	xfree(h->table);
 	xfree(h->chain);
 	xfree(h->set);
+	xfree(h->counter);
 	xfree(h->comment);
 }
 
@@ -45,6 +46,8 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->chain = xstrdup(src->chain);
 	if (dst->set == NULL && src->set != NULL)
 		dst->set = xstrdup(src->set);
+	if (dst->counter == NULL && src->counter != NULL)
+		dst->counter = xstrdup(src->counter);
 	if (dst->handle == 0)
 		dst->handle = src->handle;
 	if (dst->position == 0)
@@ -212,6 +215,70 @@ void set_print_plain(const struct set *s)
 	do_set_print(s, &opts);
 }
 
+struct counter *counter_alloc(const struct location *loc)
+{
+	struct counter *counter;
+
+	counter = xzalloc(sizeof(*counter));
+	counter->refcnt = 1;
+
+	if (loc != NULL)
+		counter->location = *loc;
+
+	return counter;
+}
+
+struct counter *counter_get(struct counter *counter)
+{
+	counter->refcnt++;
+
+	return counter;
+}
+
+void counter_free(struct counter *counter)
+{
+	if (--counter->refcnt > 0)
+		return;
+	handle_free(&counter->handle);
+	xfree(counter);
+}
+
+struct counter *counter_lookup(const struct table *table, const char *name)
+{
+	struct counter *counter;
+
+	list_for_each_entry(counter, &table->counters, list) {
+		if (!strcmp(counter->handle.counter, name))
+			return counter;
+	}
+
+	return NULL;
+}
+
+struct counter *counter_lookup_global(uint32_t family, const char *table,
+				      const char *name)
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
+	return counter_lookup(t, name);
+}
+
+void counter_print(const struct counter *counter)
+{
+	printf("\tcounter %s { ", counter->handle.counter);
+	printf("packets %"PRIu64" bytes %"PRIu64"", counter->packets,
+	       counter->bytes);
+	printf("}\n");
+}
+
 struct rule *rule_alloc(const struct location *loc, const struct handle *h)
 {
 	struct rule *rule;
@@ -467,6 +534,7 @@ struct table *table_alloc(void)
 	table = xzalloc(sizeof(*table));
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
+	init_list_head(&table->counters);
 	init_list_head(&table->scope.symbols);
 	return table;
 }
@@ -504,6 +572,7 @@ struct table *table_lookup(const struct handle *h)
 static void table_print(const struct table *table)
 {
 	struct chain *chain;
+	struct counter *counter;
 	struct set *set;
 	const char *delim = "";
 	const char *family = family2str(table->handle.family);
@@ -516,11 +585,19 @@ static void table_print(const struct table *table)
 		set_print(set);
 		delim = "\n";
 	}
+	if (!list_empty(&table->counters) && !list_empty(&table->sets))
+		printf("\n");
+	list_for_each_entry(counter, &table->counters, list) {
+		counter_print(counter);
+		delim = "\n";
+	}
+
 	list_for_each_entry(chain, &table->chains, list) {
 		printf("%s", delim);
 		chain_print(chain);
 		delim = "\n";
 	}
+
 	printf("}\n");
 }
 
@@ -602,6 +679,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
+		case CMD_OBJ_COUNTER:
+			counter_free(cmd->counter);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -625,6 +705,15 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
+static int do_add_counter(struct netlink_ctx *ctx, const struct handle *h,
+			  struct counter *counter)
+{
+	if (netlink_add_counter(ctx, h, counter) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct expr *expr)
 {
@@ -654,6 +743,7 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct chain *chain;
 	struct set *set;
+	struct counter *counter;
 
 	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
 		return -1;
@@ -663,6 +753,11 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 			if (do_add_set(ctx, &set->handle, set) < 0)
 				return -1;
 		}
+		list_for_each_entry(counter, &table->counters, list) {
+			handle_merge(&counter->handle, &table->handle);
+			if (do_add_counter(ctx, &counter->handle, counter) < 0)
+				return -1;
+		}
 		list_for_each_entry(chain, &table->chains, list) {
 			if (do_add_chain(ctx, &chain->handle, &chain->location,
 					 chain, excl) < 0)
@@ -688,6 +783,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return do_add_set(ctx, &cmd->handle, cmd->set);
 	case CMD_OBJ_SETELEM:
 		return do_add_setelems(ctx, &cmd->handle, cmd->expr);
+	case CMD_OBJ_COUNTER:
+		return do_add_counter(ctx, &cmd->handle, cmd->counter);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -720,6 +817,9 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
 		return netlink_delete_setelems(ctx, &cmd->handle, cmd->expr);
+	case CMD_OBJ_COUNTER:
+		return netlink_delete_counter(ctx, &cmd->handle,
+					      &cmd->location);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -741,6 +841,20 @@ static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
 	return 0;
 }
 
+static int do_list_counters(struct netlink_ctx *ctx, const struct location *loc,
+			    struct table *table)
+{
+	struct counter *counter, *ncounter;
+
+	if (netlink_list_counters(ctx, &table->handle, loc) < 0)
+		return -1;
+
+	list_for_each_entry_safe(counter, ncounter, &ctx->list, list)
+		list_move_tail(&counter->list, &table->counters);
+
+	return 0;
+}
+
 static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nft_ruleset *rs = netlink_dump_ruleset(ctx, &cmd->handle,
@@ -760,6 +874,7 @@ static void table_cleanup(struct table *table)
 {
 	struct chain *chain, *nchain;
 	struct set *set, *nset;
+	struct counter *counter, *ncounter;
 
 	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
 		list_del(&chain->list);
@@ -770,6 +885,10 @@ static void table_cleanup(struct table *table)
 		list_del(&set->list);
 		set_free(set);
 	}
+	list_for_each_entry_safe(counter, ncounter, &table->counters, list) {
+		list_del(&counter->list);
+		counter_free(counter);
+	}
 }
 
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
@@ -780,6 +899,8 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
 		goto err;
+	if (do_list_counters(ctx, &cmd->location, table) < 0)
+		goto err;
 	if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
 		goto err;
 	list_splice_tail_init(&ctx->list, &table->chains);
@@ -835,6 +956,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
 	struct set *set;
+	struct counter *counter;
 
 	/* No need to allocate the table object when listing all tables */
 	if (cmd->handle.table != NULL) {
@@ -887,6 +1009,20 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			set_print(set);
 		}
 		return 0;
+	case CMD_OBJ_COUNTERS:
+		if (netlink_list_counters(ctx, &cmd->handle, &cmd->location) < 0)
+			goto err;
+		list_for_each_entry(counter, &ctx->list, list) {
+			counter_print(counter);
+		}
+		return 0;
+	case CMD_OBJ_COUNTER:
+		if (netlink_get_counter(ctx, &cmd->handle, &cmd->location) < 0)
+			goto err;
+		list_for_each_entry(counter, &ctx->list, list) {
+			counter_print(counter);
+		}
+		return 0;
 	case CMD_OBJ_RULESET:
 		return do_list_ruleset(ctx, cmd);
 	default:
@@ -914,6 +1050,21 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+
+	switch (cmd->obj) {
+	case CMD_OBJ_COUNTER:
+		return netlink_reset_counter(ctx, &cmd->handle, &cmd->location);
+	case CMD_OBJ_COUNTERS:
+		return netlink_reset_counters(ctx, &cmd->handle,
+					      &cmd->location);
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+
+	return 0;
+}
 static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
@@ -1024,6 +1175,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
 		return do_command_describe(ctx, cmd);
+	case CMD_RESET:
+		return do_command_reset(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..d11c5e5 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -243,6 +243,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "map"			{ return MAP; }
 "handle"		{ return HANDLE; }
 "ruleset"		{ return RULESET; }
+"counters"		{ return COUNTERS; }
 
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
@@ -279,6 +280,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
+"name"			{ return NAME; }
 
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
diff --git a/src/statement.c b/src/statement.c
index d72c6e9..20c35f0 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -105,8 +105,12 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 
 static void counter_stmt_print(const struct stmt *stmt)
 {
-	printf("counter packets %" PRIu64 " bytes %" PRIu64,
-	       stmt->counter.packets, stmt->counter.bytes);
+	printf("counter ");
+	if (stmt->counter.name)
+		printf("name %s", stmt->counter.name);
+	else
+		printf("packets %" PRIu64 " bytes %" PRIu64,
+		       stmt->counter.packets, stmt->counter.bytes);
 }
 
 static const struct stmt_ops counter_stmt_ops = {
-- 
1.7.10.4

