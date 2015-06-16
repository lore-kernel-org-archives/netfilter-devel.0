From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: fix use-after-free netlink_events_cache_deltable()
Date: Tue, 16 Jun 2015 18:13:18 +0200
Message-ID: <1434471198-7534-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60741 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbbFPQIJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 12:08:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

h.table stores a pointer to a nftnl table object that is gone just after
assignment. Release this object once its content is not referenced anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 1167c95..429eed4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1982,14 +1982,15 @@ static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
 	nlt      = netlink_table_alloc(nlh);
 	h.family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
 	h.table  = nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME);
-	nft_table_free(nlt);
 
 	t = table_lookup(&h);
 	if (t == NULL)
-		return;
+		goto out;
 
 	list_del(&t->list);
 	table_free(t);
+out:
+	nft_table_free(nlt);
 }
 
 static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
-- 
1.7.10.4

