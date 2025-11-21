Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544941CD1F
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 00:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684088; cv=none; b=NKvHlk5pn7KqHhZlX0dEsgKhDEoM/P2Pm1Xb8UCaYu5x73KQp4vm8k0fIKI3Bk/4Q6hbEzLdg+d+isVYeU5vXwdLvD8W/SyA+3a+xF8ebECjy0V64uNoINA2Nt5e1Us2ljTtGlbEe4p8zRq1F/uBpIuJ9BMMMtBYCsxEVBwuvSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684088; c=relaxed/simple;
	bh=ZbMR9LXryIt3SXJqXxWQ7n3PgRU50FyncHIk7ibfn1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B03XFYgV7JzqqFEONoXOUMfA1CqrC9pUYEALezZ+m4SZX39qhE2t95UcUaJmHalmfI3upX8xO8qfUg0oPQEWct1g2/F2XCEXNn9AMN/Y/vcCUj46aw1EMH+l6snRi2t+ftRC2cIMbUyEDc8NtlN+A93dq91lcH5QwE02x32TVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XH553IJz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0UgzEtNy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XH553IJz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0UgzEtNy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XH553IJz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0UgzEtNy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XH553IJz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0UgzEtNy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23177211A7;
	Fri, 21 Nov 2025 00:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763684083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TP9aUYnEstNPOPD4xm1ajsfV26l0n93oZ5K+6J7u7yI=;
	b=XH553IJzFb1RLXUsYT4edexAd6jpJLn1oCDUdS/l7BELKIc4lb8vTqmFg/fdaVNH7JYteg
	SR5a//1Vh0JM59Mu0HcrTT2GgVuyfnUCXjfubPsUWZ5wYcCJdxnwt+yH0LMguCeCi7U2PR
	IByqDv+vP01FqRZ1s4vd2+Hiinqx7c4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763684083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TP9aUYnEstNPOPD4xm1ajsfV26l0n93oZ5K+6J7u7yI=;
	b=0UgzEtNytr4EKA6tH8Xbe7PM3EZYLcaxKc144E9ovXDCU+7Xlde2YxqoNByp83feN30Mkv
	5BRhtXzd9YCIH/CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763684083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TP9aUYnEstNPOPD4xm1ajsfV26l0n93oZ5K+6J7u7yI=;
	b=XH553IJzFb1RLXUsYT4edexAd6jpJLn1oCDUdS/l7BELKIc4lb8vTqmFg/fdaVNH7JYteg
	SR5a//1Vh0JM59Mu0HcrTT2GgVuyfnUCXjfubPsUWZ5wYcCJdxnwt+yH0LMguCeCi7U2PR
	IByqDv+vP01FqRZ1s4vd2+Hiinqx7c4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763684083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TP9aUYnEstNPOPD4xm1ajsfV26l0n93oZ5K+6J7u7yI=;
	b=0UgzEtNytr4EKA6tH8Xbe7PM3EZYLcaxKc144E9ovXDCU+7Xlde2YxqoNByp83feN30Mkv
	5BRhtXzd9YCIH/CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6C793EA61;
	Fri, 21 Nov 2025 00:14:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 44adMfKuH2mLcwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 21 Nov 2025 00:14:42 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/3 nf-next v4] netfilter: nf_conncount: rework API to use sk_buff directly
Date: Fri, 21 Nov 2025 01:14:30 +0100
Message-ID: <20251121001432.3552-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

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
---
 include/net/netfilter/nf_conntrack_count.h |  17 ++-
 net/netfilter/nf_conncount.c               | 159 ++++++++++++++-------
 net/netfilter/nft_connlimit.c              |  21 +--
 net/netfilter/xt_connlimit.c               |  14 +-
 net/openvswitch/conntrack.c                |  16 +--
 5 files changed, 133 insertions(+), 94 deletions(-)

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
index 913ede2f57f9..dbaa3051577c 100644
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
2.51.1

