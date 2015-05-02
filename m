From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 33/34] netfilter: ipset: Fix coding styles reported by checkpatch.pl
Date: Sat,  2 May 2015 19:28:22 +0200
Message-ID: <1430587703-3387-34-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51380 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbbEBR2N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:13 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h       |   6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h      |  11 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c       |  12 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |  23 +--
 net/netfilter/ipset/ip_set_bitmap_port.c     |   7 +-
 net/netfilter/ipset/ip_set_core.c            | 210 +++++++++++++--------------
 net/netfilter/ipset/ip_set_getport.c         |  13 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 108 +++++++-------
 net/netfilter/ipset/ip_set_hash_ip.c         |   5 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  10 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  15 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  17 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  20 ++-
 net/netfilter/ipset/ip_set_hash_mac.c        |   6 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   8 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  21 +--
 net/netfilter/ipset/ip_set_hash_netnet.c     |  46 +++---
 net/netfilter/ipset/ip_set_hash_netport.c    |  19 ++-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  54 ++++---
 net/netfilter/ipset/ip_set_list_set.c        |  17 ++-
 net/netfilter/ipset/pfxlen.c                 |  16 +-
 net/netfilter/xt_set.c                       |  37 +++--
 22 files changed, 358 insertions(+), 323 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 344616d..7c7074e 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -349,10 +349,10 @@ ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
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
@@ -550,7 +550,7 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 
 		if (nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
 			htonl(active ? ip_set_timeout_get(timeout)
-				: *timeout)))
+			      : *timeout)))
 			return -EMSGSIZE;
 	}
 	if (SET_WITH_COUNTER(set) &&
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 86429f3..d05e759 100644
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
@@ -223,7 +223,7 @@ mtype_list(const struct ip_set *set,
 		if (!test_bit(id, map->members) ||
 		    (SET_WITH_TIMEOUT(set) &&
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
-		     mtype_is_filled((const struct mtype_elem *) x) &&
+		     mtype_is_filled((const struct mtype_elem *)x) &&
 #endif
 		     ip_set_timeout_expired(ext_timeout(x, set))))
 			continue;
@@ -240,7 +240,7 @@ mtype_list(const struct ip_set *set,
 		if (mtype_do_list(skb, map, id, set->dsize))
 			goto nla_put_failure;
 		if (ip_set_put_extensions(skb, set, x,
-		    mtype_is_filled((const struct mtype_elem *) x)))
+		    mtype_is_filled((const struct mtype_elem *)x)))
 			goto nla_put_failure;
 		ipset_nest_end(skb, nested);
 	}
@@ -266,13 +266,14 @@ out:
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
index b8ce474..64a5643 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -59,7 +59,7 @@ struct bitmap_ip_adt_elem {
 static inline u32
 ip_to_id(const struct bitmap_ip *m, u32 ip)
 {
-	return ((ip & ip_set_hostmask(m->netmask)) - m->first_ip)/m->hosts;
+	return ((ip & ip_set_hostmask(m->netmask)) - m->first_ip) / m->hosts;
 }
 
 /* Common functions */
@@ -175,8 +175,9 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(ip, ip_to, cidr);
-	} else
+	} else {
 		ip_to = ip;
+	}
 
 	if (ip_to > map->last_ip)
 		return -IPSET_ERR_BITMAP_RANGE;
@@ -187,8 +188,8 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
@@ -278,8 +279,9 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		if (cidr >= HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(first_ip, last_ip, cidr);
-	} else
+	} else {
 		return -IPSET_ERR_PROTOCOL;
+	}
 
 	if (tb[IPSET_ATTR_NETMASK]) {
 		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index fe00e87..61264da 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -64,7 +64,7 @@ struct bitmap_ipmac_adt_elem {
 struct bitmap_ipmac_elem {
 	unsigned char ether[ETH_ALEN];
 	unsigned char filled;
-} __attribute__ ((aligned));
+} __aligned(8);
 
 static inline u32
 ip_to_id(const struct bitmap_ipmac *m, u32 ip)
@@ -90,7 +90,7 @@ bitmap_ipmac_do_test(const struct bitmap_ipmac_adt_elem *e,
 		return 0;
 	elem = get_elem(map->extensions, e->id, dsize);
 	if (elem->filled == MAC_FILLED)
-		return e->ether == NULL ||
+		return !e->ether ||
 		       ether_addr_equal(e->ether, elem->ether);
 	/* Trigger kernel to fill out the ethernet address */
 	return -EAGAIN;
@@ -131,7 +131,8 @@ bitmap_ipmac_add_timeout(unsigned long *timeout,
 		/* If MAC is unset yet, we store plain timeout value
 		 * because the timer is not activated yet
 		 * and we can reuse it later when MAC is filled out,
-		 * possibly by the kernel */
+		 * possibly by the kernel
+		 */
 		if (e->ether)
 			ip_set_timeout_set(timeout, t);
 		else
@@ -155,7 +156,7 @@ bitmap_ipmac_do_add(const struct bitmap_ipmac_adt_elem *e,
 				/* memcpy isn't atomic */
 				clear_bit(e->id, map->members);
 				smp_mb__after_atomic();
-				memcpy(elem->ether, e->ether, ETH_ALEN);
+				ether_addr_copy(elem->ether, e->ether);
 			}
 			return IPSET_ADD_FAILED;
 		} else if (!e->ether)
@@ -164,19 +165,18 @@ bitmap_ipmac_do_add(const struct bitmap_ipmac_adt_elem *e,
 		/* Fill the MAC address and trigger the timer activation */
 		clear_bit(e->id, map->members);
 		smp_mb__after_atomic();
-		memcpy(elem->ether, e->ether, ETH_ALEN);
+		ether_addr_copy(elem->ether, e->ether);
 		elem->filled = MAC_FILLED;
 		return IPSET_ADD_START_STORED_TIMEOUT;
 	} else if (e->ether) {
 		/* We can store MAC too */
-		memcpy(elem->ether, e->ether, ETH_ALEN);
+		ether_addr_copy(elem->ether, e->ether);
 		elem->filled = MAC_FILLED;
 		return 0;
-	} else {
-		elem->filled = MAC_UNSET;
-		/* MAC is not stored yet, don't start timer */
-		return IPSET_ADD_STORE_PLAIN_TIMEOUT;
 	}
+	elem->filled = MAC_UNSET;
+	/* MAC is not stored yet, don't start timer */
+	return IPSET_ADD_STORE_PLAIN_TIMEOUT;
 }
 
 static inline int
@@ -352,8 +352,9 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		if (cidr >= HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 		ip_set_mask_from_to(first_ip, last_ip, cidr);
-	} else
+	} else {
 		return -IPSET_ERR_PROTOCOL;
+	}
 
 	elements = (u64)last_ip - first_ip + 1;
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 2d360f9..5338ccd 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -162,8 +162,9 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 			if (port < map->first_port)
 				return -IPSET_ERR_BITMAP_RANGE;
 		}
-	} else
+	} else {
 		port_to = port;
+	}
 
 	if (port_to > map->last_port)
 		return -IPSET_ERR_BITMAP_RANGE;
@@ -174,8 +175,8 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
index 4061557..a9d099a 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -35,6 +35,7 @@ struct ip_set_net {
 	bool		is_deleted;	/* deleted by ip_set_net_exit */
 	bool		is_destroyed;	/* all sets are destroyed */
 };
+
 static int ip_set_net_id __read_mostly;
 
 static inline struct ip_set_net *ip_set_pernet(struct net *net)
@@ -60,8 +61,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 #define ip_set(inst, id)		\
 	ip_set_dereference((inst)->ip_set_list)[id]
 
