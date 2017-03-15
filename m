From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 1/7] net, netfilter: convert ip_vs_conn.refcnt from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 13:10:39 +0200
Message-ID: <1489576245-19472-2-git-send-email-elena.reshetova@intel.com>
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
 include/net/ip_vs.h                   |  8 +++++---
 net/netfilter/ipvs/ip_vs_conn.c       | 24 ++++++++++++------------
 net/netfilter/ipvs/ip_vs_core.c       |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  2 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |  2 +-
 5 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 7bdfa7d..f1429c3 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -12,6 +12,8 @@
 #include <linux/list.h>                 /* for struct list_head */
 #include <linux/spinlock.h>             /* for struct rwlock_t */
 #include <linux/atomic.h>               /* for struct atomic_t */
+#include <linux/refcount.h>             /* for struct refcount_t */
+
 #include <linux/compiler.h>
 #include <linux/timer.h>
 #include <linux/bug.h>
@@ -525,7 +527,7 @@ struct ip_vs_conn {
 	struct netns_ipvs	*ipvs;
 
 	/* counter and timer */
-	atomic_t		refcnt;		/* reference count */
+	refcount_t		refcnt;		/* reference count */
 	struct timer_list	timer;		/* Expiration timer */
 	volatile unsigned long	timeout;	/* timeout */
 
@@ -1211,14 +1213,14 @@ struct ip_vs_conn * ip_vs_conn_out_get_proto(struct netns_ipvs *ipvs, int af,
  */
 static inline bool __ip_vs_conn_get(struct ip_vs_conn *cp)
 {
-	return atomic_inc_not_zero(&cp->refcnt);
+	return refcount_inc_not_zero(&cp->refcnt);
 }
 
 /* put back the conn without restarting its timer */
 static inline void __ip_vs_conn_put(struct ip_vs_conn *cp)
 {
 	smp_mb__before_atomic();
-	atomic_dec(&cp->refcnt);
+	refcount_dec(&cp->refcnt);
 }
 void ip_vs_conn_put(struct ip_vs_conn *cp);
 void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport);
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index e6a2753..3d2ac71a 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -181,7 +181,7 @@ static inline int ip_vs_conn_hash(struct ip_vs_conn *cp)
 
 	if (!(cp->flags & IP_VS_CONN_F_HASHED)) {
 		cp->flags |= IP_VS_CONN_F_HASHED;
-		atomic_inc(&cp->refcnt);
+		refcount_inc(&cp->refcnt);
 		hlist_add_head_rcu(&cp->c_list, &ip_vs_conn_tab[hash]);
 		ret = 1;
 	} else {
@@ -215,7 +215,7 @@ static inline int ip_vs_conn_unhash(struct ip_vs_conn *cp)
 	if (cp->flags & IP_VS_CONN_F_HASHED) {
 		hlist_del_rcu(&cp->c_list);
 		cp->flags &= ~IP_VS_CONN_F_HASHED;
-		atomic_dec(&cp->refcnt);
+		refcount_dec(&cp->refcnt);
 		ret = 1;
 	} else
 		ret = 0;
@@ -242,13 +242,13 @@ static inline bool ip_vs_conn_unlink(struct ip_vs_conn *cp)
 	if (cp->flags & IP_VS_CONN_F_HASHED) {
 		ret = false;
 		/* Decrease refcnt and unlink conn only if we are last user */
-		if (atomic_cmpxchg(&cp->refcnt, 1, 0) == 1) {
+		if (refcount_dec_if_one(&cp->refcnt)) {
 			hlist_del_rcu(&cp->c_list);
 			cp->flags &= ~IP_VS_CONN_F_HASHED;
 			ret = true;
 		}
 	} else
-		ret = atomic_read(&cp->refcnt) ? false : true;
+		ret = refcount_read(&cp->refcnt) ? false : true;
 
 	spin_unlock(&cp->lock);
 	ct_write_unlock_bh(hash);
@@ -475,7 +475,7 @@ static void __ip_vs_conn_put_timer(struct ip_vs_conn *cp)
 void ip_vs_conn_put(struct ip_vs_conn *cp)
 {
 	if ((cp->flags & IP_VS_CONN_F_ONE_PACKET) &&
-	    (atomic_read(&cp->refcnt) == 1) &&
+	    (refcount_read(&cp->refcnt) == 1) &&
 	    !timer_pending(&cp->timer))
 		/* expire connection immediately */
 		__ip_vs_conn_put_notimer(cp);
@@ -617,8 +617,8 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
 		      ip_vs_fwd_tag(cp), cp->state,
-		      cp->flags, atomic_read(&cp->refcnt),
-		      atomic_read(&dest->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt),
+		      refcount_read(&dest->refcnt));
 
 	/* Update the connection counters */
 	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
@@ -714,8 +714,8 @@ static inline void ip_vs_unbind_dest(struct ip_vs_conn *cp)
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
 		      ip_vs_fwd_tag(cp), cp->state,
-		      cp->flags, atomic_read(&cp->refcnt),
-		      atomic_read(&dest->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt),
+		      refcount_read(&dest->refcnt));
 
 	/* Update the connection counters */
 	if (!(cp->flags & IP_VS_CONN_F_TEMPLATE)) {
@@ -863,10 +863,10 @@ static void ip_vs_conn_expire(unsigned long data)
 
   expire_later:
 	IP_VS_DBG(7, "delayed: conn->refcnt=%d conn->n_control=%d\n",
-		  atomic_read(&cp->refcnt),
+		  refcount_read(&cp->refcnt),
 		  atomic_read(&cp->n_control));
 
-	atomic_inc(&cp->refcnt);
+	refcount_inc(&cp->refcnt);
 	cp->timeout = 60*HZ;
 
 	if (ipvs->sync_state & IP_VS_STATE_MASTER)
@@ -941,7 +941,7 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 	 * it in the table, so that other thread run ip_vs_random_dropentry
 	 * but cannot drop this entry.
 	 */
-	atomic_set(&cp->refcnt, 1);
+	refcount_set(&cp->refcnt, 1);
 
 	cp->control = NULL;
 	atomic_set(&cp->n_control, 0);
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index db40050..a3e1b9c 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -542,7 +542,7 @@ ip_vs_schedule(struct ip_vs_service *svc, struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
-		      cp->flags, atomic_read(&cp->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt));
 
 	ip_vs_conn_stats(cp, svc);
 	return cp;
@@ -1193,7 +1193,7 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
 		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->af, &cp->daddr), ntohs(cp->dport),
-		      cp->flags, atomic_read(&cp->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt));
 	LeaveFunction(12);
 	return cp;
 }
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index d952d67..56f8e4b 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -447,7 +447,7 @@ set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 				ntohs(cp->cport),
 				sctp_state_name(cp->state),
 				sctp_state_name(next_state),
-				atomic_read(&cp->refcnt));
+				refcount_read(&cp->refcnt));
 		if (dest) {
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				(next_state != IP_VS_SCTP_S_ESTABLISHED)) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 5117bcb..12dc8d5 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -557,7 +557,7 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 			      ntohs(cp->cport),
 			      tcp_state_name(cp->state),
 			      tcp_state_name(new_state),
-			      atomic_read(&cp->refcnt));
+			      refcount_read(&cp->refcnt));
 
 		if (dest) {
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
-- 
2.7.4
