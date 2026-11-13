Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532502;
	b=h/Ng8sQLs/ugDLNm77fuOlyjVU8fycsaC94g6R5s+FxuvOkNsUSFMjyaiOOWUa/bEADT
	 XTP+IFUDekK2JIHiZ36MtfNFdLSJYSj+nn57l6Z9IkvCQBedNMYSYou//z2L7RqfLPKsD
	 XrgGYcLA/jpv0lIT++cIb+R26M5Qd2k6zLwwh66hcxjgjD46qDAjZBvX5AfBR0oXLRPjH
	 HNkhhxmI15shZ3YfZBBQQyE1IzKmNFR2HSS6Mg/Szy9tJvOmlMkczEdQWtEKEvSScOeAT
	 DFVERxKQtLMCfmdrV3/uZbRmT32BW8HaOLAaUilBIXJcB1XOmpyamyf5i29El643JHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532502;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=4/KOw/2uWwcMJbJo69GfU7Vp+Y/AB1enY/VGepzJ088=;
	b=EWAMrbxIpSLd9Ic3xsNnp544knYRf0Qd5sGXHpwzYtomgDpjTnPn8fU8fnYoXJ2Rtwrq
	 AdyBlK5N0eUEFjOBQWnTls6L+eXNdEoZh/bju+HRmkKZ4XBwt2dFxWw7l6rcLsCaPvXjd
	 J8iU0neNq/Qpzgs0ISDlUaBvqKlgt5d0t/ZSLgdCJ9faYFx7CbyKSDEmklA8P0U0osyIr
	 jew01FVLWv5ERzZde3H/UZN7qk21vp6GcYiZsVldCuCooxytZfE4xbnqoqj3hKGsxFn1h
	 6h5LwlbYwia1yK/CIsh2UEymebj7JeT+7nEFTjtBvKwa0xXn6dnVwiN6sF3S1YLl5vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="ThO4dE/B";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD7D606A32D;
	Fri, 13 Nov 2026 01:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AD7D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ThO4dE/B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532500;
	bh=4/KOw/2uWwcMJbJo69GfU7Vp+Y/AB1enY/VGepzJ088=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThO4dE/BkhIvgFEi1ivvaFHJ8GWh5M5jjtGLCQFuv4ukrCMdnSaHS8f18fh/aJxCx
	 jFF7L184V4KGmHCBlmBZ7ofhZM+SBk76gp2dJjh0hrp4e6PRLTBWdgS/e6MLQhejcL
	 LThcKt0w96jiD1Nn3iC1sxH/3W78SOYtlMJGIwtJPmRG+jlzVMzfTQeF8/DAZVyRmr
	 EO7AyefC9he5f0pLMzMaF1I+p/zcqNgbsXbnnRsb+1fXjkOwxjya8pzcSdMsATVmPB
	 dQEE4xUpKM0db5LC+oO0n27vpELz1SgaDEeEzrhhLc7qy7BB/36egGe0wyKjA3s9+G
	 RRPvqmrrTax4w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8CF946005D;
	Fri, 13 Nov 2026 02:14:59 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 03/15] ipvs: fix problems during connection deletion
Date: Fri, 13 Nov 2026 02:14:35 +0100
Message-ID: <20261113011447.2357709-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko reports for problem when deleting connections.

If connection timer expires, its callback can not be
concurrently running but if connection is deleted
the callback can be running on another CPU even
after all references are released. Before now we
continued with the connection freeing, risking the
callback to access the deleted connection after it
is freed. As ip_vs_conn_del() runs under RCU lock
there is no risk for accessing a connection freed
by concurrent timer callback. As Sashiko warns, the
risk is present if normal connection expires and
tries to delete its cp->control chain with
ip_vs_conn_del_put() without holding a RCU read lock.

It is evident that as the pending timer and the
running timer callback do not hold reference for
the connection, there are races which is difficult
to avoid.

