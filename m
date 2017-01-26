From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3 1/6] src: Allow reset single stateful object
Date: Thu, 26 Jan 2017 15:09:44 -0200
Message-ID: <20170126170944.GA7842@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35644 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdAZRKN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 12:10:13 -0500
Received: by mail-yb0-f195.google.com with SMTP id j82so14305555ybg.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 09:09:51 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the stateful objects can only be reseted in groups. With this
patch reseting a single object is allowed:

$ nft reset counter filter https-traffic
table ip filter {
	counter https-traffic {
		packets 8774 bytes 542668
	}
}

$ nft list counter filter https-traffic
table ip filter {
	counter https-traffic {
		packets 0 bytes 0
	}
}

Heavily based on work from Pablo Neira Ayuso <pablo@netfilter.org>.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: Only list tables with counters and quotas that are reseted, on v1
 tables without stateful object were listed.
 v3: Revert the changes on v2, all tables are listed.
 I kept the cache_update() call on all cases, because the tables in cache
 are used to print the objects after reset.

 include/mnl.h      |  4 ++--
 include/netlink.h  |  3 ++-
 src/evaluate.c     | 26 +++++++++++++++++++++++++-
 src/mnl.c          |  9 ++++++---
 src/netlink.c      |  9 +++++----
 src/parser_bison.y |  8 ++++++++
 src/rule.c         |  7 ++++++-
 7 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 4a99972..69dd0b7 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -87,8 +87,8 @@ int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
 
 struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
-					const char *table, uint32_t type,
-					bool reset);
+					const char *table, const char *name,
+					uint32_t type, bool dump, bool reset);
 int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
 			  uint32_t seqnum);
 int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
diff --git a/include/netlink.h b/include/netlink.h
index 450aba5..d3fb8c5 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -172,7 +172,8 @@ extern int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *
 extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc);
 extern int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
-			      const struct location *loc, uint32_t type);
+			      const struct location *loc, uint32_t type,
+			      bool dump);
 extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 			   struct obj *obj, bool excl);
 extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/src/evaluate.c b/src/evaluate.c
index bcbced1..1d2f925 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2949,6 +2949,29 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	int ret;
+
+	ret = cache_update(cmd->op, ctx->msgs);
+	if (ret < 0)
+		return ret;
+
+	switch (cmd->obj) {
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_QUOTA:
+		if (table_lookup(&cmd->handle) == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		return 0;
+	case CMD_OBJ_COUNTERS:
+	case CMD_OBJ_QUOTAS:
+		return 0;
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+}
+
 static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	int ret;
@@ -3140,8 +3163,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_DELETE:
 		return cmd_evaluate_delete(ctx, cmd);
 	case CMD_LIST:
-	case CMD_RESET:
 		return cmd_evaluate_list(ctx, cmd);
+	case CMD_RESET:
+		return cmd_evaluate_reset(ctx, cmd);
 	case CMD_FLUSH:
 		return cmd_evaluate_flush(ctx, cmd);
 	case CMD_RENAME:
diff --git a/src/mnl.c b/src/mnl.c
index 1c4b070..295dd84 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -849,8 +849,9 @@ err_free:
 
 struct nftnl_obj_list *
 mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
-		 uint32_t type, bool reset)
+		 const char *name,  uint32_t type, bool dump, bool reset)
 {
+	uint16_t nl_flags = dump ? NLM_F_DUMP : 0;
 	struct nftnl_obj_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_obj *n;
@@ -867,9 +868,11 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, msg_type, family,
-				    NLM_F_DUMP | NLM_F_ACK, seq);
+				    nl_flags | NLM_F_ACK, seq);
 	if (table != NULL)
-		nftnl_obj_set(n, NFTNL_OBJ_TABLE, table);
+		nftnl_obj_set_str(n, NFTNL_OBJ_TABLE, table);
+	if (name != NULL)
+		nftnl_obj_set_str(n, NFTNL_OBJ_NAME, name);
 	if (type != NFT_OBJECT_UNSPEC)
 		nftnl_obj_set_u32(n, NFTNL_OBJ_TYPE, type);
 	nftnl_obj_nlmsg_build_payload(nlh, n);
diff --git a/src/netlink.c b/src/netlink.c
index 73ee5c9..0cc3a51 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1775,8 +1775,8 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table,
-				     NFT_OBJECT_UNSPEC, false);
+	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, NULL,
+				     0, true, false);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1790,12 +1790,13 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
-		       const struct location *loc, uint32_t type)
+		       const struct location *loc, uint32_t type, bool dump)
 {
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, type, true);
+	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, h->obj,
+				     type, dump, true);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4749c9f..a1b8b08 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -974,6 +974,10 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
 			}
+			|       COUNTER         obj_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTER, &$2,&@$, NULL);
+			}
 			|	QUOTAS		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
@@ -982,6 +986,10 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
 			}
+			|       QUOTA           obj_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/rule.c b/src/rule.c
index b5181a9..a9f3a49 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1435,21 +1435,26 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct obj *obj, *next;
 	struct table *table;
+	bool dump = false;
 	uint32_t type;
 	int ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_COUNTERS:
+		dump = true;
+	case CMD_OBJ_COUNTER:
 		type = NFT_OBJECT_COUNTER;
 		break;
 	case CMD_OBJ_QUOTAS:
+		dump = true;
+	case CMD_OBJ_QUOTA:
 		type = NFT_OBJECT_QUOTA;
 		break;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
 
-	ret = netlink_reset_objs(ctx, &cmd->handle, &cmd->location, type);
+	ret = netlink_reset_objs(ctx, &cmd->handle, &cmd->location, type, dump);
 	list_for_each_entry_safe(obj, next, &ctx->list, list) {
 		table = table_lookup(&obj->handle);
 		list_move(&obj->list, &table->objs);
-- 
2.7.4

