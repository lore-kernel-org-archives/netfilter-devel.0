From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/26] netfilter: nft_rbtree: check for next generation when deactivating elements
Date: Wed,  6 Jul 2016 16:23:59 +0200
Message-ID: <1467815048-2240-18-git-send-email-pablo@netfilter.org>
References: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34282 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbcGFO0x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 10:26:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 334D017DB74
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 16:26:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 257F7FAB51
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 16:26:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 008C3CA0FF
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 16:26:48 +0200 (CEST)
In-Reply-To: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

set->ops->deactivate() is invoked from nft_del_setelem() that happens
from the transaction path, so we have to check if the object is active
in the next generation, not the current.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_rbtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index f762094..86fbe5e 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -170,7 +170,7 @@ static void *nft_rbtree_deactivate(const struct nft_set *set,
 	const struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
 	struct nft_rbtree_elem *rbe, *this = elem->priv;
-	u8 genmask = nft_genmask_cur(read_pnet(&set->pnet));
+	u8 genmask = nft_genmask_next(read_pnet(&set->pnet));
 	int d;
 
 	while (parent != NULL) {
-- 
2.1.4

