From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 6/8] netfilter: ipset: styles warned by checkpatch.pl fixed
Date: Fri, 12 Dec 2014 22:58:07 +0100
Message-ID: <1418421489-17411-7-git-send-email-kadlec@blackhole.kfki.hu>
References: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40184 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaLLV5L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:57:11 -0500
In-Reply-To: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h       |  6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h      | 16 ++---
 net/netfilter/ipset/ip_set_bitmap_ip.c       | 10 ++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |  6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c     |  7 ++-
 net/netfilter/ipset/ip_set_core.c            | 89 +++++++++++++---------------
 net/netfilter/ipset/ip_set_getport.c         |  3 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 79 +++++++++++++-----------
 net/netfilter/ipset/ip_set_hash_ip.c         |  4 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  9 +--
 net/netfilter/ipset/ip_set_hash_ipport.c     | 14 +++--
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 16 ++---
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 19 +++---
 net/netfilter/ipset/ip_set_hash_mac.c        |  2 +-
 net/netfilter/ipset/ip_set_hash_net.c        |  8 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c   | 17 ++++--
 net/netfilter/ipset/ip_set_hash_netnet.c     | 44 +++++++-------
 net/netfilter/ipset/ip_set_hash_netport.c    | 19 +++---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 54 +++++++++--------
 net/netfilter/ipset/ip_set_list_set.c        | 15 ++---
 net/netfilter/ipset/pfxlen.c                 | 16 ++---
 net/netfilter/xt_set.c                       |  7 +++
 net/sched/em_ipset.c                         |  5 +-
 23 files changed, 254 insertions(+), 211 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b3fe9f9..00fed2f 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -341,10 +341,10 @@ ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
 			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
 					  skbinfo->skbmarkmask))) ||
 	       (skbinfo->skbprio &&
-	        nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
+		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
 			      cpu_to_be32(skbinfo->skbprio))) ||
 	       (skbinfo->skbqueue &&
-	        nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
+		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
 			     cpu_to_be16(skbinfo->skbqueue)));
 
 }
@@ -543,7 +543,7 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 
 		if (nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
 			htonl(active ? ip_set_timeout_get(timeout)
-				: *timeout)))
+			      : *timeout)))
 			return -EMSGSIZE;
 	}
 	if (SET_WITH_COUNTER(set) &&
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 136f20b..dba65b4 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -41,7 +41,7 @@ mtype_gc_init(struct ip_set *set, void (*gc)(unsigned long ul_set))
 	struct mtype *map = set->data;
 
 	init_timer(&map->gc);
-	map->gc.data = (unsigned long) set;
+	map->gc.data = (unsigned long)set;
 	map->gc.function = gc;
 	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&map->gc);
@@ -214,7 +214,7 @@ mtype_list(const struct ip_set *set,
 		if (!test_bit(id, map->members) ||
 		    (SET_WITH_TIMEOUT(set) &&
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
-		     mtype_is_filled((const struct mtype_elem *) x) &&
+		     mtype_is_filled((const struct mtype_elem *)x) &&
 #endif
 		     ip_set_timeout_expired(ext_timeout(x, set))))
 			continue;
@@ -223,13 +223,14 @@ mtype_list(const struct ip_set *set,
 			if (id == first) {
 				nla_nest_cancel(skb, adt);
 				return -EMSGSIZE;
-			} else
-				goto nla_put_failure;
+			}
+
+			goto nla_put_failure;
 		}
 		if (mtype_do_list(skb, map, id, set->dsize))
 			goto nla_put_failure;
 		if (ip_set_put_extensions(skb, set, x,
-		    mtype_is_filled((const struct mtype_elem *) x)))
+		    mtype_is_filled((const struct mtype_elem *)x)))
 			goto nla_put_failure;
 		ipset_nest_end(skb, nested);
 	}
@@ -253,13 +254,14 @@ nla_put_failure:
 static void
 mtype_gc(unsigned long ul_set)
 {
-	struct ip_set *set = (struct ip_set *) ul_set;
+	struct ip_set *set = (struct ip_set *)ul_set;
 	struct mtype *map = set->data;
 	void *x;
 	u32 id;
 
 	/* We run parallel with other readers (test element)
-	 * but adding/deleting new entries is locked out */
+	 * but adding/deleting new entries is locked out
+	 */
 	spin_lock_bh(&set->lock);
 	for (id = 0; id < map->elements; id++)
 		if (mtype_gc_test(id, map, set->dsize)) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 55b083e..b683c17 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -177,8 +177,9 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (!cidr || cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
-	} else
+	} else {
 		ip_to = ip;
+	}
 
 	if (ip_to > map->last_ip)
 		return -IPSET_ERR_BITMAP_RANGE;
@@ -189,8 +190,8 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
@@ -280,8 +281,9 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		if (cidr >= 32)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(first_ip, last_ip, cidr);
-	} else
+	} else {
 		return -IPSET_ERR_PROTOCOL;
+	}
 
 	if (tb[IPSET_ATTR_NETMASK]) {
 		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 8610474..ba8b548 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -130,7 +130,8 @@ bitmap_ipmac_add_timeout(unsigned long *timeout,
 		/* If MAC is unset yet, we store plain timeout value
 		 * because the timer is not activated yet
 		 * and we can reuse it later when MAC is filled out,
-		 * possibly by the kernel */
+		 * possibly by the kernel
+		 */
 		if (e->ether)
 			ip_set_timeout_set(timeout, t);
 		else
@@ -346,8 +347,9 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		if (cidr >= 32)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(first_ip, last_ip, cidr);
-	} else
+	} else {
 		return -IPSET_ERR_PROTOCOL;
+	}
 
 	elements = (u64)last_ip - first_ip + 1;
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 005dd36..8a9f2d2 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -168,8 +168,9 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 			if (port < map->first_port)
 				return -IPSET_ERR_BITMAP_RANGE;
 		}
