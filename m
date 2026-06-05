Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA413F4849
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 13:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780665106; cv=none; b=BnRi0DTFCIfDDB2UadQyN4Ont4lns1GnGS6H+8y/xp8kDeeMQseExpXdiWqK119rIPzkaJ1q0jEhossDnXzqz+7lPKtsYEVa4e2sAZDYpmzCYmiYnET3ZKX2OW4vHETUIIjyt0OnKIrhSWHwhPV14K5HNA+p0b1fkCfeTcnqzFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780665106; c=relaxed/simple;
	bh=lwjx4FxtrlQOTSjlPLgfEFQoDSC1gRSthTiCeQsNBAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl0Skbyf6tEoJWRchkP7ZlZPnkWhC0ppcvoO0eBfNWRk+RJCdqpZ9lwMEKaTbIODw5kuxtmhsRImhaQlZnd+rBMIdELTpvCSmRFUErZ7B8U8uYcjNSnw8L5B0kgY8qw2Tcs54Ou1qsgmQAmu8GYHvrMQILiKB/x8ptnCaWL92P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8953060425; Fri, 05 Jun 2026 15:11:43 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 3/5] netfilter: nf_conncount: split count_tree_node rbtree walk into helper
Date: Fri,  5 Jun 2026 15:11:21 +0200
Message-ID: <20260605131123.19435-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605131123.19435-1-fw@strlen.de>
References: <20260605131123.19435-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add find_tree_node() helper that fetches a matching rbtree node.

This is used by followup patch to optionally search the tree again while
preventing concurrent updates via tree lock.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v4: prefer direct lockdep_is_held() use.

 net/netfilter/nf_conncount.c | 102 +++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index faecc05d34d4..56ac64ecfb75 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -488,6 +488,34 @@ insert_tree(struct net *net,
 	return count;
 }
 
+static struct nf_conncount_rb *
+find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
+	       const u32 *key)
+{
+	struct rb_node *parent;
+
+	parent = rcu_dereference_check(root->root.rb_node,
+				       lockdep_is_held(&root->lock));
+	while (parent) {
+		struct nf_conncount_rb *rbconn;
+		int diff;
+
+		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
+
+		diff = key_diff(key, rbconn->key, data->keylen);
+		if (diff < 0)
+			parent = rcu_dereference_check(parent->rb_left,
+						       lockdep_is_held(&root->lock));
+		else if (diff > 0)
+			parent = rcu_dereference_check(parent->rb_right,
+						       lockdep_is_held(&root->lock));
+		else
+			return rbconn;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 static unsigned int
 count_tree(struct net *net,
 	   const struct sk_buff *skb,
@@ -496,59 +524,53 @@ count_tree(struct net *net,
 	   const u32 *key)
 {
 	struct nf_conncount_root *root;
-	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
+	int ret;
 
 	hash = jhash2(key, data->keylen, data->initval) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
-	parent = rcu_dereference(root->root.rb_node);
-	while (parent) {
-		int diff;
-
-		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
+	rbconn = find_tree_node(root, data, key);
+	if (IS_ERR(rbconn)) {
+		if (PTR_ERR(rbconn) == -ENOENT) {
+			if (!skb)
+				return 0;
 
-		diff = key_diff(key, rbconn->key, data->keylen);
-		if (diff < 0) {
-			parent = rcu_dereference(parent->rb_left);
-		} else if (diff > 0) {
-			parent = rcu_dereference(parent->rb_right);
-		} else {
-			int ret;
+			return insert_tree(net, skb, l3num, data, hash, key);
+		}
+		DEBUG_NET_WARN_ON_ONCE(IS_ERR(rbconn));
+	}
 
-			if (!skb) {
-				nf_conncount_gc_list(net, &rbconn->list);
-				return rbconn->list.count;
-			}
+	DEBUG_NET_WARN_ON_ONCE(IS_ERR_OR_NULL(rbconn));
+	if (IS_ERR_OR_NULL(rbconn))
+		return 0;
 
-			spin_lock_bh(&rbconn->list.list_lock);
-			/* Node might be about to be free'd.
-			 * We need to defer to insert_tree() in this case.
-			 */
-			if (rbconn->list.count == 0) {
-				spin_unlock_bh(&rbconn->list.list_lock);
-				break;
-			}
+	if (!skb) {
+		nf_conncount_gc_list(net, &rbconn->list);
+		return rbconn->list.count;
+	}
 
-			/* same source network -> be counted! */
-			ret = __nf_conncount_add(net, skb, l3num, &rbconn->list);
-			spin_unlock_bh(&rbconn->list.list_lock);
-			if (ret && ret != -EEXIST) {
-				return 0; /* hotdrop */
-			} else {
-				/* -EEXIST means add was skipped, update the list */
-				if (ret == -EEXIST)
-					nf_conncount_gc_list(net, &rbconn->list);
-				return rbconn->list.count;
-			}
-		}
+	spin_lock_bh(&rbconn->list.list_lock);
+	/* Node might be about to be free'd.
+	 * We need to defer to insert_tree() in this case.
+	 */
+	if (rbconn->list.count == 0) {
+		spin_unlock_bh(&rbconn->list.list_lock);
+		return insert_tree(net, skb, l3num, data, hash, key);
 	}
 
-	if (!skb)
-		return 0;
+	/* same source network -> be counted! */
+	ret = __nf_conncount_add(net, skb, l3num, &rbconn->list);
+	spin_unlock_bh(&rbconn->list.list_lock);
+
+	if (ret && ret != -EEXIST)
+		return 0; /* hotdrop */
+	/* -EEXIST means add was skipped, update the list */
+	if (ret == -EEXIST)
+		nf_conncount_gc_list(net, &rbconn->list);
 
-	return insert_tree(net, skb, l3num, data, hash, key);
+	return rbconn->list.count;
 }
 
 static void tree_gc_worker(struct work_struct *work)
-- 
2.53.0

