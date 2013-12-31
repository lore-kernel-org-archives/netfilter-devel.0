From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] src: add support for listing the entire ruleset
Date: Tue, 31 Dec 2013 19:40:02 +0100
Message-ID: <20131231184002.25829.99216.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49548 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755555Ab3LaSkN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:40:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add the following operation:

 :~# nft list ruleset [xml|json]

With this, you can backup your current ruleset in 3 formats:
 * nft standar/default
 * xml
 * json

The XML/JSON output is provided raw by libnftables, thus without format.
In case of XML, you can give format with the `xmllint' tool from libxml2-tools:
 :~# nft list ruleset xml | xmllint --format -
In case of JSON, you can use `json_pp' from perl standar package:
 :~# nft list ruleset json | json_pp

Exporting your ruleset gives the possibility of a later import. In default
nft format, the workflow is as follow:

 :~# nft list ruleset > ruleset.nft
 :~# nft -f ruleset.nft

In XML/JSON format, the import operation is currently under development.

About this implementation:

By now, `struct netlink_ctx' can't handle a complete ruleset, so the ruleset
listing operation is done as follow.

if XML/JSON:
 * Obtain the ruleset from the kernel, 4 queries (one per object type),
   using NFPROTO_UNSPEC. Note that this requires sets to be fetched with
   NFPROTO_UNSPECT. This is an incoming kernel patch.
 * Call libnftables's nft_ruleset_fprintf() directly.

if default nft format:
 * Obtain tables from kernel, using NFPROTO_UNSPEC (one netlink query).
 * Iterate these obtained tables calling recursively do_command_list(). This is
   done by filling a temporal netlink_ctx, and using it as an index.
 * Proceed normally as when listing one single table (several netlink queries).

I would prefer to have just one path to print the ruleset, but I can't avoid
modifying netlink_ctx, and seems a major change to me.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/linux/netfilter.h |    2 ++
 include/mnl.h             |    1 +
 include/netlink.h         |    5 +++++
 include/rule.h            |    1 +
 src/mnl.c                 |   40 +++++++++++++++++++++++++++++++++++++++-
 src/netlink.c             |   12 +++++++++++-
 src/parser.y              |   37 +++++++++++++++++++++++++++++++++++--
 src/rule.c                |   45 +++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l             |    4 ++++
 9 files changed, 143 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2eb00b6..b4c84b1 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_NETFILTER_H
 #define __LINUX_NETFILTER_H
 
+#include <netinet/in.h>
+#include <arpa/inet.h>
 #include <linux/types.h>
 
 
diff --git a/include/mnl.h b/include/mnl.h
index fe2fb40..34d9cb2 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -65,4 +65,5 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			   unsigned int flags);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
+struct nft_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock, uint32_t family);
 #endif /* _NFTABLES_MNL_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 85e8434..3dd6c4f 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -1,6 +1,10 @@
 #ifndef NFTABLES_NETLINK_H
 #define NFTABLES_NETLINK_H
 
+#include <stdint.h>
+
+#include <libnftables/common.h>
+#include <libnftables/ruleset.h>
 #include <libnftables/table.h>
 #include <libnftables/chain.h>
 #include <libnftables/rule.h>
@@ -136,4 +140,5 @@ extern int netlink_batch_send(struct list_head *err_list);
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
 
+extern struct nft_ruleset *netlink_dump_ruleset(void);
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 6ad8af3..28b45ce 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -234,6 +234,7 @@ enum cmd_obj {
 	CMD_OBJ_RULE,
 	CMD_OBJ_CHAIN,
 	CMD_OBJ_TABLE,
+	CMD_OBJ_RULESET,
 };
 
 /**
diff --git a/src/mnl.c b/src/mnl.c
index a711b5e..e1310c5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -9,6 +9,8 @@
  */
 
 #include <libmnl/libmnl.h>
+#include <libnftables/common.h>
+#include <libnftables/ruleset.h>
 #include <libnftables/table.h>
 #include <libnftables/chain.h>
 #include <libnftables/rule.h>
@@ -643,7 +645,8 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 
 	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 				      NLM_F_DUMP|NLM_F_ACK, seq);
-	nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
+	if (table != NULL)
+		nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
 	nft_set_nlmsg_build_payload(nlh, s);
 	nft_set_free(s);
 
@@ -731,3 +734,38 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
+
+/*
+ * ruleset
+ */
+struct nft_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock,
+				     uint32_t family)
+{
+	struct nft_ruleset *rs;
+	struct nft_table_list *t;
+	struct nft_chain_list *c;
+	struct nft_set_list *s;
+	struct nft_rule_list *r;
+
+	rs = nft_ruleset_alloc();
+	if (rs == NULL)
+		memory_allocation_error();
+
+	t = mnl_nft_table_dump(nf_sock, family);
+	if (t != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, t);
+
+	c = mnl_nft_chain_dump(nf_sock, family);
+	if (c != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
+
+	s = mnl_nft_set_dump(nf_sock, family, NULL);
+	if (s != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, s);
+
+	r = mnl_nft_rule_dump(nf_sock, family);
+	if (r != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
+
+	return rs;
+}
diff --git a/src/netlink.c b/src/netlink.c
index 59bd8e4..c73d362 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -19,7 +19,7 @@
 #include <libnftables/expr.h>
 #include <libnftables/set.h>
 #include <linux/netfilter/nf_tables.h>
-
+#include <linux/netfilter.h>
 #include <nftables.h>
 #include <netlink.h>
 #include <mnl.h>
@@ -1048,3 +1048,13 @@ int netlink_batch_send(struct list_head *err_list)
 {
 	return mnl_batch_talk(nf_sock, err_list);
 }
+
+struct nft_ruleset *netlink_dump_ruleset(void)
+{
+	struct nft_ruleset *rs = nft_ruleset_alloc();
+
+	if (rs == NULL)
+		memory_allocation_error();
+
+	return mnl_ruleset_dump(nf_sock, NFPROTO_UNSPEC);
+}
diff --git a/src/parser.y b/src/parser.y
index 26e71e3..2628cde 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -18,6 +18,8 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 
+#include <libnftables/common.h>
+
 #include <rule.h>
 #include <statement.h>
 #include <expression.h>
@@ -158,6 +160,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token HOOK			"hook"
 %token TABLE			"table"
 %token TABLES			"tables"
+%token RULESET			"ruleset"
 %token CHAIN			"chain"
 %token RULE			"rule"
 %token SETS			"sets"
@@ -332,6 +335,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token POSITION			"position"
 
+%token XML			"xml"
+%token JSON			"json"
+
 %type <string>			identifier string
 %destructor { xfree($$); }	identifier string
 
@@ -341,8 +347,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
 
-%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
-%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
+%type <handle>			table_spec tables_spec ruleset_spec chain_spec chain_identifier ruleid_spec
+%destructor { handle_free(&$$); } table_spec tables_spec ruleset_spec chain_spec chain_identifier ruleid_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			handle_spec family_spec position_spec
@@ -457,6 +463,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
+%type <val>			export_format
+
 %%
 
 input			:	/* empty */
@@ -623,6 +631,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
+			|	RULESET		ruleset_spec	export_format
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, &$3);
+			}
 			|	CHAIN		chain_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAIN, &$2, &@$, NULL);
@@ -838,6 +850,14 @@ tables_spec		:	family_spec
 			}
 			;
 
+ruleset_spec		:
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.family	= NFPROTO_UNSPEC;
+				$$.table	= NULL;
+			}
+			;
+
 chain_spec		:	table_spec	identifier
 			{
 				$$		= $1;
@@ -1751,4 +1771,17 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
+export_format		: /* default */
+			{
+				$$ = 0;
+			}
+			| XML
+			{
+				$$ = NFT_OUTPUT_XML;
+			}
+			| JSON
+			{
+				$$ = NFT_OUTPUT_JSON;
+			}
+			;
 %%
diff --git a/src/rule.c b/src/rule.c
index ec8b6a4..e141dc2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -18,6 +18,10 @@
 #include <statement.h>
 #include <rule.h>
 #include <utils.h>
+#include <netlink.h>
+
+#include <libnftables/common.h>
+#include <libnftables/ruleset.h>
 
 #include <netinet/ip.h>
 #include <linux/netfilter.h>
@@ -441,6 +445,8 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_TABLE:
 			table_free(cmd->table);
 			break;
+		case CMD_OBJ_RULESET:
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -577,12 +583,28 @@ static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
 	return 0;
 }
 
+static int do_list_formatted_ruleset(uint32_t format)
+{
+	struct nft_ruleset *rs = netlink_dump_ruleset();
+
+	if (rs == NULL)
+		return -1;
+
+	nft_ruleset_fprintf(stdout, rs, format, 0);
+	fprintf(stdout, "\n");
+
+	nft_ruleset_free(rs);
+	return 0;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
 	struct chain *chain, *nchain;
 	struct rule *rule, *nrule;
 	struct set *set, *nset;
+	struct netlink_ctx ctx_index;
+	uint32_t format;
 
 	/* No need to allocate the table object when listing all tables */
 	if (cmd->handle.table != NULL) {
@@ -595,6 +617,29 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 
 	switch (cmd->obj) {
+	case CMD_OBJ_RULESET:
+		format = *(uint32_t *)cmd->data;
+		if (format != 0)
+			return do_list_formatted_ruleset(format);
+
+		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
+			return -1;
+
+		init_list_head(&ctx_index.list);
+		ctx_index.msgs = ctx->msgs;
+		ctx_index.seqnum = cmd->seqnum;
+
+		cmd->obj = CMD_OBJ_TABLE;
+
+		list_for_each_entry(table, &ctx->list, list) {
+			cmd->handle.family = table->handle.family;
+			cmd->handle.table = table->handle.table;
+			if (do_command_list(&ctx_index, cmd) != 0)
+				return -1;
+		}
+
+		cmd->obj = CMD_OBJ_RULESET;
+		return 0;
 	case CMD_OBJ_TABLE:
 		if (!cmd->handle.table) {
 			/* List all existing tables */
diff --git a/src/scanner.l b/src/scanner.l
index cee6aa6..c9e9478 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -220,6 +220,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "hook"			{ return HOOK; }
 "table"			{ return TABLE; }
 "tables"		{ return TABLES; }
+"ruleset"		{ return RULESET; }
 "chain"			{ return CHAIN; }
 "rule"			{ return RULE; }
 "sets"			{ return SETS; }
@@ -386,6 +387,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
 
+"xml"			{ return XML; }
+"json"			{ return JSON; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;

