From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH] netfilter: ipset: refactor hash types to use address/cidr arrays.
Date: Tue,  3 Sep 2013 15:12:54 +0200
Message-ID: <1378213974-21425-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:33180 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3ICNNK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:13:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 91561A2E06
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2013 14:13:06 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id qsrRVnvikYZT for <netfilter-devel@vger.kernel.org>;
	Tue,  3 Sep 2013 14:12:55 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

We now use an array in the structs for hash types so that they can be
arbitrarily expanded to situate as many ip/cidr values as required.

The primary purpose of this change is in preparation for the
hash:net,net ipset type, it otherwise carries no change in
functionality. As an aside, small comparison optimisations could
additionally be made in the future by making a union from the compared
types that encompasses them (such as bundling together cidr values).

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       |  91 ++++++++++---------
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c | 100 ++++++++++-----------
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |  78 ++++++++--------
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  88 +++++++++---------
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  74 +++++++--------
 5 files changed, 219 insertions(+), 212 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index cb6bba2..c16f119 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -37,6 +37,10 @@
 /* Max number of elements to store in an array block */
 #define AHASH_MAX_SIZE			(3*AHASH_INIT_SIZE)
 
+#ifndef IPSET_NET_COUNT
+#define IPSET_NET_COUNT		1
+#endif
+
 /* Max number of elements can be tuned */
 #ifdef IP_SET_HASH_WITH_MULTI
 #define AHASH_MAX(h)			((h)->ahash_max)
