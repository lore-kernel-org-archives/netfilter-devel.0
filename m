From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 4/4] netfilter: ipset: hash:ipport: add netmask support
Date: Tue, 21 Mar 2017 14:29:04 -0400
Message-ID: <1490120944-1770-5-git-send-email-johunt@akamai.com>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41406 "EHLO
        prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757508AbdCUSfC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:35:02 -0400
In-Reply-To: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Initial netmask support for hash:ipport set types.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 net/netfilter/ipset/ip_set_hash_ipport.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index f438740..39244c0 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -29,7 +29,8 @@
 /*				2    Counters support added */
 /*				3    Comments support added */
 /*				4    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	5 /* skbinfo support added */
+/*				5    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	6 /* netmask support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -38,6 +39,7 @@
 
 /* Type specific function prefix */
 #define HTYPE		hash_ipport
+#define IP_SET_HASH_WITH_NETMASK
 
 /* IPv4 variant */
 
@@ -95,12 +97,16 @@ struct hash_ipport4_elem {
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	const struct hash_ipport4 *h = set->data;
 
 	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	e.ip &= h->netmask.mask.ip;
+	if (e.ip == 0)
+		return -EINVAL;
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -132,6 +138,10 @@ struct hash_ipport4_elem {
 	if (ret)
 		return ret;
 
+	e.ip &= h->netmask.mask.ip;
+	if (e.ip == 0)
+		return -EINVAL;
+
 	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -237,6 +247,12 @@ struct hash_ipport6_elem {
 	next->port = d->port;
 }
 
+static inline void
+hash_ipport6_netmask(union nf_inet_addr *ip, const union nf_inet_addr *mask)
+{
+	nf_inet_addr_mask_inplace(ip, mask);
+}
+
 #undef MTYPE
 #undef HOST_MASK
 
@@ -253,12 +269,17 @@ struct hash_ipport6_elem {
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport6_elem e = { .ip = { .all = { 0 } } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	const struct hash_ipport6 *h = set->data;
 
 	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	hash_ipport6_netmask(&e.ip, &h->netmask.mask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -298,6 +319,10 @@ struct hash_ipport6_elem {
 	if (ret)
 		return ret;
 
+	hash_ipport6_netmask(&e.ip, &h->netmask.mask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -354,6 +379,8 @@ struct hash_ipport6_elem {
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_NETMASK]    = { .type = NLA_U8 },
+		[IPSET_ATTR_NETMASK_MASK] = { .type = NLA_NESTED },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
-- 
1.9.1

