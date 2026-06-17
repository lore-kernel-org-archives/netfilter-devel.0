Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624023EFFDB
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 11:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781697076; cv=none; b=qDA0e+N2/+lE/AjPZkV0gf77jlf6U5dxLF5qruCUWBq7HebQ3rquHI01zwEDwY2Fl6ow1DDdZHFSDfWjlrGLSUlE4IKzqv5KUg4WeqcmvouP4Ezp6hw/5rq0IdbSTqjsAlUVWlWX3LAILY0dWqKEPqCelS3TMUR+BqZlmUMQGBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781697076; c=relaxed/simple;
	bh=0+EhaCdaHYc6bzde5NrZR420fv3yalnSsmsNskSOwN0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UyTh7RyZYOLO3ozCTdxOHK/jNHmBY9/S1dPCI1D53i63DxrNO1colFqT6QgmvnvPnH2mHymS1A3tW0xFMtR52VwkkhxLfncGVC5hiV67QsVyAaQBQDnNXDacOWchLNi6Bsz668xYw4eq9koun75MIzvaJ+9CAlzCHe9+rxHyhcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nMNWnJ7Y; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nMNWnJ7Y"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CBA6060181
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 13:51:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781697070;
	bh=q5nb7/9aAPMaedwuNS9jdcbCtiRELl6XNQ7jDTaPqa8=;
	h=From:To:Subject:Date:From;
	b=nMNWnJ7YhL80cEg3Zu1sP+tbxuN9OitiZDeuhvb8SO5at8s5i0+HRgwoBee1I10H0
	 3xr5z580Tg5Lq9bG1l8d9TUbol+7YiF6mE8SMAFbQhljEinNJcgwAiW2nEVsMPsiXu
	 xofwippnkSj9cQQgEmtccXo2wvxBzncExrazPZd4ck7DOPO8PIy0cM/iyVkjTP/SsV
	 O5+vFtZToJLyr2oYh9CsRU3bHQl7dmTyq6tP7cnLxZWMkjhstGCAzfgnZ2dmOdtFGW
	 e8YLThSr2X1PQPCHlnSDDBSbjdnIbt6ZJGIiRb4LWn8Wl61uHxg6udvYolIWGZDUm2
	 rme4kG9jf05kQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_conntrack_expect: use conntrack GC to reap expectations
Date: Wed, 17 Jun 2026 13:51:05 +0200
Message-ID: <20260617115105.713112-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch replaces the timer API by GC worker approach for
expectations, as it already happened in many other subsystems.

Use the existing conntrack GC worker to iterate over the local list of
expectations in the master conntrack to reap expired expectations. Hold
the expectation spinlock while iterating over the master conntrack
expectation list to synchronize with nf_ct_remove_expectations().
This also performs runtime packet path garbage collection through the
expectation insertion and lookup functions while walking over one of the
chains of the global expectation hashtables.

This removes the extra bump on the refcount for expectation timers, this
allows to remove several nf_ct_expect_put() calls after the unlink,
after this update only refcount remains at 1 while on the expectation
hashes.

This patch implicitly addresses a race with the existing timer API
allowing an expectation to access a stale exp->master pointer which has
been already released when expectation removal loses races with an
expiring timer, ie. timer_del() reporting false.

Add a new NF_CT_EXPECT_DEAD flag to reap this expectation via GC. This
is needed by nf_conntrack_unexpect_related() which is called in error
paths to invalidate newly created expectations that has been added into
the hashes. These expectactions cannot be inmediately released as GC
or nf_ct_remove_expectations() could race to make it.

Set current timestamp in nf_ct_expect_alloc(), then add the expectation
policy timeout (or custom timeout specified added on top of this) to
specify the expectation lifetime.

