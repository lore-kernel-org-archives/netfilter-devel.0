Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEF0246BB2;
	Fri, 28 Nov 2025 00:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289448; cv=none; b=cFnTmqi1b2l4UeCSU3gqDeEQctw9XauasAinmErPhcN8YLHBpB/QCoDnJg4+PElQRQX8UF8X8nPFgkVc8p63hnVK9UH6BmHe/LsEK8uqzZgjpVzc9ZJSTCd732SyW7f74as4HFr/34COxcXftATBle3IfPwPVLBLiYeAJxztBbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289448; c=relaxed/simple;
	bh=1RxReY9a1M2BAMWWtq7dz4c6uJlRqTIhUsd5CzbUcLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANRiYIx9L2aIbiTdvdy16de6XRMbzOOVwCttWZGnRTDlEXp8u4irza3ATkuOOUlO/0JP7cHF7dPsDAcVSyO/59GZeYAxerVs6XlFPYhOYRQrnf3iu3I8K+kLk46hUcB1ba/uW+ctmgatv39bBJrKb5Sj306TkDLsW1zd1p//xts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S+KCMxCj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S+KCMxCj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A3E8260254;
	Fri, 28 Nov 2025 01:24:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289443;
	bh=IcLYd6R6cqS6ZIW52Dc6VPrQshx5Gdvi/FvS1j5nFOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+KCMxCj/cllAJLT7xf8IRS/NQrvEBrggemzI83E08ny3Fx80MSqUbWqNTf6CKPP7
	 3MJ4Exc7NiJR78URxrnvlobddksv6S6tqA04AYKSdeL5jxi59SwRLNMcUoOyEN/f8Z
	 RM/uc+JzJbW4UsSVk+2sq2zkqFDPv7C21dNfh6lZM4b1MaXmgDPef0OSVwBmPWd29d
	 IiIQmQvdFrk9g87fXuk7LnGR7FlikxUEPi+kijn4JAUFFpkK0xHOk6OVVE6Ib9zyBF
	 WuScexTzCvCg/oVIrwZM3+WN0FZONlkKaTA8U5275jMga6ET6kJrJ3KWRgl68fF1eS
	 AQaTe2bTVBHPg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 11/17] netfilter: nf_conncount: rework API to use sk_buff directly
Date: Fri, 28 Nov 2025 00:23:38 +0000
Message-ID: <20251128002345.29378-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

When using nf_conncount infrastructure for non-confirmed connections a
duplicated track is possible due to an optimization introduced since
commit d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC").

In order to fix this introduce a new conncount API that receives
directly an sk_buff struct.  It fetches the tuple and zone and the
corresponding ct from it. It comes with both existing conncount variants
nf_conncount_count_skb() and nf_conncount_add_skb(). In addition remove
the old API and adjust all the users to use the new one.

This way, for each sk_buff struct it is possible to check if there is a
ct present and already confirmed. If so, skip the add operation.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h |  17 +-
 net/netfilter/nf_conncount.c               | 177 ++++++++++++++-------
 net/netfilter/nft_connlimit.c              |  21 +--
 net/netfilter/xt_connlimit.c               |  14 +-
 net/openvswitch/conntrack.c                |  16 +-
 5 files changed, 142 insertions(+), 103 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 1b58b5b91ff6..52a06de41aa0 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -18,15 +18,14 @@ struct nf_conncount_list {
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen);
 void nf_conncount_destroy(struct net *net, struct nf_conncount_data *data);
 
-unsigned int nf_conncount_count(struct net *net,
-				struct nf_conncount_data *data,
-				const u32 *key,
-				const struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_zone *zone);
-
-int nf_conncount_add(struct net *net, struct nf_conncount_list *list,
-		     const struct nf_conntrack_tuple *tuple,
-		     const struct nf_conntrack_zone *zone);
+unsigned int nf_conncount_count_skb(struct net *net,
+				    const struct sk_buff *skb,
+				    u16 l3num,
+				    struct nf_conncount_data *data,
+				    const u32 *key);
+
+int nf_conncount_add_skb(struct net *net, const struct sk_buff *skb,
+			 u16 l3num, struct nf_conncount_list *list);
 
 void nf_conncount_list_init(struct nf_conncount_list *list);
 
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 913ede2f57f9..0ffc5ff78a71 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -122,15 +122,65 @@ find_or_evict(struct net *net, struct nf_conncount_list *list,
 	return ERR_PTR(-EAGAIN);
 }
 
