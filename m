From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 02/34] netfilter: ipset: Prepare the ipset core to use RCU at set level
Date: Sat,  2 May 2015 19:27:51 +0200
Message-ID: <1430587703-3387-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36945 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbbEBR2E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:04 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace rwlock_t with spinlock_t in "struct ip_set" and change the locking
accordingly. Also, simplify the timeout routines.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         |  2 +-
 include/linux/netfilter/ipset/ip_set_timeout.h | 25 ++++++---------
 net/netfilter/ipset/ip_set_core.c              | 44 +++++++++++++-------------
 3 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 34b1723..a6b7b58 100644
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
diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index 83c2f9e..cfe8a3f 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -40,31 +40,26 @@ ip_set_timeout_uget(struct nlattr *tb)
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
+	t = msecs_to_jiffies(value * 1000) + jiffies;
+	if (t == IPSET_ELEM_PERMANENT)
 		/* Bingo! :-) */
-		(*timeout)--;
+		t--;
+	*timeout = t;
 }
 
 static inline u32
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index d259da3..a8e55c8 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -208,15 +208,15 @@ ip_set_type_register(struct ip_set_type *type)
 		pr_warn("ip_set type %s, family %s with revision min %u already registered!\n",
 			type->name, family_name(type->family),
 			type->revision_min);
-		ret = -EINVAL;
-		goto unlock;
+		ip_set_type_unlock();
+		return -EINVAL;
 	}
 	list_add_rcu(&type->list, &ip_set_type_list);
 	pr_debug("type %s, family %s, revision %u:%u registered.\n",
 		 type->name, family_name(type->family),
 		 type->revision_min, type->revision_max);
-unlock:
 	ip_set_type_unlock();
+	synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ip_set_type_register);
@@ -230,12 +230,12 @@ ip_set_type_unregister(struct ip_set_type *type)
 		pr_warn("ip_set type %s, family %s with revision min %u not registered\n",
 			type->name, family_name(type->family),
 			type->revision_min);
-		goto unlock;
+		ip_set_type_unlock();
+		return;
 	}
 	list_del_rcu(&type->list);
 	pr_debug("type %s, family %s with revision min %u unregistered.\n",
 		 type->name, family_name(type->family), type->revision_min);
-unlock:
 	ip_set_type_unlock();
 
 	synchronize_rcu();
@@ -496,16 +496,16 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
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
@@ -535,9 +535,9 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	return ret;
 }
@@ -558,9 +558,9 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 
 	return ret;
 }
@@ -845,7 +845,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	set = kzalloc(sizeof(struct ip_set), GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
-	rwlock_init(&set->lock);
+	spin_lock_init(&set->lock);
 	strlcpy(set->name, name, IPSET_MAXNAMELEN);
 	set->family = family;
 	set->revision = revision;
@@ -1024,9 +1024,9 @@ ip_set_flush_set(struct ip_set *set)
 {
 	pr_debug("set: %s\n",  set->name);
 
-	write_lock_bh(&set->lock);
+	spin_lock_bh(&set->lock);
 	set->variant->flush(set);
-	write_unlock_bh(&set->lock);
+	spin_unlock_bh(&set->lock);
 }
 
 static int
@@ -1327,9 +1327,9 @@ dump_last:
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
@@ -1407,9 +1407,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
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
@@ -1589,9 +1589,9 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
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

