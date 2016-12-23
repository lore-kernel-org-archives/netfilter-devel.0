From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 06/10] src: reset internal stateful objects
Date: Fri, 23 Dec 2016 15:26:51 +0100
Message-ID: <1482503215-25422-6-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941098AbcLWO1R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75AB52519A5
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63C228E670
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C805DA725
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:11 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to atomically dump and reset stateful objects, eg.

 # nft list counters
 table ip filter {
        counter test {
              packets 1024 bytes 100000
        }
 }
 # nft reset quotas table filter
 counter test {
        packets 1024 bytes 100000
 }
 # nft reset quotas table filter
 counter test {
        packets 0 bytes 0
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h      |  3 ++-
 include/netlink.h  |  6 ++++--
 include/rule.h     |  2 ++
 src/evaluate.c     |  1 +
 src/mnl.c          | 14 +++++++++++---
 src/netlink.c      | 24 +++++++++++++++++++++++-
 src/parser_bison.y | 24 ++++++++++++++++++++++--
 src/rule.c         | 43 ++++++++++++++++++++++++++++++++++++++-----
 src/scanner.l      |  1 +
 9 files changed, 104 insertions(+), 14 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index d178bd27a75a..4a99972d4163 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -87,7 +87,8 @@ int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
 
 struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
-					const char *table);
+					const char *table, uint32_t type,
+					bool reset);
 int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
 			  uint32_t seqnum);
 int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
diff --git a/include/netlink.h b/include/netlink.h
index 841211c43760..450aba571a97 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -170,11 +170,13 @@ extern int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *
 				  const struct location *loc);
 
 extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
-			       const struct location *loc);
+			     const struct location *loc);
+extern int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
+			      const struct location *loc, uint32_t type);
 extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 			   struct obj *obj, bool excl);
 extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
-			      struct location *loc, enum stmt_types type);
+			      struct location *loc, uint32_t type);
 
 extern void netlink_dump_table(const struct nftnl_table *nlt);
 extern void netlink_dump_chain(const struct nftnl_chain *nlc);
diff --git a/include/rule.h b/include/rule.h
index 88acbcc7b163..9028c84b0033 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -294,6 +294,7 @@ const char *obj_type_name(uint32_t type);
  * @CMD_INSERT:		insert object
  * @CMD_DELETE:		delete object
  * @CMD_LIST:		list container
+ * @CMD_RESET:		reset container
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
  * @CMD_EXPORT:		export the ruleset in a given format
@@ -308,6 +309,7 @@ enum cmd_ops {
 	CMD_INSERT,
 	CMD_DELETE,
 	CMD_LIST,
+	CMD_RESET,
 	CMD_FLUSH,
 	CMD_RENAME,
 	CMD_EXPORT,
diff --git a/src/evaluate.c b/src/evaluate.c
index 9bc3b7d6477a..cedf259fcba9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3052,6 +3052,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_DELETE:
 		return cmd_evaluate_delete(ctx, cmd);
 	case CMD_LIST:
+	case CMD_RESET:
 		return cmd_evaluate_list(ctx, cmd);
 	case CMD_FLUSH:
 		return cmd_evaluate_flush(ctx, cmd);
diff --git a/src/mnl.c b/src/mnl.c
index 9458e21bf8b4..52cb7736e324 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -851,22 +851,30 @@ err_free:
 
 
 struct nftnl_obj_list *
-mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table)
+mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
+		 uint32_t type, bool reset)
 {
 	struct nftnl_obj_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_obj *n;
 	struct nlmsghdr *nlh;
-	int ret;
+	int msg_type, ret;
+
+	if (reset)
+		msg_type = NFT_MSG_GETOBJ_RESET;
+	else
+		msg_type = NFT_MSG_GETOBJ;
 
 	n = nftnl_obj_alloc();
 	if (n == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
+	nlh = nftnl_nlmsg_build_hdr(buf, msg_type, family,
 				    NLM_F_DUMP | NLM_F_ACK, seq);
 	if (table != NULL)
 		nftnl_obj_set(n, NFTNL_OBJ_TABLE, table);
+	if (type != NFT_OBJECT_UNSPEC)
+		nftnl_obj_set_u32(n, NFTNL_OBJ_TYPE, type);
 	nftnl_obj_nlmsg_build_payload(nlh, n);
 	nftnl_obj_free(n);
 
diff --git a/src/netlink.c b/src/netlink.c
index d11b3c01f264..68bed201a36d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1755,7 +1755,29 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table);
+	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table,
+				     NFT_OBJECT_UNSPEC, false);
+	if (obj_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
+		return netlink_io_error(ctx, loc,
+					"Could not receive stateful objects from kernel: %s",
+					strerror(errno));
+	}
+
+	err = nftnl_obj_list_foreach(obj_cache, list_obj_cb, ctx);
+	nftnl_obj_list_free(obj_cache);
+	return err;
+}
+
+int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
+		       const struct location *loc, uint32_t type)
+{
+	struct nftnl_obj_list *obj_cache;
+	int err;
+
+	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, type, true);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd3f0d8251a6..b571fbbed5f3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -199,6 +199,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token INSERT			"insert"
 %token DELETE			"delete"
 %token LIST			"list"
