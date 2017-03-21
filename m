From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 2/4] netfilter: ipset: generalize netmask to support cidr and mask values
Date: Tue, 21 Mar 2017 14:29:02 -0400
Message-ID: <1490120944-1770-3-git-send-email-johunt@akamai.com>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:64137 "EHLO
        prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757413AbdCUSfC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:35:02 -0400
In-Reply-To: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extends ipset netmask support to handle both cidr values and full
netmasks. As part of that it now supports wildcard masks allowing the
user to mask out any bits of an address. This commit provides the
infrastructure to specify netmasks of these types for hash sets of
both v4 and v6 addressees.

Follow on commits will add support for this type of netmasking to various
hash set types.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 include/linux/netfilter/ipset/ip_set.h      |  3 +
 include/uapi/linux/netfilter/ipset/ip_set.h |  5 ++
 net/netfilter/ipset/ip_set_core.c           |  2 +
 net/netfilter/ipset/ip_set_hash_gen.h       | 91 +++++++++++++++++++++++++----
 4 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 8e42253..0153cd3 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -69,6 +69,7 @@ enum ip_set_extension {
 #define SET_WITH_COMMENT(s)	((s)->extensions & IPSET_EXT_COMMENT)
 #define SET_WITH_SKBINFO(s)	((s)->extensions & IPSET_EXT_SKBINFO)
 #define SET_WITH_FORCEADD(s)	((s)->flags & IPSET_CREATE_FLAG_FORCEADD)
+#define SET_WITH_NETMASK(s)	((s)->flags & IPSET_CREATE_FLAG_NETMASK)
 
 /* Extension id, in size order */
 enum ip_set_ext_id {
@@ -292,6 +293,8 @@ struct ip_set {
 		cadt_flags |= IPSET_FLAG_WITH_SKBINFO;
 	if (SET_WITH_FORCEADD(set))
 		cadt_flags |= IPSET_FLAG_WITH_FORCEADD;
+	if (SET_WITH_NETMASK(set))
+		cadt_flags |= IPSET_FLAG_WITH_NETMASK;
 
 	if (!cadt_flags)
 		return 0;
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index ebb5154..2193908 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -84,6 +84,7 @@ enum {
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
 	IPSET_ATTR_MARK,	/* 10 */
 	IPSET_ATTR_MARKMASK,	/* 11 */
+	IPSET_ATTR_NETMASK_MASK,/* 12 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
@@ -200,6 +201,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_BIT_WITH_SKBINFO = 6,
 	IPSET_FLAG_WITH_SKBINFO = (1 << IPSET_FLAG_BIT_WITH_SKBINFO),
+	IPSET_FLAG_BIT_WITH_NETMASK = 7,
+	IPSET_FLAG_WITH_NETMASK = (1 << IPSET_FLAG_BIT_WITH_NETMASK),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
@@ -207,6 +210,8 @@ enum ipset_cadt_flags {
 enum ipset_create_flags {
 	IPSET_CREATE_FLAG_BIT_FORCEADD = 0,
 	IPSET_CREATE_FLAG_FORCEADD = (1 << IPSET_CREATE_FLAG_BIT_FORCEADD),
+	IPSET_CREATE_FLAG_BIT_NETMASK = 1,
+	IPSET_CREATE_FLAG_NETMASK = (1 << IPSET_CREATE_FLAG_BIT_NETMASK),
 	IPSET_CREATE_FLAG_BIT_MAX = 7,
 };
 
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c296f9b..e2ce7ab 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -374,6 +374,8 @@ static inline struct ip_set_net *ip_set_pernet(struct net *net)
 		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
 	if (cadt_flags & IPSET_FLAG_WITH_FORCEADD)
 		set->flags |= IPSET_CREATE_FLAG_FORCEADD;
+	if (cadt_flags & IPSET_FLAG_WITH_NETMASK)
+		set->flags |= IPSET_CREATE_FLAG_NETMASK;
 	if (!align)
 		align = 1;
 	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index f236c0b..a407f85 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -166,6 +166,41 @@ struct net_prefixes {
 #define NLEN			0
 #endif /* IP_SET_HASH_WITH_NETS */
 
+#ifdef IP_SET_HASH_WITH_NETMASK
+const static union nf_inet_addr onesmask = {
+	.all[0] = 0xffffffff,
+	.all[1] = 0xffffffff,
+	.all[2] = 0xffffffff,
+	.all[3] = 0xffffffff
+};
+const static union nf_inet_addr zeromask;
+
+struct ipset_netmask {
+	u8 cidr;
+	union nf_inet_addr mask;
+};
+
+static void
+ip_set_cidr_to_mask(union nf_inet_addr *addr, uint8_t cidr, uint8_t family)
+{
+	uint8_t i;
+	uint8_t addrsize = (family == NFPROTO_IPV4) ? 1 : 4;
+
+	for (i=0; i < addrsize; i++) {
+		if (!cidr) {
+			addr->all[i] = 0;
+		} else if (cidr >= 32) {
+			addr->all[i] = 0xffffffff;
+			cidr -= 32;
+		} else {
+			addr->all[i] = htonl(~((1 << (32 - cidr)) - 1));
+			break;
+		}
+	}
+}
+
+#endif
+
 #endif /* _IP_SET_HASH_GEN_H */
 
 #ifndef MTYPE
@@ -289,7 +324,7 @@ struct htype {
 	u8 ahash_max;		/* max elements in an array block */
 #endif
 #ifdef IP_SET_HASH_WITH_NETMASK
-	u8 netmask;		/* netmask value for subnets to store */
+	struct ipset_netmask netmask;
 #endif
 	struct mtype_elem next; /* temporary storage for uadd */
 #ifdef IP_SET_HASH_WITH_NETS
@@ -449,7 +484,8 @@ struct htype {
 	return x->maxelem == y->maxelem &&
 	       a->timeout == b->timeout &&
 #ifdef IP_SET_HASH_WITH_NETMASK
-	       x->netmask == y->netmask &&
+		nf_inet_addr_cmp(&x->netmask.mask, &y->netmask.mask) &&
+		x->netmask.cidr == y->netmask.cidr &&
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	       x->markmask == y->markmask &&
@@ -1061,9 +1097,20 @@ struct htype {
 	    nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
 		goto nla_put_failure;
 #ifdef IP_SET_HASH_WITH_NETMASK
-	if (h->netmask != HOST_MASK &&
-	    nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
-		goto nla_put_failure;
+	if (!nf_inet_addr_cmp(&onesmask, &h->netmask.mask)) {
+		if (SET_WITH_NETMASK(set)) {
+			if (set->family == NFPROTO_IPV4) {
+				if (nla_put_ipaddr4(skb, IPSET_ATTR_NETMASK_MASK, h->netmask.mask.ip))
+					goto nla_put_failure;
+			} else if (set->family == NFPROTO_IPV6) {
+				if (nla_put_ipaddr6(skb, IPSET_ATTR_NETMASK_MASK, &h->netmask.mask.in6))
+					goto nla_put_failure;
+			}
+		}
+
+		if (nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask.cidr))
+			goto nla_put_failure;
+	}
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	if (nla_put_u32(skb, IPSET_ATTR_MARKMASK, h->markmask))
@@ -1220,7 +1267,9 @@ struct htype {
 #endif
 	u8 hbits;
 #ifdef IP_SET_HASH_WITH_NETMASK
-	u8 netmask;
+	union nf_inet_addr netmask = onesmask;
+	int ret = 0;
+	u8 cidr = 0;
 #endif
 	size_t hsize;
 	struct htype *h;
@@ -1254,15 +1303,32 @@ struct htype {
 #endif
 
 #ifdef IP_SET_HASH_WITH_NETMASK
-	netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
 	if (tb[IPSET_ATTR_NETMASK]) {
-		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
+		cidr = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
+		if ((set->family == NFPROTO_IPV4 && cidr > 32) ||
+		    (set->family == NFPROTO_IPV6 && cidr > 128))
+			return -IPSET_ERR_INVALID_NETMASK;
 
-		if ((set->family == NFPROTO_IPV4 && netmask > 32) ||
-		    (set->family == NFPROTO_IPV6 && netmask > 128) ||
-		    netmask == 0)
+	}
+	if (tb[IPSET_ATTR_NETMASK_MASK]) {
+		if (set->family == NFPROTO_IPV4) {
+			ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_NETMASK_MASK], &netmask.ip);
+			if (ret || !netmask.ip)
+				return -IPSET_ERR_INVALID_NETMASK;
+		} else if (set->family == NFPROTO_IPV6) {
+			ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_NETMASK_MASK], &netmask);
+			if (ret || ipv6_addr_any(&netmask.in6))
+				return -IPSET_ERR_INVALID_NETMASK;
+		}
+		if (nf_inet_addr_cmp(&netmask, &zeromask))
 			return -IPSET_ERR_INVALID_NETMASK;
 	}
+
+	/* For backwards compatibility, we'll convert the cidr to a mask if
+	 * userspace didn't give us one.
+	 */
+	if (cidr && nf_inet_addr_cmp(&netmask, &onesmask))
+		ip_set_cidr_to_mask(&netmask, cidr, set->family);
 #endif
 
 	if (tb[IPSET_ATTR_HASHSIZE]) {
@@ -1292,7 +1358,8 @@ struct htype {
 	}
 	h->maxelem = maxelem;
 #ifdef IP_SET_HASH_WITH_NETMASK
-	h->netmask = netmask;
+	h->netmask.mask = netmask;
+	h->netmask.cidr = cidr;
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	h->markmask = markmask;
-- 
1.9.1