Change the connection refcounting as follows:

* the connection hashing does not take reference anymore

* new connection handoffs its reference to the timer
if started in __ip_vs_conn_put_timer(), to hold it
while it is pending.

* if user finds connection in hash table it gets reference
and can handoff this reference to the pending timer if
this timer is started in __ip_vs_conn_put_timer(),
otherwise puts its reference if the timer was already
pending which is the common case.

* the pending timer handoffs its reference to the
running timer callback implicitly. By this way, the
timer callback in the common case has the last reference.
In rare cases, while the timer callback is running and
before it changes refcnt from 1 to 0, other users can get
reference and to handoff it again to the pending timer
they arm. In this case, the expiration is deferred
for later time.

As result, cp->refcnt accounts all current connection
users and the pending and running timer.

Two paths can try to delete the connection: the
normal expiration path and ip_vs_conn_del() if it
successfully steals the connection reference from the
pending timer. refcount_dec_if_one() will tell us if
we were the last active user with no packets accessing
the connection and no pending/running timers.

Change ip_vs_conn_unlink() to directly unhash the
connection because when we are the last user the
connection's forwarding method can not change.
Use smp_acquire__after_ctrl_dep() after refcount_dec_if_one()
and before reading the connection fields.

ip_vs_conn_expire() does not need to call timer_delete()
anymore because the pending timer is already accounted
in refcnt.

Add explicit rcu_read_lock() while deleting the cp->control
chain to protect from concurrent timer callback for ct to
expire it before us and to cause use-after-free.

During such races, try to keep 0 in cp->timeout as it is
a request for deleting our cp->control chain immediately.
Make sure we do not send timeout 0 (seconds) in the
v1 sync message because the backup server will select some
large default value which is not desired for small timeouts.

Remove the smp_mb__before_atomic() call from __ip_vs_conn_put(),
it is from the atomic_dec() era, now refcount_dec() has
RELEASE semantics.

Link: https://sashiko.dev/#/patchset/cover.1789435989.git.zihanx%40nebusec.ai
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1790266803.git.zihanx%40nebusec.ai
Fixes: f9200a52eedf ("ipvs: avoid expiring many connections from timer")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |  1 -
 net/netfilter/ipvs/ip_vs_conn.c | 99 ++++++++++++++++++---------------
 net/netfilter/ipvs/ip_vs_sync.c |  2 +-
 3 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 9a83bff32569..97097d60d1c4 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1685,7 +1685,6 @@ static inline bool __ip_vs_conn_get(struct ip_vs_conn *cp)
 /* put back the conn without restarting its timer */
 static inline void __ip_vs_conn_put(struct ip_vs_conn *cp)
 {
-	smp_mb__before_atomic();
 	refcount_dec(&cp->refcnt);
 }
 void ip_vs_conn_put(struct ip_vs_conn *cp);
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 94f25fb7d87e..86c5e6c7b5af 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -293,7 +293,6 @@ static inline int ip_vs_conn_hash(struct ip_vs_conn *cp)
 	cp->flags |= IP_VS_CONN_F_HASHED;
 	WRITE_ONCE(cp->hn0.hash_key, hash_key);
 	WRITE_ONCE(cp->hn1.hash_key, hash_key2);
-	refcount_inc(&cp->refcnt);
 	hlist_bl_add_head_rcu(&cp->hn0.node, head);
 	if (use2)
 		hlist_bl_add_head_rcu(&cp->hn1.node, head2);
@@ -319,11 +318,27 @@ static inline bool ip_vs_conn_unlink(struct ip_vs_conn *cp)
 	struct hlist_bl_head *head, *head2;
 	u32 hash_key, hash_key2;
 	struct ip_vs_rht *t;
-	bool ret = false;
 	bool use2;
 