@@ -79,8 +83,8 @@ struct htable {
 
 /* Book-keeping of the prefixes added to the set */
 struct net_prefixes {
-	u8 cidr;		/* the different cidr values in the set */
-	u32 nets;		/* number of elements per cidr */
+	u8 cidr[IPSET_NET_COUNT];	/* cidr values in the set */
+	u32 nets[IPSET_NET_COUNT];	/* number of elements per cidr */
 };
 
 /* Compute the hash table size */
@@ -296,46 +300,48 @@ struct htype {
 /* Network cidr size book keeping when the hash stores different
  * sized networks */
 static void
-mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length)
+mtype_add_cidr(struct htype *h, const u8 cidr[], u8 nets_length)
 {
-	int i, j;
-
-	/* Add in increasing prefix order, so larger cidr first */
-	for (i = 0, j = -1; i < nets_length && h->nets[i].nets; i++) {
-		if (j != -1)
-			continue;
-		else if (h->nets[i].cidr < cidr)
-			j = i;
-		else if (h->nets[i].cidr == cidr) {
-			h->nets[i].nets++;
-			return;
+	u8 i, j, x;
+	for (x = 0; x < IPSET_NET_COUNT; x++) {
+		/* Add in increasing prefix order, so larger cidr first */
+		for (i = 0, j = -1; i < nets_length && h->nets[i].nets[x]; i++) {
+			if (j != -1)
+				continue;
+			else if (h->nets[i].cidr[x] < CIDR(cidr[x]))
+				j = i;
+			else if (h->nets[i].cidr[x] == CIDR(cidr[x])) {
+				h->nets[i].nets[x]++;
+				return;
+			}
 		}
-	}
-	if (j != -1) {
-		for (; i > j; i--) {
-			h->nets[i].cidr = h->nets[i - 1].cidr;
-			h->nets[i].nets = h->nets[i - 1].nets;
+		if (j != -1) {
+			for (; i > j; i--) {
+				h->nets[i].cidr[x] = h->nets[i - 1].cidr[x];
+				h->nets[i].nets[x] = h->nets[i - 1].nets[x];
+			}
 		}
+		h->nets[i].cidr[x] = CIDR(cidr[x]);
+		h->nets[i].nets[x] = 1;
 	}
-	h->nets[i].cidr = cidr;
-	h->nets[i].nets = 1;
 }
 
 static void
-mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length)
+mtype_del_cidr(struct htype *h, const u8 cidr[], u8 nets_length)
 {
-	u8 i, j;
-
-	for (i = 0; i < nets_length - 1 && h->nets[i].cidr != cidr; i++)
-		;
-	h->nets[i].nets--;
+	u8 i, j, x;
+	for (x = 0; x < IPSET_NET_COUNT; x++) {
+		for (i = 0; i < nets_length - 1 && h->nets[i].cidr[x] != CIDR(cidr[x]); i++)
+			;
+		h->nets[i].nets[x]--;
 
-	if (h->nets[i].nets != 0)
-		return;
+		if (h->nets[i].nets[x] != 0)
+			return;
 
-	for (j = i; j < nets_length - 1 && h->nets[j].nets; j++) {
-		h->nets[j].cidr = h->nets[j + 1].cidr;
-		h->nets[j].nets = h->nets[j + 1].nets;
+		for (j = i; j < nets_length - 1 && h->nets[j].nets[x]; j++) {
+			h->nets[j].cidr[x] = h->nets[j + 1].cidr[x];
+			h->nets[j].nets[x] = h->nets[j + 1].nets[x];
+		}
 	}
 }
 #endif
@@ -454,8 +460,7 @@ mtype_expire(struct htype *h, u8 nets_length, size_t dsize)
 			if (ip_set_timeout_expired(ext_timeout(data, h))) {
 				pr_debug("expired %u/%u\n", i, j);
 #ifdef IP_SET_HASH_WITH_NETS
-				mtype_del_cidr(h, CIDR(data->cidr),
-					       nets_length);
+				mtype_del_cidr(h, data->cidr, nets_length);
 #endif
 				if (j != n->pos - 1)
 					/* Not last one */
@@ -641,8 +646,8 @@ reuse_slot:
 		/* Fill out reused slot */
 		data = ahash_data(n, j, h->dsize);
 #ifdef IP_SET_HASH_WITH_NETS
-		mtype_del_cidr(h, CIDR(data->cidr), NETS_LENGTH(set->family));
-		mtype_add_cidr(h, CIDR(d->cidr), NETS_LENGTH(set->family));
+		mtype_del_cidr(h, data->cidr, NETS_LENGTH(set->family));
+		mtype_add_cidr(h, d->cidr, NETS_LENGTH(set->family));
 #endif
 	} else {
 		/* Use/create a new slot */
@@ -655,7 +660,7 @@ reuse_slot:
 		}
 		data = ahash_data(n, n->pos++, h->dsize);
 #ifdef IP_SET_HASH_WITH_NETS
-		mtype_add_cidr(h, CIDR(d->cidr), NETS_LENGTH(set->family));
+		mtype_add_cidr(h, d->cidr, NETS_LENGTH(set->family));
 #endif
 		h->elements++;
 	}
@@ -707,7 +712,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		n->pos--;
 		h->elements--;
 #ifdef IP_SET_HASH_WITH_NETS
-		mtype_del_cidr(h, CIDR(d->cidr), NETS_LENGTH(set->family));
+		mtype_del_cidr(h, d->cidr, NETS_LENGTH(set->family));
 #endif
 		if (n->pos + AHASH_INIT_SIZE < n->size) {
 			void *tmp = kzalloc((n->size - AHASH_INIT_SIZE)
@@ -759,8 +764,8 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	u8 nets_length = NETS_LENGTH(set->family);
 
 	pr_debug("test by nets\n");
-	for (; j < nets_length && h->nets[j].nets && !multi; j++) {
-		mtype_data_netmask(d, h->nets[j].cidr);
+	for (; j < nets_length && h->nets[j].nets[0] && !multi; j++) {
+		mtype_data_netmask(d, h->nets[j].cidr[0]);
 		key = HKEY(d, h->initval, t->htable_bits);
 		n = hbucket(t, key);
 		for (i = 0; i < n->pos; i++) {
@@ -803,7 +808,11 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
 	 * try all possible network sizes */
-	if (CIDR(d->cidr) == SET_HOST_MASK(set->family)) {
+	for (i = 0; i < IPSET_NET_COUNT; i++) {
+		if (CIDR(d->cidr[i]) != SET_HOST_MASK(set->family))
+			break;
+	}
+	if (i == IPSET_NET_COUNT) {
 		ret = mtype_test_cidrs(set, d, ext, mext, flags);
 		goto out;
 	}
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 02ed91e..69e014f 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -50,10 +50,9 @@ MODULE_ALIAS("ip_set_hash:ip,port,net");
 
 /* Member elements */
 struct hash_ipportnet4_elem {
-	__be32 ip;
-	__be32 ip2;
+	__be32 ip[2];
 	__be16 port;
-	u8 cidr:7;
+	u8 cidr[1];
 	u8 nomatch:1;
 	u8 proto;
 } __attribute__((aligned(sizeof(void*))));
@@ -65,9 +64,9 @@ hash_ipportnet4_data_equal(const struct hash_ipportnet4_elem *ip1,
 			   const struct hash_ipportnet4_elem *ip2,
 			   u32 *multi)
 {
-	return ip1->ip == ip2->ip &&
-	       ip1->ip2 == ip2->ip2 &&
-	       ip1->cidr == ip2->cidr &&
+	return ip1->ip[0] == ip2->ip[0] &&
+	       ip1->ip[1] == ip2->ip[1] &&
+	       ip1->cidr[0] == ip2->cidr[0] &&
 	       ip1->port == ip2->port &&
 	       ip1->proto == ip2->proto;
 }
@@ -93,8 +92,8 @@ hash_ipportnet4_data_reset_flags(struct hash_ipportnet4_elem *elem, u8 *flags)
 static inline void
 hash_ipportnet4_data_netmask(struct hash_ipportnet4_elem *elem, u8 cidr)
 {
-	elem->ip2 &= ip_set_netmask(cidr);
-	elem->cidr = cidr - 1;
+	elem->ip[0] &= ip_set_netmask(cidr);
+	elem->cidr[0] = cidr - 1;
 }
 
 static bool
@@ -103,10 +102,10 @@ hash_ipportnet4_data_list(struct sk_buff *skb,
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
-	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
-	    nla_put_ipaddr4(skb, IPSET_ATTR_IP2, data->ip2) ||
+	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip[0]) ||
+	    nla_put_ipaddr4(skb, IPSET_ATTR_IP2, data->ip[1]) ||
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr + 1) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr[0] + 1) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
@@ -121,9 +120,9 @@ static inline void
 hash_ipportnet4_data_next(struct hash_ipportnet4_elem *next,
 			  const struct hash_ipportnet4_elem *d)
 {
-	next->ip = d->ip;
+	next->ip[0] = d->ip[0];
 	next->port = d->port;
-	next->ip2 = d->ip2;
+	next->ip[1] = d->ip[1];
 }
 
 #define MTYPE		hash_ipportnet4
@@ -139,20 +138,20 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_ipportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr - 1 : HOST_MASK - 1
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] - 1 : HOST_MASK - 1
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK - 1;
+		e.cidr[0] = HOST_MASK - 1;
 
 	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
-	e.ip2 &= ip_set_netmask(e.cidr + 1);
+	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
+	ip4addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip[1]);
+	e.ip[1] &= ip_set_netmask(e.cidr[0] + 1);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -163,7 +162,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	const struct hash_ipportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_ipportnet4_elem e = { .cidr = HOST_MASK - 1 };
+	struct hash_ipportnet4_elem e = { .cidr[0] = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
 	u32 ip2_from = 0, ip2_to = 0, ip2_last, ip2;
@@ -196,7 +195,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
 		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
-		e.cidr = cidr - 1;
+		e.cidr[0] = cidr - 1;
 	}
 
 	if (tb[IPSET_ATTR_PORT])
@@ -226,8 +225,8 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (adt == IPSET_TEST ||
 	    !(tb[IPSET_ATTR_CIDR] || tb[IPSET_ATTR_IP_TO] || with_ports ||
 	      tb[IPSET_ATTR_IP2_TO])) {
-		e.ip = htonl(ip);
-		e.ip2 = htonl(ip2_from & ip_set_hostmask(e.cidr + 1));
+		e.ip[0] = htonl(ip);
+		e.ip[1] = htonl(ip2_from & ip_set_hostmask(e.cidr[0] + 1));
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
@@ -265,25 +264,25 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip2_from + UINT_MAX == ip2_to)
 			return -IPSET_ERR_HASH_RANGE;
 	} else
-		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr + 1);
+		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[0] + 1);
 
 	if (retried)
-		ip = ntohl(h->next.ip);
+		ip = ntohl(h->next.ip[0]);
 	for (; !before(ip_to, ip); ip++) {
-		e.ip = htonl(ip);
-		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
+		e.ip[0] = htonl(ip);
+		p = retried && ip == ntohl(h->next.ip[0]) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			ip2 = retried
-			      && ip == ntohl(h->next.ip)
+			      && ip == ntohl(h->next.ip[0])
 			      && p == ntohs(h->next.port)
-				? ntohl(h->next.ip2) : ip2_from;
+				? ntohl(h->next.ip[1]) : ip2_from;
 			while (!after(ip2, ip2_to)) {
-				e.ip2 = htonl(ip2);
+				e.ip[1] = htonl(ip2);
 				ip2_last = ip_set_range_to_cidr(ip2, ip2_to,
 								&cidr);
-				e.cidr = cidr - 1;
+				e.cidr[0] = cidr - 1;
 				ret = adtfn(set, &e, &ext, &ext, flags);
 
 				if (ret && !ip_set_eexist(ret, flags))
@@ -300,10 +299,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 /* IPv6 variants */
 
 struct hash_ipportnet6_elem {
-	union nf_inet_addr ip;
-	union nf_inet_addr ip2;
+	union nf_inet_addr ip[2];
 	__be16 port;
-	u8 cidr:7;
+	u8 cidr[1];
 	u8 nomatch:1;
 	u8 proto;
 } __attribute__((aligned(sizeof(void*))));
@@ -315,9 +313,9 @@ hash_ipportnet6_data_equal(const struct hash_ipportnet6_elem *ip1,
 			   const struct hash_ipportnet6_elem *ip2,
 			   u32 *multi)
 {
-	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
-	       ipv6_addr_equal(&ip1->ip2.in6, &ip2->ip2.in6) &&
-	       ip1->cidr == ip2->cidr &&
+	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
+	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
+	       ip1->cidr[0] == ip2->cidr[0] &&
 	       ip1->port == ip2->port &&
 	       ip1->proto == ip2->proto;
 }
@@ -343,8 +341,8 @@ hash_ipportnet6_data_reset_flags(struct hash_ipportnet6_elem *elem, u8 *flags)
 static inline void
 hash_ipportnet6_data_netmask(struct hash_ipportnet6_elem *elem, u8 cidr)
 {
-	ip6_netmask(&elem->ip2, cidr);
-	elem->cidr = cidr - 1;
+	ip6_netmask(&elem->ip[1], cidr);
+	elem->cidr[0] = cidr - 1;
 }
 
 static bool
@@ -353,10 +351,10 @@ hash_ipportnet6_data_list(struct sk_buff *skb,
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
-	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
-	    nla_put_ipaddr6(skb, IPSET_ATTR_IP2, &data->ip2.in6) ||
+	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip[0].in6) ||
+	    nla_put_ipaddr6(skb, IPSET_ATTR_IP2, &data->ip[1].in6) ||
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr + 1) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr[0] + 1) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
@@ -392,20 +390,20 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_ipportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet6_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr - 1 : HOST_MASK - 1
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] - 1 : HOST_MASK - 1
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK - 1;
+		e.cidr[0] = HOST_MASK - 1;
 
 	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2.in6);