-/*
- * The set types are implemented in modules and registered set types
+/* The set types are implemented in modules and registered set types
  * can be found in ip_set_type_list. Adding/deleting types is
  * serialized by ip_set_type_mutex.
  */
@@ -131,7 +131,8 @@ __find_set_type_get(const char *name, u8 family, u8 revision,
 		goto unlock;
 	}
 	/* Make sure the type is already loaded
-	 * but we don't support the revision */
+	 * but we don't support the revision
+	 */
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
 		if (STRNCMP(type->name, name)) {
 			err = -IPSET_ERR_FIND_TYPE;
@@ -290,7 +291,7 @@ static const struct nla_policy ipaddr_policy[IPSET_ATTR_IPADDR_MAX + 1] = {
 int
 ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipaddr)
 {
-	struct nlattr *tb[IPSET_ATTR_IPADDR_MAX+1];
+	struct nlattr *tb[IPSET_ATTR_IPADDR_MAX + 1];
 
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
@@ -307,7 +308,7 @@ EXPORT_SYMBOL_GPL(ip_set_get_ipaddr4);
 int
 ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 {
-	struct nlattr *tb[IPSET_ATTR_IPADDR_MAX+1];
+	struct nlattr *tb[IPSET_ATTR_IPADDR_MAX + 1];
 
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
@@ -318,7 +319,7 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 		return -IPSET_ERR_PROTOCOL;
 
 	memcpy(ipaddr, nla_data(tb[IPSET_ATTR_IPADDR_IPV6]),
-		sizeof(struct in6_addr));
+	       sizeof(struct in6_addr));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
@@ -383,7 +384,6 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
 	}
 	return offset;
 }
-
 EXPORT_SYMBOL_GPL(ip_set_elem_len);
 
 int
@@ -443,8 +443,7 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 }
 EXPORT_SYMBOL_GPL(ip_set_get_extensions);
 
-/*
- * Creating/destroying/renaming/swapping affect the existence and
+/* Creating/destroying/renaming/swapping affect the existence and
  * the properties of a set. All of these can be executed from userspace
  * only and serialized by the nfnl mutex indirectly from nfnetlink.
  *
@@ -471,8 +470,7 @@ __ip_set_put(struct ip_set *set)
 	write_unlock_bh(&ip_set_ref_lock);
 }
 
-/*
- * Add, del and test set entries from kernel.
+/* Add, del and test set entries from kernel.
  *
  * The set behind the index must exist and must be referenced
  * so it can't be destroyed (or changed) under our foot.
@@ -500,7 +498,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 			dev_net(par->in ? par->in : par->out), index);
 	int ret = 0;
 
-	BUG_ON(set == NULL);
+	BUG_ON(!set);
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
@@ -539,7 +537,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 			dev_net(par->in ? par->in : par->out), index);
 	int ret;
 
-	BUG_ON(set == NULL);
+	BUG_ON(!set);
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
@@ -562,7 +560,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 			dev_net(par->in ? par->in : par->out), index);
 	int ret = 0;
 
-	BUG_ON(set == NULL);
+	BUG_ON(!set);
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
@@ -577,8 +575,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(ip_set_del);
 
-/*
- * Find set by name, reference it once. The reference makes sure the
+/* Find set by name, reference it once. The reference makes sure the
  * thing pointed to, does not go away under our feet.
  *
  */
@@ -592,7 +589,7 @@ ip_set_get_byname(struct net *net, const char *name, struct ip_set **set)
 	rcu_read_lock();
 	for (i = 0; i < inst->ip_set_max; i++) {
 		s = rcu_dereference(inst->ip_set_list)[i];
-		if (s != NULL && STRNCMP(s->name, name)) {
+		if (s && STRNCMP(s->name, name)) {
 			__ip_set_get(s);
 			index = i;
 			*set = s;
@@ -605,8 +602,7 @@ ip_set_get_byname(struct net *net, const char *name, struct ip_set **set)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_byname);
 
-/*
- * If the given set pointer points to a valid set, decrement
+/* If the given set pointer points to a valid set, decrement
  * reference count by 1. The caller shall not assume the index
  * to be valid, after calling this function.
  *
@@ -619,7 +615,7 @@ __ip_set_put_byindex(struct ip_set_net *inst, ip_set_id_t index)
 
 	rcu_read_lock();
 	set = rcu_dereference(inst->ip_set_list)[index];
-	if (set != NULL)
+	if (set)
 		__ip_set_put(set);
 	rcu_read_unlock();
 }
@@ -633,8 +629,7 @@ ip_set_put_byindex(struct net *net, ip_set_id_t index)
 }
 EXPORT_SYMBOL_GPL(ip_set_put_byindex);
 
-/*
- * Get the name of a set behind a set index.
+/* Get the name of a set behind a set index.
  * We assume the set is referenced, so it does exist and
  * can't be destroyed. The set cannot be renamed due to
  * the referencing either.
@@ -645,7 +640,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index)
 {
 	const struct ip_set *set = ip_set_rcu_get(net, index);
 
-	BUG_ON(set == NULL);
+	BUG_ON(!set);
 	BUG_ON(set->ref == 0);
 
 	/* Referenced, so it's safe */
@@ -653,13 +648,11 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index)
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
@@ -685,8 +678,7 @@ ip_set_nfnl_get_byindex(struct net *net, ip_set_id_t index)
 }
 EXPORT_SYMBOL_GPL(ip_set_nfnl_get_byindex);
 
-/*
- * If the given set pointer points to a valid set, decrement
+/* If the given set pointer points to a valid set, decrement
  * reference count by 1. The caller shall not assume the index
  * to be valid, after calling this function.
  *
@@ -701,15 +693,14 @@ ip_set_nfnl_put(struct net *net, ip_set_id_t index)
 	nfnl_lock(NFNL_SUBSYS_IPSET);
 	if (!inst->is_deleted) { /* already deleted from ip_set_net_exit() */
 		set = ip_set(inst, index);
-		if (set != NULL)
+		if (set)
 			__ip_set_put(set);
 	}
 	nfnl_unlock(NFNL_SUBSYS_IPSET);
 }
 EXPORT_SYMBOL_GPL(ip_set_nfnl_put);
 
-/*
- * Communication protocol with userspace over netlink.
+/* Communication protocol with userspace over netlink.
  *
  * The commands are serialized by the nfnl mutex.
  */
