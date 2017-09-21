From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] monitor: Fix for incorrect debug_mask
Date: Thu, 21 Sep 2017 20:38:02 +0200
Message-ID: <20170921183802.27797-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44766 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdIUSiN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 14:38:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The field 'debug_mask' of struct netlink_mon_handler was left
uninitialized in do_command_monitor() so it contained garbage from the
stack. Fix this by initializing it with the debug_mask value from struct
netlink_ctx.

While being at it, change the code to make use of C99-style initializer,
which will also avoid things like this in future.

Fixes: be441e1ffdc24 ("src: add debugging mask to context structure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 1bb7b4756171c..8f0e752f21fba 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1690,7 +1690,14 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *t;
 	struct set *s;
-	struct netlink_mon_handler monhandler;
+	struct netlink_mon_handler monhandler = {
+		.monitor_flags	= cmd->monitor->flags,
+		.format		= cmd->monitor->format,
+		.ctx		= ctx,
+		.loc		= &cmd->location,
+		.cache		= ctx->cache,
+		.debug_mask	= ctx->debug_mask,
+	};
 
 	monhandler.cache_needed = need_cache(cmd);
 	if (monhandler.cache_needed) {
@@ -1725,12 +1732,6 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		}
 	}
 
-	monhandler.monitor_flags = cmd->monitor->flags;
-	monhandler.format = cmd->monitor->format;
-	monhandler.ctx = ctx;
-	monhandler.loc = &cmd->location;
-	monhandler.cache = ctx->cache;
-
 	return netlink_monitor(&monhandler, ctx->nf_sock);
 }
 
-- 
2.13.1

