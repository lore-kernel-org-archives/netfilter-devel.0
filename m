From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] ipset: use NFPROTO_ constants
Date: Thu, 25 Aug 2011 11:20:56 +0200
Message-ID: <1314264057-5681-2-git-send-email-jengelh@medozas.de>
References: <1314264057-5681-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45206 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1HYJVB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:21:01 -0400
In-Reply-To: <1314264057-5681-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipset is actually using NFPROTO values rather than AF (xt_set passes
that along).
---
 include/libipset/nfproto.h                         |   19 +++++++
 include/libipset/types.h                           |   15 +++--
 kernel/include/linux/netfilter/ipset/ip_set.h      |    5 ++-
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |    4 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |    4 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |    4 +-
 kernel/net/netfilter/ipset/ip_set_core.c           |   16 +++---
 kernel/net/netfilter/ipset/ip_set_getport.c        |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |   18 +++---
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |   10 ++--
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |   10 ++--
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |   12 ++--
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |   12 ++--
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |   12 ++--
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |   12 ++--
 kernel/net/netfilter/ipset/ip_set_list_set.c       |    2 +-
 lib/data.c                                         |   21 ++++----
 lib/debug.c                                        |    4 +-
 lib/parse.c                                        |   52 ++++++++++----------
 lib/print.c                                        |   20 ++++----
 lib/session.c                                      |   34 ++++++------
 lib/types.c                                        |   26 +++++-----
 src/ipset.c                                        |   10 ++--
 src/ipset_bitmap_ip.c                              |    2 +-
 src/ipset_bitmap_ipmac.c                           |    2 +-
 src/ipset_bitmap_port.c                            |    2 +-
 src/ipset_hash_ip.c                                |    2 +-
 src/ipset_hash_ipport.c                            |    2 +-
 src/ipset_hash_ipportip.c                          |    2 +-
 src/ipset_hash_ipportnet.c                         |    4 +-
 src/ipset_hash_net.c                               |    4 +-
 src/ipset_hash_netiface.c                          |    2 +-
 src/ipset_hash_netport.c                           |    4 +-
 src/ipset_list_set.c                               |    2 +-
 34 files changed, 189 insertions(+), 165 deletions(-)
 create mode 100644 include/libipset/nfproto.h

diff --git a/include/libipset/nfproto.h b/include/libipset/nfproto.h
new file mode 100644
index 0000000..800da11
--- /dev/null
+++ b/include/libipset/nfproto.h
@@ -0,0 +1,19 @@
+#ifndef LIBIPSET_NFPROTO_H
+#define LIBIPSET_NFPROTO_H
+
+/*
+ * The constants to select, same as in linux/netfilter.h.
+ * Like nf_inet_addr.h, this is just here so that we need not to rely on
+ * the presence of a recent-enough netfilter.h.
+ */
+enum {
+	NFPROTO_UNSPEC =  0,
+	NFPROTO_IPV4   =  2,
+	NFPROTO_ARP    =  3,
+	NFPROTO_BRIDGE =  7,
+	NFPROTO_IPV6   = 10,
+	NFPROTO_DECNET = 12,
+	NFPROTO_NUMPROTO,
+};
+
+#endif /* LIBIPSET_NFPROTO_H */
diff --git a/include/libipset/types.h b/include/libipset/types.h
index d3a0b4c..edec2c9 100644
--- a/include/libipset/types.h
+++ b/include/libipset/types.h
@@ -14,15 +14,18 @@
 #include <libipset/parse.h>			/* ipset_parsefn */
 #include <libipset/print.h>			/* ipset_printfn */
 #include <libipset/linux_ip_set.h>		/* IPSET_MAXNAMELEN */
-
-#define AF_INET46		255
+#include <libipset/nfproto.h>			/* for NFPROTO_ */
 
 /* Family rules:
- * - AF_UNSPEC:	type is family-neutral
- * - AF_INET:	type supports IPv4 only
- * - AF_INET6:	type supports IPv6 only
- * - AF_INET46:	type supports both IPv4 and IPv6
+ * - NFPROTO_UNSPEC:	type is family-neutral
+ * - NFPROTO_IPV4:	type supports IPv4 only
+ * - NFPROTO_IPV6:	type supports IPv6 only
+ * Special (userspace) ipset-only extra value:
+ * - NFPROTO_X_IPV46:	type supports both IPv4 and IPv6
  */