@@ -736,7 +727,7 @@ start_msg(struct sk_buff *skb, u32 portid, u32 seq, unsigned int flags,
 
 	nlh = nlmsg_put(skb, portid, seq, cmd | (NFNL_SUBSYS_IPSET << 8),
 			sizeof(*nfmsg), flags);
-	if (nlh == NULL)
+	if (!nlh)
 		return NULL;
 
 	nfmsg = nlmsg_data(nlh);
@@ -769,7 +760,7 @@ find_set_and_id(struct ip_set_net *inst, const char *name, ip_set_id_t *id)
 	*id = IPSET_INVALID_ID;
 	for (i = 0; i < inst->ip_set_max; i++) {
 		set = ip_set(inst, i);
-		if (set != NULL && STRNCMP(set->name, name)) {
+		if (set && STRNCMP(set->name, name)) {
 			*id = i;
 			break;
 		}
@@ -795,7 +786,7 @@ find_free_id(struct ip_set_net *inst, const char *name, ip_set_id_t *index,
 	*index = IPSET_INVALID_ID;
 	for (i = 0;  i < inst->ip_set_max; i++) {
 		s = ip_set(inst, i);
-		if (s == NULL) {
+		if (!s) {
 			if (*index == IPSET_INVALID_ID)
 				*index = i;
 		} else if (STRNCMP(name, s->name)) {
@@ -827,18 +818,18 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	struct ip_set_net *inst = ip_set_pernet(net);
 	struct ip_set *set, *clash = NULL;
 	ip_set_id_t index = IPSET_INVALID_ID;
-	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1] = {};
+	struct nlattr *tb[IPSET_ATTR_CREATE_MAX + 1] = {};
 	const char *name, *typename;
 	u8 family, revision;
 	u32 flags = flag_exist(nlh);
 	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_SETNAME] == NULL ||
-		     attr[IPSET_ATTR_TYPENAME] == NULL ||
-		     attr[IPSET_ATTR_REVISION] == NULL ||
-		     attr[IPSET_ATTR_FAMILY] == NULL ||
-		     (attr[IPSET_ATTR_DATA] != NULL &&
+		     !attr[IPSET_ATTR_SETNAME] ||
+		     !attr[IPSET_ATTR_TYPENAME] ||
+		     !attr[IPSET_ATTR_REVISION] ||
+		     !attr[IPSET_ATTR_FAMILY] ||
+		     (attr[IPSET_ATTR_DATA] &&
 		      !flag_nested(attr[IPSET_ATTR_DATA]))))
 		return -IPSET_ERR_PROTOCOL;
 
@@ -849,11 +840,10 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
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
@@ -861,21 +851,18 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
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
@@ -889,8 +876,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 
 	/* BTW, ret==0 here. */
 
-	/*
-	 * Here, we have a valid, constructed set and we are protected
+	/* Here, we have a valid, constructed set and we are protected
 	 * by the nfnl mutex. Find the first free index in ip_set_list
 	 * and check clashing.
 	 */
@@ -913,7 +899,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 			/* Wraparound */
 			goto cleanup;
 
-		list = kzalloc(sizeof(struct ip_set *) * i, GFP_KERNEL);
+		list = kcalloc(i, sizeof(struct ip_set *), GFP_KERNEL);
 		if (!list)
 			goto cleanup;
 		/* nfnl mutex is held, both lists are valid */
@@ -927,12 +913,11 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
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
 
@@ -994,7 +979,7 @@ ip_set_destroy(struct sock *ctnl, struct sk_buff *skb,
 	if (!attr[IPSET_ATTR_SETNAME]) {
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
-			if (s != NULL && s->ref) {
+			if (s && s->ref) {
 				ret = -IPSET_ERR_BUSY;
 				goto out;
 			}
@@ -1003,7 +988,7 @@ ip_set_destroy(struct sock *ctnl, struct sk_buff *skb,
 		read_unlock_bh(&ip_set_ref_lock);
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
-			if (s != NULL) {
+			if (s) {
 				ip_set(inst, i) = NULL;
 				ip_set_destroy_set(s);
 			}
@@ -1013,7 +998,7 @@ ip_set_destroy(struct sock *ctnl, struct sk_buff *skb,
 	} else {
 		s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
 				    &i);
-		if (s == NULL) {
+		if (!s) {
 			ret = -ENOENT;
 			goto out;
 		} else if (s->ref) {
@@ -1058,12 +1043,12 @@ ip_set_flush(struct sock *ctnl, struct sk_buff *skb,
 	if (!attr[IPSET_ATTR_SETNAME]) {
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
-			if (s != NULL)
+			if (s)
 				ip_set_flush_set(s);
 		}
 	} else {
 		s = find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-		if (s == NULL)
+		if (!s)
 			return -ENOENT;
 
 		ip_set_flush_set(s);
@@ -1095,12 +1080,12 @@ ip_set_rename(struct sock *ctnl, struct sk_buff *skb,
 	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_SETNAME] == NULL ||
-		     attr[IPSET_ATTR_SETNAME2] == NULL))
+		     !attr[IPSET_ATTR_SETNAME] ||
+		     !attr[IPSET_ATTR_SETNAME2]))
 		return -IPSET_ERR_PROTOCOL;
 
 	set = find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-	if (set == NULL)
+	if (!set)
 		return -ENOENT;
 
 	read_lock_bh(&ip_set_ref_lock);
@@ -1112,7 +1097,7 @@ ip_set_rename(struct sock *ctnl, struct sk_buff *skb,
 	name2 = nla_data(attr[IPSET_ATTR_SETNAME2]);
 	for (i = 0; i < inst->ip_set_max; i++) {
 		s = ip_set(inst, i);
-		if (s != NULL && STRNCMP(s->name, name2)) {
+		if (s && STRNCMP(s->name, name2)) {
 			ret = -IPSET_ERR_EXIST_SETNAME2;
 			goto out;
 		}
@@ -1144,23 +1129,24 @@ ip_set_swap(struct sock *ctnl, struct sk_buff *skb,
 	char from_name[IPSET_MAXNAMELEN];
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_SETNAME] == NULL ||
-		     attr[IPSET_ATTR_SETNAME2] == NULL))
+		     !attr[IPSET_ATTR_SETNAME] ||
+		     !attr[IPSET_ATTR_SETNAME2]))
 		return -IPSET_ERR_PROTOCOL;
 
 	from = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
 			       &from_id);
-	if (from == NULL)
+	if (!from)
 		return -ENOENT;
 
 	to = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME2]),
 			     &to_id);
-	if (to == NULL)
+	if (!to)
 		return -IPSET_ERR_EXIST_SETNAME2;
 
 	/* Features must not change.
-	 * Not an artificial restriction anymore, as we must prevent
-	 * possible loops created by swapping in setlist type of sets. */
+	 * Not an artifical restriction anymore, as we must prevent
+	 * possible loops created by swapping in setlist type of sets.
+	 */
 	if (!(from->type->features == to->type->features &&
 	      from->family == to->family))
 		return -IPSET_ERR_TYPE_MISMATCH;
@@ -1194,7 +1180,7 @@ ip_set_dump_done(struct netlink_callback *cb)
 	if (cb->args[IPSET_CB_ARG0]) {
 		struct ip_set_net *inst =
 			(struct ip_set_net *)cb->args[IPSET_CB_NET];
-		ip_set_id_t index = (ip_set_id_t) cb->args[IPSET_CB_INDEX];
+		ip_set_id_t index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
 		struct ip_set *set = ip_set(inst, index);
 
 		if (set->variant->uref)
@@ -1222,7 +1208,7 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(cb->skb);
 	int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
-	struct nlattr *cda[IPSET_ATTR_CMD_MAX+1];
+	struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 	struct nlattr *attr = (void *)nlh + min_len;
 	u32 dump_type;
 	ip_set_id_t index;
@@ -1236,16 +1222,18 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 
 		set = find_set_and_id(inst, nla_data(cda[IPSET_ATTR_SETNAME]),
 				      &index);
-		if (set == NULL)
+		if (!set)
 			return -ENOENT;
 
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
@@ -1271,7 +1259,8 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 		if (ret < 0) {
 			nlh = nlmsg_hdr(cb->skb);
 			/* We have to create and send the error message
-			 * manually :-( */
+			 * manually :-(
+			 */
 			if (nlh->nlmsg_flags & NLM_F_ACK)
 				netlink_ack(cb->skb, nlh, ret);
 			return ret;
@@ -1289,11 +1278,11 @@ dump_last:
 	pr_debug("dump type, flag: %u %u index: %ld\n",
 		 dump_type, dump_flags, cb->args[IPSET_CB_INDEX]);
 	for (; cb->args[IPSET_CB_INDEX] < max; cb->args[IPSET_CB_INDEX]++) {
-		index = (ip_set_id_t) cb->args[IPSET_CB_INDEX];
+		index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
 		write_lock_bh(&ip_set_ref_lock);
 		set = ip_set(inst, index);
 		is_destroyed = inst->is_destroyed;
-		if (set == NULL || is_destroyed) {
+		if (!set || is_destroyed) {
 			write_unlock_bh(&ip_set_ref_lock);
 			if (dump_type == DUMP_ONE) {
 				ret = -ENOENT;
@@ -1456,12 +1445,12 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		size_t payload = min(SIZE_MAX,
 				     sizeof(*errmsg) + nlmsg_len(nlh));
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
-		struct nlattr *cda[IPSET_ATTR_CMD_MAX+1];
+		struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 		struct nlattr *cmdattr;
 		u32 *errline;
 
 		skb2 = nlmsg_new(payload, GFP_KERNEL);
-		if (skb2 == NULL)
+		if (!skb2)
 			return -ENOMEM;
 		rep = __nlmsg_put(skb2, NETLINK_CB(skb).portid,
 				  nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
@@ -1478,7 +1467,8 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 
 		*errline = lineno;
 
-		netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+		netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid,
+				MSG_DONTWAIT);
 		/* Signal netlink not to send its ACK/errmsg.  */
 		return -EINTR;
 	}
@@ -1493,25 +1483,25 @@ ip_set_uadd(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct ip_set_net *inst = ip_set_pernet(sock_net(ctnl));
 	struct ip_set *set;
-	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1] = {};
+	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
 	const struct nlattr *nla;
 	u32 flags = flag_exist(nlh);
 	bool use_lineno;
 	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_SETNAME] == NULL ||
+		     !attr[IPSET_ATTR_SETNAME] ||
 		     !((attr[IPSET_ATTR_DATA] != NULL) ^
 		       (attr[IPSET_ATTR_ADT] != NULL)) ||
-		     (attr[IPSET_ATTR_DATA] != NULL &&
+		     (attr[IPSET_ATTR_DATA] &&
 		      !flag_nested(attr[IPSET_ATTR_DATA])) ||
-		     (attr[IPSET_ATTR_ADT] != NULL &&
+		     (attr[IPSET_ATTR_ADT] &&
 		      (!flag_nested(attr[IPSET_ATTR_ADT]) ||
-		       attr[IPSET_ATTR_LINENO] == NULL))))
+		       !attr[IPSET_ATTR_LINENO]))))
 		return -IPSET_ERR_PROTOCOL;
 
 	set = find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-	if (set == NULL)
+	if (!set)
 		return -ENOENT;
 
 	use_lineno = !!attr[IPSET_ATTR_LINENO];
@@ -1548,25 +1538,25 @@ ip_set_udel(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct ip_set_net *inst = ip_set_pernet(sock_net(ctnl));
 	struct ip_set *set;
-	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1] = {};
+	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
 	const struct nlattr *nla;
 	u32 flags = flag_exist(nlh);
 	bool use_lineno;
 	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_SETNAME] == NULL ||
+		     !attr[IPSET_ATTR_SETNAME] ||
 		     !((attr[IPSET_ATTR_DATA] != NULL) ^
 		       (attr[IPSET_ATTR_ADT] != NULL)) ||
-		     (attr[IPSET_ATTR_DATA] != NULL &&
+		     (attr[IPSET_ATTR_DATA] &&
 		      !flag_nested(attr[IPSET_ATTR_DATA])) ||
-		     (attr[IPSET_ATTR_ADT] != NULL &&
+		     (attr[IPSET_ATTR_ADT] &&
 		      (!flag_nested(attr[IPSET_ATTR_ADT]) ||
-		       attr[IPSET_ATTR_LINENO] == NULL))))
+		       !attr[IPSET_ATTR_LINENO]))))
 		return -IPSET_ERR_PROTOCOL;
 
 	set = find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-	if (set == NULL)
