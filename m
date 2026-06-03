Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944B2325495
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780527995; cv=none; b=U8tncdHg8GFsQBBDxUr2t6jzMEeRMJxsmi6hGUpmfzEPJ3ilk0YrLrP+MAxVbRCY6BzBeVSZGhSPEdx5KeFiUxlobZ3JxNPKZQl7eyPa119FWzyEoBi6W5CPGxO7ujS/Cizvyk3vDVpT9OiewoR6GG3dpDpbxY7a+uWKodsCRLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780527995; c=relaxed/simple;
	bh=pkYmTc6XzJ5gds0dq89PIqS38F2VS/TpSa1gklSlKBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RazO2fsmWDm6wqXKW9oqd2LLOD7C3go40DEzgDS73SJvFyPhFlWZhYc/eqKIjcGXTnbp1rb6M6h3idk0lltusntrMZ/H1gV5L2fEmvzMs7hVDtjHF7yPs3Z/hYwgpioc/ZP8isgM46PAo7It9/gDc6BoO1HkskUBKKVUwTvwRUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C10E06078A; Thu, 04 Jun 2026 01:06:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 3/4] netfilter: nf_conncount: add sequence counter to detect tree modifications
Date: Thu,  4 Jun 2026 01:06:02 +0200
Message-ID: <20260603230610.7900-4-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260603230610.7900-1-fw@strlen.de>
References: <20260603230610.7900-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There a two issues with traversal:
1. Key lookup (tree search) cannot detect concurrent modifications and may
   not find a result in case of parallel modification.

2. Worker does a lockless iteration.  This is never safe.

Add a sequence counter and re-do the lookup under lock in case the
tree was modified / seqcount changed.

gc_worker bugs are addressed in the next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: new in this iteration (split from last patch)
 net/netfilter/nf_conncount.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8d9c24b69dc9..3c88fb206fb4 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -58,6 +58,7 @@ static spinlock_t nf_conncount_locks[CONNCOUNT_SLOTS] __cacheline_aligned_in_smp
 
 struct nf_conncount_root {
 	struct rb_root root;
+	seqcount_t count;
 };
 
 struct nf_conncount_data {
@@ -382,8 +383,10 @@ static void tree_nodes_free(struct nf_conncount_root *root,
 		rbconn = gc_nodes[--gc_count];
 		spin_lock(&rbconn->list.list_lock);
 		if (!rbconn->list.count) {
+			write_seqcount_begin(&root->count);
 			rb_erase(&rbconn->node, &root->root);
 			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
+			write_seqcount_end(&root->count);
 		}
 		spin_unlock(&rbconn->list.list_lock);
 	}
@@ -478,8 +481,10 @@ insert_tree(struct net *net,
 		count = 1;
 		rbconn->list.count = count;
 
+		write_seqcount_begin(&root->count);
 		rb_link_node_rcu(&rbconn->node, parent, rbnode);
 		rb_insert_color(&rbconn->node, &root->root);
+		write_seqcount_end(&root->count);
 	}
 out_unlock:
 	if (refcounted)
@@ -492,6 +497,7 @@ static struct nf_conncount_rb *
 find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
 	       const u32 *key)
 {
+	unsigned int seq = read_seqcount_begin(&root->count);
 	struct rb_node *parent;
 
 	parent = rcu_dereference_raw(root->root.rb_node);
@@ -509,6 +515,9 @@ find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
 		} else {
 			return rbconn;
 		}
+
+		if (read_seqcount_retry(&root->count, seq))
+			return ERR_PTR(-EAGAIN);
 	}
 
 	return ERR_PTR(-ENOENT);
@@ -531,6 +540,12 @@ count_tree(struct net *net,
 
 	rbconn = find_tree_node(root, data, key);
 	if (IS_ERR(rbconn)) {
+		if (PTR_ERR(rbconn) == -EAGAIN) {
+			spin_lock_bh(&nf_conncount_locks[hash]);
+			rbconn = find_tree_node(root, data, key);
+			spin_unlock_bh(&nf_conncount_locks[hash]);
+		}
+
 		if (PTR_ERR(rbconn) == -ENOENT) {
 			if (!skb)
 				return 0;
@@ -647,6 +662,7 @@ EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
 static void nf_conncount_root_init(struct nf_conncount_root *r)
 {
 	r->root = RB_ROOT;
+	seqcount_init(&r->count);
 }
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
-- 
2.54.0

