Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA218511222
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548072; cv=none; b=nO8VCc4HCYqhYW8l8S5VcuyVfMxZbtAP6A8y2JkVt3iOMXZfPQsJI9yBZPg02YHA9l1imIRWQ8rc1SMpvFIR3D/v8UMSvFNUfCJ1rTTEF2Q3auN99zHuftR2szTvsasR63tR17GoleB9wbIj8NqLd36xL3RPleJrUA2oIqqMfmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548072; c=relaxed/simple;
	bh=ltpTOtjxODNnDxPWTF6pzabnfHp56JEVGTT1N8dxPwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP3BaMjhBM2PQPH10eHIVvjlehFBLSvVrZmPQU6SeJIr5Qzaou7VvozXs0pUdiliAQmBtDH1l2ohC/lkI0o87s775dLt7VT6Zr1rCZqdUBAdV9EVdIc4JDmnDK9uLtceL6MhuRMwwpxNVXQnZUdxAvyRDLt91MXrpWDvVS/ppTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3882B60E54; Fri, 04 Sep 2026 20:54:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 13/13] netfilter: ipset: improve lockdep coverage
Date: Fri,  4 Sep 2026 20:53:21 +0200
Message-ID: <20260904185321.30313-14-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid always-true arguments to rcu_dereference_protected(), they defeat
lockdep.

Add a few lockdep assertions to ip_set_init_comment() callpaths to have
more confidence in the correctness of the "Called from uadd only" claim.
Uadd implies nfnl mutex is held, make that explicit.

ip_set_comment_free() is called from different contexts, some hold
set->lock spinlock, some do not hold a lock at all but are safe because
the set is being destroyed.

