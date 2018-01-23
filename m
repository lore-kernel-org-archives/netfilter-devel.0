From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/6] src: support for flowtable listing
Date: Tue, 23 Jan 2018 13:16:17 +0100
Message-ID: <20180123121622.16287-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbeAWMQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 07:16:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57ADC2519A2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4103BDA39F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8AA9DA7E0
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:25 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6F15B41E4817
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:25 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to dump existing flowtable.

 # nft list ruleset
 table ip x {
        flowtable x {
                hook ingress priority 10
                devices = { eth0, tap0 }
        }
 }

You can also list existing flowtables via:

 # nft list flowtables
 table ip x {
        flowtable x {
                hook ingress priority 10
                devices = { eth0, tap0 }
        }
 }

 You need a Linux kernel >= 4.16-rc to test this new feature.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |   6 ++
 include/mnl.h                       |   3 +
 include/netlink.h                   |   4 ++
 include/rule.h                      |  24 +++++++
 src/evaluate.c                      |   1 +
 src/mnl.c                           |  58 +++++++++++++++++
 src/netlink.c                       |  65 +++++++++++++++++++
 src/parser_bison.y                  |   6 ++
 src/rule.c                          | 122 ++++++++++++++++++++++++++++++++++++
 src/scanner.l                       |   2 +
 10 files changed, 291 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2efbf9744c2a..b2d36004b85d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -92,6 +92,9 @@ enum nft_verdicts {
  * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
  * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
  * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
+ * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -116,6 +119,9 @@ enum nf_tables_msg_types {
 	NFT_MSG_GETOBJ,
 	NFT_MSG_DELOBJ,
 	NFT_MSG_GETOBJ_RESET,
+	NFT_MSG_NEWFLOWTABLE,
+	NFT_MSG_GETFLOWTABLE,
+	NFT_MSG_DELFLOWTABLE,
 	NFT_MSG_MAX,
 };
 
diff --git a/include/mnl.h b/include/mnl.h
index 4662cd04df9b..4475e7f872d9 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -89,6 +89,9 @@ int mnl_nft_obj_batch_add(struct nftnl_obj *nln, struct nftnl_batch *batch,
 int mnl_nft_obj_batch_del(struct nftnl_obj *nln, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seqnum);
 
+struct nftnl_flowtable_list *
+mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table);
+
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct netlink_ctx *ctx,
 					   uint32_t family);
 int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
diff --git a/include/netlink.h b/include/netlink.h
index 0d71a6b96d82..bca59bbd9ebe 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -181,6 +181,10 @@ extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 			      struct location *loc, uint32_t type);
 
+extern int netlink_list_flowtables(struct netlink_ctx *ctx,
+				   const struct handle *h,
+				   const struct location *loc);
+
 extern void netlink_dump_chain(const struct nftnl_chain *nlc,
 			       struct netlink_ctx *ctx);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr,