+static bool get_ct_or_tuple_from_skb(struct net *net,
+				     const struct sk_buff *skb,
+				     u16 l3num,
+				     struct nf_conn **ct,
+				     struct nf_conntrack_tuple *tuple,
+				     const struct nf_conntrack_zone **zone,
+				     bool *refcounted)
+{
+	const struct nf_conntrack_tuple_hash *h;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *found_ct;
+
+	found_ct = nf_ct_get(skb, &ctinfo);
+	if (found_ct && !nf_ct_is_template(found_ct)) {
+		*tuple = found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		*zone = nf_ct_zone(found_ct);
+		*ct = found_ct;
+		return true;
+	}
+
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), l3num, net, tuple))
+		return false;
+
+	if (found_ct)
+		*zone = nf_ct_zone(found_ct);
+
+	h = nf_conntrack_find_get(net, *zone, tuple);
+	if (!h)
+		return true;
+
+	found_ct = nf_ct_tuplehash_to_ctrack(h);
+	*refcounted = true;
+	*ct = found_ct;
+
+	return true;
+}
+
 static int __nf_conncount_add(struct net *net,
-			      struct nf_conncount_list *list,
-			      const struct nf_conntrack_tuple *tuple,
-			      const struct nf_conntrack_zone *zone)
+			      const struct sk_buff *skb,
+			      u16 l3num,
+			      struct nf_conncount_list *list)
 {
+	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conn *ct = NULL;
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
+	bool refcounted = false;
+
+	if (!get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted))
+		return -ENOENT;
+
+	if (ct && nf_ct_is_confirmed(ct)) {
+		if (refcounted)
+			nf_ct_put(ct);
+		return 0;
+	}
 
 	if ((u32)jiffies == list->last_gc)
 		goto add_new_node;