-	ip6_netmask(&e.ip2, e.cidr + 1);
+	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0].in6);
+	ip6addrptr(skb, opt->flags & IPSET_DIM_THREE_SRC, &e.ip[1].in6);
+	ip6_netmask(&e.ip[1], e.cidr[0] + 1);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -416,7 +414,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	const struct hash_ipportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_ipportnet6_elem e = { .cidr = HOST_MASK - 1 };
+	struct hash_ipportnet6_elem e = { .cidr[0] = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	u32 port, port_to;
 	bool with_ports = false;
@@ -439,12 +437,12 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]) ||
 	      ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip2);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip[1]);
 	if (ret)
 		return ret;
 
@@ -452,10 +450,10 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
 		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
-		e.cidr = cidr - 1;
+		e.cidr[0] = cidr - 1;
 	}
 
-	ip6_netmask(&e.ip2, e.cidr + 1);
+	ip6_netmask(&e.ip[1], e.cidr[0] + 1);
 
 	if (tb[IPSET_ATTR_PORT])
 		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index 3d2ea5d..adbbca5 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -40,10 +40,10 @@ MODULE_ALIAS("ip_set_hash:net");
 
 /* Member elements  */
 struct hash_net4_elem {
-	__be32 ip;
+	__be32 ip[1];
 	u16 padding0;
 	u8 nomatch;
-	u8 cidr;
+	u8 cidr[1];
 } __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
