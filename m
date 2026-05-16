Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317403DE42E;
	Sat, 16 May 2026 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932604; cv=none; b=khdVzhhLv+Vb1KeQxE7p3Z+d89lnLMul5BKIiVimXPEpUpPb2iDwWEmCTCfxEYwGXDL5d/qfnThZ3pLUtPzkKYBl68lTxzZPFPpjFDIc4Fzpm/Bv+Ui0VdKHUFSagnQy3T5G6M4VXvJkvB0woXDvOfvrzRXXE2Suox6geGLTe6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932604; c=relaxed/simple;
	bh=UM2wRaKnKgyVvdh3cEJdKeXvOglgJKqLtk7/iwaRY1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BABW5jpQIk0tDUK/E6AcB5lI5Y3+Ynmu3HUqmYlU5tJZyK6oMQM6xycQocLH+5vB/gJ7vxKfiHWvZ16NRcu8ZK1ScN+PPy73XcO6bRidNAnlBJbo+i7LkHmR4KiYHi3Q8D5IFmfGImkgLX7AbPByzuKB6uLfcPsD/UEVWnmvg5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eHatuPPQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eHatuPPQ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B63AA601A7;
	Sat, 16 May 2026 13:56:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932594;
	bh=wKxe6wZQpv4bv4hmOYGW2PrJ81g4Hbrq2doS3+T7uX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHatuPPQGc8PcDR4LCwBLM2MHlRhyYSb5Q7M8r7VIfNDi8RHBvlnxAY67jFJdZ/OS
	 ua4vXEeAG4OgD18ymVysdEhNuWZc/V2jwSpKwOc0p20w0pMIoPsL5Z6TM0tOIKNAz0
	 aFB8InR5prw5TCWhmiL1w4Jyp0tpavbqSHO1uynwEMOIFLI8w4xQyPKtb4dwEYNc+T
	 5s9KrQQ5863DTDYfxOgGdnAbN7qF0v4nkOHL2cR1tINjl90IhDORoygoajzn5+5frn
	 5TWYafFH0xvQgxHFZRVgrg7pX44EY5l5R/B6S45NoBKfe/q7KVGp2ImEq444LsM2Gj
	 GLYSmlOK9RZuA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/12] ipvs: avoid possible loop in ip_vs_dst_event on resizing
Date: Sat, 16 May 2026 13:56:17 +0200
Message-ID: <20260516115627.967773-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko points out that unprivileged user can frequently
call ip_vs_flush() or ip_vs_del_service() to trigger
svc_table_changes updates that can lead to infinite loop
in ip_vs_dst_event(). This can also happen if the user
triggers frequent table resizing without deleting all
services. We should also consider the possible effects
if the user triggers many NETDEV_DOWN events.

One way to solve it is to hold svc_resize_sem in
ip_vs_dst_event() but this can block the dev notifier
during the whole resizing process.

Instead, use new rw_semaphore svc_replace_sem to protect just
the svc_table replacement which is a short code section.
Then hold svc_replace_sem in ip_vs_dst_event() to serialize
with replacing the svc_table. As result, loop is avoided
as there is no need to repeat the table walking from the
start. By this way changes in svc_table_changes can happen
only when all services are removed and all dev references
dropped which allows us to abort the table walking.

As IP_VS_WORK_SVC_NORESIZE is the flag used to stop the
svc_resize_work under service_mutex, we should check only
this flag often but not while under service_mutex.

To remove the mutex_trylock() for service_mutex in the
second phase where the resizer installs the new table
after rehashing, we will avoid holding the service_mutex
there. As result, the code in configuration context which
is under service_mutex should access ipvs->svc_table under
RCU because it can be replaced at anytime and released
after a RCU grace period. As for ip_vs_zero_all(), it needs
different solution as a table walker which can escape
single RCU read-side critical section: to hold the
svc_replace_sem to prevent table to be replaced.

In ip_vs_status_show() prefer to hold svc_replace_sem
to avoid many loops, just detect if the svc_table is
removed.

Prefer the newly attached table for the u_thresh/l_thresh
checks to know when to grow/shrink while adding or deleting
services because the new table size is based on the latest
parameters.

