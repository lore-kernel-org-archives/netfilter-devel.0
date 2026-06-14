Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7055395AED;
	Sun, 14 Jun 2026 11:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437581; cv=none; b=XvGAlLtTdjr1zbWCErDuo/1vzNjjHr69xc+DFG1HF2fscuYxGIp687tiulDLerU5sr+ja98Aibu4l367ov/nSluDko3E26Q7S+b9Uie/8+GsN0t6+BHeP10YyxRlX9JOCmVrwVQGgE3UBw5cLGwVDfy3kWFWX9wrSnHl2pQIczs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437581; c=relaxed/simple;
	bh=SKLvLK0WhkPc1tMS9Uic5KJ1+kgLPUDK+VSI45IoSxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StAhiKD/YEcQZ6A/+6ibQn/IpmvO0oLJdrf3ytN3PQe/brIQTjycH3aen5Kxgr1HBhyutu49dDidr4o6HWYwhnAcQH7Xlpk23B2yV3ZwpyN2yVg9Wk0mOSAebhy/+bIpqbPj9vFSJRpOADU376ZwuUv/VlE9+rkBSRsBETKR2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Cvf7cSAX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Cvf7cSAX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E9D24601A1;
	Sun, 14 Jun 2026 13:46:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437578;
	bh=hqQnVPzPxUFtKjTeb5OhoVNxC6sTczmxNk/q104Vejk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cvf7cSAXE2sWNMgdbiiwdEKwqbL7iJo0hy0YhgYk7UIY1xlM7CJU2dYX45Q/3SHdq
	 tWNxsFlmcE0qE9zxeawGDZln1hH2+p54cEtbpJU39twIplnjhRJmHrabEql2SCFU+S
	 +17FXvyEPYkkj1wLMncdPi/ZDzlenWT6YdolNgGYtAjPSLWguAIKC4mONtIaruPokW
	 fSBl1qArfGLuTLxz5+kFPcNVA5YyaGr0cRv4R5JJ7IhPuKAGeClAU/sylPIiubVNoa
	 6cwLKMXH6SJ6GnINzVBqs8NaOnKAlcluWjPj3Rk1KpIQVhleEJf7KouAfubwFAiqNF
	 joh8cMkZSdzYA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 06/11] netfilter: nf_conncount: add sequence counter to detect tree modifications
Date: Sun, 14 Jun 2026 13:46:00 +0200
Message-ID: <20260614114605.474783-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

There a two issues with traversal:
1. Key lookup (tree search) cannot detect concurrent modifications and may
   not find a result in case of parallel modification.

2. Worker does a lockless iteration.  This is never safe.

Add a sequence counter and re-do the lookup under lock in case the
tree was modified / seqcount changed.

gc_worker bugs are addressed in the next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.47.3