@@ -53,8 +53,8 @@ hash_net4_data_equal(const struct hash_net4_elem *ip1,
 		     const struct hash_net4_elem *ip2,
 		     u32 *multi)
 {
-	return ip1->ip == ip2->ip &&
-	       ip1->cidr == ip2->cidr;
+	return ip1->ip[0] == ip2->ip[0] &&
+	       ip1->cidr[0] == ip2->cidr[0];
 }
 
 static inline int
@@ -78,8 +78,8 @@ hash_net4_data_reset_flags(struct hash_net4_elem *elem, u8 *flags)
 static inline void
 hash_net4_data_netmask(struct hash_net4_elem *elem, u8 cidr)
 {
-	elem->ip &= ip_set_netmask(cidr);
-	elem->cidr = cidr;
+	elem->ip[0] &= ip_set_netmask(cidr);
+	elem->cidr[0] = cidr;
 }
 
 static bool
@@ -87,8 +87,8 @@ hash_net4_data_list(struct sk_buff *skb, const struct hash_net4_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
-	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
+	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip[0]) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0]) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
@@ -102,7 +102,7 @@ static inline void
 hash_net4_data_next(struct hash_net4_elem *next,
 		    const struct hash_net4_elem *d)
 {
-	next->ip = d->ip;
+	next->ip[0] = d->ip[0];
 }
 
 #define MTYPE		hash_net4
