From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] Use hotdrop jump mark.
Date: Tue, 18 Jan 2011 01:36:57 +0100
Message-ID: <1295311017-9105-1-git-send-email-richard@nod.at>
Cc: netfilter-devel@vger.kernel.org,
	Richard Weinberger <richard@nod.at>
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:40567 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab1ARAnr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:43:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Richard Weinberger <richard@nod.at>
---
 net/netfilter/xt_connlimit.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 5c5b6b9..6f5a49d 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -206,8 +206,7 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (connections < 0) {
 		/* kmalloc failed, drop it entirely */
-		par->hotdrop = true;
-		return false;
+		goto hotdrop;
 	}
 
 	return (connections > info->limit) ^ info->inverse;
-- 
1.6.6.1

