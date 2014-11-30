From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 08/14] netfilter: ipset: Introduce RCU locking instead of rwlock per set in the core
Date: Sun, 30 Nov 2014 19:56:59 +0100
Message-ID: <1417373825-3734-9-git-send-email-kadlec@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55032 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbaK3S4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:56:09 -0500
In-Reply-To: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         |  6 ++++-
 include/linux/netfilter/ipset/ip_set_timeout.h | 27 ++++++++------------
 net/netfilter/ipset/ip_set_core.c              | 35 +++++++++++++-------------
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index f1606fa..d5d5bcd 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -223,7 +223,7 @@ struct ip_set {
 	/* The name of the set */
 	char name[IPSET_MAXNAMELEN];
 	/* Lock protecting the set data */
-	rwlock_t lock;
+	spinlock_t lock;
 	/* References to the set */
 	u32 ref;
 	/* The core set type */
@@ -322,6 +322,10 @@ ip_set_update_counter(struct ip_set_counter *counter,
 	}
 }
 
+#define ip_set_rcu_deref(t)		\
+	rcu_dereference_index_check(t,	\
+		rcu_read_lock_held() || rcu_read_lock_bh_held())
+
 static inline void
 ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
 		      const struct ip_set_ext *ext,
diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index 83c2f9e..1d6a935 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -40,38 +40,33 @@ ip_set_timeout_uget(struct nlattr *tb)
 }
 
 static inline bool
-ip_set_timeout_test(unsigned long timeout)
+ip_set_timeout_expired(unsigned long *t)
 {
-	return timeout == IPSET_ELEM_PERMANENT ||
-	       time_is_after_jiffies(timeout);
-}
-
-static inline bool
-ip_set_timeout_expired(unsigned long *timeout)
-{
-	return *timeout != IPSET_ELEM_PERMANENT &&
-	       time_is_before_jiffies(*timeout);
+	return *t != IPSET_ELEM_PERMANENT && time_is_before_jiffies(*t);
 }
 
 static inline void
-ip_set_timeout_set(unsigned long *timeout, u32 t)
+ip_set_timeout_set(unsigned long *timeout, u32 value)
 {
-	if (!t) {
+	unsigned long t;
+
+	if (!value) {
 		*timeout = IPSET_ELEM_PERMANENT;
 		return;
 	}
 
-	*timeout = msecs_to_jiffies(t * 1000) + jiffies;
-	if (*timeout == IPSET_ELEM_PERMANENT)
+	t = msecs_to_jiffies(value * MSEC_PER_SEC) + jiffies;
+	if (t == IPSET_ELEM_PERMANENT)
 		/* Bingo! :-) */
-		(*timeout)--;
+		t--;
+	*timeout = t;
 }
 
 static inline u32
 ip_set_timeout_get(unsigned long *timeout)
 {
 	return *timeout == IPSET_ELEM_PERMANENT ? 0 :
-		jiffies_to_msecs(*timeout - jiffies)/1000;
+		jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
 }
 
 #endif	/* __KERNEL__ */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 912e5a0..9fb2610 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -217,6 +217,7 @@ ip_set_type_register(struct ip_set_type *type)
 		 type->revision_min, type->revision_max);
 unlock:
 	ip_set_type_unlock();
+	synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ip_set_type_register);
@@ -496,16 +497,16 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return 0;
 
-	read_lock_bh(&set->lock);
+	rcu_read_lock_bh();
 	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
-	read_unlock_bh(&set->lock);
+	rcu_read_unlock_bh();
 
 	if (ret == -EAGAIN) {
 		/* Type requests element to be completed */
 		pr_debug("element must be completed, ADD is triggered\n");
-		write_lock_bh(&set->lock);
+		spin_lock_bh(&set->lock);
 		set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-		write_unlock_bh(&set->lock);
+		spin_unlock_bh(&set->lock);
 		ret = 1;
 	} else {
 		/* --return-nomatch: invert matched element */
@@ -535,9 +536,9 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	return ret;
 }
@@ -558,9 +559,9 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	return ret;
 }
@@ -845,7 +846,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	set = kzalloc(sizeof(struct ip_set), GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
-	rwlock_init(&set->lock);
+	spin_lock_init(&set->lock);
 	strlcpy(set->name, name, IPSET_MAXNAMELEN);
 	set->family = family;
 	set->revision = revision;
@@ -1024,9 +1025,9 @@ ip_set_flush_set(struct ip_set *set)
 {
 	pr_debug("set: %s\n",  set->name);
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	set->variant->flush(set);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 }
 
 static int
@@ -1327,9 +1328,9 @@ dump_last:
 				goto next_set;
 			/* Fall through and add elements */
 		default:
-			read_lock_bh(&set->lock);
+			rcu_read_lock_bh();
 			ret = set->variant->list(set, skb, cb);
-			read_unlock_bh(&set->lock);
+			rcu_read_unlock_bh();
 			if (!cb->args[IPSET_CB_ARG0])
 				/* Set is done, proceed with next one */
 				goto next_set;
@@ -1407,9 +1408,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
 
 	do {
-		write_lock_bh(&set->lock);
+		spin_lock_bh(&set->lock);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
-		write_unlock_bh(&set->lock);
+		spin_unlock_bh(&set->lock);
 		retried = true;
 	} while (ret == -EAGAIN &&
 		 set->variant->resize &&
@@ -1589,9 +1590,9 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 			     set->type->adt_policy))
 		return -IPSET_ERR_PROTOCOL;
 
-	read_lock_bh(&set->lock);
+	rcu_read_lock_bh();
 	ret = set->variant->uadt(set, tb, IPSET_TEST, NULL, 0, 0);
-	read_unlock_bh(&set->lock);
+	rcu_read_unlock_bh();
 	/* Userspace can't trigger element to be re-added */
 	if (ret == -EAGAIN)
 		ret = 1;
-- 
1.8.5.1

