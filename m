From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] netfilter: xt_connlimit: use hotdrop jump mark
Date: Tue, 18 Jan 2011 16:16:57 +0100
Message-ID: <1295363820-14881-4-git-send-email-jengelh@medozas.de>
References: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40488 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1ARPRJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:17:09 -0500
In-Reply-To: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Richard Weinberger <richard@nod.at>

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_connlimit.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 5c5b6b9..452bc16 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -204,11 +204,9 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	                         &info->mask, par->family);
 	spin_unlock_bh(&info->data->lock);
 
-	if (connections < 0) {
+	if (connections < 0)
 		/* kmalloc failed, drop it entirely */
-		par->hotdrop = true;
-		return false;
-	}
+		goto hotdrop;
 
 	return (connections > info->limit) ^ info->inverse;
 
-- 
1.7.1