-	} else
+	} else {
 		port_to = port;
+	}
 
 	if (port_to > map->last_port)
 		return -IPSET_ERR_BITMAP_RANGE;
@@ -180,8 +181,8 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index ef24cdb..2ff1a10 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -34,6 +34,7 @@ struct ip_set_net {
 	ip_set_id_t	ip_set_max;	/* max number of sets */
 	int		is_deleted;	/* deleted by ip_set_net_exit */
 };
+
 static int ip_set_net_id __read_mostly;
 
 static inline struct ip_set_net *ip_set_pernet(struct net *net)
@@ -59,8 +60,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 #define ip_set(inst, id)		\
 	ip_set_dereference((inst)->ip_set_list)[id]
 
-/*
- * The set types are implemented in modules and registered set types
+/* The set types are implemented in modules and registered set types
  * can be found in ip_set_type_list. Adding/deleting types is
  * serialized by ip_set_type_mutex.
  */
@@ -130,7 +130,8 @@ __find_set_type_get(const char *name, u8 family, u8 revision,
 		goto unlock;
 	}
 	/* Make sure the type is already loaded
-	 * but we don't support the revision */
+	 * but we don't support the revision
+	 */
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
 		if (STRNCMP(type->name, name)) {
 			err = -IPSET_ERR_FIND_TYPE;
@@ -317,7 +318,7 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 		return -IPSET_ERR_PROTOCOL;
 
 	memcpy(ipaddr, nla_data(tb[IPSET_ATTR_IPADDR_IPV6]),
-		sizeof(struct in6_addr));
+	       sizeof(struct in6_addr));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
@@ -389,6 +390,7 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 		      struct ip_set_ext *ext)
 {
 	u64 fullmark;
+
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		if (!(set->extensions & IPSET_EXT_TIMEOUT))
 			return -IPSET_ERR_TIMEOUT;
@@ -432,8 +434,7 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 }
 EXPORT_SYMBOL_GPL(ip_set_get_extensions);
 
-/*
- * Creating/destroying/renaming/swapping affect the existence and
+/* Creating/destroying/renaming/swapping affect the existence and
  * the properties of a set. All of these can be executed from userspace
  * only and serialized by the nfnl mutex indirectly from nfnetlink.
  *
@@ -460,8 +461,7 @@ __ip_set_put(struct ip_set *set)
 	write_unlock_bh(&ip_set_ref_lock);
 }
 
-/*
- * Add, del and test set entries from kernel.
+/* Add, del and test set entries from kernel.
  *
  * The set behind the index must exist and must be referenced
  * so it can't be destroyed (or changed) under our foot.
@@ -566,8 +566,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(ip_set_del);
 
-/*
- * Find set by name, reference it once. The reference makes sure the
+/* Find set by name, reference it once. The reference makes sure the
  * thing pointed to, does not go away under our feet.
  *
  */
@@ -594,8 +593,7 @@ ip_set_get_byname(struct net *net, const char *name, struct ip_set **set)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_byname);
 
-/*
- * If the given set pointer points to a valid set, decrement
+/* If the given set pointer points to a valid set, decrement
  * reference count by 1. The caller shall not assume the index
  * to be valid, after calling this function.
  *
@@ -622,8 +620,7 @@ ip_set_put_byindex(struct net *net, ip_set_id_t index)
 }
 EXPORT_SYMBOL_GPL(ip_set_put_byindex);
 
-/*
- * Get the name of a set behind a set index.
+/* Get the name of a set behind a set index.
  * We assume the set is referenced, so it does exist and
  * can't be destroyed. The set cannot be renamed due to
  * the referencing either.
@@ -642,13 +639,11 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index)
 }
 EXPORT_SYMBOL_GPL(ip_set_name_byindex);
 
-/*
- * Routines to call by external subsystems, which do not
+/* Routines to call by external subsystems, which do not
  * call nfnl_lock for us.
  */
 
-/*
- * Find set by index, reference it once. The reference makes sure the
+/* Find set by index, reference it once. The reference makes sure the
  * thing pointed to, does not go away under our feet.
  *
  * The nfnl mutex is used in the function.
@@ -674,8 +669,7 @@ ip_set_nfnl_get_byindex(struct net *net, ip_set_id_t index)
 }
 EXPORT_SYMBOL_GPL(ip_set_nfnl_get_byindex);
 
-/*
- * If the given set pointer points to a valid set, decrement
+/* If the given set pointer points to a valid set, decrement
  * reference count by 1. The caller shall not assume the index
  * to be valid, after calling this function.
  *
@@ -697,8 +691,7 @@ ip_set_nfnl_put(struct net *net, ip_set_id_t index)
 }
 EXPORT_SYMBOL_GPL(ip_set_nfnl_put);
 
-/*
- * Communication protocol with userspace over netlink.
+/* Communication protocol with userspace over netlink.
  *
  * The commands are serialized by the nfnl mutex.
  */
@@ -838,11 +831,10 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	pr_debug("setname: %s, typename: %s, family: %s, revision: %u\n",
 		 name, typename, family_name(family), revision);
 
-	/*
-	 * First, and without any locks, allocate and initialize
+	/* First, and without any locks, allocate and initialize
 	 * a normal base set structure.
 	 */
