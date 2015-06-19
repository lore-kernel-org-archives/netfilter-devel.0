From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] rule: fix use of intervals in set declarations
Date: Fri, 19 Jun 2015 15:15:18 +0200
Message-ID: <1434719718-10371-3-git-send-email-pablo@netfilter.org>
References: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, admin@rollinix.net, niels@kristensen.io,
	tom@compton.nu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48232 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbbFSNKd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:10:33 -0400
In-Reply-To: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft add table set
 # nft add set test myset { type ipv4_addr\; flags interval\; }
 # nft add element test myset2 { 1.2.3.0/24 }

Then the listing shows:

 set myset2 {
         type ipv4_addr
         flags interval
         elements = { 1.2.3.0/24}
 }

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=994
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 495aebc..e784d4c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -690,10 +690,21 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			   const struct expr *expr)
+			   const struct location *loc, struct expr *expr)
 {
-	if (netlink_add_setelems(ctx, h, expr) < 0)
+	struct set *set;
+
+	if (netlink_get_set(ctx, h, loc) < 0)
 		return -1;
+
+	list_for_each_entry(set, &ctx->list, list) {
+		if (set->flags & SET_F_INTERVAL &&
+		    set_to_intervals(ctx->msgs, set, expr) < 0)
+			return -1;
+
+		if (netlink_add_setelems(ctx, h, expr) < 0)
+			return -1;
+	}
 	return 0;
 }
 
@@ -756,7 +767,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_SET:
 		return do_add_set(ctx, &cmd->handle, cmd->set);
 	case CMD_OBJ_SETELEM:
-		return do_add_setelems(ctx, &cmd->handle, cmd->expr);
+		return do_add_setelems(ctx, &cmd->handle, &cmd->location,
+				       cmd->expr);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
