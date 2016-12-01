From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 1/2] rule: Introduce helper function cache_flush
Date: Thu,  1 Dec 2016 11:50:16 +0100
Message-ID: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:58526 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751105AbcLAKu5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 05:50:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

cache_release empties the cache, and marks it as uninitialized. Add cache_flush,
which does the same, except it keeps the cache initialized, eg. after a "nft
flush ruleset" when empty is the correct state of the cache.

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 include/rule.h | 1 +
 src/rule.c     | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 99e92ee..b9b4a19 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -422,6 +422,7 @@ struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
 extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
+extern void cache_flush(void);
 extern void cache_release(void);
 
 enum udata_type {
diff --git a/src/rule.c b/src/rule.c
index 8c58bfa..8710767 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -157,7 +157,7 @@ replay:
 	return 0;
 }
 
-void cache_release(void)
+void cache_flush(void)
 {
 	struct table *table, *next;
 
@@ -165,6 +165,11 @@ void cache_release(void)
 		list_del(&table->list);
 		table_free(table);
 	}
+}
+
+void cache_release(void)
+{
+	cache_flush();
 	cache_initialized = false;
 }
 
-- 
2.11.0