Link: https://sashiko.dev/#/patchset/20260505001648.360569-1-pablo%40netfilter.org
Fixes: 840aac3d900d ("ipvs: use resizable hash table for services")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h            |   3 +-
 net/netfilter/ipvs/ip_vs_ctl.c | 187 +++++++++++++++++++++------------
 2 files changed, 124 insertions(+), 66 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 02762ce73a0c..a02e569813d2 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1186,8 +1186,9 @@ struct netns_ipvs {
 	struct timer_list	dest_trash_timer; /* expiration timer */
 	struct mutex		service_mutex;    /* service reconfig */
 	struct rw_semaphore	svc_resize_sem;   /* svc_table resizing */
+	struct rw_semaphore	svc_replace_sem;  /* svc_table replace */
 	struct delayed_work	svc_resize_work;  /* resize svc_table */
-	atomic_t		svc_table_changes;/* ++ on new table */
+	atomic_t		svc_table_changes;/* ++ on table changes */
 	/* Service counters */
 	atomic_t		num_services[IP_VS_AF_MAX];   /* Services */
 	atomic_t		fwm_services[IP_VS_AF_MAX];   /* Services */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c7c7f6a7a9f6..bd9cae44d214 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -327,18 +327,22 @@ ip_vs_use_count_dec(void)
 /* Service hashing:
  * Operation			Locking order
  * ---------------------------------------------------------------------------
- * add table			service_mutex, svc_resize_sem(W)
- * del table			service_mutex
- * move between tables		svc_resize_sem(W), seqcount_t(W), bit lock
- * add/del service		service_mutex, bit lock
+ * add first table		service_mutex
+ * attach new table		service_mutex
+ * add/del service		service_mutex, RCU, bit lock
+ * move between tables (rehash)	svc_resize_sem(W), seqcount_t(W), bit lock
+ * replace old with attached	svc_resize_sem(W), svc_replace_sem(W)
  * find service			RCU, seqcount_t(R)
  * walk services(blocking)	service_mutex, svc_resize_sem(R)
  * walk services(non-blocking)	RCU, seqcount_t(R)
+ * walk services(non-blocking)	svc_resize_sem(R), RCU, seqcount_t(R)
+ * walk services(non-blocking)	svc_replace_sem(R), RCU, seqcount_t(R)
+ * del table			service_mutex after stopped work
  *
- * - new tables are linked/unlinked under service_mutex and svc_resize_sem
- * - new table is linked on resizing and all operations can run in parallel
- * in 2 tables until the new table is registered as current one
- * - two contexts can modify buckets: config and table resize, both in
+ * - new table is attached on resizing under service_mutex and all operations
+ * can run in parallel in 2 tables until the new table is registered as current
+ * one
+ * - two contexts can modify buckets: config and table resize (work), both in
  * process context
  * - only table resizer can move entries, so we do not protect t->seqc[]
  * items with t->lock[]
@@ -346,9 +350,13 @@ ip_vs_use_count_dec(void)
  * services are moved to new table
  * - move operations may disturb readers: find operation will not miss entries
  * but walkers may see same entry twice if they are forced to retry chains
- * - walkers using cond_resched_rcu() on !PREEMPT_RCU may need to hold
- * service_mutex to disallow new tables to be installed or to check
+ * or to walk the newly attached second table
+ * - walkers using cond_resched_rcu() on !PREEMPT_RCU may need to check
  * svc_table_changes and repeat the RCU read section if new table is installed
+ * - walkers may serialize with the whole resizing process (svc_resize_sem)
+ * to prevent seeing same service twice or just with the svc_table
+ * replace (svc_replace_sem) when we can see entries twice but we
+ * prefer to run concurrently with the rehashing.
  */
 
 /*
@@ -387,9 +395,16 @@ static int ip_vs_svc_hash(struct ip_vs_service *svc)
 	/* increase its refcnt because it is referenced by the svc table */
 	atomic_inc(&svc->refcnt);
 
+	/* We know if new table is attached under service_mutex but rely on
+	 * RCU to hold the old table to be freed in resizer
+	 */
+	rcu_read_lock();
+
+	/* This can be the old or the new table */
+	t = rcu_dereference(ipvs->svc_table);
+
 	/* New entries go into recent table */
-	t = rcu_dereference_protected(ipvs->svc_table, 1);
-	t = rcu_dereference_protected(t->new_tbl, 1);
+	t = rcu_dereference(t->new_tbl);
 
 	if (svc->fwmark == 0) {
 		/*
@@ -410,6 +425,8 @@ static int ip_vs_svc_hash(struct ip_vs_service *svc)
 	hlist_bl_add_head_rcu(&svc->s_list, head);
 	hlist_bl_unlock(head);
 
+	rcu_read_unlock();
+
 	return 1;
 }
 
@@ -432,7 +449,13 @@ static int ip_vs_svc_unhash(struct ip_vs_service *svc)
 		return 0;
 	}
 
-	t = rcu_dereference_protected(ipvs->svc_table, 1);
+	/* We know if new table is attached under service_mutex but rely on
+	 * RCU to hold the old table to be freed in resizer
+	 */
+	rcu_read_lock();
+
+	/* This can be the old or the new table */
+	t = rcu_dereference(ipvs->svc_table);
 	hash_key = READ_ONCE(svc->hash_key);
 	/* We need to lock the bucket in the right table */
 	if (ip_vs_rht_same_table(t, hash_key)) {
@@ -443,13 +466,13 @@ static int ip_vs_svc_unhash(struct ip_vs_service *svc)
 		/* Moved to new table ? */
 		if (hash_key != hash_key2) {
 			hlist_bl_unlock(head);
-			t = rcu_dereference_protected(t->new_tbl, 1);
+			t = rcu_dereference(t->new_tbl);
 			head = t->buckets + (hash_key2 & t->mask);
 			hlist_bl_lock(head);
 		}
 	} else {
 		/* It is already moved to new table */
-		t = rcu_dereference_protected(t->new_tbl, 1);
+		t = rcu_dereference(t->new_tbl);
 		head = t->buckets + (hash_key & t->mask);
 		hlist_bl_lock(head);
 	}
@@ -459,6 +482,8 @@ static int ip_vs_svc_unhash(struct ip_vs_service *svc)
 	svc->flags &= ~IP_VS_SVC_F_HASHED;
 	atomic_dec(&svc->refcnt);
 	hlist_bl_unlock(head);
+
+	rcu_read_unlock();
 	return 1;
 }
 
@@ -666,15 +691,14 @@ static void svc_resize_work_handler(struct work_struct *work)
 		goto unlock_sem;
 	more_work = false;
 	clear_bit(IP_VS_WORK_SVC_RESIZE, &ipvs->work_flags);
-	if (!READ_ONCE(ipvs->enable) ||
-	    test_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
+	if (!READ_ONCE(ipvs->enable))
 		goto unlock_m;
 	t = rcu_dereference_protected(ipvs->svc_table, 1);
 	/* Do nothing if table is removed */
 	if (!t)
 		goto unlock_m;
-	/* New table needs to be registered? BUG! */
-	if (t != rcu_dereference_protected(t->new_tbl, 1))
+	/* New table already attached? BUG! */
+	if (t != rcu_access_pointer(t->new_tbl))
 		goto unlock_m;
 
 	lfactor = sysctl_svc_lfactor(ipvs);
@@ -691,6 +715,7 @@ static void svc_resize_work_handler(struct work_struct *work)
 	/* Flip the table_id */
 	t_new->table_id = t->table_id ^ IP_VS_RHT_TABLE_ID_MASK;
 
+	/* Attach new table */
 	rcu_assign_pointer(t->new_tbl, t_new);
 	/* Allow add/del to new_tbl while moving from old table */
 	mutex_unlock(&ipvs->service_mutex);
@@ -698,8 +723,8 @@ static void svc_resize_work_handler(struct work_struct *work)
 	ip_vs_rht_for_each_bucket(t, bucket, head) {
 same_bucket:
 		if (++limit >= 16) {
-			if (!READ_ONCE(ipvs->enable) ||
-			    test_bit(IP_VS_WORK_SVC_NORESIZE,
+			/* Check if work is stopped */
+			if (test_bit(IP_VS_WORK_SVC_NORESIZE,
 				     &ipvs->work_flags))
 				goto unlock_sem;
 			if (resched_score >= 100) {
@@ -764,16 +789,12 @@ static void svc_resize_work_handler(struct work_struct *work)
 			goto same_bucket;
 	}
 
-	/* Tables can be switched only under service_mutex */
-	while (!mutex_trylock(&ipvs->service_mutex)) {
-		cond_resched();
-		if (!READ_ONCE(ipvs->enable) ||
-		    test_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
-			goto unlock_sem;
-	}
-	if (!READ_ONCE(ipvs->enable) ||
-	    test_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
-		goto unlock_m;
+	/* Serialize with readers that don't like svc_table changes */
+	down_write(&ipvs->svc_replace_sem);
+
+	/* Check if work is stopped to avoid synchronize_rcu() */
+	if (test_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
+		goto unlock_repl;
 
 	rcu_assign_pointer(ipvs->svc_table, t_new);
 	/* Inform readers that new table is installed */
@@ -781,8 +802,8 @@ static void svc_resize_work_handler(struct work_struct *work)
 	atomic_inc(&ipvs->svc_table_changes);
 	t_free = t;
 
-unlock_m:
-	mutex_unlock(&ipvs->service_mutex);
+unlock_repl:
+	up_write(&ipvs->svc_replace_sem);
 
 unlock_sem:
 	up_write(&ipvs->svc_resize_sem);
@@ -801,6 +822,11 @@ static void svc_resize_work_handler(struct work_struct *work)
 	    test_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
 		return;
 	queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work, 1);
+	return;
+
+unlock_m:
+	mutex_unlock(&ipvs->service_mutex);
+	goto unlock_sem;
 }
 
 static inline void
@@ -1691,6 +1717,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	struct ip_vs_pe *pe = NULL;
 	int ret_hooks = -1;
 	int ret = 0;
+	bool grow;
 
 	/* increase the module use count */
 	if (!ip_vs_use_count_inc())
@@ -1732,16 +1759,25 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	}
 #endif
 
-	t = rcu_dereference_protected(ipvs->svc_table, 1);
+	/* The old table can be freed, protect it with RCU */
+	rcu_read_lock();
+	t = rcu_dereference(ipvs->svc_table);
 	if (!t) {
 		int lfactor = sysctl_svc_lfactor(ipvs);
 		int new_size = ip_vs_svc_desired_size(ipvs, NULL, lfactor);
 
+		rcu_read_unlock();
 		t_new = ip_vs_svc_table_alloc(ipvs, new_size, lfactor);
 		if (!t_new) {
 			ret = -ENOMEM;
 			goto out_err;
 		}
+		grow = false;
+	} else {
+		/* Even the currently attached new table may need to grow */
+		t = rcu_dereference(t->new_tbl);
+		grow = ip_vs_get_num_services(ipvs) + 1 > t->u_thresh;
+		rcu_read_unlock();
 	}
 
 	if (!rcu_dereference_protected(ipvs->conn_tab, 1)) {
@@ -1800,6 +1836,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 		goto out_err;
 
 	if (t_new) {
+		/* Add table for first time */
 		clear_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags);
 		rcu_assign_pointer(ipvs->svc_table, t_new);
 		t_new = NULL;
@@ -1831,8 +1868,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	ip_vs_svc_hash(svc);
 
 	/* Schedule resize work */
-	if (t && ip_vs_get_num_services(ipvs) > t->u_thresh &&
-	    !test_and_set_bit(IP_VS_WORK_SVC_RESIZE, &ipvs->work_flags))
+	if (grow && !test_and_set_bit(IP_VS_WORK_SVC_RESIZE, &ipvs->work_flags))
 		queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work,
 				   1);
 
@@ -2054,7 +2090,6 @@ static int ip_vs_del_service(struct ip_vs_service *svc)
 		return -EEXIST;
 	ipvs = svc->ipvs;
 	ip_vs_unlink_service(svc, false);
-	t = rcu_dereference_protected(ipvs->svc_table, 1);
 
 	/* Drop the table if no more services */
 	ns = ip_vs_get_num_services(ipvs);
@@ -2062,6 +2097,7 @@ static int ip_vs_del_service(struct ip_vs_service *svc)
 		/* Stop the resizer and drop the tables */
 		set_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags);
 		cancel_delayed_work_sync(&ipvs->svc_resize_work);
+		t = rcu_dereference_protected(ipvs->svc_table, 1);
 		if (t) {
 			rcu_assign_pointer(ipvs->svc_table, NULL);
 			/* Inform readers that table is removed */
@@ -2075,11 +2111,19 @@ static int ip_vs_del_service(struct ip_vs_service *svc)
 				t = p;
 			}
 		}
-	} else if (ns <= t->l_thresh &&
-		   !test_and_set_bit(IP_VS_WORK_SVC_RESIZE,
-				     &ipvs->work_flags)) {
-		queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work,
-				   1);
+	} else {
+		bool shrink;
+
+		rcu_read_lock();
+		t = rcu_dereference(ipvs->svc_table);
+		/* Even the currently attached new table may need to shrink */
+		t = rcu_dereference(t->new_tbl);
+		shrink = ns <= t->l_thresh;
+		rcu_read_unlock();
+		if (shrink && !test_and_set_bit(IP_VS_WORK_SVC_RESIZE,
+						&ipvs->work_flags))
+			queue_delayed_work(system_unbound_wq,
+					   &ipvs->svc_resize_work, 1);
 	}
 	return 0;
 }
@@ -2184,17 +2228,21 @@ static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
 	struct ip_vs_service *svc;
 	struct hlist_bl_node *e;
 	struct ip_vs_dest *dest;
-	int old_gen, new_gen;
+	int old_gen;
 
 	if (event != NETDEV_DOWN || !ipvs)
 		return NOTIFY_DONE;
 	IP_VS_DBG(3, "%s() dev=%s\n", __func__, dev->name);
 
+	/* Allow concurrent rehashing on resize but to avoid loop
+	 * serialize with installing the new table.
+	 */
+	down_read(&ipvs->svc_replace_sem);
+
 	old_gen = atomic_read(&ipvs->svc_table_changes);
 
 	rcu_read_lock();
 
-repeat:
 	smp_rmb(); /* ipvs->svc_table and svc_table_changes */
 	ip_vs_rht_walk_buckets_rcu(ipvs->svc_table, head) {
 		hlist_bl_for_each_entry_rcu(svc, e, head, s_list) {
@@ -2207,17 +2255,17 @@ static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
 		}
 		resched_score++;
 		if (resched_score >= 100) {
-			resched_score = 0;
 			cond_resched_rcu();
-			new_gen = atomic_read(&ipvs->svc_table_changes);
-			/* New table installed ? */
-			if (old_gen != new_gen) {
-				old_gen = new_gen;
-				goto repeat;
-			}
+			/* Flushed? So no more dev refs */
+			if (atomic_read(&ipvs->svc_table_changes) != old_gen)
+				goto done;
+			resched_score = 0;
 		}
 	}
+
+done:
 	rcu_read_unlock();
+	up_read(&ipvs->svc_replace_sem);
 
 	return NOTIFY_DONE;
 }
