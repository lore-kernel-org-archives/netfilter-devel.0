From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 11/13] netfilter: nf_tables: prohibit deletion of a table with existing sets
Date: Thu,  9 Jan 2014 18:42:41 +0000
Message-ID: <1389292963-4089-12-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51695 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbaAISn1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:27 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently leak the set memory when deleting a table that still has
sets in it. Return EBUSY when attempting to delete a table with sets.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c352614..36add31 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -467,7 +467,7 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	if (table->use)
+	if (!list_empty(&table->chains) || !list_empty(&table->sets))
 		return -EBUSY;
 
 	list_del(&table->list);
-- 
1.8.4.2

