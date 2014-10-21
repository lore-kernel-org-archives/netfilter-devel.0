From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nft PATCH] src: add import operation
Date: Tue, 21 Oct 2014 13:25:47 +0200
Message-ID: <20141021112420.11406.7309.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39442 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755251AbaJUL0C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:26:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The import operation reads a XML or JSON file, with syntax:
 % nft import {xml|json}

A basic way to test this new functionality is:
 % nft export xml | nft import xml

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---

NOTE: This patchs requires:
	* [nft] mnl: delete useless parameter nf_sock in batch functions
	* [libnftnl] ruleset: deconstify _get interface

Please comment :-)

 include/mnl.h     |   12 ++++
 include/netlink.h |    4 +
 include/rule.h    |   13 ++++
 src/evaluate.c    |    1 
 src/mnl.c         |  170 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 src/netlink.c     |   64 ++++++++++++++++++++
 src/parser.y      |   20 +++++-
 src/rule.c        |   52 ++++++++++++++++
 src/scanner.l     |    1 
 9 files changed, 330 insertions(+), 7 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index a0dfa1b..4126f18 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -24,6 +24,8 @@ void mnl_batch_end(void);
 int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list);
 int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum);
+int mnl_nft_rule_list_batch_add(struct nft_rule_list *nlrl,
+				unsigned int flags);
 int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum);
 
@@ -38,6 +40,8 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 		      unsigned int flags);
 int mnl_nft_chain_batch_add(struct nft_chain *nlc,
 			    unsigned int flags, uint32_t seq);
+int mnl_nft_chain_list_batch_add(struct nft_chain_list *nlcl,
+				 unsigned int flags);
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
                          unsigned int flags);
 int mnl_nft_chain_batch_del(struct nft_chain *nlc,
@@ -51,6 +55,8 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags);
 int mnl_nft_table_batch_add(struct nft_table *nlt,
 			    unsigned int flags, uint32_t seq);
+int mnl_nft_table_list_batch_add(struct nft_table_list *nltl,
+				 unsigned int flags);
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 			 unsigned int flags);
 int mnl_nft_table_batch_del(struct nft_table *nlt,
@@ -64,6 +70,7 @@ int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 		    unsigned int flags);
 int mnl_nft_set_batch_add(struct nft_set *nls,
 			  unsigned int flags, uint32_t seq);
+int mnl_nft_set_list_batch_add(struct nft_set_list *nlsl, unsigned int flags);
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 		       unsigned int flags);
 int mnl_nft_set_batch_del(struct nft_set *nls,
@@ -76,6 +83,8 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			unsigned int flags);
 int mnl_nft_setelem_batch_add(struct nft_set *nls,
 			      unsigned int flags, uint32_t seq);
+int mnl_nft_setelem_set_list_batch_add(struct nft_set_list *nlsl,
+				       unsigned int flags);
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			   unsigned int flags);
 int mnl_nft_setelem_batch_del(struct nft_set *nls,
@@ -84,6 +93,9 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
 struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					 uint32_t family);
+int mnl_nft_ruleset_batch_add(const struct nft_ruleset *rs,
+			      uint32_t table_flags, uint32_t chain_flags,
+			      uint32_t sets_flags, uint32_t rule_flags);
 int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data);
diff --git a/include/netlink.h b/include/netlink.h
index 4f79470..6584277 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -154,6 +154,10 @@ extern int netlink_flush_ruleset(struct netlink_ctx *ctx,
 extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 						const struct handle *h,
 						const struct location *loc);
