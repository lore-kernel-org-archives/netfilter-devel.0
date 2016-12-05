From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add support to flush sets
Date: Mon,  5 Dec 2016 23:37:05 +0100
Message-ID: <1480977425-15015-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbcLEWhO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 17:37:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB5E51DF5BB
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:37:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC6D1DA843
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:37:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A99D0DA843
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:37:09 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You can use this new command to remove all existing elements in a set:

 # nft flush set filter xyz

After this command, the set 'xyz' in table 'filter' becomes empty.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h | 2 ++
 src/evaluate.c    | 3 +++
 src/netlink.c     | 9 ++++++++-
 src/rule.c        | 3 +++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/netlink.h b/include/netlink.h
index 28c11f603ed2..363b5251968f 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -165,6 +165,8 @@ extern int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle
 				   const struct expr *expr);
 extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc, struct set *set);
+extern int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *h,
+				  const struct location *loc);
 
 extern void netlink_dump_table(const struct nftnl_table *nlt);
 extern void netlink_dump_chain(const struct nftnl_chain *nlc);
diff --git a/src/evaluate.c b/src/evaluate.c
index e11a455a5f53..8a3da54e5b2d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2857,9 +2857,11 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	int ret;
+
 	ret = cache_update(cmd->op, ctx->msgs);
 	if (ret < 0)
 		return ret;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_RULESET:
 		cache_flush();
@@ -2870,6 +2872,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		 */
 	case CMD_OBJ_CHAIN:
 		/* Chains don't hold sets */
+	case CMD_OBJ_SET:
 		break;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/netlink.c b/src/netlink.c
index f8e600ff6f81..714df4e892b2 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1374,7 +1374,8 @@ static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	alloc_setelem_cache(expr, nls);
+	if (expr)
+		alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
 	err = mnl_nft_setelem_batch_del(nls, 0, ctx->seqnum);
@@ -1406,6 +1407,12 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 	return err;
 }
 
+int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			   const struct location *loc)
+{
+	return netlink_del_setelems_batch(ctx, h, NULL);
+}
+
 static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
 					      struct expr *data)
 {
diff --git a/src/rule.c b/src/rule.c
index 8710767bc330..f1bb6cfe04ea 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1244,6 +1244,9 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 		return netlink_flush_table(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_CHAIN:
 		return netlink_flush_chain(ctx, &cmd->handle, &cmd->location);
+	case CMD_OBJ_SET:
+		return netlink_flush_setelems(ctx, &cmd->handle,
+					      &cmd->location);
 	case CMD_OBJ_RULESET:
 		return netlink_flush_ruleset(ctx, &cmd->handle, &cmd->location);
 	default:
-- 
2.1.4