diff --git a/include/rule.h b/include/rule.h
index 4e5a349a806a..5ee5389a6c36 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -35,6 +35,7 @@ struct position_spec {
  * @chain:	chain name (chains and rules only)
  * @set:	set name (sets only)
  * @obj:	stateful object name (stateful object only)
+ * @flowtable:	flow table name (flow table only)
  * @handle:	rule handle (rules only)
  * @position:	rule position (rules only)
  * @set_id:	set ID (sets only)
@@ -45,6 +46,7 @@ struct handle {
 	const char		*chain;
 	const char		*set;
 	const char		*obj;
+	const char		*flowtable;
 	struct handle_spec	handle;
 	struct position_spec	position;
 	uint32_t		set_id;
@@ -98,6 +100,7 @@ enum table_flags {
  * @chains:	chains contained in the table
  * @sets:	sets contained in the table
  * @objs:	stateful objects contained in the table
+ * @flowtables:	flow tables contained in the table
  * @flags:	table flags
  * @refcnt:	table reference counter
  */
@@ -109,6 +112,7 @@ struct table {
 	struct list_head	chains;
 	struct list_head	sets;
 	struct list_head	objs;
+	struct list_head	flowtables;
 	enum table_flags 	flags;
 	unsigned int		refcnt;
 };
@@ -313,6 +317,24 @@ void obj_print_plain(const struct obj *obj, struct output_ctx *octx);
 const char *obj_type_name(uint32_t type);
 uint32_t obj_type_to_cmd(uint32_t type);
 
+struct flowtable {
+	struct list_head	list;
+	struct handle		handle;
+	struct location		location;
+	unsigned int		hooknum;
+	int			priority;
+	const char		**dev_array;
+	int			dev_array_len;
+	unsigned int		refcnt;
+};
+
+extern struct flowtable *flowtable_alloc(const struct location *loc);
+extern struct flowtable *flowtable_get(struct flowtable *flowtable);
+extern void flowtable_free(struct flowtable *flowtable);
+extern void flowtable_add_hash(struct flowtable *flowtable, struct table *table);
+
+void flowtable_print(const struct flowtable *n, struct output_ctx *octx);
+
 /**
  * enum cmd_ops - command operations
  *
@@ -371,6 +393,7 @@ enum cmd_ops {
  * @CMD_OBJ_QUOTAS:	multiple quotas
  * @CMD_OBJ_LIMIT:	limit
  * @CMD_OBJ_LIMITS:	multiple limits
+ * @CMD_OBJ_FLOWTABLES:	flow tables
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -397,6 +420,7 @@ enum cmd_obj {
 	CMD_OBJ_CT_HELPERS,
 	CMD_OBJ_LIMIT,
 	CMD_OBJ_LIMITS,
+	CMD_OBJ_FLOWTABLES,
 };
 
 struct markup {
diff --git a/src/evaluate.c b/src/evaluate.c
index 2da589c01a62..a58fca9e6362 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3193,6 +3193,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_HELPERS:
 	case CMD_OBJ_LIMITS:
 	case CMD_OBJ_SETS:
+	case CMD_OBJ_FLOWTABLES:
 		if (cmd->handle.table == NULL)
 			return 0;
 		if (table_lookup(&cmd->handle, ctx->cache) == NULL)
diff --git a/src/mnl.c b/src/mnl.c
index 5587e1589cda..e70b0cdeb723 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -17,6 +17,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
 #include <libnftnl/object.h>
+#include <libnftnl/flowtable.h>
 #include <libnftnl/batch.h>
 
 #include <linux/netfilter/nfnetlink.h>
@@ -953,6 +954,63 @@ int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls)
 	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
 
+static int flowtable_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_flowtable_list *nln_list = data;
+	struct nftnl_flowtable *n;
+
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
+	n = nftnl_flowtable_alloc();
+	if (n == NULL)
+		memory_allocation_error();
+
+	if (nftnl_flowtable_nlmsg_parse(nlh, n) < 0)
+		goto err_free;
+
+	nftnl_flowtable_list_add_tail(n, nln_list);
+	return MNL_CB_OK;
+
+err_free:
+	nftnl_flowtable_free(n);
+	return MNL_CB_OK;
+}
+
+struct nftnl_flowtable_list *
+mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table)
+{
+	struct nftnl_flowtable_list *nln_list;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nftnl_flowtable *n;
+	struct nlmsghdr *nlh;
+	int ret;
+
+	n = nftnl_flowtable_alloc();
+	if (n == NULL)
+		memory_allocation_error();
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
+				    NLM_F_DUMP | NLM_F_ACK, ctx->seqnum);
+	if (table != NULL)
+		nftnl_flowtable_set_str(n, NFTNL_FLOWTABLE_TABLE, table);
+	nftnl_flowtable_nlmsg_build_payload(nlh, n);
+	nftnl_flowtable_free(n);
+
+	nln_list = nftnl_flowtable_list_alloc();
+	if (nln_list == NULL)
+		memory_allocation_error();
+
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, flowtable_cb, nln_list);
+	if (ret < 0)
+		goto err;
+
+	return nln_list;
+err:
+	nftnl_flowtable_list_free(nln_list);
+	return NULL;
+}
+
 /*
  * ruleset
  */
diff --git a/src/netlink.c b/src/netlink.c
index 23f92443f8c4..7b8e48dc341d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -23,6 +23,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/object.h>
 #include <libnftnl/set.h>
+#include <libnftnl/flowtable.h>
 #include <libnftnl/udata.h>
 #include <libnftnl/ruleset.h>
 #include <libnftnl/common.h>
@@ -1815,6 +1816,70 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
+static struct flowtable *
+netlink_delinearize_flowtable(struct netlink_ctx *ctx,
+			      struct nftnl_flowtable *nlo)
+{
+	struct flowtable *flowtable;
+	const char **dev_array;
+	int len = 0, i;
+
+	flowtable = flowtable_alloc(&netlink_location);
+	flowtable->handle.family =
+		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_FAMILY);
+	flowtable->handle.table =
+		xstrdup(nftnl_flowtable_get_str(nlo, NFTNL_FLOWTABLE_TABLE));
+	flowtable->handle.flowtable =
+		xstrdup(nftnl_flowtable_get_str(nlo, NFTNL_FLOWTABLE_NAME));
+	dev_array = nftnl_flowtable_get_array(nlo, NFTNL_FLOWTABLE_DEVICES);
+	while (dev_array[len] != '\0')
+		len++;
+
+	flowtable->dev_array = calloc(1, len * sizeof(char *));
+	for (i = 0; i < len; i++)
+		flowtable->dev_array[i] = xstrdup(dev_array[i]);
+
+	flowtable->dev_array_len = len;
+
+	flowtable->priority =
+		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
+	flowtable->hooknum =
+		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_HOOKNUM);
+
+	return flowtable;
+}
+
+static int list_flowtable_cb(struct nftnl_flowtable *nls, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+	struct flowtable *flowtable;
+
+	flowtable = netlink_delinearize_flowtable(ctx, nls);
+	if (flowtable == NULL)
+		return -1;
+	list_add_tail(&flowtable->list, &ctx->list);
+	return 0;
+}
+
+int netlink_list_flowtables(struct netlink_ctx *ctx, const struct handle *h,
+		      const struct location *loc)
+{
+	struct nftnl_flowtable_list *flowtable_cache;
+	int err;
+
+	flowtable_cache = mnl_nft_flowtable_dump(ctx, h->family, h->table);
+	if (flowtable_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
+		return 0;
+	}
+
+	err = nftnl_flowtable_list_foreach(flowtable_cache, list_flowtable_cb, ctx);
+	nftnl_flowtable_list_free(flowtable_cache);
+	return err;
+}
+
 int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list)
 {
 	return mnl_batch_talk(ctx, err_list);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 009b801f9d6b..4cfa8076cfc4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -247,6 +247,8 @@ int nft_lex(void *, void *, void *);
 %token METER			"meter"
 %token METERS			"meters"
 
+%token FLOWTABLES		"flowtables"
+
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING	"quoted string"
@@ -1103,6 +1105,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_METER, &$2, &@$, NULL);
 			}
