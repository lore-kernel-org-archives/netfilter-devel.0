From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/4] src: create element command
Date: Wed, 24 Aug 2016 16:45:06 +0200
Message-ID: <1472049907-7935-3-git-send-email-pablo@netfilter.org>
References: <1472049907-7935-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43026 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755593AbcHXOqY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 10:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40763231663
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30BE1100A57
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39B7B100A63
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:45:13 +0200 (CEST)
In-Reply-To: <1472049907-7935-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the create command, that send the NLM_F_EXCL flag so
nf_tables bails out if the element already exists, eg.

 # nft add element x y { 1.1.1.1 }
 # nft create element x y { 1.1.1.1 }
 <cmdline>:1:1-31: Error: Could not process rule: File exists
 create element x y { 1.1.1.1 }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This update requires nf_tables kernel patches to honor the NLM_F_EXCL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h  |  2 +-
 src/netlink.c      | 15 ++++++++-------
 src/parser_bison.y |  4 ++++
 src/rule.c         | 13 +++++++------
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 5f48707..28c11f6 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -160,7 +160,7 @@ extern struct stmt *netlink_parse_set_expr(const struct set *set,
 					   const struct nftnl_expr *nle);
 
 extern int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-				const struct expr *expr);
+				const struct expr *expr, bool excl);
 extern int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				   const struct expr *expr);
 extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/src/netlink.c b/src/netlink.c
index f897b0e..f8da2a6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1318,7 +1318,7 @@ static void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 
 static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 				      const struct handle *h,
-				      const struct expr *expr)
+				      const struct expr *expr, bool excl)
 {
 	struct nftnl_set *nls;
 	int err;
@@ -1327,7 +1327,8 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_batch_add(nls, 0, ctx->seqnum);
+	err = mnl_nft_setelem_batch_add(nls, excl ? NLM_F_EXCL : 0,
+					ctx->seqnum);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1338,7 +1339,7 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 
 static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 				       const struct handle *h,
-				       const struct expr *expr)
+				       const struct expr *expr, bool excl)
 {
 	struct nftnl_set *nls;
 	int err;
@@ -1347,7 +1348,7 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_add(nf_sock, nls, 0);
+	err = mnl_nft_setelem_add(nf_sock, nls, excl ? NLM_F_EXCL : 0);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1357,12 +1358,12 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 }
 
 int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct expr *expr)
+			 const struct expr *expr, bool excl)
 {
 	if (ctx->batch_supported)
-		return netlink_add_setelems_batch(ctx, h, expr);
+		return netlink_add_setelems_batch(ctx, h, expr, excl);
 	else
-		return netlink_add_setelems_compat(ctx, h, expr);
+		return netlink_add_setelems_compat(ctx, h, expr, excl);
 }
 
 static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5d5ce8c..8c0f625 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -788,6 +788,10 @@ create_cmd		:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SET, &$2, &@$, $5);
 			}
+			|	ELEMENT		set_spec	set_expr
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SETELEM, &$2, &@$, $3);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
diff --git a/src/rule.c b/src/rule.c
index 54edd8c..8c58bfa 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -881,20 +881,20 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			     struct set *set, struct expr *expr)
+			     struct set *set, struct expr *expr, bool excl)
 {
 	if (set->flags & SET_F_INTERVAL &&
 	    set_to_intervals(ctx->msgs, set, expr, true) < 0)
 		return -1;
 
-	if (netlink_add_setelems(ctx, h, expr) < 0)
+	if (netlink_add_setelems(ctx, h, expr, excl) < 0)
 		return -1;
 
 	return 0;
 }
 
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			   struct expr *init)
+			   struct expr *init, bool excl)
 {
 	struct table *table;
 	struct set *set;
@@ -902,7 +902,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	table = table_lookup(h);
 	set = set_lookup(table, h->set);
 
-	return __do_add_setelems(ctx, h, set, init);
+	return __do_add_setelems(ctx, h, set, init, excl);
 }
 
 static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
@@ -911,7 +911,8 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 	if (netlink_add_set(ctx, h, set, excl) < 0)
 		return -1;
 	if (set->init != NULL)
-		return __do_add_setelems(ctx, &set->handle, set, set->init);
+		return __do_add_setelems(ctx, &set->handle, set, set->init,
+					 false);
 
 	return 0;
 }
@@ -960,7 +961,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_SET:
 		return do_add_set(ctx, &cmd->handle, cmd->set, excl);
 	case CMD_OBJ_SETELEM:
-		return do_add_setelems(ctx, &cmd->handle, cmd->expr);
+		return do_add_setelems(ctx, &cmd->handle, cmd->expr, excl);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.1.4