@@ -118,17 +118,17 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_net *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 
-	if (e.cidr == 0)
+	if (e.cidr[0] == 0)
 		return -EINVAL;
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK;
+		e.cidr[0] = HOST_MASK;
 
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	e.ip &= ip_set_netmask(e.cidr);
+	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
+	e.ip[0] &= ip_set_netmask(e.cidr[0]);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -139,7 +139,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	const struct hash_net *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_net4_elem e = { .cidr = HOST_MASK };
+	struct hash_net4_elem e = { .cidr[0] = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	u32 ip = 0, ip_to = 0, last;
 	int ret;
@@ -160,8 +160,8 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	if (tb[IPSET_ATTR_CIDR]) {
-		e.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
-		if (!e.cidr || e.cidr > HOST_MASK)
+		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (!e.cidr[0] || e.cidr[0] > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
@@ -172,7 +172,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	}
 
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
-		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
+		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0]));
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		return ip_set_enomatch(ret, flags, adt, set) ? -ret:
 		       ip_set_eexist(ret, flags) ? 0 : ret;
@@ -189,10 +189,10 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_HASH_RANGE;
 	}
 	if (retried)
-		ip = ntohl(h->next.ip);
+		ip = ntohl(h->next.ip[0]);
 	while (!after(ip, ip_to)) {
-		e.ip = htonl(ip);
-		last = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
+		e.ip[0] = htonl(ip);
+		last = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
@@ -206,10 +206,10 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 /* IPv6 variants */
 
 struct hash_net6_elem {
-	union nf_inet_addr ip;
+	union nf_inet_addr ip[1];
 	u16 padding0;
 	u8 nomatch;
-	u8 cidr;
+	u8 cidr[1];
 } __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
@@ -219,8 +219,8 @@ hash_net6_data_equal(const struct hash_net6_elem *ip1,
 		     const struct hash_net6_elem *ip2,
 		     u32 *multi)
 {
-	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
-	       ip1->cidr == ip2->cidr;
+	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
+	       ip1->cidr[0] == ip2->cidr[0];
 }
 
 static inline int
@@ -244,8 +244,8 @@ hash_net6_data_reset_flags(struct hash_net6_elem *elem, u8 *flags)
 static inline void
 hash_net6_data_netmask(struct hash_net6_elem *elem, u8 cidr)
 {
-	ip6_netmask(&elem->ip, cidr);
-	elem->cidr = cidr;
+	ip6_netmask(&elem->ip[0], cidr);
+	elem->cidr[0] = cidr;
 }
 
 static bool
@@ -253,8 +253,8 @@ hash_net6_data_list(struct sk_buff *skb, const struct hash_net6_elem *data)
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
-	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
+	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip[0].in6) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0]) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
@@ -288,17 +288,17 @@ hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_net *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net6_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 
-	if (e.cidr == 0)
+	if (e.cidr[0] == 0)
 		return -EINVAL;
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK;
+		e.cidr[0] = HOST_MASK;
 
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6_netmask(&e.ip, e.cidr);
+	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0].in6);
+	ip6_netmask(&e.ip[0], e.cidr[0]);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -309,7 +309,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	const struct hash_net *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_net6_elem e = { .cidr = HOST_MASK };
+	struct hash_net6_elem e = { .cidr[0] = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	int ret;
 
@@ -325,18 +325,18 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]) ||
 	      ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
 	if (tb[IPSET_ATTR_CIDR])
-		e.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
-	if (!e.cidr || e.cidr > HOST_MASK)
+	if (!e.cidr[0] || e.cidr[0] > HOST_MASK)
 		return -IPSET_ERR_INVALID_CIDR;
 