+			|       FLOWTABLES      ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLES, &$2, &@$, NULL);
+			}
 			|	MAPS		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAPS, &$2, &@$, NULL);
diff --git a/src/rule.c b/src/rule.c
index f19197fe240d..08ea2c3c9fb5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -95,6 +95,11 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 			return -1;
 		list_splice_tail_init(&ctx->list, &table->chains);
 
+		ret = netlink_list_flowtables(ctx, &table->handle, &internal_location);
+		if (ret < 0)
+			return -1;
+		list_splice_tail_init(&ctx->list, &table->flowtables);
+
 		if (cmd != CMD_RESET) {
 			ret = netlink_list_objs(ctx, &table->handle, &internal_location);
 			if (ret < 0)
@@ -719,6 +724,7 @@ struct table *table_alloc(void)
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
 	init_list_head(&table->objs);
+	init_list_head(&table->flowtables);
 	init_list_head(&table->scope.symbols);
 	table->refcnt = 1;
 
@@ -794,6 +800,7 @@ static void table_print_options(const struct table *table, const char **delim,
 
 static void table_print(const struct table *table, struct output_ctx *octx)
 {
+	struct flowtable *flowtable;
 	struct chain *chain;
 	struct obj *obj;
 	struct set *set;
@@ -815,6 +822,11 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		set_print(set, octx);
 		delim = "\n";
 	}
+	list_for_each_entry(flowtable, &table->flowtables, list) {
+		nft_print(octx, "%s", delim);
+		flowtable_print(flowtable, octx);
+		delim = "\n";
+	}
 	list_for_each_entry(chain, &table->chains, list) {
 		nft_print(octx, "%s", delim);
 		chain_print(chain, octx);
@@ -1478,6 +1490,114 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 	return 0;
 }
 
+struct flowtable *flowtable_alloc(const struct location *loc)
+{
+	struct flowtable *flowtable;
+
+	flowtable = xzalloc(sizeof(*flowtable));
+	if (loc != NULL)
+		flowtable->location = *loc;
+
+	flowtable->refcnt = 1;
+	return flowtable;
+}
+
+struct flowtable *flowtable_get(struct flowtable *flowtable)
+{
+	flowtable->refcnt++;
+	return flowtable;
+}
+
+void flowtable_free(struct flowtable *flowtable)
+{
+	if (--flowtable->refcnt > 0)
+		return;
+	handle_free(&flowtable->handle);
+	xfree(flowtable);
+}
+
+void flowtable_add_hash(struct flowtable *flowtable, struct table *table)
+{
+	list_add_tail(&flowtable->list, &table->flowtables);
+}
+
+static void flowtable_print_declaration(const struct flowtable *flowtable,
+					struct print_fmt_options *opts,
+					struct output_ctx *octx)
+{
+	int i;
+
+	nft_print(octx, "%sflowtable", opts->tab);
+
+	if (opts->family != NULL)
+		nft_print(octx, " %s", opts->family);
+
+	if (opts->table != NULL)
+		nft_print(octx, " %s", opts->table);
+
+	nft_print(octx, " %s {%s", flowtable->handle.flowtable, opts->nl);
+
+	nft_print(octx, "%s%shook %s priority %d%s",
+		  opts->tab, opts->tab, "ingress",
+		  flowtable->priority, opts->stmt_separator);
+
+	nft_print(octx, "%s%sdevices = { ", opts->tab, opts->tab);
+	for (i = 0; i < flowtable->dev_array_len; i++) {
+		nft_print(octx, "%s", flowtable->dev_array[i]);
+		if (i + 1 != flowtable->dev_array_len)
+			nft_print(octx, ", ");
+	}
+	nft_print(octx, " }%s", opts->stmt_separator);
+}
+
+static void do_flowtable_print(const struct flowtable *flowtable,
+			       struct print_fmt_options *opts,
+			       struct output_ctx *octx)
+{
+	flowtable_print_declaration(flowtable, opts, octx);
+	nft_print(octx, "%s}%s", opts->tab, opts->nl);
+}
+
+void flowtable_print(const struct flowtable *s, struct output_ctx *octx)
+{
+	struct print_fmt_options opts = {
+		.tab		= "\t",
+		.nl		= "\n",
+		.stmt_separator	= "\n",
+	};
+
+	do_flowtable_print(s, &opts, octx);
+}
+
+static int do_list_flowtables(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct print_fmt_options opts = {
+		.tab		= "\t",
+		.nl		= "\n",
+		.stmt_separator	= "\n",
+	};
+	struct flowtable *flowtable;
+	struct table *table;
+
+	list_for_each_entry(table, &ctx->cache->list, list) {
+		if (cmd->handle.family != NFPROTO_UNSPEC &&
+		    cmd->handle.family != table->handle.family)
+			continue;
+
+		nft_print(ctx->octx, "table %s %s {\n",
+			  family2str(table->handle.family),
+			  table->handle.table);
+
+		list_for_each_entry(flowtable, &table->flowtables, list) {
+			flowtable_print_declaration(flowtable, &opts, ctx->octx);
+			nft_print(ctx->octx, "%s}%s", opts.tab, opts.nl);
+		}
+
+		nft_print(ctx->octx, "}\n");
+	}
+	return 0;
+}
+
 static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	unsigned int family = cmd->handle.family;
@@ -1625,6 +1745,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_LIMITS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_LIMIT);
+	case CMD_OBJ_FLOWTABLES:
+		return do_list_flowtables(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 5402be1cc2b0..6a1f2f685615 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -296,6 +296,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "meter"			{ return METER; }
 "meters"		{ return METERS; }
 
+"flowtables"		{ return FLOWTABLES; }
+
 "counter"		{ return COUNTER; }
 "name"			{ return NAME; }
 "packets"		{ return PACKETS; }
-- 
2.11.0

