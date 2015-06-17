From: Markus Koetter <koetter@rrzn.uni-hannover.de>
Subject: [PATCH 3/5] rule: make cache creation a function
Date: Wed, 17 Jun 2015 22:07:35 +0200
Message-ID: <1434571657-20047-4-git-send-email-koetter@rrzn.uni-hannover.de>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:38459 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbFQUO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 16:14:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailout2.uni-hannover.de (Postfix) with ESMTP id 9C46060A1
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from mailout2.uni-hannover.de ([127.0.0.1])
	by localhost (mailout2.uni-hannover.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cJIUO6Hf95li for <netfilter-devel@vger.kernel.org>;
	Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from hass1404.example.prv (p4FDA71FA.dip0.t-ipconnect.de [79.218.113.250])
	(Authenticated sender: koetter@rrzn.uni-hannover.de)
	by mailout2.uni-hannover.de (Postfix) with ESMTPSA id 6BD63609A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
In-Reply-To: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/rule.c | 93 +++++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 31 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 97c436e..dc65452 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -962,18 +962,73 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
+static int create_cache(struct netlink_ctx *ctx, struct handle *h, struct location *loc)
 {
 	struct table *t, *nt;
 	struct set *s, *ns;
-	struct netlink_ctx set_ctx;
+	struct chain *c, *nc;
+	struct rule *r, *rc;
+	struct netlink_ctx tmpctx;
 	LIST_HEAD(msgs);
-	struct handle set_handle;
-	struct netlink_mon_handler monhandler;
-}
+	struct handle filter;
+
+	/* create cache */
+	memset(&tmpctx, 0, sizeof(tmpctx));
+	init_list_head(&msgs);
+	tmpctx.msgs = &msgs;
+
+	if (netlink_list_tables(ctx, h, loc) < 0)
+		return -1;
+
+	list_for_each_entry_safe(t, nt, &ctx->list, list) {
+		table_add_hash(t);
+
+		filter.family = t->handle.family;
+		filter.table = t->handle.table;
+		filter.chain = NULL;
+
+		init_list_head(&tmpctx.list);
+
+		if (netlink_list_sets(&tmpctx, &filter, loc) < 0)
+			return -1;
+
+		list_for_each_entry_safe(s, ns, &tmpctx.list, list) {
+			if (netlink_get_setelems(&tmpctx, &s->handle, loc, s) < 0)
+				return -1;
+			list_move_tail(&s->list, &t->sets);
+			set_add_hash(s, t);
+		}
+
+		init_list_head(&tmpctx.list);
+
+		if (netlink_list_chains(&tmpctx, &filter, loc) < 0)
+			return -1;
+
+		list_for_each_entry_safe(c, nc, &tmpctx.list, list) {
+			chain_add_hash(c, t);
+		}
+
+		init_list_head(&tmpctx.list);
 
+		if (netlink_list_table(&tmpctx, &filter, loc) < 0)
+			return -1;
+
+		list_for_each_entry_safe(r, rc, &tmpctx.list, list) {
+			c = chain_lookup(t, &r->handle);
+			if (c == NULL) {
+				c = chain_alloc(r->handle.chain);
+				chain_add_hash(c, t);
+			}
+			list_move_tail(&r->list, &c->rules);
+		}
+		init_list_head(&tmpctx.list);
+	}
+	return 0;
 }
 
+static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct netlink_mon_handler monhandler;
 
 	/* cache only needed if monitoring:
 	 *  - new rules in default format
@@ -986,32 +1041,8 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	else
 		monhandler.cache_needed = false;
 
-	if (monhandler.cache_needed) {
-		memset(&set_ctx, 0, sizeof(set_ctx));
-		init_list_head(&msgs);
-		set_ctx.msgs = &msgs;
-
-		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
-
-		list_for_each_entry_safe(t, nt, &ctx->list, list) {
-			set_handle.family = t->handle.family;
-			set_handle.table = t->handle.table;
-
-			init_list_head(&set_ctx.list);
-
-			if (netlink_list_sets(&set_ctx, &set_handle,
-					      &cmd->location) < 0)
-				return -1;
-
-			list_for_each_entry_safe(s, ns, &set_ctx.list, list) {
-				s->init = set_expr_alloc(&cmd->location);
-				set_add_hash(s, t);
-			}
-
-			table_add_hash(t);
-		}
-	}
+	if (monhandler.cache_needed)
+		create_cache(ctx, &cmd->handle, &cmd->location);
 
 	monhandler.monitor_flags = cmd->monitor->flags;
 	monhandler.format = cmd->monitor->format;
-- 
1.9.1

