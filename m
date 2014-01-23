From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v3] This patch adds the following operation:
Date: Thu, 23 Jan 2014 10:49:27 +0100
Message-ID: <20140123094743.17227.18043.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34952 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751157AbaAWJtn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:49:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 :~# nft export <xml|json>

The XML/JSON output is provided raw by libnftnl, thus without format.

In case of XML, you can give format with the `xmllint' tool from libxml2-tools:
 :~# nft list ruleset xml | xmllint --format -

In case of JSON, you can use `json_pp' from perl standar package:
 :~# nft list ruleset json | json_pp

A format field is added in struct cmd, and it will be reused in the import
operation.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: address comments by Patrick: use CMD_OBJ_RULESET, move some includes, etc.
v3: rebase against nft's next-3.14 branch.

 include/mnl.h     |    2 ++
 include/netlink.h |    3 ++
 include/rule.h    |    6 +++++
 src/evaluate.c    |    1 +
 src/mnl.c         |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 src/netlink.c     |   17 ++++++++++++++
 src/parser.y      |   23 +++++++++++++++++--
 src/rule.c        |   20 +++++++++++++++++
 src/scanner.l     |    4 +++
 9 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index a630605..f4de27d 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -65,4 +65,6 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			   unsigned int flags);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
+struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
+					 uint32_t family);
 #endif /* _NFTABLES_MNL_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 3f8d465..84b2487 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -136,4 +136,7 @@ extern int netlink_batch_send(struct list_head *err_list);
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
 
+extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
+						const struct handle *h,
+						const struct location *loc);
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 30a4d12..47dd6ab 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -205,6 +205,7 @@ extern void set_print(const struct set *set);
  * @CMD_LIST:		list container
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
+ * @CMD_EXPORT:		export the ruleset in a given format
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -215,6 +216,7 @@ enum cmd_ops {
 	CMD_LIST,
 	CMD_FLUSH,
 	CMD_RENAME,
+	CMD_EXPORT,
 };
 
 /**
@@ -227,6 +229,7 @@ enum cmd_ops {
  * @CMD_OBJ_RULE:	rule
  * @CMD_OBJ_CHAIN:	chain
  * @CMD_OBJ_TABLE:	table
+ * @CMD_OBJ_RULESET:	ruleset
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -236,6 +239,7 @@ enum cmd_obj {
 	CMD_OBJ_RULE,
 	CMD_OBJ_CHAIN,
 	CMD_OBJ_TABLE,
+	CMD_OBJ_RULESET,
 };
 
 /**
@@ -249,6 +253,7 @@ enum cmd_obj {
  * @seqnum:	sequence number to match netlink errors
  * @union:	object
  * @arg:	argument data
+ * @format:	info about the export/import format
  */
 struct cmd {
 	struct list_head	list;
@@ -266,6 +271,7 @@ struct cmd {
 		struct table	*table;
 	};
 	const void		*arg;
+	uint32_t		format;
 };
 
 extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
diff --git a/src/evaluate.c b/src/evaluate.c
index cf30ed9..215a004 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1405,6 +1405,7 @@ static int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_LIST:
 	case CMD_FLUSH:
 	case CMD_RENAME:
+	case CMD_EXPORT:
 		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
diff --git a/src/mnl.c b/src/mnl.c
index 7ac1fc5..3f092ed 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -9,6 +9,8 @@
  */
 
 #include <libmnl/libmnl.h>
+#include <libnftnl/common.h>
+#include <libnftnl/ruleset.h>
 #include <libnftnl/table.h>
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
@@ -645,7 +647,8 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 
 	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 				      NLM_F_DUMP|NLM_F_ACK, seq);
-	nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
+	if (table != NULL)
+		nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
 	nft_set_nlmsg_build_payload(nlh, s);
 	nft_set_free(s);
 
