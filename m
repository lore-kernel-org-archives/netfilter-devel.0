From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH] netfilter: nf_tables: Fixes how a table is checked to be in use
Date: Fri, 30 Aug 2013 12:43:32 +0300
Message-ID: <1377855812-15251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6402 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab3H3Jnp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:43:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's check table's chain list emptyness instead so struct nft_table
does not grow and we avoid the (unlikely to happen) overflow.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/net/netfilter/nf_tables.h | 1 -
 net/netfilter/nf_tables_api.c     | 7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 215edf5..e4306a4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -450,7 +450,6 @@ struct nft_table {
 	struct list_head		chains;
 	struct list_head		sets;
 	u64				hgenerator;
-	u32				use;
 	u16				flags;
 	char				name[];
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5d0129..68f90da 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -448,7 +448,7 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	if (table->use)
+	if (!list_empty(&table->chains))
 		return -EBUSY;
 
 	list_del(&table->list);
@@ -835,9 +835,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	if (table->use == UINT_MAX)
-		return -EOVERFLOW;
-
 	chain = NULL;
 	name = nla[NFTA_CHAIN_NAME];
 
@@ -992,7 +989,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		}
 	}
 	list_add_tail(&chain->list, &table->chains);
-	table->use++;
 notify:
 	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_NEWCHAIN,
 			       family);
@@ -1038,7 +1034,6 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 		return -EBUSY;
 
 	list_del(&chain->list);
-	table->use--;
 
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    chain->flags & NFT_BASE_CHAIN)
-- 
1.8.3.2

