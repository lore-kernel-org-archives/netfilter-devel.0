Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F941487F6
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789415; cv=none; b=LlEJ//1mFNzXBdhsqj02jSFQDHn0oVPvqvjKN8ShWFbThtsF2QCdmeW69SmE8jR98FsdOhodLtAtlt6zFPjh+TqesMY5iwstm5ZLi06kaFcUuSuqIXlxAg0S1TnDqHW8aEXxBDCktwTkeIGn0f47wUtc4Hx6Yr56zWI+MEDcmRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789415; c=relaxed/simple;
	bh=Hx3ajUVfhrFkkrEJAle6ZXnJD82CvyC+pS5qOXHv+qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0dfpyKVCsK/dGkMSZC85Sj62oLQrhtXFrvWrvh45YW6Aox0qljNmtxF260AZ7Noz3266qOjVgul9vFVi+tLkCE8qElcD9fflV0Yuux5EOKJx88lwGEZwacKEG6nzogniEJsPmGt1vW0Pi70wEnq4GbnR6jWNQG/6lRwuvdusBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3BA7B21D33;
	Mon, 10 Nov 2025 15:43:31 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AAFE914480;
	Mon, 10 Nov 2025 15:43:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OMPnJiIIEmkWWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 10 Nov 2025 15:43:30 +0000
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
Subject: [PATCH 2/4 nf-next v2] netfilter: nf_conncount: only track connection if it is not confirmed
Date: Mon, 10 Nov 2025 16:42:47 +0100
Message-ID: <20251110154249.3586-3-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110154249.3586-1-fmancera@suse.de>
References: <20251110154249.3586-1-fmancera@suse.de>
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
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 3BA7B21D33
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

