From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] rule: check for EINTR error from cache_init_objects() for stateful objects
Date: Tue, 24 Jan 2017 19:36:26 +0100
Message-ID: <1485282987-9118-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46666 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdAXShC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 13:37:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4C561D94A6
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:36:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7C0AA7DB2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:36:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3935A7EE5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:36:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Catch -1 case, so we have a chance to handle EINTR.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index f2ffd4b27e8a..b5181a90f795 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -96,10 +96,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 		list_splice_tail_init(&ctx->list, &table->chains);
 
 		if (cmd != CMD_RESET) {
-			/* Don't check for errors on listings, this would break
-			 * nft with old kernels with no stateful object support.
-			 */
-			netlink_list_objs(ctx, &table->handle, &internal_location);
+			ret = netlink_list_objs(ctx, &table->handle, &internal_location);
+			if (ret < 0)
+				return -1;
 			list_splice_tail_init(&ctx->list, &table->objs);
 		}
 
-- 
2.1.4

