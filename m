From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 09/16] rule: use netlink_add_setelems() when creating literal sets
Date: Mon,  6 Jul 2015 20:17:01 +0200
Message-ID: <1436206628-23894-10-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40448 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbbGFSLm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:42 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thus, do_add_setelems() is only used for set declarations. This comes in
preparation to the follow up patch, to avoid resending back to userspace the
list of existing elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 2b624c2..2b663f5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -762,7 +762,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		if (set->flags & SET_F_INTERVAL &&
 		    set_to_intervals(ctx->msgs, set, set->init) < 0)
 			return -1;
-		if (do_add_setelems(ctx, &set->handle, set->init) < 0)
+		if (netlink_add_setelems(ctx, &set->handle, set->init) < 0)
 			return -1;
 	}
 	return 0;
-- 
1.7.10.4