+int netlink_add_ruleset(struct netlink_ctx *ctx, const struct handle *h,
+			const struct location *loc,
+			struct nft_ruleset *rs);
+
 struct netlink_mon_handler {
 	uint32_t		monitor_flags;
 	uint32_t		format;
diff --git a/include/rule.h b/include/rule.h
index 936177b..4669ba4 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -223,6 +223,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
  * @CMD_EXPORT:		export the ruleset in a given format
+ * @CMD_IMPORT:		import a ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
  */
@@ -236,6 +237,7 @@ enum cmd_ops {
 	CMD_FLUSH,
 	CMD_RENAME,
 	CMD_EXPORT,
+	CMD_IMPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
 };
@@ -254,6 +256,7 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_IMPORT:	import
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -267,6 +270,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_IMPORT,
 };
 
 struct export {
@@ -276,6 +280,13 @@ struct export {
 struct export *export_alloc(uint32_t format);
 void export_free(struct export *e);
 
+struct import {
+	uint32_t	format;
+};
+
+struct import *import_alloc(uint32_t format);
+void import_free(struct import *i);
+
 enum {
 	CMD_MONITOR_OBJ_ANY,
 	CMD_MONITOR_OBJ_TABLES,
@@ -308,7 +319,6 @@ void monitor_free(struct monitor *m);
  * @seqnum:	sequence number to match netlink errors
  * @union:	object
  * @arg:	argument data
- * @format:	info about the export/import format
  */
 struct cmd {
 	struct list_head	list;
@@ -326,6 +336,7 @@ struct cmd {
 		struct table	*table;
 		struct monitor	*monitor;
 		struct export	*export;
+		struct import	*import;
 	};
 	const void		*arg;
 };
diff --git a/src/evaluate.c b/src/evaluate.c
index d61d76b..6085d5f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1776,6 +1776,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_FLUSH:
 	case CMD_RENAME:
 	case CMD_EXPORT:
+	case CMD_IMPORT:
 	case CMD_DESCRIBE:
 		return 0;
 	case CMD_MONITOR:
diff --git a/src/mnl.c b/src/mnl.c
index f48ead5..ed1fc3c 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -342,6 +342,9 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 	return ret;
 }
 
+/*
+ * Rule
+ */
 int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum)
 {
@@ -358,6 +361,30 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 	return 0;
 }
 
+int mnl_nft_rule_list_batch_add(struct nft_rule_list *nlrl,
+				unsigned int flags)
+{
+	struct nft_rule_list_iter *rli;
+	struct nft_rule *r;
+	int ret;
+
+	rli = nft_rule_list_iter_create(nlrl);
+	if (rli == NULL)
+		memory_allocation_error();
+
+	r = nft_rule_list_iter_next(rli);
+	while (r != NULL) {
+		ret = mnl_nft_rule_batch_add(r, flags, seq++);
+		if (ret < 0)
+			return ret;
+
+		r = nft_rule_list_iter_next(rli);
+	}
+	nft_rule_list_iter_destroy(rli);
+
+	return 0;
+}
+
 int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum)
 {
@@ -374,9 +401,6 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 	return 0;
 }
 
