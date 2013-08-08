From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables 1/2] netfilter: nf_tables: don't delete table if in use
Date: Thu,  8 Aug 2013 19:54:30 +0200
Message-ID: <1375984471-21035-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35285 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965829Ab3HHRyt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:54:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Return EBUSY if you try to delete a table that is in use.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    4 +++-
 net/netfilter/nf_tables_api.c     |    8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 805490d..215edf5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -440,8 +440,9 @@ extern unsigned int nft_do_chain_pktinfo(struct nft_pktinfo *pkt,
  *	@list: used internally
  *	@chains: chains in the table
  *	@sets: sets in the table
- *	@flags: table flag (see enum nft_table_flags)
  *	@hgenerator: handle generator state
+ *	@use: number of chain references to this table
+ *	@flags: table flag (see enum nft_table_flags)
  *	@name: name of the table
  */
 struct nft_table {
@@ -449,6 +450,7 @@ struct nft_table {
 	struct list_head		chains;
 	struct list_head		sets;
 	u64				hgenerator;
+	u32				use;
 	u16				flags;
 	char				name[];
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2b7bf88..c93ce18 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -448,6 +448,9 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
+	if (table->use)
+		return -EBUSY;
+
 	list_del(&table->list);
 	nf_tables_table_notify(skb, nlh, table, NFT_MSG_DELTABLE, family);
 	kfree(table);
@@ -832,6 +835,9 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
+	if (table->use == UINT_MAX)
+		return -EOVERFLOW;
+
 	chain = NULL;
 	name = nla[NFTA_CHAIN_NAME];
 
@@ -986,6 +992,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		}
 	}
 	list_add_tail(&chain->list, &table->chains);
+	table->use++;
 notify:
 	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_NEWCHAIN,
 			       family);
@@ -1031,6 +1038,7 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 		return -EBUSY;
 
 	list_del(&chain->list);
+	table->use--;
 
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    chain->flags & NFT_BASE_CHAIN)
-- 
1.7.10.4