+enum {
+	NFPROTO_X_IPV46 = 255,
+};
 
 /* Set dimensions */
 enum {
diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index 3540c6e..e7b06f5 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -288,7 +288,10 @@ struct ip_set_type {
 	u8 features;
 	/* Set type dimension */
 	u8 dimension;
-	/* Supported family: may be AF_UNSPEC for both AF_INET/AF_INET6 */
+	/*
+	 * Supported family: may be NFPROTO_UNSPEC for both
+	 * NFPROTO_IPV4/NFPROTO_IPV6.
+	 */
 	u8 family;
 	/* Type revisions */
 	u8 revision_min, revision_max;
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
index e3e7399..a72a4df 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -442,7 +442,7 @@ init_map_ip(struct ip_set *set, struct bitmap_ip *map,
 	map->timeout = IPSET_NO_TIMEOUT;
 
 	set->data = map;
-	set->family = AF_INET;
+	set->family = NFPROTO_IPV4;
 
 	return true;
 }
@@ -550,7 +550,7 @@ static struct ip_set_type bitmap_ip_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP,
 	.dimension	= IPSET_DIM_ONE,
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.revision_min	= 0,
 	.revision_max	= 0,
 	.create		= bitmap_ip_create,
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 56096f5..81324c1 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -543,7 +543,7 @@ init_map_ipmac(struct ip_set *set, struct bitmap_ipmac *map,
 	map->timeout = IPSET_NO_TIMEOUT;
 
 	set->data = map;
-	set->family = AF_INET;
+	set->family = NFPROTO_IPV4;
 
 	return true;
 }
@@ -623,7 +623,7 @@ static struct ip_set_type bitmap_ipmac_type = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_MAC,
 	.dimension	= IPSET_DIM_TWO,
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.revision_min	= 0,
 	.revision_max	= 0,
 	.create		= bitmap_ipmac_create,
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
index 29ba93b..382ec28 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -422,7 +422,7 @@ init_map_port(struct ip_set *set, struct bitmap_port *map,
 	map->timeout = IPSET_NO_TIMEOUT;
 
 	set->data = map;
-	set->family = AF_UNSPEC;
+	set->family = NFPROTO_UNSPEC;
 
 	return true;
 }
@@ -483,7 +483,7 @@ static struct ip_set_type bitmap_port_type = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_PORT,
 	.dimension	= IPSET_DIM_ONE,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	.revision_max	= 0,
 	.create		= bitmap_port_create,
diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
index cb4abbb..1a01628 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -70,7 +70,7 @@ find_set_type(const char *name, u8 family, u8 revision)
 
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
 		if (STREQ(type->name, name) &&
-		    (type->family == family || type->family == AF_UNSPEC) &&
+		    (type->family == family || type->family == NFPROTO_UNSPEC) &&
 		    revision >= type->revision_min &&
 		    revision <= type->revision_max)
 			return type;
@@ -135,7 +135,7 @@ find_set_type_minmax(const char *name, u8 family, u8 *min, u8 *max)
 	rcu_read_lock();
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
 		if (STREQ(type->name, name) &&
-		    (type->family == family || type->family == AF_UNSPEC)) {
+		    (type->family == family || type->family == NFPROTO_UNSPEC)) {
 			found = true;
 			if (type->revision_min < *min)
 				*min = type->revision_min;
@@ -149,8 +149,8 @@ find_set_type_minmax(const char *name, u8 family, u8 *min, u8 *max)
 	return try_to_load_type(name);
 }
 
-#define family_name(f)	((f) == AF_INET ? "inet" : \
-			 (f) == AF_INET6 ? "inet6" : "any")
+#define family_name(f)	((f) == NFPROTO_IPV4 ? "inet" : \
+			 (f) == NFPROTO_IPV6 ? "inet6" : "any")
 
 /* Register a set type structure. The type is identified by
  * the unique triple of name, family and revision.
@@ -344,7 +344,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family == set->family || set->family == AF_UNSPEC))
+	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return 0;
 
 	read_lock_bh(&set->lock);
@@ -377,7 +377,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family == set->family || set->family == AF_UNSPEC))
+	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return 0;
 
 	write_lock_bh(&set->lock);
@@ -400,7 +400,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family == set->family || set->family == AF_UNSPEC))
+	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return 0;
 
 	write_lock_bh(&set->lock);
@@ -565,7 +565,7 @@ start_msg(struct sk_buff *skb, u32 pid, u32 seq, unsigned int flags,
 		return NULL;
 
 	nfmsg = nlmsg_data(nlh);
-	nfmsg->nfgen_family = AF_INET;
+	nfmsg->nfgen_family = NFPROTO_IPV4;
 	nfmsg->version = NFNETLINK_V0;
 	nfmsg->res_id = 0;
 
diff --git a/kernel/net/netfilter/ipset/ip_set_getport.c b/kernel/net/netfilter/ipset/ip_set_getport.c
index 757143b..58ca4e1 100644
--- a/kernel/net/netfilter/ipset/ip_set_getport.c
+++ b/kernel/net/netfilter/ipset/ip_set_getport.c
@@ -133,10 +133,10 @@ ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
 	u8 proto;
 
 	switch (pf) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		ret = ip_set_get_ip4_port(skb, src, port, &proto);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		ret = ip_set_get_ip6_port(skb, src, port, &proto);
 		break;
 	default:
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index f2d576e..14a8628 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -366,11 +366,11 @@ hash_ip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u8 netmask, hbits;
 	struct ip_set_hash *h;
 
-	if (!(set->family == AF_INET || set->family == AF_INET6))
+	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
-	netmask = set->family == AF_INET ? 32 : 128;
+	netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
 	pr_debug("Create set %s with family %s\n",
-		 set->name, set->family == AF_INET ? "inet" : "inet6");
+		 set->name, set->family == NFPROTO_IPV4 ? "inet" : "inet6");
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_MAXELEM) ||
@@ -389,8 +389,8 @@ hash_ip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_NETMASK]) {
 		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
 
-		if ((set->family == AF_INET && netmask > 32) ||
-		    (set->family == AF_INET6 && netmask > 128) ||
+		if ((set->family == NFPROTO_IPV4 && netmask > 32) ||
+		    (set->family == NFPROTO_IPV6 && netmask > 128) ||
 		    netmask == 0)
 			return -IPSET_ERR_INVALID_NETMASK;
 	}
@@ -419,15 +419,15 @@ hash_ip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ip4_tvariant : &hash_ip6_tvariant;
 
-		if (set->family == AF_INET)
+		if (set->family == NFPROTO_IPV4)
 			hash_ip4_gc_init(set);
 		else
 			hash_ip6_gc_init(set);
 	} else {
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ip4_variant : &hash_ip6_variant;
 	}
 
@@ -443,7 +443,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP,
 	.dimension	= IPSET_DIM_ONE,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	.revision_max	= 0,
 	.create		= hash_ip_create,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 6ee10f5..30a6273 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -450,7 +450,7 @@ hash_ipport_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u8 hbits;
 
-	if (!(set->family == AF_INET || set->family == AF_INET6))
+	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
@@ -490,15 +490,15 @@ hash_ipport_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ipport4_tvariant : &hash_ipport6_tvariant;
 
-		if (set->family == AF_INET)
+		if (set->family == NFPROTO_IPV4)
 			hash_ipport4_gc_init(set);
 		else
 			hash_ipport6_gc_init(set);
 	} else {
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ipport4_variant : &hash_ipport6_variant;
 	}
 
@@ -514,7 +514,7 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT,
 	.dimension	= IPSET_DIM_TWO,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	.revision_max	= 1,	/* SCTP and UDPLITE support added */
 	.create		= hash_ipport_create,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index fb90e34..55de642 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -468,7 +468,7 @@ hash_ipportip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u8 hbits;
 
-	if (!(set->family == AF_INET || set->family == AF_INET6))
+	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
@@ -508,15 +508,15 @@ hash_ipportip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ipportip4_tvariant : &hash_ipportip6_tvariant;
 
-		if (set->family == AF_INET)
+		if (set->family == NFPROTO_IPV4)
 			hash_ipportip4_gc_init(set);
 		else
 			hash_ipportip6_gc_init(set);
 	} else {
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ipportip4_variant : &hash_ipportip6_variant;
 	}
 
@@ -532,7 +532,7 @@ static struct ip_set_type hash_ipportip_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT | IPSET_TYPE_IP2,
 	.dimension	= IPSET_DIM_THREE,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	.revision_max	= 1,	/* SCTP and UDPLITE support added */
 	.create		= hash_ipportip_create,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index deb3e3d..6ee4f72 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -554,7 +554,7 @@ hash_ipportnet_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u8 hbits;
 