+	if (!set)
 		return -ENOENT;
 
 	use_lineno = !!attr[IPSET_ATTR_LINENO];
@@ -1603,17 +1593,17 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct ip_set_net *inst = ip_set_pernet(sock_net(ctnl));
 	struct ip_set *set;
-	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1] = {};
+	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
 	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_SETNAME] == NULL ||
-		     attr[IPSET_ATTR_DATA] == NULL ||
+		     !attr[IPSET_ATTR_SETNAME] ||
+		     !attr[IPSET_ATTR_DATA] ||
 		     !flag_nested(attr[IPSET_ATTR_DATA])))
 		return -IPSET_ERR_PROTOCOL;
 
 	set = find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-	if (set == NULL)
+	if (!set)
 		return -ENOENT;
 
 	if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA],
@@ -1644,15 +1634,15 @@ ip_set_header(struct sock *ctnl, struct sk_buff *skb,
 	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_SETNAME] == NULL))
+		     !attr[IPSET_ATTR_SETNAME]))
 		return -IPSET_ERR_PROTOCOL;
 
 	set = find_set(inst, nla_data(attr[IPSET_ATTR_SETNAME]));
-	if (set == NULL)
+	if (!set)
 		return -ENOENT;
 
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL)
+	if (!skb2)
 		return -ENOMEM;
 
 	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
@@ -1701,8 +1691,8 @@ ip_set_type(struct sock *ctnl, struct sk_buff *skb,
 	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
-		     attr[IPSET_ATTR_TYPENAME] == NULL ||
-		     attr[IPSET_ATTR_FAMILY] == NULL))
+		     !attr[IPSET_ATTR_TYPENAME] ||
+		     !attr[IPSET_ATTR_FAMILY]))
 		return -IPSET_ERR_PROTOCOL;
 
 	family = nla_get_u8(attr[IPSET_ATTR_FAMILY]);
@@ -1712,7 +1702,7 @@ ip_set_type(struct sock *ctnl, struct sk_buff *skb,
 		return ret;
 
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL)
+	if (!skb2)
 		return -ENOMEM;
 
 	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
@@ -1757,11 +1747,11 @@ ip_set_protocol(struct sock *ctnl, struct sk_buff *skb,
 	struct nlmsghdr *nlh2;
 	int ret = 0;
 
-	if (unlikely(attr[IPSET_ATTR_PROTOCOL] == NULL))
+	if (unlikely(!attr[IPSET_ATTR_PROTOCOL]))
 		return -IPSET_ERR_PROTOCOL;
 
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL)
+	if (!skb2)
 		return -ENOMEM;
 
 	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
@@ -1889,7 +1879,7 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 		ret = -EFAULT;
 		goto done;
 	}