-	set = kzalloc(sizeof(struct ip_set), GFP_KERNEL);
+	set = kzalloc(sizeof(*set), GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
 	spin_lock_init(&set->lock);
@@ -850,21 +842,18 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	set->family = family;
 	set->revision = revision;
 
-	/*
-	 * Next, check that we know the type, and take
+	/* Next, check that we know the type, and take
 	 * a reference on the type, to make sure it stays available
 	 * while constructing our new set.
 	 *
 	 * After referencing the type, we try to create the type
 	 * specific part of the set without holding any locks.
 	 */
-	ret = find_set_type_get(typename, family, revision, &(set->type));
+	ret = find_set_type_get(typename, family, revision, &set->type);
 	if (ret)
 		goto out;
 
-	/*
-	 * Without holding any locks, create private part.
-	 */
+	/* Without holding any locks, create private part. */
 	if (attr[IPSET_ATTR_DATA] &&
 	    nla_parse_nested(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA],
 			     set->type->create_policy)) {
@@ -878,8 +867,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 
 	/* BTW, ret==0 here. */
 
-	/*
-	 * Here, we have a valid, constructed set and we are protected
+	/* Here, we have a valid, constructed set and we are protected
 	 * by the nfnl mutex. Find the first free index in ip_set_list
 	 * and check clashing.
 	 */
@@ -902,7 +890,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 			/* Wraparound */
 			goto cleanup;
 
-		list = kzalloc(sizeof(struct ip_set *) * i, GFP_KERNEL);
+		list = kcalloc(i, sizeof(struct ip_set *), GFP_KERNEL);
 		if (!list)
 			goto cleanup;
 		/* nfnl mutex is held, both lists are valid */
@@ -916,12 +904,11 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 		inst->ip_set_max = i;
 		kfree(tmp);
 		ret = 0;
-	} else if (ret)
+	} else if (ret) {
 		goto cleanup;
+	}
 
-	/*
-	 * Finally! Add our shiny new set to the list, and be done.
-	 */
+	/* Finally! Add our shiny new set to the list, and be done. */
 	pr_debug("create: '%s' created with index %u!\n", set->name, index);
 	ip_set(inst, index) = set;
 
@@ -1146,7 +1133,8 @@ ip_set_swap(struct sock *ctnl, struct sk_buff *skb,
 
 	/* Features must not change.
 	 * Not an artificial restriction anymore, as we must prevent
-	 * possible loops created by swapping in setlist type of sets. */
+	 * possible loops created by swapping in setlist type of sets.
+	 */
 	if (!(from->type->features == to->type->features &&
 	      from->family == to->family))
 		return -IPSET_ERR_TYPE_MISMATCH;
@@ -1178,11 +1166,12 @@ static int
 ip_set_dump_done(struct netlink_callback *cb)
 {
 	struct ip_set_net *inst = (struct ip_set_net *)cb->args[IPSET_CB_NET];
+
 	if (cb->args[IPSET_CB_ARG0]) {
 		pr_debug("release set %s\n",
 			 ip_set(inst, cb->args[IPSET_CB_INDEX])->name);
 		__ip_set_put_byindex(inst,
-			(ip_set_id_t) cb->args[IPSET_CB_INDEX]);
+				     (ip_set_id_t)cb->args[IPSET_CB_INDEX]);
 	}
 	return 0;
 }
@@ -1215,7 +1204,7 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 
 	/* cb->args[IPSET_CB_NET]:	net namespace
 	 *         [IPSET_CB_DUMP]:	dump single set/all sets
-	 *         [IPSET_CB_INDEX]: 	set index
+	 *         [IPSET_CB_INDEX]:	set index
 	 *         [IPSET_CB_ARG0]:	type specific
 	 */
 
@@ -1229,11 +1218,13 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 
 		dump_type = DUMP_ONE;
 		cb->args[IPSET_CB_INDEX] = index;
-	} else
+	} else {
 		dump_type = DUMP_ALL;
+	}
 
 	if (cda[IPSET_ATTR_FLAGS]) {
 		u32 f = ip_set_get_h32(cda[IPSET_ATTR_FLAGS]);
+
 		dump_type |= (f << 16);
 	}
 	cb->args[IPSET_CB_NET] = (unsigned long)inst;