Fixes: bffcaad9afdf ("netfilter: ctnetlink: ensure safe access to master conntrack")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: address AI reviewer hints:
    - unexpect_related() could race with GC, add _DEAD flag.
    - fix incorrect NF_CT_EXPECT_PERMANENT semantics with is_expired().

 include/net/netfilter/nf_conntrack_expect.h   |  16 ++-
 .../linux/netfilter/nf_conntrack_common.h     |   3 +-
 net/netfilter/nf_conntrack_core.c             |   5 +
 net/netfilter/nf_conntrack_expect.c           | 120 +++++++++---------
 net/netfilter/nf_conntrack_h323_main.c        |   4 +-
 net/netfilter/nf_conntrack_netlink.c          |  22 ++--
 net/netfilter/nf_conntrack_sip.c              |  13 +-
 net/netfilter/nft_ct.c                        |   2 +-
 8 files changed, 96 insertions(+), 89 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 80f50fd0f7ad..7e1e88c2116e 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -54,8 +54,8 @@ struct nf_conntrack_expect {
 	/* The conntrack of the master connection */
 	struct nf_conn *master;
 
-	/* Timer function; deletes the expectation. */
-	struct timer_list timeout;
+	/* jiffies32 when this expectation expires */
+	u32 timeout;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 	union nf_inet_addr saved_addr;
@@ -69,6 +69,14 @@ struct nf_conntrack_expect {
 	struct rcu_head rcu;
 };
 
+static inline bool nf_ct_exp_is_expired(const struct nf_conntrack_expect *exp)
+{
+	if (exp->flags & NF_CT_EXPECT_DEAD)
+		return true;
+
+	return (__s32)(READ_ONCE(exp->timeout) - nfct_time_stamp) <= 0;
+}
+
 static inline struct net *nf_ct_exp_net(struct nf_conntrack_expect *exp)
 {
 	return read_pnet(&exp->net);
@@ -130,7 +138,6 @@ static inline void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 
 void nf_ct_remove_expectations(struct nf_conn *ct);
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
-bool nf_ct_remove_expect(struct nf_conntrack_expect *exp);
 
 void nf_ct_expect_iterate_destroy(bool (*iter)(struct nf_conntrack_expect *e, void *data), void *data);
 void nf_ct_expect_iterate_net(struct net *net,
@@ -153,5 +160,8 @@ static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
 	return nf_ct_expect_related_report(expect, 0, 0, flags);
 }
 
+struct nf_conn_help;
+void nf_ct_expectation_gc(struct nf_conn_help *master_help);
+
 #endif /*_NF_CONNTRACK_EXPECT_H*/
 
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 56b6b60a814f..651f3676a7bc 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -160,8 +160,9 @@ enum ip_conntrack_expect_events {
 #define NF_CT_EXPECT_USERSPACE		0x4
 
 #ifdef __KERNEL__
+#define NF_CT_EXPECT_DEAD		0x8
 #define NF_CT_EXPECT_MASK	(NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE | \
-				 NF_CT_EXPECT_USERSPACE)
+				 NF_CT_EXPECT_USERSPACE | NF_CT_EXPECT_DEAD)
 #endif
 
 #endif /* _UAPI_NF_CONNTRACK_COMMON_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4fb3a2d18631..9be40e33b003 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1502,6 +1502,7 @@ static void gc_worker(struct work_struct *work)
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
 		struct hlist_nulls_node *n;
+		struct nf_conn_help *help;
 		struct nf_conn *tmp;
 
 		rcu_read_lock();
@@ -1533,6 +1534,10 @@ static void gc_worker(struct work_struct *work)
 				goto early_exit;
 			}
 
+			help = nfct_help(tmp);
+			if (help)
+				nf_ct_expectation_gc(help);
+
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
 				expired_count++;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 5c9b17835c28..f2c0c0ac7fda 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -43,6 +43,24 @@ unsigned int nf_ct_expect_max __read_mostly;
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
 static siphash_aligned_key_t nf_ct_expect_hashrnd;
 
+void nf_ct_expectation_gc(struct nf_conn_help *master_help)
+{
+	struct nf_conntrack_expect *exp;
+	struct hlist_node *next;
+
+	if (hlist_empty(&master_help->expectations))
+		return;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	hlist_for_each_entry_safe(exp, next, &master_help->expectations, lnode) {
+		if (!nf_ct_exp_is_expired(exp))
+			continue;
+
+		nf_ct_unlink_expect(exp);
+	}
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+}
+
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 				u32 portid, int report)
@@ -52,7 +70,6 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	struct nf_conntrack_net *cnet;
 
 	lockdep_nfct_expect_lock_held();
