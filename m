From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/7] netfilter: nf_tables: pass netns to set->ops->remove()
Date: Wed, 18 Jan 2017 18:30:07 +0100
Message-ID: <1484760613-17236-2-git-send-email-pablo@netfilter.org>
References: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752560AbdARRaY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 12:30:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8903F1392A4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F5E4A7EE4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CA2FA7DB2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:18 +0100 (CET)
In-Reply-To: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is required by the new bitmap set type that comes in a follow up
patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 3 ++-
 net/netfilter/nf_tables_api.c     | 4 ++--
 net/netfilter/nft_set_hash.c      | 3 ++-
 net/netfilter/nft_set_rbtree.c    | 3 ++-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 924325c46aab..1b6fd97d268c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -298,7 +298,8 @@ struct nft_set_ops {
 	bool				(*deactivate_one)(const struct net *net,
 							  const struct nft_set *set,
 							  void *priv);
-	void				(*remove)(const struct nft_set *set,
+	void				(*remove)(const struct net *net,
+						  const struct nft_set *set,
 						  const struct nft_set_elem *elem);
 	void				(*walk)(const struct nft_ctx *ctx,
 						const struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a4619cbf2fe2..6598a48ead2f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4803,7 +4803,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
 						 NFT_MSG_DELSETELEM, 0);
-			te->set->ops->remove(te->set, &te->elem);
+			te->set->ops->remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
 			te->set->ndeact--;
 			break;
@@ -4924,7 +4924,7 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			te->set->ops->remove(te->set, &te->elem);
+			te->set->ops->remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
 			break;
 		case NFT_MSG_DELSETELEM:
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 1e20e2bbb6d9..12df560edee1 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -203,7 +203,8 @@ static void *nft_hash_deactivate(const struct net *net,
 	return he;
 }
 
-static void nft_hash_remove(const struct nft_set *set,
+static void nft_hash_remove(const struct net *net,
+			    const struct nft_set *set,
 			    const struct nft_set_elem *elem)
 {
 	struct nft_hash *priv = nft_set_priv(set);
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 08376e50f6cd..afccbd2aee31 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -151,7 +151,8 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	return err;
 }
 
-static void nft_rbtree_remove(const struct nft_set *set,
+static void nft_rbtree_remove(const struct net *net,
+			      const struct nft_set *set,
 			      const struct nft_set_elem *elem)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
-- 
2.1.4