@@ -1258,7 +1249,8 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 		if (ret < 0) {
 			nlh = nlmsg_hdr(cb->skb);
 			/* We have to create and send the error message
-			 * manually :-( */
+			 * manually :-(
+			 */
 			if (nlh->nlmsg_flags & NLM_F_ACK)
 				netlink_ack(cb->skb, nlh, ret);
 			return ret;
@@ -1276,7 +1268,7 @@ dump_last:
 	pr_debug("dump type, flag: %u %u index: %ld\n",
 		 dump_type, dump_flags, cb->args[IPSET_CB_INDEX]);
 	for (; cb->args[IPSET_CB_INDEX] < max; cb->args[IPSET_CB_INDEX]++) {
-		index = (ip_set_id_t) cb->args[IPSET_CB_INDEX];
+		index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
 		set = ip_set(inst, index);
 		if (set == NULL) {
 			if (dump_type == DUMP_ONE) {
@@ -1451,7 +1443,8 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 
 		*errline = lineno;
 
-		netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+		netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid,
+				MSG_DONTWAIT);
 		/* Signal netlink not to send its ACK/errmsg.  */
 		return -EINTR;
 	}
@@ -1862,7 +1855,7 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 		ret = -EFAULT;
 		goto done;
 	}
-	op = (unsigned int *) data;
+	op = (unsigned int *)data;
 
 	if (*op < IP_SET_OP_VERSION) {
 		/* Check the version at the beginning of operations */
@@ -1974,7 +1967,7 @@ ip_set_net_init(struct net *net)
 	if (inst->ip_set_max >= IPSET_INVALID_ID)
 		inst->ip_set_max = IPSET_INVALID_ID - 1;
 
-	list = kzalloc(sizeof(struct ip_set *) * inst->ip_set_max, GFP_KERNEL);
+	list = kcalloc(inst->ip_set_max, sizeof(struct ip_set *), GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
 	inst->is_deleted = 0;
@@ -2007,11 +2000,11 @@ static struct pernet_operations ip_set_net_ops = {
 	.size	= sizeof(struct ip_set_net)
 };
 
-
 static int __init
 ip_set_init(void)
 {
 	int ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
+
 	if (ret != 0) {
 		pr_err("ip_set: cannot register with nfnetlink.\n");
 		return ret;
diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index 29fb01d..b95c5ba 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -116,7 +116,8 @@ ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
 			return false;
 		default:
 			/* Other protocols doesn't have ports,
-			   so we can match fragments */
+			 * so we can match fragments.
+			 */
 			*proto = protocol;
 			return true;
 		}
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8f51ba4..1dadd85 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -57,6 +57,7 @@ tune_ahash_max(u8 curr, u32 multi)
 	 */
 	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
 }
+
 #define TUNE_AHASH_MAX(h, multi)	\
 	((h)->ahash_max = tune_ahash_max((h)->ahash_max, multi))
 #else
@@ -77,7 +78,7 @@ struct hbucket {
 /* The hash table: the table size stored here in order to make resizing easy */
 struct htable {
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
-	struct hbucket __rcu * bucket[0]; /* hashtable buckets */
+	struct hbucket __rcu *bucket[0]; /* hashtable buckets */
 };
 
 #define hbucket(h, i)		((h)->bucket[i])
@@ -270,7 +271,8 @@ struct htype {
 
 #ifdef IP_SET_HASH_WITH_NETS
 /* Network cidr size book keeping when the hash stores different
- * sized networks */
+ * sized networks
+ */
 static void
 mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 {
@@ -278,11 +280,11 @@ mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 
 	/* Add in increasing prefix order, so larger cidr first */
 	for (i = 0, j = -1; i < nets_length && h->nets[i].cidr[n]; i++) {
-		if (j != -1)
+		if (j != -1) {
 			continue;
-		else if (h->nets[i].cidr[n] < cidr)
+		} else if (h->nets[i].cidr[n] < cidr) {
 			j = i;
-		else if (h->nets[i].cidr[n] == cidr) {
+		} else if (h->nets[i].cidr[n] == cidr) {
 			h->nets[cidr - 1].nets[n]++;
 			return;
 		}
@@ -301,15 +303,15 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 	u8 i, j, net_end = nets_length - 1;
 
 	for (i = 0; i < nets_length; i++) {
-	        if (h->nets[i].cidr[n] != cidr)
-	                continue;
+		if (h->nets[i].cidr[n] != cidr)
+			continue;
 		h->nets[cidr - 1].nets[n]--;
 		if (h->nets[cidr - 1].nets[n] > 0)
-                        return;
+			return;
 		for (j = i; j < net_end && h->nets[j].cidr[n]; j++)
-		        h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
+			h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
 		h->nets[j].cidr[n] = 0;
-                return;
+		return;
 	}
 }
 #endif
@@ -406,7 +408,7 @@ mtype_destroy(struct ip_set *set)
 		del_timer_sync(&h->gc);
 
 	mtype_ahash_destroy(set,
-		__ipset_dereference_protected(h->table, 1), true);
+			    __ipset_dereference_protected(h->table, 1), true);
 	kfree(h);
 
 	set->data = NULL;
@@ -418,7 +420,7 @@ mtype_gc_init(struct ip_set *set, void (*gc)(unsigned long ul_set))
 	struct htype *h = set->data;
 
 	init_timer(&h->gc);
-	h->gc.data = (unsigned long) set;
+	h->gc.data = (unsigned long)set;
 	h->gc.function = gc;
 	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&h->gc);
@@ -481,7 +483,7 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 			}
 		}
 		if (d >= AHASH_INIT_SIZE) {
-			struct hbucket *tmp = kzalloc(sizeof(struct hbucket) +
+			struct hbucket *tmp = kzalloc(sizeof(*tmp) +
 					(n->size - AHASH_INIT_SIZE) * dsize,
 					GFP_ATOMIC);
 			if (!tmp)
@@ -506,7 +508,7 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 static void
 mtype_gc(unsigned long ul_set)
 {
-	struct ip_set *set = (struct ip_set *) ul_set;
+	struct ip_set *set = (struct ip_set *)ul_set;
 	struct htype *h = set->data;
 
 	pr_debug("called\n");
@@ -520,7 +522,8 @@ mtype_gc(unsigned long ul_set)
 
 /* Resize a hash: create a new hash table with doubling the hashsize
  * and inserting the elements to it. Repeat until we succeed or
- * fail due to memory pressures. */
+ * fail due to memory pressures.
+ */
 static int
 mtype_resize(struct ip_set *set, bool retried)
 {
@@ -589,7 +592,7 @@ retry:
 			key = HKEY(data, h->initval, htable_bits);
 			m = __ipset_dereference_protected(hbucket(t, key), 1);
 			if (!m) {
-				m = kzalloc(sizeof(struct hbucket) +
+				m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
 					    GFP_ATOMIC);
 				if (!m)
@@ -599,10 +602,10 @@ retry:
 			} else if (m->pos >= m->size) {
 				struct hbucket *ht;
 
-				if (m->size >= AHASH_MAX(h))
+				if (m->size >= AHASH_MAX(h)) {
 					ret = -EAGAIN;
-				else {
-					ht = kzalloc(sizeof(struct hbucket) +
+				} else {
+					ht = kzalloc(sizeof(*ht) +
 						(m->size + AHASH_INIT_SIZE)
 						* dsize,
 						GFP_ATOMIC);
@@ -647,11 +650,11 @@ out:
 	kfree(tmp);
 #endif
 	return ret;
-
 }
 
 /* Add an element to a hash and update the internal counters when succeeded,
- * otherwise report the proper error code. */
+ * otherwise report the proper error code.
+ */
 static int
 mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	  struct ip_set_ext *mext, u32 flags)
@@ -683,11 +686,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				pr_warn("Set %s is full, maxelem %u reached\n",
 					set->name, h->maxelem);
 			return -IPSET_ERR_HASH_FULL;
-		} else if (h->elements >= h->maxelem)
+		} else if (h->elements >= h->maxelem) {
 			goto set_full;
+		}
 		old = NULL;
-		n = kzalloc(sizeof(struct hbucket) +
-			    AHASH_INIT_SIZE * set->dsize,
+		n = kzalloc(sizeof(*n) + AHASH_INIT_SIZE * set->dsize,
 			    GFP_ATOMIC);
 		if (n == NULL)
 			return -ENOMEM;
@@ -711,8 +714,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				/* Just the extensions could be overwritten */
 				j = i;
 				goto overwrite_extensions;
-			} else
-				return -IPSET_ERR_EXIST;
+			}
+			return -IPSET_ERR_EXIST;
 		}
 		/* Reuse first timed out entry */
 		if (SET_WITH_TIMEOUT(set) &&
@@ -746,7 +749,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			return -EAGAIN;
 		}
 		old = n;
-		n = kzalloc(sizeof(struct hbucket) +
+		n = kzalloc(sizeof(*n) +
 			    (old->size + AHASH_INIT_SIZE) * set->dsize,
 			    GFP_ATOMIC);
 		if (!n)
@@ -847,7 +850,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
 		} else if (k >= AHASH_INIT_SIZE) {
-			struct hbucket *tmp = kzalloc(sizeof(struct hbucket) +
+			struct hbucket *tmp = kzalloc(sizeof(*tmp) +
 					(n->size - AHASH_INIT_SIZE) * dsize,
 					GFP_ATOMIC);
 			if (!tmp)
@@ -887,7 +890,8 @@ mtype_data_match(struct mtype_elem *data, const struct ip_set_ext *ext,
 
 #ifdef IP_SET_HASH_WITH_NETS
 /* Special test function which takes into account the different network
- * sizes added to the set */
+ * sizes added to the set
+ */
 static int
 mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		 const struct ip_set_ext *ext,
@@ -964,7 +968,8 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	t = rcu_dereference_bh(h->table);
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
-	 * try all possible network sizes */
+	 * try all possible network sizes
+	 */
 	for (i = 0; i < IPSET_NET_COUNT; i++)
 		if (GCIDR(d->cidr, i) != SET_HOST_MASK(set->family))
 			break;
@@ -1083,8 +1088,8 @@ mtype_list(const struct ip_set *set,
 					nla_nest_cancel(skb, atd);
 					ret = -EMSGSIZE;
 					goto out;
-				} else
-					goto nla_put_failure;
+				}
+				goto nla_put_failure;
 			}
 			if (mtype_data_list(skb, e))
 				goto nla_put_failure;
@@ -1106,20 +1111,22 @@ nla_put_failure:
 			set->name);
 		cb->args[IPSET_CB_ARG0] = 0;
 		ret = -EMSGSIZE;
-	} else
+	} else {
 		ipset_nest_end(skb, atd);
+	}
 out:
 	return ret;
 }
 
 static int
 IPSET_TOKEN(MTYPE, _kadt)(struct ip_set *set, const struct sk_buff *skb,
-	    const struct xt_action_param *par,
-	    enum ipset_adt adt, struct ip_set_adt_opt *opt);
+			  const struct xt_action_param *par,
+			  enum ipset_adt adt, struct ip_set_adt_opt *opt);
 
 static int
 IPSET_TOKEN(MTYPE, _uadt)(struct ip_set *set, struct nlattr *tb[],
-	    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried);
+			  enum ipset_adt adt, u32 *lineno, u32 flags,
+			  bool retried);
 
 static const struct ip_set_type_variant mtype_variant = {
 	.kadt	= mtype_kadt,
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 247cbc4..50278d9 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -162,8 +162,8 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 0d53038..6882a08 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -160,8 +160,8 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
@@ -215,7 +215,6 @@ hash_ipmark6_data_next(struct hash_ipmark4_elem *next,
 #define	IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
-
 static int
 hash_ipmark6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		  const struct xt_action_param *par,
@@ -274,10 +273,8 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 	ret = adtfn(set, &e, &ext, &ext, flags);
 	if (ret && !ip_set_eexist(ret, flags))
 		return ret;
-	else
-		ret = 0;
 
-	return ret;
+	return 0;
 }
 
 static struct ip_set_type hash_ipmark_type __read_mostly = {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 7dc9304..0dc521e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -148,8 +148,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
@@ -195,8 +196,8 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-			else
-				ret = 0;
+
+			ret = 0;
 		}
 	}
 	return ret;
@@ -317,8 +318,9 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
 		e.port = 0;
@@ -341,8 +343,8 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index af70f86..1c3ae88 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -63,7 +63,7 @@ hash_ipportip4_data_equal(const struct hash_ipportip4_elem *ip1,
 
 static bool
 hash_ipportip4_data_list(struct sk_buff *skb,
-		       const struct hash_ipportip4_elem *data)
+			 const struct hash_ipportip4_elem *data)
 {
 	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
 	    nla_put_ipaddr4(skb, IPSET_ATTR_IP2, data->ip2) ||
@@ -154,8 +154,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
@@ -201,8 +202,8 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-			else
-				ret = 0;
+
+			ret = 0;
 		}
 	}
 	return ret;
