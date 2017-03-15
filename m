From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/7] net, netfilter: convert ip_vs_dest.refcnt from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 13:10:40 +0200
Message-ID: <1489576245-19472-3-git-send-email-elena.reshetova@intel.com>
References: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, kadlec@blackhole.kfki.hu,
        pablo@netfilter.org, peterz@infradead.org, keescook@chromium.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/net/ip_vs.h              |  8 ++++----
 net/netfilter/ipvs/ip_vs_ctl.c   | 12 ++++++------
 net/netfilter/ipvs/ip_vs_lblc.c  |  2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c |  6 +++---
 net/netfilter/ipvs/ip_vs_nq.c    |  2 +-
 net/netfilter/ipvs/ip_vs_rr.c    |  2 +-
 net/netfilter/ipvs/ip_vs_sed.c   |  2 +-
 net/netfilter/ipvs/ip_vs_wlc.c   |  2 +-
 net/netfilter/ipvs/ip_vs_wrr.c   |  2 +-
 9 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index f1429c3..8a4a57b8 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -669,7 +669,7 @@ struct ip_vs_dest {
 	atomic_t		conn_flags;	/* flags to copy to conn */
 	atomic_t		weight;		/* server weight */
 
-	atomic_t		refcnt;		/* reference counter */
+	refcount_t		refcnt;		/* reference counter */
 	struct ip_vs_stats      stats;          /* statistics */
 	unsigned long		idle_start;	/* start time, jiffies */
 
@@ -1412,18 +1412,18 @@ void ip_vs_try_bind_dest(struct ip_vs_conn *cp);
 
 static inline void ip_vs_dest_hold(struct ip_vs_dest *dest)
 {
-	atomic_inc(&dest->refcnt);
+	refcount_inc(&dest->refcnt);
 }
 
 static inline void ip_vs_dest_put(struct ip_vs_dest *dest)
 {
 	smp_mb__before_atomic();
-	atomic_dec(&dest->refcnt);
+	refcount_dec(&dest->refcnt);
 }
 
 static inline void ip_vs_dest_put_and_free(struct ip_vs_dest *dest)
 {
-	if (atomic_dec_and_test(&dest->refcnt))
+	if (refcount_dec_and_test(&dest->refcnt))
 		kfree(dest);
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 5aeb0dd..541aa76 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -699,7 +699,7 @@ ip_vs_trash_get_dest(struct ip_vs_service *svc, int dest_af,
 			      dest->vfwmark,
 			      IP_VS_DBG_ADDR(dest->af, &dest->addr),
 			      ntohs(dest->port),
-			      atomic_read(&dest->refcnt));
+			      refcount_read(&dest->refcnt));
 		if (dest->af == dest_af &&
 		    ip_vs_addr_equal(dest_af, &dest->addr, daddr) &&
 		    dest->port == dport &&
@@ -934,7 +934,7 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 	atomic_set(&dest->activeconns, 0);
 	atomic_set(&dest->inactconns, 0);
 	atomic_set(&dest->persistconns, 0);
-	atomic_set(&dest->refcnt, 1);
+	refcount_set(&dest->refcnt, 1);
 
 	INIT_HLIST_NODE(&dest->d_list);
 	spin_lock_init(&dest->dst_lock);
@@ -998,7 +998,7 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 		IP_VS_DBG_BUF(3, "Get destination %s:%u from trash, "
 			      "dest->refcnt=%d, service %u/%s:%u\n",
 			      IP_VS_DBG_ADDR(udest->af, &daddr), ntohs(dport),
-			      atomic_read(&dest->refcnt),
+			      refcount_read(&dest->refcnt),
 			      dest->vfwmark,
 			      IP_VS_DBG_ADDR(svc->af, &dest->vaddr),
 			      ntohs(dest->vport));
@@ -1074,7 +1074,7 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
 	spin_lock_bh(&ipvs->dest_trash_lock);
 	IP_VS_DBG_BUF(3, "Moving dest %s:%u into trash, dest->refcnt=%d\n",
 		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port),
-		      atomic_read(&dest->refcnt));
+		      refcount_read(&dest->refcnt));
 	if (list_empty(&ipvs->dest_trash) && !cleanup)
 		mod_timer(&ipvs->dest_trash_timer,
 			  jiffies + (IP_VS_DEST_TRASH_PERIOD >> 1));
