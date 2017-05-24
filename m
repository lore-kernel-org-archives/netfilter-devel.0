From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] rule: adjust set expression size accordingly with intervals
Date: Wed, 24 May 2017 11:53:16 +0200
Message-ID: <1495619598-22759-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42614 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932854AbdEXJxd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 05:53:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1F8D81EC2C7
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 122CBFF6F6
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D896100796
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:22 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For implicit sets, we have to call set_to_intervals() before we add the
set so we have the net size in elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 5923bf64101e..0d9e393ab26f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -914,10 +914,6 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			     struct set *set, struct expr *expr, bool excl)
 {
-	if (set->flags & NFT_SET_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, expr, true) < 0)
-		return -1;
-
 	expr->set_flags |= set->flags;
 	if (netlink_add_setelems(ctx, h, expr, excl) < 0)
 		return -1;
@@ -934,18 +930,27 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	table = table_lookup(h);
 	set = set_lookup(table, h->set);
 
+	if (set->flags & NFT_SET_INTERVAL &&
+	    set_to_intervals(ctx->msgs, set, init, true) < 0)
+		return -1;
+
 	return __do_add_setelems(ctx, h, set, init, excl);
 }
 
 static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		      struct set *set, bool excl)
 {
+	if (set->init != NULL) {
+		if (set->flags & NFT_SET_INTERVAL &&
+		    set_to_intervals(ctx->msgs, set, set->init, true) < 0)
+			return -1;
+	}
 	if (netlink_add_set(ctx, h, set, excl) < 0)
 		return -1;
-	if (set->init != NULL)
+	if (set->init != NULL) {
 		return __do_add_setelems(ctx, &set->handle, set, set->init,
 					 false);
-
+	}
 	return 0;
 }
 
-- 
2.1.4