-	op = (unsigned int *) data;
+	op = (unsigned int *)data;
 
 	if (*op < IP_SET_OP_VERSION) {
 		/* Check the version at the beginning of operations */
@@ -2001,7 +1991,7 @@ ip_set_net_init(struct net *net)
 	if (inst->ip_set_max >= IPSET_INVALID_ID)
 		inst->ip_set_max = IPSET_INVALID_ID - 1;
 
-	list = kzalloc(sizeof(struct ip_set *) * inst->ip_set_max, GFP_KERNEL);
+	list = kcalloc(inst->ip_set_max, sizeof(struct ip_set *), GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
 	inst->is_deleted = false;
@@ -2022,7 +2012,7 @@ ip_set_net_exit(struct net *net)
 
 	for (i = 0; i < inst->ip_set_max; i++) {
 		set = ip_set(inst, i);
-		if (set != NULL) {
+		if (set) {
 			ip_set(inst, i) = NULL;
 			ip_set_destroy_set(set);
 		}
@@ -2037,11 +2027,11 @@ static struct pernet_operations ip_set_net_ops = {
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
index 1981f02..42c3e3b 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -30,7 +30,7 @@ get_port(const struct sk_buff *skb, int protocol, unsigned int protooff,
 		const struct tcphdr *th;
 
 		th = skb_header_pointer(skb, protooff, sizeof(_tcph), &_tcph);
-		if (th == NULL)
+		if (!th)
 			/* No choice either */
 			return false;
 
@@ -42,7 +42,7 @@ get_port(const struct sk_buff *skb, int protocol, unsigned int protooff,
 		const sctp_sctphdr_t *sh;
 
 		sh = skb_header_pointer(skb, protooff, sizeof(_sh), &_sh);
-		if (sh == NULL)
+		if (!sh)
 			/* No choice either */
 			return false;
 
@@ -55,7 +55,7 @@ get_port(const struct sk_buff *skb, int protocol, unsigned int protooff,
 		const struct udphdr *uh;
 
 		uh = skb_header_pointer(skb, protooff, sizeof(_udph), &_udph);
-		if (uh == NULL)
+		if (!uh)
 			/* No choice either */
 			return false;
 
@@ -67,7 +67,7 @@ get_port(const struct sk_buff *skb, int protocol, unsigned int protooff,
 		const struct icmphdr *ic;
 
 		ic = skb_header_pointer(skb, protooff, sizeof(_ich), &_ich);
-		if (ic == NULL)
+		if (!ic)
 			return false;
 
 		*port = (__force __be16)htons((ic->type << 8) | ic->code);
@@ -78,7 +78,7 @@ get_port(const struct sk_buff *skb, int protocol, unsigned int protooff,
 		const struct icmp6hdr *ic;
 
 		ic = skb_header_pointer(skb, protooff, sizeof(_ich), &_ich);
-		if (ic == NULL)
+		if (!ic)
 			return false;
 
 		*port = (__force __be16)
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
index 453849e..878d35f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -35,7 +35,7 @@
 /* Number of elements to store in an initial array block */
 #define AHASH_INIT_SIZE			4
 /* Max number of elements to store in an array block */
-#define AHASH_MAX_SIZE			(3*AHASH_INIT_SIZE)
+#define AHASH_MAX_SIZE			(3 * AHASH_INIT_SIZE)
 /* Max muber of elements in the array block when tuned */
 #define AHASH_MAX_TUNED			64
 
@@ -57,6 +57,7 @@ tune_ahash_max(u8 curr, u32 multi)
 	 */
 	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
 }
+
 #define TUNE_AHASH_MAX(h, multi)	\
 	((h)->ahash_max = tune_ahash_max((h)->ahash_max, multi))
 #else
@@ -79,7 +80,7 @@ struct htable {
 	atomic_t ref;		/* References for resizing */
 	atomic_t uref;		/* References for dumping */
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
-	struct hbucket __rcu * bucket[0]; /* hashtable buckets */
+	struct hbucket __rcu *bucket[0]; /* hashtable buckets */
 };
 
 #define hbucket(h, i)		((h)->bucket[i])
@@ -104,7 +105,7 @@ htable_size(u8 hbits)
 	if (hbits > 31)
 		return 0;
 	hsize = jhash_size(hbits);
-	if ((((size_t)-1) - sizeof(struct htable))/sizeof(struct hbucket *)
+	if ((((size_t)-1) - sizeof(struct htable)) / sizeof(struct hbucket *)
 	    < hsize)
 		return 0;
 
@@ -256,7 +257,7 @@ htable_bits(u32 hashsize)
 #endif
 
 #define HKEY(data, initval, htable_bits)			\
-(jhash2((u32 *)(data), HKEY_DATALEN/sizeof(u32), initval)	\
+(jhash2((u32 *)(data), HKEY_DATALEN / sizeof(u32), initval)	\
 	& jhash_mask(htable_bits))
 
 #ifndef htype
@@ -299,11 +300,11 @@ mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 
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
@@ -322,15 +323,15 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
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
@@ -349,7 +350,7 @@ mtype_ahash_memsize(const struct htype *h, const struct htable *t,
 #endif
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = rcu_dereference_bh(hbucket(t, i));
-		if (n == NULL)
+		if (!n)
 			continue;
 		memsize += sizeof(struct hbucket) + n->size * dsize;
 	}
@@ -383,7 +384,7 @@ mtype_flush(struct ip_set *set)
 	t = ipset_dereference_protected(h->table, set);
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = __ipset_dereference_protected(hbucket(t, i), 1);
-		if (n == NULL)
+		if (!n)
 			continue;
 		if (set->extensions & IPSET_EXT_DESTROY)
 			mtype_ext_cleanup(set, n);
@@ -406,7 +407,7 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = __ipset_dereference_protected(hbucket(t, i), 1);
-		if (n == NULL)
+		if (!n)
 			continue;
 		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
 			mtype_ext_cleanup(set, n);
@@ -427,7 +428,7 @@ mtype_destroy(struct ip_set *set)
 		del_timer_sync(&h->gc);
 
 	mtype_ahash_destroy(set,
-		__ipset_dereference_protected(h->table, 1), true);
+			    __ipset_dereference_protected(h->table, 1), true);
 	kfree(h);
 
 	set->data = NULL;
@@ -439,7 +440,7 @@ mtype_gc_init(struct ip_set *set, void (*gc)(unsigned long ul_set))
 	struct htype *h = set->data;
 
 	init_timer(&h->gc);
-	h->gc.data = (unsigned long) set;
+	h->gc.data = (unsigned long)set;
 	h->gc.function = gc;
 	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
 	add_timer(&h->gc);
@@ -480,7 +481,7 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 	t = ipset_dereference_protected(h->table, set);
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = __ipset_dereference_protected(hbucket(t, i), 1);
-		if (n == NULL)
+		if (!n)
 			continue;
 		for (j = 0, d = 0; j < n->pos; j++) {
 			if (!test_bit(j, n->used)) {
@@ -505,7 +506,7 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 			}
 		}
 		if (d >= AHASH_INIT_SIZE) {
-			struct hbucket *tmp = kzalloc(sizeof(struct hbucket) +
+			struct hbucket *tmp = kzalloc(sizeof(*tmp) +
 					(n->size - AHASH_INIT_SIZE) * dsize,
 					GFP_ATOMIC);
 			if (!tmp)
@@ -530,7 +531,7 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 static void
 mtype_gc(unsigned long ul_set)
 {
-	struct ip_set *set = (struct ip_set *) ul_set;
+	struct ip_set *set = (struct ip_set *)ul_set;
 	struct htype *h = set->data;
 
 	pr_debug("called\n");
@@ -544,7 +545,8 @@ mtype_gc(unsigned long ul_set)
 
 /* Resize a hash: create a new hash table with doubling the hashsize
  * and inserting the elements to it. Repeat until we succeed or
- * fail due to memory pressures. */
+ * fail due to memory pressures.
+ */
 static int
 mtype_resize(struct ip_set *set, bool retried)
 {
@@ -597,7 +599,7 @@ retry:
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (i = 0; i < jhash_size(orig->htable_bits); i++) {
 		n = __ipset_dereference_protected(hbucket(orig, i), 1);
-		if (n == NULL)
+		if (!n)
 			continue;
 		for (j = 0; j < n->pos; j++) {
 			if (!test_bit(j, n->used))
@@ -615,7 +617,7 @@ retry:
 			key = HKEY(data, h->initval, htable_bits);
 			m = __ipset_dereference_protected(hbucket(t, key), 1);
 			if (!m) {
-				m = kzalloc(sizeof(struct hbucket) +
+				m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
 					    GFP_ATOMIC);
 				if (!m)
@@ -625,10 +627,10 @@ retry:
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
@@ -679,11 +681,11 @@ out:
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
@@ -709,19 +711,19 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	t = ipset_dereference_protected(h->table, set);
 	key = HKEY(value, h->initval, t->htable_bits);
 	n = __ipset_dereference_protected(hbucket(t, key), 1);
-	if (n == NULL) {
+	if (!n) {
 		if (forceadd) {
 			if (net_ratelimit())
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
-		if (n == NULL)
+		if (!n)
 			return -ENOMEM;
 		n->size = AHASH_INIT_SIZE;
 		goto copy_elem;
@@ -743,8 +745,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -779,7 +781,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			return -EAGAIN;
 		}
 		old = n;
-		n = kzalloc(sizeof(struct hbucket) +
+		n = kzalloc(sizeof(*n) +
 			    (old->size + AHASH_INIT_SIZE) * set->dsize,
 			    GFP_ATOMIC);
 		if (!n)
@@ -882,7 +884,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
 		} else if (k >= AHASH_INIT_SIZE) {
-			struct hbucket *tmp = kzalloc(sizeof(struct hbucket) +
+			struct hbucket *tmp = kzalloc(sizeof(*tmp) +
 					(n->size - AHASH_INIT_SIZE) * dsize,
 					GFP_ATOMIC);
 			if (!tmp)
@@ -922,7 +924,8 @@ mtype_data_match(struct mtype_elem *data, const struct ip_set_ext *ext,
 
 #ifdef IP_SET_HASH_WITH_NETS
 /* Special test function which takes into account the different network
- * sizes added to the set */
+ * sizes added to the set
+ */
 static int
 mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		 const struct ip_set_ext *ext,
@@ -955,7 +958,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 #endif
 		key = HKEY(d, h->initval, t->htable_bits);
 		n =  rcu_dereference_bh(hbucket(t, key));
-		if (n == NULL)
+		if (!n)
 			continue;
 		for (i = 0; i < n->pos; i++) {
 			if (!test_bit(i, n->used))
@@ -1000,7 +1003,8 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	t = rcu_dereference_bh(h->table);
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
-	 * try all possible network sizes */
+	 * try all possible network sizes
+	 */
 	for (i = 0; i < IPSET_NET_COUNT; i++)
 		if (DCIDR_GET(d->cidr, i) != SET_HOST_MASK(set->family))
 			break;
@@ -1012,7 +1016,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	key = HKEY(d, h->initval, t->htable_bits);
 	n = rcu_dereference_bh(hbucket(t, key));
-	if (n == NULL) {
+	if (!n) {
 		ret = 0;
 		goto out;
 	}
@@ -1086,10 +1090,10 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 		rcu_read_lock_bh();
 		t = rcu_dereference_bh_nfnl(h->table);
 		atomic_inc(&t->uref);
-		cb->args[IPSET_CB_PRIVATE] = (unsigned long) t;
+		cb->args[IPSET_CB_PRIVATE] = (unsigned long)t;
 		rcu_read_unlock_bh();
 	} else if (cb->args[IPSET_CB_PRIVATE]) {
-		t = (struct htable *) cb->args[IPSET_CB_PRIVATE];
+		t = (struct htable *)cb->args[IPSET_CB_PRIVATE];
 		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 			/* Resizing didn't destroy the hash table */
 			pr_debug("Table destroy by dump: %p\n", t);
@@ -1118,7 +1122,7 @@ mtype_list(const struct ip_set *set,
 		return -EMSGSIZE;
 
 	pr_debug("list hash set %s\n", set->name);
-	t = (const struct htable *) cb->args[IPSET_CB_PRIVATE];
+	t = (const struct htable *)cb->args[IPSET_CB_PRIVATE];
 	/* Expire may replace a hbucket with another one */
 	rcu_read_lock();
 	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
@@ -1127,7 +1131,7 @@ mtype_list(const struct ip_set *set,
 		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
 		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
 			 cb->args[IPSET_CB_ARG0], t, n);
-		if (n == NULL)
+		if (!n)
 			continue;
 		for (i = 0; i < n->pos; i++) {
 			if (!test_bit(i, n->used))
@@ -1144,8 +1148,8 @@ mtype_list(const struct ip_set *set,
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
@@ -1167,8 +1171,9 @@ nla_put_failure:
 			set->name);
 		cb->args[IPSET_CB_ARG0] = 0;
 		ret = -EMSGSIZE;
-	} else
+	} else {
 		ipset_nest_end(skb, atd);
+	}
 out:
 	rcu_read_unlock();
 	return ret;
@@ -1176,12 +1181,13 @@ out:
 
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
index 99ea053..9d6bf19 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -158,8 +158,8 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
@@ -249,6 +249,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 	if (unlikely(tb[IPSET_ATTR_CIDR])) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+
 		if (cidr != HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 6e0324d..a0695a2 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -155,8 +155,8 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 	}
 	return ret;
 }
@@ -206,7 +206,6 @@ hash_ipmark6_data_next(struct hash_ipmark4_elem *next,
 #define IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
-
 static int
 hash_ipmark6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		  const struct xt_action_param *par,
@@ -244,6 +243,7 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 	if (unlikely(tb[IPSET_ATTR_CIDR])) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+
 		if (cidr != HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
@@ -267,10 +267,8 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
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
index 7a83109..9d84b3d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -140,8 +140,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
@@ -187,8 +188,8 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-			else
-				ret = 0;
+
+			ret = 0;
 		}
 	}
 	return ret;
@@ -284,6 +285,7 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 	if (unlikely(tb[IPSET_ATTR_CIDR])) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+
 		if (cidr != HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
@@ -304,8 +306,9 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
 		e.port = 0;
@@ -328,8 +331,8 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
index 2d30bb0..215b7b9 100644
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
@@ -147,8 +147,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
@@ -194,8 +195,8 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-			else
-				ret = 0;
+
+			ret = 0;
 		}
 	}
 	return ret;
@@ -295,6 +296,7 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 	if (unlikely(tb[IPSET_ATTR_CIDR])) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+
 		if (cidr != HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
@@ -319,8 +321,9 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
 		e.port = 0;
@@ -343,8 +346,8 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
index 0252278..9ca7196 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -209,14 +209,16 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
@@ -263,8 +265,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip2_from, ip2_to);
 		if (ip2_from + UINT_MAX == ip2_to)
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr + 1);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip);
@@ -287,8 +290,8 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
-				else
-					ret = 0;
+
+				ret = 0;
 				ip2 = ip2_last + 1;
 			}
 		}
@@ -432,6 +435,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 	if (unlikely(tb[IPSET_ATTR_CIDR])) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+
 		if (cidr != HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
@@ -465,14 +469,16 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
@@ -496,8 +502,8 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
index 112aff3..f1e7d2c 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -89,10 +89,10 @@ hash_mac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		return 0;
 
 	if (skb_mac_header(skb) < skb->head ||
-	     (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
 
-	memcpy(e.ether, eth_hdr(skb)->h_source, ETH_ALEN);
+	ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	if (memcmp(e.ether, invalid_ether, ETH_ALEN) == 0)
 		return -EINVAL;
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -116,7 +116,7 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
-	memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
+	ether_addr_copy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]));
 	if (memcmp(e.ether, invalid_ether, ETH_ALEN) == 0)
 		return -IPSET_ERR_HASH_ELEM;
 
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index e49b1d0..3e4bffd 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -169,6 +169,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -176,7 +177,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
 		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
 		ret = adtfn(set, &e, &ext, &ext, flags);
-		return ip_set_enomatch(ret, flags, adt, set) ? -ret:
+		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
 	}
 
@@ -198,8 +199,8 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
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
@@ -339,6 +340,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 3e7f12a..ab88ced 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -42,7 +42,7 @@ MODULE_ALIAS("ip_set_hash:net,iface");
 #define IP_SET_HASH_WITH_MULTI
 #define IP_SET_HASH_WITH_NET0
 
-#define IFNAMCPY(a, b)	strlcpy(a, b, IFNAMSIZ)
+#define STRLCPY(a, b)	strlcpy(a, b, IFNAMSIZ)
 
 /* IPv4 variant */
 
@@ -182,11 +182,11 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 		if (!eiface)
 			return -EINVAL;
-		IFNAMCPY(e.iface, eiface);
+		STRLCPY(e.iface, eiface);
 		e.physdev = 1;
 #endif
 	} else {
-		IFNAMCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
+		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
 	}
 
 	if (strlen(e.iface) == 0)
@@ -230,6 +230,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
@@ -250,8 +251,9 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip);
@@ -262,8 +264,8 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
-		else
-			ret = 0;
+
+		ret = 0;
 		ip = last + 1;
 	}
 	return ret;
@@ -390,11 +392,11 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		if (!eiface)
 			return -EINVAL;
 
-		IFNAMCPY(e.iface, eiface);
+		STRLCPY(e.iface, eiface);
 		e.physdev = 1;
 #endif
 	} else {
-		IFNAMCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
+		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
 	}
 
 	if (strlen(e.iface) == 0)
@@ -405,7 +407,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
-		   enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface6_elem e = { .cidr = HOST_MASK, .elem = 1 };
@@ -442,6 +444,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index b5428be..3c862c0 100644
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
@@ -133,8 +133,8 @@ hash_netnet4_data_next(struct hash_netnet4_elem *next,
 
 static int
 hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
-	       const struct xt_action_param *par,
-	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		  const struct xt_action_param *par,
+		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -156,7 +156,7 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
-	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -199,6 +199,7 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -221,8 +222,9 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (unlikely(ip + UINT_MAX == ip_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr[0]);
+	}
 
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
@@ -233,8 +235,9 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip2_from, ip2_to);
 		if (unlikely(ip2_from + UINT_MAX == ip2_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip[0]);
@@ -251,8 +254,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
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
@@ -276,8 +279,8 @@ struct hash_netnet6_elem {
 
 static inline bool
 hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
-		     const struct hash_netnet6_elem *ip2,
-		     u32 *multi)
+			const struct hash_netnet6_elem *ip2,
+			u32 *multi)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
@@ -304,7 +307,7 @@ hash_netnet6_data_reset_flags(struct hash_netnet6_elem *elem, u8 *flags)
 
 static inline void
 hash_netnet6_data_reset_elem(struct hash_netnet6_elem *elem,
-			  struct hash_netnet6_elem *orig)
+			     struct hash_netnet6_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
@@ -323,7 +326,7 @@ hash_netnet6_data_netmask(struct hash_netnet6_elem *elem, u8 cidr, bool inner)
 
 static bool
 hash_netnet6_data_list(struct sk_buff *skb,
-		    const struct hash_netnet6_elem *data)
+		       const struct hash_netnet6_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
@@ -342,7 +345,7 @@ nla_put_failure:
 
 static inline void
 hash_netnet6_data_next(struct hash_netnet4_elem *next,
-		    const struct hash_netnet6_elem *d)
+		       const struct hash_netnet6_elem *d)
 {
 }
 
@@ -356,8 +359,8 @@ hash_netnet6_data_next(struct hash_netnet4_elem *next,
 
 static int
 hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
-	       const struct xt_action_param *par,
-	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		  const struct xt_action_param *par,
+		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -367,7 +370,7 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	e.cidr[0] = INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
 	if (adt == IPSET_TEST)
-		e.ccmp = (HOST_MASK << (sizeof(u8)*8)) | HOST_MASK;
+		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0].in6);
 	ip6addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip[1].in6);
@@ -379,7 +382,7 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
-	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netnet6_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
@@ -424,6 +427,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 27307d0..731813e 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -198,8 +198,9 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (e.proto == 0)
 			return -IPSET_ERR_INVALID_PROTO;
-	} else
+	} else {
 		return -IPSET_ERR_MISSING_PROTO;
+	}
 
 	if (!(with_ports || e.proto == IPPROTO_ICMP))
 		e.port = 0;
@@ -208,6 +209,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
@@ -233,8 +235,9 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip);
@@ -250,8 +253,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
-			else
-				ret = 0;
+
+			ret = 0;
 		}
 		ip = last + 1;
 	}
@@ -413,14 +416,16 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
@@ -444,8 +449,8 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
index 1e0e47a..0c68734 100644
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
@@ -144,8 +144,8 @@ hash_netportnet4_data_next(struct hash_netportnet4_elem *next,
 
 static int
 hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
-		     const struct xt_action_param *par,
-		     enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		      const struct xt_action_param *par,
+		      enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -171,7 +171,7 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
-		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -223,14 +223,16 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
@@ -254,8 +256,9 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip, ip_to);
 		if (unlikely(ip + UINT_MAX == ip_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr[0]);
+	}
 
 	port_to = port = ntohs(e.port);
 	if (tb[IPSET_ATTR_PORT_TO]) {
@@ -273,8 +276,9 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(ip2_from, ip2_to);
 		if (unlikely(ip2_from + UINT_MAX == ip2_to))
 			return -IPSET_ERR_HASH_RANGE;
-	} else
+	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
+	}
 
 	if (retried)
 		ip = ntohl(h->next.ip[0]);
@@ -296,8 +300,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
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
@@ -324,8 +328,8 @@ struct hash_netportnet6_elem {
 
 static inline bool
 hash_netportnet6_data_equal(const struct hash_netportnet6_elem *ip1,
-			   const struct hash_netportnet6_elem *ip2,
-			   u32 *multi)
+			    const struct hash_netportnet6_elem *ip2,
+			    u32 *multi)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
@@ -354,7 +358,7 @@ hash_netportnet6_data_reset_flags(struct hash_netportnet6_elem *elem, u8 *flags)
 
 static inline void
 hash_netportnet6_data_reset_elem(struct hash_netportnet6_elem *elem,
-				struct hash_netportnet6_elem *orig)
+				 struct hash_netportnet6_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
@@ -374,7 +378,7 @@ hash_netportnet6_data_netmask(struct hash_netportnet6_elem *elem,
 
 static bool
 hash_netportnet6_data_list(struct sk_buff *skb,
-			  const struct hash_netportnet6_elem *data)
+			   const struct hash_netportnet6_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
@@ -395,7 +399,7 @@ nla_put_failure:
 
 static inline void
 hash_netportnet6_data_next(struct hash_netportnet4_elem *next,
-			  const struct hash_netportnet6_elem *d)
+			   const struct hash_netportnet6_elem *d)
 {
 	next->port = d->port;
 }
@@ -410,8 +414,8 @@ hash_netportnet6_data_next(struct hash_netportnet4_elem *next,
 
 static int
 hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
-		     const struct xt_action_param *par,
-		     enum ipset_adt adt, struct ip_set_adt_opt *opt)
+		      const struct xt_action_param *par,
+		      enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -437,7 +441,7 @@ hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 static int
 hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
-		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
@@ -493,14 +497,16 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
@@ -524,8 +530,8 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
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
index 76a1c5f..a1fe537 100644
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
-			ret = prev != NULL && prev->id == d->refid;
+		} else {
+			ret = prev && prev->id == d->refid;
+		}
 		return ret;
 	}
 	return 0;
@@ -291,7 +292,7 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			n = list_prev_entry(prev, list);
 	}
 	/* Can we replace a timed out entry? */
-	if (n != NULL &&
+	if (n &&
 	    !(SET_WITH_TIMEOUT(set) &&
 	      ip_set_timeout_expired(ext_timeout(n, set))))
 		n =  NULL;
@@ -337,7 +338,7 @@ list_set_udel(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			    next->id != d->refid)
 				return -IPSET_ERR_REF_EXIST;
 		} else if (d->before < 0) {
-			if (prev == NULL || prev->id != d->refid)
+			if (!prev || prev->id != d->refid)
 				return -IPSET_ERR_REF_EXIST;
 		}
 		list_set_del(set, e);
@@ -558,7 +559,7 @@ static const struct ip_set_type_variant set_variant = {
 static void
 list_set_gc(unsigned long ul_set)
 {
-	struct ip_set *set = (struct ip_set *) ul_set;
+	struct ip_set *set = (struct ip_set *)ul_set;
 	struct list_set *map = set->data;
 
 	spin_lock_bh(&set->lock);
@@ -575,7 +576,7 @@ list_set_gc_init(struct ip_set *set, void (*gc)(unsigned long ul_set))
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
index 8904598..b4eb4a3 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -9,7 +9,8 @@
  */
 
 /* Kernel module which implements the set match and SET target
- * for netfilter/iptables. */
+ * for netfilter/iptables.
+ */
 
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -52,6 +53,7 @@ static bool
 set_match_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v0 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.u.compat.dim,
 		info->match_set.u.compat.flags, 0, UINT_MAX);
 
@@ -68,10 +70,10 @@ compat_flags(struct xt_set_info_v0 *info)
 	info->u.compat.dim = IPSET_DIM_ZERO;
 	if (info->u.flags[0] & IPSET_MATCH_INV)
 		info->u.compat.flags |= IPSET_INV_MATCH;
-	for (i = 0; i < IPSET_DIM_MAX-1 && info->u.flags[i]; i++) {
+	for (i = 0; i < IPSET_DIM_MAX - 1 && info->u.flags[i]; i++) {
 		info->u.compat.dim++;
 		if (info->u.flags[i] & IPSET_SRC)
-			info->u.compat.flags |= (1<<info->u.compat.dim);
+			info->u.compat.flags |= (1 << info->u.compat.dim);
 	}
 }
 
@@ -88,7 +90,7 @@ set_match_v0_checkentry(const struct xt_mtchk_param *par)
 			info->match_set.index);
 		return -ENOENT;
 	}
