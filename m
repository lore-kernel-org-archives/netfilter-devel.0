Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5544314A85
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762947919; cv=none; b=ph1W1LGI7zR5rjH1r4RNQy119YSjYEfCA3BEOL0CmXfRIpJhWn43QRc5A4alWtMGM3hmNM4zTYZnbkgYTTiM6FfKIdFZZioRXEQXECzPA4adrQ0OyYvOQlQrnR5Urj8Xhg9EgGeAUaWlOrzLQKOn6kvY5XCS0+yYpRjgtcS40fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762947919; c=relaxed/simple;
	bh=4iTDY5K/RA7aSTuuOP+/HgkewuHml2BvS0RlaiL5KrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJwSzrjuqFt4fWQqJV1MyYwEUN6BHRuBYgIPnDMzMIkdEJuOiKoCmxrxf5oLt79P2T+OPexRUF4+kkFiiIR6orJ5loMFUSo+N0g8jMt+PmR99kYXiFH+kL6442oTfMA7k1Uxw+HDCgRWGUEzDciQcCDJtNCQa9YEScH70KErfZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B37F91F45B;
	Wed, 12 Nov 2025 11:45:14 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 275FD3EA61;
	Wed, 12 Nov 2025 11:45:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0MihBkpzFGmvCQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 12 Nov 2025 11:45:14 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	aconole@redhat.com,
	echaudro@redhat.com,
	i.maximets@ovn.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/6 nf-next v3] netfilter: nf_conncount: pass the sk_buff down to __nf_conncount_add()
Date: Wed, 12 Nov 2025 12:43:50 +0100
Message-ID: <20251112114351.3273-6-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112114351.3273-2-fmancera@suse.de>
References: <20251112114351.3273-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: B37F91F45B
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

When using nf_conncount infrastructure for non-confirmed connections a
duplicated track is possible due to an optimization introduced since
commit d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC").

This is solved by passing the sk_buff down to __nf_conncount_add() and
there if the ct is present and already confirmed, skip the add
operation.

As __nf_conncount_add() is now handling the sk_buff directly, introduce
a new API nf_conncount_add_skb() similar to the already introduced
nf_conncount_count_skb(). In addition, add a helper function to fetch
tuple, zone and ct from the skb to avoid duplicated code.

Use the newly introduce API from nft_connlimit.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/net/netfilter/nf_conntrack_count.h |   5 +-
 net/netfilter/nf_conncount.c               | 175 ++++++++++++---------
 net/netfilter/nft_connlimit.c              |  21 +--
 3 files changed, 107 insertions(+), 94 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 8d980f7bff8e..52a06de41aa0 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -24,9 +24,8 @@ unsigned int nf_conncount_count_skb(struct net *net,
 				    struct nf_conncount_data *data,
 				    const u32 *key);
 
-int nf_conncount_add(struct net *net, struct nf_conncount_list *list,
-		     const struct nf_conntrack_tuple *tuple,
-		     const struct nf_conntrack_zone *zone);
+int nf_conncount_add_skb(struct net *net, const struct sk_buff *skb,
+			 u16 l3num, struct nf_conncount_list *list);
 
 void nf_conncount_list_init(struct nf_conncount_list *list);
 
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index fc5798db7727..e6d30a54b1fc 100644
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
+		return -EINVAL;
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
@@ -375,19 +432,24 @@ insert_tree(struct net *net,
 		goto out_unlock;
 	}
 
-	conn->tuple = *tuple;
-	conn->zone = *zone;
-	conn->cpu = raw_smp_processor_id();
-	conn->jiffies32 = (u32)jiffies;
-	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
+	if (get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted)) {
+		conn->tuple = tuple;
+		conn->zone = *zone;
+		conn->cpu = raw_smp_processor_id();
+		conn->jiffies32 = (u32)jiffies;
+		memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
 
-	nf_conncount_list_init(&rbconn->list);
-	list_add(&conn->node, &rbconn->list.head);
-	count = 1;
-	rbconn->list.count = count;
+		nf_conncount_list_init(&rbconn->list);
+		list_add(&conn->node, &rbconn->list.head);
+		count = 1;
+		rbconn->list.count = count;
 
-	rb_link_node_rcu(&rbconn->node, parent, rbnode);
-	rb_insert_color(&rbconn->node, root);
+		rb_link_node_rcu(&rbconn->node, parent, rbnode);
+		rb_insert_color(&rbconn->node, root);
+
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
@@ -520,41 +582,8 @@ unsigned int nf_conncount_count_skb(struct net *net,
 				    struct nf_conncount_data *data,
 				    const u32 *key)
 {
-	const struct nf_conntrack_tuple_hash *h;
-	const struct nf_conntrack_zone *zone;
-	struct nf_conntrack_tuple tuple;
-	enum ip_conntrack_info ctinfo;
-	unsigned int connections;
-	struct nf_conn *ct;
-
-	if (!skb)
-		return count_tree(net, data, key, NULL, NULL);
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct && !nf_ct_is_template(ct))
-		return count_tree(net, data, key,
-				  &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-				  nf_ct_zone(ct));
-
-	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), l3num, net, &tuple))
-		return 0;
-
-	if (ct)
-		zone = nf_ct_zone(ct);
-	else
-		zone = &nf_ct_zone_dflt;
-
-	h = nf_conntrack_find_get(net, zone, &tuple);
-	if (!h)
-		return count_tree(net, data, key, &tuple, zone);
-
-	ct = nf_ct_tuplehash_to_ctrack(h);
-	connections = count_tree(net, data, key,
-				 &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-				 zone);
-	nf_ct_put(ct);
+	return count_tree(net, skb, l3num, data, key);
 
-	return connections;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index fc35a11cdca2..4bee5a8f9ef8 100644
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
+	if (err != EINVAL) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
-- 
2.51.0