-	ip6_netmask(&e.ip, e.cidr);
+	ip6_netmask(&e.ip[0], e.cidr[0]);
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 06cc27b..d41fba1 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -137,17 +137,17 @@ iface_add(struct rb_root *root, const char **iface)
 /* IPv4 variants */
 
 struct hash_netiface4_elem_hashed {
-	__be32 ip;
+	__be32 ip[1];
 	u8 physdev;
-	u8 cidr;
+	u8 cidr[1];
 	u8 nomatch;
 	u8 elem;
 };
 
 struct hash_netiface4_elem {
-	__be32 ip;
+	__be32 ip[1];
 	u8 physdev;
-	u8 cidr;
+	u8 cidr[1];
 	u8 nomatch;
 	u8 elem;
 	const char *iface;
@@ -160,8 +160,8 @@ hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
 			  const struct hash_netiface4_elem *ip2,
 			  u32 *multi)
 {
-	return ip1->ip == ip2->ip &&
-	       ip1->cidr == ip2->cidr &&
+	return ip1->ip[0] == ip2->ip[0] &&
+	       ip1->cidr[0] == ip2->cidr[0] &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
 	       ip1->iface == ip2->iface;
@@ -188,8 +188,8 @@ hash_netiface4_data_reset_flags(struct hash_netiface4_elem *elem, u8 *flags)
 static inline void
 hash_netiface4_data_netmask(struct hash_netiface4_elem *elem, u8 cidr)
 {
-	elem->ip &= ip_set_netmask(cidr);
-	elem->cidr = cidr;
+	elem->ip[0] &= ip_set_netmask(cidr);
+	elem->cidr[0] = cidr;
 }
 
 static bool
@@ -200,8 +200,8 @@ hash_netiface4_data_list(struct sk_buff *skb,
 
 	if (data->nomatch)
 		flags |= IPSET_FLAG_NOMATCH;
-	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
+	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip[0]) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0]) ||
 	    nla_put_string(skb, IPSET_ATTR_IFACE, data->iface) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
@@ -216,7 +216,7 @@ static inline void
 hash_netiface4_data_next(struct hash_netiface4_elem *next,
 			 const struct hash_netiface4_elem *d)
 {
-	next->ip = d->ip;
+	next->ip[0] = d->ip[0];
 }
 
 #define MTYPE		hash_netiface4
@@ -233,19 +233,19 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netiface *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK,
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK,
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 	int ret;
 
-	if (e.cidr == 0)
+	if (e.cidr[0] == 0)
 		return -EINVAL;
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK;
+		e.cidr[0] = HOST_MASK;
 
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	e.ip &= ip_set_netmask(e.cidr);
+	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
+	e.ip[0] &= ip_set_netmask(e.cidr[0]);
 
 #define IFACE(dir)	(par->dir ? par->dir->name : NULL)
 #define PHYSDEV(dir)	(nf_bridge->dir ? nf_bridge->dir->name : NULL)
@@ -286,7 +286,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	struct hash_netiface *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
+	struct hash_netiface4_elem e = { .cidr[0] = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	u32 ip = 0, ip_to = 0, last;
 	char iface[IFNAMSIZ];
@@ -309,8 +309,8 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	if (tb[IPSET_ATTR_CIDR]) {
-		e.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
-		if (e.cidr > HOST_MASK)
+		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (e.cidr[0] > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
@@ -334,7 +334,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 			flags |= (IPSET_FLAG_NOMATCH << 16);
 	}
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
-		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
+		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0]));
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
@@ -349,13 +349,13 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	} else
-		ip_set_mask_from_to(ip, ip_to, e.cidr);
+		ip_set_mask_from_to(ip, ip_to, e.cidr[0]);
 
 	if (retried)