-	if (info->match_set.u.flags[IPSET_DIM_MAX-1] != 0) {
+	if (info->match_set.u.flags[IPSET_DIM_MAX - 1] != 0) {
 		pr_warn("Protocol error: set match dimension is over the limit!\n");
 		ip_set_nfnl_put(par->net, info->match_set.index);
 		return -ERANGE;
@@ -114,6 +116,7 @@ static bool
 set_match_v1(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v1 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.dim,
 		info->match_set.flags, 0, UINT_MAX);
 
@@ -178,6 +181,7 @@ static bool
 set_match_v3(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v3 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.dim,
 		info->match_set.flags, info->flags, UINT_MAX);
 	int ret;
@@ -224,6 +228,7 @@ static bool
 set_match_v4(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v4 *info = par->matchinfo;
+
 	ADT_OPT(opt, par->family, info->match_set.dim,
 		info->match_set.flags, info->flags, UINT_MAX);
 	int ret;
@@ -252,6 +257,7 @@ static unsigned int
 set_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v0 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.u.compat.dim,
 		info->add_set.u.compat.flags, 0, UINT_MAX);
 	ADT_OPT(del_opt, par->family, info->del_set.u.compat.dim,
@@ -290,8 +296,8 @@ set_target_v0_checkentry(const struct xt_tgchk_param *par)
 			return -ENOENT;
 		}
 	}
-	if (info->add_set.u.flags[IPSET_DIM_MAX-1] != 0 ||
-	    info->del_set.u.flags[IPSET_DIM_MAX-1] != 0) {
+	if (info->add_set.u.flags[IPSET_DIM_MAX - 1] != 0 ||
+	    info->del_set.u.flags[IPSET_DIM_MAX - 1] != 0) {
 		pr_warn("Protocol error: SET target dimension is over the limit!\n");
 		if (info->add_set.index != IPSET_INVALID_ID)
 			ip_set_nfnl_put(par->net, info->add_set.index);
@@ -324,6 +330,7 @@ static unsigned int
 set_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v1 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, 0, UINT_MAX);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
@@ -392,6 +399,7 @@ static unsigned int
 set_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v2 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, info->flags, info->timeout);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
@@ -399,8 +407,8 @@ set_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 
 	/* Normalize to fit into jiffies */
 	if (add_opt.ext.timeout != IPSET_NO_TIMEOUT &&
-	    add_opt.ext.timeout > UINT_MAX/MSEC_PER_SEC)
-		add_opt.ext.timeout = UINT_MAX/MSEC_PER_SEC;
+	    add_opt.ext.timeout > UINT_MAX / MSEC_PER_SEC)
+		add_opt.ext.timeout = UINT_MAX / MSEC_PER_SEC;
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
 	if (info->del_set.index != IPSET_INVALID_ID)