-/*
- * Rule
- */
 int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 		     unsigned int flags)
 {
@@ -486,6 +510,30 @@ int mnl_nft_chain_batch_add(struct nft_chain *nlc, unsigned int flags,
 	return 0;
 }
 
+int mnl_nft_chain_list_batch_add(struct nft_chain_list *nlcl,
+				 unsigned int flags)
+{
+	struct nft_chain_list_iter *ci;
+	struct nft_chain *c;
+	int ret;
+
+	ci = nft_chain_list_iter_create(nlcl);
+	if (ci == NULL)
+		memory_allocation_error();
+
+	c = nft_chain_list_iter_next(ci);
+	while (c != NULL) {
+		ret = mnl_nft_chain_batch_add(c, flags, seq++);
+		if (ret < 0)
+			return ret;
+
+		c = nft_chain_list_iter_next(ci);
+	}
+	nft_chain_list_iter_destroy(ci);
+
+	return 0;
+}
+
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			 unsigned int flags)
 {
@@ -614,6 +662,30 @@ int mnl_nft_table_batch_add(struct nft_table *nlt, unsigned int flags,
 	return 0;
 }
 
+int mnl_nft_table_list_batch_add(struct nft_table_list *nltl,
+				 unsigned int flags)
+{
+	struct nft_table_list_iter *ti;
+	struct nft_table *t;
+	int ret;
+
+	ti = nft_table_list_iter_create(nltl);
+	if (ti == NULL)
+		memory_allocation_error();
+
+	t = nft_table_list_iter_next(ti);
+	while (t != NULL) {
+		ret = mnl_nft_table_batch_add(t, flags, seq++);
+		if (ret < 0)
+			return ret;
+
+		t = nft_table_list_iter_next(ti);
+	}
+	nft_table_list_iter_destroy(ti);
+
+	return 0;
+}
+
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags)
 {
@@ -762,6 +834,29 @@ int mnl_nft_set_batch_add(struct nft_set *nls, unsigned int flags,
 	return 0;
 }
 
+int mnl_nft_set_list_batch_add(struct nft_set_list *nlsl, unsigned int flags)
+{
+	struct nft_set_list_iter *sli;
+	struct nft_set *s;
+	int ret;
+
+	sli = nft_set_list_iter_create(nlsl);
+	if (sli == NULL)
+		memory_allocation_error();
+
+	s = nft_set_list_iter_next(sli);
+	while (s != NULL) {
+		ret = mnl_nft_set_batch_add(s, flags, seq++);
+		if (ret < 0)
+			return ret;
+
+		s = nft_set_list_iter_next(sli);
+	}
+	nft_set_list_iter_destroy(sli);
+
+	return 0;
+}
+
 int mnl_nft_set_batch_del(struct nft_set *nls, unsigned int flags,
 			  uint32_t seqnum)
 {
@@ -946,6 +1041,30 @@ int mnl_nft_setelem_batch_del(struct nft_set *nls, unsigned int flags,
 	return 0;
 }
 
+int mnl_nft_setelem_set_list_batch_add(struct nft_set_list *nlsl,
+				       unsigned int flags)
+{
+	struct nft_set_list_iter *sli;
+	struct nft_set *s;
+	int ret;
+
+	sli = nft_set_list_iter_create(nlsl);
+	if (sli == NULL)
+		memory_allocation_error();
+
+	s = nft_set_list_iter_next(sli);
+	while (s != NULL) {
+		ret = mnl_nft_setelem_batch_add(s, flags, seq++);
+		if (ret < 0)
+			return ret;
+
+		s = nft_set_list_iter_next(sli);
+	}
+	nft_set_list_iter_destroy(sli);
+
+	return 0;
+}
+
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -1019,6 +1138,51 @@ err:
 	return NULL;
 }
 
+int mnl_nft_ruleset_batch_add(const struct nft_ruleset *rs,
+			      uint32_t table_flags, uint32_t chain_flags,
+			      uint32_t set_flags, uint32_t rule_flags)
+{
+	struct nft_table_list *tl;
+	struct nft_chain_list *cl;
+	struct nft_rule_list *rl;
+	struct nft_set_list *sl;
+	int ret;
+
+	tl = nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_TABLELIST);
+	if (tl != NULL) {
+		ret = mnl_nft_table_list_batch_add(tl, table_flags);
+		if (ret < 0)
+			return ret;
+	}
+
+	cl = nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_CHAINLIST);
+	if (cl != NULL) {
+		ret = mnl_nft_chain_list_batch_add(cl, chain_flags);
+		if (ret < 0)
+			return ret;
+	}
+
+	sl = nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_SETLIST);
+	if (sl != NULL) {
+		ret = mnl_nft_set_list_batch_add(sl, set_flags);
+		if (ret < 0)
+			return ret;
+
+		ret = mnl_nft_setelem_set_list_batch_add(sl, set_flags);
+		if (ret < 0)
+			return ret;
+	}
+
+	rl = nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_RULELIST);
+	if (rl != NULL) {
+		ret = mnl_nft_rule_list_batch_add(rl, rule_flags);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * events
  */
diff --git a/src/netlink.c b/src/netlink.c
index 33e77ab..0331b65 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -22,6 +22,7 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
 #include <libnftnl/common.h>
+#include <libnftnl/ruleset.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
@@ -1510,6 +1511,69 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 	return rs;
 }
 
