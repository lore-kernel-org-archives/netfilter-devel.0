From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 04/10] src: listing of stateful objects
Date: Fri, 23 Dec 2016 15:26:49 +0100
Message-ID: <1482503215-25422-4-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941139AbcLWO1O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0B442519A7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AACED8E66A
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF1E48E66D
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:09 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to dump existing stateful objects, eg.

 # nft list ruleset
 table ip filter {
        counter test {
                packets 64 bytes 1268
        }

        quota test {
                over 1 mbytes used 1268 bytes
        }

        chain input {
                type filter hook input priority 0; policy accept;
                quota name test drop
                counter name test
        }
 }

 # nft list quotas
 table ip filter {
        quota test {
                over 1 mbytes used 1268 bytes
        }
 }
 # nft list counters
 table ip filter {
        counter test {
                packets 64 bytes 1268
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h       |   2 +
 include/netlink.h   |   4 ++
 include/rule.h      |  51 +++++++++++++++++++
 include/statement.h |   3 ++
 src/evaluate.c      |   2 +
 src/mnl.c           |  59 ++++++++++++++++++++++
 src/netlink.c       |  67 +++++++++++++++++++++++++
 src/parser_bison.y  |  30 ++++++++++-
 src/rule.c          | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l       |   3 ++
 src/statement.c     |   2 +-
 11 files changed, 360 insertions(+), 3 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 87db96afd369..ad036aefabbd 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -86,6 +86,8 @@ int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
 				uint32_t seqnum);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
 
+struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
+					const char *table);
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					 uint32_t family);
 int mnl_nft_event_listener(struct mnl_socket *nf_sock,
diff --git a/include/netlink.h b/include/netlink.h
index 363b5251968f..ce577871761f 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -6,6 +6,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/object.h>
 
 #include <linux/netlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -168,6 +169,9 @@ extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 extern int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				  const struct location *loc);
 
+extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
+			       const struct location *loc);
+
 extern void netlink_dump_table(const struct nftnl_table *nlt);
 extern void netlink_dump_chain(const struct nftnl_chain *nlc);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr);
