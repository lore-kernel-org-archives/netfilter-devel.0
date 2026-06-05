Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478A30D403
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780665110; cv=none; b=Np8uEjoqTBS2R5zbf1e/a5auawvjExALplZp5y81pAmRCheur/PMm46X8Y907cNRqcmb+sQEFVmP/uKf0rKGkhg3MmClZpYSihL64G1IHIVLQubg/w5rUgv9EKy36GuhSjtS0l2Dx9GjLNaBh8R25AsszHHoR+Fio1YAUsN/1nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780665110; c=relaxed/simple;
	bh=FElTRxisZvh+zXx2yjNpjhtcCzEhSEk/fa0mUK0GswQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7NO4EZwnTLBkgYbc40iyTcrY6o/Mn0WTXmNl8RUZR04PhcSXn4pwT8d8Sxxv6KVLl6Bt31VUb0dqJ5R1Fx07O7Spyja4ij9X7HJHzOBPTqng0llMG2y0kdfpYSqGjujErHwD8C+eos92Vco9NAg1MzbGJE78YadvHrYsZS05jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CA4B460425; Fri, 05 Jun 2026 15:11:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 4/5] netfilter: nf_conncount: add sequence counter to detect tree modifications
Date: Fri,  5 Jun 2026 15:11:22 +0200
Message-ID: <20260605131123.19435-5-fw@strlen.de>
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

There a two issues with traversal:
1. Key lookup (tree search) cannot detect concurrent modifications and may
   not find a result in case of parallel modification.

2. Worker does a lockless iteration.  This is never safe.

Add a sequence counter and re-do the lookup under lock in case the
tree was modified / seqcount changed.

gc_worker bugs are addressed in the next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v4: use seqcount_spinlock_t.

 net/netfilter/nf_conncount.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 56ac64ecfb75..1247cbe77740 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -57,6 +57,7 @@ struct nf_conncount_rb {
 struct nf_conncount_root {
 	struct rb_root root;
 	spinlock_t lock;
+	seqcount_spinlock_t count;
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
 
 	parent = rcu_dereference_check(root->root.rb_node,
@@ -511,8 +517,14 @@ find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
 						       lockdep_is_held(&root->lock));
 		else
 			return rbconn;
+
+		if (read_seqcount_retry(&root->count, seq))
+			return ERR_PTR(-EAGAIN);
 	}
 
+	if (read_seqcount_retry(&root->count, seq))
+		return ERR_PTR(-EAGAIN);
+
 	return ERR_PTR(-ENOENT);
 }
 
@@ -533,6 +545,12 @@ count_tree(struct net *net,
 
 	rbconn = find_tree_node(root, data, key);
 	if (IS_ERR(rbconn)) {
+		if (PTR_ERR(rbconn) == -EAGAIN) {
+			spin_lock_bh(&root->lock);
+			rbconn = find_tree_node(root, data, key);
+			spin_unlock_bh(&root->lock);
+		}
+
 		if (PTR_ERR(rbconn) == -ENOENT) {
 			if (!skb)
 				return 0;
@@ -650,6 +668,7 @@ static void nf_conncount_root_init(struct nf_conncount_root *r)
 {
 	r->root = RB_ROOT;
 	spin_lock_init(&r->lock);
+	seqcount_spinlock_init(&r->count, &r->lock);
 }
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
-- 
2.53.0