@@ -418,6 +426,7 @@ static unsigned int
 set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_set_info_target_v3 *info = par->targinfo;
+
 	ADT_OPT(add_opt, par->family, info->add_set.dim,
 		info->add_set.flags, info->flags, info->timeout);
 	ADT_OPT(del_opt, par->family, info->del_set.dim,
@@ -429,8 +438,8 @@ set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 
 	/* Normalize to fit into jiffies */
 	if (add_opt.ext.timeout != IPSET_NO_TIMEOUT &&
-	    add_opt.ext.timeout > UINT_MAX/MSEC_PER_SEC)
-		add_opt.ext.timeout = UINT_MAX/MSEC_PER_SEC;
+	    add_opt.ext.timeout > UINT_MAX / MSEC_PER_SEC)
+		add_opt.ext.timeout = UINT_MAX / MSEC_PER_SEC;
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
 	if (info->del_set.index != IPSET_INVALID_ID)
@@ -456,7 +465,6 @@ set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-
 static int
 set_target_v3_checkentry(const struct xt_tgchk_param *par)
 {
@@ -496,8 +504,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 		     !(par->hook_mask & (1 << NF_INET_FORWARD |
 					 1 << NF_INET_LOCAL_OUT |
 					 1 << NF_INET_POST_ROUTING))) {
-			pr_warn("mapping of prio or/and queue is allowed only"
-				"from OUTPUT/FORWARD/POSTROUTING chains\n");
+			pr_warn("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
 			return -EINVAL;
 		}
 		index = ip_set_nfnl_get_byindex(par->net,
@@ -518,8 +525,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 	if (info->add_set.dim > IPSET_DIM_MAX ||
 	    info->del_set.dim > IPSET_DIM_MAX ||
 	    info->map_set.dim > IPSET_DIM_MAX) {
-		pr_warn("Protocol error: SET target dimension "
-			"is over the limit!\n");
+		pr_warn("Protocol error: SET target dimension is over the limit!\n");
 		if (info->add_set.index != IPSET_INVALID_ID)
 			ip_set_nfnl_put(par->net, info->add_set.index);
 		if (info->del_set.index != IPSET_INVALID_ID)
@@ -545,7 +551,6 @@ set_target_v3_destroy(const struct xt_tgdtor_param *par)
 		ip_set_nfnl_put(par->net, info->map_set.index);
 }
 
-
 static struct xt_match set_matches[] __read_mostly = {
 	{
 		.name		= "set",
-- 
1.8.5.1

