Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA313C9EE5
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813665; cv=none; b=O+B15cmAMvbgXWMOKu47rhJ7FBPSalVNYwBu0yCLD+EKc4oDWNFJ+tR05BzQbeY3uwNKM8ABPvVoKRqnpCvOpcB/Fls/WEL1bQt8c9lexuNUpB9U59PIXbv9GeAAxTitFOZGN/8UJ/nE49w3O8MIJSa7BFW7vyLzIV/5znZtxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813665; c=relaxed/simple;
	bh=p/or4IM87gSkeClUdLsHNz2C68NhTw3I6eBt+F5nvY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/sS8aj6A4x0B4qfiVEt8m2nlIixIJv/AZFlBegBMJjyyUbahF5yyG3r3ncsfMPPBV+iOQD9hwNVGiuFwMtwstYLdBaIeR+Pjn4jLHnRc6HcaaDpApt5iTUxkXW3p5STqMc2t2akW37qE6eO5tgThVa4SxhmhomMuFEiJ8P1psY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WGgn6OGQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WGgn6OGQ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A9D246055B;
	Tue, 26 May 2026 18:40:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779813659;
	bh=IjH887sON3svwNsTTcnGTeXHkINY/z8yvM/IAQzUeu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGgn6OGQaTG91gGT078TbFR1ekxzCPU6wM7TT2PrkellPxdYHHg7mPKwsQk4Ix5hi
	 nxy/th43sBQ/nBtTt0pOsGSJ3tPeleUuLgsffu8mora+kVzCyeIlK+xCI9z0F0S3jK
	 PzFkBB6T4EF8ImckRbDE18qhlHlXQ1EkWPz3xzqWA+nU7PsbuzEQcgVbAgO/AFFYx3
	 9qtWqrli+oLJWifeWgSsuJNIBNf3S6XwtKSGgq0UVhncRnH2w0tpJLDrsjd53FgwlT
	 95VSFD86c+iU9zpQ1QrYy6Hvc2hhKliGwCnTtSUt1jaoFjF/Rpjrg6qiIveeHjRIr1
	 R78xkkuVBK++A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 6/6] netfilter: conntrack: revert ct extension genid infrastructure
Date: Tue, 26 May 2026 18:40:49 +0200
Message-ID: <20260526164049.148218-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260526164049.148218-1-pablo@netfilter.org>
References: <20260526164049.148218-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This infrastructure is not used anymore after moving ct timeout and
helper to use datapath refcount to track object use.

Revert commit c56716c69ce1 ("netfilter: extensions: introduce extension
genid count") this patch disables all ct extensions (leading to NULL)
for unconfirmed conntracks, when this is only targeted at ct helper and
ct timeout. There is also codebase that dereferences the ct extension
without checking for NULL which could lead to crash.

This also reverts commit 2843fb69980b ("netfilter: conntrack: add
nf_ct_iterate_destroy") since the sledgehammer approach does not work
with unconfirmed conntrack that are flying to sit in nfqueue, or
elsewhere, then allowing potential UaF on reinjection.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h        |   4 -
 include/net/netfilter/nf_conntrack_extend.h |  12 ---
 net/netfilter/nf_conntrack_core.c           | 112 --------------------
 net/netfilter/nf_conntrack_extend.c         |  32 +-----
 net/netfilter/nf_nat_core.c                 |  15 +--
 net/netfilter/nfnetlink_cttimeout.c         |   1 +
 6 files changed, 4 insertions(+), 172 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f75af8eb1cae..91c23bf42911 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -244,10 +244,6 @@ void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
 			       const struct nf_ct_iter_data *iter_data);
 
-/* also set unconfirmed conntracks as dying. Only use in module exit path. */
-void nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data),
-			   void *data);
-
 struct nf_conntrack_zone;
 
 void nf_conntrack_free(struct nf_conn *ct);
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 0b247248b032..fd5c4dbf72ca 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -38,7 +38,6 @@ enum nf_ct_ext_id {
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
-	unsigned int gen_id;
 	char data[] __aligned(8);
 };
 
@@ -52,8 +51,6 @@ static inline bool nf_ct_ext_exist(const struct nf_conn *ct, u8 id)
 	return (ct->ext && __nf_ct_ext_exist(ct->ext, id));
 }
 
