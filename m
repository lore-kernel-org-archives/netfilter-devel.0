From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/8] netfilter: ipset: Prepare ipset core for RCU locking instead of rwlock per set
Date: Fri, 12 Dec 2014 22:58:03 +0100
Message-ID: <1418421489-17411-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:49138 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaLLV5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:57:08 -0500
In-Reply-To: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         |  2 +-
 include/linux/netfilter/ipset/ip_set_timeout.h | 27 +++++------
 net/netfilter/ipset/ip_set_core.c              | 66 ++++++++++++++------------
 3 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index f1606fa..b3fe9f9 100644
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
index d259da3..ef24cdb 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -42,7 +42,7 @@ static inline struct ip_set_net *ip_set_pernet(struct net *net)
 }
 
 #define IP_SET_INC	64
-#define STREQ(a, b)	(strncmp(a, b, IPSET_MAXNAMELEN) == 0)
+#define STRNCMP(a, b)	(strncmp(a, b, IPSET_MAXNAMELEN) == 0)
 
 static unsigned int max_sets;
 
@@ -85,7 +85,7 @@ find_set_type(const char *name, u8 family, u8 revision)
 	struct ip_set_type *type;
 
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
-		if (STREQ(type->name, name) &&
+		if (STRNCMP(type->name, name) &&
 		    (type->family == family ||
 		     type->family == NFPROTO_UNSPEC) &&
 		    revision >= type->revision_min &&
@@ -132,7 +132,7 @@ __find_set_type_get(const char *name, u8 family, u8 revision,
 	/* Make sure the type is already loaded
 	 * but we don't support the revision */
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
-		if (STREQ(type->name, name)) {
+		if (STRNCMP(type->name, name)) {
 			err = -IPSET_ERR_FIND_TYPE;
 			goto unlock;
 		}
@@ -166,7 +166,7 @@ __find_set_type_minmax(const char *name, u8 family, u8 *min, u8 *max,
 	*min = 255; *max = 0;
 	rcu_read_lock();
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
-		if (STREQ(type->name, name) &&
+		if (STRNCMP(type->name, name) &&
 		    (type->family == family ||
 		     type->family == NFPROTO_UNSPEC)) {
 			found = true;
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
@@ -581,7 +581,7 @@ ip_set_get_byname(struct net *net, const char *name, struct ip_set **set)
 	rcu_read_lock();
 	for (i = 0; i < inst->ip_set_max; i++) {
 		s = rcu_dereference(inst->ip_set_list)[i];
-		if (s != NULL && STREQ(s->name, name)) {
+		if (s != NULL && STRNCMP(s->name, name)) {
 			__ip_set_get(s);
 			index = i;
 			*set = s;
@@ -758,7 +758,7 @@ find_set_and_id(struct ip_set_net *inst, const char *name, ip_set_id_t *id)
 	*id = IPSET_INVALID_ID;
 	for (i = 0; i < inst->ip_set_max; i++) {
 		set = ip_set(inst, i);
-		if (set != NULL && STREQ(set->name, name)) {
+		if (set != NULL && STRNCMP(set->name, name)) {
 			*id = i;
 			break;
 		}
@@ -787,7 +787,7 @@ find_free_id(struct ip_set_net *inst, const char *name, ip_set_id_t *index,
 		if (s == NULL) {
 			if (*index == IPSET_INVALID_ID)
 				*index = i;
-		} else if (STREQ(name, s->name)) {
+		} else if (STRNCMP(name, s->name)) {
 			/* Name clash */
 			*set = s;
 			return -EEXIST;
@@ -845,7 +845,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	set = kzalloc(sizeof(struct ip_set), GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
-	rwlock_init(&set->lock);
+	spin_lock_init(&set->lock);
 	strlcpy(set->name, name, IPSET_MAXNAMELEN);
 	set->family = family;
 	set->revision = revision;
@@ -887,7 +887,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	if (ret == -EEXIST) {
 		/* If this is the same set and requested, ignore error */
 		if ((flags & IPSET_FLAG_EXIST) &&
-		    STREQ(set->type->name, clash->type->name) &&
+		    STRNCMP(set->type->name, clash->type->name) &&
 		    set->type->family == clash->type->family &&
 		    set->type->revision_min == clash->type->revision_min &&
 		    set->type->revision_max == clash->type->revision_max &&
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
@@ -1098,7 +1098,7 @@ ip_set_rename(struct sock *ctnl, struct sk_buff *skb,
 	name2 = nla_data(attr[IPSET_ATTR_SETNAME2]);
 	for (i = 0; i < inst->ip_set_max; i++) {
 		s = ip_set(inst, i);
-		if (s != NULL && STREQ(s->name, name2)) {
+		if (s != NULL && STRNCMP(s->name, name2)) {
 			ret = -IPSET_ERR_EXIST_SETNAME2;
 			goto out;
 		}
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
@@ -1407,9 +1407,13 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
 
 	do {
-		write_lock_bh(&set->lock);
+		spin_lock_bh(&set->lock);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
-		write_unlock_bh(&set->lock);
+		spin_unlock_bh(&set->lock);
+		if (ret == -EINPROGRESS) {
+			synchronize_rcu_bh();
+			ret = 0;
+		}
 		retried = true;
 	} while (ret == -EAGAIN &&
 		 set->variant->resize &&
@@ -1589,9 +1593,9 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
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