@@ -2244,6 +2292,10 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
 	struct ip_vs_service *svc;
 	struct hlist_bl_node *e;
 
+	/* svc_table can not be replaced (svc_replace_sem) or
+	 * removed (service_mutex)
+	 */
+	down_read(&ipvs->svc_replace_sem);
 	rcu_read_lock();
 
 	ip_vs_rht_walk_buckets_rcu(ipvs->svc_table, head) {
@@ -2259,6 +2311,7 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
 	}
 
 	rcu_read_unlock();
+	up_read(&ipvs->svc_replace_sem);
 
 	ip_vs_zero_stats(&ipvs->tot_stats->s);
 	return 0;
@@ -3062,6 +3115,7 @@ static int ip_vs_status_show(struct seq_file *seq, void *v)
 	u32 sum;
 	int i;
 
+	/* Info for conns */
 	rcu_read_lock();
 
 	t = rcu_dereference(ipvs->conn_tab);
@@ -3123,6 +3177,12 @@ static int ip_vs_status_show(struct seq_file *seq, void *v)
 	}
 
 after_conns:
+	rcu_read_unlock();
+
+	/* Info for services */
+	down_read(&ipvs->svc_replace_sem);
+	rcu_read_lock();
+
 	t = rcu_dereference(ipvs->svc_table);
 
 	count = ip_vs_get_num_services(ipvs);