@@ -329,8 +330,9 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
 		e.port = 0;
@@ -353,8 +355,8 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 291c03f..129b9b7 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -216,14 +216,16 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -270,8 +272,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip2_from, ip2_to);
 		if (ip2_from + UINT_MAX == ip2_to)
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr + 1);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip);
@@ -294,8 +297,8 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
-				else
-					ret = 0;
+
+				ret = 0;
 				ip2 = ip2_last + 1;
 			}
 		}
@@ -477,14 +480,16 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
 		e.port = 0;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -508,8 +513,8 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 809461b..3271d01 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -85,7 +85,7 @@ hash_mac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		return 0;
 
 	if (skb_mac_header(skb) < skb->head ||
-	     (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
 
 	memcpy(e.ether, eth_hdr(skb)->h_source, ETH_ALEN);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index f6dcbfb..4e72e47 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -173,6 +173,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -180,7 +181,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
 		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
 		ret = adtfn(set, &e, &ext, &ext, flags);
-		return ip_set_enomatch(ret, flags, adt, set) ? -ret:
+		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
 	}
 
@@ -202,8 +203,8 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 		ip = last + 1;
 	}
 	return ret;
@@ -348,6 +349,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 20feebf..ea134ca 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -170,8 +170,9 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 			SRCDIR ? PHYSDEV(physindev) : PHYSDEV(physoutdev));
 		e.physdev = 1;
 #endif