Since commit d265929930e2 ("netfilter: nf_conncount: reduce unnecessary
GC") if nftables/iptables connlimit is used without a check for new
connections there can be duplicated entries tracked.

Pass the nf_conn struct directly to the nf_conncount API and check
whether the connection is confirmed or not inside nf_conncount_add(). If
the connection is confirmed, skip it.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: handle the ct refcount, avoid copy-paste by using the helper
introduced in the new commit "nf_ct_find_or_get"
---
 include/net/netfilter/nf_conntrack_count.h | 10 +---
 net/netfilter/nf_conncount.c               | 70 ++++++++++++----------
 net/netfilter/nft_connlimit.c              | 31 +++++-----
 net/netfilter/xt_connlimit.c               | 27 ++++-----
 net/openvswitch/conntrack.c                | 14 ++---
 5 files changed, 70 insertions(+), 82 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 1b58b5b91ff6..4fc2fb03d093 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -18,15 +18,11 @@ struct nf_conncount_list {
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen);
 void nf_conncount_destroy(struct net *net, struct nf_conncount_data *data);
 
-unsigned int nf_conncount_count(struct net *net,
+unsigned int nf_conncount_count(struct net *net, const struct nf_conn *ct,
 				struct nf_conncount_data *data,
-				const u32 *key,
-				const struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_zone *zone);
+				const u32 *key);
 
-int nf_conncount_add(struct net *net, struct nf_conncount_list *list,
-		     const struct nf_conntrack_tuple *tuple,
-		     const struct nf_conntrack_zone *zone);
+int nf_conncount_add(const struct nf_conn *ct, struct nf_conncount_list *list);
 
 void nf_conncount_list_init(struct nf_conncount_list *list);
 
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 913ede2f57f9..803589f4eaa1 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -122,16 +122,22 @@ find_or_evict(struct net *net, struct nf_conncount_list *list,
 	return ERR_PTR(-EAGAIN);
 }
 
-static int __nf_conncount_add(struct net *net,
-			      struct nf_conncount_list *list,
-			      const struct nf_conntrack_tuple *tuple,
-			      const struct nf_conntrack_zone *zone)
+static int __nf_conncount_add(const struct nf_conn *ct,
+			      struct nf_conncount_list *list)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
+	const struct nf_conntrack_tuple *tuple;
+	const struct nf_conntrack_zone *zone;
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 
+	if (!ct || nf_ct_is_confirmed(ct))
+		return -EINVAL;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	zone = nf_ct_zone(ct);
+
 	if ((u32)jiffies == list->last_gc)
 		goto add_new_node;
 
@@ -140,7 +146,7 @@ static int __nf_conncount_add(struct net *net,
 		if (collect > CONNCOUNT_GC_MAX_NODES)
 			break;
 
-		found = find_or_evict(net, list, conn);
+		found = find_or_evict(nf_ct_net(ct), list, conn);
 		if (IS_ERR(found)) {
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
@@ -198,16 +204,13 @@ static int __nf_conncount_add(struct net *net,
 	return 0;
 }
 
-int nf_conncount_add(struct net *net,
-		     struct nf_conncount_list *list,
-		     const struct nf_conntrack_tuple *tuple,
-		     const struct nf_conntrack_zone *zone)
+int nf_conncount_add(const struct nf_conn *ct, struct nf_conncount_list *list)
 {
 	int ret;
 
 	/* check the saved connections */
 	spin_lock_bh(&list->list_lock);
-	ret = __nf_conncount_add(net, list, tuple, zone);
+	ret = __nf_conncount_add(ct, list);
 	spin_unlock_bh(&list->list_lock);
 
 	return ret;
@@ -308,21 +311,22 @@ static void schedule_gc_worker(struct nf_conncount_data *data, int tree)
 }
 
 static unsigned int
-insert_tree(struct net *net,
+insert_tree(const struct nf_conn *ct,
 	    struct nf_conncount_data *data,
 	    struct rb_root *root,
 	    unsigned int hash,
-	    const u32 *key,
-	    const struct nf_conntrack_tuple *tuple,
-	    const struct nf_conntrack_zone *zone)
+	    const u32 *key)
 {
 	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES];
+	const struct nf_conntrack_zone *zone = nf_ct_zone(ct);
+	const struct nf_conntrack_tuple *tuple;
 	struct rb_node **rbnode, *parent;
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
 	unsigned int count = 0, gc_count = 0;
 	bool do_gc = true;
 
+	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 	spin_lock_bh(&nf_conncount_locks[hash]);
 restart:
 	parent = NULL;
@@ -340,8 +344,8 @@ insert_tree(struct net *net,
 		} else {
 			int ret;
 
-			ret = nf_conncount_add(net, &rbconn->list, tuple, zone);
-			if (ret)
+			ret = nf_conncount_add(ct, &rbconn->list);
+			if (ret && ret != -EINVAL)
 				count = 0; /* hotdrop */
 			else
 				count = rbconn->list.count;
@@ -352,7 +356,7 @@ insert_tree(struct net *net,
 		if (gc_count >= ARRAY_SIZE(gc_nodes))
 			continue;
 
-		if (do_gc && nf_conncount_gc_list(net, &rbconn->list))
+		if (do_gc && nf_conncount_gc_list(nf_ct_net(ct), &rbconn->list))
 			gc_nodes[gc_count++] = rbconn;
 	}
 
@@ -394,11 +398,9 @@ insert_tree(struct net *net,
 }
 
 static unsigned int
-count_tree(struct net *net,
+count_tree(struct net *net, const struct nf_conn *ct,
 	   struct nf_conncount_data *data,
-	   const u32 *key,
-	   const struct nf_conntrack_tuple *tuple,
-	   const struct nf_conntrack_zone *zone)
+	   const u32 *key)
 {
 	struct rb_root *root;
 	struct rb_node *parent;
@@ -422,7 +424,7 @@ count_tree(struct net *net,
 		} else {
 			int ret;
 
-			if (!tuple) {
+			if (!ct) {
 				nf_conncount_gc_list(net, &rbconn->list);
 				return rbconn->list.count;
 			}
@@ -437,19 +439,23 @@ count_tree(struct net *net,
 			}
 
 			/* same source network -> be counted! */
-			ret = __nf_conncount_add(net, &rbconn->list, tuple, zone);
+			ret = __nf_conncount_add(ct, &rbconn->list);
 			spin_unlock_bh(&rbconn->list.list_lock);
-			if (ret)
+			if (ret && ret != -EINVAL) {
 				return 0; /* hotdrop */
-			else
+			} else {
+				/* -EINVAL means add was skipped, update the list */
+				if (ret == -EINVAL)
+					nf_conncount_gc_list(net, &rbconn->list);
 				return rbconn->list.count;
+			}
 		}
 	}
 
-	if (!tuple)
+	if (!ct)
 		return 0;
 
-	return insert_tree(net, data, root, hash, key, tuple, zone);
+	return insert_tree(ct, data, root, hash, key);
 }
 
 static void tree_gc_worker(struct work_struct *work)
@@ -511,16 +517,14 @@ static void tree_gc_worker(struct work_struct *work)
 }
 
 /* Count and return number of conntrack entries in 'net' with particular 'key'.
- * If 'tuple' is not null, insert it into the accounting data structure.
+ * If 'ct' is not null, insert the tuple into the accounting data structure.
  * Call with RCU read lock.
  */
-unsigned int nf_conncount_count(struct net *net,
+unsigned int nf_conncount_count(struct net *net, const struct nf_conn *ct,
 				struct nf_conncount_data *data,
-				const u32 *key,
-				const struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_zone *zone)
+				const u32 *key)
 {
-	return count_tree(net, data, key, tuple, zone);
+	return count_tree(net, ct, data, key);
 }
 EXPORT_SYMBOL_GPL(nf_conncount_count);
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index fc35a11cdca2..102c2ed3de41 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -24,29 +24,28 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 					 const struct nft_pktinfo *pkt,
 					 const struct nft_set_ext *ext)
 {
-	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
-	const struct nf_conntrack_tuple *tuple_ptr;
-	struct nf_conntrack_tuple tuple;
-	enum ip_conntrack_info ctinfo;
-	const struct nf_conn *ct;
+	bool refcounted = false;
+	struct nf_conn *ct;
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
+	ct = nf_ct_get_or_find(nft_net(pkt), pkt->skb, nft_pf(pkt), &refcounted);
+	if (!ct) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
 
-	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
-		regs->verdict.code = NF_DROP;
-		return;
+	err = nf_conncount_add(ct, priv->list);
+	if (err) {
+		if (err != -EINVAL) {
+			if (refcounted)
+				nf_ct_put(ct);
+			regs->verdict.code = NF_DROP;
+			return;
+		}
 	}
+	if (refcounted)
+		nf_ct_put(ct);
 
 	count = READ_ONCE(priv->list->count);
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 0189f8b6b0bd..8c21890e4536 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -29,24 +29,16 @@
 static bool
 connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
-	struct net *net = xt_net(par);
 	const struct xt_connlimit_info *info = par->matchinfo;
-	struct nf_conntrack_tuple tuple;
-	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
-	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
-	enum ip_conntrack_info ctinfo;
-	const struct nf_conn *ct;
+	struct net *net = xt_net(par);
 	unsigned int connections;
+	bool refcounted = false;
+	struct nf_conn *ct;
 	u32 key[5];
 
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct != NULL) {
-		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-		zone = nf_ct_zone(ct);
-	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-				      xt_family(par), net, &tuple)) {
+	ct = nf_ct_get_or_find(net, skb, xt_family(par), &refcounted);
+	if (!ct)
 		goto hotdrop;
-	}
 
 	if (xt_family(par) == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
@@ -59,18 +51,19 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		for (i = 0; i < ARRAY_SIZE(addr.ip6); ++i)
 			addr.ip6[i] &= info->mask.ip6[i];
 		memcpy(key, &addr, sizeof(addr.ip6));
-		key[4] = zone->id;
+		key[4] = nf_ct_zone(ct)->id;
 	} else {
 		const struct iphdr *iph = ip_hdr(skb);
 
 		key[0] = (info->flags & XT_CONNLIMIT_DADDR) ?
 			 (__force __u32)iph->daddr : (__force __u32)iph->saddr;
 		key[0] &= (__force __u32)info->mask.ip;
-		key[1] = zone->id;
+		key[1] = nf_ct_zone(ct)->id;
 	}
 
-	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
-					 zone);
+	connections = nf_conncount_count(net, ct, info->data, key);
+	if (refcounted)
+		nf_ct_put(ct);
 	if (connections == 0)
 		/* kmalloc failed, drop it entirely */
 		goto hotdrop;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e573e9221302..e23a0de48ff9 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -929,7 +929,7 @@ static u32 ct_limit_get(const struct ovs_ct_limit_info *info, u16 zone)
 
 static int ovs_ct_check_limit(struct net *net,
 			      const struct ovs_conntrack_info *info,
-			      const struct nf_conntrack_tuple *tuple)
+			      const struct nf_conn *ct)
 {
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
 	const struct ovs_ct_limit_info *ct_limit_info = ovs_net->ct_limit_info;
@@ -942,8 +942,8 @@ static int ovs_ct_check_limit(struct net *net,
 	if (per_zone_limit == OVS_CT_LIMIT_UNLIMITED)
 		return 0;
 
-	connections = nf_conncount_count(net, ct_limit_info->data,
-					 &conncount_key, tuple, &info->zone);
+	connections = nf_conncount_count(net, ct, ct_limit_info->data,
+					 &conncount_key);
 	if (connections > per_zone_limit)
 		return -ENOMEM;
 
@@ -972,8 +972,7 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	if (static_branch_unlikely(&ovs_ct_limit_enabled)) {
 		if (!nf_ct_is_confirmed(ct)) {
-			err = ovs_ct_check_limit(net, info,
-				&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+			err = ovs_ct_check_limit(net, info, ct);
 			if (err) {
 				net_warn_ratelimited("openvswitch: zone: %u "
 					"exceeds conntrack limit\n",
@@ -1762,16 +1761,13 @@ static int __ovs_ct_limit_get_zone_limit(struct net *net,
 					 u16 zone_id, u32 limit,
 					 struct sk_buff *reply)
 {
-	struct nf_conntrack_zone ct_zone;
 	struct ovs_zone_limit zone_limit;
 	u32 conncount_key = zone_id;
 
 	zone_limit.zone_id = zone_id;
 	zone_limit.limit = limit;
-	nf_ct_zone_init(&ct_zone, zone_id, NF_CT_DEFAULT_ZONE_DIR, 0);
 
-	zone_limit.count = nf_conncount_count(net, data, &conncount_key, NULL,
-					      &ct_zone);
+	zone_limit.count = nf_conncount_count(net, NULL, data, &conncount_key);
 	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
 }
 
-- 
2.51.0