-	if (!(set->family == AF_INET || set->family == AF_INET6))
+	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
@@ -573,7 +573,7 @@ hash_ipportnet_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 
 	h = kzalloc(sizeof(*h)
 		    + sizeof(struct ip_set_hash_nets)
-		      * (set->family == AF_INET ? 32 : 128), GFP_KERNEL);
+		      * (set->family == NFPROTO_IPV4 ? 32 : 128), GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
 
@@ -596,16 +596,16 @@ hash_ipportnet_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ipportnet4_tvariant
 			: &hash_ipportnet6_tvariant;
 
-		if (set->family == AF_INET)
+		if (set->family == NFPROTO_IPV4)
 			hash_ipportnet4_gc_init(set);
 		else
 			hash_ipportnet6_gc_init(set);
 	} else {
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_ipportnet4_variant : &hash_ipportnet6_variant;
 	}
 
@@ -621,7 +621,7 @@ static struct ip_set_type hash_ipportnet_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT | IPSET_TYPE_IP2,
 	.dimension	= IPSET_DIM_THREE,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	/*		  1	   SCTP and UDPLITE support added */
 	.revision_max	= 2,	/* Range as input support for IPv4 added */
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index 60d0165..48e35ba 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -406,7 +406,7 @@ hash_net_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	struct ip_set_hash *h;
 	u8 hbits;
 
-	if (!(set->family == AF_INET || set->family == AF_INET6))
+	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
@@ -425,7 +425,7 @@ hash_net_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 
 	h = kzalloc(sizeof(*h)
 		    + sizeof(struct ip_set_hash_nets)
-		      * (set->family == AF_INET ? 32 : 128), GFP_KERNEL);
+		      * (set->family == NFPROTO_IPV4 ? 32 : 128), GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
 
@@ -448,15 +448,15 @@ hash_net_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_net4_tvariant : &hash_net6_tvariant;
 
-		if (set->family == AF_INET)
+		if (set->family == NFPROTO_IPV4)
 			hash_net4_gc_init(set);
 		else
 			hash_net6_gc_init(set);
 	} else {
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_net4_variant : &hash_net6_variant;
 	}
 
@@ -472,7 +472,7 @@ static struct ip_set_type hash_net_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP,
 	.dimension	= IPSET_DIM_ONE,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	.revision_max	= 1,	/* Range as input support for IPv4 added */
 	.create		= hash_net_create,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index e13095d..a9fb4af 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -678,7 +678,7 @@ hash_netiface_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u8 hbits;
 
-	if (!(set->family == AF_INET || set->family == AF_INET6))
+	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
@@ -697,7 +697,7 @@ hash_netiface_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 
 	h = kzalloc(sizeof(*h)
 		    + sizeof(struct ip_set_hash_nets)
-		      * (set->family == AF_INET ? 32 : 128), GFP_KERNEL);
+		      * (set->family == NFPROTO_IPV4 ? 32 : 128), GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
 
@@ -722,15 +722,15 @@ hash_netiface_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_netiface4_tvariant : &hash_netiface6_tvariant;
 
-		if (set->family == AF_INET)
+		if (set->family == NFPROTO_IPV4)
 			hash_netiface4_gc_init(set);
 		else
 			hash_netiface6_gc_init(set);
 	} else {
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_netiface4_variant : &hash_netiface6_variant;
 	}
 
@@ -746,7 +746,7 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_IFACE,
 	.dimension	= IPSET_DIM_TWO,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	.create		= hash_netiface_create,
 	.create_policy	= {
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index 8f9de72..1fcc102 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -507,7 +507,7 @@ hash_netport_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u8 hbits;
 
-	if (!(set->family == AF_INET || set->family == AF_INET6))
+	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
@@ -526,7 +526,7 @@ hash_netport_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 
 	h = kzalloc(sizeof(*h)
 		    + sizeof(struct ip_set_hash_nets)
-		      * (set->family == AF_INET ? 32 : 128), GFP_KERNEL);
+		      * (set->family == NFPROTO_IPV4 ? 32 : 128), GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
 
@@ -549,15 +549,15 @@ hash_netport_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_netport4_tvariant : &hash_netport6_tvariant;
 
-		if (set->family == AF_INET)
+		if (set->family == NFPROTO_IPV4)
 			hash_netport4_gc_init(set);
 		else
 			hash_netport6_gc_init(set);
 	} else {
-		set->variant = set->family == AF_INET
+		set->variant = set->family == NFPROTO_IPV4
 			? &hash_netport4_variant : &hash_netport6_variant;
 	}
 
@@ -573,7 +573,7 @@ static struct ip_set_type hash_netport_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT,
 	.dimension	= IPSET_DIM_TWO,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	/*		  1	   SCTP and UDPLITE support added */
 	.revision_max	= 2,	/* Range as input support for IPv4 added */
