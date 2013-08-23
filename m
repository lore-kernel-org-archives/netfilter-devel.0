From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH] Add hash:net,net ipset for storage of v4/v6 CIDR pairs.
Date: Fri, 23 Aug 2013 06:15:03 +0200
Message-ID: <1377231303-6926-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1377231303-6926-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:49649 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3HWEZQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:25:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 633EE9F85C
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2013 05:18:58 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ZX2uPJUG7I7W for <netfilter-devel@vger.kernel.org>;
	Fri, 23 Aug 2013 05:17:54 +0100 (BST)
In-Reply-To: <1377231303-6926-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This adds a new set that provides the ability to configure pairs of
subnets.

In order to achieve this, additional handling code has been
added to deal with the fact that both parameters accept an arbitrary
CIDR range. A preprocessor symbol is used to conditionally enable this
extra code.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/Kbuild               |   2 +-
 kernel/net/netfilter/ipset/Kconfig              |   9 +
 kernel/net/netfilter/ipset/ip_set_hash_gen.h    |  73 ++++
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c | 526 ++++++++++++++++++++++++
 lib/Makefile.am                                 |   1 +
 lib/ipset_hash_netnet.c                         | 439 ++++++++++++++++++++
 6 files changed, 1049 insertions(+), 1 deletion(-)
 create mode 100644 kernel/net/netfilter/ipset/ip_set_hash_netnet.c
 create mode 100644 lib/ipset_hash_netnet.c

diff --git a/kernel/net/netfilter/ipset/Kbuild b/kernel/net/netfilter/ipset/Kbuild
index c205ab9..5ec21e2 100644
--- a/kernel/net/netfilter/ipset/Kbuild
+++ b/kernel/net/netfilter/ipset/Kbuild
@@ -6,7 +6,7 @@ obj-m += ip_set.o
 obj-m += ip_set_bitmap_ip.o ip_set_bitmap_ipmac.o ip_set_bitmap_port.o
 obj-m += ip_set_hash_ip.o ip_set_hash_ipport.o ip_set_hash_ipportip.o
 obj-m += ip_set_hash_ipportnet.o
-obj-m += ip_set_hash_net.o ip_set_hash_netport.o ip_set_hash_netiface.o
+obj-m += ip_set_hash_net.o ip_set_hash_netport.o ip_set_hash_netiface.o ip_set_hash_netnet.o
 obj-m += ip_set_list_set.o
 
 # It's for me...
diff --git a/kernel/net/netfilter/ipset/Kconfig b/kernel/net/netfilter/ipset/Kconfig
index ba36c28..46d5873 100644
--- a/kernel/net/netfilter/ipset/Kconfig
+++ b/kernel/net/netfilter/ipset/Kconfig
@@ -99,6 +99,15 @@ config IP_SET_HASH_NET
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_SET_HASH_NETNET
+	tristate "hash:net,net set support"
+	depends on IP_SET
+	help
+	  This option adds the hash:net,net  set type support, by which
+	  one can store IPv4/IPv6 network address/prefix pairs in a set.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_SET_HASH_NETPORT
 	tristate "hash:net,port set support"
 	depends on IP_SET
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index c694079..bb633fd 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -81,6 +81,10 @@ struct htable {
 struct net_prefixes {
 	u8 cidr;		/* the different cidr values in the set */
 	u32 nets;		/* number of elements per cidr */
+#ifdef IP_SET_HASH_WITH_DUONETS
+	u8 cidr2;		/* Secondary net */
+	u32 nets2;		/* number of elements per secondary cidr */
+#endif
 };
 
 /* Compute the hash table size */
@@ -233,6 +237,10 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
 #define mtype_elem		IPSET_TOKEN(MTYPE, _elem)
 #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
 #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
+#ifdef IP_SET_HASH_WITH_DUONETS
+#define mtype_add_cidr2		IPSET_TOKEN(MTYPE, _add_cidr2)
+#define mtype_del_cidr2		IPSET_TOKEN(MTYPE, _del_cidr2)
+#endif
 #define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
 #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
 #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
@@ -338,6 +346,52 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length)
 		h->nets[j].nets = h->nets[j + 1].nets;
 	}
 }