@@ -1157,7 +1157,7 @@ static void ip_vs_dest_trash_expire(unsigned long data)
 
 	spin_lock(&ipvs->dest_trash_lock);
 	list_for_each_entry_safe(dest, next, &ipvs->dest_trash, t_list) {
-		if (atomic_read(&dest->refcnt) > 1)
+		if (refcount_read(&dest->refcnt) > 1)
 			continue;
 		if (dest->idle_start) {
 			if (time_before(now, dest->idle_start +
@@ -1545,7 +1545,7 @@ ip_vs_forget_dev(struct ip_vs_dest *dest, struct net_device *dev)
 			      dev->name,
 			      IP_VS_DBG_ADDR(dest->af, &dest->addr),
 			      ntohs(dest->port),
-			      atomic_read(&dest->refcnt));
+			      refcount_read(&dest->refcnt));
 		__ip_vs_dst_cache_reset(dest);
 	}
 	spin_unlock_bh(&dest->dst_lock);
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 5824927..b6aa4a9 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -448,7 +448,7 @@ __ip_vs_lblc_schedule(struct ip_vs_service *svc)
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 703f118..c13ff57 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -204,7 +204,7 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 	return least;
 }
@@ -249,7 +249,7 @@ static inline struct ip_vs_dest *ip_vs_dest_set_max(struct ip_vs_dest_set *set)
 		      __func__,
 		      IP_VS_DBG_ADDR(most->af, &most->addr), ntohs(most->port),
 		      atomic_read(&most->activeconns),
-		      atomic_read(&most->refcnt),
+		      refcount_read(&most->refcnt),
 		      atomic_read(&most->weight), moh);
 	return most;
 }
@@ -612,7 +612,7 @@ __ip_vs_lblcr_schedule(struct ip_vs_service *svc)
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
diff --git a/net/netfilter/ipvs/ip_vs_nq.c b/net/netfilter/ipvs/ip_vs_nq.c
index a8b6340..7d9d4ac 100644
--- a/net/netfilter/ipvs/ip_vs_nq.c
+++ b/net/netfilter/ipvs/ip_vs_nq.c
@@ -110,7 +110,7 @@ ip_vs_nq_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
diff --git a/net/netfilter/ipvs/ip_vs_rr.c b/net/netfilter/ipvs/ip_vs_rr.c
index 58bacfc..ee0530d1 100644
--- a/net/netfilter/ipvs/ip_vs_rr.c
+++ b/net/netfilter/ipvs/ip_vs_rr.c
@@ -97,7 +97,7 @@ ip_vs_rr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      "activeconns %d refcnt %d weight %d\n",
 		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port),
 		      atomic_read(&dest->activeconns),
-		      atomic_read(&dest->refcnt), atomic_read(&dest->weight));
+		      refcount_read(&dest->refcnt), atomic_read(&dest->weight));
 
 	return dest;
 }
diff --git a/net/netfilter/ipvs/ip_vs_sed.c b/net/netfilter/ipvs/ip_vs_sed.c
index f8e2d00..ab23cf2 100644
--- a/net/netfilter/ipvs/ip_vs_sed.c
+++ b/net/netfilter/ipvs/ip_vs_sed.c
@@ -111,7 +111,7 @@ ip_vs_sed_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
diff --git a/net/netfilter/ipvs/ip_vs_wlc.c b/net/netfilter/ipvs/ip_vs_wlc.c
index 6b366fd..6add39e 100644
--- a/net/netfilter/ipvs/ip_vs_wlc.c
+++ b/net/netfilter/ipvs/ip_vs_wlc.c
@@ -83,7 +83,7 @@ ip_vs_wlc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
diff --git a/net/netfilter/ipvs/ip_vs_wrr.c b/net/netfilter/ipvs/ip_vs_wrr.c
index 17e6d44..62258dd 100644
--- a/net/netfilter/ipvs/ip_vs_wrr.c
+++ b/net/netfilter/ipvs/ip_vs_wrr.c
@@ -218,7 +218,7 @@ ip_vs_wrr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      "activeconns %d refcnt %d weight %d\n",
 		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port),
 		      atomic_read(&dest->activeconns),
-		      atomic_read(&dest->refcnt),
+		      refcount_read(&dest->refcnt),
 		      atomic_read(&dest->weight));
 	mark->cl = dest;
 
-- 
2.7.4