@@ -3133,9 +3193,7 @@ static int ip_vs_status_show(struct seq_file *seq, void *v)
 	if (!count)
 		goto after_svc;
 	old_gen = atomic_read(&ipvs->svc_table_changes);
-	loops = 0;
 
-repeat_svc:
 	smp_rmb(); /* ipvs->svc_table and svc_table_changes */
 	memset(counts, 0, sizeof(counts));
 	ip_vs_rht_for_each_table_rcu(ipvs->svc_table, t, pt) {
@@ -3157,15 +3215,10 @@ static int ip_vs_status_show(struct seq_file *seq, void *v)
 			if (resched_score >= 100) {
 				resched_score = 0;
 				cond_resched_rcu();
-				new_gen = atomic_read(&ipvs->svc_table_changes);
-				/* New table installed ? */
-				if (old_gen != new_gen) {
-					/* Too many changes? */
-					if (++loops >= 5)
-						goto after_svc;
-					old_gen = new_gen;
-					goto repeat_svc;
-				}
+				/* Flushed? */
+				if (atomic_read(&ipvs->svc_table_changes) !=
+				    old_gen)
+					goto after_svc;
 			}
 			counts[count]++;
 		}
@@ -3184,6 +3237,9 @@ static int ip_vs_status_show(struct seq_file *seq, void *v)
 	}
 
 after_svc:
