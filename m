From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: don't bail out on dump errors
Date: Thu, 19 Jan 2017 17:52:55 +0100
Message-ID: <1484844775-6691-1-git-send-email-pablo@netfilter.org>
Cc: pablombg@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753224AbdASQxy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 11:53:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7CE31BFA8B
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 17:53:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BED2DA725
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 17:53:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CACB179E27
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 17:53:00 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes the existing error messages on netlink dump errors.
These functions used to be called from list commands. These days they
are called from the cache cache population path.

Note that nft breaks with older kernels at netlink_list_objs() since we
have no stateful objects support there.

Silence errors at this stage and return an empty list, thus, nft bails
out on explicit user commands if no nf_tables support is available.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Please, give it a test and let me know if this fixes the problem for you, thanks!

 src/netlink.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 4135f2517a09..73ee5c973d16 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -551,9 +551,7 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 		if (errno == EINTR)
 			return -1;
 
-		return netlink_io_error(ctx, loc,
-					"Could not receive rules from kernel: %s",
-					strerror(errno));
+		return 0;
 	}
 
 	ctx->data = h;
@@ -827,9 +825,7 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 		if (errno == EINTR)
 			return -1;
 
-		return netlink_io_error(ctx, loc,
-					"Could not receive chains from kernel: %s",
-					strerror(errno));
+		return 0;
 	}
 
 	ctx->data = h;
@@ -1029,9 +1025,7 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 		if (errno == EINTR)
 			return -1;
 
-		return netlink_io_error(ctx, loc,
-					"Could not receive tables from kernel: %s",
-					strerror(errno));
+		return 0;
 	}
 
 	nftnl_table_list_foreach(table_cache, list_table_cb, ctx);
@@ -1331,9 +1325,7 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 		if (errno == EINTR)
 			return -1;
 
-		return netlink_io_error(ctx, loc,
-					"Could not receive sets from kernel: %s",
-					strerror(errno));
+		return 0;
 	}
 
 	err = nftnl_set_list_foreach(set_cache, list_set_cb, ctx);
@@ -1789,9 +1781,7 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 		if (errno == EINTR)
 			return -1;
 
-		return netlink_io_error(ctx, loc,
-					"Could not receive stateful objects from kernel: %s",
-					strerror(errno));
+		return 0;
 	}
 
 	err = nftnl_obj_list_foreach(obj_cache, list_obj_cb, ctx);
-- 
2.1.4