-	} else
+	} else {
 		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
+	}
 
 	if (strlen(e.iface) == 0)
 		return -EINVAL;
@@ -217,6 +218,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
@@ -237,8 +239,9 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip);
@@ -249,8 +252,8 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 		ip = last + 1;
 	}
 	return ret;
@@ -383,8 +386,9 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 			SRCDIR ? PHYSDEV(physindev) : PHYSDEV(physoutdev));
 		e.physdev = 1;
 #endif
-	} else
+	} else {
 		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
+	}
 
 	if (strlen(e.iface) == 0)
 		return -EINVAL;
@@ -394,7 +398,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
-		   enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface6_elem e = { .cidr = HOST_MASK, .elem = 1 };
@@ -432,6 +436,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 5f91538..158c530 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -57,8 +57,8 @@ struct hash_netnet4_elem {
 
 static inline bool
 hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
-		     const struct hash_netnet4_elem *ip2,
-		     u32 *multi)
+			const struct hash_netnet4_elem *ip2,
+			u32 *multi)
 {
 	return ip1->ipcmp == ip2->ipcmp &&
 	       ip1->ccmp == ip2->ccmp;
@@ -84,7 +84,7 @@ hash_netnet4_data_reset_flags(struct hash_netnet4_elem *elem, u8 *flags)
 
 static inline void
 hash_netnet4_data_reset_elem(struct hash_netnet4_elem *elem,
-			  struct hash_netnet4_elem *orig)
+			     struct hash_netnet4_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
@@ -103,7 +103,7 @@ hash_netnet4_data_netmask(struct hash_netnet4_elem *elem, u8 cidr, bool inner)
 
 static bool
 hash_netnet4_data_list(struct sk_buff *skb,
-		    const struct hash_netnet4_elem *data)
+		       const struct hash_netnet4_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
@@ -122,7 +122,7 @@ nla_put_failure:
 
 static inline void
 hash_netnet4_data_next(struct hash_netnet4_elem *next,
-		    const struct hash_netnet4_elem *d)
+		       const struct hash_netnet4_elem *d)
 {
 	next->ipcmp = d->ipcmp;
 }
@@ -134,8 +134,8 @@ hash_netnet4_data_next(struct hash_netnet4_elem *next,
 
 static int
 hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
-	       const struct xt_action_param *par,
-	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		  const struct xt_action_param *par,
+		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -157,7 +157,7 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
-	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -204,6 +204,7 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -226,8 +227,9 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (unlikely(ip + UINT_MAX == ip_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr[0]);
+	}
 
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
@@ -238,8 +240,9 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip2_from, ip2_to);
 		if (unlikely(ip2_from + UINT_MAX == ip2_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip[0]);
@@ -258,8 +261,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			ret = adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-			else
-				ret = 0;
+
+			ret = 0;
 			ip2 = last2 + 1;
 		}
 		ip = last + 1;
@@ -283,8 +286,8 @@ struct hash_netnet6_elem {
 
 static inline bool
 hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
-		     const struct hash_netnet6_elem *ip2,
-		     u32 *multi)
+			const struct hash_netnet6_elem *ip2,
+			u32 *multi)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
@@ -311,7 +314,7 @@ hash_netnet6_data_reset_flags(struct hash_netnet6_elem *elem, u8 *flags)
 
 static inline void
 hash_netnet6_data_reset_elem(struct hash_netnet6_elem *elem,
-			  struct hash_netnet6_elem *orig)
+			     struct hash_netnet6_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
@@ -330,7 +333,7 @@ hash_netnet6_data_netmask(struct hash_netnet6_elem *elem, u8 cidr, bool inner)
 
 static bool
 hash_netnet6_data_list(struct sk_buff *skb,
-		    const struct hash_netnet6_elem *data)
+		       const struct hash_netnet6_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
@@ -349,7 +352,7 @@ nla_put_failure:
 
 static inline void
 hash_netnet6_data_next(struct hash_netnet4_elem *next,
-		    const struct hash_netnet6_elem *d)
+		       const struct hash_netnet6_elem *d)
 {
 }
 
