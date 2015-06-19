From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] rule: use netlink_add_setelems() when creating literal sets
Date: Fri, 19 Jun 2015 15:15:16 +0200
Message-ID: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, admin@rollinix.net, niels@kristensen.io,
	tom@compton.nu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48051 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbbFSNKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:10:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thus, do_add_setelems() is only used for set declarations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index b2090dd..a4c685c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -706,7 +706,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		if (set->flags & SET_F_INTERVAL &&
 		    set_to_intervals(ctx->msgs, set) < 0)
 			return -1;
-		if (do_add_setelems(ctx, &set->handle, set->init) < 0)
+		if (netlink_add_setelems(ctx, &set->handle, set->init) < 0)
 			return -1;
 	}
 	return 0;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