+	/* No more users and no running/pending timer except us? */
+	if (!refcount_dec_if_one(&cp->refcnt))
+		return false;
+
+	/* The ONE_PACKET connection is special:
+	 * - the flag is present only for normal connections, not for templates
+	 * - its timer is never started
+	 * - it is never hashed, so you can not find it and delete it
+	 * - it is not synced
+	 * - it has only one user
+	 * - it is freed after use immediately
+	 */
 	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
-		return refcount_dec_if_one(&cp->refcnt);
+		return true;
+
+	/* Add the needed ACQUIRE barrier between the above
+	 * refcount_dec_if_one() call and the read of cp fields
+	 */
+	smp_acquire__after_ctrl_dep();
 
 	rcu_read_lock();
 	local_bh_disable();
@@ -337,15 +352,11 @@ static inline bool ip_vs_conn_unlink(struct ip_vs_conn *cp)
 		      false /* new_hash2 */, &head, &head2);
 
 	if (cp->flags & IP_VS_CONN_F_HASHED) {
-		/* Decrease refcnt and unlink conn only if we are last user */
-		if (use2 == ip_vs_conn_use_hash2(cp) &&
-		    refcount_dec_if_one(&cp->refcnt)) {
-			hlist_bl_del_rcu(&cp->hn0.node);
-			if (use2)
-				hlist_bl_del_rcu(&cp->hn1.node);
-			cp->flags &= ~IP_VS_CONN_F_HASHED;
-			ret = true;
-		}
+		/* Unlink conn as we are the last user */
+		hlist_bl_del_rcu(&cp->hn0.node);
+		if (use2)
+			hlist_bl_del_rcu(&cp->hn1.node);
+		cp->flags &= ~IP_VS_CONN_F_HASHED;
 	}
 
 	conn_tab_unlock(head, head2);
@@ -353,7 +364,7 @@ static inline bool ip_vs_conn_unlink(struct ip_vs_conn *cp)
 	local_bh_enable();
 	rcu_read_unlock();
 
-	return ret;
+	return true;
 }
 
 
@@ -621,9 +632,12 @@ static void __ip_vs_conn_put_timer(struct ip_vs_conn *cp)
 {
 	unsigned long t = (cp->flags & IP_VS_CONN_F_ONE_PACKET) ?
 		0 : cp->timeout;
-	mod_timer(&cp->timer, jiffies+t);
 
-	__ip_vs_conn_put(cp);
+	/* Handoff our reference to the timer if it was just armed,
+	 * put the reference if timer was already pending.
+	 */
+	if (mod_timer(&cp->timer, jiffies + t))
+		__ip_vs_conn_put(cp);
 }
 
 void ip_vs_conn_put(struct ip_vs_conn *cp)
@@ -1322,9 +1336,18 @@ static void ip_vs_conn_rcu_free(struct rcu_head *head)
 	kmem_cache_free(ip_vs_conn_cachep, cp);
 }
 
-/* Try to delete connection while not holding reference */
+/* Try to delete connection while not holding reference.
+ * It can be called concurrently and always under RCU lock
+ * to protect from connection deletion from others.
+ * Used when we need to remove the connection immediately
+ * and without overloading the timer processing.
+ * OTOH, we use ip_vs_conn_expire_now() when we prefer to
+ * leave the current context (packet processing) and to
+ * remove the connection from timer.
+ */
 static void ip_vs_conn_del(struct ip_vs_conn *cp)
 {
+	/* Steal reference from the pending timer */
 	if (timer_delete(&cp->timer)) {
 		/* Drop cp->control chain too */
 		if (cp->control)
@@ -1333,20 +1356,11 @@ static void ip_vs_conn_del(struct ip_vs_conn *cp)
 	}
 }
 