-void *__nf_ct_ext_find(const struct nf_ct_ext *ext, u8 id);
-
 static inline void *nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 {
 	struct nf_ct_ext *ext = ct->ext;
@@ -61,19 +58,10 @@ static inline void *nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 	if (!ext || !__nf_ct_ext_exist(ext, id))
 		return NULL;
 
-	if (unlikely(ext->gen_id))
-		return __nf_ct_ext_find(ext, id);
-
 	return (void *)ct->ext + ct->ext->offset[id];
 }
 
 /* Add this type, returns pointer to data or NULL. */
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
-/* ext genid.  if ext->id != ext_genid, extensions cannot be used
- * anymore unless conntrack has CONFIRMED bit set.
- */
-extern atomic_t nf_conntrack_ext_genid;
-void nf_ct_ext_bump_genid(void);
-
 #endif /* _NF_CONNTRACK_EXTEND_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 493748f792de..b7ad399b79d9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -833,33 +833,6 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 			   &nf_conntrack_hash[reply_hash]);
 }
 
-static bool nf_ct_ext_valid_pre(const struct nf_ct_ext *ext)
-{
-	/* if ext->gen_id is not equal to nf_conntrack_ext_genid, some extensions
-	 * may contain stale pointers to e.g. helper that has been removed.
-	 *
-	 * The helper can't clear this because the nf_conn object isn't in
-	 * any hash and synchronize_rcu() isn't enough because associated skb
-	 * might sit in a queue.
-	 */
-	return !ext || ext->gen_id == atomic_read(&nf_conntrack_ext_genid);
-}
-
-static bool nf_ct_ext_valid_post(struct nf_ct_ext *ext)
-{
-	if (!ext)
-		return true;
-
-	if (ext->gen_id != atomic_read(&nf_conntrack_ext_genid))
-		return false;
-
-	/* inserted into conntrack table, nf_ct_iterate_cleanup()
-	 * will find it.  Disable nf_ct_ext_find() id check.
-	 */
-	WRITE_ONCE(ext->gen_id, 0);
-	return true;
-}
-
 int
 nf_conntrack_hash_check_insert(struct nf_conn *ct)
 {
@@ -875,9 +848,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
-	if (!nf_ct_ext_valid_pre(ct->ext))
-		return -EAGAIN;
-
 	local_bh_disable();
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
@@ -911,18 +881,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 			goto chaintoolong;
 	}
 
-	/* If genid has changed, we can't insert anymore because ct
-	 * extensions could have stale pointers and nf_ct_iterate_destroy
-	 * might have completed its table scan already.
-	 *
-	 * Increment of the ext genid right after this check is fine:
-	 * nf_ct_iterate_destroy blocks until locks are released.
-	 */
-	if (!nf_ct_ext_valid_post(ct->ext)) {
-		err = -EAGAIN;
-		goto out;
-	}
-
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
@@ -1250,11 +1208,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		return NF_DROP;
 	}
 
-	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC(net, insert_failed);
-		goto dying;
-	}
-
 	/* We have to check the DYING flag after unlink to prevent
 	 * a race against nf_ct_get_next_corpse() possibly called from
 	 * user context, else we insert an already 'dead' hash, blocking
@@ -1317,16 +1270,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	nf_conntrack_double_unlock(hash, reply_hash);
 	local_bh_enable();
 
-	/* ext area is still valid (rcu read lock is held,
-	 * but will go out of scope soon, we need to remove
-	 * this conntrack again.
-	 */
-	if (!nf_ct_ext_valid_post(ct->ext)) {
-		nf_ct_kill(ct);
-		NF_CT_STAT_INC_ATOMIC(net, drop);
-		return NF_DROP;
-	}
-
 	help = nfct_help(ct);
 	if (help && help->helper)
 		nf_conntrack_event_cache(IPCT_HELPER, ct);