diff --git a/kernel/net/netfilter/ipset/ip_set_list_set.c b/kernel/net/netfilter/ipset/ip_set_list_set.c
index 4d10819..7e095f9 100644
--- a/kernel/net/netfilter/ipset/ip_set_list_set.c
+++ b/kernel/net/netfilter/ipset/ip_set_list_set.c
@@ -575,7 +575,7 @@ static struct ip_set_type list_set_type __read_mostly = {
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_NAME | IPSET_DUMP_LAST,
 	.dimension	= IPSET_DIM_ONE,
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.revision_min	= 0,
 	.revision_max	= 0,
 	.create		= list_set_create,
diff --git a/lib/data.c b/lib/data.c
index dfae6aa..0210b7b 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -8,7 +8,6 @@
 #include <arpa/inet.h>				/* ntoh* */
 #include <net/ethernet.h>			/* ETH_ALEN */
 #include <net/if.h>				/* IFNAMSIZ */
-#include <sys/socket.h>				/* AF_ */
 #include <stdlib.h>				/* malloc, free */
 #include <string.h>				/* memset */
 
@@ -81,7 +80,7 @@ struct ipset_data {
 static void
 copy_addr(uint8_t family, union nf_inet_addr *ip, const void *value)
 {
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		in4cpy(&ip->in, value);
 	else
 		in6cpy(&ip->in6, value);
@@ -213,12 +212,12 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		break;
 	/* CADT options */
 	case IPSET_OPT_IP:
-		if (!(data->family == AF_INET || data->family == AF_INET6))
+		if (!(data->family == NFPROTO_IPV4 || data->family == NFPROTO_IPV6))
 			return -1;
 		copy_addr(data->family, &data->ip, value);
 		break;
 	case IPSET_OPT_IP_TO:
-		if (!(data->family == AF_INET || data->family == AF_INET6))
+		if (!(data->family == NFPROTO_IPV4 || data->family == NFPROTO_IPV6))
 			return -1;
 		copy_addr(data->family, &data->ip_to, value);
 		break;
@@ -288,12 +287,12 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		ipset_strlcpy(data->adt.nameref, value, IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_IP2:
-		if (!(data->family == AF_INET || data->family == AF_INET6))
+		if (!(data->family == NFPROTO_IPV4 || data->family == NFPROTO_IPV6))
 			return -1;
 		copy_addr(data->family, &data->adt.ip2, value);
 		break;
 	case IPSET_OPT_IP2_TO:
-		if (!(data->family == AF_INET || data->family == AF_INET6))
+		if (!(data->family == NFPROTO_IPV4 || data->family == NFPROTO_IPV6))
 			return -1;
 		copy_addr(data->family, &data->adt.ip2_to, value);
 		break;
@@ -456,7 +455,7 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_IP_TO:
 	case IPSET_OPT_IP2:
 	case IPSET_OPT_IP2_TO:
-		return family == AF_INET ? sizeof(uint32_t)
+		return family == NFPROTO_IPV4 ? sizeof(uint32_t)
 					 : sizeof(struct in6_addr);
 	case IPSET_OPT_PORT:
 	case IPSET_OPT_PORT_TO:
@@ -511,14 +510,14 @@ ipset_data_setname(const struct ipset_data *data)
  * @data: data blob
  *
  * Return the INET family supported by the set from the data blob.
- * If the family is not set yet, AF_UNSPEC is returned.
+ * If the family is not set yet, NFPROTO_UNSPEC is returned.
  */
 uint8_t
 ipset_data_family(const struct ipset_data *data)
 {
 	assert(data);
 	return ipset_data_test(data, IPSET_OPT_FAMILY)
-		? data->family : AF_UNSPEC;
+		? data->family : NFPROTO_UNSPEC;
 }
 
 /**
@@ -534,8 +533,8 @@ ipset_data_cidr(const struct ipset_data *data)
 {
 	assert(data);
 	return ipset_data_test(data, IPSET_OPT_CIDR) ? data->cidr :
-	       data->family == AF_INET ? 32 :
-	       data->family == AF_INET6 ? 128 : 0;
+	       data->family == NFPROTO_IPV4 ? 32 :
+	       data->family == NFPROTO_IPV6 ? 128 : 0;
 }
 
 /**
diff --git a/lib/debug.c b/lib/debug.c
index 931b0c1..486d910 100644
--- a/lib/debug.c
+++ b/lib/debug.c
@@ -116,14 +116,14 @@ debug_cadt_attrs(int max, const struct ipset_attr_policy *policy,
 				d = mnl_attr_get_payload(
 					ipattr[IPSET_ATTR_IPADDR_IPV4]);
 
-				inet_ntop(AF_INET, d, addr, INET6_ADDRSTRLEN);
+				inet_ntop(NFPROTO_IPV4, d, addr, INET6_ADDRSTRLEN);
 				fprintf(stderr, "\t\t%s: %s\n",
 					attr2name[i].name, addr);
 			} else if (ipattr[IPSET_ATTR_IPADDR_IPV6]) {
 				d = mnl_attr_get_payload(
 					ipattr[IPSET_ATTR_IPADDR_IPV6]);
 
-				inet_ntop(AF_INET6, d, addr, INET6_ADDRSTRLEN);
+				inet_ntop(NFPROTO_IPV6, d, addr, INET6_ADDRSTRLEN);
 				fprintf(stderr, "\t\t%s: %s\n",
 					attr2name[i].name, addr);
 			}
diff --git a/lib/parse.c b/lib/parse.c
index 2bb0601..b13b4d6 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -511,7 +511,7 @@ ipset_parse_proto_port(struct ipset_session *session,
 			tmp = a;
 			goto parse_port;
 		case IPPROTO_ICMP:
-			if (family != AF_INET) {
+			if (family != NFPROTO_IPV4) {
 				syntax_err("Protocol ICMP can be used "
 					   "with family INET only");
 				goto error;
@@ -519,7 +519,7 @@ ipset_parse_proto_port(struct ipset_session *session,
 			err = ipset_parse_icmp(session, opt, a);
 			break;
 		case IPPROTO_ICMPV6:
-			if (family != AF_INET6) {
+			if (family != NFPROTO_IPV6) {
 				syntax_err("Protocol ICMPv6 can be used "
 					   "with family INET6 only");
 				goto error;
@@ -577,11 +577,11 @@ ipset_parse_family(struct ipset_session *session,
 			   "multiple times");
 
 	if (STREQ(str, "inet") || STREQ(str, "ipv4") || STREQ(str, "-4"))
-		family = AF_INET;
+		family = NFPROTO_IPV4;
 	else if (STREQ(str, "inet6") || STREQ(str, "ipv6") || STREQ(str, "-6"))
-		family = AF_INET6;
+		family = NFPROTO_IPV6;
 	else if (STREQ(str, "any") || STREQ(str, "unspec"))
-		family = AF_UNSPEC;
+		family = NFPROTO_UNSPEC;
 	else
 		return syntax_err("unknown INET family %s", str);
 
@@ -610,7 +610,7 @@ call_getaddrinfo(struct ipset_session *session, const char *str,
 
 	if ((err = getaddrinfo(str, NULL, &hints, &res)) != 0) {
 		syntax_err("cannot resolve '%s' to an %s address: %s",
-			   str, family == AF_INET6 ? "IPv6" : "IPv4",
+			   str, family == NFPROTO_IPV6 ? "IPv6" : "IPv4",
 			   gai_strerror(err));
 		return NULL;
 	} else
@@ -625,13 +625,13 @@ get_addrinfo(struct ipset_session *session,
 	     uint8_t family)
 {
 	struct addrinfo *i;
-	size_t addrlen = family == AF_INET ? sizeof(struct sockaddr_in)
+	size_t addrlen = family == NFPROTO_IPV4 ? sizeof(struct sockaddr_in)
 					   : sizeof(struct sockaddr_in6);
 	int found, err = 0;
 
 	if ((*info = call_getaddrinfo(session, str, family)) == NULL) {
 		syntax_err("cannot parse %s: resolving to %s address failed",
-			   str, family == AF_INET ? "IPv4" : "IPv6");
+			   str, family == NFPROTO_IPV4 ? "IPv4" : "IPv6");
 		return EINVAL;
 	}
 
@@ -639,7 +639,7 @@ get_addrinfo(struct ipset_session *session,
 		if (i->ai_family != family || i->ai_addrlen != addrlen)
 			continue;
 		if (found == 0) {
-			if (family == AF_INET) {
+			if (family == NFPROTO_IPV4) {
 				/* Workaround: direct cast increases
 				 * required alignment on Sparc
 				 */
@@ -668,7 +668,7 @@ get_addrinfo(struct ipset_session *session,
 	if (found == 0)
 		return syntax_err("cannot parse %s: "
 				  "%s address could not be resolved",
-				  str, family == AF_INET ? "IPv4" : "IPv6");
+				  str, family == NFPROTO_IPV4 ? "IPv4" : "IPv6");
 	return err;
 }
 
@@ -677,7 +677,7 @@ parse_ipaddr(struct ipset_session *session,
 	     enum ipset_opt opt, const char *str,
 	     uint8_t family)
 {
-	uint8_t m = family == AF_INET ? 32 : 128;
+	uint8_t m = family == NFPROTO_IPV4 ? 32 : 128;
 	int aerr = EINVAL, err = 0, range = 0;
 	char *saved = strdup(str);
 	char *a, *tmp = saved;
@@ -737,7 +737,7 @@ cidr_hostaddr(const char *str, uint8_t family)
 {
 	char *a = cidr_separator(str);
 
-	return family == AF_INET ? STREQ(a, "/32") : STREQ(a, "/128");
+	return family == NFPROTO_IPV4 ? STREQ(a, "/32") : STREQ(a, "/128");
 }
 
 static int
@@ -747,8 +747,8 @@ parse_ip(struct ipset_session *session,
 	struct ipset_data *data = ipset_session_data(session);
 	uint8_t family = ipset_data_family(data);
 
-	if (family == AF_UNSPEC) {
-		family = AF_INET;
+	if (family == NFPROTO_UNSPEC) {
+		family = NFPROTO_IPV4;
 		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
 	}
 
@@ -985,12 +985,12 @@ ipset_parse_ip4_single6(struct ipset_session *session,
 	data = ipset_session_data(session);
 	family = ipset_data_family(data);
 
-	if (family == AF_UNSPEC) {
-		family = AF_INET;
+	if (family == NFPROTO_UNSPEC) {
+		family = NFPROTO_IPV4;
 		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
 	}
 
-	return family == AF_INET ? ipset_parse_ip(session, opt, str)
+	return family == NFPROTO_IPV4 ? ipset_parse_ip(session, opt, str)
 				 : ipset_parse_single_ip(session, opt, str);
 
 }
@@ -1025,12 +1025,12 @@ ipset_parse_ip4_net6(struct ipset_session *session,
 	data = ipset_session_data(session);
 	family = ipset_data_family(data);
 
-	if (family == AF_UNSPEC) {
-		family = AF_INET;
+	if (family == NFPROTO_UNSPEC) {
+		family = NFPROTO_IPV4;
 		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
 	}
 
-	return family == AF_INET ? parse_ip(session, opt, str, IPADDR_ANY)
+	return family == NFPROTO_IPV4 ? parse_ip(session, opt, str, IPADDR_ANY)
 				 : ipset_parse_ipnet(session, opt, str);
 
 }
@@ -1330,21 +1330,21 @@ ipset_parse_netmask(struct ipset_session *session,
 
 	data = ipset_session_data(session);
 	family = ipset_data_family(data);
-	if (family == AF_UNSPEC) {
-		family = AF_INET;
+	if (family == NFPROTO_UNSPEC) {
+		family = NFPROTO_IPV4;
 		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
 	}
 
 	err = string_to_cidr(session, str,
-			     family == AF_INET ? 1 : 4,
-			     family == AF_INET ? 31 : 124,
+			     family == NFPROTO_IPV4 ? 1 : 4,
+			     family == NFPROTO_IPV4 ? 31 : 124,
 			     &cidr);
 
 	if (err)
 		return syntax_err("netmask is out of the inclusive range "
 				  "of %u-%u",
-				  family == AF_INET ? 1 : 4,
-				  family == AF_INET ? 31 : 124);
+				  family == NFPROTO_IPV4 ? 1 : 4,
+				  family == NFPROTO_IPV4 ? 31 : 124);
 
 	return ipset_data_set(data, opt, &cidr);
 }
diff --git a/lib/print.c b/lib/print.c
index 6452ab5..d7f99a4 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -152,7 +152,7 @@ __getnameinfo4(char *buf, unsigned int len,
 
 	memset(&saddr, 0, sizeof(saddr));
 	in4cpy(&saddr.sin_addr, &addr->in);
-	saddr.sin_family = AF_INET;
+	saddr.sin_family = NFPROTO_IPV4;
 
 	err = getnameinfo((const struct sockaddr *)&saddr,
 			  sizeof(saddr),
@@ -178,7 +178,7 @@ __getnameinfo6(char *buf, unsigned int len,
 
 	memset(&saddr, 0, sizeof(saddr));
 	in6cpy(&saddr.sin6_addr, &addr->in6);
-	saddr.sin6_family = AF_INET6;
+	saddr.sin6_family = NFPROTO_IPV6;
 
 	err = getnameinfo((const struct sockaddr *)&saddr,
 			  sizeof(saddr),
@@ -253,14 +253,14 @@ ipset_print_ip(char *buf, unsigned int len,
 		cidr = *(const uint8_t *) ipset_data_get(data, cidropt);
 		D("CIDR: %u", cidr);
 	} else
-		cidr = family == AF_INET6 ? 128 : 32;
+		cidr = family == NFPROTO_IPV6 ? 128 : 32;
 	flags = (env & IPSET_ENV_RESOLVE) ? 0 : NI_NUMERICHOST;
 
 	ip = ipset_data_get(data, opt);
 	assert(ip);
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		size = snprintf_ipv4(buf, len, flags, ip, cidr);
-	else if (family == AF_INET6)
+	else if (family == NFPROTO_IPV6)
 		size = snprintf_ipv6(buf, len, flags, ip, cidr);
 	else
 		return -1;
@@ -275,9 +275,9 @@ ipset_print_ip(char *buf, unsigned int len,
 	SNPRINTF_FAILURE(size, len, offset);
 
 	ip = ipset_data_get(data, IPSET_OPT_IP_TO);
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		size = snprintf_ipv4(buf + offset, len, flags, ip, cidr);
-	else if (family == AF_INET6)
+	else if (family == NFPROTO_IPV6)
 		size = snprintf_ipv6(buf + offset, len, flags, ip, cidr);
 	else
 		return -1;
@@ -320,14 +320,14 @@ ipset_print_ipaddr(char *buf, unsigned int len,
 	if (ipset_data_test(data, cidropt))
 		cidr = *(const uint8_t *) ipset_data_get(data, cidropt);
 	else
-		cidr = family == AF_INET6 ? 128 : 32;
+		cidr = family == NFPROTO_IPV6 ? 128 : 32;
 	flags = (env & IPSET_ENV_RESOLVE) ? 0 : NI_NUMERICHOST;
 
 	ip = ipset_data_get(data, opt);
 	assert(ip);
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		return snprintf_ipv4(buf, len, flags, ip, cidr);
-	else if (family == AF_INET6)
+	else if (family == NFPROTO_IPV6)
 		return snprintf_ipv6(buf, len, flags, ip, cidr);
 
 	return -1;
diff --git a/lib/session.c b/lib/session.c
index 9e36efd..472b974 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -568,7 +568,7 @@ attr2data(struct ipset_session *session, struct nlattr *nla[],
 
 		/* Validate by hand */
 		switch (family) {
-		case AF_INET:
+		case NFPROTO_IPV4:
 			atype = IPSET_ATTR_IPADDR_IPV4;
 			if (!ipattr[atype])
 				FAILURE("Broken kernel message: IPv4 address "
@@ -578,7 +578,7 @@ attr2data(struct ipset_session *session, struct nlattr *nla[],
 					"cannot validate IPv4 "
 					"address attribute!");
 			break;
-		case AF_INET6:
+		case NFPROTO_IPV6:
 			atype = IPSET_ATTR_IPADDR_IPV6;
 			if (!ipattr[atype])
 				FAILURE("Broken kernel message: IPv6 address "
@@ -814,8 +814,8 @@ list_adt(struct ipset_session *session, struct nlattr *nla[])
 }
 
 #define FAMILY_TO_STR(f)		\
-	((f) == AF_INET ? "inet" :	\
-	 (f) == AF_INET6 ? "inet6" : "any")
+	((f) == NFPROTO_IPV4 ? "inet" :	\
+	 (f) == NFPROTO_IPV6 ? "inet6" : "any")
 
 static int
 list_create(struct ipset_session *session, struct nlattr *nla[])
@@ -1413,7 +1413,7 @@ attr_len(const struct ipset_attr_policy *attr, uint8_t family, uint16_t *flags)
 			return attr->len;
 
 		*flags = NLA_F_NET_BYTEORDER;
-		return family == AF_INET ? sizeof(uint32_t)
+		return family == NFPROTO_IPV4 ? sizeof(uint32_t)
 					 : sizeof(struct in6_addr);
 	case MNL_TYPE_U32:
 		*flags = NLA_F_NET_BYTEORDER;
@@ -1446,7 +1446,7 @@ rawdata2attr(struct ipset_session *session, struct nlmsghdr *nlh,
 	if (attr->type == MNL_TYPE_NESTED) {
 		/* IP addresses */
 		struct nlattr *nested;
-		int atype = family == AF_INET ? IPSET_ATTR_IPADDR_IPV4
+		int atype = family == NFPROTO_IPV4 ? IPSET_ATTR_IPADDR_IPV4
 					      : IPSET_ATTR_IPADDR_IPV6;
 
 		alen = attr_len(attr, family, &flags);
@@ -1454,8 +1454,8 @@ rawdata2attr(struct ipset_session *session, struct nlmsghdr *nlh,
 				MNL_ATTR_HDRLEN, alen))
 			return 1;
 		nested = mnl_attr_nest_start(nlh, type);
-		D("family: %s", family == AF_INET ? "INET" :
-				family == AF_INET6 ? "INET6" : "UNSPEC");
+		D("family: %s", family == NFPROTO_IPV4 ? "INET" :
+				family == NFPROTO_IPV6 ? "INET6" : "UNSPEC");
 		mnl_attr_put(nlh, atype | flags, alen, d);
 		mnl_attr_nest_end(nlh, nested);
 
@@ -1509,14 +1509,14 @@ data2attr(struct ipset_session *session, struct nlmsghdr *nlh,
 	data2attr(session, nlh, data, type, family, attrs)
 
 #define ADDATTR_SETNAME(session, nlh, data)				\
-	data2attr(session, nlh, data, IPSET_ATTR_SETNAME, AF_INET, cmd_attrs)
+	data2attr(session, nlh, data, IPSET_ATTR_SETNAME, NFPROTO_IPV4, cmd_attrs)
 
 #define ADDATTR_IF(session, nlh, data, type, family, attrs)		\
 	ipset_data_test(data, attrs[type].opt) ?			\
 		data2attr(session, nlh, data, type, family, attrs) : 0
 
 #define ADDATTR_RAW(session, nlh, data, type, attrs)			\
-	rawdata2attr(session, nlh, data, type, AF_INET, attrs)
+	rawdata2attr(session, nlh, data, type, NFPROTO_IPV4, attrs)
 
 static void
 addattr_create(struct ipset_session *session,
@@ -1572,13 +1572,13 @@ build_send_private_msg(struct ipset_session *session, enum ipset_cmd cmd)
 				"Invalid internal TYPE command: "
 				"missing settype");
 		ADDATTR(session, nlh, data, IPSET_ATTR_TYPENAME,
-			AF_INET, cmd_attrs);
+			NFPROTO_IPV4, cmd_attrs);
 		if (ipset_data_test(data, IPSET_OPT_FAMILY))
 			ADDATTR(session, nlh, data, IPSET_ATTR_FAMILY,
-				AF_INET, cmd_attrs);
+				NFPROTO_IPV4, cmd_attrs);
 		else
 			/* bitmap:port and list:set types */
-			mnl_attr_put_u8(nlh, IPSET_ATTR_FAMILY, AF_UNSPEC);
+			mnl_attr_put_u8(nlh, IPSET_ATTR_FAMILY, NFPROTO_UNSPEC);
 		break;
 	default:
 		return ipset_err(session, "Internal error: "
@@ -1638,17 +1638,17 @@ build_msg(struct ipset_session *session, bool aggregate)
 		 * setname, typename, revision, family, flags (optional) */
 		ADDATTR_SETNAME(session, nlh, data);
 		ADDATTR(session, nlh, data, IPSET_ATTR_TYPENAME,
-			AF_INET, cmd_attrs);
+			NFPROTO_IPV4, cmd_attrs);
 		ADDATTR_RAW(session, nlh, &type->revision,
 			    IPSET_ATTR_REVISION, cmd_attrs);
 		D("family: %u, type family %u",
 		  ipset_data_family(data), type->family);
 		if (ipset_data_test(data, IPSET_OPT_FAMILY))
 			ADDATTR(session, nlh, data, IPSET_ATTR_FAMILY,
-				AF_INET, cmd_attrs);
+				NFPROTO_IPV4, cmd_attrs);
 		else
 			/* bitmap:port and list:set types */
-			mnl_attr_put_u8(nlh, IPSET_ATTR_FAMILY, AF_UNSPEC);
+			mnl_attr_put_u8(nlh, IPSET_ATTR_FAMILY, NFPROTO_UNSPEC);
 
 		/* Type-specific create attributes */
 		D("call open_nested");
@@ -1675,7 +1675,7 @@ build_msg(struct ipset_session *session, bool aggregate)
 			ADDATTR_SETNAME(session, nlh, data);
 		if (flags && session->mode != IPSET_LIST_SAVE) {
 			ipset_data_set(data, IPSET_OPT_FLAGS, &flags);
-			ADDATTR(session, nlh, data, IPSET_ATTR_FLAGS, AF_INET,
+			ADDATTR(session, nlh, data, IPSET_ATTR_FLAGS, NFPROTO_IPV4,
 				cmd_attrs);
 		}
 		break;
diff --git a/lib/types.c b/lib/types.c
index 7c16a30..2048568 100644
--- a/lib/types.c
+++ b/lib/types.c
@@ -173,7 +173,7 @@ ipset_cache_swap(const char *from, const char *to)
 }
 
 #define MATCH_FAMILY(type, f)	\
-	(f == AF_UNSPEC || type->family == f || type->family == AF_INET46)
+	(f == NFPROTO_UNSPEC || type->family == f || type->family == NFPROTO_X_IPV46)
 
 bool
 ipset_match_typename(const char *name, const struct ipset_type *type)
@@ -227,8 +227,8 @@ create_type_get(struct ipset_session *session)
 				    typename);
 
 	/* Family is unspecified yet: set from matching set type */
-	if (family == AF_UNSPEC && match->family != AF_UNSPEC) {
-		family = match->family == AF_INET46 ? AF_INET : match->family;
+	if (family == NFPROTO_UNSPEC && match->family != NFPROTO_UNSPEC) {
+		family = match->family == NFPROTO_X_IPV46 ? NFPROTO_IPV4 : match->family;
 		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
 	}
 
@@ -254,8 +254,8 @@ create_type_get(struct ipset_session *session)
 				"with maximal revision %u.\n"
 				"You need to upgrade your ipset program.",
 				typename,
-				family == AF_INET ? "INET" :
-				family == AF_INET6 ? "INET6" : "UNSPEC",
+				family == NFPROTO_IPV4 ? "INET" :
+				family == NFPROTO_IPV6 ? "INET6" : "UNSPEC",
 				kmin, tmax);
 		else
 			return ipset_errptr(session,
@@ -264,8 +264,8 @@ create_type_get(struct ipset_session *session)
 				"with minimal revision %u.\n"
 				"You need to upgrade your kernel.",
 				typename,
-				family == AF_INET ? "INET" :
-				family == AF_INET6 ? "INET6" : "UNSPEC",
+				family == NFPROTO_IPV4 ? "INET" :
+				family == NFPROTO_IPV6 ? "INET6" : "UNSPEC",
 				kmax, tmin);
 	}
 
@@ -290,8 +290,8 @@ found:
 }
 
 #define set_family_and_type(data, match, family) do {		\
-	if (family == AF_UNSPEC && match->family != AF_UNSPEC)	\
-		family = match->family == AF_INET46 ? AF_INET : match->family;\
+	if (family == NFPROTO_UNSPEC && match->family != NFPROTO_UNSPEC)	\
+		family = match->family == NFPROTO_X_IPV46 ? NFPROTO_IPV4 : match->family;\
 	ipset_data_set(data, IPSET_OPT_FAMILY, &family);	\
 	ipset_data_set(data, IPSET_OPT_TYPE, match);		\
 } while (0)
@@ -306,7 +306,7 @@ adt_type_get(struct ipset_session *session)
 	const struct ipset_type *match;
 	const char *setname, *typename;
 	const uint8_t *revision;
-	uint8_t family = AF_UNSPEC;
+	uint8_t family = NFPROTO_UNSPEC;
 	int ret;
 
 	data = ipset_session_data(session);
@@ -352,8 +352,8 @@ adt_type_get(struct ipset_session *session)
 				    "ipset library does not support the "
 				    "settype with that family and revision.",
 				    setname, typename,
-				    family == AF_INET ? "inet" :
-				    family == AF_INET6 ? "inet6" : "unspec",
+				    family == NFPROTO_IPV4 ? "inet" :
+				    family == NFPROTO_IPV6 ? "inet6" : "unspec",
 				    *revision);
 
 	set_family_and_type(data, match, family);
@@ -409,7 +409,7 @@ ipset_type_check(struct ipset_session *session)
 	const struct ipset_type *t, *match = NULL;
 	struct ipset_data *data;
 	const char *typename;
-	uint8_t family = AF_UNSPEC, revision;
+	uint8_t family = NFPROTO_UNSPEC, revision;
 
 	assert(session);
 	data = ipset_session_data(session);
diff --git a/src/ipset.c b/src/ipset.c
index 358befe..d68b446 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -324,9 +324,9 @@ static const char *
 session_family(void)
 {
 	switch (ipset_data_family(ipset_session_data(session))) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		return "inet";
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		return "inet6";
 	default:
 		return "unspec";
@@ -581,10 +581,10 @@ parse_commandline(int argc, char *argv[])
 				       type->name, type->usage);
 				if (type->usagefn)
 					type->usagefn();
-				if (type->family == AF_UNSPEC)
+				if (type->family == NFPROTO_UNSPEC)
 					printf("\nType %s is family neutral.\n",
 					       type->name);
-				else if (type->family == AF_INET46)
+				else if (type->family == NFPROTO_X_IPV46)
 					printf("\nType %s supports INET "
 					       "and INET6.\n",
 					       type->name);
@@ -592,7 +592,7 @@ parse_commandline(int argc, char *argv[])
 					printf("\nType %s supports family "
 					       "%s only.\n",
 					       type->name,
-					       type->family == AF_INET
+					       type->family == NFPROTO_IPV4
 						? "INET" : "INET6");
 			} else {
 				printf("\nSupported set types:\n");
diff --git a/src/ipset_bitmap_ip.c b/src/ipset_bitmap_ip.c
index e73bc7c..890b0dc 100644
--- a/src/ipset_bitmap_ip.c
+++ b/src/ipset_bitmap_ip.c
@@ -60,7 +60,7 @@ struct ipset_type ipset_bitmap_ip0 = {
 	.name = "bitmap:ip",
 	.alias = { "ipmap", NULL },
 	.revision = 0,
-	.family = AF_INET,
+	.family = NFPROTO_IPV4,
 	.dimension = IPSET_DIM_ONE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_bitmap_ipmac.c b/src/ipset_bitmap_ipmac.c
index f47f25d..385f2a8 100644
--- a/src/ipset_bitmap_ipmac.c
+++ b/src/ipset_bitmap_ipmac.c
@@ -57,7 +57,7 @@ struct ipset_type ipset_bitmap_ipmac0 = {
 	.name = "bitmap:ip,mac",
 	.alias = { "macipmap", NULL },
 	.revision = 0,
-	.family = AF_INET,
+	.family = NFPROTO_IPV4,
 	.dimension = IPSET_DIM_TWO,
 	.last_elem_optional = true,
 	.elem = {
diff --git a/src/ipset_bitmap_port.c b/src/ipset_bitmap_port.c
index c8c6e1f..d9b4cd8 100644
--- a/src/ipset_bitmap_port.c
+++ b/src/ipset_bitmap_port.c
@@ -51,7 +51,7 @@ struct ipset_type ipset_bitmap_port0 = {
 	.name = "bitmap:port",
 	.alias = { "portmap", NULL },
 	.revision = 0,
-	.family = AF_UNSPEC,
+	.family = NFPROTO_UNSPEC,
 	.dimension = IPSET_DIM_ONE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_hash_ip.c b/src/ipset_hash_ip.c
index 315804a..88bba80 100644
--- a/src/ipset_hash_ip.c
+++ b/src/ipset_hash_ip.c
@@ -83,7 +83,7 @@ struct ipset_type ipset_hash_ip0 = {
 	.name = "hash:ip",
 	.alias = { "iphash", NULL },
 	.revision = 0,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_ONE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_hash_ipport.c b/src/ipset_hash_ipport.c
index b5bd41b..8fd152c 100644
--- a/src/ipset_hash_ipport.c
+++ b/src/ipset_hash_ipport.c
@@ -89,7 +89,7 @@ struct ipset_type ipset_hash_ipport1 = {
 	.name = "hash:ip,port",
 	.alias = { "ipporthash", NULL },
 	.revision = 1,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_TWO,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_hash_ipportip.c b/src/ipset_hash_ipportip.c
index b27cebf..bf77fbd 100644
--- a/src/ipset_hash_ipportip.c
+++ b/src/ipset_hash_ipportip.c
@@ -89,7 +89,7 @@ struct ipset_type ipset_hash_ipportip1 = {
 	.name = "hash:ip,port,ip",
 	.alias = { "ipportiphash", NULL },
 	.revision = 1,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_THREE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_hash_ipportnet.c b/src/ipset_hash_ipportnet.c
index ecab191..47fd013 100644
--- a/src/ipset_hash_ipportnet.c
+++ b/src/ipset_hash_ipportnet.c
@@ -90,7 +90,7 @@ struct ipset_type ipset_hash_ipportnet1 = {
 	.name = "hash:ip,port,net",
 	.alias = { "ipportnethash", NULL },
 	.revision = 1,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_THREE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
@@ -180,7 +180,7 @@ struct ipset_type ipset_hash_ipportnet2 = {
 	.name = "hash:ip,port,net",
 	.alias = { "ipportnethash", NULL },
 	.revision = 2,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_THREE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_hash_net.c b/src/ipset_hash_net.c
index 665c398..f799987 100644
--- a/src/ipset_hash_net.c
+++ b/src/ipset_hash_net.c
@@ -73,7 +73,7 @@ struct ipset_type ipset_hash_net0 = {
 	.name = "hash:net",
 	.alias = { "nethash", NULL },
 	.revision = 0,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_ONE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
@@ -125,7 +125,7 @@ struct ipset_type ipset_hash_net1 = {
 	.name = "hash:net",
 	.alias = { "nethash", NULL },
 	.revision = 1,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_ONE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_hash_netiface.c b/src/ipset_hash_netiface.c
index 2fbe27d..b31e30d 100644
--- a/src/ipset_hash_netiface.c
+++ b/src/ipset_hash_netiface.c
@@ -66,7 +66,7 @@ struct ipset_type ipset_hash_netiface0 = {
 	.name = "hash:net,iface",
 	.alias = { "netifacehash", NULL },
 	.revision = 0,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_TWO,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_hash_netport.c b/src/ipset_hash_netport.c
index 480dd84..83bd631 100644
--- a/src/ipset_hash_netport.c
+++ b/src/ipset_hash_netport.c
@@ -67,7 +67,7 @@ struct ipset_type ipset_hash_netport1 = {
 	.name = "hash:net,port",
 	.alias = { "netporthash", NULL },
 	.revision = 1,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_TWO,
 	.elem = {
 		[IPSET_DIM_ONE] = {
@@ -141,7 +141,7 @@ struct ipset_type ipset_hash_netport2 = {
 	.name = "hash:net,port",
 	.alias = { "netporthash", NULL },
 	.revision = 2,
-	.family = AF_INET46,
+	.family = NFPROTO_X_IPV46,
 	.dimension = IPSET_DIM_TWO,
 	.elem = {
 		[IPSET_DIM_ONE] = {
diff --git a/src/ipset_list_set.c b/src/ipset_list_set.c
index f3fa6df..8f813d6 100644
--- a/src/ipset_list_set.c
+++ b/src/ipset_list_set.c
@@ -50,7 +50,7 @@ struct ipset_type ipset_list_set0 = {
 	.name = "list:set",
 	.alias = { "setlist", NULL },
 	.revision = 0,
-	.family = AF_UNSPEC,
+	.family = NFPROTO_UNSPEC,
 	.dimension = IPSET_DIM_ONE,
 	.elem = {
 		[IPSET_DIM_ONE] = {
-- 
1.7.3.4