+
+#ifdef IP_SET_HASH_WITH_DUONETS
+static void
+mtype_add_cidr2(struct htype *h, u8 cidr, u8 nets_length)
+{
+	int i, j;
+
+	/* Add in increasing prefix order, so larger cidr first */
+	for (i = 0, j = -1; i < nets_length && h->nets[i].nets2; i++) {
+		if (j != -1)
+			continue;
+		else if (h->nets[i].cidr2 < cidr)
+			j = i;
+		else if (h->nets[i].cidr2 == cidr) {
+			h->nets[i].nets2++;
+			return;
+		}
+	}
+	if (j != -1) {
+		for (; i > j; i--) {
+			h->nets[i].cidr2 = h->nets[i - 1].cidr2;
+			h->nets[i].nets2 = h->nets[i - 1].nets2;
+		}
+	}
+	h->nets[i].cidr2 = cidr;
+	h->nets[i].nets2 = 1;
+}
+
+static void
+mtype_del_cidr2(struct htype *h, u8 cidr, u8 nets_length)
+{
+	u8 i, j;
+
+	for (i = 0; i < nets_length - 1 && h->nets[i].cidr2 != cidr; i++)
+		;
+	h->nets[i].nets2--;
+
+	if (h->nets[i].nets2 != 0)
+		return;
+
+	for (j = i; j < nets_length - 1 && h->nets[j].nets2; j++) {
+		h->nets[j].cidr2 = h->nets[j + 1].cidr2;
+		h->nets[j].nets2 = h->nets[j + 1].nets2;
+	}
+}
+#endif
 #endif
 
 /* Calculate the actual memory size of the set data */
@@ -456,6 +510,10 @@ mtype_expire(struct htype *h, u8 nets_length, size_t dsize)
 #ifdef IP_SET_HASH_WITH_NETS
 				mtype_del_cidr(h, CIDR(data->cidr),
 					       nets_length);
+#ifdef IP_SET_HASH_WITH_DUONETS
+				mtype_del_cidr2(h, CIDR(data->cidr2),
+					        nets_length);
+#endif
 #endif
 				if (j != n->pos - 1)
 					/* Not last one */
@@ -643,6 +701,10 @@ reuse_slot:
 #ifdef IP_SET_HASH_WITH_NETS
 		mtype_del_cidr(h, CIDR(data->cidr), NETS_LENGTH(set->family));
 		mtype_add_cidr(h, CIDR(d->cidr), NETS_LENGTH(set->family));
+#ifdef IP_SET_HASH_WITH_DUONETS
+		mtype_del_cidr2(h, CIDR(data->cidr2), NETS_LENGTH(set->family));
+		mtype_add_cidr2(h, CIDR(d->cidr2), NETS_LENGTH(set->family));
+#endif
 #endif
 	} else {
 		/* Use/create a new slot */
@@ -656,6 +718,9 @@ reuse_slot:
 		data = ahash_data(n, n->pos++, h->dsize);
 #ifdef IP_SET_HASH_WITH_NETS
 		mtype_add_cidr(h, CIDR(d->cidr), NETS_LENGTH(set->family));
+#ifdef IP_SET_HASH_WITH_DUONETS
+		mtype_add_cidr2(h, CIDR(d->cidr2), NETS_LENGTH(set->family));
+#endif
 #endif
 		h->elements++;
 	}