Jozsef suggests to add a "dead" flag, make it so.

Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/ipset/ip_set.h  |  5 +++++
 net/netfilter/ipset/ip_set_bitmap_gen.h |  4 ++++
 net/netfilter/ipset/ip_set_core.c       | 22 +++++++++++++++-------
 net/netfilter/ipset/ip_set_hash_gen.h   |  6 ++----
 net/netfilter/ipset/ip_set_list_set.c   | 20 ++++++++++++++++++--
 5 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b2ff881e2ec1..27270575d7ba 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -258,6 +258,8 @@ struct ip_set {
 	u8 extensions;
 	/* Create flags */
 	u8 flags;
+	/* set is being destroyed */
+	bool dead;
 	/* Default timeout value, if enabled */
 	u32 timeout;
 	/* Number of elements (vs timeout) */
@@ -272,6 +274,9 @@ struct ip_set {
 	void *data;
 };
 
+#define ipset_dereference_locked(p, set)		\
+	rcu_dereference_protected(p, lockdep_is_held(&set->lock))
+
 static inline void
 ip_set_ext_destroy(struct ip_set *set, void *data)
 {
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 409a7d07fa8d..907273d6c37b 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -137,6 +137,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	void *x = get_ext(set, map, e->id);
 	int ret = mtype_do_add(e, map, flags, set->dsize);
 
+	lockdep_assert_held(&set->lock);
+
 	if (ret == IPSET_ADD_FAILED) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(x, set))) {
@@ -182,6 +184,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_adt_elem *e = value;
 	void *x = get_ext(set, map, e->id);
 
+	lockdep_assert_held(&set->lock);
+
 	if (mtype_do_del(e, map))
 		return -IPSET_ERR_EXIST;
 
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 856e53271b38..9d1c765de86a 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -62,7 +62,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 #define ip_set(inst, id)		\
 	ip_set_dereference(inst)[id]
 #define ip_set_ref_netlink(inst,id)	\
-	rcu_dereference_raw((inst)->ip_set_list)[id]
+	rcu_dereference((inst)->ip_set_list)[id]
 #define ip_set_dereference_nfnl(p)	\
 	rcu_dereference_check(p, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
 
@@ -323,14 +323,14 @@ ip_set_comment_uget(struct nlattr *tb)
 	return nla_data(tb);
 }
 
-/* Called from uadd only, protected by the set spinlock.
+/* Called from uadd only, protected by the nfnl subsys mutex.
  * The kadt functions don't use the comment extensions in any way.
  */
 void
 ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 		    const struct ip_set_ext *ext)
 {
-	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
+	struct ip_set_comment_rcu *c = ip_set_dereference_nfnl(comment->c);
 	size_t len = ext->comment ? strlen(ext->comment) : 0;
 
 	if (unlikely(c)) {
@@ -373,7 +373,9 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	struct ip_set_comment *comment = ptr;
 	struct ip_set_comment_rcu *c;
 
-	c = rcu_dereference_protected(comment->c, 1);
+	c = rcu_dereference_check(comment->c,
+				  lockdep_is_held(&set->lock) ||
+				  set->dead);
 	if (unlikely(!c))
 		return;
 	atomic64_sub(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
@@ -1014,6 +1016,12 @@ static int ip_set_none(struct sk_buff *skb, const struct nfnl_info *info,
 	return -EOPNOTSUPP;
 }
 
+static void ip_set_destroy_set(struct ip_set *set)
+{
+	set->dead = true;
+	set->variant->destroy(set);
+}
+
 static int ip_set_create(struct sk_buff *skb, const struct nfnl_info *info,
 			 const struct nlattr * const attr[])
 {
@@ -1129,7 +1137,7 @@ static int ip_set_create(struct sk_buff *skb, const struct nfnl_info *info,
 
 cleanup:
 	set->variant->cancel_gc(set);
-	set->variant->destroy(set);
+	ip_set_destroy_set(set);
 put_out:
 	module_put(set->type->me);
 out:
@@ -1149,7 +1157,7 @@ ip_set_setname_policy[IPSET_ATTR_CMD_MAX + 1] = {
 static void
 destroy_and_free_set(struct ip_set *set)
 {
-	set->variant->destroy(set);
+	ip_set_destroy_set(set);
 	module_put(set->type->me);
 	kfree(set);
 }
@@ -1189,7 +1197,7 @@ _destroy_all_sets(struct ip_set_net *inst)
 		set = ip_set(inst, i);
 		if (set) {
 			ip_set(inst, i) = NULL;
-			set->variant->destroy(set);
+			ip_set_destroy_set(set);
 			module_put(set->type->me);
 			kfree(set);
 		}
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index cf48b7c50ca1..e60602ecbdbd 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -12,8 +12,6 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/ipset/ip_set.h>
 
-#define __ipset_dereference(p)		\
-	rcu_dereference_protected(p, 1)
 #define ipset_dereference_nfnl(p)	\
 	rcu_dereference_protected(p,	\
 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
@@ -353,7 +351,7 @@ mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 	struct net_prefix np;
 
 	spin_lock_bh(&set->lock);
-	nets = __ipset_dereference(h->rnets[n]);
+	nets = ipset_dereference_locked(h->rnets[n], set);
 	/* Add in increasing prefix order, so larger cidr first */
 	for (i = 0, found = -1; i < nets->len; i++) {
 		np = READ_ONCE(nets->nets[i]);
@@ -426,7 +424,7 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 	BUILD_BUG_ON(sizeof(struct net_prefix) != sizeof(u32));
 
 	spin_lock_bh(&set->lock);
-	nets = __ipset_dereference(h->rnets[n]);
+	nets = ipset_dereference_locked(h->rnets[n], set);
 	for (i = 0, found = -1; i < nets->len; i++) {
 		np = READ_ONCE(nets->nets[i]);
 		if (np.count && np.cidr == cidr) {
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 738f14a73684..ac749afe3801 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -139,15 +139,25 @@ list_set_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return ret;
 }
 
-/* Userspace interfaces: we are protected by the nfnl mutex */
-
 static void
 __list_set_del_rcu(struct rcu_head * rcu)
 {
 	struct set_elem *e = container_of(rcu, struct set_elem, rcu);
 	struct ip_set *set = e->set;
 
+	/* element is no longer public, extensions can
+	 * be removed without lock.  This will trip the
+	 * rcu_dereference_check() call in ip_set_comment_free(),
+	 * so lock/unlock for debug kernels to avoid need to
+	 * add a 'dead' flag to the comment extension.
+	 */
+#ifdef CONFIG_PROVE_RCU
+	spin_lock_bh(&set->lock);
+#endif
 	ip_set_ext_destroy(set, e);
+#ifdef CONFIG_PROVE_RCU
+	spin_unlock_bh(&set->lock);
+#endif
 	kfree(e);
 }
 
@@ -223,6 +233,8 @@ static void
 list_set_init_extensions(struct ip_set *set, const struct ip_set_ext *ext,
 			 struct set_elem *e)
 {
+	lockdep_assert_held(&set->lock);
+
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(e, set), ext);
 	if (SET_WITH_COMMENT(set))
@@ -243,6 +255,8 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct set_elem *e, *n, *prev, *next;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 
+	lockdep_assert_held(&set->lock);
+
 	/* Find where to add the new entry */
 	n = prev = next = NULL;
 	list_for_each_entry_rcu(e, &map->members, list) {
@@ -327,6 +341,8 @@ list_set_udel(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct set_adt_elem *d = value;
 	struct set_elem *e, *n, *next, *prev = NULL;
 
+	lockdep_assert_held(&set->lock);
+
 	list_for_each_entry_safe(e, n, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
-- 
2.55.0

