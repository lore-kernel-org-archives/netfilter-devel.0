Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA5C3093B8
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585824; cv=none; b=N440nKMInCZ6cWTzD137UdX0FIzKa804aBcCaJ+u7TidkFIW44WbMmK/flh78PttXq6Vtk8e7MrWXJE6vuGKx/18p43PaWkY6DpJ6qYKJbXByWo6p8kGJ1hiBqwNAaikpxJu5Re0qT+wyIBKWfL9060wQ12fKnSrH/OCOHnITHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585824; c=relaxed/simple;
	bh=W47tP5+OEbLInY+M/9Q35LSnZabaXI3cCc1tLmDKUiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjH3fOr6x7+8KJHOtNYZNbKaKXLYZepn4za22oimVa2/WO6fb158TxNm+ng3o5gGZRRq8ZUdsWsMRnVZ48WBF3rg5eWpY3pp8mbyr8qPdTjjzaOpktcICLW4RPcZRPPWNmzZ7C2b8qZ76Rf/fbXX3ElWC2nfcEvkmdaJxINLeRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0B48C60337; Thu, 04 Jun 2026 17:10:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 4/5] netfilter: nf_conncount: add sequence counter to detect tree modifications
Date: Thu,  4 Jun 2026 17:03:37 +0200
Message-ID: <20260604150338.163592-5-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260604150338.163592-1-fw@strlen.de>
References: <20260604150338.163592-1-fw@strlen.de>
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
 v3: return -EAGAIN if no match found but tree was altered.
 net/netfilter/nf_conncount.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 90d29a8684c0..2183649085b5 100644
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
@@ -493,6 +498,7 @@ find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
 	       const u32 *key,
 	       bool locked)
 {
+	unsigned int seq = read_seqcount_begin(&root->count);
 	struct rb_node *parent;
 
 	parent = rcu_dereference_check(root->root.rb_node, locked);
@@ -509,8 +515,14 @@ find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
 			parent = rcu_dereference_check(parent->rb_right, locked);
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
 
@@ -531,6 +543,12 @@ count_tree(struct net *net,
 
 	rbconn = find_tree_node(root, data, key, false);
 	if (IS_ERR(rbconn)) {
+		if (PTR_ERR(rbconn) == -EAGAIN) {
+			spin_lock_bh(&nf_conncount_locks[hash]);
+			rbconn = find_tree_node(root, data, key, true);
+			spin_unlock_bh(&nf_conncount_locks[hash]);
+		}
+
 		if (PTR_ERR(rbconn) == -ENOENT) {
 			if (!skb)
 				return 0;
@@ -647,6 +665,7 @@ EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
 static void nf_conncount_root_init(struct nf_conncount_root *r)
 {
 	r->root = RB_ROOT;
+	seqcount_init(&r->count);
 }
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
-- 
2.54.0