@@ -144,10 +194,10 @@ static int __nf_conncount_add(struct net *net,
 		if (IS_ERR(found)) {
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
-				if (nf_ct_tuple_equal(&conn->tuple, tuple) &&
+				if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
 				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
 				    nf_ct_zone_id(zone, zone->dir))
-					return 0; /* already exists */
+					goto out_put; /* already exists */
 			} else {
 				collect++;
 			}
@@ -156,7 +206,7 @@ static int __nf_conncount_add(struct net *net,
 
 		found_ct = nf_ct_tuplehash_to_ctrack(found);
 
-		if (nf_ct_tuple_equal(&conn->tuple, tuple) &&
+		if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
 		    nf_ct_zone_equal(found_ct, zone, zone->dir)) {
 			/*
 			 * We should not see tuples twice unless someone hooks
@@ -165,7 +215,7 @@ static int __nf_conncount_add(struct net *net,
 			 * Attempt to avoid a re-add in this case.
 			 */
 			nf_ct_put(found_ct);
-			return 0;
+			goto out_put;
 		} else if (already_closed(found_ct)) {
 			/*
 			 * we do not care about connections which are
@@ -188,31 +238,35 @@ static int __nf_conncount_add(struct net *net,
 	if (conn == NULL)
 		return -ENOMEM;
 
-	conn->tuple = *tuple;
+	conn->tuple = tuple;
 	conn->zone = *zone;
 	conn->cpu = raw_smp_processor_id();
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
 	list->last_gc = (u32)jiffies;
+
+out_put:
+	if (refcounted)
+		nf_ct_put(ct);
 	return 0;
 }
 
-int nf_conncount_add(struct net *net,
-		     struct nf_conncount_list *list,
-		     const struct nf_conntrack_tuple *tuple,
-		     const struct nf_conntrack_zone *zone)
+int nf_conncount_add_skb(struct net *net,
+			 const struct sk_buff *skb,
+			 u16 l3num,
+			 struct nf_conncount_list *list)
 {
 	int ret;
 
 	/* check the saved connections */
 	spin_lock_bh(&list->list_lock);
-	ret = __nf_conncount_add(net, list, tuple, zone);
+	ret = __nf_conncount_add(net, skb, l3num, list);
 	spin_unlock_bh(&list->list_lock);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_conncount_add);
+EXPORT_SYMBOL_GPL(nf_conncount_add_skb);
 
 void nf_conncount_list_init(struct nf_conncount_list *list)
 {
@@ -309,19 +363,22 @@ static void schedule_gc_worker(struct nf_conncount_data *data, int tree)
 
 static unsigned int
 insert_tree(struct net *net,
+	    const struct sk_buff *skb,
+	    u16 l3num,
 	    struct nf_conncount_data *data,
 	    struct rb_root *root,
 	    unsigned int hash,
-	    const u32 *key,
-	    const struct nf_conntrack_tuple *tuple,
-	    const struct nf_conntrack_zone *zone)
+	    const u32 *key)
 {
 	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES];
+	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
+	bool do_gc = true, refcounted = false;
+	unsigned int count = 0, gc_count = 0;
 	struct rb_node **rbnode, *parent;
-	struct nf_conncount_rb *rbconn;
+	struct nf_conntrack_tuple tuple;
 	struct nf_conncount_tuple *conn;
-	unsigned int count = 0, gc_count = 0;
-	bool do_gc = true;
+	struct nf_conncount_rb *rbconn;
+	struct nf_conn *ct = NULL;
 
 	spin_lock_bh(&nf_conncount_locks[hash]);
 restart:
@@ -340,7 +397,7 @@ insert_tree(struct net *net,
 		} else {
 			int ret;
 
-			ret = nf_conncount_add(net, &rbconn->list, tuple, zone);
+			ret = nf_conncount_add_skb(net, skb, l3num, &rbconn->list);
 			if (ret)
 				count = 0; /* hotdrop */
 			else
@@ -364,30 +421,35 @@ insert_tree(struct net *net,
 		goto restart;
 	}
 
-	/* expected case: match, insert new node */
-	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
-	if (rbconn == NULL)
-		goto out_unlock;
+	if (get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted)) {
+		/* expected case: match, insert new node */
+		rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
+		if (rbconn == NULL)
+			goto out_unlock;
 
-	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
-	if (conn == NULL) {
-		kmem_cache_free(conncount_rb_cachep, rbconn);
-		goto out_unlock;
-	}
+		conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
+		if (conn == NULL) {
+			kmem_cache_free(conncount_rb_cachep, rbconn);
+			goto out_unlock;
+		}
 
-	conn->tuple = *tuple;
-	conn->zone = *zone;
-	conn->cpu = raw_smp_processor_id();
-	conn->jiffies32 = (u32)jiffies;
-	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
+		conn->tuple = tuple;
+		conn->zone = *zone;
+		conn->cpu = raw_smp_processor_id();
+		conn->jiffies32 = (u32)jiffies;
+		memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
+
+		nf_conncount_list_init(&rbconn->list);
+		list_add(&conn->node, &rbconn->list.head);
+		count = 1;
+		rbconn->list.count = count;
 
-	nf_conncount_list_init(&rbconn->list);
-	list_add(&conn->node, &rbconn->list.head);
-	count = 1;
-	rbconn->list.count = count;
+		rb_link_node_rcu(&rbconn->node, parent, rbnode);
+		rb_insert_color(&rbconn->node, root);
 
-	rb_link_node_rcu(&rbconn->node, parent, rbnode);
-	rb_insert_color(&rbconn->node, root);
+		if (refcounted)
+			nf_ct_put(ct);
+	}
 out_unlock:
 	spin_unlock_bh(&nf_conncount_locks[hash]);
 	return count;
@@ -395,10 +457,10 @@ insert_tree(struct net *net,
 
 static unsigned int
 count_tree(struct net *net,
+	   const struct sk_buff *skb,
+	   u16 l3num,
 	   struct nf_conncount_data *data,
-	   const u32 *key,
-	   const struct nf_conntrack_tuple *tuple,
-	   const struct nf_conntrack_zone *zone)
+	   const u32 *key)
 {
 	struct rb_root *root;
 	struct rb_node *parent;
@@ -422,7 +484,7 @@ count_tree(struct net *net,
 		} else {
 			int ret;
 
-			if (!tuple) {
+			if (!skb) {
 				nf_conncount_gc_list(net, &rbconn->list);
 				return rbconn->list.count;
 			}
@@ -437,7 +499,7 @@ count_tree(struct net *net,
 			}
 
 			/* same source network -> be counted! */
-			ret = __nf_conncount_add(net, &rbconn->list, tuple, zone);
+			ret = __nf_conncount_add(net, skb, l3num, &rbconn->list);
 			spin_unlock_bh(&rbconn->list.list_lock);
 			if (ret)
 				return 0; /* hotdrop */
@@ -446,10 +508,10 @@ count_tree(struct net *net,
 		}
 	}
 
-	if (!tuple)
+	if (!skb)
 		return 0;
 
-	return insert_tree(net, data, root, hash, key, tuple, zone);
+	return insert_tree(net, skb, l3num, data, root, hash, key);
 }
 
 static void tree_gc_worker(struct work_struct *work)
@@ -511,18 +573,19 @@ static void tree_gc_worker(struct work_struct *work)
 }
 
 /* Count and return number of conntrack entries in 'net' with particular 'key'.
- * If 'tuple' is not null, insert it into the accounting data structure.
- * Call with RCU read lock.
+ * If 'skb' is not null, insert the corresponding tuple into the accounting
+ * data structure. Call with RCU read lock.
  */
-unsigned int nf_conncount_count(struct net *net,
-				struct nf_conncount_data *data,
-				const u32 *key,
-				const struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_zone *zone)
+unsigned int nf_conncount_count_skb(struct net *net,
+				    const struct sk_buff *skb,
+				    u16 l3num,
+				    struct nf_conncount_data *data,
+				    const u32 *key)
 {
-	return count_tree(net, data, key, tuple, zone);
+	return count_tree(net, skb, l3num, data, key);
+
 }
-EXPORT_SYMBOL_GPL(nf_conncount_count);
+EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
 {
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index fc35a11cdca2..5df7134131d2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -24,26 +24,11 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 					 const struct nft_pktinfo *pkt,
 					 const struct nft_set_ext *ext)
 {
-	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
-	const struct nf_conntrack_tuple *tuple_ptr;
-	struct nf_conntrack_tuple tuple;
-	enum ip_conntrack_info ctinfo;
-	const struct nf_conn *ct;
 	unsigned int count;
+	int err;
 
-	tuple_ptr = &tuple;
-
-	ct = nf_ct_get(pkt->skb, &ctinfo);
-	if (ct != NULL) {
-		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-		zone = nf_ct_zone(ct);
-	} else if (!nf_ct_get_tuplepr(pkt->skb, skb_network_offset(pkt->skb),
-				      nft_pf(pkt), nft_net(pkt), &tuple)) {
-		regs->verdict.code = NF_DROP;
-		return;
-	}
-
-	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
+	err = nf_conncount_add_skb(nft_net(pkt), pkt->skb, nft_pf(pkt), priv->list);
+	if (err) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 0189f8b6b0bd..848287ab79cf 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -31,8 +31,6 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct net *net = xt_net(par);
 	const struct xt_connlimit_info *info = par->matchinfo;
-	struct nf_conntrack_tuple tuple;
-	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
 	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
@@ -40,13 +38,8 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	u32 key[5];
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct != NULL) {
-		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	if (ct)
 		zone = nf_ct_zone(ct);
-	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-				      xt_family(par), net, &tuple)) {
-		goto hotdrop;
-	}
 
 	if (xt_family(par) == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
@@ -69,10 +62,9 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		key[1] = zone->id;
 	}
 
-	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
-					 zone);
+	connections = nf_conncount_count_skb(net, skb, xt_family(par), info->data, key);
 	if (connections == 0)