@@ -2394,61 +2337,6 @@ void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 
-/**
- * nf_ct_iterate_destroy - destroy unconfirmed conntracks and iterate table
- * @iter: callback to invoke for each conntrack
- * @data: data to pass to @iter
- *
- * Like nf_ct_iterate_cleanup, but first marks conntracks on the
- * unconfirmed list as dying (so they will not be inserted into
- * main table).
- *
- * Can only be called in module exit path.
- */
-void
-nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
-{
-	struct nf_ct_iter_data iter_data = {};
-	struct net *net;
-
-	down_read(&net_rwsem);
-	for_each_net(net) {
-		struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-		if (atomic_read(&cnet->count) == 0)
-			continue;
-		nf_queue_nf_hook_drop(net);
-	}
-	up_read(&net_rwsem);
-
-	/* Need to wait for netns cleanup worker to finish, if its
-	 * running -- it might have deleted a net namespace from
-	 * the global list, so hook drop above might not have
-	 * affected all namespaces.
-	 */
-	net_ns_barrier();
-
-	/* a skb w. unconfirmed conntrack could have been reinjected just
-	 * before we called nf_queue_nf_hook_drop().
-	 *
-	 * This makes sure its inserted into conntrack table.
-	 */
-	synchronize_net();
-
-	nf_ct_ext_bump_genid();
-	iter_data.data = data;
-	nf_ct_iterate_cleanup(iter, &iter_data);
-
-	/* Another cpu might be in a rcu read section with
-	 * rcu protected pointer cleared in iter callback
-	 * or hidden via nf_ct_ext_bump_genid() above.
-	 *
-	 * Wait until those are done.
-	 */
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(nf_ct_iterate_destroy);
-
 static int kill_all(struct nf_conn *i, void *data)
 {
 	return 1;
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index dd62cc12e775..0da105e1ded9 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -27,8 +27,6 @@
 
 #define NF_CT_EXT_PREALLOC	128u /* conntrack events are on by default */
 
-atomic_t nf_conntrack_ext_genid __read_mostly = ATOMIC_INIT(1);
-
 static const u8 nf_ct_ext_type_len[NF_CT_EXT_NUM] = {
 	[NF_CT_EXT_HELPER] = sizeof(struct nf_conn_help),
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -118,10 +116,8 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	if (!new)
 		return NULL;
 
-	if (!ct->ext) {
+	if (!ct->ext)
 		memset(new->offset, 0, sizeof(new->offset));
-		new->gen_id = atomic_read(&nf_conntrack_ext_genid);
-	}
 
 	new->offset[id] = newoff;
 	new->len = newlen;
@@ -131,29 +127,3 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
-
-/* Use nf_ct_ext_find wrapper. This is only useful for unconfirmed entries. */
-void *__nf_ct_ext_find(const struct nf_ct_ext *ext, u8 id)
-{
-	unsigned int gen_id = atomic_read(&nf_conntrack_ext_genid);
-	unsigned int this_id = READ_ONCE(ext->gen_id);
-
-	if (!__nf_ct_ext_exist(ext, id))
-		return NULL;
-
-	if (this_id == 0 || ext->gen_id == gen_id)
-		return (void *)ext + ext->offset[id];
-
-	return NULL;
-}
-EXPORT_SYMBOL(__nf_ct_ext_find);
-
-void nf_ct_ext_bump_genid(void)
-{
-	unsigned int value = atomic_inc_return(&nf_conntrack_ext_genid);
-
-	if (value == UINT_MAX)
-		atomic_set(&nf_conntrack_ext_genid, 1);
-
-	msleep(HZ);
-}
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 74ec224ce0d6..e06ac58b8f79 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -969,20 +969,9 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_nat_inet_fn);
 
-struct nf_nat_proto_clean {
-	u8	l3proto;
-	u8	l4proto;
-};
-
 /* kill conntracks with affected NAT section */
 static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 {
-	const struct nf_nat_proto_clean *clean = data;
-
-	if ((clean->l3proto && nf_ct_l3num(i) != clean->l3proto) ||
-	    (clean->l4proto && nf_ct_protonum(i) != clean->l4proto))
-		return 0;
-
 	return i->status & IPS_NAT_MASK ? 1 : 0;
 }
 
@@ -1350,9 +1339,9 @@ static int __init nf_nat_init(void)
 
 static void __exit nf_nat_cleanup(void)
 {
-	struct nf_nat_proto_clean clean = {};
+	struct nf_ct_iter_data iter_data = {};
 
-	nf_ct_iterate_destroy(nf_nat_proto_clean, &clean);
+	nf_ct_iterate_cleanup(nf_nat_proto_clean, &iter_data);
 
 	nf_ct_helper_expectfn_unregister(&follow_master_nat);
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 8efda53f94eb..739a8461ff9f 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -677,6 +677,7 @@ static void __exit cttimeout_exit(void)
 
 	unregister_pernet_subsys(&cttimeout_ops);
 	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
+	synchronize_net();
 
 	nf_ct_untimeout(NULL, NULL);
 }
-- 
2.47.3