-	WARN_ON_ONCE(timer_pending(&exp->timeout));
 
 	hlist_del_rcu(&exp->hnode);
 
@@ -70,16 +87,6 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 }
 EXPORT_SYMBOL_GPL(nf_ct_unlink_expect_report);
 
-static void nf_ct_expectation_timed_out(struct timer_list *t)
-{
-	struct nf_conntrack_expect *exp = timer_container_of(exp, t, timeout);
-
-	spin_lock_bh(&nf_conntrack_expect_lock);
-	nf_ct_unlink_expect(exp);
-	spin_unlock_bh(&nf_conntrack_expect_lock);
-	nf_ct_expect_put(exp);
-}
-
 static unsigned int nf_ct_expect_dst_hash(const struct net *n, const struct nf_conntrack_tuple *tuple)
 {
 	struct {
@@ -117,19 +124,6 @@ nf_ct_exp_equal(const struct nf_conntrack_tuple *tuple,
 	       nf_ct_exp_zone_equal_any(i, zone);
 }
 
-bool nf_ct_remove_expect(struct nf_conntrack_expect *exp)
-{
-	lockdep_nfct_expect_lock_held();
-
-	if (timer_delete(&exp->timeout)) {
-		nf_ct_unlink_expect(exp);
-		nf_ct_expect_put(exp);
-		return true;
-	}
-	return false;
-}
-EXPORT_SYMBOL_GPL(nf_ct_remove_expect);
-
 struct nf_conntrack_expect *
 __nf_ct_expect_find(struct net *net,
 		    const struct nf_conntrack_zone *zone,
@@ -144,6 +138,8 @@ __nf_ct_expect_find(struct net *net,
 
 	h = nf_ct_expect_dst_hash(net, tuple);
 	hlist_for_each_entry_rcu(i, &nf_ct_expect_hash[h], hnode) {
+		if (nf_ct_exp_is_expired(i))
+			continue;
 		if (nf_ct_exp_equal(tuple, i, zone, net))
 			return i;
 	}
@@ -178,6 +174,7 @@ nf_ct_find_expectation(struct net *net,
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	struct nf_conntrack_expect *i, *exp = NULL;
+	struct hlist_node *next;
 	unsigned int h;
 
 	lockdep_nfct_expect_lock_held();
@@ -186,7 +183,11 @@ nf_ct_find_expectation(struct net *net,
 		return NULL;
 
 	h = nf_ct_expect_dst_hash(net, tuple);
-	hlist_for_each_entry(i, &nf_ct_expect_hash[h], hnode) {
+	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
+		if (nf_ct_exp_is_expired(i)) {
+			nf_ct_unlink_expect(i);
+			continue;
+		}
 		if (!(i->flags & NF_CT_EXPECT_INACTIVE) &&
 		    nf_ct_exp_equal(tuple, i, zone, net)) {
 			exp = i;
@@ -196,13 +197,16 @@ nf_ct_find_expectation(struct net *net,
 	if (!exp)
 		return NULL;
 
+	if (!refcount_inc_not_zero(&exp->use))
+		return NULL;
+
 	/* If master is not in hash table yet (ie. packet hasn't left
 	   this machine yet), how can other end know about expected?
 	   Hence these are not the droids you are looking for (if
 	   master ct never got confirmed, we'd hold a reference to it
 	   and weird things would happen to future packets). */
 	if (!nf_ct_is_confirmed(exp->master))
-		return NULL;
+		goto err_release_exp;
 
 	/* Avoid race with other CPUs, that for exp->master ct, is
 	 * about to invoke ->destroy(), or nf_ct_delete() via timeout
@@ -214,18 +218,17 @@ nf_ct_find_expectation(struct net *net,
 	 */
 	if (unlikely(nf_ct_is_dying(exp->master) ||
 		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
-		return NULL;
+		goto err_release_exp;
 
-	if (exp->flags & NF_CT_EXPECT_PERMANENT || !unlink) {
-		refcount_inc(&exp->use);
-		return exp;
-	} else if (timer_delete(&exp->timeout)) {
-		nf_ct_unlink_expect(exp);
+	if (exp->flags & NF_CT_EXPECT_PERMANENT || !unlink)
 		return exp;
-	}
-	/* Undo exp->master refcnt increase, if timer_delete() failed */
-	nf_ct_put(exp->master);
 
+	nf_ct_unlink_expect(exp);
+
+	return exp;
+
+err_release_exp:
+	nf_ct_expect_put(exp);
 	return NULL;
 }
 
@@ -241,9 +244,8 @@ void nf_ct_remove_expectations(struct nf_conn *ct)
 		return;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
-		nf_ct_remove_expect(exp);
-	}
+	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode)
+		nf_ct_unlink_expect(exp);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 }
 EXPORT_SYMBOL_GPL(nf_ct_remove_expectations);
@@ -292,7 +294,7 @@ static bool master_matches(const struct nf_conntrack_expect *a,
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
 {
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	nf_ct_remove_expect(exp);
+	exp->flags |= NF_CT_EXPECT_DEAD;
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 }
 EXPORT_SYMBOL_GPL(nf_ct_unexpect_related);
@@ -308,6 +310,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 	if (!new)
 		return NULL;
 
+	new->timeout = nfct_time_stamp;
 	new->master = me;
 	refcount_set(&new->use, 1);
 	return new;
@@ -413,17 +416,12 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp,
 	struct net *net = nf_ct_exp_net(exp);
 	unsigned int h = nf_ct_expect_dst_hash(net, &exp->tuple);
 
-	/* two references : one for hash insert, one for the timer */
-	refcount_add(2, &exp->use);
+	refcount_inc(&exp->use);
 
-	timer_setup(&exp->timeout, nf_ct_expectation_timed_out, 0);
 	helper = rcu_dereference_protected(master_help->helper,
 					   lockdep_is_held(&nf_conntrack_expect_lock));
-	if (helper) {
-		exp->timeout.expires = jiffies +
-			helper->expect_policy[exp->class].timeout * HZ;
-	}
-	add_timer(&exp->timeout);
+	if (helper)
+		exp->timeout += helper->expect_policy[exp->class].timeout * HZ;
 
 	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
 	master_help->expecting[exp->class]++;
@@ -447,7 +445,7 @@ static void evict_oldest_expect(struct nf_conn_help *master_help,
 	}
 
 	if (last)
-		nf_ct_remove_expect(last);
+		nf_ct_unlink_expect(last);
 }
 
 static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
@@ -467,14 +465,18 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
+		if (nf_ct_exp_is_expired(i)) {
+			nf_ct_unlink_expect(i);
+			continue;
+		}
 		if (master_matches(i, expect, flags) &&
 		    expect_matches(i, expect)) {
 			if (i->class != expect->class ||
 			    i->master != expect->master)
 				return -EALREADY;
 
-			if (nf_ct_remove_expect(i))
-				break;
+			nf_ct_unlink_expect(i);
+			break;
 		} else if (expect_clash(i, expect)) {
 			ret = -EBUSY;
 			goto out;
@@ -547,10 +549,8 @@ void nf_ct_expect_iterate_destroy(bool (*iter)(struct nf_conntrack_expect *e, vo
 		hlist_for_each_entry_safe(exp, next,
 					  &nf_ct_expect_hash[i],
 					  hnode) {
-			if (iter(exp, data) && timer_delete(&exp->timeout)) {
+			if (iter(exp, data))
 				nf_ct_unlink_expect(exp);
-				nf_ct_expect_put(exp);
-			}
 		}
 	}
 
@@ -577,10 +577,8 @@ void nf_ct_expect_iterate_net(struct net *net,
 			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
-			if (iter(exp, data) && timer_delete(&exp->timeout)) {
+			if (iter(exp, data))
 				nf_ct_unlink_expect_report(exp, portid, report);
-				nf_ct_expect_put(exp);
-			}
 		}
 	}
 
@@ -657,17 +655,17 @@ static int exp_seq_show(struct seq_file *s, void *v)
 	struct net *net = seq_file_net(s);
 	struct hlist_node *n = v;
 	char *delim = "";
+	__s32 timeout;
 
 	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
 	if (!net_eq(nf_ct_exp_net(expect), net))
 		return 0;
+	if (nf_ct_exp_is_expired(expect))
+		return 0;
 
-	if (expect->timeout.function)
-		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
-			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
-	else
-		seq_puts(s, "- ");
+	timeout = (__s32)(READ_ONCE(expect->timeout) - nfct_time_stamp) / HZ;
+	seq_printf(s, "%d ", timeout > 0 ? timeout : 0);
 	seq_printf(s, "l3proto = %u proto=%u ",
 		   expect->tuple.src.l3num,
 		   expect->tuple.dst.protonum);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 7f189dceb3c4..24931e379985 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1388,8 +1388,8 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 				 "timeout to %u seconds for",
 				 info->timeout);
 			nf_ct_dump_tuple(&exp->tuple);
-			mod_timer_pending(&exp->timeout,
-					  jiffies + info->timeout * HZ);
+			WRITE_ONCE(exp->timeout,
+				   nfct_time_stamp + (info->timeout * HZ));
 		}
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b429e648f06c..4e78d2482989 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3014,8 +3014,8 @@ static int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
+	__s32 timeout = (__s32)(READ_ONCE(exp->timeout) - nfct_time_stamp) / HZ;
 	struct nf_conn *master = exp->master;
-	long timeout = ((long)exp->timeout.expires - (long)jiffies) / HZ;
 	struct nf_conntrack_helper *helper;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
@@ -3178,6 +3178,9 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 restart:
 		hlist_for_each_entry_rcu(exp, &nf_ct_expect_hash[cb->args[0]],
 					 hnode) {
+			if (nf_ct_exp_is_expired(exp))
+				continue;
+
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
@@ -3456,11 +3459,8 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 		}
 
 		/* after list removal, usage count == 1 */
-		if (timer_delete(&exp->timeout)) {
-			nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
-						   nlmsg_report(info->nlh));
-			nf_ct_expect_put(exp);
-		}
+		nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
+					   nlmsg_report(info->nlh));
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 		/* have to put what we 'get' above.
 		 * after this line usage count == 0 */
@@ -3484,14 +3484,10 @@ static int
 ctnetlink_change_expect(struct nf_conntrack_expect *x,
 			const struct nlattr * const cda[])
 {
-	if (cda[CTA_EXPECT_TIMEOUT]) {
-		if (!timer_delete(&x->timeout))
-			return -ETIME;
+	if (cda[CTA_EXPECT_TIMEOUT])
+		WRITE_ONCE(x->timeout, nfct_time_stamp +
+			   ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ);
 
-		x->timeout.expires = jiffies +
-			ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
-		add_timer(&x->timeout);
-	}
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c606d1f60b58..3563ad3de8a6 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -897,11 +897,10 @@ static int refresh_signalling_expectation(struct nf_conn *ct,
 		    exp->tuple.dst.protonum != proto ||
 		    exp->tuple.dst.u.udp.port != port)
 			continue;
-		if (mod_timer_pending(&exp->timeout, jiffies + expires * HZ)) {
-			exp->flags &= ~NF_CT_EXPECT_INACTIVE;
-			found = 1;
-			break;
-		}
+		WRITE_ONCE(exp->timeout, nfct_time_stamp + (expires * HZ));
+		exp->flags &= ~NF_CT_EXPECT_INACTIVE;
+		found = 1;
+		break;
 	}
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 	return found;
@@ -920,8 +919,7 @@ static void flush_expectations(struct nf_conn *ct, bool media)
 	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
 		if ((exp->class != SIP_EXPECT_SIGNALLING) ^ media)
 			continue;
-		if (!nf_ct_remove_expect(exp))
-			continue;
+		nf_ct_unlink_expect(exp);
 		if (!media)
 			break;
 	}
@@ -1413,7 +1411,6 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
-	exp->timeout.expires = sip_timeout * HZ;
 	rcu_assign_pointer(exp->assign_helper, helper);
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 25934c6f01fb..fb4fa89988b2 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1326,7 +1326,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          &ct->tuplehash[!dir].tuple.src.u3,
 		          &ct->tuplehash[!dir].tuple.dst.u3,
 		          priv->l4proto, NULL, &priv->dport);
-	exp->timeout.expires = jiffies + priv->timeout * HZ;
+	exp->timeout += priv->timeout * HZ;
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
-- 
2.47.3