@@ -760,7 +825,11 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 
 	pr_debug("test by nets\n");
 	for (; j < nets_length && h->nets[j].nets && !multi; j++) {
+#ifdef IP_SET_HASH_WITH_DUONETS
+		mtype_data_netmask(d, h->nets[j].cidr, h->nets[j].cidr2);
+#else
 		mtype_data_netmask(d, h->nets[j].cidr);
+#endif
 		key = HKEY(d, h->initval, t->htable_bits);
 		n = hbucket(t, key);
 		for (i = 0; i < n->pos; i++) {
@@ -803,7 +872,11 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
 	 * try all possible network sizes */
+#ifdef IP_SET_HASH_WITH_DUONETS
+	if (CIDR(d->cidr) == SET_HOST_MASK(set->family) && CIDR(d->cidr2) == SET_HOST_MASK(set->family)) {
+#else
 	if (CIDR(d->cidr) == SET_HOST_MASK(set->family)) {
+#endif
 		ret = mtype_test_cidrs(set, d, ext, mext, flags);
 		goto out;
 	}
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
new file mode 100644
index 0000000..f04f0aa
--- /dev/null
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -0,0 +1,526 @@
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2013 Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* Kernel module implementing an IP set type: the hash:net type */
+
+#include <linux/jhash.h>
+#include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/errno.h>
+#include <linux/random.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+#include <net/netlink.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/ipset/pfxlen.h>
+#include <linux/netfilter/ipset/ip_set.h>
+#include <linux/netfilter/ipset/ip_set_hash.h>
+
+#define IPSET_TYPE_REV_MIN	0
+/*				1    Range as input support for IPv4 added */
+/*				2    nomatch flag support added */
+#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
+IP_SET_MODULE_DESC("hash:net,net", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
+MODULE_ALIAS("ip_set_hash:net,net");
+
+/* Type specific function prefix */
+#define HTYPE		hash_netnet
+#define IP_SET_HASH_WITH_NETS
+#define IP_SET_HASH_WITH_DUONETS
+
+/* IPv4 variants */
+
+/* Member elements  */
+struct hash_netnet4_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+};
+
+struct hash_netnet4t_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	unsigned long timeout;
+};
+
+struct hash_netnet4c_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_counter counter;
+};
+
+struct hash_netnet4ct_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	u8 padding0;
+	struct ip_set_counter counter;
+	unsigned long timeout;
+};
+
+/* Common functions */
+
+static inline bool
+hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
+		     const struct hash_netnet4_elem *ip2,
+		     u32 *multi)
+{
+	return ip1->ip == ip2->ip &&
+	       ip1->ip2 == ip2->ip2 &&
+	       ip1->cidr == ip2->cidr &&
+	       ip2->cidr2 == ip2->cidr2;
+}
+
+static inline int
+hash_netnet4_do_data_match(const struct hash_netnet4_elem *elem)
+{
+	return elem->nomatch ? -ENOTEMPTY : 1;
+}
+
+static inline void
+hash_netnet4_data_set_flags(struct hash_netnet4_elem *elem, u32 flags)
+{
+	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
+}
+
+static inline void
+hash_netnet4_data_reset_flags(struct hash_netnet4_elem *elem, u8 *flags)
+{
+	swap(*flags, elem->nomatch);
+}
+
+static inline void
+hash_netnet4_data_netmask(struct hash_netnet4_elem *elem, u8 cidr, u8 cidr2)
+{
+	elem->ip &= ip_set_netmask(cidr);
+	elem->ip2 &= ip_set_netmask(cidr2);
+	elem->cidr = cidr;
+	elem->cidr2 = cidr2;
+}
+
+static bool
+hash_netnet4_data_list(struct sk_buff *skb, const struct hash_netnet4_elem *data)
+{
+	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
+
+	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
+	    nla_put_ipaddr4(skb, IPSET_ATTR_IP2, data->ip2) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr2) ||
+	    (flags &&
+	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return 1;
+}
+
+static inline void
+hash_netnet4_data_next(struct hash_netnet4_elem *next,
+		    const struct hash_netnet4_elem *d)
+{
+	next->ip = d->ip;
+	next->ip2 = d->ip2;
+}
+
+#define MTYPE		hash_netnet4
+#define PF		4
+#define HOST_MASK	32
+#include "ip_set_hash_gen.h"
+
+static int
+hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
+	       const struct xt_action_param *par,
+	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
+{
+	const struct hash_netnet *h = set->data;
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_netnet4_elem e = {
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK,
+		.cidr2 = h->nets[0].cidr2 ? h->nets[0].cidr2 : HOST_MASK
+	};
+	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
+
+	if (adt == IPSET_TEST)
+		e.cidr = e.cidr2 = HOST_MASK;
+
+	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	ip4addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip2);
+	e.ip &= ip_set_netmask(e.cidr);
+	e.ip2 &= ip_set_netmask(e.cidr2);
+
+	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+}
+
+static int
+hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
+	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+{
+	const struct hash_netnet *h = set->data;
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_netnet4_elem e = { .cidr = HOST_MASK, .cidr2 = HOST_MASK };
+	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
+	u32 ip = 0, ip_to = 0, last;
+	u32 ip2 = 0, ip2_to = 0, last2;
+	u8 cidr, cidr2;
+	int ret;
+
+	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
+		return -IPSET_ERR_PROTOCOL;
+
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
+	      ip_set_get_extensions(set, tb, &ext);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2], &ip2);
+	if (ret)
+		return ret;
+
+	if (tb[IPSET_ATTR_CIDR]) {
+		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (!cidr || cidr > HOST_MASK)
+			return -IPSET_ERR_INVALID_CIDR;
+		e.cidr = cidr;
+	}
+
+	if(tb[IPSET_ATTR_CIDR2]) {
+		cidr2 = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
+		if (!cidr2 || cidr2 > HOST_MASK)
+			return -IPSET_ERR_INVALID_CIDR;
+		e.cidr2 = cidr2;
+	}
+
+	if (tb[IPSET_ATTR_CADT_FLAGS]) {
+		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+		if (cadt_flags & IPSET_FLAG_NOMATCH)
+			flags |= (IPSET_FLAG_NOMATCH << 16);
+	}
+
+	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] && tb[IPSET_ATTR_IP2_TO])) {
+		printk(KERN_INFO "UADT ipset test");
+		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
+		e.ip2 = htonl(ip2 & ip_set_hostmask(e.cidr2));
+		ret = adtfn(set, &e, &ext, &ext, flags);
+		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
+		       ip_set_eexist(ret, flags) ? 0 : ret;
+	}
+
+	ip_to = ip;
+	if (tb[IPSET_ATTR_IP_TO]) {
+		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
+		if (ret)
+			return ret;
+		if (ip_to < ip)
+			swap(ip, ip_to);
+		if (ip + UINT_MAX == ip_to)
+			return -IPSET_ERR_HASH_RANGE;
+	}
+
+	ip2_to = ip2;
+	if (tb[IPSET_ATTR_IP2_TO]) {
+		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
+		if (ret)
+			return ret;
+		if (ip2_to < ip2)
+			swap(ip2, ip2_to);
+		if (ip2 + UINT_MAX == ip2_to)
+			return -IPSET_ERR_HASH_RANGE;
+
+	}
+
+	if (retried)
+		ip = ntohl(h->next.ip);
+	while (!after(ip, ip_to)) {
+		e.ip = htonl(ip);
+		last = ip_set_range_to_cidr(ip, ip_to, &cidr);
+		e.cidr = cidr;
+
+		while(!after(ip2, ip2_to)) {
+			e.ip2 = htonl(ip2);
+			last2 = ip_set_range_to_cidr(ip2, ip2_to, &cidr2);
+			e.cidr2 = cidr2;
+			ret = adtfn(set, &e, &ext, &ext, flags);
+			if (ret && !ip_set_eexist(ret, flags))
+				return ret;
+			else
+				ret = 0;
+			ip2 = last2 + 1;
+		}
+		ip = last + 1;
+	}
+	return ret;
+}
+
+/* IPv6 variants */
+
+struct hash_netnet6_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+};
+
+struct hash_netnet6t_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	unsigned long timeout;
+};
+
+struct hash_netnet6c_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_counter counter;
+};
+
+struct hash_netnet6ct_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_counter counter;
+	unsigned long timeout;
+};
+
+/* Common functions */
+
+static inline bool
+hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
+		     const struct hash_netnet6_elem *ip2,
+		     u32 *multi)
+{
+	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
+	       ipv6_addr_equal(&ip1->ip2.in6, &ip2->ip2.in6) &&
+	       ip1->cidr == ip2->cidr &&
+	       ip1->cidr2 == ip2->cidr2;
+}
+
+static inline int
+hash_netnet6_do_data_match(const struct hash_netnet6_elem *elem)
+{
+	return elem->nomatch ? -ENOTEMPTY : 1;
+}
+
+static inline void
+hash_netnet6_data_set_flags(struct hash_netnet6_elem *elem, u32 flags)
+{
+	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
+}
+
+static inline void
+hash_netnet6_data_reset_flags(struct hash_netnet6_elem *elem, u8 *flags)
+{
+	swap(*flags, elem->nomatch);
+}
+
+static inline void
+hash_netnet6_data_netmask(struct hash_netnet6_elem *elem, u8 cidr, u8 cidr2)
+{
+	ip6_netmask(&elem->ip, cidr);
+	ip6_netmask(&elem->ip2, cidr2);
+	elem->cidr = cidr;
+	elem->cidr2 = cidr2;
+}
+
+static bool
+hash_netnet6_data_list(struct sk_buff *skb, const struct hash_netnet6_elem *data)
+{
+	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
+
+	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
+	    nla_put_ipaddr6(skb, IPSET_ATTR_IP2, &data->ip2.in6) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr2) ||
+	    (flags &&
+	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return 1;
+}
+
+static inline void
+hash_netnet6_data_next(struct hash_netnet4_elem *next,
+		    const struct hash_netnet6_elem *d)
+{
+}
+
+#undef MTYPE
+#undef PF
+#undef HOST_MASK
+
+#define MTYPE		hash_netnet6
+#define PF		6
+#define HOST_MASK	128
+#define IP_SET_EMIT_CREATE
+#include "ip_set_hash_gen.h"
+
+static int
+hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
+	       const struct xt_action_param *par,
+	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
+{
+	const struct hash_netnet *h = set->data;
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_netnet6_elem e = {
+		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK,
+		.cidr2 = h->nets[0].cidr2 ? h->nets[0].cidr2 : HOST_MASK
+	};
+	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
+
+	if (adt == IPSET_TEST)
+		e.cidr = e.cidr2 = HOST_MASK;
+
+	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	ip6addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip2.in6);
+	ip6_netmask(&e.ip, e.cidr);
+	ip6_netmask(&e.ip2, e.cidr2);
+
+	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+}
+
+static int
+hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
+	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
+{
+	const struct hash_netnet *h = set->data;
+	ipset_adtfn adtfn = set->variant->adt[adt];
+	struct hash_netnet6_elem e = { .cidr = HOST_MASK, .cidr2 = HOST_MASK };
+	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
+	int ret;
+
+	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
+		return -IPSET_ERR_PROTOCOL;
+	if (unlikely(tb[IPSET_ATTR_IP_TO]))
+		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
+
+	if (tb[IPSET_ATTR_LINENO])
+		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
+
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
+	      ip_set_get_extensions(set, tb, &ext);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip2);
+	if (ret)
+		return ret;
+
+	if (tb[IPSET_ATTR_CIDR])
+		e.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+
+	if(tb[IPSET_ATTR_CIDR2])
+		e.cidr2 = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
+
+	if (!e.cidr || e.cidr > HOST_MASK || !e.cidr2 || e.cidr2 > HOST_MASK)
+		return -IPSET_ERR_INVALID_CIDR;
+
+	ip6_netmask(&e.ip, e.cidr);
+	ip6_netmask(&e.ip2, e.cidr2);
+
+	if (tb[IPSET_ATTR_CADT_FLAGS]) {
+		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+		if (cadt_flags & IPSET_FLAG_NOMATCH)
+			flags |= (IPSET_FLAG_NOMATCH << 16);
+	}
+
+	ret = adtfn(set, &e, &ext, &ext, flags);
+
+	return ip_set_enomatch(ret, flags, adt, set) ? -ret :
+	       ip_set_eexist(ret, flags) ? 0 : ret;
+}
+
+static struct ip_set_type hash_netnet_type __read_mostly = {
+	.name		= "hash:net,net",
+	.protocol	= IPSET_PROTOCOL,
+	.features	= IPSET_TYPE_IP | IPSET_TYPE_IP2 | IPSET_TYPE_NOMATCH,
+	.dimension	= IPSET_DIM_TWO,
+	.family		= NFPROTO_UNSPEC,
+	.revision_min	= IPSET_TYPE_REV_MIN,
+	.revision_max	= IPSET_TYPE_REV_MAX,
+	.create		= hash_netnet_create,
+	.create_policy	= {
+		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
+		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
+		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
+		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
+		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+	},
+	.adt_policy	= {
+		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
+		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
+		[IPSET_ATTR_IP2]	= { .type = NLA_NESTED },
+		[IPSET_ATTR_IP2_TO]	= { .type = NLA_NESTED },
+		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
+		[IPSET_ATTR_CIDR2]	= { .type = NLA_U8 },
+		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
+		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+	},
+	.me		= THIS_MODULE,
+};
+
+static int __init
+hash_netnet_init(void)
+{
+	return ip_set_type_register(&hash_netnet_type);
+}
+
+static void __exit
+hash_netnet_fini(void)
+{
+	ip_set_type_unregister(&hash_netnet_type);
+}
+
+module_init(hash_netnet_init);
+module_exit(hash_netnet_fini);
diff --git a/lib/Makefile.am b/lib/Makefile.am
index ccc02aa..32fc820 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -9,6 +9,7 @@ IPSET_SETTYPE_LIST = \
 	ipset_hash_ipportip.c \
 	ipset_hash_ipportnet.c \
 	ipset_hash_net.c \