+	rcu_read_unlock();
+	up_read(&ipvs->svc_replace_sem);
+
 	seq_printf(seq, "Stats thread slots:\t%d (max %lu)\n",
 		   ipvs->est_kt_count, ipvs->est_max_threads);
 	seq_printf(seq, "Stats chain max len:\t%d\n", ipvs->est_chain_max);
@@ -3191,7 +3247,6 @@ static int ip_vs_status_show(struct seq_file *seq, void *v)
 		   ipvs->est_chain_max * IPVS_EST_CHAIN_FACTOR *
 		   IPVS_EST_NTICKS);
 
-	rcu_read_unlock();
 	return 0;
 }
 
@@ -3503,7 +3558,7 @@ __ip_vs_get_service_entries(struct netns_ipvs *ipvs,
 	int ret = 0;
 
 	lockdep_assert_held(&ipvs->svc_resize_sem);
-	/* All service modifications are disabled, go ahead */
+	/* All svc_table modifications are disabled, go ahead */
 	ip_vs_rht_walk_buckets(ipvs->svc_table, head) {
 		hlist_bl_for_each_entry(svc, e, head, s_list) {
 			/* Only expose IPv4 entries to old interface */
@@ -3687,7 +3742,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 			pr_err("length: %u != %zu\n", *len, size);
 			return -EINVAL;
 		}
-		/* Protect against table resizer moving the entries.
+		/* Prevent modifications to the list with services.
 		 * Try reverse locking, so that we do not hold the mutex
 		 * while waiting for semaphore.
 		 */
@@ -4029,6 +4084,7 @@ static int ip_vs_genl_dump_services(struct sk_buff *skb,
 	int start = cb->args[0];
 	int idx = 0;
 
+	/* Make sure we do not see same service twice during resize */
 	down_read(&ipvs->svc_resize_sem);
 	rcu_read_lock();
 	ip_vs_rht_walk_buckets_safe_rcu(ipvs->svc_table, head) {
@@ -5072,6 +5128,7 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 	/* Initialize service_mutex, svc_table per netns */
 	__mutex_init(&ipvs->service_mutex, "ipvs->service_mutex", &__ipvs_service_key);
 	init_rwsem(&ipvs->svc_resize_sem);
+	init_rwsem(&ipvs->svc_replace_sem);
 	INIT_DELAYED_WORK(&ipvs->svc_resize_work, svc_resize_work_handler);
 	atomic_set(&ipvs->svc_table_changes, 0);
 	RCU_INIT_POINTER(ipvs->svc_table, NULL);
-- 
2.47.3