-		ip = ntohl(h->next.ip);
+		ip = ntohl(h->next.ip[0]);
 	while (!after(ip, ip_to)) {
-		e.ip = htonl(ip);
-		last = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
+		e.ip[0] = htonl(ip);
+		last = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
 		if (ret && !ip_set_eexist(ret, flags))
@@ -370,17 +370,17 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 /* IPv6 variants */
 
 struct hash_netiface6_elem_hashed {
-	union nf_inet_addr ip;
+	union nf_inet_addr ip[1];
 	u8 physdev;
-	u8 cidr;
+	u8 cidr[1];
 	u8 nomatch;
 	u8 elem;
 };
 
 struct hash_netiface6_elem {
-	union nf_inet_addr ip;
+	union nf_inet_addr ip[1];
 	u8 physdev;
-	u8 cidr;
+	u8 cidr[1];
 	u8 nomatch;
 	u8 elem;
 	const char *iface;
@@ -393,8 +393,8 @@ hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
 			  const struct hash_netiface6_elem *ip2,
 			  u32 *multi)
 {
-	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
-	       ip1->cidr == ip2->cidr &&
+	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
+	       ip1->cidr[0] == ip2->cidr[0] &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
 	       ip1->iface == ip2->iface;
@@ -421,8 +421,8 @@ hash_netiface6_data_reset_flags(struct hash_netiface6_elem *elem, u8 *flags)
 static inline void
 hash_netiface6_data_netmask(struct hash_netiface6_elem *elem, u8 cidr)
 {
-	ip6_netmask(&elem->ip, cidr);
-	elem->cidr = cidr;
+	ip6_netmask(&elem->ip[0], cidr);
+	elem->cidr[0] = cidr;
 }
 
 static bool
@@ -433,8 +433,8 @@ hash_netiface6_data_list(struct sk_buff *skb,
 
 	if (data->nomatch)
 		flags |= IPSET_FLAG_NOMATCH;
-	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
+	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip[0].in6) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0]) ||
 	    nla_put_string(skb, IPSET_ATTR_IFACE, data->iface) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
@@ -471,19 +471,19 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netiface *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface6_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK,
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK,
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 	int ret;
 
-	if (e.cidr == 0)
+	if (e.cidr[0] == 0)
 		return -EINVAL;
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK;
+		e.cidr[0] = HOST_MASK;
 
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6_netmask(&e.ip, e.cidr);
+	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0].in6);
+	ip6_netmask(&e.ip[0], e.cidr[0]);
 
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #ifdef CONFIG_BRIDGE_NETFILTER
@@ -520,7 +520,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	struct hash_netiface *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netiface6_elem e = { .cidr = HOST_MASK, .elem = 1 };
+	struct hash_netiface6_elem e = { .cidr[0] = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	char iface[IFNAMSIZ];
 	int ret;
@@ -538,16 +538,16 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]) ||
 	      ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
 	if (tb[IPSET_ATTR_CIDR])
-		e.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
-	if (e.cidr > HOST_MASK)
+		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+	if (e.cidr[0] > HOST_MASK)
 		return -IPSET_ERR_INVALID_CIDR;
-	ip6_netmask(&e.ip, e.cidr);
+	ip6_netmask(&e.ip[0], e.cidr[0]);
 
 	strcpy(iface, nla_data(tb[IPSET_ATTR_IFACE]));
 	e.iface = iface;
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index 570e6b5..cc8a330 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -49,10 +49,10 @@ MODULE_ALIAS("ip_set_hash:net,port");
 
 /* Member elements */
 struct hash_netport4_elem {
-	__be32 ip;
+	__be32 ip[1];
 	__be16 port;
 	u8 proto;
-	u8 cidr:7;
+	u8 cidr[1];
 	u8 nomatch:1;
 } __attribute__((aligned(sizeof(void*))));
 
@@ -63,10 +63,10 @@ hash_netport4_data_equal(const struct hash_netport4_elem *ip1,
 			 const struct hash_netport4_elem *ip2,
 			 u32 *multi)
 {
-	return ip1->ip == ip2->ip &&
+	return ip1->ip[0] == ip2->ip[0] &&
 	       ip1->port == ip2->port &&
 	       ip1->proto == ip2->proto &&
-	       ip1->cidr == ip2->cidr;
+	       ip1->cidr[0] == ip2->cidr[0];
 }
 
 static inline int
@@ -90,8 +90,8 @@ hash_netport4_data_reset_flags(struct hash_netport4_elem *elem, u8 *flags)
 static inline void
 hash_netport4_data_netmask(struct hash_netport4_elem *elem, u8 cidr)
 {
-	elem->ip &= ip_set_netmask(cidr);
-	elem->cidr = cidr - 1;
+	elem->ip[0] &= ip_set_netmask(cidr);
+	elem->cidr[0] = cidr - 1;
 }
 
 static bool
@@ -100,9 +100,9 @@ hash_netport4_data_list(struct sk_buff *skb,
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
-	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
+	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip[0]) ||
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr + 1) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0] + 1) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
@@ -117,7 +117,7 @@ static inline void
 hash_netport4_data_next(struct hash_netport4_elem *next,
 			const struct hash_netport4_elem *d)
 {
-	next->ip = d->ip;
+	next->ip[0] = d->ip[0];
 	next->port = d->port;
 }
 
@@ -134,19 +134,19 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_netport *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr - 1 : HOST_MASK - 1
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] - 1 : HOST_MASK - 1
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK - 1;
+		e.cidr[0] = HOST_MASK - 1;
 
 	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