+%token RESET			"reset"
 %token FLUSH			"flush"
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
@@ -442,8 +443,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
 %type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
@@ -725,6 +726,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	INSERT		insert_cmd	{ $$ = $2; }
 			|	DELETE		delete_cmd	{ $$ = $2; }
 			|	LIST		list_cmd	{ $$ = $2; }
+			|	RESET		reset_cmd	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
@@ -968,6 +970,24 @@ list_cmd		:	TABLE		table_spec
 			}
 			;
 
+reset_cmd		:	COUNTERS	ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
+			}
+			|	COUNTERS	TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
+			}
+			|	QUOTAS		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
+			}
+			|	QUOTAS		TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
+			}
+			;
+
 flush_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_TABLE, &$2, &@$, NULL);
diff --git a/src/rule.c b/src/rule.c
index 29b1450666db..9eeb436cd37a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -95,11 +95,13 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 			return -1;
 		list_splice_tail_init(&ctx->list, &table->chains);
 
-		/* Don't check for errors on listings, this would break nft with
-		 * old kernels with no stateful object support.
-		 */
-		netlink_list_objs(ctx, &table->handle, &internal_location);
-		list_splice_tail_init(&ctx->list, &table->objs);
+		if (cmd != CMD_RESET) {
+			/* Don't check for errors on listings, this would break
+			 * nft with old kernels with no stateful object support.
+			 */
+			netlink_list_objs(ctx, &table->handle, &internal_location);
+			list_splice_tail_init(&ctx->list, &table->objs);
+		}
 
 		/* Skip caching other objects to speed up things: We only need
 		 * a full cache when listing the existing ruleset.
@@ -1398,6 +1400,35 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct obj *obj, *next;
+	struct table *table;
+	uint32_t type;
+	int ret;
+
+	switch (cmd->obj) {
+	case CMD_OBJ_COUNTERS:
+		type = NFT_OBJECT_COUNTER;
+		break;
+	case CMD_OBJ_QUOTAS:
+		type = NFT_OBJECT_QUOTA;
+		break;
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+
+	ret = netlink_reset_objs(ctx, &cmd->handle, &cmd->location, type);
+	list_for_each_entry_safe(obj, next, &ctx->list, list) {
+		table = table_lookup(&obj->handle);
+		list_move(&obj->list, &table->objs);
+	}
+	if (ret < 0)
+		return ret;
+
+	return do_list_obj(ctx, cmd, type);
+}
+
 static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -1518,6 +1549,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_delete(ctx, cmd);
 	case CMD_LIST:
 		return do_command_list(ctx, cmd);
+	case CMD_RESET:
+		return do_command_reset(ctx, cmd);
 	case CMD_FLUSH:
 		return do_command_flush(ctx, cmd);
 	case CMD_RENAME:
diff --git a/src/scanner.l b/src/scanner.l
index cb9893203244..1aa2e96b9f64 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -268,6 +268,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "insert"		{ return INSERT; }
 "delete"		{ return DELETE; }
 "list"			{ return LIST; }
+"reset"			{ return RESET; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
-- 
2.1.4

