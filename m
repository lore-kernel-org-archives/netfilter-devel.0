From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/3] netfilter: nft_set: introduce nft_{hash,rbtree}_deactivate_one()
Date: Mon,  5 Dec 2016 23:35:49 +0100
Message-ID: <1480977350-14873-2-git-send-email-pablo@netfilter.org>
References: <1480977350-14873-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbcLEWgJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 17:36:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 160971DF5BD
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:35:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05B5BDA729
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:35:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 200A1DA729
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:35:56 +0100 (CET)
In-Reply-To: <1480977350-14873-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new function allows us to deactivate one single element, this is
required by the set flush command that comes in a follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c   | 24 +++++++++++++++++-------
 net/netfilter/nft_set_rbtree.c | 11 ++++++++++-
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index a3dface3e6e6..73f7687c5656 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -167,6 +167,19 @@ static void nft_hash_activate(const struct net *net, const struct nft_set *set,
 	nft_set_elem_clear_busy(&he->ext);
 }
 
+static bool nft_hash_deactivate_one(const struct net *net,
+				    const struct nft_set *set, void *priv)
+{
+	struct nft_hash_elem *he = priv;
+
+	if (!nft_set_elem_mark_busy(&he->ext) ||
+	    !nft_is_active(net, &he->ext)) {
+		nft_set_elem_change_active(net, set, &he->ext);
+		return true;
+	}
+	return false;
+}
+
 static void *nft_hash_deactivate(const struct net *net,
 				 const struct nft_set *set,
 				 const struct nft_set_elem *elem)
@@ -181,13 +194,10 @@ static void *nft_hash_deactivate(const struct net *net,
 
 	rcu_read_lock();
 	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_hash_params);
-	if (he != NULL) {
-		if (!nft_set_elem_mark_busy(&he->ext) ||
-		    !nft_is_active(net, &he->ext))
-			nft_set_elem_change_active(net, set, &he->ext);
-		else
-			he = NULL;
-	}
+	if (he != NULL &&
+	    !nft_hash_deactivate_one(net, set, he))
+		he = NULL;
+
 	rcu_read_unlock();
 
 	return he;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 36493a7cae88..845bbdb26853 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -171,6 +171,15 @@ static void nft_rbtree_activate(const struct net *net,
 	nft_set_elem_change_active(net, set, &rbe->ext);
 }
 
+static bool nft_rbtree_deactivate_one(const struct net *net,
+				      const struct nft_set *set, void *priv)
+{
+	struct nft_rbtree_elem *rbe = priv;
+
+	nft_set_elem_change_active(net, set, &rbe->ext);
+	return true;
+}
+
 static void *nft_rbtree_deactivate(const struct net *net,
 				   const struct nft_set *set,
 				   const struct nft_set_elem *elem)
@@ -204,7 +213,7 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				parent = parent->rb_right;
 				continue;
 			}
-			nft_set_elem_change_active(net, set, &rbe->ext);
+			nft_rbtree_deactivate_one(net, set, &rbe->ext);
 			return rbe;
 		}
 	}
-- 
2.1.4

