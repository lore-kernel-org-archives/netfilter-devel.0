From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/7] rule: support for incremental set interval element updates
Date: Mon, 18 Apr 2016 20:14:33 +0200
Message-ID: <1461003275-2330-6-git-send-email-pablo@netfilter.org>
References: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35454 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbcDRSO5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:14:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E4A56C1085
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C95A59D0EF
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6D4A89D108
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:52 +0200 (CEST)
In-Reply-To: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce __do_add_setelems() and do_delete_setelems() to support
incremental set interval element updates.

>From do_add_set(), use netlink_add_setelems() not to try to re-add the
same elements again

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 52 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 43a606b..e2f15ee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -863,26 +863,39 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
-static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			   const struct expr *expr)
+static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			     struct set *set, struct expr *expr)
 {
+	if (set->flags & SET_F_INTERVAL &&
+	    set_to_intervals(ctx->msgs, set, expr) < 0)
+		return -1;
+
 	if (netlink_add_setelems(ctx, h, expr) < 0)
 		return -1;
+
 	return 0;
 }
 
+static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			   struct expr *init)
+{
+	struct table *table;
+	struct set *set;
+
+	table = table_lookup(h);
+	set = set_lookup(table, h->set);
+
+	return __do_add_setelems(ctx, h, set, init);
+}
+
 static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		      struct set *set)
 {
 	if (netlink_add_set(ctx, h, set) < 0)
 		return -1;
-	if (set->init != NULL) {
-		if (set->flags & SET_F_INTERVAL &&
-		    set_to_intervals(ctx->msgs, set, set->init) < 0)
-			return -1;
-		if (do_add_setelems(ctx, &set->handle, set->init) < 0)
-			return -1;
-	}
+	if (set->init != NULL)
+		return __do_add_setelems(ctx, &set->handle, set, set->init);
+
 	return 0;
 }
 
@@ -961,6 +974,25 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
+			      struct expr *expr)
+{
+	struct table *table;
+	struct set *set;
+
+	table = table_lookup(h);
+	set = set_lookup(table, h->set);
+
+	if (set->flags & SET_F_INTERVAL &&
+	    set_to_intervals(ctx->msgs, set, expr) < 0)
+		return -1;
+
+	if (netlink_delete_setelems(ctx, h, expr) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -974,7 +1006,7 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
-		return netlink_delete_setelems(ctx, &cmd->handle, cmd->expr);
+		return do_delete_setelems(ctx, &cmd->handle, cmd->expr);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.1.4