+	ipset_hash_netnet.c \
 	ipset_hash_netport.c \
 	ipset_hash_netiface.c \
 	ipset_list_set.c
diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
new file mode 100644
index 0000000..1fb3f14
--- /dev/null
+++ b/lib/ipset_hash_netnet.c
@@ -0,0 +1,439 @@
+/* Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
+ * Copyright 2013 Oliver Smith (oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <libipset/data.h>			/* IPSET_OPT_* */
+#include <libipset/parse.h>			/* parser functions */
+#include <libipset/print.h>			/* printing functions */
+#include <libipset/types.h>			/* prototypes */
+
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netnet_create_args0[] = {
+	{ .name = { "family", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,		.print = ipset_print_family,
+	},
+	/* Alias: family inet */
+	{ .name = { "-4", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	/* Alias: family inet6 */
+	{ .name = { "-6", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	{ .name = { "hashsize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "maxelem", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MAXELEM,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	/* Ignored options: backward compatibilty */
+	{ .name = { "probes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "resize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_netnet_add_args0[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ },
+};
+
+static const char hash_netnet_usage0[] =
+"create SETNAME hash:net,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE]\n"
+"add    SETNAME IP[/CIDR] IP[/CIDR] [timeout VALUE]\n"
+"del    SETNAME IP[/CIDR] IP[/CIDR]\n"
+"test   SETNAME IP[/CIDR] IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n";
+
+static struct ipset_type ipset_hash_netnet0 = {
+	.name = "hash:net,net",
+	.alias = { "netnethash", NULL },
+	.revision = 0,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ipnet,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ipnet,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netnet_create_args0,
+		[IPSET_ADD] = hash_netnet_add_args0,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2),
+	},
+
+	.usage = hash_netnet_usage0,
+	.description = "Initial revision",
+};
+
+static const char hash_netnet_usage1[] =
+"create SETNAME hash:net,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO [timeout VALUE]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO\n"
+"test   SETNAME IP[/CIDR] IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      IP range is not supported with IPv6.\n";
+
+static struct ipset_type ipset_hash_netnet1 = {
+	.name = "hash:net,net",
+	.alias = { "netnethash", NULL },
+	.revision = 1,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netnet_create_args0,
+		[IPSET_ADD] = hash_netnet_add_args0,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2),
+	},
+
+	.usage = hash_netnet_usage1,
+	.description = "Add/del range support",
+};
+
+static const struct ipset_arg hash_netnet_add_args2[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const char hash_netnet_usage2[] =
+"create SETNAME hash:net,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO [timeout VALUE] [nomatch]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO\n"
+"test   SETNAME IP[/CIDR] IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      IP range is not supported with IPv6.\n";
+
+static struct ipset_type ipset_hash_netnet2 = {
+	.name = "hash:net,net",
+	.alias = { "netnethash", NULL },
+	.revision = 2,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netnet_create_args0,
+		[IPSET_ADD] = hash_netnet_add_args2,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2),
+	},
+
+	.usage = hash_netnet_usage2,
+	.description = "nomatch flag support",
+};
+
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netnet_create_args3[] = {
+	{ .name = { "family", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,		.print = ipset_print_family,
+	},
+	/* Alias: family inet */
+	{ .name = { "-4", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	/* Alias: family inet6 */
+	{ .name = { "-6", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	{ .name = { "hashsize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "maxelem", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MAXELEM,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "counters", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	/* Ignored options: backward compatibilty */
+	{ .name = { "probes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "resize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_netnet_add_args3[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "packets", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PACKETS,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ .name = { "bytes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_netnet_test_args3[] = {
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const char hash_netnet_usage3[] =
+"create SETNAME hash:net,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO\n"
+"test   SETNAME IP[/CIDR] IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      IP range is not supported with IPv6.\n";
+
+static struct ipset_type ipset_hash_netnet3 = {
+	.name = "hash:net,net",
+	.alias = { "netnethash", NULL },
+	.revision = 3,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netnet_create_args3,
+		[IPSET_ADD] = hash_netnet_add_args3,
+		[IPSET_TEST] = hash_netnet_test_args3,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netnet_usage3,
+	.description = "counters support",
+};
+
+void _init(void);
+void _init(void)
+{
+	ipset_type_add(&ipset_hash_netnet0);
+	ipset_type_add(&ipset_hash_netnet1);
+	ipset_type_add(&ipset_hash_netnet2);
+	ipset_type_add(&ipset_hash_netnet3);
+}
-- 
1.8.2.1