-/* Try to delete connection while holding reference */
-static void ip_vs_conn_del_put(struct ip_vs_conn *cp)
-{
-	if (timer_delete(&cp->timer)) {
-		/* Drop cp->control chain too */
-		if (cp->control)
-			cp->timeout = 0;
-		__ip_vs_conn_put(cp);
-		ip_vs_conn_expire(&cp->timer);
-	} else {
-		__ip_vs_conn_put(cp);
-	}
-}
-
+/* Connection is removed in the following steps:
+ * - timer expires (with ref) or connection is deleted (with stolen ref)
+ * - there should be no more users except us (pending/running timer,
+ * n_control>0 or refcnt>1)
+ */
 static void ip_vs_conn_expire(struct timer_list *t)
 {
 	struct ip_vs_conn *cp = timer_container_of(cp, t, timer);
@@ -1362,23 +1376,18 @@ static void ip_vs_conn_expire(struct timer_list *t)
 	if (likely(ip_vs_conn_unlink(cp))) {
 		struct ip_vs_conn *ct = cp->control;
 
-		/* delete the timer if it is activated by other users */
-		timer_delete(&cp->timer);
-
 		/* does anybody control me? */
 		if (ct) {
-			bool has_ref = !cp->timeout && __ip_vs_conn_get(ct);
-
+			rcu_read_lock();
 			ip_vs_control_del(cp);
 			/* Drop CTL or non-assured TPL if not used anymore */
-			if (has_ref && !atomic_read(&ct->n_control) &&
+			if (!cp->timeout && !atomic_read(&ct->n_control) &&
 			    (!(ct->flags & IP_VS_CONN_F_TEMPLATE) ||
 			     !(ct->state & IP_VS_CTPL_S_ASSURED))) {
 				IP_VS_DBG(4, "drop controlling connection\n");
-				ip_vs_conn_del_put(ct);
-			} else if (has_ref) {
-				__ip_vs_conn_put(ct);
+				ip_vs_conn_del(ct);
 			}
+			rcu_read_unlock();
 		}
 
 		if ((cp->flags & IP_VS_CONN_F_NFCT) &&
@@ -1413,8 +1422,8 @@ static void ip_vs_conn_expire(struct timer_list *t)
 		  refcount_read(&cp->refcnt),
 		  atomic_read(&cp->n_control));
 
-	refcount_inc(&cp->refcnt);
-	cp->timeout = 60*HZ;
+	if (cp->timeout || atomic_read(&cp->n_control))
+		cp->timeout = 60 * HZ;
 
 	if (ipvs->sync_state & IP_VS_STATE_MASTER)
 		ip_vs_sync_conn(ipvs, cp, sysctl_sync_threshold(ipvs));
@@ -1432,7 +1441,7 @@ static void ip_vs_conn_expire(struct timer_list *t)
 void ip_vs_conn_expire_now(struct ip_vs_conn *cp)
 {
 	/* Using mod_timer_pending will ensure the timer is not
-	 * modified after the final timer_delete in ip_vs_conn_expire.
+	 * started without giving it new reference.
 	 */
 	if (timer_pending(&cp->timer) &&
 	    time_after(cp->timer.expires, jiffies))
@@ -1500,9 +1509,9 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 	spin_lock_init(&cp->lock);
 
 	/*
-	 * Set the entry is referenced by the current thread before hashing
-	 * it in the table, so that other thread run ip_vs_random_dropentry
-	 * but cannot drop this entry.
+	 * Set the entry as referenced by the current thread before starting
+	 * the timer and giving it our reference to allow other threads to
+	 * run ip_vs_random_dropentry() or any deletion method safely.
 	 */
 	refcount_set(&cp->refcnt, 1);
 
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 157f5c8361ab..1caacf419af9 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -732,7 +732,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	s->v4.vport = cp->vport;
 	s->v4.dport = cp->dport;
 	s->v4.fwmark = htonl(cp->fwmark);
-	s->v4.timeout = htonl(cp->timeout / HZ);
+	s->v4.timeout = htonl(max(1UL, cp->timeout / HZ));
 	m->nr_conns++;
 
 #ifdef CONFIG_IP_VS_IPV6
-- 
2.47.3