-	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
-	e.ip &= ip_set_netmask(e.cidr + 1);
+	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
+	e.ip[0] &= ip_set_netmask(e.cidr[0] + 1);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -157,7 +157,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	const struct hash_netport *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
+	struct hash_netport4_elem e = { .cidr[0] = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	u32 port, port_to, p = 0, ip = 0, ip_to = 0, last;
 	bool with_ports = false;
@@ -185,7 +185,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
-		e.cidr = cidr - 1;
+		e.cidr[0] = cidr - 1;
 	}
 
 	if (tb[IPSET_ATTR_PORT])
@@ -214,7 +214,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	}
 
 	if (adt == IPSET_TEST || !(with_ports || tb[IPSET_ATTR_IP_TO])) {
-		e.ip = htonl(ip & ip_set_hostmask(e.cidr + 1));
+		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0] + 1));
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
@@ -235,15 +235,15 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	} else
-		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
+		ip_set_mask_from_to(ip, ip_to, e.cidr[0] + 1);
 
 	if (retried)
-		ip = ntohl(h->next.ip);
+		ip = ntohl(h->next.ip[0]);
 	while (!after(ip, ip_to)) {
-		e.ip = htonl(ip);
+		e.ip[0] = htonl(ip);
 		last = ip_set_range_to_cidr(ip, ip_to, &cidr);
-		e.cidr = cidr - 1;
-		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
+		e.cidr[0] = cidr - 1;
+		p = retried && ip == ntohl(h->next.ip[0]) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
@@ -262,10 +262,10 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 /* IPv6 variants */
 
 struct hash_netport6_elem {
-	union nf_inet_addr ip;
+	union nf_inet_addr ip[1];
 	__be16 port;
 	u8 proto;
-	u8 cidr:7;
+	u8 cidr[1];
 	u8 nomatch:1;
 } __attribute__((aligned(sizeof(void*))));
 
@@ -276,10 +276,10 @@ hash_netport6_data_equal(const struct hash_netport6_elem *ip1,
 			 const struct hash_netport6_elem *ip2,
 			 u32 *multi)
 {
-	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
+	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ip1->port == ip2->port &&
 	       ip1->proto == ip2->proto &&
-	       ip1->cidr == ip2->cidr;
+	       ip1->cidr[0] == ip2->cidr[0];
 }
 
 static inline int
@@ -303,8 +303,8 @@ hash_netport6_data_reset_flags(struct hash_netport6_elem *elem, u8 *flags)
 static inline void
 hash_netport6_data_netmask(struct hash_netport6_elem *elem, u8 cidr)
 {
-	ip6_netmask(&elem->ip, cidr);
-	elem->cidr = cidr - 1;
+	ip6_netmask(&elem->ip[0], cidr);
+	elem->cidr[0] = cidr - 1;
 }
 
 static bool
@@ -313,9 +313,9 @@ hash_netport6_data_list(struct sk_buff *skb,
 {
 	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
 
-	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
+	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip[0].in6) ||
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
-	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr + 1) ||
+	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0] + 1) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto) ||
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
@@ -351,19 +351,19 @@ hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	const struct hash_netport *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport6_elem e = {
-		.cidr = h->nets[0].cidr ? h->nets[0].cidr - 1 : HOST_MASK - 1,
+		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] - 1 : HOST_MASK - 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
 
 	if (adt == IPSET_TEST)
-		e.cidr = HOST_MASK - 1;
+		e.cidr[0] = HOST_MASK - 1;
 
 	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
-	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	ip6_netmask(&e.ip, e.cidr + 1);
+	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0].in6);
+	ip6_netmask(&e.ip[0], e.cidr[0] + 1);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -374,7 +374,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	const struct hash_netport *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netport6_elem e = { .cidr = HOST_MASK  - 1 };
+	struct hash_netport6_elem e = { .cidr[0] = HOST_MASK  - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
 	u32 port, port_to;
 	bool with_ports = false;
@@ -395,7 +395,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]) ||
 	      ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
@@ -404,9 +404,9 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 		if (!cidr || cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
-		e.cidr = cidr - 1;
+		e.cidr[0] = cidr - 1;
 	}
-	ip6_netmask(&e.ip, e.cidr + 1);
+	ip6_netmask(&e.ip[0], e.cidr[0] + 1);
 
 	if (tb[IPSET_ATTR_PORT])
 		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-- 
1.8.3.2


