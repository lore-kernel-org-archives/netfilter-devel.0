Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F31481FD0
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785949884; cv=none; b=TSXU0LDtdF+VjexUyLs9mCya+8l5AJW/1ILHIaNp4gNKx156sAoPo6v703auT0eBj1G7g2NxgJ7usXn3lnQwOeXtyb57jdZJY6qzfKJqdxfJGltKuGPy31wVhsCK6c+eBbqpKKU9ODaqW4Ip6Gs76D5gRUePUIdwSW17RyuvqXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785949884; c=relaxed/simple;
	bh=UxNACu3mK7vyxXb9WGV10FOOU12ive2o0skwkQCBlhQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biMREQKi1M8tGGK5jWu4jlBqQxu7F+P1OKsSeuicV/ezwkEMHaIdgTIh+VMpGhiOUMdJivOq6naMGQpxP8yvU9PPZw/gA002HZD5hCTB6XOnpyDgFc2b1DyIh5fCnN+GXzAS4w5C+LqT+7eFlu3ZBVeazWbys9ZHT4i1dPn/hr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CM3cEXDw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CM3cEXDw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 798E6601A4
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 19:11:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785949880;
	bh=z9TeIN9RhBKBWCiB2Ubt8LvRgCD7OQAKic7iTaE6GpA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CM3cEXDwv1/DYTrnU88pUj2512pTTw5pyn8ljIu2hRDLnxlU0g/0LNCr7DkhDMCJ3
	 qi+EF2/tlsxQy/Q/XgZDiIznsFLjOJEuw/1NcuI1TwzaYhQ6SspUEm7mH3jBoSFnQu
	 G1ns2IkaRMeAoz7LQ5JWqi/ovyUVBfNfJUUYoAJ5zMDSKzAM8ZEXtKFg6rL2290MuK
	 6vLIpz/gBKqLPamA3HDNSOTW7wR9tBvHXhZFVg4R6V44z2wdnxT6Qwgeocr9BRGJRi
	 Cbaqj/m+v3P5r7x34ySDqjL+zmE4zQZzYnrLRiLQHUX2Wz5FL0NvmF+xSOwaESoRhJ
	 WwAqxtYniu1kg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit when building new ruleset
Date: Wed,  5 Aug 2026 19:11:15 +0200
Message-ID: <20260805171115.250749-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805171115.250749-1-pablo@netfilter.org>
References: <20260805171115.250749-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rbtree set only builds the b-search array after the new ruleset has
been exposed through set ops .commit.

This is currently needed by pipapo because it purges the elements from
the clone after the transactions are handled, therefore, pipapo still
needs the delayed set ops .commit call after the transaction handling.

Allow the rbtree to call .commit before the transaction handling which
purges the stale elements from the frontend rbtree datastructure.

Update rbtree .commit to skip deactivated and expired elements when
building the new b-search array.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
sashiko: there is a timestamp that prevents elements from expiring while
handling the transaction.

v2: - use NFT_GENMASK_ANY for GC scan, theoretically no new element in
      this transaction can expire while handling the transaction but
      let's just skip either new element or deactivated elements from
      the GC scan.
    - remove incorrect reset of previous rbe when performing GC scan.

 net/netfilter/nf_tables_api.c  |  9 ++++++--
 net/netfilter/nft_set_rbtree.c | 38 ++++++++++++++++++++++++++++------
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 90a379533e08..a7006725c307 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10853,11 +10853,14 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
 	}
 }
 
-static void nft_set_commit_update(struct nftables_pernet *nft_net)
+static void nft_set_commit_update(struct nftables_pernet *nft_net, bool early_commit)
 {
 	struct nft_set *set, *next;
 
 	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
+		if (set->ops->abort_skip_removal && early_commit)
+			continue;
+
 		list_del_init(&set->pending_update);
 
 		if (!set->ops->commit || set->dead)
@@ -10964,6 +10967,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* step 2.  Make rules_gen_X visible to packet path */
+	nft_set_commit_update(nft_net, true);
+
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
 			nf_tables_commit_chain(net, chain);
@@ -11170,7 +11175,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
-	nft_set_commit_update(nft_net);
+	nft_set_commit_update(nft_net, false);
 
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 6222e9bb57bc..d908b94540ef 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -901,6 +901,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
 		next = rb_next(node);
 
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
+			continue;
 
 		/* elements are reversed in the rbtree for historical reasons,
 		 * from highest to lowest value, that is why end element is
@@ -1036,10 +1038,32 @@ static void nft_array_free_rcu(struct rcu_head *rcu_head)
 	__nft_array_free(array);
 }
 
+static struct nft_rbtree_elem *
+__nft_rbtree_prev_active(struct rb_node **pnode, u8 genmask)
+{
+	struct nft_rbtree_elem *prev_rbe;
+	struct rb_node *node = *pnode;
+
+	while (node) {
+		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		if (!nft_set_elem_active(&prev_rbe->ext, genmask)) {
+			node = rb_prev(node);
+			continue;
+		}
+
+		*pnode = node;
+		return prev_rbe;
+	}
+
+	return NULL;
+}
+
 static void nft_rbtree_commit(struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe, *prev_rbe;
+	struct net *net = read_pnet(&set->net);
+	u8 genmask = nft_genmask_next(net);
 	struct nft_array *old;
 	u32 num_intervals = 0;
 	struct rb_node *node;
@@ -1061,12 +1085,12 @@ static void nft_rbtree_commit(struct nft_set *set)
 
 	/* Reverse walk to create an array from smaller to largest interval. */
 	node = rb_last(&priv->root);
-	if (node)
-		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
-	else
-		prev_rbe = NULL;
 
-	while (prev_rbe) {
+	while (node) {
+		prev_rbe = __nft_rbtree_prev_active(&node, genmask);
+		if (!prev_rbe)
+			break;
+
 		rbe = prev_rbe;
 
 		if (nft_rbtree_interval_start(rbe))
@@ -1083,7 +1107,9 @@ static void nft_rbtree_commit(struct nft_set *set)
 		if (!node)
 			break;
 
-		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		prev_rbe = __nft_rbtree_prev_active(&node, genmask);
+		if (!prev_rbe)
+			break;
 
 		/* For anonymous sets, when adjacent ranges are found,
 		 * the end element is not added to the set to pack the set
-- 
2.47.3