-		/* kmalloc failed, drop it entirely */
+		/* kmalloc failed or tuple couldn't be found, drop it entirely */
 		goto hotdrop;
 
 	return (connections > info->limit) ^ !!(info->flags & XT_CONNLIMIT_INVERT);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e573e9221302..a0811e1fba65 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -928,8 +928,8 @@ static u32 ct_limit_get(const struct ovs_ct_limit_info *info, u16 zone)
 }
 
 static int ovs_ct_check_limit(struct net *net,
-			      const struct ovs_conntrack_info *info,
-			      const struct nf_conntrack_tuple *tuple)
+			      const struct sk_buff *skb,
+			      const struct ovs_conntrack_info *info)
 {
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
 	const struct ovs_ct_limit_info *ct_limit_info = ovs_net->ct_limit_info;
@@ -942,8 +942,9 @@ static int ovs_ct_check_limit(struct net *net,
 	if (per_zone_limit == OVS_CT_LIMIT_UNLIMITED)
 		return 0;
 
-	connections = nf_conncount_count(net, ct_limit_info->data,
-					 &conncount_key, tuple, &info->zone);
+	connections = nf_conncount_count_skb(net, skb, info->family,
+					     ct_limit_info->data,
+					     &conncount_key);
 	if (connections > per_zone_limit)
 		return -ENOMEM;
 
@@ -972,8 +973,7 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	if (static_branch_unlikely(&ovs_ct_limit_enabled)) {
 		if (!nf_ct_is_confirmed(ct)) {
-			err = ovs_ct_check_limit(net, info,
-				&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+			err = ovs_ct_check_limit(net, skb, info);
 			if (err) {
 				net_warn_ratelimited("openvswitch: zone: %u "
 					"exceeds conntrack limit\n",
@@ -1770,8 +1770,8 @@ static int __ovs_ct_limit_get_zone_limit(struct net *net,
 	zone_limit.limit = limit;
 	nf_ct_zone_init(&ct_zone, zone_id, NF_CT_DEFAULT_ZONE_DIR, 0);
 
-	zone_limit.count = nf_conncount_count(net, data, &conncount_key, NULL,
-					      &ct_zone);
+	zone_limit.count = nf_conncount_count_skb(net, NULL, 0, data,
+						  &conncount_key);
 	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
 }
 
-- 
2.47.3

