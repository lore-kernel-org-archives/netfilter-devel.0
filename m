From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5 nft] rule: use netlink_add_setelems() when creating literal sets
Date: Tue, 19 Jan 2016 18:52:53 +0100
Message-ID: <1453225976-23749-2-git-send-email-pablo@netfilter.org>
References: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ast@fiberby.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56876 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbcASRxX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 12:53:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 35805231663
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 235D7DA862
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01053DA7E0
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:16 +0100 (CET)
In-Reply-To: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thus, do_add_setelems() is only used for set declarations. This change
is required by the follow up patch entitled ("rule: fix use of intervals
in set declarations").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 18ff592..1295228 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -876,7 +876,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		if (set->flags & SET_F_INTERVAL &&
 		    set_to_intervals(ctx->msgs, set) < 0)
 			return -1;
-		if (do_add_setelems(ctx, &set->handle, set->init) < 0)
+		if (netlink_add_setelems(ctx, &set->handle, set->init) < 0)
 			return -1;
 	}
 	return 0;
-- 
2.1.4