+static void netlink_add_ruleset_setup(struct nft_ruleset *rs)
+{
+	struct nft_chain_list *cl;
+	struct nft_chain_list_iter *i;
+	struct nft_chain *c;
+	struct nft_rule_list *rl, *reverse_rule_list;
+	struct nft_rule_list_iter *rli;
+	struct nft_rule *r;
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) {
+		cl = nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_CHAINLIST);
+		i = nft_chain_list_iter_create(cl);
+		if (i == NULL)
+			memory_allocation_error();
+
+		c = nft_chain_list_iter_next(i);
+		while (c != NULL) {
+			nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
+			c = nft_chain_list_iter_next(i);
+		}
+		nft_chain_list_iter_destroy(i);
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)) {
+		rl = nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_RULELIST);
+		rli = nft_rule_list_iter_create(rl);
+		if (rli == NULL)
+			memory_allocation_error();
+
+		reverse_rule_list = nft_rule_list_alloc();
+		if (reverse_rule_list == NULL)
+			memory_allocation_error();
+
+		r = nft_rule_list_iter_next(rli);
+		while (r != NULL) {
+			nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
+			nft_rule_attr_unset(r, NFT_RULE_ATTR_POSITION);
+			nft_rule_list_del(r);
+			nft_rule_list_add(r, reverse_rule_list);
+			r = nft_rule_list_iter_next(rli);
+		}
+		nft_rule_list_iter_destroy(rli);
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST,
+				     reverse_rule_list);
+	}
+}
+
+int netlink_add_ruleset(struct netlink_ctx *ctx, const struct handle *h,
+			const struct location *loc,
+			struct nft_ruleset *rs)
+{
+	int ret;
+
+	netlink_add_ruleset_setup(rs);
+
+	ret = mnl_nft_ruleset_batch_add(rs, 0, 0, 0, 0);
+	if (ret < 0)
+		netlink_io_error(ctx, loc, "Could not add new ruleset: %s",
+				 strerror(errno));
+
+	return ret;
+}
+
 static struct nft_table *netlink_table_alloc(const struct nlmsghdr *nlh)
 {
 	struct nft_table *nlt = nft_table_alloc();
diff --git a/src/parser.y b/src/parser.y
index 9e9a839..d1f884c 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -189,6 +189,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
 %token EXPORT			"export"
+%token IMPORT			"import"
 %token MONITOR			"monitor"
 
 %token ACCEPT			"accept"
@@ -396,8 +397,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd import_cmd monitor_cmd describe_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd import_cmd monitor_cmd describe_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
@@ -529,7 +530,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
-%type <val>			export_format
+%type <val>			export_format	import_format
 %type <string>			monitor_event
 %destructor { xfree($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
@@ -632,6 +633,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
+			|	IMPORT		import_cmd	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
 			;
@@ -803,6 +805,14 @@ export_cmd		:	export_format
 			}
 			;
 
+import_cmd		:	import_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct import *import = import_alloc($1);
+				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_IMPORT, &h, &@$, import);
+			}
+			;
+
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
@@ -832,6 +842,10 @@ export_format		: 	XML 		{ $$ = NFT_OUTPUT_XML; }
 			|	JSON		{ $$ = NFT_OUTPUT_JSON; }
 			;
 
+import_format		: 	XML 		{ $$ = NFT_PARSE_XML; }
+			|	JSON		{ $$ = NFT_PARSE_JSON; }
+			;
+
 describe_cmd		:	primary_expr
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
diff --git a/src/rule.c b/src/rule.c
index a79a420..1702102 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -571,6 +571,21 @@ void export_free(struct export *e)
 	xfree(e);
 }
 
+struct import *import_alloc(uint32_t format)
+{
+	struct import *import;
+
+	import = xmalloc(sizeof(struct import));
+	import->format = format;
+
+	return import;
+}
+
+void import_free(struct import *i)
+{
+	xfree(i);
+}
+
 struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
 {
 	struct monitor *mon;
@@ -618,6 +633,9 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
+		case CMD_OBJ_IMPORT:
+			import_free(cmd->import);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -772,6 +790,38 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_command_import(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	int ret;
+	struct nft_ruleset *rs = nft_ruleset_alloc();
+	struct nft_parse_err *err = nft_parse_err_alloc();
+
+	if (rs == NULL)
+		return -1;
+
+	if (err == NULL)
+		return -1;
+
+	ret = nft_ruleset_parse_file(rs, cmd->import->format, stdin, err);
+	if (ret < 0) {
+		nft_parse_perror("E: Unable to import. Parsing failed", err);
+		goto out;
+	}
+
+	ret = netlink_flush_ruleset(ctx, &cmd->handle, &cmd->location);
+	if (ret < 0)
+		goto out;
+
+	ret = netlink_add_ruleset(ctx, &cmd->handle, &cmd->location, rs);
+	if (ret < 0)
+		goto out;
+
+out:
+	nft_ruleset_free(rs);
+	nft_parse_err_free(err);
+	return ret;
+}
+
 static void table_cleanup(struct table *table)
 {
 	struct chain *chain, *nchain;
@@ -1035,6 +1085,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_rename(ctx, cmd);
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
+	case CMD_IMPORT:
+		return do_command_import(ctx, cmd);
 	case CMD_MONITOR:
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
diff --git a/src/scanner.l b/src/scanner.l
index 32e59d9..880cb2f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -259,6 +259,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
+"import"		{ return IMPORT; }
 "monitor"		{ return MONITOR; }
 
 "position"		{ return POSITION; }