diff --git a/include/rule.h b/include/rule.h
index f74630c53d2b..e0f891393276 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -34,6 +34,7 @@ struct position_spec {
  * @table:	table name
  * @chain:	chain name (chains and rules only)
  * @set:	set name (sets only)
+ * @obj:	stateful object name (stateful object only)
  * @handle:	rule handle (rules only)
  * @position:	rule position (rules only)
  * @set_id:	set ID (sets only)
@@ -43,6 +44,7 @@ struct handle {
 	const char		*table;
 	const char		*chain;
 	const char		*set;
+	const char		*obj;
 	struct handle_spec	handle;
 	struct position_spec	position;
 	uint32_t		set_id;
@@ -95,6 +97,7 @@ enum table_flags {
  * @location:	location the table was defined at
  * @chains:	chains contained in the table
  * @sets:	sets contained in the table
+ * @objs:	stateful objects contained in the table
  * @flags:	table flags
  * @refcnt:	table reference counter
  */
@@ -105,6 +108,7 @@ struct table {
 	struct scope		scope;
 	struct list_head	chains;
 	struct list_head	sets;
+	struct list_head	objs;
 	enum table_flags 	flags;
 	unsigned int		refcnt;
 };
@@ -241,6 +245,45 @@ extern struct set *set_lookup_global(uint32_t family, const char *table,
 extern void set_print(const struct set *set);
 extern void set_print_plain(const struct set *s);
 
+#include <statement.h>
+
+struct counter {
+	uint64_t	packets;
+	uint64_t	bytes;
+};
+
+struct quota {
+	uint64_t	bytes;
+	uint64_t	used;
+	uint32_t	flags;
+};
+
+/**
+ * struct obj - nftables stateful object statement
+ *
+ * @list:	table set list node
+ * @location:	location the stateful object was defined/declared at
+ * @handle:	counter handle
+ * @type:	type of stateful object
+ */
+struct obj {
+	struct list_head		list;
+	struct location			location;
+	struct handle			handle;
+	uint32_t			type;
+
+	union {
+		struct counter		counter;
+		struct quota		quota;
+	};
+};
+
+struct obj *obj_alloc(const struct location *loc);
+void obj_free(struct obj *obj);
+void obj_add_hash(struct obj *obj, struct table *table);
+void obj_print(const struct obj *n);
+const char *obj_type_name(enum stmt_types type);
+
 /**
  * enum cmd_ops - command operations
  *
@@ -287,6 +330,10 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_COUNTER:	counter
+ * @CMD_OBJ_COUNTERS:	multiple counters
+ * @CMD_OBJ_QUOTA:	quota
+ * @CMD_OBJ_QUOTAS:	multiple quotas
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -305,6 +352,10 @@ enum cmd_obj {
 	CMD_OBJ_FLOWTABLES,
 	CMD_OBJ_MAP,
 	CMD_OBJ_MAPS,
+	CMD_OBJ_COUNTER,
+	CMD_OBJ_COUNTERS,
+	CMD_OBJ_QUOTA,
+	CMD_OBJ_QUOTAS,
 };
 
 struct export {
diff --git a/include/statement.h b/include/statement.h
index d317ae368164..9d0f601f98a2 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -66,6 +66,7 @@ struct limit_stmt {
 };
 
 extern struct stmt *limit_stmt_alloc(const struct location *loc);
+extern void __limit_stmt_print(const struct limit_stmt *limit);
 
 struct reject_stmt {
 	struct expr		*expr;
@@ -301,4 +302,6 @@ extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt);
 
+const char *get_rate(uint64_t byte_rate, uint64_t *rate);
+
 #endif /* NFTABLES_STATEMENT_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 557c61c814df..b3630c303920 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2845,6 +2845,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_OBJ_CHAINS:
 	case CMD_OBJ_SETS:
+	case CMD_OBJ_COUNTERS:
+	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_RULESET:
 	case CMD_OBJ_FLOWTABLES:
 	case CMD_OBJ_MAPS:
diff --git a/src/mnl.c b/src/mnl.c
index 257b630e2a26..534d02f4ff32 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -16,6 +16,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/object.h>
 #include <libnftnl/batch.h>
 
 #include <linux/netfilter/nfnetlink.h>
@@ -795,6 +796,64 @@ err:
 	return NULL;
 }
 
+static int obj_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_obj_list *nln_list = data;
+	struct nftnl_obj *n;
+
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
+	n = nftnl_obj_alloc();
+	if (n == NULL)
+		memory_allocation_error();
+
+	if (nftnl_obj_nlmsg_parse(nlh, n) < 0)
+		goto err_free;
+
+	nftnl_obj_list_add_tail(n, nln_list);
+	return MNL_CB_OK;
+
+err_free:
+	nftnl_obj_free(n);
+	return MNL_CB_OK;
+}
+
+
+struct nftnl_obj_list *
+mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table)
+{
+	struct nftnl_obj_list *nln_list;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nftnl_obj *n;
+	struct nlmsghdr *nlh;
+	int ret;
+
+	n = nftnl_obj_alloc();
+	if (n == NULL)
+		memory_allocation_error();
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
+				    NLM_F_DUMP | NLM_F_ACK, seq);
+	if (table != NULL)
+		nftnl_obj_set(n, NFTNL_OBJ_TABLE, table);
+	nftnl_obj_nlmsg_build_payload(nlh, n);
+	nftnl_obj_free(n);
+
+	nln_list = nftnl_obj_list_alloc();
+	if (nln_list == NULL)
+		memory_allocation_error();
+
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, obj_cb, nln_list);
+	if (ret < 0)
+		goto err;
+
+	return nln_list;
+err:
+	nftnl_obj_list_free(nln_list);
+	return NULL;
+}
+
 static int set_get_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nftnl_set *s = data;
diff --git a/src/netlink.c b/src/netlink.c
index e37d3bf124a6..bbf675f90def 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1608,6 +1608,73 @@ out:
 	return err;
 }
 
+static struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
+					   struct nftnl_obj *nlo)
+{
+	struct obj *obj;
+	uint32_t type;
+
+	obj = obj_alloc(&netlink_location);
+	obj->handle.family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
+	obj->handle.table =
+		xstrdup(nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE));
+	obj->handle.obj =
+		xstrdup(nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
+
+	type = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
+	switch (type) {
+	case NFT_OBJECT_COUNTER:
+		obj->counter.packets =
+			nftnl_obj_get_u64(nlo, NFTNL_OBJ_CTR_PKTS);
+		obj->counter.bytes =
+			nftnl_obj_get_u64(nlo, NFTNL_OBJ_CTR_BYTES);
+		break;
+	case NFT_OBJECT_QUOTA:
+		obj->quota.bytes =
+			nftnl_obj_get_u64(nlo, NFTNL_OBJ_QUOTA_BYTES);
+		obj->quota.used =
+			nftnl_obj_get_u64(nlo, NFTNL_OBJ_QUOTA_CONSUMED);
+		obj->quota.flags =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_QUOTA_FLAGS);
+	}
+	obj->type = type;
+
+	return obj;
+}
+
+static int list_obj_cb(struct nftnl_obj *nls, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+	struct obj *obj;
+
+	obj = netlink_delinearize_obj(ctx, nls);
+	if (obj == NULL)
+		return -1;
+	list_add_tail(&obj->list, &ctx->list);
+	return 0;
+}
+
+int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
+		      const struct location *loc)
+{
+	struct nftnl_obj_list *obj_cache;
+	int err;
+
+	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table);
+	if (obj_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
+		return netlink_io_error(ctx, loc,
+					"Could not receive stateful object from kernel: %s",
+					strerror(errno));
+	}
+
+	err = nftnl_obj_list_foreach(obj_cache, list_obj_cb, ctx);
+	nftnl_obj_list_free(obj_cache);
+	return err;
+}
+
 int netlink_batch_send(struct list_head *err_list)
 {
 	return mnl_batch_talk(nf_sock, err_list);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index aea6e47d8b12..2213f3808db4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -364,6 +364,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token PACKETS			"packets"
 %token BYTES			"bytes"
 
+%token COUNTERS			"counters"
+%token QUOTAS			"quotas"
+
 %token LOG			"log"
 %token PREFIX			"prefix"
 %token GROUP			"group"
@@ -441,8 +444,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
-%type <handle>			set_spec set_identifier
-%destructor { handle_free(&$$); } set_spec set_identifier
+%type <handle>			set_spec set_identifier obj_spec
+%destructor { handle_free(&$$); } set_spec set_identifier obj_spec
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
 
 %type <string>			dev_spec quota_unit
@@ -872,6 +875,22 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	COUNTERS	ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
+			}
+			|	COUNTER		obj_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
+			|	QUOTAS		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
+			}
+			|	QUOTA		obj_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTA, &$2, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
@@ -1299,6 +1318,13 @@ set_identifier		:	identifier
 			}
 			;
 
+obj_spec		:	table_spec	identifier
+			{
+				$$		= $1;
+				$$.obj		= $2;
+			}
+			;
+
 handle_spec		:	HANDLE		NUM
 			{
 				memset(&$$, 0, sizeof($$));
diff --git a/src/rule.c b/src/rule.c
index 988305b57615..05f0eb87b162 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -93,6 +93,12 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 			return -1;
 		list_splice_tail_init(&ctx->list, &table->chains);
 
+		/* Don't check for errors on listings, this would break nft with
+		 * old kernels with no stateful object support.
+		 */
+		netlink_list_objs(ctx, &table->handle, &internal_location);
+		list_splice_tail_init(&ctx->list, &table->objs);
+
 		/* Skip caching other objects to speed up things: We only need
 		 * a full cache when listing the existing ruleset.
 		 */
@@ -688,6 +694,7 @@ struct table *table_alloc(void)
 	table = xzalloc(sizeof(*table));
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
+	init_list_head(&table->objs);
 	init_list_head(&table->scope.symbols);
 	table->refcnt = 1;
 
@@ -762,6 +769,7 @@ static void table_print_options(const struct table *table, const char **delim)
 static void table_print(const struct table *table)
 {
 	struct chain *chain;
+	struct obj *obj;
 	struct set *set;
 	const char *delim = "";
 	const char *family = family2str(table->handle.family);
@@ -769,6 +777,11 @@ static void table_print(const struct table *table)
 	printf("table %s %s {\n", family, table->handle.table);
 	table_print_options(table, &delim);
 
+	list_for_each_entry(obj, &table->objs, list) {
+		printf("%s", delim);
+		obj_print(obj);
+		delim = "\n";
+	}
 	list_for_each_entry(set, &table->sets, list) {
 		if (set->flags & NFT_SET_ANONYMOUS)
 			continue;
@@ -1098,6 +1111,129 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+struct obj *obj_alloc(const struct location *loc)
+{
+	struct obj *obj;
+
+	obj = xzalloc(sizeof(*obj));
+	if (loc != NULL)
+		obj->location = *loc;
+	return obj;
+}
+
+void obj_free(struct obj *obj)
+{
+	handle_free(&obj->handle);
+	xfree(obj);
+}
+
+void obj_add_hash(struct obj *obj, struct table *table)
+{
+	list_add_tail(&obj->list, &table->objs);
+}
+
+static void obj_print_data(const struct obj *obj,
+			   struct print_fmt_options *opts)
+{
+	switch (obj->type) {
+	case NFT_OBJECT_COUNTER:
+		printf(" %s {%s%s%s", obj->handle.obj,
+				      opts->nl, opts->tab, opts->tab);
+		printf("packets %"PRIu64" bytes %"PRIu64"",
+		       obj->counter.packets, obj->counter.bytes);
+		break;
+	case NFT_OBJECT_QUOTA: {
+		const char *data_unit;
+		uint64_t bytes;
+
+		printf(" %s {%s%s%s", obj->handle.obj,
+				      opts->nl, opts->tab, opts->tab);
+		data_unit = get_rate(obj->quota.bytes, &bytes);
+		printf("%s%"PRIu64" %s",
+		       obj->quota.flags & NFT_QUOTA_F_INV ? "over " : "",
+		       bytes, data_unit);
+		if (obj->quota.used) {
+			data_unit = get_rate(obj->quota.used, &bytes);
+			printf(" used %"PRIu64" %s", bytes, data_unit);
+		}
+		}
+		break;
+	default:
+		printf("unknown {%s", opts->nl);
+		break;
+	}
+}
+
+static const char *obj_type_name_array[] = {
+	[NFT_OBJECT_COUNTER]	= "counter",
+	[NFT_OBJECT_QUOTA]	= "quota",
+};
+
+const char *obj_type_name(enum stmt_types type)
+{
+	assert(type <= NFT_OBJECT_QUOTA && obj_type_name_array[type]);
+
+	return obj_type_name_array[type];
+}
+
+static void obj_print_declaration(const struct obj *obj,
+				  struct print_fmt_options *opts)
+{
+	printf("%s%s", opts->tab, obj_type_name(obj->type));
+
+	if (opts->family != NULL)
+		printf(" %s", opts->family);
+
+	if (opts->table != NULL)
+		printf(" %s", opts->table);
+
+	obj_print_data(obj, opts);
+
+	printf("%s%s}%s", opts->nl, opts->tab, opts->nl);
+}
+
+void obj_print(const struct obj *obj)
+{
+	struct print_fmt_options opts = {
+		.tab		= "\t",
+		.nl		= "\n",
+		.stmt_separator	= "\n",
+	};
+
+	obj_print_declaration(obj, &opts);
+}
+
+static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
+{
+	struct print_fmt_options opts = {
+		.tab		= "\t",
+		.nl		= "\n",
+		.stmt_separator	= "\n",
+	};
+	struct table *table;
+	struct obj *obj;
+
+	list_for_each_entry(table, &table_list, list) {
+		if (cmd->handle.family != NFPROTO_UNSPEC &&
+		    cmd->handle.family != table->handle.family)
+			continue;
+
+		printf("table %s %s {\n",
+		       family2str(table->handle.family),
+		       table->handle.table);
+
+		list_for_each_entry(obj, &table->objs, list) {
+			if (obj->type != type)
+				continue;
+
+			obj_print_declaration(obj, &opts);
+		}
+
+		printf("}\n");
+	}
+	return 0;
+}
+
 static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	unsigned int family = cmd->handle.family;
@@ -1230,6 +1366,10 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_MAP:
 		return do_list_set(ctx, cmd, table);
+	case CMD_OBJ_COUNTERS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_COUNTER);
+	case CMD_OBJ_QUOTAS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 8aa4b08ba8fc..cb9893203244 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -293,6 +293,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
 
+"counters"		{ return COUNTERS; }
+"quotas"		{ return QUOTAS; }
+
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
 "group"			{ return GROUP; }
diff --git a/src/statement.c b/src/statement.c
index 4d3ca55a4081..fbd78aafe69a 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -255,7 +255,7 @@ static const char *data_unit[] = {
 	NULL
 };
 
-static const char *get_rate(uint64_t byte_rate, uint64_t *rate)
+const char *get_rate(uint64_t byte_rate, uint64_t *rate)
 {
 	uint64_t res, prev, rest;
 	int i;
-- 
2.1.4