@@ -365,8 +368,8 @@ hash_netnet6_data_next(struct hash_netnet4_elem *next,
 
 static int
 hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
-	       const struct xt_action_param *par,
-	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		  const struct xt_action_param *par,
+		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -388,7 +391,7 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
-	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netnet6_elem e = { };
@@ -432,6 +435,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 0c915e8..40c3ae8 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -205,8 +205,9 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
@@ -215,6 +216,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -240,8 +242,9 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip);
@@ -257,8 +260,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-			else
-				ret = 0;
+
+			ret = 0;
 		}
 		ip = last + 1;
 	}
@@ -428,14 +431,16 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
 		e.port = 0;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -459,8 +464,8 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 14b3d38..6e0ddb5 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -62,8 +62,8 @@ struct hash_netportnet4_elem {
 
 static inline bool
 hash_netportnet4_data_equal(const struct hash_netportnet4_elem *ip1,
-			   const struct hash_netportnet4_elem *ip2,
-			   u32 *multi)
+			    const struct hash_netportnet4_elem *ip2,
+			    u32 *multi)
 {
 	return ip1->ipcmp == ip2->ipcmp &&
 	       ip1->ccmp == ip2->ccmp &&
@@ -91,7 +91,7 @@ hash_netportnet4_data_reset_flags(struct hash_netportnet4_elem *elem, u8 *flags)
 
 static inline void
 hash_netportnet4_data_reset_elem(struct hash_netportnet4_elem *elem,
-				struct hash_netportnet4_elem *orig)
+				 struct hash_netportnet4_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
@@ -111,7 +111,7 @@ hash_netportnet4_data_netmask(struct hash_netportnet4_elem *elem,
 
 static bool
 hash_netportnet4_data_list(struct sk_buff *skb,
-			  const struct hash_netportnet4_elem *data)
+			   const struct hash_netportnet4_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
@@ -132,7 +132,7 @@ nla_put_failure:
 
 static inline void
 hash_netportnet4_data_next(struct hash_netportnet4_elem *next,
-			  const struct hash_netportnet4_elem *d)
+			   const struct hash_netportnet4_elem *d)
 {
 	next->ipcmp = d->ipcmp;
 	next->port = d->port;
@@ -145,8 +145,8 @@ hash_netportnet4_data_next(struct hash_netportnet4_elem *next,
 
 static int
 hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
-		     const struct xt_action_param *par,
-		     enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		      const struct xt_action_param *par,
+		      enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -172,7 +172,7 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
-		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -231,14 +231,16 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -262,8 +264,9 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (unlikely(ip + UINT_MAX == ip_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr[0]);
+	}
 
 	port_to = port = ntohs(e.port);
 	if (tb[IPSET_ATTR_PORT_TO]) {
@@ -281,8 +284,9 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip2_from, ip2_to);
 		if (unlikely(ip2_from + UINT_MAX == ip2_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip[0]);
@@ -306,8 +310,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 				ret = adtfn(set, &e, &ext, &ext, flags);
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
-				else
-					ret = 0;
+
+				ret = 0;
 				ip2 = ip2_last + 1;
 			}
 		}
@@ -334,8 +338,8 @@ struct hash_netportnet6_elem {
 
 static inline bool
 hash_netportnet6_data_equal(const struct hash_netportnet6_elem *ip1,
-			   const struct hash_netportnet6_elem *ip2,
-			   u32 *multi)
+			    const struct hash_netportnet6_elem *ip2,
+			    u32 *multi)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
@@ -364,7 +368,7 @@ hash_netportnet6_data_reset_flags(struct hash_netportnet6_elem *elem, u8 *flags)
 
 static inline void
 hash_netportnet6_data_reset_elem(struct hash_netportnet6_elem *elem,
-				struct hash_netportnet6_elem *orig)
+				 struct hash_netportnet6_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
@@ -384,7 +388,7 @@ hash_netportnet6_data_netmask(struct hash_netportnet6_elem *elem,
 
 static bool
 hash_netportnet6_data_list(struct sk_buff *skb,
-			  const struct hash_netportnet6_elem *data)
+			   const struct hash_netportnet6_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
@@ -405,7 +409,7 @@ nla_put_failure:
 
 static inline void
 hash_netportnet6_data_next(struct hash_netportnet4_elem *next,
-			  const struct hash_netportnet6_elem *d)
+			   const struct hash_netportnet6_elem *d)
 {
 	next->port = d->port;
 }
@@ -422,8 +426,8 @@ hash_netportnet6_data_next(struct hash_netportnet4_elem *next,
 
 static int
 hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
-		     const struct xt_action_param *par,
-		     enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		      const struct xt_action_param *par,
+		      enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -449,7 +453,7 @@ hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
-		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -507,14 +511,16 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
 		e.port = 0;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -538,8 +544,8 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index b7abcbb..97a5a6a 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -206,14 +206,15 @@ list_set_utest(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			continue;
 		}
 
-		if (d->before == 0)
+		if (d->before == 0) {
 			ret = 1;
-		else if (d->before > 0) {
+		} else if (d->before > 0) {
 			next = list_next_entry(e, list);
 			ret = !list_is_last(&e->list, &map->members) &&
 			      next->id == d->refid;
-		} else
+		} else {
 			ret = prev != NULL && prev->id == d->refid;
+		}
 		return ret;
 	}
 	return 0;
@@ -506,8 +507,8 @@ list_set_list(const struct ip_set *set,
 			if (i == first) {
 				nla_nest_cancel(skb, atd);
 				return -EMSGSIZE;
-			} else
-				goto nla_put_failure;
+			}
+			goto nla_put_failure;
 		}
 		if (nla_put_string(skb, IPSET_ATTR_NAME,
 				   ip_set_name_byindex(map->net, e->id)))
@@ -562,7 +563,7 @@ static const struct ip_set_type_variant set_variant = {
 static void
 list_set_gc(unsigned long ul_set)
 {
-	struct ip_set *set = (struct ip_set *) ul_set;
+	struct ip_set *set = (struct ip_set *)ul_set;
 	struct list_set *map = set->data;
 
 	spin_lock_bh(&set->lock);
@@ -579,7 +580,7 @@ list_set_gc_init(struct ip_set *set, void (*gc)(unsigned long ul_set))
 	struct list_set *map = set->data;
 
 	init_timer(&map->gc);
-	map->gc.data = (unsigned long) set;
+	map->gc.data = (unsigned long)set;
 	map->gc.function = gc;
 	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&map->gc);
diff --git a/net/netfilter/ipset/pfxlen.c b/net/netfilter/ipset/pfxlen.c
index 04d15fd..1c8a42c 100644
--- a/net/netfilter/ipset/pfxlen.c
+++ b/net/netfilter/ipset/pfxlen.c
@@ -1,9 +1,7 @@
 #include <linux/export.h>
 #include <linux/netfilter/ipset/pfxlen.h>
 
-/*
- * Prefixlen maps for fast conversions, by Jan Engelhardt.
- */
+/* Prefixlen maps for fast conversions, by Jan Engelhardt. */
 
 #define E(a, b, c, d) \
 	{.ip6 = { \
@@ -11,8 +9,7 @@
 		htonl(c), htonl(d), \
 	} }
 
-/*
- * This table works for both IPv4 and IPv6;
+/* This table works for both IPv4 and IPv6;
  * just use prefixlen_netmask_map[prefixlength].ip.
  */
 const union nf_inet_addr ip_set_netmask_map[] = {
@@ -149,13 +146,12 @@ const union nf_inet_addr ip_set_netmask_map[] = {
 EXPORT_SYMBOL_GPL(ip_set_netmask_map);
 
 #undef  E
-#define E(a, b, c, d)						\
-	{.ip6 = { (__force __be32) a, (__force __be32) b,	\
-		  (__force __be32) c, (__force __be32) d,	\
+#define E(a, b, c, d)					\
+	{.ip6 = { (__force __be32)a, (__force __be32)b,	\
+		  (__force __be32)c, (__force __be32)d,	\
 	} }
 
-/*
- * This table works for both IPv4 and IPv6;
+/* This table works for both IPv4 and IPv6;
  * just use prefixlen_hostmask_map[prefixlength].ip.
  */
 const union nf_inet_addr ip_set_hostmask_map[] = {
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 0d47afe..bec8a51 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -52,6 +52,7 @@ static bool
 set_match_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v0 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.u.compat.dim,
 		info->match_set.u.compat.flags, 0, UINT_MAX);
 
@@ -114,6 +115,7 @@ static bool
 set_match_v1(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v1 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.dim,
 		info->match_set.flags, 0, UINT_MAX);
 
@@ -178,6 +180,7 @@ static bool
 set_match_v3(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v3 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.dim,
 		info->match_set.flags, info->flags, UINT_MAX);
 	int ret;
@@ -252,6 +255,7 @@ static unsigned int
 set_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v0 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.u.compat.dim,
 		info->add_set.u.compat.flags, 0, UINT_MAX);
 	ADT_OPT(del_opt, par->family, info->del_set.u.compat.dim,
@@ -324,6 +328,7 @@ static unsigned int
 set_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v1 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, 0, UINT_MAX);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
@@ -392,6 +397,7 @@ static unsigned int
 set_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v2 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, info->flags, info->timeout);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
@@ -418,6 +424,7 @@ static unsigned int
 set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v3 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, info->flags, info->timeout);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
diff --git a/net/sched/em_ipset.c b/net/sched/em_ipset.c
index 5b4a4ef..c3dba5e 100644
--- a/net/sched/em_ipset.c
+++ b/net/sched/em_ipset.c
@@ -44,6 +44,7 @@ static int em_ipset_change(struct net *net, void *data, int data_len,
 static void em_ipset_destroy(struct tcf_ematch *em)
 {
 	const struct xt_set_info *set = (const void *) em->data;
+
 	if (set) {
 		ip_set_nfnl_put(em->net, set->index);
 		kfree((void *) em->data);
@@ -70,7 +71,9 @@ static int em_ipset_match(struct sk_buff *skb, struct tcf_ematch *em,
 		acpar.family = NFPROTO_IPV6;
 		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return 0;
-		/* doesn't call ipv6_find_hdr() because ipset doesn't use thoff, yet */
+		/* doesn't call ipv6_find_hdr() because ipset doesn't use
+		 * thoff, yet
+		 */
 		acpar.thoff = sizeof(struct ipv6hdr);
 		break;
 	default:
-- 
1.8.5.1