@@ -733,3 +736,62 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
+
+/*
+ * ruleset
+ */
+struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
+					 uint32_t family)
+{
+	struct nft_ruleset *rs;
+	struct nft_table_list *t;
+	struct nft_chain_list *c;
+	struct nft_set_list *sl;
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+	struct nft_rule_list *r;
+	int ret = 0;
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
+	sl = mnl_nft_set_dump(nf_sock, family, NULL);
+	if (sl != NULL) {
+		i = nft_set_list_iter_create(sl);
+		s = nft_set_list_iter_next(i);
+		while (s != NULL) {
+			ret = mnl_nft_setelem_get(nf_sock, s);
+			if (ret != 0)
+				goto out;
+
+			s = nft_set_list_iter_next(i);
+		}
+		nft_set_list_iter_destroy(i);
+
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, sl);
+	}
+
+	r = mnl_nft_rule_dump(nf_sock, family);
+	if (r != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
+
+	if (!(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) &&
+	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) &&
+	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST)) &&
+	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)))
+		goto out;
+
+	return rs;
+out:
+	nft_ruleset_free(rs);
+	return NULL;
+}
diff --git a/src/netlink.c b/src/netlink.c
index 84be505..98e7fc6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -13,12 +13,15 @@
 #include <fcntl.h>
 #include <errno.h>
 #include <libmnl/libmnl.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
 
 #include <libnftnl/table.h>
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter.h>
 
 #include <nftables.h>
 #include <netlink.h>
@@ -1050,3 +1053,17 @@ int netlink_batch_send(struct list_head *err_list)
 {
 	return mnl_batch_talk(nf_sock, err_list);
 }
+
+struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
+					 const struct handle *h,
+					 const struct location *loc)
+{
+	struct nft_ruleset *rs;
+
+	rs = mnl_nft_ruleset_dump(nf_sock, h->family);
+	if (rs == NULL)
+		netlink_io_error(ctx, loc, "Could not receive ruleset: %s",
+				 strerror(errno));
+
+	return rs;
+}
diff --git a/src/parser.y b/src/parser.y
index cd9ade1..24f022a 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -18,6 +18,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <libnftnl/common.h>
 
 #include <rule.h>
 #include <statement.h>
@@ -176,6 +177,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token FLUSH			"flush"
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
+%token EXPORT			"export"
 
 %token ACCEPT			"accept"
 %token DROP			"drop"
@@ -346,14 +348,17 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token POSITION			"position"
 
+%token XML			"xml"
+%token JSON			"json"
+
 %type <string>			identifier string
 %destructor { xfree($$); }	identifier string
 
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
@@ -476,6 +481,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
+%type <val>			export_format
+
 %%
 
 input			:	/* empty */
@@ -544,6 +551,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	LIST		list_cmd	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
+			|	EXPORT		export_cmd	{ $$ = $2; }
 			|	DESCRIBE	primary_expr
 			{
 				expr_describe($2);
@@ -703,6 +711,14 @@ rename_cmd		:	CHAIN		chain_spec	identifier
 			}
 			;
 
+export_cmd		:	export_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_RULESET, &h, &@$, NULL);
+				$$->format = $1;
+			}
+			;
+
 table_block_alloc	:	/* empty */
 			{
 				$$ = table_alloc();
@@ -1914,4 +1930,7 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
+export_format		: 	XML 		{ $$ = NFT_OUTPUT_XML; }
+			|	JSON		{ $$ = NFT_OUTPUT_JSON; }
+			;
 %%
diff --git a/src/rule.c b/src/rule.c
index 18d72d9..657695a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -18,7 +18,10 @@
 #include <statement.h>
 #include <rule.h>
 #include <utils.h>
+#include <netlink.h>
 
+#include <libnftnl/common.h>
+#include <libnftnl/ruleset.h>
 #include <netinet/ip.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
@@ -589,6 +592,21 @@ static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
 	return 0;
 }
 
+static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct nft_ruleset *rs = netlink_dump_ruleset(ctx, &cmd->handle,
+						      &cmd->location);
+
+	if (rs == NULL)
+		return -1;
+
+	nft_ruleset_fprintf(stdout, rs, cmd->format, 0);
+	fprintf(stdout, "\n");
+
+	nft_ruleset_free(rs);
+	return 0;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
@@ -741,6 +759,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_flush(ctx, cmd);
 	case CMD_RENAME:
 		return do_command_rename(ctx, cmd);
+	case CMD_EXPORT:
+		return do_command_export(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index f133f23..47ab1e2 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -255,6 +255,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "list"			{ return LIST; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
+"export"		{ return EXPORT; }
 
 "position"		{ return POSITION; }
 
@@ -411,6 +412,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
 
+"xml"			{ return XML; }
+"json"			{ return JSON; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;

